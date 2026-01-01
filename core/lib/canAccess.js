'use strict';

function mapPermissionCode(resource, action) {
  return `${resource}.${action}`;
}

async function resolveScope(pg, userId, resource, action) {
  const permissionCode = mapPermissionCode(resource, action);

  const { rows: direct } = await pg.query(
    `SELECT rp.scope
     FROM core.user_roles ur
     JOIN core.role_permissions rp ON rp.role_id = ur.role_id
     JOIN core.permissions p ON p.id = rp.permission_id
     WHERE ur.user_id = $1 AND p.code = $2
     LIMIT 1`,
    [userId, permissionCode]
  );
  if (direct.length) return direct[0].scope;

  const { rows: groupRows } = await pg.query(
    `SELECT rp.scope
     FROM core.user_groups ug
     JOIN core.group_roles gr ON gr.group_id = ug.group_id
     JOIN core.role_permissions rp ON rp.role_id = gr.role_id
     JOIN core.permissions p ON p.id = rp.permission_id
     WHERE ug.user_id = $1 AND p.code = $2
     LIMIT 1`,
    [userId, permissionCode]
  );
  if (groupRows.length) return groupRows[0].scope;

  return 'none';
}

async function isInDepartment(pg, userId, departmentId) {
  if (!departmentId) return false;
  const { rows } = await pg.query(
    `WITH RECURSIVE dept_tree AS (
        SELECT d.id, d.parent_id
        FROM core.departments d
        WHERE d.id = $1
      UNION ALL
        SELECT d2.id, d2.parent_id
        FROM core.departments d2
        JOIN dept_tree dt ON dt.parent_id = d2.id
    )
    SELECT 1
    FROM core.department_users du
    JOIN dept_tree dt ON dt.id = du.department_id
    WHERE du.user_id = $2
    LIMIT 1`,
    [departmentId, userId]
  );
  return rows.length > 0;
}

async function getPolicies(pg, userId, resource, action) {
  const { rows: groupIds } = await pg.query(
    `SELECT group_id FROM core.user_groups WHERE user_id = $1`,
    [userId]
  );

  const groupIdList = groupIds.map(r => r.group_id);
  const values = [userId, resource, action];
  const conditions = [
    `(subject_type = 'user' AND subject_id = $1)`,
    `(subject_type = 'role' AND subject_id IN (
        SELECT role_id FROM core.user_roles WHERE user_id = $1
      ))`
  ];

  if (groupIdList.length) {
    conditions.push(`(subject_type = 'group' AND subject_id = ANY($4::uuid[]))`);
    values.push(groupIdList);
  }

  const query = `
    SELECT id, effect, conditions, enabled
    FROM core.access_policies
    WHERE resource = $2 AND action = $3
      AND (${conditions.join(' OR ')})
    ORDER BY priority ASC, created_at ASC`;

  const { rows } = await pg.query(query, values);
  return rows;
}

function matches(conditions, entity) {
  if (!conditions || Object.keys(conditions).length === 0) return true;
  if (!entity) return false;
  return Object.entries(conditions).every(([key, value]) => {
    if (value === null || typeof value !== 'object') {
      return entity[key] === value;
    }
    if (value.in && Array.isArray(value.in)) {
      return value.in.includes(entity[key]);
    }
    return entity[key] === value;
  });
}

async function canAccess(pg, user, resource, action, entity = null) {
  const scope = await resolveScope(pg, user.id, resource, action);
  if (scope === 'none') return false;

  if (entity) {
    if (scope === 'own' && entity.owner_id !== user.id) return false;
    if (scope === 'department' && !(await isInDepartment(pg, user.id, entity.department_id))) {
      return false;
    }
  }

  const policies = await getPolicies(pg, user.id, resource, action);

  for (const policy of policies) {
    if (!policy.enabled) continue;
    if (matches(policy.conditions, entity)) {
      if (policy.effect === 'deny') return false;
      if (policy.effect === 'allow') return true;
    }
  }

  return true;
}

module.exports = {
  canAccess,
  mapPermissionCode,
  resolveScope,
  isInDepartment,
  getPolicies
};

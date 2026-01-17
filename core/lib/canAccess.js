export function mapPermissionCode(resource, action) {
  return `${resource}.${action}`;
}

const SUPER_ADMIN_ROLE = 'super_admin';

function hasRole(user, roleCode) {
  return Array.isArray(user?.roles) && user.roles.includes(roleCode);
}

function normalizeObjectType(resource) {
  if (!resource) return null;
  if (resource === 'orders') return 'order';
  if (resource === 'clients') return 'client';
  if (resource === 'managers') return 'manager';
  if (resource === 'groups') return 'group';
  return resource;
}

export async function resolveScope(pg, userId, resource, action) {
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

async function resolveEffectiveGroups(pg, userId) {
  const { rows } = await pg.query(
    `WITH RECURSIVE direct_groups AS (
        SELECT group_id::text AS id
        FROM core.user_groups
        WHERE user_id = $1
      UNION
        SELECT object_id
        FROM core.authz_tuples
        WHERE object_type = 'group'
          AND relation = 'member'
          AND subject_type = 'user'
          AND subject_id = $2
      ),
      group_tree AS (
        SELECT id FROM direct_groups
        UNION
        SELECT t.subject_id
        FROM core.authz_tuples t
        JOIN group_tree gt
          ON t.object_type = 'group'
         AND t.relation = 'parent'
         AND t.subject_type = 'group'
         AND t.object_id = gt.id
      )
      SELECT id FROM group_tree`,
    [userId, String(userId)]
  );
  return rows.map(row => row.id);
}

function relationsForAction(action) {
  if (['view', 'read'].includes(action)) {
    return ['viewer', 'editor'];
  }
  if (['edit', 'write', 'manage'].includes(action)) {
    return ['editor'];
  }
  return [];
}

async function hasTupleAccess(pg, userId, action, entity, resource) {
  if (!entity) return false;
  const relations = relationsForAction(action);
  if (!relations.length) return false;

  const objectType = entity.object_type || entity.objectType || normalizeObjectType(resource);
  const objectId = entity.object_id || entity.objectId || entity.id;
  if (!objectType || !objectId) return false;

  const effectiveGroups = await resolveEffectiveGroups(pg, userId);
  const groupArray = effectiveGroups.length ? effectiveGroups : null;

  const { rows } = await pg.query(
    `SELECT 1
     FROM core.authz_tuples t
     WHERE t.object_type = $1
       AND t.object_id = $2
       AND t.relation = ANY($3::text[])
       AND (
         (t.subject_type = 'user' AND t.subject_id = $4)
         OR ($5::text[] IS NOT NULL AND t.subject_type = 'group' AND t.subject_id = ANY($5::text[]))
       )
     LIMIT 1`,
    [objectType, String(objectId), relations, String(userId), groupArray]
  );
  if (rows.length) return true;

  if (resource === 'orders' || resource === 'order') {
    const managerId = entity.manager_id || entity.managerId;
    if (managerId) {
      const managerRelation = action === 'edit' || action === 'write' ? 'orders_editor' : 'orders_viewer';
      const { rows: managerRows } = await pg.query(
        `SELECT 1
         FROM core.authz_tuples t
         WHERE t.object_type = 'manager'
           AND t.object_id = $1
           AND t.relation = $2
           AND (
             (t.subject_type = 'user' AND t.subject_id = $3)
             OR ($4::text[] IS NOT NULL AND t.subject_type = 'group' AND t.subject_id = ANY($4::text[]))
           )
         LIMIT 1`,
        [String(managerId), managerRelation, String(userId), groupArray]
      );
      if (managerRows.length) return true;
    }

    const clientId = entity.client_id || entity.clientId;
    if (clientId) {
      const { rows: clientRows } = await pg.query(
        `SELECT 1
         FROM core.authz_tuples t
         WHERE t.object_type = 'client'
           AND t.object_id = $1
           AND t.relation = ANY($2::text[])
           AND (
             (t.subject_type = 'user' AND t.subject_id = $3)
             OR ($4::text[] IS NOT NULL AND t.subject_type = 'group' AND t.subject_id = ANY($4::text[]))
           )
         LIMIT 1`,
        [String(clientId), relations, String(userId), groupArray]
      );
      if (clientRows.length) return true;
    }
  }

  return false;
}

function hasAbacAccess(user, action, entity, resource) {
  if (!entity) return false;
  if (!hasRole(user, 'manager')) return false;
  const isSupportedResource = ['orders', 'order', 'clients', 'client'].includes(resource);
  if (!isSupportedResource) return false;
  if (!['view', 'read', 'edit', 'write'].includes(action)) return false;
  return entity.manager_id === user.id || entity.managerId === user.id;
}

export async function isInDepartment(pg, userId, departmentId) {
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

export async function getPolicies(pg, userId, resource, action) {
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

export async function canAccess(pg, user, resource, action, entity = null) {
  if (hasRole(user, SUPER_ADMIN_ROLE)) return true;

  const scope = await resolveScope(pg, user.id, resource, action);
  let rbacAllowed = scope !== 'none';

  if (rbacAllowed && entity) {
    if (scope === 'own' && entity.owner_id !== user.id) rbacAllowed = false;
    if (scope === 'department' && !(await isInDepartment(pg, user.id, entity.department_id))) {
      rbacAllowed = false;
    }
  }

  const abacAllowed = hasAbacAccess(user, action, entity, resource);
  const aclAllowed = await hasTupleAccess(pg, user.id, action, entity, resource);
  const allowed = rbacAllowed || abacAllowed || aclAllowed;
  if (!allowed) return false;

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

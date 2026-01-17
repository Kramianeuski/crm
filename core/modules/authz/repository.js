export async function upsertGrant(pg, grant) {
  const {
    object_type,
    object_id,
    relation,
    subject_type,
    subject_id,
    created_by
  } = grant;

  const { rows } = await pg.query(
    `INSERT INTO core.authz_tuples (
        object_type,
        object_id,
        relation,
        subject_type,
        subject_id,
        created_by
      )
     VALUES ($1, $2, $3, $4, $5, $6)
     ON CONFLICT (object_type, object_id, relation, subject_type, subject_id)
     DO NOTHING
     RETURNING id`,
    [object_type, object_id, relation, subject_type, subject_id, created_by || null]
  );

  if (rows.length) return rows[0].id;

  const { rows: existing } = await pg.query(
    `SELECT id
     FROM core.authz_tuples
     WHERE object_type = $1
       AND object_id = $2
       AND relation = $3
       AND subject_type = $4
       AND subject_id = $5
     LIMIT 1`,
    [object_type, object_id, relation, subject_type, subject_id]
  );

  return existing[0]?.id || null;
}

export async function deleteGrantById(pg, id) {
  const { rowCount } = await pg.query(
    `DELETE FROM core.authz_tuples WHERE id = $1`,
    [id]
  );
  return rowCount > 0;
}

export async function deleteGrantByTuple(pg, grant) {
  const {
    object_type,
    object_id,
    relation,
    subject_type,
    subject_id
  } = grant;

  const { rowCount } = await pg.query(
    `DELETE FROM core.authz_tuples
     WHERE object_type = $1
       AND object_id = $2
       AND relation = $3
       AND subject_type = $4
       AND subject_id = $5`,
    [object_type, object_id, relation, subject_type, subject_id]
  );
  return rowCount > 0;
}

export async function listGrantsByObject(pg, object_type, object_id) {
  const { rows } = await pg.query(
    `SELECT id,
            object_type,
            object_id,
            relation,
            subject_type,
            subject_id,
            created_by,
            created_at
     FROM core.authz_tuples
     WHERE object_type = $1
       AND object_id = $2
     ORDER BY created_at DESC`,
    [object_type, object_id]
  );
  return rows;
}

export async function listEffectiveAccess(pg, userId) {
  const { rows: roles } = await pg.query(
    `SELECT r.id, r.code, r.name_key
     FROM core.user_roles ur
     JOIN core.roles r ON r.id = ur.role_id
     WHERE ur.user_id = $1`,
    [userId]
  );

  const { rows: permissions } = await pg.query(
    `SELECT DISTINCT p.code
     FROM core.user_roles ur
     JOIN core.role_permissions rp ON rp.role_id = ur.role_id
     JOIN core.permissions p ON p.id = rp.permission_id
     WHERE ur.user_id = $1`,
    [userId]
  );

  const { rows: groupRows } = await pg.query(
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

  const groupIds = groupRows.map(row => row.id);

  const { rows: tuples } = await pg.query(
    `SELECT id,
            object_type,
            object_id,
            relation,
            subject_type,
            subject_id,
            created_by,
            created_at
     FROM core.authz_tuples
     WHERE (subject_type = 'user' AND subject_id = $1)
        OR ($2::text[] IS NOT NULL AND subject_type = 'group' AND subject_id = ANY($2::text[]))
     ORDER BY created_at DESC`,
    [String(userId), groupIds.length ? groupIds : null]
  );

  return {
    roles,
    permissions: permissions.map(row => row.code),
    groups: groupIds,
    tuples
  };
}

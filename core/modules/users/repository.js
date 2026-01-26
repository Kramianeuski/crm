export async function fetchUsers(pg) {
  const { rows } = await pg.query(
    `
    SELECT
      u.id,
      u.email,
      u.login,
      u.first_name,
      u.last_name,
      u.company_name,
      u.display_name,
      u.lang,
      u.is_active,
      COALESCE(
        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),
        '{}'
      ) AS roles,
      COALESCE(
        ARRAY_AGG(DISTINCT g.code) FILTER (WHERE g.code IS NOT NULL),
        '{}'
      ) AS groups,
      COALESCE(
        JSONB_AGG(
          DISTINCT JSONB_BUILD_OBJECT(
            'id', d.id,
            'name', d.name,
            'name_key', d.name_key,
            'code', d.code
          )
        ) FILTER (WHERE d.id IS NOT NULL),
        '[]'::jsonb
      ) AS departments
    FROM core.users u
    LEFT JOIN core.user_roles ur ON ur.user_id = u.id
    LEFT JOIN core.roles r ON r.id = ur.role_id
    LEFT JOIN core.user_groups ug ON ug.user_id = u.id
    LEFT JOIN core.groups g ON g.id = ug.group_id
    LEFT JOIN core.department_users du ON du.user_id = u.id
    LEFT JOIN core.departments d ON d.id = du.department_id
    GROUP BY u.id
    ORDER BY u.created_at DESC
    `
  );
  return rows;
}

export async function fetchUser(pg, userId) {
  const { rows } = await pg.query(
    `
    SELECT
      u.id,
      u.email,
      u.login,
      u.first_name,
      u.last_name,
      u.company_name,
      u.display_name,
      u.lang,
      u.is_active,
      COALESCE(
        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),
        '{}'
      ) AS roles
    FROM core.users u
    LEFT JOIN core.user_roles ur ON ur.user_id = u.id
    LEFT JOIN core.roles r ON r.id = ur.role_id
    WHERE u.id = $1
    GROUP BY u.id
    `,
    [userId]
  );
  return rows[0] || null;
}

export async function insertUser(pg, payload) {
  await pg.query(
    `INSERT INTO core.users
     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
    [
      payload.id,
      payload.email,
      payload.login,
      payload.first_name,
      payload.last_name,
      payload.company_name,
      payload.display_name,
      payload.lang,
      payload.is_active
    ]
  );
}

export async function updateUser(pg, userId, payload) {
  const fields = [];
  const values = [];
  const addField = (key, value) => {
    values.push(value);
    fields.push(`${key} = $${values.length}`);
  };

  if (payload.first_name !== undefined) addField('first_name', payload.first_name);
  if (payload.last_name !== undefined) addField('last_name', payload.last_name);
  if (payload.company_name !== undefined) addField('company_name', payload.company_name);
  if (payload.lang !== undefined) addField('lang', payload.lang);
  if (payload.is_active !== undefined) addField('is_active', payload.is_active);

  if (!fields.length) return;

  values.push(userId);
  await pg.query(
    `UPDATE core.users
     SET ${fields.join(', ')}
     WHERE id = $${values.length}`,
    values
  );
}

export async function replaceUserRoles(pg, userId, roleCodes) {
  await pg.query(`DELETE FROM core.user_roles WHERE user_id = $1`, [userId]);
  if (!roleCodes || roleCodes.length === 0) return;

  const { rows } = await pg.query(
    `SELECT id, code FROM core.roles WHERE code = ANY($1::text[])`,
    [roleCodes]
  );

  for (const role of rows) {
    await pg.query(
      `INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)`,
      [userId, role.id]
    );
  }
}

export async function insertUserPassword(pg, userId, passwordHash) {
  await pg.query(
    `INSERT INTO core.user_passwords (user_id, password_hash, is_enabled)
     VALUES ($1, $2, true)
     ON CONFLICT (user_id)
     DO UPDATE SET password_hash = EXCLUDED.password_hash, updated_at = now(), is_enabled = true`,
    [userId, passwordHash]
  );
}

export async function deleteUser(pg, userId) {
  const { rowCount } = await pg.query(`DELETE FROM core.users WHERE id = $1`, [userId]);
  return rowCount > 0;
}

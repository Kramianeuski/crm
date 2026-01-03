import { pool } from '../../db.js';

const USER_SELECT = `
  SELECT
    id,
    email,
    COALESCE(
      display_name,
      trim(concat_ws(' ', first_name, last_name))
    ) AS display_name,
    lang,
    is_active
  FROM core.users
`;

export async function findUserByEmail(email) {
  const { rows } = await pool.query(
    `${USER_SELECT}
     WHERE email = $1`,
    [email.toLowerCase()]
  );
  return rows[0] || null;
}

export async function findUserById(userId) {
  const { rows } = await pool.query(
    `${USER_SELECT}
     WHERE id = $1`,
    [userId]
  );
  return rows[0] || null;
}

export async function findPassword(userId) {
  const { rows } = await pool.query(
    `SELECT password_hash, is_enabled
     FROM core.user_passwords
     WHERE user_id = $1
     LIMIT 1`,
    [userId]
  );
  return rows[0] || null;
}

export async function findRoles(userId) {
  const { rows } = await pool.query(
    `SELECT r.id, r.code, r.name_key
     FROM core.user_roles ur
     JOIN core.roles r ON r.id = ur.role_id
     WHERE ur.user_id = $1`,
    [userId]
  );
  return rows;
}

export async function findPermissions(userId) {
  const { rows } = await pool.query(
    `SELECT DISTINCT p.code, rp.scope
     FROM core.user_roles ur
     JOIN core.role_permissions rp ON rp.role_id = ur.role_id
     JOIN core.permissions p ON p.id = rp.permission_id
     WHERE ur.user_id = $1`,
    [userId]
  );
  return rows;
}

export async function findGroups(userId) {
  const { rows } = await pool.query(
    `SELECT g.id, g.code, g.name_key
     FROM core.user_groups ug
     JOIN core.groups g ON g.id = ug.group_id
     WHERE ug.user_id = $1`,
    [userId]
  );
  return rows;
}

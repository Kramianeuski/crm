'use strict';

async function findUserByEmail(pg, email) {
  const { rows } = await pg.query(
    `SELECT id, email, full_name, lang, is_active
     FROM core.users
     WHERE email = $1`,
    [email.toLowerCase()]
  );
  return rows[0] || null;
}

async function findUserById(pg, userId) {
  const { rows } = await pg.query(
    `SELECT id, email, full_name, lang, is_active
     FROM core.users
     WHERE id = $1`,
    [userId]
  );
  return rows[0] || null;
}

async function findPassword(pg, userId) {
  const { rows } = await pg.query(
    `SELECT password_hash, enabled
     FROM core.user_passwords
     WHERE user_id = $1
     ORDER BY created_at DESC
     LIMIT 1`,
    [userId]
  );
  return rows[0] || null;
}

async function findRoles(pg, userId) {
  const { rows } = await pg.query(
    `SELECT r.id, r.code, r.name_key
     FROM core.user_roles ur
     JOIN core.roles r ON r.id = ur.role_id
     WHERE ur.user_id = $1`,
    [userId]
  );
  return rows;
}

async function findPermissions(pg, userId) {
  const { rows } = await pg.query(
    `SELECT DISTINCT p.code, rp.scope
     FROM core.user_roles ur
     JOIN core.role_permissions rp ON rp.role_id = ur.role_id
     JOIN core.permissions p ON p.id = rp.permission_id
     WHERE ur.user_id = $1`,
    [userId]
  );
  return rows;
}

async function findGroups(pg, userId) {
  const { rows } = await pg.query(
    `SELECT g.id, g.code, g.name
     FROM core.user_groups ug
     JOIN core.groups g ON g.id = ug.group_id
     WHERE ug.user_id = $1`,
    [userId]
  );
  return rows;
}

module.exports = {
  findUserByEmail,
  findUserById,
  findPassword,
  findRoles,
  findPermissions,
  findGroups
};

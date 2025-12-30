'use strict';

const argon2 = require('argon2');
const repo = require('./repository');

async function authenticate(pg, email, password) {
  const user = await repo.findUserByEmail(pg, email);
  if (!user) return { error: 'invalid_credentials' };
  if (!user.is_active) return { error: 'user_inactive' };

  const passwordRow = await repo.findPassword(pg, user.id);
  if (!passwordRow || !passwordRow.enabled) return { error: 'password_disabled' };

  const isValid = await argon2.verify(passwordRow.password_hash, password);
  if (!isValid) return { error: 'invalid_credentials' };

  const roles = await repo.findRoles(pg, user.id);
  const permissions = await repo.findPermissions(pg, user.id);
  const groups = await repo.findGroups(pg, user.id);

  return { user, roles, permissions, groups };
}

async function buildUserContext(pg, userId) {
  const user = await repo.findUserById(pg, userId);
  if (!user) return null;
  const roles = await repo.findRoles(pg, user.id);
  const permissions = await repo.findPermissions(pg, user.id);
  const groups = await repo.findGroups(pg, user.id);
  return { user, roles, permissions, groups };
}

module.exports = {
  authenticate,
  buildUserContext
};

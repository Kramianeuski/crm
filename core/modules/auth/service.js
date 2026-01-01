'use strict';

const argon2 = require('argon2');
const repo = require('./repository');

async function authenticate(email, password) {
  const user = await repo.findUserByEmail(email);
  if (!user) return { error: 'invalid_credentials' };
  if (!user.is_active) return { error: 'user_inactive' };

  const passwordRow = await repo.findPassword(user.id);
  if (!passwordRow) return { error: 'password_not_set' };
  if (passwordRow.is_enabled !== true)
    return { error: 'password_disabled' };

  const isValid = await argon2.verify(
    passwordRow.password_hash,
    password
  );
  if (!isValid) return { error: 'invalid_credentials' };

  const roles = await repo.findRoles(user.id);
  const permissions = await repo.findPermissions(user.id);
  const groups = await repo.findGroups(user.id);

  return { user, roles, permissions, groups };
}

async function buildUserContext(userId) {
  const user = await repo.findUserById(userId);
  if (!user) return null;

  const roles = await repo.findRoles(user.id);
  const permissions = await repo.findPermissions(user.id);
  const groups = await repo.findGroups(user.id);

  return { user, roles, permissions, groups };
}

module.exports = {
  authenticate,
  buildUserContext
};

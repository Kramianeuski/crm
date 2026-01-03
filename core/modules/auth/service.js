import argon2 from 'argon2';
import {
  findGroups,
  findPassword,
  findPermissions,
  findRoles,
  findUserByEmail,
  findUserById
} from './repository.js';

export async function authenticate(email, password) {
  const user = await findUserByEmail(email);
  if (!user) return { error: 'invalid_credentials' };
  if (!user.is_active) return { error: 'user_inactive' };

  const passwordRow = await findPassword(user.id);
  if (!passwordRow) return { error: 'password_not_set' };
  if (passwordRow.is_enabled !== true) return { error: 'password_disabled' };

  const isValid = await argon2.verify(
    passwordRow.password_hash,
    password
  );
  if (!isValid) return { error: 'invalid_credentials' };

  const roles = await findRoles(user.id);
  const permissions = await findPermissions(user.id);
  const groups = await findGroups(user.id);

  return { user, roles, permissions, groups };
}

export async function buildUserContext(userId) {
  const user = await findUserById(userId);
  if (!user) return null;

  const roles = await findRoles(user.id);
  const permissions = await findPermissions(user.id);
  const groups = await findGroups(user.id);

  return { user, roles, permissions, groups };
}

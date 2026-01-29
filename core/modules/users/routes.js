import argon2 from 'argon2';
import { randomUUID } from 'crypto';
import {
  deleteUser,
  fetchUser,
  fetchUsers,
  insertUser,
  insertUserPassword,
  replaceUserRoles,
  updateUser
} from './repository.js';

const requireAccess = (resource, permission) => async (request, reply) => {
  if (!await request.server.canAccess(request.user, resource, permission)) return reply.code(403).send({ error: 'forbidden' });
};

async function getSecuritySettings(pg) {
  const { rows } = await pg.query(
    `SELECT payload
     FROM core.settings_values
     WHERE module_code = 'core' AND page_code = 'security'
     LIMIT 1`
  );
  return rows[0]?.payload || {};
}

export default async function userRoutes(fastify) {
  const preHandler = [fastify.verifyJWT];

  fastify.get('/users', { preHandler: [...preHandler, requireAccess('users', 'view')] }, async (request, reply) => {
    try {
      fastify.log.info({ userId: request.user?.id }, 'GET /users called');

      // Note: access check is now in preHandler
      const users = await fetchUsers(fastify.pg);
      return reply.send({ users });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/users/:id', { preHandler: [...preHandler, requireAccess('users', 'view')] }, async (request, reply) => {
    try {
      // Note: access check is now in preHandler
      const user = await fetchUser(fastify.pg, request.params.id);
      if (!user) return reply.code(404).send({ error: 'user_not_found' });

      return reply.send({ user });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/users', { preHandler: [...preHandler, requireAccess('users', 'manage')] }, async (request, reply) => {
    try {
      // Note: access check is now in preHandler

      const payload = request.body || {};
      if (!payload.email) {
        return reply.code(422).send({ error: 'email_required' });
      }

      const id = randomUUID();
      const email = String(payload.email).toLowerCase();
      const displayName = payload.first_name || payload.last_name
        ? `${payload.first_name || ''} ${payload.last_name || ''}`.trim()
        : null;

      await fastify.pg.query('BEGIN');
      await insertUser(fastify.pg, {
        id,
        email,
        login: payload.login || null,
        first_name: payload.first_name || null,
        last_name: payload.last_name || null,
        company_name: payload.company_name || null,
        display_name: displayName,
        lang: payload.lang || 'ru',
        is_active: payload.is_active !== false
      });

      if (Array.isArray(payload.roles)) {
        await replaceUserRoles(fastify.pg, id, payload.roles);
      }

      const securitySettings = await getSecuritySettings(fastify.pg);
      const allowPasswords = securitySettings.enableLocalPasswords !== false;
      if (payload.password && allowPasswords) {
        const hash = await argon2.hash(payload.password);
        await insertUserPassword(fastify.pg, id, hash);
      }

      await fastify.pg.query('COMMIT');

      fastify.audit?.logEvent?.(
        'user_create',
        { email },
        { actorUserId: request.user.id, entityType: 'user', entityId: id }
      );

      const user = await fetchUser(fastify.pg, id);
      return reply.send({ user });
    } catch (err) {
      await fastify.pg.query('ROLLBACK').catch(() => null);
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'user_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  const updateHandler = async (request, reply) => {
    try {
      const payload = request.body || {};
      const rolesProvided = Array.isArray(payload.roles);
      const canManage = await fastify.canAccess(request.user, 'users', 'manage');

      // If roles are provided, user must have either 'users.manage' or 'users.roles.assign'
      if (rolesProvided && !canManage) {
        const canAssign = await fastify.canAccess(request.user, 'users.roles', 'assign');
        if (!canAssign) return reply.code(403).send({ error: 'forbidden' });
      }

      // If other fields are provided, user must have 'users.manage'
      const otherFieldsProvided = Object.keys(payload).some(k => k !== 'roles');
      if (otherFieldsProvided && !canManage) {
        return reply.code(403).send({ error: 'forbidden' });
      }

      const user = await fetchUser(fastify.pg, request.params.id);
      if (!user) return reply.code(404).send({ error: 'user_not_found' });

      await fastify.pg.query('BEGIN');
      if (otherFieldsProvided) {
        await updateUser(fastify.pg, request.params.id, {
          first_name: payload.first_name,
          last_name: payload.last_name,
          company_name: payload.company_name,
          lang: payload.lang,
          is_active: payload.is_active
        });
      }

      if (rolesProvided) {
        await replaceUserRoles(fastify.pg, request.params.id, payload.roles);
      }
      await fastify.pg.query('COMMIT');

      fastify.audit?.logEvent?.(
        'user_update',
        { fields: Object.keys(payload) },
        { actorUserId: request.user.id, entityType: 'user', entityId: request.params.id }
      );

      const updated = await fetchUser(fastify.pg, request.params.id);
      return reply.send({ user: updated });
    } catch (err) {
      await fastify.pg.query('ROLLBACK').catch(() => null);
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  };

  fastify.patch('/users/:id', { preHandler }, updateHandler);
  fastify.put('/users/:id', { preHandler }, updateHandler);

  fastify.delete('/users/:id', { preHandler: [...preHandler, requireAccess('users', 'manage')] }, async (request, reply) => {
    try {
      // Note: access check is now in preHandler

      const removed = await deleteUser(fastify.pg, request.params.id);
      if (!removed) return reply.code(404).send({ error: 'user_not_found' });

      fastify.audit?.logEvent?.(
        'user_delete',
        {},
        { actorUserId: request.user.id, entityType: 'user', entityId: request.params.id }
      );

      return reply.code(204).send();
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

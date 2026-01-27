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

async function canManageUsers(fastify, request) {
  return fastify.canAccess(request.user, 'users', 'manage');
}

async function canAssignRoles(fastify, request) {
  return fastify.canAccess(request.user, 'users.roles', 'assign');
}

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
  fastify.get('/users', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      fastify.log.info({ userId: request.user?.id }, 'GET /users called');
      const allowed = await fastify.canAccess(request.user, 'users', 'view');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const users = await fetchUsers(fastify.pg);
      return reply.send({ users });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/users/:id', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'users', 'view');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const user = await fetchUser(fastify.pg, request.params.id);
      if (!user) return reply.code(404).send({ error: 'user_not_found' });

      return reply.send({ user });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/users', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      if (!(await canManageUsers(fastify, request))) {
        return reply.code(403).send({ error: 'forbidden' });
      }

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

      await fastify.audit?.logEvent?.(
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
      const canManage = await canManageUsers(fastify, request);
      const canAssign = await canAssignRoles(fastify, request);

      if (!canManage && !(rolesProvided && canAssign && Object.keys(payload).length === 1)) {
        return reply.code(403).send({ error: 'forbidden' });
      }
      if (rolesProvided && !(canAssign || canManage)) {
        return reply.code(403).send({ error: 'forbidden' });
      }

      const user = await fetchUser(fastify.pg, request.params.id);
      if (!user) return reply.code(404).send({ error: 'user_not_found' });

      await fastify.pg.query('BEGIN');
      await updateUser(fastify.pg, request.params.id, {
        first_name: payload.first_name,
        last_name: payload.last_name,
        company_name: payload.company_name,
        lang: payload.lang,
        is_active: payload.is_active
      });

      if (rolesProvided) {
        await replaceUserRoles(fastify.pg, request.params.id, payload.roles);
      }
      await fastify.pg.query('COMMIT');

      await fastify.audit?.logEvent?.(
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

  fastify.patch('/users/:id', { preHandler: fastify.verifyJWT }, updateHandler);
  fastify.put('/users/:id', { preHandler: fastify.verifyJWT }, updateHandler);

  fastify.delete('/users/:id', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      if (!(await canManageUsers(fastify, request))) {
        return reply.code(403).send({ error: 'forbidden' });
      }

      const removed = await deleteUser(fastify.pg, request.params.id);
      if (!removed) return reply.code(404).send({ error: 'user_not_found' });

      await fastify.audit?.logEvent?.(
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

import {
  listPermissions,
  listRolePermissions,
  updateRolePermissions
} from './repository.js';

export default async function rbacRoutes(fastify) {
  const ensureAccess = async (request, reply, resource, action) => {
    const allowed = await fastify.canAccess(request.user, resource, action);
    if (!allowed) {
      reply.code(403).send({ error: 'forbidden' });
      return false;
    }
    return true;
  };

  fastify.get('/roles', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'roles', 'view');
      if (!allowed) return reply;

      const roles = await listRolePermissions(fastify.pg);
      return reply.send({ roles });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/permissions', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'permissions', 'view');
      if (!allowed) return reply;

      const permissions = await listPermissions(fastify.pg);
      return reply.send({ permissions });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/roles/:id', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'roles', 'manage');
      if (!allowed) return reply;

      const { id } = request.params;
      const { permissions } = request.body || {};

      if (!Array.isArray(permissions)) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      const sanitized = permissions.map((permission) => ({
        code: permission.code,
        scope: permission.scope
      })).filter((permission) => Boolean(permission.code));

      const result = await updateRolePermissions(fastify.pg, id, sanitized);

      if (result.error === 'role_not_found') {
        return reply.code(404).send({ error: 'role_not_found' });
      }

      if (result.error === 'permission_not_found') {
        return reply.code(400).send({ error: 'permission_not_found', details: result.details });
      }

      return reply.send({ saved: true });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

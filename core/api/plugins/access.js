'use strict';

const { canAccess } = require('../lib/canAccess');
const fp = require('fastify-plugin');

module.exports = fp(async function accessPlugin(fastify) {
  fastify.decorate('canAccess', (user, resource, action, entity = null) =>
    canAccess(fastify.pg, user, resource, action, entity)
  );

  fastify.decorate('requirePermission', (resource, action) => async (request, reply) => {
    if (!request.user) {
      reply.code(401).send({ error: 'unauthorized' });
      return;
    }

    const allowed = await fastify.canAccess(request.user, resource, action, request.body?.entity || null);
    if (!allowed) {
      reply.code(403).send({ error: 'forbidden' });
    }
  });
});

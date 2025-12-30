'use strict';

module.exports = async function accessRoutes(fastify) {
  fastify.post('/api/core/v1/access/check', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { resource, action, entity } = request.body || {};
    if (!resource || !action) return reply.code(400).send({ error: 'invalid_request' });

    const allowed = await fastify.canAccess(request.user, resource, action, entity || null);
    reply.send({ allowed });
  });
};

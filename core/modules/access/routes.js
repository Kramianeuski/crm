export default async function accessRoutes(fastify) {
  fastify.post('/access/check', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const { resource, action, entity } = request.body || {};
      if (!resource || !action) return reply.code(400).send({ error: 'invalid_request' });

      const allowed = await fastify.canAccess(request.user, resource, action, entity || null);
      return reply.send({ allowed });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

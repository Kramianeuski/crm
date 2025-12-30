'use strict';

const fp = require('fastify-plugin');

module.exports = fp(async function authPlugin(fastify) {
  fastify.decorate('requireAuth', async function requireAuth(request, reply) {
    if (!request.user) {
      reply.code(401).send({ error: 'unauthorized' });
    }
  });
});

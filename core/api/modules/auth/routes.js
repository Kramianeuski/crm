'use strict';

const service = require('./service');

module.exports = async function authRoutes(fastify) {
  fastify.post('/api/core/v1/auth/login', async (request, reply) => {
    const { email, password } = request.body || {};
    if (!email || !password) return reply.code(400).send({ error: 'invalid_request' });

    const result = await service.authenticate(email, password);
    if (result.error) return reply.code(result.error === 'invalid_credentials' ? 401 : 403).send({ error: result.error });

    const token = fastify.signToken({
      sub: result.user.id,
      email: result.user.email,
      lang: result.user.lang,
      roles: result.roles.map(r => r.code),
      groups: result.groups.map(g => g.code)
    });

    reply.send({ token });
  });

  fastify.get('/api/core/v1/auth/me', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const ctx = await service.buildUserContext(request.user.id);
    if (!ctx) return reply.code(404).send({ error: 'user_not_found' });

    reply.send({
      user: ctx.user,
      roles: ctx.roles,
      permissions: ctx.permissions,
      lang: ctx.user.lang
    });
  });
};

import { authenticate, buildUserContext } from './service.js';

export default async function authRoutes(fastify) {
  fastify.post('/api/core/v1/auth/login', async (request, reply) => {
    try {
      const { email, password } = request.body || {};
      if (!email || !password) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      const result = await authenticate(email, password);
      if (result.error) {
        return reply
          .code(result.error === 'invalid_credentials' ? 401 : 403)
          .send({ error: result.error });
      }

      const token = fastify.signToken({
        sub: result.user.id,
        email: result.user.email,
        lang: result.user.lang,
        roles: result.roles.map(r => r.code),
        groups: result.groups.map(g => g.code)
      });

      return reply.send({ token });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/api/core/v1/auth/me', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const ctx = await buildUserContext(request.user.id);
      if (!ctx) return reply.code(404).send({ error: 'user_not_found' });

      return reply.send({
        user: ctx.user,
        roles: ctx.roles,
        permissions: ctx.permissions,
        lang: ctx.user.lang
      });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

'use strict';

const jwt = require('jsonwebtoken');
const fp = require('fastify-plugin');

module.exports = fp(async function jwtPlugin(fastify) {
  const JWT_SECRET = process.env.JWT_SECRET;
  const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '12h';

  fastify.decorate('signToken', payload =>
    jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN })
  );

  fastify.decorateRequest('user', null);

  fastify.decorate('verifyJWT', async function verifyJWT(request, reply) {
    const authHeader = request.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      reply.code(401).send({ error: 'unauthorized' });
      return;
    }

    try {
      const token = authHeader.slice(7);
      const payload = jwt.verify(token, JWT_SECRET);
      request.user = {
        id: payload.sub,
        email: payload.email,
        lang: payload.lang,
        roles: payload.roles || [],
        groups: payload.groups || []
      };
    } catch (err) {
      request.log.warn({ err }, 'Invalid JWT');
      reply.code(401).send({ error: 'unauthorized' });
    }
  });
});

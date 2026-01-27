import fp from 'fastify-plugin';
import jwt from 'jsonwebtoken';

function validateJwtEnv() {
  if (!process.env.JWT_SECRET) {
    throw new Error('Missing required env var: JWT_SECRET');
  }
}

export default fp(async function jwtPlugin(app) {
  validateJwtEnv();

  const JWT_SECRET = process.env.JWT_SECRET;
  const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '15m';
  const JWT_ISSUER = process.env.JWT_ISSUER || 'crm-core';
  const JWT_AUDIENCE = process.env.JWT_AUDIENCE || 'crm-ui';

  app.decorate('signToken', payload => {
    return jwt.sign(
      payload,
      JWT_SECRET,
      {
        algorithm: 'HS256',
        expiresIn: JWT_EXPIRES_IN,
        issuer: JWT_ISSUER,
        audience: JWT_AUDIENCE
      }
    );
  });

  app.decorateRequest('user', null);

  app.decorate('verifyJWT', async function verifyJWT(request) {
    const authHeader = request.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      const err = new Error('Unauthorized');
      err.statusCode = 401;
      err.code = 'unauthorized';
      throw err;
    }

    try {
      const token = authHeader.slice(7);

      const payload = jwt.verify(token, JWT_SECRET, {
        algorithms: ['HS256'],
        issuer: JWT_ISSUER,
        audience: JWT_AUDIENCE
      });

      const userId =
        payload.sub ?? payload.user_id ?? payload.userId ?? payload.id ?? null;

      if (!userId) {
        const err = new Error('Unauthorized');
        err.statusCode = 401;
        err.code = 'unauthorized';
        throw err;
      }

      request.user = {
        id: userId,
        email: payload.email,
        lang: payload.lang,
        roles: Array.isArray(payload.roles) ? payload.roles : [],
        groups: Array.isArray(payload.groups) ? payload.groups : []
      };
    } catch (err) {
      app.log.warn({ err }, 'JWT verification failed');
      err.statusCode = 401;
      err.code = 'unauthorized';
      throw err;
    }
  });
});

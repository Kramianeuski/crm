import fp from 'fastify-plugin';
import jwt from 'jsonwebtoken';

export default fp(async function partnerJwtPlugin(app) {
  const PARTNER_JWT_SECRET = process.env.PARTNER_JWT_SECRET || process.env.JWT_SECRET;
  if (!PARTNER_JWT_SECRET) {
    throw new Error('Missing required env var: PARTNER_JWT_SECRET');
  }

  const PARTNER_JWT_EXPIRES_IN = process.env.PARTNER_JWT_EXPIRES_IN || '15m';
  const PARTNER_JWT_ISSUER = process.env.PARTNER_JWT_ISSUER || 'crm-partners';
  const PARTNER_JWT_AUDIENCE = process.env.PARTNER_JWT_AUDIENCE || 'crm-partners';

  app.decorate('signPartnerToken', payload => {
    return jwt.sign(
      payload,
      PARTNER_JWT_SECRET,
      {
        algorithm: 'HS256',
        expiresIn: PARTNER_JWT_EXPIRES_IN,
        issuer: PARTNER_JWT_ISSUER,
        audience: PARTNER_JWT_AUDIENCE
      }
    );
  });

  app.decorateRequest('partner', null);

  app.decorate('verifyPartnerJWT', async function verifyPartnerJWT(request) {
    const authHeader = request.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      const err = new Error('Unauthorized');
      err.statusCode = 401;
      err.code = 'unauthorized';
      throw err;
    }

    try {
      const token = authHeader.slice(7);

      const payload = jwt.verify(token, PARTNER_JWT_SECRET, {
        algorithms: ['HS256'],
        issuer: PARTNER_JWT_ISSUER,
        audience: PARTNER_JWT_AUDIENCE
      });

      request.partner = {
        id: payload.sub,
        email: payload.email,
        lang: payload.lang,
        roles: payload.roles || [],
        groups: payload.groups || []
      };
    } catch (err) {
      app.log.warn({ err }, 'Partner JWT verification failed');
      err.statusCode = 401;
      err.code = 'unauthorized';
      throw err;
    }
  });
});

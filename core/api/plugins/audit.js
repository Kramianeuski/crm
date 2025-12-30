'use strict';

module.exports = async function auditPlugin(fastify) {
  fastify.addHook('onRequest', async request => {
    request.auditContext = {
      startedAt: Date.now(),
      before: null,
      after: null
    };
  });

  fastify.addHook('onSend', async (request, reply, payload) => {
    const userId = request.user?.id || null;
    const route = request.routerPath || request.raw.url;
    const durationMs = Date.now() - (request.auditContext?.startedAt || Date.now());

    try {
      await fastify.pg.query(
        `INSERT INTO audit.audit_log (user_id, route, method, status_code, duration_ms)
         VALUES ($1, $2, $3, $4, $5)`,
        [userId, route, request.method, reply.statusCode, durationMs]
      );
    } catch (err) {
      fastify.log.warn({ err }, 'Failed to write audit log');
    }

    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(request.method)) {
      let parsedPayload = null;
      if (typeof payload === 'string') {
        try {
          parsedPayload = JSON.parse(payload);
        } catch (err) {
          fastify.log.debug({ err }, 'Response payload not JSON');
        }
      }
      try {
        await fastify.pg.query(
          `INSERT INTO bull.bull_log (user_id, route, before_payload, after_payload, created_at)
           VALUES ($1, $2, $3, $4, now())`,
          [
            userId,
            route,
            request.auditContext?.before,
            request.auditContext?.after || parsedPayload
          ]
        );
      } catch (err) {
        fastify.log.warn({ err }, 'Failed to write bull log');
      }
    }
  });
};

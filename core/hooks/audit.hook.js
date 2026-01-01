'use strict';

const fp = require('fastify-plugin');
const { createAuditService } = require('../logging/audit.service');
const { createSystemService } = require('../logging/system.service');

module.exports = fp(async function auditHook(fastify) {
  const auditService = createAuditService(fastify.pg, fastify.log);
  const systemService = createSystemService(fastify.pg, fastify.log);

  fastify.decorate('audit', auditService);
  fastify.decorate('systemLog', systemService);

  fastify.addHook('onRequest', async request => {
    request.auditContext = {
      startedAt: Date.now(),
      before: request.body ?? null,
      after: null
    };
  });

  fastify.addHook('onSend', async (request, reply, payload) => {
    const route = request.routerPath || request.raw.url;
    const durationMs = Date.now() - (request.auditContext?.startedAt || Date.now());

    await auditService.logEvent('http_request', {
      userId: request.user?.id || null,
      route,
      method: request.method,
      statusCode: reply.statusCode,
      durationMs
    });

    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(request.method)) {
      let parsedPayload = null;

      if (typeof payload === 'string') {
        try {
          parsedPayload = JSON.parse(payload);
        } catch (err) {
          request.log.debug({ err }, 'Response payload not JSON');
        }
      }

      const beforePayload = request.auditContext?.before ?? null;
      const afterPayload = request.auditContext?.after ?? parsedPayload;

      await systemService.logQueueEvent('http_mutation', {
        userId: request.user?.id || null,
        route,
        method: request.method,
        before: beforePayload,
        after: afterPayload
      });
    }
  });
});

import { createAuditService } from '../logging/audit.service.js';
import { createSystemService } from '../logging/system.service.js';

export default async function auditHook(app) {
  const auditService = createAuditService(app.pg, app.log);
  const systemService = createSystemService(app.pg, app.log);

  app.decorate('audit', auditService);
  app.decorate('systemLog', systemService);

  app.addHook('onRequest', async request => {
    request.auditContext = {
      startedAt: Date.now(),
      before: request.body ?? null,
      after: null
    };
  });

  app.addHook('onSend', async (request, reply, payload) => {
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
}

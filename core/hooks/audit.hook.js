import { createAuditService } from '../logging/audit.service.js';
import { createSystemService } from '../logging/system.service.js';

const SENSITIVE_KEYS = new Set([
  'password',
  'password_hash',
  'token',
  'access_token',
  'refresh_token',
  'secret'
]);

function sanitizePayload(payload) {
  if (!payload) return payload;
  if (Array.isArray(payload)) {
    return payload.map(item => sanitizePayload(item));
  }
  if (typeof payload === 'object') {
    return Object.entries(payload).reduce((acc, [key, value]) => {
      if (SENSITIVE_KEYS.has(key.toLowerCase())) {
        acc[key] = '[redacted]';
      } else {
        acc[key] = sanitizePayload(value);
      }
      return acc;
    }, {});
  }
  return payload;
}

function truncatePayload(payload, maxLength = 1500) {
  if (!payload) return payload;
  try {
    const json = JSON.stringify(payload);
    if (json.length <= maxLength) return payload;
    return { truncated: true, preview: json.slice(0, maxLength) };
  } catch (err) {
    return payload;
  }
}

export default async function auditHook(app) {
  const auditService = createAuditService(app.pg, app.log);
  const systemService = createSystemService(app.pg, app.log);
  const cache = { value: null, expiresAt: 0 };

  const isDeveloperModeEnabled = async () => {
    if (Date.now() < cache.expiresAt && cache.value !== null) {
      return cache.value;
    }
    try {
      const { rows } = await app.pg.query(
        `SELECT payload
         FROM core.settings_values
         WHERE module_code = 'core' AND page_code = 'system'
         LIMIT 1`
      );
      const developerMode = rows[0]?.payload?.developerMode === true;
      cache.value = developerMode;
      cache.expiresAt = Date.now() + 10_000;
      return developerMode;
    } catch (err) {
      app.log.warn(err, 'Failed to read developer mode setting');
      cache.value = false;
      cache.expiresAt = Date.now() + 10_000;
      return false;
    }
  };

  app.decorate('audit', auditService);
  app.decorate('systemLog', systemService);

  app.addHook('onRequest', async request => {
    request.auditContext = {
      startedAt: Date.now(),
      before: sanitizePayload(request.body ?? null),
      after: null
    };
  });

  app.addHook('onSend', async (request, reply, payload) => {
    const route = request.routerPath || request.raw.url;
    const durationMs = Date.now() - (request.auditContext?.startedAt || Date.now());

    await auditService.logEvent(
      'http_request',
      {
        route,
        method: request.method,
        statusCode: reply.statusCode,
        durationMs
      },
      { actorUserId: request.user?.id || null }
    );

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
      const afterPayload = sanitizePayload(request.auditContext?.after ?? parsedPayload);

      if (await isDeveloperModeEnabled()) {
        await systemService.logQueueEvent('http_mutation', {
          userId: request.user?.id || null,
          route,
          method: request.method,
          before: truncatePayload(beforePayload),
          after: truncatePayload(afterPayload)
        });
      }
    }
  });
}

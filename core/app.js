'use strict';

const fastify = require('fastify');
const process = require('process');
const { createLogger } = require('./logging/logger');

function buildApp() {
  const logger = createLogger();

  const app = fastify({
    logger,
    trustProxy: process.env.TRUST_PROXY === 'true',
    disableRequestLogging: process.env.NODE_ENV === 'production'
  });

  /* =========================
   * Security & platform
   * ========================= */

  app.register(require('@fastify/helmet'), {
    global: true,
    contentSecurityPolicy: false
  });

  app.register(require('@fastify/rate-limit'), {
    max: 1000,
    timeWindow: '1 minute',
    keyGenerator: req => req.user?.id ?? req.ip
  });

  app.register(require('@fastify/cors'), {
    origin: (origin, cb) => {
      if (!origin) return cb(null, true); // server-to-server / curl

      const allowedOrigins = (process.env.CORS_ORIGIN || '')
        .split(',')
        .map(o => o.trim())
        .filter(Boolean);

      cb(null, allowedOrigins.includes(origin));
    }
  });

  /* =========================
   * Core plugins
   * Order is IMPORTANT:
   * jwt → auth → access
   * ========================= */

  app.register(require('./plugins/db'));
  app.register(require('./plugins/jwt'));
  app.register(require('./plugins/auth'));
  app.register(require('./plugins/access'));

  /* =========================
   * Hooks
   * ========================= */

  app.register(require('./hooks/audit.hook'));

  /* =========================
   * Routes
   * ========================= */

  // Health must be public and lightweight
  app.register(require('./modules/health/routes'), {
    logLevel: 'silent'
  });

  app.register(require('./modules/auth/routes'), { prefix: '/api' });
  app.register(require('./modules/access/routes'), { prefix: '/api' });
  app.register(require('./modules/settings/routes'), { prefix: '/api' });

  /* =========================
   * Global error handler
   * ========================= */

  app.setErrorHandler((error, request, reply) => {
    request.log.error(error);

    if (reply.sent) return;

    reply
      .code(error.statusCode || 500)
      .send({
        error: error.code || 'internal_server_error'
      });
  });

  return app;
}

module.exports = buildApp;

'use strict';

const fastify = require('fastify');
const process = require('process');
const { createLogger } = require('./logging/logger');

function buildApp() {
  const logger = createLogger();

  const app = fastify({
    logger,
    trustProxy: true,
    disableRequestLogging: false
  });

  app.register(require('@fastify/helmet'), {
    global: true,
    contentSecurityPolicy: false
  });

  app.register(require('@fastify/rate-limit'), {
    max: 1000,
    timeWindow: '1 minute'
  });

  app.register(require('@fastify/cors'), {
    origin: false
  });

  app.register(require('./plugins/db'));
  app.register(require('./plugins/jwt'));
  app.register(require('./plugins/auth'));
  app.register(require('./plugins/access'));
  app.register(require('./hooks/audit.hook'));

  app.register(require('./modules/health/routes'));
  app.register(require('./modules/auth/routes'));
  app.register(require('./modules/access/routes'));
  app.register(require('./modules/settings/routes'));

  app.setErrorHandler((error, request, reply) => {
    request.log.error(error);

    if (reply.sent) return;

    reply.code(500).send({
      error: 'internal_server_error'
    });
  });

  return app;
}

module.exports = buildApp;

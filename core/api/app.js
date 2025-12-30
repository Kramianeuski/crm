'use strict';

const fastify = require('fastify');
const process = require('process');

function buildApp() {
  const isProd = process.env.CORE_ENV === 'production';

  const app = fastify({
    logger: {
      level: isProd ? 'info' : 'debug',
      transport: !isProd
        ? {
            target: 'pino-pretty',
            options: { colorize: true }
          }
        : undefined
    },
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
  app.register(require('./plugins/audit'));
  app.register(require('./plugins/error-handler'));

  app.register(require('./modules/health/routes'));
  app.register(require('./modules/auth/routes'));
  app.register(require('./modules/access/routes'));
  app.register(require('./modules/settings/routes'));

  return app;
}

module.exports = buildApp;

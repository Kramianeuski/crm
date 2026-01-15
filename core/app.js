'use strict';

import Fastify from 'fastify';
import process from 'process';

import { createLogger } from './logging/logger.js';

import helmet from '@fastify/helmet';
import rateLimit from '@fastify/rate-limit';
import cors from '@fastify/cors';

import dbPlugin from './plugins/db.js';
import jwtPlugin from './plugins/jwt.js';
import authPlugin from './plugins/auth.js';
import accessPlugin from './plugins/access.js';

import auditHook from './hooks/audit.hook.js';

import partnerJwtPlugin from './plugins/partner-jwt.js';

export default function buildApp() {
  const logger = createLogger();

  const app = Fastify({
    logger,
    trustProxy: process.env.TRUST_PROXY === 'true',
    disableRequestLogging: process.env.NODE_ENV === 'production'
  });

  /* =========================
   * Security & platform
   * ========================= */

  app.register(helmet, {
    global: true,
    contentSecurityPolicy: false
  });

  app.register(rateLimit, {
    max: 1000,
    timeWindow: '1 minute',
    keyGenerator: req => req.user?.id ?? req.ip
  });

  app.register(cors, {
    origin: (origin, cb) => {
      if (!origin) return cb(null, true);

      const allowedOrigins = (process.env.CORS_ORIGIN || '')
        .split(',')
        .map(o => o.trim())
        .filter(Boolean);

      cb(null, allowedOrigins.includes(origin));
    }
  });

  /* =========================
   * Core plugins
   * ========================= */

  app.register(dbPlugin);
  app.register(jwtPlugin);
  app.register(authPlugin);
  app.register(accessPlugin);
  app.register(partnerJwtPlugin);

  /* =========================
   * Hooks
   * ========================= */

  app.register(auditHook);

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

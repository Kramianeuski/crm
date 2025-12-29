'use strict';

/**
 * CRM Core API – production-ready bootstrap
 * - Fastify
 * - graceful shutdown
 * - healthcheck
 * - structured logging
 * - env from systemd (/etc/crm/core.env)
 */

const fastify = require('fastify');
const process = require('process');

// -----------------------------------------------------------------------------
// 1) Environment validation (fail fast)
// -----------------------------------------------------------------------------
const REQUIRED_ENV = [
  'CORE_ENV',
  'CORE_PORT',
  'DB_HOST',
  'DB_PORT',
  'DB_NAME',
  'DB_USER',
  'DB_PASSWORD',
  'JWT_SECRET'
];

for (const key of REQUIRED_ENV) {
  if (!process.env[key]) {
    console.error(`❌ Missing required env var: ${key}`);
    process.exit(1);
  }
}

const isProd = process.env.CORE_ENV === 'production';

// -----------------------------------------------------------------------------
// 2) Fastify instance
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 3) Core plugins (minimal, explicit)
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 4) PostgreSQL (direct access, no ORM)
// -----------------------------------------------------------------------------
const { Pool } = require('pg');

const pgPool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 5_000
});

app.decorate('pg', pgPool);

// Test DB connection early
pgPool
  .query('select 1')
  .catch(err => {
    app.log.error(err, '❌ PostgreSQL connection failed');
    process.exit(1);
  });

// -----------------------------------------------------------------------------
// 5) Core routes
// -----------------------------------------------------------------------------

/**
 * Healthcheck (for nginx / monitoring)
 */
app.get('/api/v1/core/health', async () => {
  return {
    status: 'ok',
    service: 'crm-core',
    env: process.env.CORE_ENV,
    timestamp: new Date().toISOString()
  };
});

/**
 * Readiness check (DB + internal deps)
 */
app.get('/api/v1/core/ready', async () => {
  await app.pg.query('select 1');
  return { ready: true };
});

// -----------------------------------------------------------------------------
// 6) Global error handler
// -----------------------------------------------------------------------------
app.setErrorHandler((error, request, reply) => {
  app.log.error(
    {
      err: error,
      reqId: request.id,
      url: request.url
    },
    'Unhandled error'
  );

  reply.status(500).send({
    error: 'internal_error',
    message: 'Internal server error'
  });
});

// -----------------------------------------------------------------------------
// 7) Graceful shutdown (CRITICAL for production)
// -----------------------------------------------------------------------------
let isShuttingDown = false;

const shutdown = async signal => {
  if (isShuttingDown) return;
  isShuttingDown = true;

  app.log.info({ signal }, 'Shutting down CRM Core');

  try {
    await app.close();
    await pgPool.end();
    process.exit(0);
  } catch (err) {
    app.log.error(err, 'Shutdown error');
    process.exit(1);
  }
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

// -----------------------------------------------------------------------------
// 8) Start server
// -----------------------------------------------------------------------------
const start = async () => {
  try {
    const port = Number(process.env.CORE_PORT);
    await app.listen({ port, host: '127.0.0.1' });

    app.log.info(
      {
        port,
        env: process.env.CORE_ENV
      },
      'CRM Core API started'
    );
  } catch (err) {
    app.log.error(err, 'Startup failed');
    process.exit(1);
  }
};

start();

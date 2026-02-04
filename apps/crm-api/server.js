import dotenv from 'dotenv';
import process from 'process';

dotenv.config({ path: '/etc/crm/core.env' });
dotenv.config({ path: process.env.CORE_ENV_PATH || '.env' });

const REQUIRED_ENV = [
  'PORT',
  'DATABASE_URL',
  'NODE_ENV',
  'JWT_SECRET'
];

function validateEnv() {
  for (const key of REQUIRED_ENV) {
    if (!process.env[key]) {
      throw new Error(`Missing required env var: ${key}`);
    }
  }

  const port = Number(process.env.PORT);
  if (Number.isNaN(port)) {
    throw new Error('PORT must be a number');
  }
}

validateEnv();

const { default: buildApp } = await import('../../core/app.js');
const { default: healthRoutes } = await import('../../core/modules/health/routes.js');
const { default: authRoutes } = await import('../../core/modules/auth/routes.js');
const { default: i18nRoutes } = await import('../../core/modules/i18n/routes.js');
const { default: productsRoutes } = await import('../../modules/products/http/routes.js');
const { default: warehouseRoutes } = await import('../../modules/warehouse/http/routes.js');

const app = buildApp();
const coreBasePath = '/api/core/v1';
const apiBasePath = '/api/v1';
let isShuttingDown = false;

const shutdown = async (signal) => {
  if (isShuttingDown) return;
  isShuttingDown = true;

  app.log.info({ signal }, 'Shutting down CRM API');
  try {
    await app.close();
  } catch (err) {
    app.log.error(err, 'Shutdown error');
  }
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

const start = async () => {
  try {
    app.register(healthRoutes, { logLevel: 'silent' });
    app.register(i18nRoutes, { prefix: coreBasePath });
    app.register(authRoutes, { prefix: coreBasePath });

    app.register(productsRoutes, { prefix: apiBasePath });
    app.register(warehouseRoutes, { prefix: apiBasePath });

    const port = Number(process.env.PORT);
    await app.listen({ port, host: '0.0.0.0' });
    app.log.info({ port, env: process.env.NODE_ENV }, 'CRM API started');
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
};

start();

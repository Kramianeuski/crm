import dotenv from 'dotenv';
dotenv.config({ path: '/etc/crm/core.env' });
import process from 'process';

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

const { default: buildApp } = await import('./app.js');
const { default: healthRoutes } = await import('./modules/health/routes.js');
const { default: authRoutes } = await import('./modules/auth/routes.js');
const { default: accessRoutes } = await import('./modules/access/routes.js');
const { default: settingsRoutes } = await import('./modules/settings/routes.js');
const { default: i18nRoutes } = await import('./modules/i18n/routes.js');
const { default: rbacRoutes } = await import('./modules/rbac/routes.js');
const { default: authzRoutes } = await import('./modules/authz/routes.js');
const { default: partnersRoutes } = await import('./modules/partners/routes.js');
const { default: logsRoutes } = await import('./modules/logs/routes.js');
const { default: usersRoutes } = await import('./modules/users/routes.js');

const app = buildApp();
const coreBasePath = '/api/core/v1';
const partnersBasePath = '/api/partners/v1';
let isShuttingDown = false;

const shutdown = async (signal) => {
  if (isShuttingDown) return;
  isShuttingDown = true;

  app.log.info({ signal }, 'Shutting down CRM Core');
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
    app.register(accessRoutes, { prefix: coreBasePath });
    app.register(rbacRoutes, { prefix: coreBasePath });
    app.register(authzRoutes, { prefix: coreBasePath });
    app.register(settingsRoutes, { prefix: coreBasePath });
    app.register(logsRoutes, { prefix: coreBasePath });
    app.register(usersRoutes, { prefix: coreBasePath });
    app.register(partnersRoutes, { prefix: partnersBasePath });

    const port = Number(process.env.PORT);
    await app.listen({ port, host: '0.0.0.0' });
    app.log.info(
      { port, env: process.env.NODE_ENV },
      'CRM Core API started'
    );
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
};

start();

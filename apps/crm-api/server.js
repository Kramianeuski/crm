import fs from 'fs';
import process from 'process';

function loadEnvFile(path) {
  try {
    const raw = fs.readFileSync(path, 'utf8');
    for (const line of raw.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;

      const separator = trimmed.indexOf('=');
      if (separator === -1) continue;

      const key = trimmed.slice(0, separator).trim();
      let value = trimmed.slice(separator + 1).trim();

      const hasDoubleQuotes = value.startsWith('"') && value.endsWith('"');
      const hasSingleQuotes = value.startsWith("'") && value.endsWith("'");
      if (hasDoubleQuotes || hasSingleQuotes) {
        value = value.slice(1, -1);
      }

      if (!(key in process.env)) {
        process.env[key] = value;
      }
    }
  } catch {
    // ignore missing env file
  }
}

loadEnvFile('/etc/crm/core.env');
loadEnvFile(process.env.CORE_ENV_PATH || '.env');

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
const { default: accessRoutes } = await import('../../core/modules/access/routes.js');
const { default: settingsRoutes } = await import('../../core/modules/settings/routes.js');
const { default: i18nRoutes } = await import('../../core/modules/i18n/routes.js');
const { default: rbacRoutes } = await import('../../core/modules/rbac/routes.js');
const { default: authzRoutes } = await import('../../core/modules/authz/routes.js');
const { default: logsRoutes } = await import('../../core/modules/logs/routes.js');
const { default: usersRoutes } = await import('../../core/modules/users/routes.js');
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
    app.register(accessRoutes, { prefix: coreBasePath });
    app.register(rbacRoutes, { prefix: coreBasePath });
    app.register(authzRoutes, { prefix: coreBasePath });
    app.register(settingsRoutes, { prefix: coreBasePath });
    app.register(logsRoutes, { prefix: coreBasePath });
    app.register(usersRoutes, { prefix: coreBasePath });

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

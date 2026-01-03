import dotenv from 'dotenv';

const envResult = dotenv.config({ path: '/etc/crm/core.env' });
if (envResult.error) {
  throw envResult.error;
}

import process from 'process';

const REQUIRED_ENV = [
  'CORE_PORT',
  'DB_HOST',
  'DB_PORT',
  'DB_NAME',
  'DB_USER',
  'DB_PASSWORD',
  'JWT_SECRET'
];

function validateEnv() {
  for (const key of REQUIRED_ENV) {
    if (!process.env[key]) {
      throw new Error(`Missing required env var: ${key}`);
    }
  }

  const port = Number(process.env.CORE_PORT);
  if (Number.isNaN(port)) {
    throw new Error('CORE_PORT must be a number');
  }

  const dbPort = Number(process.env.DB_PORT);
  if (Number.isNaN(dbPort)) {
    throw new Error('DB_PORT must be a number');
  }
}

validateEnv();

const { default: buildApp } = await import('./app.js');

const app = buildApp();
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
    const port = Number(process.env.CORE_PORT);
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

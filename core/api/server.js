'use strict';

const process = require('process');
const buildApp = require('./app');

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

const app = buildApp();
let isShuttingDown = false;

const shutdown = async signal => {
  if (isShuttingDown) return;
  isShuttingDown = true;
  app.log.info({ signal }, 'Shutting down CRM Core');

  try {
    await app.close();
    process.exit(0);
  } catch (err) {
    app.log.error(err, 'Shutdown error');
    process.exit(1);
  }
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

const start = async () => {
  try {
    const port = Number(process.env.CORE_PORT);
    await app.listen({ port, host: '127.0.0.1' });
    app.log.info({ port, env: process.env.CORE_ENV }, 'CRM Core API started');
  } catch (err) {
    app.log.error(err, 'Startup failed');
    process.exit(1);
  }
};

start();

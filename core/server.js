'use strict';

const process = require('process');
const buildApp = require('./app');

const REQUIRED_ENV = [
  'CORE_PORT',
  'JWT_SECRET'
];

function validateEnv() {
  for (const key of REQUIRED_ENV) {
    if (!process.env[key]) {
      throw new Error(`Missing required env var: ${key}`);
    }
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
  } catch (err) {
    app.log.error(err, 'Shutdown error');
  }
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

const start = async () => {
  try {
    validateEnv();
    const port = Number(process.env.CORE_PORT);
    await app.listen({ port, host: '0.0.0.0' });
    app.log.info({ port, env: process.env.NODE_ENV }, 'CRM Core API started');
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
};

start();

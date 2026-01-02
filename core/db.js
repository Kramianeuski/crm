'use strict';

const fp = require('fastify-plugin');
const { Pool } = require('pg');

function validateDbEnv() {
  const required = [
    'DB_HOST',
    'DB_NAME',
    'DB_USER',
    'DB_PASSWORD'
  ];

  for (const key of required) {
    if (!process.env[key]) {
      throw new Error(`Missing required DB env var: ${key}`);
    }
  }
}

async function dbPlugin(app) {
  validateDbEnv();

  const pool = new Pool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    max: Number(process.env.DB_POOL_SIZE || 20),
    idleTimeoutMillis: 30_000,
    connectionTimeoutMillis: 2_000,
    ssl: process.env.DB_SSL === 'true'
      ? { rejectUnauthorized: false }
      : undefined
  });

  pool.on('error', err => {
    app.log.error(err, 'PostgreSQL pool error');
  });

  // Decorate fastify instance
  app.decorate('db', pool);

  // Graceful shutdown
  app.addHook('onClose', async () => {
    app.log.info('Closing PostgreSQL pool');
    await pool.end();
  });
}

module.exports = fp(dbPlugin);

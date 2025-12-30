'use strict';

const { Pool } = require('pg');
const fp = require('fastify-plugin');

module.exports = fp(async function dbPlugin(fastify) {
  const pool = new Pool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    max: 20,
    idleTimeoutMillis: 30_000,
    connectionTimeoutMillis: 5_000
  });

  try {
    await pool.query('select 1');
  } catch (err) {
    fastify.log.error(err, 'PostgreSQL connection failed');
    throw err;
  }

  fastify.decorate('pg', pool);

  fastify.addHook('onClose', async () => {
    await pool.end();
  });
});

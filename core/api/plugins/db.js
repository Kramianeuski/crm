'use strict';

const fp = require('fastify-plugin');
const { pool } = require('../db');

module.exports = fp(async function dbPlugin(fastify) {
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

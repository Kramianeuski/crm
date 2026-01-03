import fp from 'fastify-plugin';
import { pool } from '../db.js';

export default fp(async function dbPlugin(app) {
  try {
    await pool.query('select 1');
  } catch (err) {
    app.log.error(err, 'PostgreSQL connection failed');
    throw err;
  }

  app.decorate('pg', pool);

  app.addHook('onClose', async () => {
    await pool.end();
  });
});

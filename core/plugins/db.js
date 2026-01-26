import fp from 'fastify-plugin';
import { pool } from '../db.js';

const SQL_LOG_QUEUE = 'sql';
const SENSITIVE_PARAM_PATTERN = /password|token|secret/i;

export default fp(async function dbPlugin(app) {
  try {
    await pool.query('select 1');
  } catch (err) {
    app.log.error(err, 'PostgreSQL connection failed');
    throw err;
  }

  const rawQuery = pool.query.bind(pool);
  const cache = { value: null, expiresAt: 0 };

  const isDeveloperModeEnabled = async () => {
    if (Date.now() < cache.expiresAt && cache.value !== null) {
      return cache.value;
    }
    try {
      const { rows } = await rawQuery(
        `SELECT payload
         FROM core.settings_values
         WHERE module_code = 'core' AND page_code = 'system'
         LIMIT 1`
      );
      const developerMode = rows[0]?.payload?.developerMode === true;
      cache.value = developerMode;
      cache.expiresAt = Date.now() + 10_000;
      return developerMode;
    } catch (err) {
      app.log.warn(err, 'Failed to read developer mode setting');
      cache.value = false;
      cache.expiresAt = Date.now() + 10_000;
      return false;
    }
  };

  const shouldLogQuery = text =>
    !text.includes('bull.bull_log') && !text.includes('audit.audit_log');

  const sanitizeParams = (text, values) => {
    if (!values) return values;
    if (SENSITIVE_PARAM_PATTERN.test(text)) {
      return values.map(() => '[redacted]');
    }
    return values;
  };

  pool.query = async (query, params) => {
    const startedAt = Date.now();
    const config =
      typeof query === 'string'
        ? { text: query, values: params }
        : { text: query?.text, values: query?.values ?? params };

    const result = await rawQuery(query, params);

    if (config.text && shouldLogQuery(config.text) && (await isDeveloperModeEnabled())) {
      const durationMs = Date.now() - startedAt;
      const payload = {
        text: config.text,
        params: sanitizeParams(config.text, config.values),
        durationMs
      };
      try {
        await rawQuery(
          `INSERT INTO bull.bull_log (queue, payload)
           VALUES ($1, $2)`,
          [SQL_LOG_QUEUE, payload]
        );
      } catch (err) {
        app.log.warn(err, 'Failed to log SQL query');
      }
    }

    return result;
  };

  app.decorate('pg', pool);

  app.addHook('onClose', async () => {
    await pool.end();
  });
});

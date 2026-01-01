'use strict';

const BULL_SCHEMA_SQL = `
  CREATE SCHEMA IF NOT EXISTS bull;

  CREATE TABLE IF NOT EXISTS bull.bull_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    queue text NOT NULL,
    payload jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
  );
`;

async function ensureBullStructures(db, logger) {
  try {
    await db.query(BULL_SCHEMA_SQL);
  } catch (err) {
    logger.warn(err, 'Failed to ensure bull schema');
  }
}

function createSystemService(db, logger) {
  ensureBullStructures(db, logger);

  return {
    async logQueueEvent(queue, payload) {
      if (!queue) return;

      try {
        await db.query(
          `INSERT INTO bull.bull_log (queue, payload)
           VALUES ($1, $2)`,
          [queue, payload || null]
        );
      } catch (err) {
        logger.warn(err, 'System log failed');
      }
    }
  };
}

module.exports = {
  createSystemService
};

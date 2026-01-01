'use strict';

const AUDIT_SCHEMA_SQL = `
  CREATE SCHEMA IF NOT EXISTS audit;

  CREATE TABLE IF NOT EXISTS audit.audit_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event text NOT NULL,
    payload jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
  );
`;

async function ensureAuditStructures(db, logger) {
  try {
    await db.query(AUDIT_SCHEMA_SQL);
  } catch (err) {
    logger.warn(err, 'Failed to ensure audit schema');
  }
}

async function insertAuditLog(db, entry, logger) {
  try {
    await db.query(
      `INSERT INTO audit.audit_log (event, payload)
       VALUES ($1, $2)`,
      [entry.event, entry.payload || null]
    );
  } catch (err) {
    logger.warn(err, 'Audit log failed');
  }
}

module.exports = {
  ensureAuditStructures,
  insertAuditLog
};

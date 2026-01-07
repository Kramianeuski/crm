export async function insertAuditLog(db, entry, logger) {
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

export async function insertAuditLog(db, entry, logger) {
  try {
    await db.query(
      `INSERT INTO audit.audit_log (event_type, entity_type, entity_id, actor_user_id, payload)
       VALUES ($1, $2, $3, $4, $5)`,
      [
        entry.eventType,
        entry.entityType || null,
        entry.entityId || null,
        entry.actorUserId || null,
        entry.payload || null
      ]
    );
  } catch (err) {
    logger.warn(err, 'Audit log failed');
  }
}

import { ensureAuditStructures, insertAuditLog } from './audit.repository.js';

export function createAuditService(db, logger) {
  ensureAuditStructures(db, logger);

  return {
    async logEvent(event, payload) {
      if (!event) return;

      try {
        await insertAuditLog(db, { event, payload }, logger);
      } catch (err) {
        logger.warn(err, 'Audit log failed');
      }
    }
  };
}

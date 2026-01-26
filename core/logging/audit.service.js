import { insertAuditLog } from './audit.repository.js';

export function createAuditService(db, logger) {
  return {
    async logEvent(eventType, payload, options = {}) {
      if (!eventType) return;

      try {
        await insertAuditLog(
          db,
          {
            eventType,
            payload,
            actorUserId: options.actorUserId,
            entityType: options.entityType,
            entityId: options.entityId
          },
          logger
        );
      } catch (err) {
        logger.warn(err, 'Audit log failed');
      }
    }
  };
}

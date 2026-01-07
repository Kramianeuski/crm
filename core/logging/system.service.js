export function createSystemService(db, logger) {
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

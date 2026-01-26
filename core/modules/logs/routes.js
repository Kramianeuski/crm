export default async function logsRoutes(fastify) {
  const ensureAccess = async (request, reply, resource, action) => {
    const allowed = await fastify.canAccess(request.user, resource, action);
    if (!allowed) {
      reply.code(403).send({ error: 'forbidden' });
      return false;
    }
    return true;
  };

  fastify.get('/audit', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'audit', 'view');
      if (!allowed) return reply;

      const { from, to, event, q, limit = 10, page = 1 } = request.query || {};
      const conditions = [];
      const values = [];

      if (from) {
        values.push(from);
        conditions.push(`al.created_at >= $${values.length}`);
      }
      if (to) {
        values.push(to);
        conditions.push(`al.created_at <= $${values.length}`);
      }
      if (event) {
        values.push(event);
        conditions.push(`al.event_type = $${values.length}`);
      }
      if (q) {
        values.push(`%${q}%`);
        conditions.push(`(al.event_type ILIKE $${values.length} OR al.payload::text ILIKE $${values.length})`);
      }

      const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
      const offset = (Number(page) - 1) * Number(limit);

      const { rows } = await fastify.pg.query(
        `
        SELECT
          al.id,
          al.event_type,
          al.entity_type,
          al.entity_id,
          al.payload,
          al.created_at,
          u.id AS actor_id,
          u.email AS actor_email
        FROM audit.audit_log al
        LEFT JOIN core.users u ON u.id = al.actor_user_id
        ${whereClause}
        ORDER BY al.created_at DESC
        LIMIT $${values.length + 1}
        OFFSET $${values.length + 2}
        `,
        [...values, Number(limit), offset]
      );

      const { rows: countRows } = await fastify.pg.query(
        `
        SELECT COUNT(*)::int AS total
        FROM audit.audit_log al
        ${whereClause}
        `,
        values
      );

      const logs = rows.map(row => ({
        id: row.id,
        event_type: row.event_type,
        event: row.event_type,
        entity_type: row.entity_type,
        entity_id: row.entity_id,
        entity: row.entity_type,
        payload: row.payload,
        created_at: row.created_at,
        user: row.actor_email || null,
        actor: row.actor_id ? { id: row.actor_id, email: row.actor_email } : null
      }));

      return reply.send({ logs, total: countRows[0]?.total ?? logs.length });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/logs/system', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'audit', 'view');
      if (!allowed) return reply;

      const { from, to, queue, q, limit = 10, page = 1 } = request.query || {};
      const conditions = [];
      const values = [];

      if (from) {
        values.push(from);
        conditions.push(`created_at >= $${values.length}`);
      }
      if (to) {
        values.push(to);
        conditions.push(`created_at <= $${values.length}`);
      }
      if (queue) {
        values.push(queue);
        conditions.push(`queue = $${values.length}`);
      }
      if (q) {
        values.push(`%${q}%`);
        conditions.push(`payload::text ILIKE $${values.length}`);
      }

      const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
      const offset = (Number(page) - 1) * Number(limit);

      const { rows } = await fastify.pg.query(
        `
        SELECT id, queue, payload, created_at
        FROM bull.bull_log
        ${whereClause}
        ORDER BY created_at DESC
        LIMIT $${values.length + 1}
        OFFSET $${values.length + 2}
        `,
        [...values, Number(limit), offset]
      );

      const { rows: countRows } = await fastify.pg.query(
        `
        SELECT COUNT(*)::int AS total
        FROM bull.bull_log
        ${whereClause}
        `,
        values
      );

      return reply.send({ logs: rows, total: countRows[0]?.total ?? rows.length });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

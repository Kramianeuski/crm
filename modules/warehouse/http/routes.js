import { WarehouseInService } from '../service/warehouse-in-service.js';
import { WarehouseOutService } from '../service/warehouse-out-service.js';
import { WarehouseTransferService } from '../service/warehouse-transfer-service.js';
import { WarehouseAdjustService } from '../service/warehouse-adjust-service.js';
import { AvailabilityService } from '../service/availability-service.js';

const requireAuth = async (request, reply) => {
  if (!request.user) {
    return reply.code(401).send({ error: 'unauthorized' });
  }
};

export default async function warehouseRoutes(fastify) {
  const preHandler = [fastify.verifyJWT, requireAuth];

  fastify.get('/warehouses', { preHandler }, async (request, reply) => {
    try {
      const { rows } = await fastify.pg.query(
        `SELECT id, code, name, city, is_company_stock, is_active, created_at
         FROM warehouse.warehouses
         ORDER BY name`
      );
      return reply.send({ warehouses: rows });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/users/me/default-warehouse', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      if (!payload.warehouse_id) {
        return reply.code(422).send({ error: 'missing_required_fields' });
      }

      await fastify.pg.query(
        `INSERT INTO core.user_preferences (user_id, key, value_json)
         VALUES ($1, 'default_warehouse_id', $2)
         ON CONFLICT (user_id, key) DO UPDATE
           SET value_json = EXCLUDED.value_json`,
        [request.user.id, { warehouse_id: payload.warehouse_id }]
      );

      return reply.send({ warehouse_id: payload.warehouse_id });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/warehouse/balances', { preHandler }, async (request, reply) => {
    try {
      const warehouseId = request.query.warehouse_id;
      const productId = request.query.product_id;
      const params = [];
      const conditions = [];

      if (warehouseId) {
        params.push(warehouseId);
        conditions.push(`warehouse_id = $${params.length}`);
      }

      if (productId) {
        params.push(productId);
        conditions.push(`product_id = $${params.length}`);
      }

      const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

      const { rows } = await fastify.pg.query(
        `SELECT warehouse_id, product_id, unit_id, qty
         FROM warehouse.stock_balances
         ${whereClause}`,
        params
      );

      return reply.send({ balances: rows });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/warehouse/movements', { preHandler }, async (request, reply) => {
    try {
      const warehouseId = request.query.warehouse_id;
      const productId = request.query.product_id;
      const params = [];
      const conditions = [];

      if (warehouseId) {
        params.push(warehouseId);
        conditions.push(`warehouse_id = $${params.length}`);
      }

      if (productId) {
        params.push(productId);
        conditions.push(`product_id = $${params.length}`);
      }

      const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

      const { rows } = await fastify.pg.query(
        `SELECT id, warehouse_id, product_id, unit_id, qty, movement_type, source_type, source_id, created_by, created_at
         FROM warehouse.stock_movements
         ${whereClause}
         ORDER BY created_at DESC`,
        params
      );

      return reply.send({ movements: rows });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/warehouse/in', { preHandler }, async (request, reply) => {
    try {
      const service = new WarehouseInService(fastify.pg);
      await service.execute({
        warehouseId: request.body?.warehouse_id,
        productId: request.body?.product_id,
        unitId: request.body?.unit_id,
        qty: request.body?.qty,
        sourceType: request.body?.source_type,
        sourceId: request.body?.source_id,
        userId: request.user.id
      });
      return reply.send({ status: 'ok' });
    } catch (err) {
      request.log.error(err);
      return reply.code(err.statusCode || 500).send({ error: err.message || 'internal_error' });
    }
  });

  fastify.post('/warehouse/out', { preHandler }, async (request, reply) => {
    try {
      const service = new WarehouseOutService(fastify.pg);
      await service.execute({
        warehouseId: request.body?.warehouse_id,
        productId: request.body?.product_id,
        unitId: request.body?.unit_id,
        qty: request.body?.qty,
        sourceType: request.body?.source_type,
        sourceId: request.body?.source_id,
        userId: request.user.id
      });
      return reply.send({ status: 'ok' });
    } catch (err) {
      request.log.error(err);
      return reply.code(err.statusCode || 500).send({ error: err.message || 'internal_error' });
    }
  });

  fastify.post('/warehouse/transfer', { preHandler }, async (request, reply) => {
    try {
      const service = new WarehouseTransferService(fastify.pg);
      await service.execute({
        fromWarehouseId: request.body?.from_warehouse_id,
        toWarehouseId: request.body?.to_warehouse_id,
        productId: request.body?.product_id,
        unitId: request.body?.unit_id,
        qty: request.body?.qty,
        userId: request.user.id
      });
      return reply.send({ status: 'ok' });
    } catch (err) {
      request.log.error(err);
      return reply.code(err.statusCode || 500).send({ error: err.message || 'internal_error' });
    }
  });

  fastify.post('/warehouse/adjust', { preHandler }, async (request, reply) => {
    try {
      const service = new WarehouseAdjustService(fastify.pg);
      await service.execute({
        warehouseId: request.body?.warehouse_id,
        productId: request.body?.product_id,
        unitId: request.body?.unit_id,
        qty: request.body?.qty,
        userId: request.user.id
      });
      return reply.send({ status: 'ok' });
    } catch (err) {
      request.log.error(err);
      return reply.code(err.statusCode || 500).send({ error: err.message || 'internal_error' });
    }
  });

  fastify.get('/availability', { preHandler }, async (request, reply) => {
    try {
      const productId = request.query.product_id;
      const warehouseId = request.query.warehouse_id;
      if (!productId || !warehouseId) {
        return reply.code(422).send({ error: 'missing_required_fields' });
      }

      const service = new AvailabilityService(fastify.pg);
      const availability = await service.getAvailability({
        productId,
        warehouseId,
        preferredSupplierId: request.query.supplier_id || null
      });

      return reply.send({
        product_id: productId,
        warehouse_id: warehouseId,
        available_date: availability.availableDate,
        reason: availability.reason,
        details: availability.details
      });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

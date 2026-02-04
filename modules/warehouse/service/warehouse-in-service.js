import { fetchBaseUnitId, fetchUnitMultiplier, toBaseQty } from '../domain/unit-conversion.js';
import { assertActiveProduct, assertActiveWarehouse } from './warehouse-service.js';

export class WarehouseInService {
  constructor(pg) {
    this.pg = pg;
  }

  async execute({
    warehouseId,
    productId,
    unitId,
    qty,
    sourceType,
    sourceId,
    userId
  }) {
    if (!warehouseId || !productId || !unitId) {
      const error = new Error('missing_required_fields');
      error.statusCode = 422;
      throw error;
    }

    await assertActiveWarehouse(this.pg, warehouseId);
    await assertActiveProduct(this.pg, productId);

    const baseUnitId = await fetchBaseUnitId(this.pg, productId);
    const multiplier = await fetchUnitMultiplier(this.pg, productId, unitId);
    const baseQty = toBaseQty(qty, multiplier);

    if (baseQty <= 0) {
      const error = new Error('qty_invalid');
      error.statusCode = 422;
      throw error;
    }

    await this.pg.query('BEGIN');

    try {
      await this.pg.query(
        `INSERT INTO warehouse.stock_movements
          (id, warehouse_id, product_id, unit_id, qty, movement_type, source_type, source_id, created_by, created_at)
         VALUES (gen_random_uuid(), $1, $2, $3, $4, 'in', $5, $6, $7, now())`,
        [warehouseId, productId, baseUnitId, baseQty, sourceType || null, sourceId || null, userId]
      );

      await this.pg.query(
        `INSERT INTO warehouse.stock_balances (warehouse_id, product_id, unit_id, qty)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (warehouse_id, product_id, unit_id)
         DO UPDATE SET qty = warehouse.stock_balances.qty + EXCLUDED.qty`,
        [warehouseId, productId, baseUnitId, baseQty]
      );

      await this.pg.query('COMMIT');
    } catch (err) {
      await this.pg.query('ROLLBACK').catch(() => null);
      throw err;
    }
  }
}

import { fetchBaseUnitId, fetchUnitMultiplier, toBaseQty } from '../domain/unit-conversion.js';
import { assertActiveProduct, assertActiveWarehouse } from './warehouse-service.js';

export class WarehouseTransferService {
  constructor(pg) {
    this.pg = pg;
  }

  async execute({
    fromWarehouseId,
    toWarehouseId,
    productId,
    unitId,
    qty,
    userId
  }) {
    if (!fromWarehouseId || !toWarehouseId || !productId || !unitId) {
      const error = new Error('missing_required_fields');
      error.statusCode = 422;
      throw error;
    }

    await assertActiveWarehouse(this.pg, fromWarehouseId);
    await assertActiveWarehouse(this.pg, toWarehouseId);
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
      const { rows } = await this.pg.query(
        `SELECT qty
         FROM warehouse.stock_balances
         WHERE warehouse_id = $1 AND product_id = $2 AND unit_id = $3
         FOR UPDATE`,
        [fromWarehouseId, productId, baseUnitId]
      );

      const currentQty = Number(rows[0]?.qty ?? 0);
      if (currentQty < baseQty) {
        const error = new Error('insufficient_stock');
        error.statusCode = 422;
        throw error;
      }

      await this.pg.query(
        `INSERT INTO warehouse.stock_movements
          (id, warehouse_id, product_id, unit_id, qty, movement_type, source_type, created_by, created_at)
         VALUES (gen_random_uuid(), $1, $2, $3, $4, 'transfer_out', 'transfer', $5, now())`,
        [fromWarehouseId, productId, baseUnitId, -baseQty, userId]
      );

      await this.pg.query(
        `INSERT INTO warehouse.stock_movements
          (id, warehouse_id, product_id, unit_id, qty, movement_type, source_type, created_by, created_at)
         VALUES (gen_random_uuid(), $1, $2, $3, $4, 'transfer_in', 'transfer', $5, now())`,
        [toWarehouseId, productId, baseUnitId, baseQty, userId]
      );

      await this.pg.query(
        `UPDATE warehouse.stock_balances
         SET qty = qty - $4
         WHERE warehouse_id = $1 AND product_id = $2 AND unit_id = $3`,
        [fromWarehouseId, productId, baseUnitId, baseQty]
      );

      await this.pg.query(
        `INSERT INTO warehouse.stock_balances (warehouse_id, product_id, unit_id, qty)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (warehouse_id, product_id, unit_id)
         DO UPDATE SET qty = warehouse.stock_balances.qty + EXCLUDED.qty`,
        [toWarehouseId, productId, baseUnitId, baseQty]
      );

      await this.pg.query('COMMIT');
    } catch (err) {
      await this.pg.query('ROLLBACK').catch(() => null);
      throw err;
    }
  }
}

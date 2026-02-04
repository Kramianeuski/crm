import { fetchBaseUnitId, fetchUnitMultiplier, toBaseQty } from '../domain/unit-conversion.js';
import { assertActiveProduct, assertActiveWarehouse } from './warehouse-service.js';

export class WarehouseAdjustService {
  constructor(pg) {
    this.pg = pg;
  }

  async execute({
    warehouseId,
    productId,
    unitId,
    qty,
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

    if (baseQty === 0) {
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
        [warehouseId, productId, baseUnitId]
      );

      const currentQty = Number(rows[0]?.qty ?? 0);
      const nextQty = currentQty + baseQty;
      if (nextQty < 0) {
        const error = new Error('insufficient_stock');
        error.statusCode = 422;
        throw error;
      }

      await this.pg.query(
        `INSERT INTO warehouse.stock_movements
          (id, warehouse_id, product_id, unit_id, qty, movement_type, source_type, created_by, created_at)
         VALUES (gen_random_uuid(), $1, $2, $3, $4, 'adjust', 'adjust', $5, now())`,
        [warehouseId, productId, baseUnitId, baseQty, userId]
      );

      if (rows[0]) {
        await this.pg.query(
          `UPDATE warehouse.stock_balances
           SET qty = qty + $4
           WHERE warehouse_id = $1 AND product_id = $2 AND unit_id = $3`,
          [warehouseId, productId, baseUnitId, baseQty]
        );
      } else {
        await this.pg.query(
          `INSERT INTO warehouse.stock_balances (warehouse_id, product_id, unit_id, qty)
           VALUES ($1, $2, $3, $4)`,
          [warehouseId, productId, baseUnitId, baseQty]
        );
      }

      await this.pg.query('COMMIT');
    } catch (err) {
      await this.pg.query('ROLLBACK').catch(() => null);
      throw err;
    }
  }
}

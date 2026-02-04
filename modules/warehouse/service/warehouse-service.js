export class WarehouseService {
  constructor(pg) {
    this.pg = pg;
  }

  async getBalance(warehouseId, productId) {
    const { rows } = await this.pg.query(
      `SELECT qty
       FROM warehouse.stock_balances
       WHERE warehouse_id = $1 AND product_id = $2`,
      [warehouseId, productId]
    );
    return Number(rows[0]?.qty ?? 0);
  }

  async assertEnoughStock(warehouseId, productId, qty) {
    const current = await this.getBalance(warehouseId, productId);
    if (current < qty) {
      const error = new Error('insufficient_stock');
      error.statusCode = 422;
      throw error;
    }
  }
}

export async function assertActiveWarehouse(pg, warehouseId) {
  const { rows } = await pg.query(
    `SELECT is_active
     FROM warehouse.warehouses
     WHERE id = $1`,
    [warehouseId]
  );
  if (!rows[0]) {
    const error = new Error('warehouse_not_found');
    error.statusCode = 404;
    throw error;
  }
  if (!rows[0].is_active) {
    const error = new Error('warehouse_inactive');
    error.statusCode = 422;
    throw error;
  }
}

export async function assertActiveProduct(pg, productId) {
  const { rows } = await pg.query(
    `SELECT is_active
     FROM products.products
     WHERE id = $1`,
    [productId]
  );
  if (!rows[0]) {
    const error = new Error('product_not_found');
    error.statusCode = 404;
    throw error;
  }
  if (!rows[0].is_active) {
    const error = new Error('product_inactive');
    error.statusCode = 422;
    throw error;
  }
}

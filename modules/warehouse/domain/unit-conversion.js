export async function fetchBaseUnitId(pg, productId) {
  const { rows } = await pg.query(
    `SELECT base_unit_id
     FROM products.products
     WHERE id = $1`,
    [productId]
  );
  if (!rows[0]) {
    const error = new Error('product_not_found');
    error.statusCode = 404;
    throw error;
  }
  return rows[0].base_unit_id;
}

export async function fetchUnitMultiplier(pg, productId, unitId) {
  const { rows } = await pg.query(
    `SELECT multiplier
     FROM products.product_units
     WHERE product_id = $1 AND unit_id = $2`,
    [productId, unitId]
  );
  if (!rows[0]) {
    const error = new Error('unit_multiplier_not_found');
    error.statusCode = 422;
    throw error;
  }
  return Number(rows[0].multiplier);
}

export function toBaseQty(qty, multiplier) {
  const numericQty = Number(qty);
  if (!Number.isFinite(numericQty)) {
    const error = new Error('qty_invalid');
    error.statusCode = 422;
    throw error;
  }
  return numericQty * multiplier;
}

export class AvailabilityService {
  constructor(pg) {
    this.pg = pg;
  }

  async getAvailability({ productId, warehouseId, preferredSupplierId }) {
    const today = new Date();

    const inStockDate = await this.#getInStockDate(productId, warehouseId, today);
    if (inStockDate) {
      return {
        availableDate: inStockDate,
        reason: 'in_stock',
        details: { warehouse_id: warehouseId }
      };
    }

    const transferCandidate = await this.#getTransferDate(productId, warehouseId, today);
    const supplierCandidate = await this.#getSupplierDate(productId, warehouseId, preferredSupplierId, today);

    const candidates = [transferCandidate, supplierCandidate].filter(Boolean);
    if (!candidates.length) {
      return {
        availableDate: null,
        reason: 'unknown',
        details: {}
      };
    }

    const best = candidates.sort((a, b) => a.availableDate - b.availableDate)[0];
    return best;
  }

  async #getInStockDate(productId, warehouseId, today) {
    const { rows } = await this.pg.query(
      `SELECT qty
       FROM warehouse.stock_balances
       WHERE warehouse_id = $1 AND product_id = $2`,
      [warehouseId, productId]
    );

    const qty = Number(rows[0]?.qty ?? 0);
    if (qty > 0) {
      return today;
    }
    return null;
  }

  async #getTransferDate(productId, warehouseId, today) {
    const { rows } = await this.pg.query(
      `SELECT sb.warehouse_id,
              sb.qty,
              wtl.transfer_days
       FROM warehouse.stock_balances sb
       JOIN warehouse.warehouse_transfer_lead_times wtl
         ON wtl.from_warehouse_id = sb.warehouse_id
        AND wtl.to_warehouse_id = $2
       WHERE sb.product_id = $1
         AND sb.qty > 0`,
      [productId, warehouseId]
    );

    if (!rows.length) return null;

    let best = null;
    for (const row of rows) {
      const candidate = new Date(today);
      candidate.setDate(candidate.getDate() + Number(row.transfer_days));
      if (!best || candidate < best.availableDate) {
        best = {
          availableDate: candidate,
          reason: 'transfer',
          details: {
            from_warehouse_id: row.warehouse_id,
            transfer_days: Number(row.transfer_days)
          }
        };
      }
    }

    return best;
  }

  async #getSupplierDate(productId, warehouseId, preferredSupplierId, today) {
    const supplierId = preferredSupplierId || await this.#getPrimarySupplierId(productId);

    const productLead = await this.pg.query(
      `SELECT supplier_id, lead_days
       FROM warehouse.product_supplier_warehouse_lead_times
       WHERE product_id = $1
         AND warehouse_id = $2
         AND ($3::uuid IS NULL OR supplier_id = $3)
       ORDER BY lead_days ASC
       LIMIT 1`,
      [productId, warehouseId, supplierId]
    );

    let leadRow = productLead.rows[0];

    if (!leadRow) {
      const defaultLead = await this.pg.query(
        `SELECT supplier_id, lead_days
         FROM warehouse.supplier_warehouse_lead_times
         WHERE warehouse_id = $1
           AND ($2::uuid IS NULL OR supplier_id = $2)
         ORDER BY lead_days ASC
         LIMIT 1`,
        [warehouseId, supplierId]
      );
      leadRow = defaultLead.rows[0];
    }

    if (!leadRow) return null;

    const candidate = new Date(today);
    candidate.setDate(candidate.getDate() + Number(leadRow.lead_days));

    return {
      availableDate: candidate,
      reason: 'supplier',
      details: {
        supplier_id: leadRow.supplier_id,
        lead_days: Number(leadRow.lead_days)
      }
    };
  }

  async #getPrimarySupplierId(productId) {
    const { rows } = await this.pg.query(
      `SELECT supplier_id
       FROM products.product_suppliers
       WHERE product_id = $1 AND is_primary = true
       LIMIT 1`,
      [productId]
    );
    return rows[0]?.supplier_id || null;
  }
}

export async function fetchProducts(pg, { lang, categoryId, brandId, isActive }) {
  const conditions = [];
  const values = [lang];
  let index = values.length;

  if (categoryId) {
    index += 1;
    conditions.push(`p.category_id = $${index}`);
    values.push(categoryId);
  }

  if (brandId) {
    index += 1;
    conditions.push(`p.brand_id = $${index}`);
    values.push(brandId);
  }

  if (typeof isActive === 'boolean') {
    index += 1;
    conditions.push(`p.is_active = $${index}`);
    values.push(isActive);
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';

  const { rows } = await pg.query(
    `SELECT p.id,
            p.sku,
            p.brand_id,
            p.category_id,
            p.base_unit_id,
            p.is_active,
            p.created_at,
            p.updated_at,
            pi.name,
            pi.description
     FROM products.products p
     LEFT JOIN products.product_i18n pi
       ON pi.product_id = p.id AND pi.lang = $1
     ${whereClause}
     ORDER BY p.created_at DESC`,
    values
  );

  return rows;
}

export async function fetchProduct(pg, { id, lang }) {
  const { rows } = await pg.query(
    `SELECT p.id,
            p.sku,
            p.brand_id,
            p.category_id,
            p.base_unit_id,
            p.is_active,
            p.created_at,
            p.updated_at,
            pi.name,
            pi.description
     FROM products.products p
     LEFT JOIN products.product_i18n pi
       ON pi.product_id = p.id AND pi.lang = $2
     WHERE p.id = $1`,
    [id, lang]
  );

  return rows[0] || null;
}

export async function insertProduct(pg, payload) {
  await pg.query(
    `INSERT INTO products.products (id, sku, brand_id, category_id, base_unit_id, is_active)
     VALUES ($1, $2, $3, $4, $5, $6)`,
    [
      payload.id,
      payload.sku,
      payload.brand_id,
      payload.category_id,
      payload.base_unit_id,
      payload.is_active
    ]
  );

  if (payload.name) {
    await pg.query(
      `INSERT INTO products.product_i18n (product_id, lang, name, description)
       VALUES ($1, $2, $3, $4)`,
      [payload.id, payload.lang, payload.name, payload.description]
    );
  }
}

export async function updateProduct(pg, payload) {
  await pg.query(
    `UPDATE products.products
     SET sku = $2,
         brand_id = $3,
         category_id = $4,
         base_unit_id = $5,
         is_active = $6,
         updated_at = now()
     WHERE id = $1`,
    [
      payload.id,
      payload.sku,
      payload.brand_id,
      payload.category_id,
      payload.base_unit_id,
      payload.is_active
    ]
  );

  if (payload.name) {
    await pg.query(
      `INSERT INTO products.product_i18n (product_id, lang, name, description)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (product_id, lang) DO UPDATE
         SET name = EXCLUDED.name,
             description = EXCLUDED.description`,
      [payload.id, payload.lang, payload.name, payload.description]
    );
  }
}

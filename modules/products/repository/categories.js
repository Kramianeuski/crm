export async function fetchCategories(pg, lang) {
  const { rows } = await pg.query(
    `SELECT c.id,
            c.parent_id,
            c.code,
            c.slug,
            c.is_active,
            c.sort_order,
            c.created_at,
            c.updated_at,
            ci.name,
            ci.description
     FROM products.categories c
     LEFT JOIN products.category_i18n ci
       ON ci.category_id = c.id AND ci.lang = $1
     ORDER BY c.sort_order, c.created_at`,
    [lang]
  );
  return rows;
}

export async function insertCategory(pg, payload) {
  await pg.query(
    `INSERT INTO products.categories (id, parent_id, code, slug, is_active, sort_order)
     VALUES ($1, $2, $3, $4, $5, $6)`,
    [
      payload.id,
      payload.parent_id,
      payload.code,
      payload.slug,
      payload.is_active,
      payload.sort_order
    ]
  );

  if (payload.name) {
    await pg.query(
      `INSERT INTO products.category_i18n (category_id, lang, name, description)
       VALUES ($1, $2, $3, $4)`,
      [payload.id, payload.lang, payload.name, payload.description]
    );
  }
}

export async function updateCategory(pg, payload) {
  await pg.query(
    `UPDATE products.categories
     SET parent_id = $2,
         code = $3,
         slug = $4,
         is_active = $5,
         sort_order = $6,
         updated_at = now()
     WHERE id = $1`,
    [
      payload.id,
      payload.parent_id,
      payload.code,
      payload.slug,
      payload.is_active,
      payload.sort_order
    ]
  );

  if (payload.name) {
    await pg.query(
      `INSERT INTO products.category_i18n (category_id, lang, name, description)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (category_id, lang) DO UPDATE
         SET name = EXCLUDED.name,
             description = EXCLUDED.description`,
      [payload.id, payload.lang, payload.name, payload.description]
    );
  }
}

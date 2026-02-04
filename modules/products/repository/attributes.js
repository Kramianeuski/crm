export async function fetchAttributes(pg, lang) {
  const { rows } = await pg.query(
    `SELECT a.id,
            a.code,
            a.value_type,
            a.unit_id,
            a.is_system,
            a.is_filterable,
            a.is_required,
            a.sort_order,
            ai.name
     FROM products.attributes a
     LEFT JOIN products.attribute_i18n ai
       ON ai.attribute_id = a.id AND ai.lang = $1
     ORDER BY a.sort_order, a.code`,
    [lang]
  );
  return rows;
}

export async function insertAttribute(pg, payload) {
  await pg.query(
    `INSERT INTO products.attributes
      (id, code, value_type, unit_id, is_system, is_filterable, is_required, sort_order)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
    [
      payload.id,
      payload.code,
      payload.value_type,
      payload.unit_id,
      payload.is_system,
      payload.is_filterable,
      payload.is_required,
      payload.sort_order
    ]
  );

  if (payload.name) {
    await pg.query(
      `INSERT INTO products.attribute_i18n (attribute_id, lang, name)
       VALUES ($1, $2, $3)`,
      [payload.id, payload.lang, payload.name]
    );
  }
}

export async function upsertAttributeValues(pg, productId, values) {
  await pg.query(
    `DELETE FROM products.product_attribute_values
     WHERE product_id = $1`,
    [productId]
  );

  for (const value of values) {
    await pg.query(
      `INSERT INTO products.product_attribute_values
        (product_id, attribute_id, value_string, value_number, value_bool, value_enum)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [
        productId,
        value.attribute_id,
        value.value_string,
        value.value_number,
        value.value_bool,
        value.value_enum
      ]
    );
  }
}

export async function fetchAttributeTypes(pg, attributeIds) {
  if (!attributeIds.length) return [];
  const { rows } = await pg.query(
    `SELECT id, value_type
     FROM products.attributes
     WHERE id = ANY($1::uuid[])`,
    [attributeIds]
  );
  return rows;
}

export async function fetchEtimClasses(pg, version) {
  const params = [];
  let whereClause = '';
  if (version) {
    params.push(version);
    whereClause = 'WHERE etim_version = $1';
  }
  const { rows } = await pg.query(
    `SELECT id, etim_version, class_code, parent_class_code, title, is_active
     FROM products.etim_classes
     ${whereClause}
     ORDER BY class_code`,
    params
  );
  return rows;
}

export async function replaceCategoryEtimMap(pg, categoryId, mappings) {
  await pg.query(
    `DELETE FROM products.category_etim_map
     WHERE category_id = $1`,
    [categoryId]
  );

  for (const item of mappings) {
    await pg.query(
      `INSERT INTO products.category_etim_map
        (category_id, etim_class_id, priority, note)
       VALUES ($1, $2, $3, $4)`,
      [categoryId, item.etim_class_id, item.priority, item.note]
    );
  }
}

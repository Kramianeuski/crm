-- migrate:up

DO $$
DECLARE
  demo_enabled text := COALESCE(current_setting('app.seed_demo_data', true), 'true');
  category_electronics_id uuid;
  category_accessories_id uuid;
  attribute_color_id uuid;
  attribute_weight_id uuid;
BEGIN
  IF lower(demo_enabled) NOT IN ('1', 'true', 'on', 'yes') THEN
    RAISE NOTICE 'Skipping demo seed: app.seed_demo_data=%', demo_enabled;
    RETURN;
  END IF;

  INSERT INTO products.categories (code, slug, sort_order, is_active)
  VALUES ('ELEC', 'electronics', 10, true)
  ON CONFLICT (code) DO UPDATE
    SET slug = EXCLUDED.slug,
        sort_order = EXCLUDED.sort_order,
        is_active = EXCLUDED.is_active
  RETURNING id INTO category_electronics_id;

  IF category_electronics_id IS NULL THEN
    SELECT id INTO category_electronics_id FROM products.categories WHERE code = 'ELEC';
  END IF;

  INSERT INTO products.categories (code, slug, sort_order, parent_id, is_active)
  VALUES ('ELEC-ACC', 'electronics-accessories', 20, category_electronics_id, true)
  ON CONFLICT (code) DO UPDATE
    SET slug = EXCLUDED.slug,
        sort_order = EXCLUDED.sort_order,
        parent_id = EXCLUDED.parent_id,
        is_active = EXCLUDED.is_active
  RETURNING id INTO category_accessories_id;

  IF category_accessories_id IS NULL THEN
    SELECT id INTO category_accessories_id FROM products.categories WHERE code = 'ELEC-ACC';
  END IF;

  INSERT INTO products.category_i18n (category_id, lang, name, description)
  VALUES
    (category_electronics_id, 'en', 'Electronics', 'Consumer electronics and devices'),
    (category_electronics_id, 'ru', 'Электроника', 'Бытовая и цифровая электроника'),
    (category_accessories_id, 'en', 'Accessories', 'Accessories and spare parts'),
    (category_accessories_id, 'ru', 'Аксессуары', 'Аксессуары и комплектующие')
  ON CONFLICT (category_id, lang) DO UPDATE
    SET name = EXCLUDED.name,
        description = EXCLUDED.description;

  INSERT INTO products.attributes (code, value_type, is_filterable, is_required, sort_order)
  VALUES ('COLOR', 'string', true, false, 10)
  ON CONFLICT (code) DO UPDATE
    SET value_type = EXCLUDED.value_type,
        is_filterable = EXCLUDED.is_filterable,
        is_required = EXCLUDED.is_required,
        sort_order = EXCLUDED.sort_order
  RETURNING id INTO attribute_color_id;

  IF attribute_color_id IS NULL THEN
    SELECT id INTO attribute_color_id FROM products.attributes WHERE code = 'COLOR';
  END IF;

  INSERT INTO products.attributes (code, value_type, is_filterable, is_required, sort_order)
  VALUES ('WEIGHT', 'number', true, false, 20)
  ON CONFLICT (code) DO UPDATE
    SET value_type = EXCLUDED.value_type,
        is_filterable = EXCLUDED.is_filterable,
        is_required = EXCLUDED.is_required,
        sort_order = EXCLUDED.sort_order
  RETURNING id INTO attribute_weight_id;

  IF attribute_weight_id IS NULL THEN
    SELECT id INTO attribute_weight_id FROM products.attributes WHERE code = 'WEIGHT';
  END IF;

  INSERT INTO products.attribute_i18n (attribute_id, lang, name)
  VALUES
    (attribute_color_id, 'en', 'Color'),
    (attribute_color_id, 'ru', 'Цвет'),
    (attribute_weight_id, 'en', 'Weight'),
    (attribute_weight_id, 'ru', 'Вес')
  ON CONFLICT (attribute_id, lang) DO UPDATE
    SET name = EXCLUDED.name;

  INSERT INTO warehouse.warehouses (code, name, city, is_company_stock, is_active)
  VALUES ('WH-MAIN', 'Main Warehouse', 'Moscow', true, true)
  ON CONFLICT (code) DO UPDATE
    SET name = EXCLUDED.name,
        city = EXCLUDED.city,
        is_company_stock = EXCLUDED.is_company_stock,
        is_active = EXCLUDED.is_active;
END $$;

-- migrate:down

DELETE FROM warehouse.warehouses WHERE code = 'WH-MAIN';
DELETE FROM products.attribute_i18n WHERE attribute_id IN (
  SELECT id FROM products.attributes WHERE code IN ('COLOR', 'WEIGHT')
);
DELETE FROM products.attributes WHERE code IN ('COLOR', 'WEIGHT');
DELETE FROM products.category_i18n WHERE category_id IN (
  SELECT id FROM products.categories WHERE code IN ('ELEC-ACC', 'ELEC')
);
DELETE FROM products.categories WHERE code IN ('ELEC-ACC', 'ELEC');

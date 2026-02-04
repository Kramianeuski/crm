-- migrate:up

CREATE SCHEMA IF NOT EXISTS products;
CREATE SCHEMA IF NOT EXISTS warehouse;

CREATE TABLE IF NOT EXISTS core.user_preferences (
  user_id uuid NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
  key text NOT NULL,
  value_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  PRIMARY KEY (user_id, key)
);

CREATE TABLE IF NOT EXISTS products.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id uuid REFERENCES products.categories(id),
  code text UNIQUE NOT NULL,
  slug text UNIQUE NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS products.category_i18n (
  category_id uuid NOT NULL REFERENCES products.categories(id) ON DELETE CASCADE,
  lang text NOT NULL,
  name text NOT NULL,
  description text,
  PRIMARY KEY (category_id, lang)
);

CREATE TABLE IF NOT EXISTS products.etim_classes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  etim_version text NOT NULL,
  class_code text NOT NULL,
  parent_class_code text,
  title text,
  is_active boolean NOT NULL DEFAULT true,
  UNIQUE (etim_version, class_code)
);

CREATE TABLE IF NOT EXISTS products.category_etim_map (
  category_id uuid NOT NULL REFERENCES products.categories(id) ON DELETE CASCADE,
  etim_class_id uuid NOT NULL REFERENCES products.etim_classes(id) ON DELETE CASCADE,
  priority int NOT NULL DEFAULT 100,
  note text,
  PRIMARY KEY (category_id, etim_class_id)
);

CREATE TABLE IF NOT EXISTS products.brands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS products.units (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  is_base boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS products.unit_i18n (
  unit_id uuid NOT NULL REFERENCES products.units(id) ON DELETE CASCADE,
  lang text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (unit_id, lang)
);

CREATE TABLE IF NOT EXISTS products.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sku text UNIQUE NOT NULL,
  brand_id uuid REFERENCES products.brands(id),
  category_id uuid NOT NULL REFERENCES products.categories(id),
  base_unit_id uuid NOT NULL REFERENCES products.units(id),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS products.product_i18n (
  product_id uuid NOT NULL REFERENCES products.products(id) ON DELETE CASCADE,
  lang text NOT NULL,
  name text NOT NULL,
  description text,
  PRIMARY KEY (product_id, lang)
);

CREATE TABLE IF NOT EXISTS products.product_units (
  product_id uuid NOT NULL REFERENCES products.products(id) ON DELETE CASCADE,
  unit_id uuid NOT NULL REFERENCES products.units(id),
  multiplier numeric(18,6) NOT NULL,
  is_default_for_sales boolean NOT NULL DEFAULT false,
  PRIMARY KEY (product_id, unit_id)
);

CREATE TABLE IF NOT EXISTS products.attributes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  value_type text NOT NULL,
  unit_id uuid REFERENCES products.units(id),
  is_system boolean NOT NULL DEFAULT false,
  is_filterable boolean NOT NULL DEFAULT false,
  is_required boolean NOT NULL DEFAULT false,
  sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS products.attribute_i18n (
  attribute_id uuid NOT NULL REFERENCES products.attributes(id) ON DELETE CASCADE,
  lang text NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (attribute_id, lang)
);

CREATE TABLE IF NOT EXISTS products.product_attribute_values (
  product_id uuid NOT NULL REFERENCES products.products(id) ON DELETE CASCADE,
  attribute_id uuid NOT NULL REFERENCES products.attributes(id) ON DELETE CASCADE,
  value_string text,
  value_number numeric,
  value_bool boolean,
  value_enum text,
  PRIMARY KEY (product_id, attribute_id)
);

CREATE INDEX IF NOT EXISTS idx_products_category_id ON products.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products.products(sku);
CREATE INDEX IF NOT EXISTS idx_product_i18n_product_lang ON products.product_i18n(product_id, lang);
CREATE INDEX IF NOT EXISTS idx_product_attribute_values_attribute_number ON products.product_attribute_values(attribute_id, value_number);
CREATE INDEX IF NOT EXISTS idx_product_attribute_values_attribute_string ON products.product_attribute_values(attribute_id, value_string);
CREATE INDEX IF NOT EXISTS idx_product_attribute_values_product ON products.product_attribute_values(product_id);

CREATE TABLE IF NOT EXISTS products.suppliers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS products.product_suppliers (
  product_id uuid NOT NULL REFERENCES products.products(id) ON DELETE CASCADE,
  supplier_id uuid NOT NULL REFERENCES products.suppliers(id) ON DELETE CASCADE,
  is_primary boolean NOT NULL DEFAULT false,
  PRIMARY KEY (product_id, supplier_id)
);

CREATE TABLE IF NOT EXISTS warehouse.warehouses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  city text NOT NULL,
  is_company_stock boolean NOT NULL DEFAULT true,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS warehouse.warehouse_transfer_lead_times (
  from_warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id) ON DELETE CASCADE,
  to_warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id) ON DELETE CASCADE,
  transfer_days int NOT NULL,
  PRIMARY KEY (from_warehouse_id, to_warehouse_id)
);

CREATE TABLE IF NOT EXISTS warehouse.stock_movements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id),
  product_id uuid NOT NULL REFERENCES products.products(id),
  unit_id uuid NOT NULL REFERENCES products.units(id),
  qty numeric(18,6) NOT NULL,
  movement_type text NOT NULL,
  source_type text,
  source_id uuid,
  created_by uuid REFERENCES core.users(id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS warehouse.stock_balances (
  warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id),
  product_id uuid NOT NULL REFERENCES products.products(id),
  unit_id uuid NOT NULL REFERENCES products.units(id),
  qty numeric(18,6) NOT NULL,
  PRIMARY KEY (warehouse_id, product_id, unit_id)
);

CREATE INDEX IF NOT EXISTS idx_stock_balances_warehouse_product ON warehouse.stock_balances(warehouse_id, product_id);
CREATE INDEX IF NOT EXISTS idx_stock_movements_warehouse_product_created ON warehouse.stock_movements(warehouse_id, product_id, created_at);

CREATE TABLE IF NOT EXISTS warehouse.supplier_warehouse_lead_times (
  supplier_id uuid NOT NULL REFERENCES products.suppliers(id) ON DELETE CASCADE,
  warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id) ON DELETE CASCADE,
  lead_days int NOT NULL,
  PRIMARY KEY (supplier_id, warehouse_id)
);

CREATE TABLE IF NOT EXISTS warehouse.product_supplier_warehouse_lead_times (
  product_id uuid NOT NULL REFERENCES products.products(id) ON DELETE CASCADE,
  supplier_id uuid NOT NULL REFERENCES products.suppliers(id) ON DELETE CASCADE,
  warehouse_id uuid NOT NULL REFERENCES warehouse.warehouses(id) ON DELETE CASCADE,
  lead_days int NOT NULL,
  PRIMARY KEY (product_id, supplier_id, warehouse_id)
);

-- migrate:down

DROP TABLE IF EXISTS warehouse.product_supplier_warehouse_lead_times;
DROP TABLE IF EXISTS warehouse.supplier_warehouse_lead_times;
DROP INDEX IF EXISTS idx_stock_movements_warehouse_product_created;
DROP INDEX IF EXISTS idx_stock_balances_warehouse_product;
DROP TABLE IF EXISTS warehouse.stock_balances;
DROP TABLE IF EXISTS warehouse.stock_movements;
DROP TABLE IF EXISTS warehouse.warehouse_transfer_lead_times;
DROP TABLE IF EXISTS warehouse.warehouses;
DROP TABLE IF EXISTS products.product_suppliers;
DROP TABLE IF EXISTS products.suppliers;
DROP INDEX IF EXISTS idx_product_attribute_values_product;
DROP INDEX IF EXISTS idx_product_attribute_values_attribute_string;
DROP INDEX IF EXISTS idx_product_attribute_values_attribute_number;
DROP INDEX IF EXISTS idx_product_i18n_product_lang;
DROP INDEX IF EXISTS idx_products_sku;
DROP INDEX IF EXISTS idx_products_category_id;
DROP TABLE IF EXISTS products.product_attribute_values;
DROP TABLE IF EXISTS products.attribute_i18n;
DROP TABLE IF EXISTS products.attributes;
DROP TABLE IF EXISTS products.product_units;
DROP TABLE IF EXISTS products.product_i18n;
DROP TABLE IF EXISTS products.products;
DROP TABLE IF EXISTS products.unit_i18n;
DROP TABLE IF EXISTS products.units;
DROP TABLE IF EXISTS products.brands;
DROP TABLE IF EXISTS products.category_etim_map;
DROP TABLE IF EXISTS products.etim_classes;
DROP TABLE IF EXISTS products.category_i18n;
DROP TABLE IF EXISTS products.categories;
DROP TABLE IF EXISTS core.user_preferences;
DROP SCHEMA IF EXISTS warehouse;
DROP SCHEMA IF EXISTS products;

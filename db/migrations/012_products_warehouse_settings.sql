-- migrate:up

INSERT INTO core.permissions (code, description)
VALUES
  ('products.catalog.view', 'View product catalog'),
  ('products.attributes.view', 'View product attributes'),
  ('warehouse.view', 'View warehouses')
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.settings_modules (code, title_key, icon, sort_order, is_system, enabled)
VALUES
  ('products', 'settings.products', 'products', 20, false, true),
  ('warehouse', 'settings.warehouse', 'warehouse', 30, false, true)
ON CONFLICT (code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      icon = EXCLUDED.icon,
      sort_order = EXCLUDED.sort_order,
      enabled = EXCLUDED.enabled;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'catalog', 'settings.products.catalog', 'products.catalog.view', 10
FROM core.settings_modules
WHERE code = 'products'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'attributes', 'settings.products.attributes', 'products.attributes.view', 20
FROM core.settings_modules
WHERE code = 'products'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'warehouses', 'settings.warehouse.list', 'warehouse.view', 10
FROM core.settings_modules
WHERE code = 'warehouse'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.role_permissions (role_id, permission_id, scope)
SELECT r.id, p.id, 'all'
FROM core.roles r
JOIN core.permissions p ON p.code IN (
  'products.catalog.view',
  'products.attributes.view',
  'warehouse.view'
)
WHERE r.code IN ('super_admin', 'admin')
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO core.i18n_translations (key, language_code, value)
VALUES
  ('settings.products', 'en', 'Products'),
  ('settings.products', 'ru', 'Товары'),
  ('settings.products.catalog', 'en', 'Catalog'),
  ('settings.products.catalog', 'ru', 'Каталог'),
  ('settings.products.attributes', 'en', 'Attributes'),
  ('settings.products.attributes', 'ru', 'Атрибуты'),
  ('settings.warehouse', 'en', 'Warehouse'),
  ('settings.warehouse', 'ru', 'Склад'),
  ('settings.warehouse.list', 'en', 'Warehouses'),
  ('settings.warehouse.list', 'ru', 'Склады')
ON CONFLICT (key, language_code) DO UPDATE
  SET value = EXCLUDED.value;

INSERT INTO core.translations (key, lang, value, updated_at)
VALUES
  ('settings.products', 'en', 'Products', now()),
  ('settings.products', 'ru', 'Товары', now()),
  ('settings.products.catalog', 'en', 'Catalog', now()),
  ('settings.products.catalog', 'ru', 'Каталог', now()),
  ('settings.products.attributes', 'en', 'Attributes', now()),
  ('settings.products.attributes', 'ru', 'Атрибуты', now()),
  ('settings.warehouse', 'en', 'Warehouse', now()),
  ('settings.warehouse', 'ru', 'Склад', now()),
  ('settings.warehouse.list', 'en', 'Warehouses', now()),
  ('settings.warehouse.list', 'ru', 'Склады', now())
ON CONFLICT (key, lang) DO UPDATE
  SET value = EXCLUDED.value,
      updated_at = now();

-- migrate:down

-- Intentionally left minimal.

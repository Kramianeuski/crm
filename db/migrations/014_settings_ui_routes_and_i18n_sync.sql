-- migrate:up

ALTER TABLE core.settings_pages
  ADD COLUMN IF NOT EXISTS ui_route text;

UPDATE core.settings_pages AS sp
SET ui_route = CASE
  WHEN sm.code = 'core' AND sp.code = 'system' THEN '/settings#system-general'
  WHEN sm.code = 'core' AND sp.code = 'users' THEN '/settings#users-list'
  WHEN sm.code = 'core' AND sp.code = 'roles' THEN '/settings#roles'
  WHEN sm.code = 'core' AND sp.code = 'languages' THEN '/settings#languages'
  WHEN sm.code = 'core' AND sp.code = 'audit' THEN '/settings#audit'
  WHEN sm.code = 'products' AND sp.code = 'catalog' THEN '/products/catalog'
  WHEN sm.code = 'products' AND sp.code = 'attributes' THEN '/products/attributes'
  WHEN sm.code = 'warehouse' AND sp.code = 'warehouses' THEN '/warehouse/warehouses'
  ELSE ui_route
END
FROM core.settings_modules AS sm
WHERE sm.id = sp.module_id;

INSERT INTO core.translations (key, lang, value, updated_at)
SELECT it.key, it.language_code, it.value, now()
FROM core.i18n_translations it
ON CONFLICT (key, lang) DO UPDATE
SET value = EXCLUDED.value,
    updated_at = now();

-- migrate:down

ALTER TABLE core.settings_pages
  DROP COLUMN IF EXISTS ui_route;

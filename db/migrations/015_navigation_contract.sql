-- migrate:up

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
  ELSE sp.ui_route
END
FROM core.settings_modules AS sm
WHERE sm.id = sp.module_id
  AND (sp.ui_route IS NULL OR sp.ui_route = '');

ALTER TABLE core.settings_pages
  ALTER COLUMN ui_route SET NOT NULL;

ALTER TABLE core.settings_pages
  DROP CONSTRAINT IF EXISTS settings_pages_ui_route_format_chk;

ALTER TABLE core.settings_pages
  ADD CONSTRAINT settings_pages_ui_route_format_chk
  CHECK (ui_route ~ '^/');

CREATE UNIQUE INDEX IF NOT EXISTS ux_settings_pages_ui_route
  ON core.settings_pages (ui_route);

-- migrate:down

DROP INDEX IF EXISTS core.ux_settings_pages_ui_route;

ALTER TABLE core.settings_pages
  DROP CONSTRAINT IF EXISTS settings_pages_ui_route_format_chk;

ALTER TABLE core.settings_pages
  ALTER COLUMN ui_route DROP NOT NULL;

-- migrate:up

CREATE TABLE IF NOT EXISTS core.settings_values (
  module_code text NOT NULL,
  page_code text NOT NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  PRIMARY KEY (module_code, page_code)
);

INSERT INTO core.settings_modules (code, title_key, icon, sort_order, is_system, enabled)
VALUES ('core', 'settings_scope_core', 'settings', 10, true, true)
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'system', 'settings_nav_system', 'settings.view', 10
FROM core.settings_modules
WHERE code = 'core'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'users', 'settings_nav_users', 'users.view', 20
FROM core.settings_modules
WHERE code = 'core'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'roles', 'settings_nav_roles', 'roles.view', 30
FROM core.settings_modules
WHERE code = 'core'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'languages', 'settings_nav_languages', 'i18n.languages.view', 40
FROM core.settings_modules
WHERE code = 'core'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'audit', 'settings_nav_audit', 'audit.view', 50
FROM core.settings_modules
WHERE code = 'core'
ON CONFLICT (module_id, code) DO UPDATE
  SET title_key = EXCLUDED.title_key,
      permission_code = EXCLUDED.permission_code,
      sort_order = EXCLUDED.sort_order;

-- migrate:down

-- Intentionally left minimal.

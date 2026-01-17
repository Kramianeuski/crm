-- migrate:up

INSERT INTO core.roles (code, name_key)
VALUES
  ('admin', 'roles_admin_name'),
  ('manager', 'roles_manager_name')
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.translations (key, lang, value)
VALUES
  ('roles_admin_name', 'en', 'Administrator'),
  ('roles_admin_name', 'ru', 'Администратор')
ON CONFLICT (key, lang) DO UPDATE
  SET value = EXCLUDED.value;

-- migrate:down

-- Intentionally left minimal.

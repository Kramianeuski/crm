-- migrate:up

ALTER TABLE core.roles
  ALTER COLUMN id SET DEFAULT gen_random_uuid();

INSERT INTO core.roles (code, name_key)
VALUES
  ('super_admin', 'roles_super_admin_name'),
  ('admin', 'roles_admin_name'),
  ('manager', 'roles_manager_name')
ON CONFLICT (code) DO NOTHING;

INSERT INTO core.translations (key, lang, value)
VALUES
  ('roles_super_admin_name', 'en', 'Super administrator'),
  ('roles_super_admin_name', 'ru', 'Суперадминистратор'),
  ('roles_admin_name', 'en', 'Administrator'),
  ('roles_admin_name', 'ru', 'Администратор'),
  ('roles_manager_name', 'en', 'Manager'),
  ('roles_manager_name', 'ru', 'Менеджер')
ON CONFLICT (key, lang) DO UPDATE
  SET value = EXCLUDED.value;

-- migrate:down

-- Intentionally left minimal.

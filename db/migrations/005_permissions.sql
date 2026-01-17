-- migrate:up

ALTER TABLE core.users
  ALTER COLUMN id SET DEFAULT gen_random_uuid();

INSERT INTO core.permissions (code, description)
VALUES
  ('settings.view', 'View system settings'),
  ('settings.edit', 'Edit system settings'),
  ('users.view', 'View users'),
  ('users.manage', 'Manage users'),
  ('users.roles.assign', 'Assign user roles'),
  ('users.admin.manage', 'Manage admin users'),
  ('roles.view', 'View roles'),
  ('roles.manage', 'Manage roles'),
  ('permissions.view', 'View permissions'),
  ('groups.view', 'View groups'),
  ('groups.manage', 'Manage groups'),
  ('authz.grants.view', 'View access grants'),
  ('authz.grants.manage', 'Manage access grants'),
  ('i18n.languages.view', 'View languages'),
  ('i18n.languages.manage', 'Manage languages'),
  ('i18n.translations.view', 'View translations'),
  ('i18n.translations.manage', 'Manage translations'),
  ('audit.view', 'View audit logs')
ON CONFLICT (code) DO NOTHING;

-- migrate:down

-- Intentionally left minimal.

-- migrate:up

INSERT INTO core.role_permissions (role_id, permission_id, scope)
SELECT r.id, p.id, 'all'
FROM core.roles r
CROSS JOIN core.permissions p
WHERE r.code = 'super_admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO core.role_permissions (role_id, permission_id, scope)
SELECT r.id, p.id, 'all'
FROM core.roles r
JOIN core.permissions p ON p.code != 'users.admin.manage'
WHERE r.code = 'admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO core.role_permissions (role_id, permission_id, scope)
SELECT r.id, p.id, 'all'
FROM core.roles r
JOIN core.permissions p ON p.code IN (
  'settings.view',
  'users.view',
  'roles.view',
  'permissions.view',
  'groups.view',
  'authz.grants.view',
  'i18n.languages.view',
  'i18n.translations.view',
  'audit.view'
)
WHERE r.code = 'manager'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- migrate:down

-- Intentionally left minimal.

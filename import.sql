\connect crm;

BEGIN;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Settings key/value storage
CREATE TABLE IF NOT EXISTS core.settings (
    key text PRIMARY KEY,
    value jsonb NOT NULL,
    updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO core.settings (key, value)
VALUES
    ('system.general', jsonb_build_object(
        'system_name', 'Core platform',
        'default_language', 'en',
        'timezone', 'UTC',
        'developer_mode', true
    )),
    ('system.security', jsonb_build_object(
        'enable_local_passwords', true,
        'enable_sso', false,
        'jwt_ttl', 60,
        'allow_multiple_sessions', false
    ))
ON CONFLICT (key) DO UPDATE
SET value = EXCLUDED.value,
    updated_at = now();

-- Languages
INSERT INTO core.languages (code, title, enabled)
VALUES
    ('en', 'English', true),
    ('ru', 'Русский', true),
    ('de', 'Deutsch', false)
ON CONFLICT (code) DO UPDATE
SET title = EXCLUDED.title,
    enabled = EXCLUDED.enabled;

-- Permissions
INSERT INTO core.permissions (code, description)
VALUES
    ('settings.view', 'Access to Settings root'),
    ('system.manage', 'Manage system settings'),
    ('users.manage', 'Manage users and org structure'),
    ('roles.manage', 'Manage roles and access policies'),
    ('languages.manage', 'Manage languages and translations'),
    ('audit.view', 'View audit logs')
ON CONFLICT (code) DO UPDATE
SET description = EXCLUDED.description;

-- Roles
INSERT INTO core.roles (id, code, name_key)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'owner', 'role.owner'),
    ('22222222-2222-2222-2222-222222222222', 'manager', 'role.department_manager'),
    ('33333333-3333-3333-3333-333333333333', 'viewer', 'role.read_only')
ON CONFLICT (code) DO UPDATE
SET name_key = EXCLUDED.name_key;

-- Link permissions to roles with scope
WITH perm AS (
    SELECT id, code FROM core.permissions WHERE code IN (
        'settings.view', 'system.manage', 'users.manage', 'roles.manage', 'languages.manage', 'audit.view'
    )
), role_map AS (
    SELECT id, code FROM core.roles WHERE code IN ('owner', 'manager', 'viewer')
), desired AS (
    SELECT r.id AS role_id, p.id AS permission_id,
           CASE
             WHEN r.code = 'owner' THEN 'all'
             WHEN r.code = 'manager' AND p.code = 'users.manage' THEN 'department'
             WHEN r.code = 'manager' THEN 'all'
             WHEN r.code = 'viewer' THEN 'own'
             ELSE 'none'
           END AS scope
    FROM role_map r
    CROSS JOIN perm p
    WHERE (r.code = 'owner')
       OR (r.code = 'manager' AND p.code IN ('settings.view', 'users.manage', 'audit.view'))
       OR (r.code = 'viewer' AND p.code IN ('settings.view', 'audit.view'))
)
INSERT INTO core.role_permissions (role_id, permission_id, scope)
SELECT role_id, permission_id, scope FROM desired
ON CONFLICT (role_id, permission_id) DO UPDATE SET scope = EXCLUDED.scope;

-- Users
INSERT INTO core.users (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'ceo@example.com', 'ceo', 'Elena', 'Morozova', 'Timeweb', 'Elena Morozova', 'ru', true),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'manager@example.com', 'manager', 'Ivan', 'Petrov', 'Timeweb', 'Ivan Petrov', 'en', true),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'contractor@example.com', 'contractor', 'Anna', 'Kuznetsova', 'Contractors Ltd', 'Anna Kuznetsova', 'en', false),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa4', 'ops@example.com', 'ops', 'Alex', 'Smirnov', 'Timeweb', 'Alex Smirnov', 'ru', true)
ON CONFLICT (email) DO UPDATE
SET first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    company_name = EXCLUDED.company_name,
    display_name = EXCLUDED.display_name,
    lang = EXCLUDED.lang,
    is_active = EXCLUDED.is_active;

-- User roles
WITH role_map AS (
    SELECT code, id FROM core.roles
), user_map AS (
    SELECT email, id FROM core.users
)
INSERT INTO core.user_roles (user_id, role_id)
VALUES
    ((SELECT id FROM user_map WHERE email = 'ceo@example.com'), (SELECT id FROM role_map WHERE code = 'owner')),
    ((SELECT id FROM user_map WHERE email = 'manager@example.com'), (SELECT id FROM role_map WHERE code = 'manager')),
    ((SELECT id FROM user_map WHERE email = 'contractor@example.com'), (SELECT id FROM role_map WHERE code = 'viewer')),
    ((SELECT id FROM user_map WHERE email = 'ops@example.com'), (SELECT id FROM role_map WHERE code = 'viewer'))
ON CONFLICT DO NOTHING;

-- Groups
INSERT INTO core.groups (id, code, name_key)
VALUES
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', 'executive', 'group.executive'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc2', 'sales', 'group.sales'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc3', 'partners', 'group.partners'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc4', 'support', 'group.support')
ON CONFLICT (code) DO UPDATE
SET name_key = EXCLUDED.name_key;

-- User groups
WITH grp AS (SELECT code, id FROM core.groups), usr AS (SELECT email, id FROM core.users)
INSERT INTO core.user_groups (user_id, group_id)
VALUES
    ((SELECT id FROM usr WHERE email = 'ceo@example.com'), (SELECT id FROM grp WHERE code = 'executive')),
    ((SELECT id FROM usr WHERE email = 'manager@example.com'), (SELECT id FROM grp WHERE code = 'sales')),
    ((SELECT id FROM usr WHERE email = 'contractor@example.com'), (SELECT id FROM grp WHERE code = 'partners')),
    ((SELECT id FROM usr WHERE email = 'ops@example.com'), (SELECT id FROM grp WHERE code = 'support'))
ON CONFLICT DO NOTHING;

-- Departments
INSERT INTO core.departments (id, code, name_key, parent_id, manager_user_id)
VALUES
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'ceo-office', 'department.ceo_office', NULL, (SELECT id FROM core.users WHERE email = 'ceo@example.com')),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'sales', 'department.sales', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', (SELECT id FROM core.users WHERE email = 'manager@example.com')),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'operations', 'department.operations', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', (SELECT id FROM core.users WHERE email = 'ops@example.com'))
ON CONFLICT (code) DO UPDATE
SET name_key = EXCLUDED.name_key,
    parent_id = EXCLUDED.parent_id,
    manager_user_id = EXCLUDED.manager_user_id;

-- Department membership
WITH dept AS (SELECT code, id FROM core.departments), usr AS (SELECT email, id FROM core.users)
INSERT INTO core.department_users (department_id, user_id, is_primary)
VALUES
    ((SELECT id FROM dept WHERE code = 'ceo-office'), (SELECT id FROM usr WHERE email = 'ceo@example.com'), true),
    ((SELECT id FROM dept WHERE code = 'sales'), (SELECT id FROM usr WHERE email = 'manager@example.com'), true),
    ((SELECT id FROM dept WHERE code = 'sales'), (SELECT id FROM usr WHERE email = 'contractor@example.com'), false),
    ((SELECT id FROM dept WHERE code = 'operations'), (SELECT id FROM usr WHERE email = 'ops@example.com'), true)
ON CONFLICT DO NOTHING;

-- Access policies
INSERT INTO core.access_policies (id, subject_type, subject_id, resource, action, effect, conditions, priority, enabled)
VALUES
    (gen_random_uuid(), 'role', (SELECT id FROM core.roles WHERE code = 'manager'), 'orders', 'view', 'allow', '{"not": {"counterparty": "X"}}', 90, true),
    (gen_random_uuid(), 'role', (SELECT id FROM core.roles WHERE code = 'viewer'), 'records', 'view', 'allow', '{"owner_only": true}', 100, true)
ON CONFLICT DO NOTHING;

-- Audit log table and seed entries
CREATE TABLE IF NOT EXISTS audit.audit_log (
    id bigserial PRIMARY KEY,
    event text NOT NULL,
    payload jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO audit.audit_log (event, payload, created_at)
VALUES
    ('user.login', '{"user": "ceo@example.com", "ip": "10.0.0.4", "user_agent": "Chrome"}', '2024-08-01T09:15:00Z'),
    ('settings.updated', '{"user": "ceo@example.com", "entity": "core.settings", "key": "developer_mode", "value": true}', '2024-08-02T07:30:00Z'),
    ('user.invited', '{"user": "manager@example.com", "entity": "users", "email": "new.user@example.com", "department": "sales"}', '2024-08-02T10:00:00Z')
ON CONFLICT DO NOTHING;

COMMIT;

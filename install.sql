\connect crm;
/* ============================================================
   CORE MIGRATION V1
   Final Core DB structure (RBAC + Org + Policies + Settings)
   ============================================================ */

BEGIN;

-- ============================================================
-- EXTENSIONS & SCHEMAS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS bull;
CREATE SCHEMA IF NOT EXISTS ext;

-- ============================================================
-- 1. USERS & AUTH
-- ============================================================
CREATE TABLE IF NOT EXISTS core.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    lang TEXT NOT NULL DEFAULT 'en',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.user_passwords (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
    password_hash TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.user_identities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
    provider TEXT NOT NULL,
    external_id TEXT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (provider, external_id)
);

-- ============================================================
-- 2. I18N
-- ============================================================
CREATE TABLE IF NOT EXISTS core.languages (
    code TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lang_code TEXT NOT NULL REFERENCES core.languages(code) ON DELETE CASCADE,
    translation_key TEXT NOT NULL,
    translation_value TEXT NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (lang_code, translation_key)
);

CREATE TABLE IF NOT EXISTS core.translation_aliases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alias_key TEXT NOT NULL UNIQUE,
    target_key TEXT NOT NULL
);

-- ============================================================
-- 3. RBAC
-- ============================================================
CREATE TABLE IF NOT EXISTS core.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name_key TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.user_roles (
    user_id UUID NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES core.roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE IF NOT EXISTS core.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE core.permissions IS 'List of all possible permissions in system';

CREATE TABLE IF NOT EXISTS core.role_permissions (
    role_id UUID NOT NULL REFERENCES core.roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES core.permissions(id) ON DELETE CASCADE,
    scope TEXT NOT NULL CHECK (scope IN ('none','own','department','all')),
    PRIMARY KEY (role_id, permission_id)
);

COMMENT ON TABLE core.role_permissions IS 'Permissions assigned to roles with scope';

-- ============================================================
-- 4. GROUPS (logical grouping of users)
-- ============================================================
CREATE TABLE IF NOT EXISTS core.groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name_key TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.user_groups (
    user_id UUID NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
    group_id UUID NOT NULL REFERENCES core.groups(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
);

CREATE TABLE IF NOT EXISTS core.group_roles (
    group_id UUID NOT NULL REFERENCES core.groups(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES core.roles(id) ON DELETE CASCADE,
    PRIMARY KEY (group_id, role_id)
);

COMMENT ON TABLE core.groups IS 'User groups (not roles)';
COMMENT ON TABLE core.user_groups IS 'Users assigned to groups';
COMMENT ON TABLE core.group_roles IS 'Roles assigned to groups';

-- ============================================================
-- 5. ORG STRUCTURE (Departments & hierarchy)
-- ============================================================
CREATE TABLE IF NOT EXISTS core.departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name_key TEXT NOT NULL,
    parent_id UUID REFERENCES core.departments(id) ON DELETE SET NULL,
    manager_user_id UUID REFERENCES core.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.department_users (
    department_id UUID NOT NULL REFERENCES core.departments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES core.users(id) ON DELETE CASCADE,
    is_primary BOOLEAN NOT NULL DEFAULT true,
    PRIMARY KEY (department_id, user_id)
);

COMMENT ON TABLE core.departments IS 'Organizational departments with hierarchy';
COMMENT ON TABLE core.department_users IS 'Users assigned to departments';

-- ============================================================
-- 6. ACCESS POLICIES (ABAC over RBAC)
-- ============================================================
CREATE TABLE IF NOT EXISTS core.access_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_type TEXT NOT NULL CHECK (subject_type IN ('user','group','role')),
    subject_id UUID NOT NULL,
    resource TEXT NOT NULL,
    action TEXT NOT NULL,
    effect TEXT NOT NULL CHECK (effect IN ('allow','deny')),
    conditions JSONB,
    priority INT NOT NULL DEFAULT 100,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE core.access_policies IS 'Conditional access rules applied after RBAC';

-- ============================================================
-- 7. SETTINGS REGISTRY (Unified Settings App)
-- ============================================================
CREATE TABLE IF NOT EXISTS core.settings_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    title_key TEXT NOT NULL,
    icon TEXT,
    sort_order INT NOT NULL DEFAULT 100,
    is_system BOOLEAN NOT NULL DEFAULT false,
    enabled BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS core.settings_pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES core.settings_modules(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    title_key TEXT NOT NULL,
    permission_code TEXT NOT NULL,
    sort_order INT NOT NULL DEFAULT 100,
    UNIQUE (module_id, code)
);

CREATE TABLE IF NOT EXISTS core.settings_values (
    module_code TEXT NOT NULL,
    page_code TEXT NOT NULL,
    payload JSONB NOT NULL,
    updated_by UUID REFERENCES core.users(id) ON DELETE SET NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (module_code, page_code)
);

COMMENT ON TABLE core.settings_modules IS 'Modules registered in Settings application';
COMMENT ON TABLE core.settings_pages IS 'Pages of settings per module';
COMMENT ON TABLE core.settings_values IS 'Stored values for settings pages';

-- ============================================================
-- 8. LOGGING
-- ============================================================
CREATE TABLE IF NOT EXISTS audit.audit_log (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID,
    action TEXT NOT NULL,
    resource TEXT,
    entity_id UUID,
    meta JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bull.bull_log (
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    entity_id UUID,
    before_state JSONB,
    after_state JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ext.outbox_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_key TEXT NOT NULL,
    payload JSONB NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS ext.inbox_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_key TEXT NOT NULL,
    payload JSONB NOT NULL,
    status TEXT NOT NULL DEFAULT 'received',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ
);

-- ============================================================
-- 9. BASE SYSTEM PERMISSIONS
-- ============================================================
INSERT INTO core.permissions (code, description) VALUES
('settings.system.view', 'View system settings'),
('settings.system.edit', 'Edit system settings'),
('settings.users.view', 'View users'),
('settings.users.edit', 'Manage users'),
('settings.access.view', 'View access rules'),
('settings.access.edit', 'Edit access rules'),
('settings.languages.edit', 'Edit languages')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 10. SETTINGS MODULE REGISTRATION
-- ============================================================
INSERT INTO core.settings_modules (code, title_key, icon, sort_order, is_system)
VALUES ('system', 'settings.system.title', 'settings', 1, true)
ON CONFLICT DO NOTHING;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'core-info', 'settings.system.core_info', 'settings.system.view', 1
FROM core.settings_modules WHERE code = 'system'
ON CONFLICT DO NOTHING;

INSERT INTO core.settings_pages (module_id, code, title_key, permission_code, sort_order)
SELECT id, 'core-security', 'settings.system.security', 'settings.system.edit', 2
FROM core.settings_modules WHERE code = 'system'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 11. LANGUAGES SEED
-- ============================================================
INSERT INTO core.languages (code, title) VALUES
('en', 'English'),
('ru', 'Русский')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 12. ADMIN ROLE + USER
-- ============================================================
INSERT INTO core.roles (code, name_key, description)
VALUES ('admin', 'role.admin', 'Platform administrator')
ON CONFLICT (code) DO NOTHING;

-- Default admin user
INSERT INTO core.users (email, full_name, lang)
VALUES ('admin@sissol.ru', 'Admin User', 'ru')
ON CONFLICT (email) DO NOTHING;

-- Default password hash for admin@sissol.ru (argon2id, password: admin123)
DO $$
DECLARE
    admin_user_id UUID;
    existing_count INT;
BEGIN
    SELECT id INTO admin_user_id FROM core.users WHERE email = 'admin@sissol.ru';
    SELECT COUNT(*) INTO existing_count FROM core.user_passwords WHERE user_id = admin_user_id;

    IF admin_user_id IS NOT NULL AND existing_count = 0 THEN
        INSERT INTO core.user_passwords (user_id, password_hash, enabled)
        VALUES (
            admin_user_id,
            '$argon2id$v=19$m=65536,t=3,p=4$c29tZXNhbHQ$Xz7QL9ZhuttW60Agw7O3cu6UytzszbmWzxubAEANe0w',
            true
        );
    END IF;
END;
$$;

-- Attach admin role
DO $$
DECLARE
    admin_role_id UUID;
    admin_user_id UUID;
BEGIN
    SELECT id INTO admin_role_id FROM core.roles WHERE code = 'admin';
    SELECT id INTO admin_user_id FROM core.users WHERE email = 'admin@sissol.ru';

    IF admin_role_id IS NOT NULL AND admin_user_id IS NOT NULL THEN
        INSERT INTO core.user_roles (user_id, role_id)
        VALUES (admin_user_id, admin_role_id)
        ON CONFLICT DO NOTHING;
    END IF;
END;
$$;

-- Grant all permissions to admin
DO $$
DECLARE
    admin_role_id UUID;
BEGIN
    SELECT id INTO admin_role_id FROM core.roles WHERE code = 'admin';

    IF admin_role_id IS NOT NULL THEN
        INSERT INTO core.role_permissions (role_id, permission_id, scope)
        SELECT admin_role_id, p.id, 'all'
        FROM core.permissions p
        ON CONFLICT DO NOTHING;
    END IF;
END;
$$;

COMMIT;

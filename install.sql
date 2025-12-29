

\connect crm;
/* ============================================================
   CORE MIGRATION V1
   Final Core DB structure (RBAC + Org + Policies + Settings)
   ============================================================ */

BEGIN;

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- 1. RBAC: PERMISSIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS core.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE core.permissions IS 'List of all possible permissions in system';

-- ============================================================
-- 2. RBAC: ROLE PERMISSIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS core.role_permissions (
    role_id UUID NOT NULL REFERENCES core.roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES core.permissions(id) ON DELETE CASCADE,
    scope TEXT NOT NULL CHECK (scope IN ('none','own','department','all','view','edit')),
    PRIMARY KEY (role_id, permission_id)
);

COMMENT ON TABLE core.role_permissions IS 'Permissions assigned to roles with scope';

-- ============================================================
-- 3. GROUPS (logical grouping of users)
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
-- 4. ORG STRUCTURE (Departments & hierarchy)
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
-- 5. ACCESS POLICIES (ABAC over RBAC)
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
-- 6. SETTINGS REGISTRY (Unified Settings App)
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

COMMENT ON TABLE core.settings_modules IS 'Modules registered in Settings application';
COMMENT ON TABLE core.settings_pages IS 'Pages of settings per module';

-- ============================================================
-- 7. BASE SYSTEM PERMISSIONS
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
-- 8. SYSTEM SETTINGS MODULE REGISTRATION
-- ============================================================

INSERT INTO core.settings_modules (code, title_key, icon, sort_order, is_system)
VALUES ('system', 'settings.system.title', 'settings', 1, true)
ON CONFLICT DO NOTHING;

-- ============================================================
-- 9. ADMIN ROLE: FULL ACCESS
-- ============================================================

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

-- ============================================================
-- 10. ASSIGN ADMIN ROLE TO admin@sissol.ru
-- ============================================================

DO $$
DECLARE
    admin_user_id UUID;
    admin_role_id UUID;
BEGIN
    SELECT id INTO admin_user_id FROM core.users WHERE email = 'admin@sissol.ru';
    SELECT id INTO admin_role_id FROM core.roles WHERE code = 'admin';

    IF admin_user_id IS NOT NULL AND admin_role_id IS NOT NULL THEN
        INSERT INTO core.user_roles (user_id, role_id)
        VALUES (admin_user_id, admin_role_id)
        ON CONFLICT DO NOTHING;
    END IF;
END;
$$;

COMMIT;

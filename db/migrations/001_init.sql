--
-- PostgreSQL database dump
--

\restrict XApoc2xa8L9O293xDA8Sul0GLRNLYwUoSu3Obtqf0K0dCrJbOt0eWQQEDaTs6j4

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: bull; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bull;


--
-- Name: core; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA core;


--
-- Name: ext; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ext;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_policies; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.access_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_type text NOT NULL,
    subject_id uuid NOT NULL,
    resource text NOT NULL,
    action text NOT NULL,
    effect text NOT NULL,
    conditions jsonb,
    priority integer DEFAULT 100 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT access_policies_effect_check CHECK ((effect = ANY (ARRAY['allow'::text, 'deny'::text]))),
    CONSTRAINT access_policies_subject_type_check CHECK ((subject_type = ANY (ARRAY['user'::text, 'group'::text, 'role'::text])))
);


--
-- Name: TABLE access_policies; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.access_policies IS 'Conditional access rules applied after RBAC';


--
-- Name: department_users; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.department_users (
    department_id uuid NOT NULL,
    user_id uuid NOT NULL,
    is_primary boolean DEFAULT true NOT NULL
);


--
-- Name: TABLE department_users; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.department_users IS 'Users assigned to departments';


--
-- Name: departments; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name_key text NOT NULL,
    parent_id uuid,
    manager_user_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE departments; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.departments IS 'Organizational departments with hierarchy';


--
-- Name: group_roles; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.group_roles (
    group_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: TABLE group_roles; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.group_roles IS 'Roles assigned to groups';


--
-- Name: groups; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE groups; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.groups IS 'User groups (not roles)';


--
-- Name: languages; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.languages (
    code text NOT NULL,
    title text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: permissions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE permissions; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.permissions IS 'List of all possible permissions in system';


--
-- Name: role_permissions; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    scope text NOT NULL,
    CONSTRAINT role_permissions_scope_check CHECK ((scope = ANY (ARRAY['none'::text, 'own'::text, 'department'::text, 'all'::text, 'view'::text, 'edit'::text])))
);


--
-- Name: TABLE role_permissions; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.role_permissions IS 'Permissions assigned to roles with scope';


--
-- Name: roles; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.roles (
    id uuid NOT NULL,
    code text NOT NULL,
    name_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: settings_modules; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.settings_modules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    title_key text NOT NULL,
    icon text,
    sort_order integer DEFAULT 100 NOT NULL,
    is_system boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


--
-- Name: TABLE settings_modules; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.settings_modules IS 'Modules registered in Settings application';


--
-- Name: settings_pages; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.settings_pages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    module_id uuid NOT NULL,
    code text NOT NULL,
    title_key text NOT NULL,
    permission_code text NOT NULL,
    sort_order integer DEFAULT 100 NOT NULL
);


--
-- Name: TABLE settings_pages; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.settings_pages IS 'Pages of settings per module';


--
-- Name: translation_aliases; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.translation_aliases (
    from_key text NOT NULL,
    to_key text NOT NULL,
    reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: translations; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.translations (
    key text NOT NULL,
    lang text NOT NULL,
    value text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_groups; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.user_groups (
    user_id uuid NOT NULL,
    group_id uuid NOT NULL
);


--
-- Name: TABLE user_groups; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.user_groups IS 'Users assigned to groups';


--
-- Name: user_identities; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.user_identities (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    provider text NOT NULL,
    issuer text,
    subject text NOT NULL,
    email text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_identities_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

CREATE SEQUENCE core.user_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: -
--

ALTER SEQUENCE core.user_identities_id_seq OWNED BY core.user_identities.id;


--
-- Name: user_passwords; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.user_passwords (
    user_id uuid NOT NULL,
    password_hash text NOT NULL,
    algo text DEFAULT 'argon2id'::text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_roles; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.users (
    id uuid NOT NULL,
    email text NOT NULL,
    login text,
    first_name text,
    last_name text,
    company_name text,
    display_name text,
    lang text DEFAULT 'ru'::text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_identities id; Type: DEFAULT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_identities ALTER COLUMN id SET DEFAULT nextval('core.user_identities_id_seq'::regclass);


--
-- Name: access_policies access_policies_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.access_policies
    ADD CONSTRAINT access_policies_pkey PRIMARY KEY (id);


--
-- Name: department_users department_users_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department_users
    ADD CONSTRAINT department_users_pkey PRIMARY KEY (department_id, user_id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: group_roles group_roles_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.group_roles
    ADD CONSTRAINT group_roles_pkey PRIMARY KEY (group_id, role_id);


--
-- Name: groups groups_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.groups
    ADD CONSTRAINT groups_code_key UNIQUE (code);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (code);


--
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (code);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.roles
    ADD CONSTRAINT roles_code_key UNIQUE (code);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: settings_modules settings_modules_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.settings_modules
    ADD CONSTRAINT settings_modules_code_key UNIQUE (code);


--
-- Name: settings_modules settings_modules_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.settings_modules
    ADD CONSTRAINT settings_modules_pkey PRIMARY KEY (id);


--
-- Name: settings_pages settings_pages_module_id_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.settings_pages
    ADD CONSTRAINT settings_pages_module_id_code_key UNIQUE (module_id, code);


--
-- Name: settings_pages settings_pages_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.settings_pages
    ADD CONSTRAINT settings_pages_pkey PRIMARY KEY (id);


--
-- Name: translation_aliases translation_aliases_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.translation_aliases
    ADD CONSTRAINT translation_aliases_pkey PRIMARY KEY (from_key);


--
-- Name: translations translations_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (key, lang);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (user_id, group_id);


--
-- Name: user_identities user_identities_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_identities
    ADD CONSTRAINT user_identities_pkey PRIMARY KEY (id);


--
-- Name: user_identities user_identities_provider_subject_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_identities
    ADD CONSTRAINT user_identities_provider_subject_key UNIQUE (provider, subject);


--
-- Name: user_passwords user_passwords_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_passwords
    ADD CONSTRAINT user_passwords_pkey PRIMARY KEY (user_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_login_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: department_users department_users_department_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department_users
    ADD CONSTRAINT department_users_department_id_fkey FOREIGN KEY (department_id) REFERENCES core.departments(id) ON DELETE CASCADE;


--
-- Name: department_users department_users_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department_users
    ADD CONSTRAINT department_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES core.users(id) ON DELETE CASCADE;


--
-- Name: departments departments_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_manager_user_id_fkey FOREIGN KEY (manager_user_id) REFERENCES core.users(id) ON DELETE SET NULL;


--
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES core.departments(id) ON DELETE SET NULL;


--
-- Name: group_roles group_roles_group_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.group_roles
    ADD CONSTRAINT group_roles_group_id_fkey FOREIGN KEY (group_id) REFERENCES core.groups(id) ON DELETE CASCADE;


--
-- Name: group_roles group_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.group_roles
    ADD CONSTRAINT group_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES core.roles(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES core.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES core.roles(id) ON DELETE CASCADE;


--
-- Name: settings_pages settings_pages_module_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.settings_pages
    ADD CONSTRAINT settings_pages_module_id_fkey FOREIGN KEY (module_id) REFERENCES core.settings_modules(id) ON DELETE CASCADE;


--
-- Name: translations translations_lang_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.translations
    ADD CONSTRAINT translations_lang_fkey FOREIGN KEY (lang) REFERENCES core.languages(code);


--
-- Name: user_groups user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_groups
    ADD CONSTRAINT user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES core.groups(id) ON DELETE CASCADE;


--
-- Name: user_groups user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_groups
    ADD CONSTRAINT user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES core.users(id) ON DELETE CASCADE;


--
-- Name: user_identities user_identities_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_identities
    ADD CONSTRAINT user_identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES core.users(id) ON DELETE CASCADE;


--
-- Name: user_passwords user_passwords_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_passwords
    ADD CONSTRAINT user_passwords_user_id_fkey FOREIGN KEY (user_id) REFERENCES core.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES core.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES core.users(id) ON DELETE CASCADE;


--
-- Name: users users_lang_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.users
    ADD CONSTRAINT users_lang_fkey FOREIGN KEY (lang) REFERENCES core.languages(code);


--
-- PostgreSQL database dump complete
--

\unrestrict XApoc2xa8L9O293xDA8Sul0GLRNLYwUoSu3Obtqf0K0dCrJbOt0eWQQEDaTs6j4


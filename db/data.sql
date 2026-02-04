--
-- PostgreSQL database dump
--

\restrict a10gE68dmGxfAa7Io9HwenyO606IuQRRoZUju5PoReUFwd5LaSBhVpY9eBzGTag

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
-- Data for Name: audit_log; Type: TABLE DATA; Schema: audit; Owner: crm_migrator
--



--
-- Data for Name: bull_log; Type: TABLE DATA; Schema: bull; Owner: crm_migrator
--

INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('01f11ebc-1901-476b-b340-50f91e27b141', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 3}', '2026-01-26 12:28:27.093495+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('88b28e9f-cd44-4003-9765-0b4166636791', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-26 12:28:27.09656+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5c701a40-9899-4db9-8dba-cbdd54145af4', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-26 12:28:27.280856+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e8cc408a-a8eb-4aaf-9bf5-49176503595c', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-26 12:28:27.283647+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('81d60355-272c-4013-9840-9a4a9b9020d7', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:28:27.285488+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('58f53a93-3500-4f37-ada8-1f52b98df827', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 1}', '2026-01-26 12:28:30.748766+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f389fe54-245d-43d0-981b-21a5d0e65d63', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-26 12:28:30.750528+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('665c6f92-a25c-4f50-bd52-ad820dfc5d6f', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-26 12:28:30.754077+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('98c92719-dcaf-4566-96f0-58663bb6cf99', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-26 12:28:30.75592+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a08b0fbf-58d6-461f-a60f-0509705f2972', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-26 12:28:35.557586+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('40828a12-0cee-4395-bea8-e69c215abd2f', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-26 12:28:35.559391+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2c7d3112-606f-44e3-b2f7-6c2d2bbd7005', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:28:35.776937+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e5646a38-0e97-4a11-88af-c1dc67a93404', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:28:35.778671+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('eb80fda5-0fcb-4587-b54b-27996bfcfd26', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-26 12:28:35.779803+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2140d6d4-ed41-438e-80cb-6b63ad18bded', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 2}', '2026-01-26 12:29:08.44603+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cb9dc979-087f-4f10-81af-1b11f45504f1', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-26 12:29:08.448153+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1828f418-d36e-4f4d-bee8-dfbba72e6e15', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-26 12:29:08.452106+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9db1775a-af19-44d4-a55b-02b0a57cc6de', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-26 12:29:08.454065+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8a8b5c00-6e64-492e-98c9-5be6fed35a51', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 2}', '2026-01-26 12:29:11.94383+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bd45deb7-7d82-4eff-bf23-e28d92b65b18', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-26 12:29:11.946398+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f6f9e9b9-88b7-43f5-8e3a-abe88ccbbc5a', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-26 12:29:12.144598+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('86990058-1900-4864-8969-195622afeea6', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:29:12.146945+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8cd0b069-7119-4128-881c-d45af4f01f0e', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:29:12.149057+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('19087942-6567-40ca-be7f-0510d5a0e8c0', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 2}', '2026-01-26 12:29:18.386483+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c1d19deb-53a5-4a01-8e4a-ed500dc74156', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-26 12:29:18.388718+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9c689c85-9474-407c-9c54-3d50c49f06a6', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:29:18.596117+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3c0fc766-50d3-44de-b520-aecdf832b576', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:29:18.597882+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d92e9d0f-241e-4d78-8a5f-fb6bf724a83e', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-26 12:29:18.599051+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e008617a-9d6e-4c50-b023-d5c4900178cb', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 11}', '2026-01-26 12:32:34.08907+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('dfc2b05d-9a3f-4cf3-b769-0fd94a8b2203', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-26 12:32:34.091157+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3043eec6-8d8d-4584-b04a-fe0036759edf', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-26 12:32:34.094217+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7b1df24f-183a-4b09-baec-776b12161d4b', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-26 12:32:34.096325+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('061b7f00-87c2-4a0c-898e-21795f2cdcbb', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-26 12:32:37.767159+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5e7333ca-23e0-40d9-95df-46659a28dcc9', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-26 12:32:37.769922+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ed9ce1b0-438c-4c34-b1a3-547b56f606d7', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-26 12:32:37.979916+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('116c3fc9-3c08-4495-a1da-310f091deef5', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-26 12:32:37.983077+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2239231f-1a36-4bde-b1b4-b0967b5cb3e8', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:32:37.98496+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cf98fb36-9070-429d-b03d-5574af8fed12', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 13}', '2026-01-26 12:33:30.623173+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cd7c19b2-b3bd-47d0-baa7-f1b0ad3fff08', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-26 12:33:30.625117+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('608a0656-f5ee-455b-bb6e-db752f4f907d', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 4}', '2026-01-26 12:33:30.629477+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a644f924-3622-426c-a040-d4400d65d4ce', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-26 12:33:30.631102+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('23cbdb63-bc81-4cb3-9bdd-14bc9d562764', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 3}', '2026-01-26 12:33:42.064271+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('53ba5643-0a45-4af6-8e72-d6e5f00c98b9', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-26 12:33:42.065848+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('28a6a181-979b-40dc-be5c-94c6a9d3698a', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:33:42.271671+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d2b4a642-43c1-4a88-9d9d-a328c562717b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:33:42.273646+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('12ebf4f0-4939-4bc3-8668-49c7222f7004', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-26 12:33:42.275134+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6a7455de-d4d2-4a7a-aa00-6e5c47f442f1', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 15}', '2026-01-27 08:57:46.292961+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3062012b-56e3-479e-9640-d6e99a533d18', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 08:57:46.295212+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8da9a487-d062-462c-b878-b181742625ba', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 7}', '2026-01-27 08:57:46.303408+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('be0e558b-b745-453d-981d-b79cad924f29', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 08:57:46.306544+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8d4bd076-a049-41a0-9141-28d24e4d7951', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 2}', '2026-01-27 08:57:48.583401+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2710e5cd-80ce-41cf-94ca-77d37c971413', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-27 08:57:48.585203+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('843fe8b3-98fa-4b22-b5b8-23cda4ffe5e3', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 08:57:48.793881+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a4f5be66-6cef-4d7d-bba8-520214d922c9', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 08:57:48.795914+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8a5da9e6-d6c8-4a44-b7ef-5f22f168e7f0', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 08:57:48.797338+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('55da29b7-7ca1-423a-be9e-0690f8319808', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 2}', '2026-01-27 09:14:39.415996+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bb04826c-9c3a-4d59-8d33-ae2e1041562e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:14:39.418148+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4eb4b8dd-f73e-4e26-b0f8-6ba6dd79d103', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-01-27 09:14:39.421475+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('071e614b-e3ec-4963-9809-76a05c2ca966', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:14:39.423213+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('181b5983-cf54-45f2-84ad-5b09a1c0eb92', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-27 09:14:42.106896+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('eb9ee081-e93e-4700-b1f9-ae6741459aff', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-27 09:14:42.108987+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0e202108-eef4-4ed5-9b41-67186422555a', 'sql', '{"text": "SELECT id, code, description\n     FROM core.permissions\n     ORDER BY code ASC", "durationMs": 7}', '2026-01-27 09:15:20.478085+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('995e2745-b547-4c66-8977-a7c90de76709', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:14:42.303644+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6e1e1479-df52-4b7e-9679-728adf495175', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:14:42.306196+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9507dec4-1324-488a-bdb3-21635c84daaf', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:14:42.307633+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7a1836eb-a091-4ff0-b2c0-1f75246dbb28', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:14:42.539601+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a1424608-c5df-45fb-8cc3-d6ffd9c70a2c', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:14:42.541028+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('703a3206-7d83-4455-b6a5-d6d772f5bab0', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:14:42.542468+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0961a8a4-3dbd-4cfc-a5eb-8f185da6144d', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:14:42.543528+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f7c50871-fd04-4cee-b232-bdca66da0480', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:14:42.833452+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('313cd85f-bbad-479b-9db0-37e1b8571f39', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:14:42.835095+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('55e3afd6-ba8d-4c4d-be4f-3ece68580be4', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:14:42.836372+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5590fe41-39ee-41c3-9234-6080290388af', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 2}', '2026-01-27 09:15:01.954402+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d3c212b6-6163-4033-9206-628c997f2b06', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:01.957026+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b6da3bb0-831e-4502-b830-b68f7fe4a27f', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:15:01.957565+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('89799c39-5760-4147-b496-81e05f15d4ef', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:01.958555+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1071a1de-f4e3-468f-bb6c-00d5b1d15d9d', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-27 09:15:01.961234+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('56755783-b4b5-4941-ba96-981e3216a770', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 2}', '2026-01-27 09:15:01.964732+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('acc6e0f8-9fd8-4579-aa85-21458ec747da', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 3}', '2026-01-27 09:15:01.966866+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bef2ca09-edc6-40dd-923e-6831bf703ed7', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:01.969308+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b1eca92f-a91b-48db-aabc-8ffdb37a753d', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:15:02.496665+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('05d413c1-ccaa-4861-9d9f-8c8f783559d7', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 2}', '2026-01-27 09:15:02.501257+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fac97667-8afe-4ebe-ad7c-f8a6826d670a', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 4}', '2026-01-27 09:15:02.508587+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('766a4fca-afed-498f-aa46-26f4ffa28ed1', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 2}', '2026-01-27 09:15:11.773677+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a1c6033f-266f-4161-b715-8d41be077dd5', 'sql', '{"text": "SELECT id, code, description\n     FROM core.permissions\n     ORDER BY code ASC", "durationMs": 0}', '2026-01-27 09:15:11.778166+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ed3d9386-4f6b-4b55-acd3-70add48f0701', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 3}', '2026-01-27 09:15:19.955929+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fd37688a-2ec2-4cbd-b240-748bf4eb50bc', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 6}', '2026-01-27 09:15:19.956153+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2d3cf7f5-0441-4c58-8375-127be536f9c3', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:19.958576+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('68383f08-bdf7-42ed-93f1-05ac8ad8a39e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:15:19.960469+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f60c5500-4c35-4ace-a20c-15c3b4cc4234', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:19.960665+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('657ab1b3-9144-4726-8a9a-02d439bbc794', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 6}', '2026-01-27 09:15:19.969404+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ef162de7-b138-4f9b-a7d3-1c78ecf70290', 'sql', '{"text": "BEGIN", "durationMs": 1}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('518b3f5b-663f-4ff8-a91c-d0b1e4775f67', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 10}', '2026-01-27 09:15:19.972907+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('88d94aa1-2a5a-4ceb-bcc7-502a81e56a4b', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 5}', '2026-01-27 09:15:19.985408+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('efee295c-6c5c-4c4a-9d35-241a90aea89b', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 5}', '2026-01-27 09:15:20.463947+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('dd0177f5-2761-4b77-bcb8-3d49c53191f9', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 6}', '2026-01-27 09:15:20.477763+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ece29bca-f079-4e03-9678-458210ab202c', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:15:20.479457+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9fc37d49-610e-4aa8-b589-2a9f3188fcae', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-27 09:15:20.466474+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0e29be12-6486-4afa-b289-75f93252cd41', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 3}', '2026-01-27 09:15:39.679814+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('220f254b-bdf7-482f-ba61-f98c1ae97d5e', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:39.682396+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fe70a51f-bfd8-47d5-8b53-909cc3fe491b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:39.683995+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b9fd190e-9f90-4185-9902-084468bfb24f', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:15:39.685256+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c20eaa95-70b7-4a71-8327-8182af032bcd', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:15:40.271994+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fa13dc75-f158-4fcc-bc8a-9c4598e703de', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:15:40.273304+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4348ec2e-6e54-4fb0-9af3-639a51bdcf43', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 2}', '2026-01-27 09:15:40.276514+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0126c5e7-1e21-43bd-93f6-1e3775318de3', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 10}', '2026-01-27 09:15:22.315885+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('206ff4fb-7d29-41f1-bf2f-1d7ad0fe1336', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 4}', '2026-01-27 09:15:39.6793+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fb2984dd-3e3e-43c7-8973-cc020510ce1e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:15:39.68055+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7251c4cf-9ef3-47ad-b682-a06ed3e3489f', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-27 09:15:39.682645+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('25199855-a6b6-420c-83ba-024538b356ae', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:15:39.684507+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('32930824-d080-4297-8179-6211307a6085', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 10}', '2026-01-27 09:15:40.290987+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2d791952-db09-4922-90bb-1d1e69531cf7', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:15:45.216913+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('85b062c2-282f-42a5-9707-b859adee1073', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:15:45.218309+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e270d7c9-1e86-4c26-98ee-0c9bd833f2e8', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:15:45.219178+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('592da729-6e0e-421e-8834-e2d0697681cb', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 23}', '2026-01-27 09:17:49.874437+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7f255aee-1ce6-45fa-a47d-e265438f4541', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 20}', '2026-01-27 09:17:49.875834+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b3868d72-5e62-4f23-a38d-51f22386439c', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:17:49.87874+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d7f410f6-6cc2-4111-99b0-8ac690f9d530', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:17:49.878959+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bf88e08a-58da-4613-ab0e-576d90236b46', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 5}', '2026-01-27 09:17:49.884962+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9ec91473-f64c-4b31-952a-fca284804034', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 4}', '2026-01-27 09:17:49.886002+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('41e217cb-6aa2-44be-8ebb-f3713c8b711a', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:17:49.888146+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('40155a8c-f678-4dee-9e8d-c37c212c63ff', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:17:49.88945+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('770cb6b1-9dec-4dfd-8a11-3951b4df01b3', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:17:50.390088+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('aa41a21f-a2a9-407f-b40b-63ac3ec7c6a7', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:17:50.391661+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('59725f51-00aa-4e08-8eee-ec63eef28e41', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 09:17:50.39279+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ad0a2e58-48f2-43d7-b936-35e192a9faf3', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-27 09:17:55.034881+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('81fb9ea4-537d-48a1-8477-04bf80d03c98', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-27 09:17:55.036909+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('854cf7f5-3b8f-423e-a95e-4484968804a7', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.238002+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1ca1402e-6ab8-4fe6-90fe-008394f302c6', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.24007+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2627416c-1105-4645-a078-e8b7b7f9ade8', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.241366+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3c84d562-282a-4be8-b951-b556315ef8f6', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.481457+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0ad4f21e-4785-4049-81ea-f78cd05d3be0', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:17:55.482868+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('626ee9a4-3cc6-411b-8e68-5d1bb4ff6132', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.484169+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('802e9bdf-54f7-4af4-8061-9d29339d1d2c', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:17:55.485174+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f7845d25-29bb-41b0-a4f0-b3646ed8a906', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:17:55.784946+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('973ea38b-ac18-43ad-addb-99d3087dd3f1', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:17:55.786171+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c1d22a8a-f80c-4a17-a9a0-0851b9d13c95', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:17:55.787106+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('749870a3-e3cf-4954-88a6-129aece369b4', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:17:57.866139+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c9368d62-96fb-4ef5-ad87-10495bec83fa', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:17:57.867682+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('86a00cc9-2ae8-4b81-9ecd-7e4b3d8a5103', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 09:17:57.868923+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0dc06265-e7b4-436d-9d0d-8dd624783971', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 4}', '2026-01-27 09:18:06.83523+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d47c08ae-43a3-4351-825d-7d70b51ee91f', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-27 09:18:06.836742+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b1895969-3ae0-4a8c-a191-709b3053f5ff', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:07.019099+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('683f900f-00c7-466c-aa54-f632f41e7aeb', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:07.020814+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('edb33e4b-b08a-4a98-89bb-15b9096937b3', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:18:07.022063+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('60d19619-0d2a-4573-a757-20bb6cb03a9c', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:07.310316+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('330cd1f2-a866-467f-979a-032edcf896d4', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:18:07.311888+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d88edc16-5f11-4e4e-9fcb-c6027b508063', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:07.313518+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('04158e5e-c6ce-4b58-bd00-cf7e8a25af34', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:07.314638+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9ca29237-585f-4466-a1a8-15a759d49268', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:18:07.553762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d24fc9f8-e9ae-4204-aed5-c7639734cb2f', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:18:07.555024+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f59030d7-eace-45c1-9e4f-7e528f34ab90', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 09:18:07.555967+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ecb3d2bd-fc33-42df-8f52-082a91a678a1', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:18:08.589998+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('32a8e232-638f-4072-bef5-361c08b9e0b2', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:18:08.591389+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7a9fc8d6-0328-4510-8831-534a029a59f8', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:18:08.592322+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f1399a92-ff41-44f5-bdc7-729d5b534dc6', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 4}', '2026-01-27 09:18:19.39155+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('da3c37b7-bbba-45be-91b2-660ccea1714c', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:18:19.39277+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a44c700f-46a6-4464-904b-7ab7a02960e0', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 5}', '2026-01-27 09:18:19.399768+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f33c5df1-e0db-4f52-973f-730ee639a044', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:18:19.40428+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e697566a-4854-4bf4-8d75-8e6ed227495a', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:18:19.673987+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('eb010cca-f57e-4560-9d35-80df48b70dd5', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:18:19.676227+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('da0835ac-6d09-4a93-835f-39bcb071e682', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 09:18:19.678076+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a0a2cf41-a7b6-4596-9b25-e25395d17646', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 1}', '2026-01-27 09:18:30.930464+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c560f70b-912c-4cf6-9434-0a9e76ee82f8', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:18:30.931665+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ba6076a9-08ea-4ea1-8811-c493bb3d8294', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 4}', '2026-01-27 09:18:30.936785+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3070041b-c18f-49e2-844e-e133cb69d9a8', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-27 09:18:30.939401+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0678f2b8-2f46-43db-8e4c-a4f11790ba8e', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-27 09:18:35.914747+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5108e5f6-f1d8-4b92-9a59-4da99558c60c', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-27 09:18:35.916283+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5993a8e5-2b76-4d33-9da8-b85833457579', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:18:19.391976+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bf27ffe0-fe62-4eda-a528-d751b8ac330e', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:19.393954+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ea846298-5ced-40b5-8cc8-7537030222c4', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:18:19.402206+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b1127168-5906-4473-b620-f8d3d5cb62d0', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:19.404588+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b963590a-6e59-4ffe-975c-783ab8a5c262', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 3}', '2026-01-27 09:18:19.673458+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('18122e15-04f0-4a9c-a7f4-05d7cb03c158', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:18:19.674873+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cb0e478a-bdb2-443c-ba67-89f58a725332', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 09:18:19.676027+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a9932bd8-df1e-4dde-9c58-b729018ad19b', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 1}', '2026-01-27 09:18:37.718118+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('04241098-593e-4413-9ad4-8e2cab30a913', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:18:45.62349+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1dfb9c27-c876-4ae9-9c76-146b79ecd163', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:18:45.624942+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e8a47d89-203d-47b2-8d1d-419944333582', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:18:45.626177+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('70739e70-bcd6-4ebd-acfd-672a48b5cf1a', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:36.109947+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a107fd3f-9eb3-4172-87a7-d7a4c53e9c9b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:36.111705+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bde704c0-8c4e-4849-b1ea-633bdf02067b', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:18:36.112756+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5a2264cb-88a9-4082-8332-5fb908da2c89', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:18:36.351735+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c35613e5-6588-4f7c-9309-ebc8db58a57c', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:36.353182+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9060114d-f16b-4b2f-8359-542bd3455435', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:18:36.354614+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b1949688-6069-4ef7-99ef-0b58ddfb2291', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:18:36.355906+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1688089e-a67d-44c4-8ebb-0aff21a85840', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:18:36.709654+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1bef2732-97d7-4c6c-b89a-4f487ceaa38c', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:18:36.71131+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('97a37e1d-980f-4bef-a989-db9641f7b7e4', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:18:36.712565+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4d4a5a8b-d768-4e12-b0e9-136e2b635a9d', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 6}', '2026-01-27 09:19:14.192052+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6f15e6cd-3e27-4e9f-bb5a-8169ccc8f1a9', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:19:14.193969+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6cf95ebc-85cb-41d3-b1f2-6823276890b4', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 1}', '2026-01-27 09:19:14.196649+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('90b7dc13-1a97-4766-8de8-a918db9e11d6', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:19:14.198188+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('89aa6b3d-5e3d-445f-9886-2f782df884c0', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 17}', '2026-01-27 09:19:14.203913+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('be59c1dd-636b-41a5-b9db-827bf7fc2116', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:19:14.205707+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('240718ec-801f-4f76-9cb4-1ede3075820b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:19:14.207345+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('810cd50e-f236-407f-8b16-db549aaaa101', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:19:14.208655+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ca234000-0f89-43c9-af2b-78f791db7f06', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:19:14.690556+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8753314e-9a7d-4a4a-bab4-4850346eb075', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:19:14.692145+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4c83bf31-408f-41d3-944d-91b16a957d2e', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:19:14.69319+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3f7e95e7-14e7-4e32-be20-ea4d66fbe3d2', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-27 09:19:15.883638+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6f0644dc-f56e-41b2-b90a-015b7ad97ef7', 'sql', '{"text": "BEGIN", "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b2662cf5-cb27-400e-aff7-737b78bd59b1', 'sql', '{"text": "INSERT INTO core.users\n     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)\n     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)", "params": ["1ce1ce26-1fd1-476b-9126-37e190dc5a96", "a@sissol.ru", null, "A", "A", null, "A A", "ru", true], "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('709bba4b-48d6-4ed9-9a3f-a2c6b52eee80', 'sql', '{"text": "DELETE FROM core.user_roles WHERE user_id = $1", "params": ["1ce1ce26-1fd1-476b-9126-37e190dc5a96"], "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d57f96e3-8d85-4706-839a-fb84e76061fd', 'sql', '{"text": "SELECT id, code FROM core.roles WHERE code = ANY($1::text[])", "params": [["manager"]], "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e85132d6-2a8b-437a-802a-9f8355add8e4', 'sql', '{"text": "INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)", "params": ["1ce1ce26-1fd1-476b-9126-37e190dc5a96", "d2563ab6-c3b7-4a0e-9241-048aa4a999e6"], "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fe8bcd65-ebfb-4171-8cce-b574a9c6cb33', 'sql', '{"text": "SELECT payload\n     FROM core.settings_values\n     WHERE module_code = ''core'' AND page_code = ''security''\n     LIMIT 1", "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d98d1415-f27c-46e5-a448-da58e6ed895f', 'sql', '{"text": "INSERT INTO core.user_passwords (user_id, password_hash, is_enabled)\n     VALUES ($1, $2, true)\n     ON CONFLICT (user_id)\n     DO UPDATE SET password_hash = EXCLUDED.password_hash, updated_at = now(), is_enabled = true", "params": ["[redacted]", "[redacted]"], "durationMs": 1}', '2026-01-27 09:19:39.875539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('972a2f79-f6f5-4176-95b9-e4ec929cfc61', 'sql', '{"text": "COMMIT", "durationMs": 1}', '2026-01-27 09:19:40.09149+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1be2c00c-85c8-4219-a48a-81a923a76d27', 'sql', '{"text": "\n    SELECT\n      u.id,\n      u.email,\n      u.login,\n      u.first_name,\n      u.last_name,\n      u.company_name,\n      u.display_name,\n      u.lang,\n      u.is_active,\n      COALESCE(\n        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),\n        ''{}''\n      ) AS roles\n    FROM core.users u\n    LEFT JOIN core.user_roles ur ON ur.user_id = u.id\n    LEFT JOIN core.roles r ON r.id = ur.role_id\n    WHERE u.id = $1\n    GROUP BY u.id\n    ", "params": ["1ce1ce26-1fd1-476b-9126-37e190dc5a96"], "durationMs": 1}', '2026-01-27 09:19:40.09389+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('dff4b564-fdc0-4e43-aae5-b531c0403513', 'sql', '{"text": "ROLLBACK", "durationMs": 10}', '2026-01-27 09:20:09.331305+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d8bf6105-7543-49f2-a66c-2fd4bced6a5b', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 9}', '2026-01-27 09:23:33.941262+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('15c35dc5-5bb3-42c9-8b63-8c8975a83885', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-27 09:23:33.943028+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('aa1965bd-2ac9-47df-bbdb-0293a9718e13', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 11}', '2026-01-27 09:24:06.783436+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('eb7ce886-7ace-407e-9c75-b33bb56d4681', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-27 09:24:06.785095+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e57920c5-57d4-4d4c-aa40-258d2a85b6ec', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:24:06.970473+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bf135c04-0b53-44d6-bc68-8df52f50d034', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:06.972504+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b5f6e4b5-0ea5-4293-995f-e7a037df8901', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:24:06.973992+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f69ea8b0-4356-4b29-9560-6ef48549ae24', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:24:07.205918+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7e10f308-c194-4786-9ccc-334a77feeeae', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:07.207434+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8db5aaf1-05c6-43f9-a85e-9a8bc10e69e2', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:24:07.208927+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8b58a979-b69f-4ac7-ab05-c33c06ba5995', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:07.210362+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1da53088-06fc-4ab9-a250-2a289bdcf598', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:24:07.498394+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('97a93e61-decc-4b8a-afac-55e6816985ad', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:24:07.500157+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1fc8f9ef-88b2-4188-a25e-288f4380df28', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:24:07.5018+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('68d73207-2e54-4ba3-aeab-cfdf5f194c19', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 2}', '2026-01-27 09:24:18.580151+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d202a9c7-c81b-43b0-826b-02f7b98be11b', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:24:18.58134+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('df984cec-34fe-4e4c-b457-38cd65a4c927', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-01-27 09:24:18.584826+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c17bd979-520d-44b1-8a6d-41ef9be840a5', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:24:18.587053+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0c5959f0-913b-4168-9013-d739cfcb9124', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-01-27 09:24:22.297622+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('119b23a8-03a7-4df6-bd34-818735217fa6', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-27 09:24:22.300904+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('715d08d1-cc0d-4a50-8dfa-00c5250d1d7e', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:22.482818+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('dc48f40f-8d48-45eb-85fa-98dd1512b8c0', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:22.484347+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('988ae31a-cd1c-4a7c-85cf-96807401bffb', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:22.485528+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8ba93fa1-a4b0-4ee8-8067-01f069ace167', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:24:22.713976+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ea28198f-9667-44fd-ac1d-dcef5f2fb5fd', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:22.715572+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('11acbf1a-2872-4b1b-8676-60f44b6a1297', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:24:22.717108+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a4b6153d-2ef5-4f81-972f-f948289e9c74', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:22.718397+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8b223282-f625-4324-aac2-323697ebe127', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:24:22.957217+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6227407b-3136-40e8-a0c9-4eef4c312050', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 09:24:22.958539+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2fd0c5a8-02e1-4efd-ad07-23c2a73416c2', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:24:22.959463+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b9b72484-cab5-465d-b763-e9bb82bef1d9', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-27 09:24:28.003569+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('13ad61b4-4dec-47f8-941f-c5eb683f3c5a', 'sql', '{"text": "SELECT id, code, description\n     FROM core.permissions\n     ORDER BY code ASC", "durationMs": 12}', '2026-01-27 09:24:28.014299+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c81e7d12-660a-4c8c-bed3-7521e1c0060a', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 3}', '2026-01-27 09:24:32.67791+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4c8611e3-2fb7-4fae-981d-822c96d6d107', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:32.678104+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ff3c8bc7-5341-4304-9b55-b99b3c306477', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:24:32.679108+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a932c668-e375-479e-b0da-5b41f49af5e8', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:24:32.680117+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('74e9965d-100b-4078-b18f-2aa99c6a7f1d', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 1}', '2026-01-27 09:24:32.681991+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f7755553-7322-4682-b641-3b39631fa9df', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 4}', '2026-01-27 09:24:32.693401+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('42abd51b-85ea-4a36-b117-b991f8084540', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 9}', '2026-01-27 09:24:32.694002+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5d8f473c-84fc-456d-8c30-f6c9e4ffb2ef', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:24:32.699937+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bb8584dd-a6f3-4f5c-90d8-e0c144ebf97b', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:24:32.946351+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('99d8fae3-6c89-48f8-a4c5-94d55b3d94cd', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 2}', '2026-01-27 09:24:32.948403+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9c0ed123-ba20-425e-9446-413dae222f99', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 2}', '2026-01-27 09:24:32.953217+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f9179a41-4f1a-48e5-b5ed-9e3d98481430', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:24:32.955728+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e96f7c50-af44-4ca9-98ef-2dffe156347a', 'sql', '{"text": "SELECT id, code, description\n     FROM core.permissions\n     ORDER BY code ASC", "durationMs": 17}', '2026-01-27 09:24:32.965196+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('57dde920-6e0c-4d96-bb23-fa89735d23d7', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-27 09:24:34.748153+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d1a9d6ef-f17a-48f3-9ed9-9943762d4294', 'sql', '{"text": "BEGIN", "durationMs": 8}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8677a909-8eed-488b-8dec-853a3940033f', 'sql', '{"text": "INSERT INTO core.users\n     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)\n     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)", "params": ["c4941cf5-f3b9-4b12-8823-b2af9064dc7a", "ewe@gmail.com", null, "ewe", "wewe", null, "ewe wewe", "ru", true], "durationMs": 1}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d9b80519-b86e-4f35-ba75-c559982b8e77', 'sql', '{"text": "DELETE FROM core.user_roles WHERE user_id = $1", "params": ["c4941cf5-f3b9-4b12-8823-b2af9064dc7a"], "durationMs": 0}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f59a7c31-c10c-42c6-a519-c198a919c484', 'sql', '{"text": "SELECT id, code FROM core.roles WHERE code = ANY($1::text[])", "params": [["manager"]], "durationMs": 1}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('eb389845-f368-4b77-bb24-598b62237801', 'sql', '{"text": "INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)", "params": ["c4941cf5-f3b9-4b12-8823-b2af9064dc7a", "d2563ab6-c3b7-4a0e-9241-048aa4a999e6"], "durationMs": 0}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a28a907b-3647-41ab-91c2-a71a5811a03d', 'sql', '{"text": "SELECT payload\n     FROM core.settings_values\n     WHERE module_code = ''core'' AND page_code = ''security''\n     LIMIT 1", "durationMs": 0}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('99f2be62-b239-4ea9-99f7-a375fe92c280', 'sql', '{"text": "INSERT INTO core.user_passwords (user_id, password_hash, is_enabled)\n     VALUES ($1, $2, true)\n     ON CONFLICT (user_id)\n     DO UPDATE SET password_hash = EXCLUDED.password_hash, updated_at = now(), is_enabled = true", "params": ["[redacted]", "[redacted]"], "durationMs": 2}', '2026-01-27 09:25:46.323067+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('85434ba4-1523-40f8-8b7f-e92b5b1d9623', 'sql', '{"text": "COMMIT", "durationMs": 1}', '2026-01-27 09:25:46.539803+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('80d3af8e-c3f8-4ac6-bc80-eae789680810', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 19}', '2026-01-27 09:52:11.760963+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5ac46c4f-b58c-4663-9d46-f727c23a8f43', 'sql', '{"text": "\n    SELECT\n      u.id,\n      u.email,\n      u.login,\n      u.first_name,\n      u.last_name,\n      u.company_name,\n      u.display_name,\n      u.lang,\n      u.is_active,\n      COALESCE(\n        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),\n        ''{}''\n      ) AS roles\n    FROM core.users u\n    LEFT JOIN core.user_roles ur ON ur.user_id = u.id\n    LEFT JOIN core.roles r ON r.id = ur.role_id\n    WHERE u.id = $1\n    GROUP BY u.id\n    ", "params": ["c4941cf5-f3b9-4b12-8823-b2af9064dc7a"], "durationMs": 2}', '2026-01-27 09:25:46.542251+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2d50ffe5-81ba-4dbe-b8f4-bb8737a60d22', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 20}', '2026-01-27 09:32:12.506932+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b3374aa9-2029-43db-8cfd-140d37bf3e79', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 16}', '2026-01-27 09:32:12.507395+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('effcb633-38da-4ee2-81a3-7a91da834784', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 09:32:12.510168+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b7797df5-d85b-4736-98fa-c340b1653618', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-27 09:32:12.510347+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('089b39d8-8a0e-4bed-96b9-55130bfb4fde', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-01-27 09:32:12.514012+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c36f5853-4f39-4464-b733-23e789d44e12', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 09:32:12.514396+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a639abaa-11f3-4dfd-901c-6b18674277d6', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:32:12.516182+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4907d53d-108d-44e8-8fb7-343de14a2a6b', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 3}', '2026-01-27 09:32:12.519651+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('930c598a-d496-40d0-91f9-efdeb4cfa35f', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:32:13.027794+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d85eae7d-8de3-474a-a6eb-60477550da41', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 6}', '2026-01-27 09:32:13.03703+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7a941f35-63ba-4b25-9189-c2a3f70c2014', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:32:13.039549+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('82f701d4-b76c-44ec-b11c-75df3fb7e960', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 15}', '2026-01-27 09:32:13.049505+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4be8e082-1816-4358-b15f-028234dbfe30', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 12}', '2026-01-27 09:51:58.416888+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8c7f516b-48a3-47cc-9b58-5a786a49a48e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:51:58.419343+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2c1e0a32-8d68-4684-85e2-8190c58b46ba', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-27 09:51:58.422653+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c0eeae4d-716d-45b9-938a-0f77133558e7', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 09:51:58.424477+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1071cc9e-8b38-469e-924e-dd8e15d49e80', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 2}', '2026-01-27 09:52:03.621056+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('08465a0f-91a7-4228-95d7-fa925b19a573', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-01-27 09:52:03.623028+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('df2c090c-5bba-46c3-b8f2-affbda13f644', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:03.826408+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1ef08045-28df-4e5c-bdcd-53791f0b4cc2', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:03.828976+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('22b89a17-ad86-410c-a40c-200a3bf7759d', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:03.830728+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('39bfba4e-037d-4200-84ce-e3577e217a4b', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:04.149922+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b09a4fb4-7176-474f-b150-ee24bb0303a1', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:04.152048+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2b5efd33-f96d-49bd-8ed3-152b9f48ddda', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:04.154072+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('88e9cdd5-f7a9-4fa7-904b-b341287ec004', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 09:52:04.155489+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6ec31413-91af-4c78-9f37-35689000302e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 09:52:04.404961+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ede2d7cf-e9c1-4a1d-9e12-5d9a13f9a2c6', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-27 09:52:04.407007+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('20795658-cbb3-4c6c-b588-39d616cea8b4', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 09:52:04.408239+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6284f24c-d4cd-4a36-a920-fb77ea844093', 'sql', '{"text": "INSERT INTO core.users\n     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)\n     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)", "params": ["7ce7031c-752f-4ec7-baf3-807a3cad5d44", "asd@fnh.com", null, "jjhj", "jhj", null, "jjhj jhj", "ru", true], "durationMs": 1}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4142fa95-6fc6-4929-8579-08ba193e048c', 'sql', '{"text": "DELETE FROM core.user_roles WHERE user_id = $1", "params": ["7ce7031c-752f-4ec7-baf3-807a3cad5d44"], "durationMs": 1}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a8027329-8baf-4e19-8cbd-71d60bef854b', 'sql', '{"text": "SELECT id, code FROM core.roles WHERE code = ANY($1::text[])", "params": [["manager"]], "durationMs": 0}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c27c9c74-c87b-4ecb-8336-096091545417', 'sql', '{"text": "INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)", "params": ["7ce7031c-752f-4ec7-baf3-807a3cad5d44", "d2563ab6-c3b7-4a0e-9241-048aa4a999e6"], "durationMs": 0}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('635edb9e-424e-4be6-983f-bf5f30beff77', 'sql', '{"text": "SELECT payload\n     FROM core.settings_values\n     WHERE module_code = ''core'' AND page_code = ''security''\n     LIMIT 1", "durationMs": 0}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d3a4e690-ffe4-47df-84f9-a34e763d5f46', 'sql', '{"text": "INSERT INTO core.user_passwords (user_id, password_hash, is_enabled)\n     VALUES ($1, $2, true)\n     ON CONFLICT (user_id)\n     DO UPDATE SET password_hash = EXCLUDED.password_hash, updated_at = now(), is_enabled = true", "params": ["[redacted]", "[redacted]"], "durationMs": 1}', '2026-01-27 09:52:31.268021+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('60b73399-eaff-44ee-b3bf-3a0a0581038c', 'sql', '{"text": "COMMIT", "durationMs": 2}', '2026-01-27 09:52:31.465653+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c0bcba73-4a90-4c36-9670-a40f05b8deab', 'sql', '{"text": "\n    SELECT\n      u.id,\n      u.email,\n      u.login,\n      u.first_name,\n      u.last_name,\n      u.company_name,\n      u.display_name,\n      u.lang,\n      u.is_active,\n      COALESCE(\n        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),\n        ''{}''\n      ) AS roles\n    FROM core.users u\n    LEFT JOIN core.user_roles ur ON ur.user_id = u.id\n    LEFT JOIN core.roles r ON r.id = ur.role_id\n    WHERE u.id = $1\n    GROUP BY u.id\n    ", "params": ["7ce7031c-752f-4ec7-baf3-807a3cad5d44"], "durationMs": 2}', '2026-01-27 09:52:31.468671+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('367515f2-80db-4603-ab31-d61068d11d34', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 6}', '2026-01-27 10:01:47.194323+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('197ec427-6ac6-42b6-b1e3-6282726a6566', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 2}', '2026-01-27 10:01:47.198887+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('46509518-7a0a-485d-884b-03b58938596b', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-27 10:01:47.203166+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cee7ade4-2471-4b8b-8bdc-c1d173406b69', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-27 10:01:47.205643+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4c0516dc-7f2f-4d68-8fef-0c0dc125c7d0', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 22}', '2026-01-27 10:01:47.212317+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('072c29aa-99ca-4d2c-997a-e872a86d4ca6', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 10:01:47.215958+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a6c99b2e-8d46-4748-ae05-5c22b0fddefb', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 10:01:47.218465+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fb286e28-0ba9-4944-956a-018def8ddbe4', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:01:47.220584+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c623de22-0a1b-4df0-9f94-1bd1fbf487e6', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 10:01:47.459653+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3e902646-c05d-4b93-9457-01eddf052b04', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 9}', '2026-01-27 10:01:47.471942+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5d247c47-d0d3-44d8-bc8f-b3ff44448d03', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 1}', '2026-01-27 10:01:47.475596+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('28195df5-04fb-4dd6-8c3f-1ae35e798a30', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 16}', '2026-01-27 10:01:47.486662+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6a4af603-37f3-4ff9-afff-56ff1e018bc6', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 1}', '2026-01-27 10:01:55.04403+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3599e3e6-ea0a-4260-b083-c2016b12be97', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 10:01:55.045586+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f5fdf295-f121-4d26-985e-566f891f8809', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 5}', '2026-01-27 10:01:55.051345+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6b5deec0-61a5-4935-9842-6aec6ec83eba', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-27 10:01:55.053113+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2e4d9156-f661-4f04-8399-9416f388cfda', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 2}', '2026-01-27 10:01:59.594331+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f7929680-c7f0-4437-b036-d07bd27ac1c6', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-27 10:01:59.595795+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1448757d-7872-4ecf-92c1-8613050b1ef8', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:01:59.796853+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('62c2eacf-fafc-47e7-9aa5-b6dfb79c618b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:01:59.798886+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d7daa2eb-370d-4282-92a5-6511246de0a5', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:01:59.800441+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1f3a8813-15fa-420c-ab40-f4e300d86fad', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-27 10:02:00.029809+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('18a409a8-2d46-435f-9350-f9a53c7ce530', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:02:00.032454+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('89209c85-9089-4b03-bed4-7349b1e2316b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:02:00.034267+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('77d7658b-beaf-40ed-8baf-09794e959438', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-27 10:02:00.035568+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ad229b6d-fa0b-4778-93b6-3ba84ee53556', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-27 10:02:00.284002+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d87e26fb-c558-4079-a25c-7d1b1eea087c', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-27 10:02:00.285531+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c5b3fc47-c691-42a5-ac6d-daa875c94710', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-27 10:02:00.286741+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('10cd8e91-158e-44b1-bff4-7ecd002d3689', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-27 10:02:03.163176+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('de218e58-5dc1-47a9-b535-104ecccddccd', 'sql', '{"text": "BEGIN", "durationMs": 1}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('73f1db69-0500-4624-96d0-20de4f56e4e1', 'sql', '{"text": "INSERT INTO core.users\n     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)\n     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)", "params": ["20d60a58-2eb4-4725-b696-fc34eae20bc5", "ghh@ngh.com", null, "kjjk", "kk", null, "kjjk kk", "ru", true], "durationMs": 1}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('44d43d99-7141-463f-bc2c-87f0e9b25bdc', 'sql', '{"text": "DELETE FROM core.user_roles WHERE user_id = $1", "params": ["20d60a58-2eb4-4725-b696-fc34eae20bc5"], "durationMs": 1}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6255f490-3488-4fc2-8924-5052e128832c', 'sql', '{"text": "SELECT id, code FROM core.roles WHERE code = ANY($1::text[])", "params": [["manager"]], "durationMs": 1}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4092dff1-eadf-4773-aa1d-5a8cd170624b', 'sql', '{"text": "INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)", "params": ["20d60a58-2eb4-4725-b696-fc34eae20bc5", "d2563ab6-c3b7-4a0e-9241-048aa4a999e6"], "durationMs": 0}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('913a6136-e8ab-45d1-b662-e5d69149072a', 'sql', '{"text": "SELECT payload\n     FROM core.settings_values\n     WHERE module_code = ''core'' AND page_code = ''security''\n     LIMIT 1", "durationMs": 0}', '2026-01-27 10:02:15.224762+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bf38e4b4-c5d9-46bb-be4a-80a344bde09d', 'sql', '{"text": "COMMIT", "durationMs": 1}', '2026-01-27 10:02:15.230772+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('62b80e47-6dc6-4a03-b14a-3a2bc413f2e2', 'sql', '{"text": "\n    SELECT\n      u.id,\n      u.email,\n      u.login,\n      u.first_name,\n      u.last_name,\n      u.company_name,\n      u.display_name,\n      u.lang,\n      u.is_active,\n      COALESCE(\n        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),\n        ''{}''\n      ) AS roles\n    FROM core.users u\n    LEFT JOIN core.user_roles ur ON ur.user_id = u.id\n    LEFT JOIN core.roles r ON r.id = ur.role_id\n    WHERE u.id = $1\n    GROUP BY u.id\n    ", "params": ["20d60a58-2eb4-4725-b696-fc34eae20bc5"], "durationMs": 2}', '2026-01-27 10:02:15.233567+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c10cc920-6809-43f3-bdf5-eb13da5aead9', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 14}', '2026-01-27 19:04:32.8841+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1f0eba2c-866e-4eca-b720-0c806040b470', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-27 19:04:32.886248+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('56164c1d-c5ff-4e2c-ae67-558cc6973f9c', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-01-27 19:04:32.891046+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ca80f197-9a70-4f22-aa5d-7c395483c61a', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 2}', '2026-01-27 19:04:32.893677+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('04226974-dbc0-4c9c-b604-7ee7a2733613', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 3}', '2026-01-29 10:16:49.89444+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('316e67cc-f9c2-42b8-8362-052d93168b05', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-01-29 10:16:49.89728+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5b8bc287-e0f2-41ea-a8c2-b2b857ce4f43', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-01-29 10:16:50.106837+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('90982216-0697-4e82-b8e5-ef250c0993d2', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:50.110293+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cb279063-3dbe-48c4-80ab-db12bdd3e529', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:50.112816+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('991e38ce-9a37-455b-9bde-f9836a3fed6e', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:50.335089+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7e6c37d5-8fd1-440b-bcde-34ec369bb3a1', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-29 10:16:50.336943+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7e480351-1d3d-462a-91e4-74fa0f5a2b42', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:50.338564+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7cd8761f-e389-454a-bb67-d0f50adc0c96', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-01-29 10:16:50.340088+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('71851411-1916-4f13-b768-86ccc494d715', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-29 10:16:50.597633+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9582d79b-7811-401a-a945-112fec11be5e', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-01-29 10:16:50.599016+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('df547bd2-0376-4325-9a91-61e15abf44cc', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-29 10:16:50.600037+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('983022e4-243e-4ebe-b4e4-e5bd94e627d6', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 1}', '2026-01-29 10:16:54.073404+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3d69dce7-932f-45c6-ae9a-ca07dbf1f8b5', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-01-29 10:16:54.077331+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('366c2f8b-984a-4cf7-9940-70c11878ef31', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 2}', '2026-01-29 10:16:54.083015+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2a39cb2b-ecc7-463a-973d-776ccd28c31b', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-01-29 10:16:54.086325+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('6a53d312-c890-4560-881d-7c9bbbc62962', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 18}', '2026-01-29 10:16:54.091876+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cbbe0f13-9655-4a98-9e3f-8b1b5e87dc44', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:54.094092+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('febbcb2d-fd16-4395-88a4-5133227efa7b', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:54.096038+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a315eae2-bba8-4c71-8931-a163158cd922', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-01-29 10:16:54.097327+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('39ffee9c-f693-41a3-851b-04f1860585c2', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 2}', '2026-01-29 10:16:54.556298+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4196d171-a997-455e-a1c3-7099539e82ac', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-01-29 10:16:54.5582+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7d7826db-9d05-42ec-9f1f-a4234c511ff3', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-01-29 10:16:54.560934+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b2bcf1ba-56a9-4646-b337-29eba4059c9c', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 3}', '2026-01-29 10:16:57.295418+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bb1d54b3-5834-4bac-8619-1f7a74c1b26d', 'sql', '{"text": "BEGIN", "durationMs": 1}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f43ea229-9265-455a-a28b-8daae5fb4431', 'sql', '{"text": "INSERT INTO core.users\n     (id, email, login, first_name, last_name, company_name, display_name, lang, is_active)\n     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)", "params": ["2b15ed09-991c-4736-96e6-5c6d5dbbb12b", "adn@sissol.ru", null, "ssas", "asas", null, "ssas asas", "ru", true], "durationMs": 1}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e88e13b8-e26b-4604-8841-00860a554399', 'sql', '{"text": "DELETE FROM core.user_roles WHERE user_id = $1", "params": ["2b15ed09-991c-4736-96e6-5c6d5dbbb12b"], "durationMs": 1}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('49f04ce7-e7a2-42a7-8a2e-c2834503e761', 'sql', '{"text": "SELECT id, code FROM core.roles WHERE code = ANY($1::text[])", "params": [["manager"]], "durationMs": 1}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('608b1187-4f1b-4213-adb8-97e6fd3da7a7', 'sql', '{"text": "INSERT INTO core.user_roles (user_id, role_id) VALUES ($1, $2)", "params": ["2b15ed09-991c-4736-96e6-5c6d5dbbb12b", "d2563ab6-c3b7-4a0e-9241-048aa4a999e6"], "durationMs": 0}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('b7f097a8-dc01-467f-9ea6-b0eff2a9d5a0', 'sql', '{"text": "SELECT payload\n     FROM core.settings_values\n     WHERE module_code = ''core'' AND page_code = ''security''\n     LIMIT 1", "durationMs": 0}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d27da776-f7b3-4203-8a85-e2a006e82d4f', 'sql', '{"text": "INSERT INTO core.user_passwords (user_id, password_hash, is_enabled)\n     VALUES ($1, $2, true)\n     ON CONFLICT (user_id)\n     DO UPDATE SET password_hash = EXCLUDED.password_hash, updated_at = now(), is_enabled = true", "params": ["[redacted]", "[redacted]"], "durationMs": 1}', '2026-01-29 10:17:08.461776+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('ed9156cd-9667-46d9-b598-457e726202a5', 'sql', '{"text": "COMMIT", "durationMs": 1}', '2026-01-29 10:17:08.677783+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9e2045c2-e99b-4d79-85d1-f77eff3324fa', 'sql', '{"text": "\n    SELECT\n      u.id,\n      u.email,\n      u.login,\n      u.first_name,\n      u.last_name,\n      u.company_name,\n      u.display_name,\n      u.lang,\n      u.is_active,\n      COALESCE(\n        ARRAY_AGG(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL),\n        ''{}''\n      ) AS roles\n    FROM core.users u\n    LEFT JOIN core.user_roles ur ON ur.user_id = u.id\n    LEFT JOIN core.roles r ON r.id = ur.role_id\n    WHERE u.id = $1\n    GROUP BY u.id\n    ", "params": ["2b15ed09-991c-4736-96e6-5c6d5dbbb12b"], "durationMs": 2}', '2026-01-29 10:17:08.680639+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a5824dc6-7269-4e6a-9059-a3ee47778f27', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 11}', '2026-01-31 14:25:55.308447+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('4baf372e-fd9e-40f3-b038-8eb2acc15ae6', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-01-31 14:25:55.309813+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1a57595c-8e44-41dd-84f6-94a8642f62d3', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-01-31 14:25:55.314133+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1e3c021d-d14c-4773-aae1-b9fbcce95205', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 0}', '2026-01-31 14:25:55.315559+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e43eda51-e443-47c2-b70f-d63848a85e61', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 13}', '2026-02-02 04:34:01.234165+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('8b76755b-f532-47d6-a1db-00dc2def413b', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 1}', '2026-02-02 04:34:01.236306+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cab8f165-e04c-496d-820b-38744146ab2b', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-02-02 04:34:01.442277+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('a735c9bd-8b92-4fcd-bf19-d67a1baa7693', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:01.444906+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('fcf1e65e-18ad-4340-ae90-6d76824646a9', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:01.446328+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('7725df4a-d44e-469c-9d0d-8d531ef58e9c', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-02-02 04:34:01.671164+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2924a1f0-316c-49a6-a568-23b0ec236006', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:01.672523+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('0ad88c6b-b621-4392-b0a6-fc23619e5ed7', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:01.673719+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('656bf69f-4c4d-4fdc-a605-4625cf661b63', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-02-02 04:34:01.674607+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d0365ce8-bb23-4e69-aa7a-8f98c9d73189', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 3}', '2026-02-02 04:34:01.921075+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cb1c8785-8d1f-4ad5-b10c-9ff12673eb41', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 2}', '2026-02-02 04:34:01.923663+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('44cc3073-aa08-47ac-8a6d-89deabee0246', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-02-02 04:34:01.924629+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cafb9679-db55-47c6-b25e-84e86b6f37e5', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 3}', '2026-02-02 04:34:05.342834+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d9f91466-184e-4e1b-afc5-f0634494af57', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 0}', '2026-02-02 04:34:05.345965+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('95c12dba-224f-46f0-95d8-1079b799c590', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-02-02 04:34:05.351399+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('1651c87e-6a84-40bd-8f55-33be24d08389', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-02-02 04:34:05.35672+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e16f4abb-ace2-4c66-8045-eda472372f39', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 24}', '2026-02-02 04:34:05.365309+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('896a42be-0237-4f2b-ac11-fb87078af5aa', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-02-02 04:34:05.369402+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cfc46f6a-05c9-4ca7-a4bf-8b9f75a91d72', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:05.371259+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d012e756-2780-4cf8-9807-21773916861e', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-02 04:34:05.372479+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('3cd603a9-3978-46f6-84bd-3f90625e806e', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-02-02 04:34:05.845108+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5dad89a1-2e71-4161-81f6-f60a11c10212', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 1}', '2026-02-02 04:34:05.846484+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('14f53258-e63c-4b34-a65d-5374912a3bca', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-02-02 04:34:05.847546+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('aa720fbe-e7c7-4e75-8e03-b42da3e24b44', 'sql', '{"text": "SELECT code, name, is_active, is_default\n     FROM core.languages\n     ORDER BY is_default DESC, name ASC", "durationMs": 3}', '2026-02-04 03:06:01.640551+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c52eb7ec-c879-427c-bfaa-5ecde255c712', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-02-04 03:06:01.642927+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2ebebe2c-e2b9-4d30-a95c-82e0271b6aa2', 'sql', '{"text": "SELECT t.key, t.lang AS language_code, t.value\n     FROM core.translations t\n     JOIN core.languages l ON l.code = t.lang AND l.is_active = true", "durationMs": 3}', '2026-02-04 03:06:01.64695+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9b9b78dd-8508-49e0-b290-50f5ec53f944', 'sql', '{"text": "SELECT from_key, to_key FROM core.translation_aliases", "durationMs": 1}', '2026-02-04 03:06:01.648753+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('9dad046a-2f02-4eb3-8590-634d2720aed2', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE email = $1", "params": ["admin@sissol.ru"], "durationMs": 1}', '2026-02-04 03:06:03.979285+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('e8d5bdcc-51ac-4ce3-9c54-04e52ffad973', 'sql', '{"text": "SELECT password_hash, is_enabled\n     FROM core.user_passwords\n     WHERE user_id = $1\n     LIMIT 1", "params": ["[redacted]"], "durationMs": 0}', '2026-02-04 03:06:03.981297+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('15c32f52-cdda-45a8-9528-963030edc643', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 2}', '2026-02-04 03:06:04.158215+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5debaae5-9fd6-4ee9-9a66-189da9ad185e', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-04 03:06:04.161033+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('c0f0d066-f151-48ca-a76b-83ec5f852e02', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-02-04 03:06:04.163112+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('2e2d0943-90d3-4ebe-80ad-8d04b9dbfcc2', 'sql', '{"text": "\n  SELECT\n    id,\n    email,\n    COALESCE(\n      display_name,\n      trim(concat_ws('' '', first_name, last_name))\n    ) AS display_name,\n    lang,\n    is_active\n  FROM core.users\n\n     WHERE id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-04 03:06:04.343495+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('5e7eb35a-47f3-47ff-ba82-6dc8caab0ab1', 'sql', '{"text": "SELECT r.id, r.code, r.name_key\n     FROM core.user_roles ur\n     JOIN core.roles r ON r.id = ur.role_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-02-04 03:06:04.345148+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('62ae9b10-c180-436e-8a07-409e5a6bcd33', 'sql', '{"text": "SELECT DISTINCT p.code, rp.scope\n     FROM core.user_roles ur\n     JOIN core.role_permissions rp ON rp.role_id = ur.role_id\n     JOIN core.permissions p ON p.id = rp.permission_id\n     WHERE ur.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 1}', '2026-02-04 03:06:04.346694+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('bcb2f16b-4e43-4af2-9546-9c6dad62030e', 'sql', '{"text": "SELECT g.id, g.code, g.name_key\n     FROM core.user_groups ug\n     JOIN core.groups g ON g.id = ug.group_id\n     WHERE ug.user_id = $1", "params": ["deb310f2-a91e-4f73-9d1e-880003e8baa6"], "durationMs": 0}', '2026-02-04 03:06:04.347768+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('d1d6e9fc-f2ac-41b8-9da9-f72aaae35704', 'sql', '{"text": "SELECT code FROM core.languages WHERE is_default = true LIMIT 1", "durationMs": 1}', '2026-02-04 03:06:04.545697+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('f1d40566-c672-4d5d-aefd-62fbc8bb7b55', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "system"], "durationMs": 0}', '2026-02-04 03:06:04.547052+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('01efcde4-80ea-49af-a2ce-23b5657b2667', 'sql', '{"text": "SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2", "params": ["core", "security"], "durationMs": 0}', '2026-02-04 03:06:04.548167+00');
INSERT INTO bull.bull_log (id, queue, payload, created_at) VALUES ('cefcf492-e949-4871-998c-2000b6f03d55', 'sql', '{"text": "SELECT r.id AS role_id,\n            r.code AS role_code,\n            r.name_key AS role_name_key,\n            p.code AS permission_code,\n            rp.scope AS scope\n     FROM core.roles r\n     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id\n     LEFT JOIN core.permissions p ON p.id = rp.permission_id\n     ORDER BY r.code ASC, p.code ASC", "durationMs": 15}', '2026-02-04 03:06:10.110579+00');


--
-- Data for Name: access_policies; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: authz_tuples; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: departments; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: department_users; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: groups; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.roles (id, code, name_key, created_at) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', 'admin', 'core.role.admin', '2025-12-29 18:31:45.414129+00');
INSERT INTO core.roles (id, code, name_key, created_at) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', 'super_admin', 'roles_super_admin_name', '2026-01-17 14:21:56.722952+00');
INSERT INTO core.roles (id, code, name_key, created_at) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', 'manager', 'roles_manager_name', '2026-01-17 14:21:56.722952+00');


--
-- Data for Name: group_roles; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: i18n_keys; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('app_loading', 'Global loading state', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('layout_brand_title', 'Header brand title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('layout_brand_subtitle', 'Header brand subtitle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('layout_status_online', 'User online status', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('layout_action_logout', 'Logout action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('sidebar_settings', 'Sidebar settings link', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_subtitle', 'Login subtitle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_email_label', 'Email label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_password_label', 'Password label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_email_placeholder', 'Email placeholder', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_password_placeholder', 'Password placeholder', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_button_idle', 'Login submit idle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_button_loading', 'Login submit loading', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_error_invalid_credentials', 'Invalid credentials error', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_error_invalid_request', 'Invalid request error', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('auth_error_generic', 'Generic auth error', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_scope_core', 'Settings scope label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_title', 'Settings title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_badge_admin', 'Admin badge', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_nav_system', 'Nav item System', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_nav_users', 'Nav item Users', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_nav_roles', 'Nav item Roles', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_nav_languages', 'Nav item Languages', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_nav_audit', 'Nav item Audit', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_access_denied_title', 'Access denied title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_access_denied_body', 'Access denied body', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_label', 'System label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_general', 'System general title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_name', 'System name field', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_default_language', 'Default language field', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_timezone', 'Timezone field', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_developer_mode', 'Developer mode field', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_developer_mode_on', 'Developer mode enabled', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_developer_mode_off', 'Developer mode disabled', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_save_general', 'Save general action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_security', 'System security title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_local_passwords', 'Local passwords toggle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_sso', 'SSO toggle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_jwt_ttl', 'JWT TTL field', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_multiple_sessions', 'Multiple sessions toggle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_save', 'Save security action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_system_saved', 'System general saved banner', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_security_saved', 'Security saved banner', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_label', 'Users label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_title', 'Users title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_create', 'Create user action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_deactivate', 'Deactivate user action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_change_language', 'Change language action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_reset_password', 'Reset password action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_email', 'User email column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_first_name', 'User first name column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_last_name', 'User last name column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_company', 'User company column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_status', 'User status column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_language', 'User language column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_roles', 'User roles column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_groups', 'User groups column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_users_department', 'User department column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_active', 'Active status', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_inactive', 'Inactive status', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_departments_title', 'Departments title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_departments_lead', 'Department lead label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_departments_add', 'Add department action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_groups_title', 'Groups title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_groups_add', 'Add group action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_label', 'Roles & access label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_title', 'Roles title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_code', 'Role code column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_name', 'Role name column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_scope', 'Role scope column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_permissions', 'Role permissions column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_roles_add', 'Add role action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_permissions_title', 'Permissions title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_permissions_hint', 'Permissions hint', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_policies_title', 'Access policies title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_policies_apply', 'Policy applies to label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_policies_add', 'Create policy action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_label', 'Languages label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_title', 'Languages title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_code', 'Language code column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_name', 'Language name column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_status', 'Language status column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_default', 'Language default column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_enabled_count', 'Enabled languages count', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_add', 'Add language action', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_enabled', 'Enabled status', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_disabled', 'Disabled status', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_yes', 'Affirmative label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('status_no', 'Negative label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_title', 'Translations title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_key', 'Translation key column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_value', 'Translation value column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_language', 'Translation language column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_aliases', 'Translation aliases column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_label', 'Audit label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_title', 'Audit logs title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_from', 'Audit filter from', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_to', 'Audit filter to', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_event', 'Audit filter event', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_any', 'Audit filter any', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_search', 'Audit filter search payload', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_filter_limit', 'Audit filter limit', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_table_date', 'Audit date column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_table_event', 'Audit event column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_table_user', 'Audit user column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_table_entity', 'Audit entity column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_table_payload', 'Audit payload column', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_page', 'Audit page indicator', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('common_prev', 'Previous button', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('common_next', 'Next button', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('common_read_only', 'Read-only marker', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_audit_payload_source', 'Audit payload source', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('roles_owner_name', 'Role owner display name', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('roles_manager_name', 'Role manager display name', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('roles_viewer_name', 'Role viewer display name', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('policies_invite_only_managers', 'Policy description for managers', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('policies_support_only', 'Policy description for support group', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('policies_vendor_scope', 'Policy description for vendors', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('app_language_selector_label', 'Language selector label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_form_title', 'Languages form title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_form_code', 'Languages form code', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_form_name', 'Languages form name', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_form_is_default', 'Languages form default toggle', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_form_submit', 'Languages form submit', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_form_title', 'Translations form title', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_form_key', 'Translations form key', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_form_value', 'Translations form value', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_form_language', 'Translations form language', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_translations_form_submit', 'Translations form submit', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_status_toggle', 'Languages status toggle label', '2026-01-03 22:34:32.475113');
INSERT INTO core.i18n_keys (key, description, created_at) VALUES ('settings_languages_default_toggle', 'Languages default toggle label', '2026-01-03 22:34:32.475113');


--
-- Data for Name: languages; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.languages (code, name, is_active, created_at, is_default) VALUES ('en', 'English', true, '2025-12-30 13:23:31.460409+00', true);
INSERT INTO core.languages (code, name, is_active, created_at, is_default) VALUES ('ru', 'Русский', true, '2025-12-30 13:23:31.460409+00', false);
INSERT INTO core.languages (code, name, is_active, created_at, is_default) VALUES ('pl', 'Polski', true, '2025-12-30 13:23:31.460409+00', false);


--
-- Data for Name: i18n_translations; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('app_loading', 'en', 'Loading...');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_brand_title', 'en', 'SISSOL CRM');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_brand_subtitle', 'en', 'Core interface');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_status_online', 'en', 'Online');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_action_logout', 'en', 'Logout');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('sidebar_settings', 'en', 'Settings');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_subtitle', 'en', 'Sign in to continue');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_email_label', 'en', 'Email');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_password_label', 'en', 'Password');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_email_placeholder', 'en', 'you@example.com');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_password_placeholder', 'en', '••••••••');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_button_idle', 'en', 'Sign in');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_button_loading', 'en', 'Signing in...');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_invalid_credentials', 'en', 'Invalid email or password');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_invalid_request', 'en', 'Enter email and password');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_generic', 'en', 'Authentication error');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_scope_core', 'en', 'Core');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_title', 'en', 'Settings');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_badge_admin', 'en', 'Admin');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_system', 'en', 'System');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_users', 'en', 'Users');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_roles', 'en', 'Roles & Access');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_languages', 'en', 'Languages & translations');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_audit', 'en', 'Audit Logs');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_access_denied_title', 'en', 'Access denied');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_access_denied_body', 'en', 'Permission settings.view is required to open Core Settings.');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_label', 'en', 'System');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_general', 'en', 'General');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_name', 'en', 'System name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_default_language', 'en', 'Default language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_timezone', 'en', 'Timezone');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode', 'en', 'Developer mode');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode_on', 'en', 'Payloads and SQL are logged (no passwords)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode_off', 'en', 'Errors and warnings only');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_save_general', 'en', 'Save general');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_security', 'en', 'Security');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_local_passwords', 'en', 'Enable local passwords');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_sso', 'en', 'Enable SSO');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_jwt_ttl', 'en', 'JWT TTL (minutes)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_multiple_sessions', 'en', 'Allow multiple sessions');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_save', 'en', 'Save security');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_saved', 'en', 'System general saved (POST /api/core/v1/settings/system)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_saved', 'en', 'Security saved (POST /api/core/v1/settings/security)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_label', 'en', 'Users');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_title', 'en', 'Users');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_create', 'en', 'Create user');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_deactivate', 'en', 'Deactivate');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_change_language', 'en', 'Change language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_reset_password', 'en', 'Reset password');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_email', 'en', 'Email');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_first_name', 'en', 'First name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_last_name', 'en', 'Last name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_company', 'en', 'Company');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_status', 'en', 'Status');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_language', 'en', 'Language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_roles', 'en', 'Roles');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_groups', 'en', 'Groups');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_department', 'en', 'Department');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_active', 'en', 'active');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_inactive', 'en', 'inactive');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_title', 'en', 'Departments');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_lead', 'en', 'Lead');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_add', 'en', 'Add department');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_groups_title', 'en', 'Groups');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_groups_add', 'en', 'Add group');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_label', 'en', 'Roles & Access');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_title', 'en', 'Roles');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_code', 'en', 'Code');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_name', 'en', 'Name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_scope', 'en', 'Scope');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_permissions', 'en', 'Permissions');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_add', 'en', 'Add role');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_permissions_title', 'en', 'Permissions');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_permissions_hint', 'en', 'System permissions are not editable, only assignable.');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_title', 'en', 'Access Policies (ABAC)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_apply', 'en', 'Applies to');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_add', 'en', 'Create policy');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_label', 'en', 'Languages');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_title', 'en', 'Languages');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_code', 'en', 'Code');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_name', 'en', 'Name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_status', 'en', 'Status');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_default', 'en', 'Default');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_enabled_count', 'en', 'Enabled languages: {{count}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_add', 'en', 'Add language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_enabled', 'en', 'enabled');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_disabled', 'en', 'disabled');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_yes', 'en', 'Yes');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_no', 'en', '—');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_title', 'en', 'Translations');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_key', 'en', 'Key');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_value', 'en', 'Value');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_language', 'en', 'Language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_aliases', 'en', 'Aliases');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_label', 'en', 'Audit');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_title', 'en', 'Audit Logs');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_from', 'en', 'From');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_to', 'en', 'To');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_event', 'en', 'Event');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_any', 'en', 'Any');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_search', 'en', 'Search payload');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_limit', 'en', 'Limit');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_date', 'en', 'Date / Time');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_event', 'en', 'Event');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_user', 'en', 'User');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_entity', 'en', 'Entity');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_payload', 'en', 'Payload');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_page', 'en', 'Page {{page}} of {{total}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_prev', 'en', 'Prev');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_next', 'en', 'Next');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_read_only', 'en', 'read-only');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_payload_source', 'en', 'Source: audit.audit_log · id {{id}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_owner_name', 'en', 'Owner');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_manager_name', 'en', 'Department manager');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_viewer_name', 'en', 'Read only');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_invite_only_managers', 'en', 'Only managers can invite new users');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_support_only', 'en', 'Support role only in support group');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_vendor_scope', 'en', 'Vendors can access vendor entities only');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('app_language_selector_label', 'en', 'Language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_title', 'en', 'Add language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_code', 'en', 'Code');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_name', 'en', 'Name');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_is_default', 'en', 'Make default');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_submit', 'en', 'Save language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_title', 'en', 'Add translation');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_key', 'en', 'Key');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_value', 'en', 'Value');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_language', 'en', 'Language');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_submit', 'en', 'Save translation');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_status_toggle', 'en', 'Active');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_default_toggle', 'en', 'Default');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('app_loading', 'ru', 'Загрузка...');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_brand_title', 'ru', 'SISSOL CRM');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_brand_subtitle', 'ru', 'Интерфейс ядра');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_status_online', 'ru', 'Онлайн');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('layout_action_logout', 'ru', 'Выйти');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('sidebar_settings', 'ru', 'Настройки');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_subtitle', 'ru', 'Войдите, чтобы продолжить');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_email_label', 'ru', 'Email');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_password_label', 'ru', 'Пароль');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_email_placeholder', 'ru', 'you@example.com');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_password_placeholder', 'ru', '••••••••');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_button_idle', 'ru', 'Войти');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_button_loading', 'ru', 'Вход...');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_invalid_credentials', 'ru', 'Неверный email или пароль');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_invalid_request', 'ru', 'Введите email и пароль');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('auth_error_generic', 'ru', 'Ошибка авторизации');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_scope_core', 'ru', 'Ядро');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_title', 'ru', 'Настройки');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_badge_admin', 'ru', 'Админ');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_system', 'ru', 'Система');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_users', 'ru', 'Пользователи');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_roles', 'ru', 'Роли и доступ');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_languages', 'ru', 'Языки и переводы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_nav_audit', 'ru', 'Аудит');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_access_denied_title', 'ru', 'Недостаточно прав');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_access_denied_body', 'ru', 'Нужен permission settings.view, чтобы открыть Core Settings.');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_label', 'ru', 'Система');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_general', 'ru', 'Общее');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_name', 'ru', 'Название системы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_default_language', 'ru', 'Язык по умолчанию');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_timezone', 'ru', 'Часовой пояс');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode', 'ru', 'Режим разработчика');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode_on', 'ru', 'Логируются payload и SQL (без паролей)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_developer_mode_off', 'ru', 'Только ошибки и предупреждения');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_save_general', 'ru', 'Сохранить общее');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_security', 'ru', 'Безопасность');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_local_passwords', 'ru', 'Включить локальные пароли');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_sso', 'ru', 'Включить SSO');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_jwt_ttl', 'ru', 'JWT TTL (минуты)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_multiple_sessions', 'ru', 'Разрешить несколько сессий');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_save', 'ru', 'Сохранить безопасность');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_system_saved', 'ru', 'Общие настройки сохранены (POST /api/core/v1/settings/system)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_security_saved', 'ru', 'Безопасность сохранена (POST /api/core/v1/settings/security)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_label', 'ru', 'Пользователи');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_title', 'ru', 'Пользователи');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_create', 'ru', 'Создать пользователя');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_deactivate', 'ru', 'Деактивировать');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_change_language', 'ru', 'Сменить язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_reset_password', 'ru', 'Сбросить пароль');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_email', 'ru', 'Email');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_first_name', 'ru', 'Имя');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_last_name', 'ru', 'Фамилия');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_company', 'ru', 'Компания');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_status', 'ru', 'Статус');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_language', 'ru', 'Язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_roles', 'ru', 'Роли');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_groups', 'ru', 'Группы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_users_department', 'ru', 'Департамент');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_active', 'ru', 'активен');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_inactive', 'ru', 'неактивен');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_title', 'ru', 'Департаменты');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_lead', 'ru', 'Руководитель');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_departments_add', 'ru', 'Добавить департамент');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_groups_title', 'ru', 'Группы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_groups_add', 'ru', 'Добавить группу');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_label', 'ru', 'Роли и доступ');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_title', 'ru', 'Роли');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_code', 'ru', 'Код');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_name', 'ru', 'Название');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_scope', 'ru', 'Область');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_permissions', 'ru', 'Права');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_roles_add', 'ru', 'Добавить роль');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_permissions_title', 'ru', 'Права доступа');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_permissions_hint', 'ru', 'Системные permissions не редактируются, только назначаются.');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_title', 'ru', 'Политики доступа (ABAC)');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_apply', 'ru', 'Применяется к');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_policies_add', 'ru', 'Создать политику');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_label', 'ru', 'Языки');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_title', 'ru', 'Языки');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_code', 'ru', 'Код');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_name', 'ru', 'Название');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_status', 'ru', 'Статус');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_default', 'ru', 'По умолчанию');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_enabled_count', 'ru', 'Включено языков: {{count}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_add', 'ru', 'Добавить язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_enabled', 'ru', 'включен');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_disabled', 'ru', 'выключен');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_yes', 'ru', 'Да');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('status_no', 'ru', '—');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_title', 'ru', 'Переводы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_key', 'ru', 'Ключ');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_value', 'ru', 'Значение');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_language', 'ru', 'Язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_aliases', 'ru', 'Алиасы');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_label', 'ru', 'Аудит');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_title', 'ru', 'Логи аудита');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_from', 'ru', 'С');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_to', 'ru', 'По');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_event', 'ru', 'Событие');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_any', 'ru', 'Любое');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_search', 'ru', 'Поиск по payload');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_filter_limit', 'ru', 'Лимит');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_date', 'ru', 'Дата / Время');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_event', 'ru', 'Событие');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_user', 'ru', 'Пользователь');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_entity', 'ru', 'Сущность');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_table_payload', 'ru', 'Payload');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_page', 'ru', 'Страница {{page}} из {{total}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_prev', 'ru', 'Назад');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_next', 'ru', 'Вперед');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('common_read_only', 'ru', 'только чтение');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_audit_payload_source', 'ru', 'Источник: audit.audit_log · id {{id}}');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_owner_name', 'ru', 'Владелец');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_manager_name', 'ru', 'Руководитель отдела');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('roles_viewer_name', 'ru', 'Только чтение');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_invite_only_managers', 'ru', 'Только менеджеры могут приглашать новых пользователей');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_support_only', 'ru', 'Роль support только в группе support');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('policies_vendor_scope', 'ru', 'Поставщики видят только свои сущности');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('app_language_selector_label', 'ru', 'Язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_title', 'ru', 'Добавить язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_code', 'ru', 'Код');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_name', 'ru', 'Название');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_is_default', 'ru', 'Сделать основным');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_form_submit', 'ru', 'Сохранить язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_title', 'ru', 'Добавить перевод');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_key', 'ru', 'Ключ');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_value', 'ru', 'Значение');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_language', 'ru', 'Язык');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_translations_form_submit', 'ru', 'Сохранить перевод');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_status_toggle', 'ru', 'Активен');
INSERT INTO core.i18n_translations (key, language_code, value) VALUES ('settings_languages_default_toggle', 'ru', 'Основной');


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.permissions (id, code, description, created_at) VALUES ('78f68fe2-20a6-41cf-9f36-1f841353b4fd', 'settings.system.view', 'View system settings', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('ffc86213-f01a-4b5c-8585-b0aece1eaf20', 'settings.system.edit', 'Edit system settings', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('20414790-f714-4163-8340-3c0303878fc0', 'settings.users.view', 'View users', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('dd9d319b-f3c1-4400-a8d5-4ee999281cc4', 'settings.users.edit', 'Manage users', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('2307ce4b-63ad-4c6d-92ad-3586f8faf6d6', 'settings.access.view', 'View access rules', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('7b197498-d381-4378-bba7-a2ec1d2f16ee', 'settings.access.edit', 'Edit access rules', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('30d55854-b2bd-49e8-99bd-e0e2b342dbcc', 'settings.languages.edit', 'Edit languages', '2025-12-29 22:21:43.296418+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('9b5f49d2-9b46-4090-a3ed-0af6910db0fb', 'settings.view', 'View system settings', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('041d96d0-8ab1-419d-9ae3-2ed4cd985652', 'settings.edit', 'Edit system settings', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('38b389a9-e5d3-45d2-8211-45d8a8527033', 'users.view', 'View users', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('9d148ff5-9b5a-4a61-8d4c-1110cf57c43d', 'users.manage', 'Manage users', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('32184ed8-1cfd-42ea-90e2-195e12aefc13', 'users.roles.assign', 'Assign user roles', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('1aae2c5a-5a38-4863-b1c2-f625d75c922a', 'roles.view', 'View roles', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('7bf22120-f617-4f2e-9d59-2bf0f32dd0c5', 'roles.manage', 'Manage roles', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('88852563-471e-4a4b-98f6-e5afa67179b7', 'permissions.view', 'View permissions', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('35f92534-d075-4d31-823f-7c3df7f4d8c5', 'i18n.languages.view', 'View languages', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('a1a2b23f-1aa2-44d0-ac25-fbad79bda1f6', 'i18n.languages.manage', 'Manage languages', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('f86337c0-cf0c-4c8e-a81b-c25e53620bc3', 'i18n.translations.view', 'View translations', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('59143c34-e35a-42b5-8fc2-4e053415e5e0', 'i18n.translations.manage', 'Manage translations', '2026-01-17 13:52:15.845287+00');
INSERT INTO core.permissions (id, code, description, created_at) VALUES ('5384c8ca-be32-4afc-8bd1-c9c01ace32dd', 'audit.view', 'View audit logs', '2026-01-17 13:52:15.845287+00');


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '78f68fe2-20a6-41cf-9f36-1f841353b4fd', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', 'ffc86213-f01a-4b5c-8585-b0aece1eaf20', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '20414790-f714-4163-8340-3c0303878fc0', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', 'dd9d319b-f3c1-4400-a8d5-4ee999281cc4', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '2307ce4b-63ad-4c6d-92ad-3586f8faf6d6', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '7b197498-d381-4378-bba7-a2ec1d2f16ee', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '30d55854-b2bd-49e8-99bd-e0e2b342dbcc', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '78f68fe2-20a6-41cf-9f36-1f841353b4fd', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', 'ffc86213-f01a-4b5c-8585-b0aece1eaf20', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '20414790-f714-4163-8340-3c0303878fc0', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', 'dd9d319b-f3c1-4400-a8d5-4ee999281cc4', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '2307ce4b-63ad-4c6d-92ad-3586f8faf6d6', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '7b197498-d381-4378-bba7-a2ec1d2f16ee', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '30d55854-b2bd-49e8-99bd-e0e2b342dbcc', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '9b5f49d2-9b46-4090-a3ed-0af6910db0fb', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '041d96d0-8ab1-419d-9ae3-2ed4cd985652', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '38b389a9-e5d3-45d2-8211-45d8a8527033', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '9d148ff5-9b5a-4a61-8d4c-1110cf57c43d', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '32184ed8-1cfd-42ea-90e2-195e12aefc13', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '1aae2c5a-5a38-4863-b1c2-f625d75c922a', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '7bf22120-f617-4f2e-9d59-2bf0f32dd0c5', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '88852563-471e-4a4b-98f6-e5afa67179b7', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '35f92534-d075-4d31-823f-7c3df7f4d8c5', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', 'a1a2b23f-1aa2-44d0-ac25-fbad79bda1f6', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', 'f86337c0-cf0c-4c8e-a81b-c25e53620bc3', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '59143c34-e35a-42b5-8fc2-4e053415e5e0', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('1c28b41a-556a-4462-8323-cb341d975c11', '5384c8ca-be32-4afc-8bd1-c9c01ace32dd', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '9b5f49d2-9b46-4090-a3ed-0af6910db0fb', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '041d96d0-8ab1-419d-9ae3-2ed4cd985652', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '38b389a9-e5d3-45d2-8211-45d8a8527033', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '9d148ff5-9b5a-4a61-8d4c-1110cf57c43d', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '32184ed8-1cfd-42ea-90e2-195e12aefc13', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '1aae2c5a-5a38-4863-b1c2-f625d75c922a', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '7bf22120-f617-4f2e-9d59-2bf0f32dd0c5', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '88852563-471e-4a4b-98f6-e5afa67179b7', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '35f92534-d075-4d31-823f-7c3df7f4d8c5', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', 'a1a2b23f-1aa2-44d0-ac25-fbad79bda1f6', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', 'f86337c0-cf0c-4c8e-a81b-c25e53620bc3', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '59143c34-e35a-42b5-8fc2-4e053415e5e0', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('34cd294f-5d7f-422b-b719-b3b997fdbdeb', '5384c8ca-be32-4afc-8bd1-c9c01ace32dd', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '9b5f49d2-9b46-4090-a3ed-0af6910db0fb', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '38b389a9-e5d3-45d2-8211-45d8a8527033', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '1aae2c5a-5a38-4863-b1c2-f625d75c922a', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '88852563-471e-4a4b-98f6-e5afa67179b7', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '35f92534-d075-4d31-823f-7c3df7f4d8c5', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', 'f86337c0-cf0c-4c8e-a81b-c25e53620bc3', 'all');
INSERT INTO core.role_permissions (role_id, permission_id, scope) VALUES ('d2563ab6-c3b7-4a0e-9241-048aa4a999e6', '5384c8ca-be32-4afc-8bd1-c9c01ace32dd', 'all');


--
-- Data for Name: settings_modules; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.settings_modules (id, code, title_key, icon, sort_order, is_system, enabled) VALUES ('e9b31bab-a2da-4a03-acdb-3d19ff901871', 'system', 'settings.system.title', 'settings', 1, true, true);
INSERT INTO core.settings_modules (id, code, title_key, icon, sort_order, is_system, enabled) VALUES ('efa75f76-b3be-4b9f-a96e-16359987304b', 'core', 'settings_scope_core', 'settings', 10, true, true);


--
-- Data for Name: settings_pages; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.settings_pages (id, module_id, code, title_key, permission_code, sort_order) VALUES ('141415e1-2c99-4487-b059-a0e3eb91fa74', 'efa75f76-b3be-4b9f-a96e-16359987304b', 'system', 'settings_nav_system', 'settings.view', 10);
INSERT INTO core.settings_pages (id, module_id, code, title_key, permission_code, sort_order) VALUES ('f37e28f7-b01c-4e5c-b488-ed1f2ec6dec6', 'efa75f76-b3be-4b9f-a96e-16359987304b', 'users', 'settings_nav_users', 'users.view', 20);
INSERT INTO core.settings_pages (id, module_id, code, title_key, permission_code, sort_order) VALUES ('24c7ba17-28a3-417d-b305-0b3334ca6075', 'efa75f76-b3be-4b9f-a96e-16359987304b', 'roles', 'settings_nav_roles', 'roles.view', 30);
INSERT INTO core.settings_pages (id, module_id, code, title_key, permission_code, sort_order) VALUES ('2fec2c78-1741-4321-95d9-8786ae04b5ce', 'efa75f76-b3be-4b9f-a96e-16359987304b', 'languages', 'settings_nav_languages', 'i18n.languages.view', 40);
INSERT INTO core.settings_pages (id, module_id, code, title_key, permission_code, sort_order) VALUES ('821576b4-36e2-4b5b-a501-a86fbd5475ee', 'efa75f76-b3be-4b9f-a96e-16359987304b', 'audit', 'settings_nav_audit', 'audit.view', 50);


--
-- Data for Name: settings_values; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.settings_values (module_code, page_code, payload, updated_by, created_at, updated_at) VALUES ('core', 'system', '{"timezone": "UTC", "systemName": "SISSOL CRM", "developerMode": true, "defaultLanguage": "en"}', 'deb310f2-a91e-4f73-9d1e-880003e8baa6', '2026-01-17 14:33:13.469352+00', '2026-01-17 14:33:13.469352+00');


--
-- Data for Name: translation_aliases; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: translations; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('core.role.admin', 'ru', 'Администратор', '2025-12-29 18:31:45.414659+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('core.role.admin', 'en', 'Administrator', '2025-12-29 18:31:45.414659+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_super_admin_name', 'en', 'Super administrator', '2026-01-17 14:21:56.722952+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_super_admin_name', 'ru', 'Суперадминистратор', '2026-01-17 14:21:56.722952+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_admin_name', 'en', 'Administrator', '2026-01-17 14:21:56.722952+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_admin_name', 'ru', 'Администратор', '2026-01-17 14:21:56.722952+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('app_loading', 'en', 'Loading...', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_brand_title', 'en', 'SISSOL CRM', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_brand_subtitle', 'en', 'Core interface', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_status_online', 'en', 'Online', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_action_logout', 'en', 'Logout', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('sidebar_settings', 'en', 'Settings', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_subtitle', 'en', 'Sign in to continue', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_password_label', 'en', 'Password', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_email_placeholder', 'en', 'you@example.com', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_password_placeholder', 'en', '••••••••', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_button_idle', 'en', 'Sign in', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_button_loading', 'en', 'Signing in...', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_invalid_credentials', 'en', 'Invalid email or password', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_invalid_request', 'en', 'Enter email and password', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_generic', 'en', 'Authentication error', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_scope_core', 'en', 'Core', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_title', 'en', 'Settings', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_badge_admin', 'en', 'Admin', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_system', 'en', 'System', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_users', 'en', 'Users', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_roles', 'en', 'Roles & Access', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_languages', 'en', 'Languages & translations', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_audit', 'en', 'Audit Logs', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_access_denied_title', 'en', 'Access denied', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_access_denied_body', 'en', 'Permission settings.view is required to open Core Settings.', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_label', 'en', 'System', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_general', 'en', 'General', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_name', 'en', 'System name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_default_language', 'en', 'Default language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_timezone', 'en', 'Timezone', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode', 'en', 'Developer mode', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode_on', 'en', 'Payloads and SQL are logged (no passwords)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode_off', 'en', 'Errors and warnings only', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_save_general', 'en', 'Save general', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_security', 'en', 'Security', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_local_passwords', 'en', 'Enable local passwords', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_sso', 'en', 'Enable SSO', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_jwt_ttl', 'en', 'JWT TTL (minutes)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_multiple_sessions', 'en', 'Allow multiple sessions', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_save', 'en', 'Save security', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_saved', 'en', 'System general saved (POST /api/core/v1/settings/system)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_saved', 'en', 'Security saved (POST /api/core/v1/settings/security)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_label', 'en', 'Users', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_title', 'en', 'Users', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_create', 'en', 'Create user', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_deactivate', 'en', 'Deactivate', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_change_language', 'en', 'Change language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_reset_password', 'en', 'Reset password', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_email', 'en', 'Email', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_first_name', 'en', 'First name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_last_name', 'en', 'Last name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_company', 'en', 'Company', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_status', 'en', 'Status', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_language', 'en', 'Language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_roles', 'en', 'Roles', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_groups', 'en', 'Groups', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_department', 'en', 'Department', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_active', 'en', 'active', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_inactive', 'en', 'inactive', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_title', 'en', 'Departments', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_lead', 'en', 'Lead', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_add', 'en', 'Add department', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_groups_title', 'en', 'Groups', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_groups_add', 'en', 'Add group', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_label', 'en', 'Roles & Access', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_title', 'en', 'Roles', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_code', 'en', 'Code', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_name', 'en', 'Name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_scope', 'en', 'Scope', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_permissions', 'en', 'Permissions', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_add', 'en', 'Add role', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_permissions_title', 'en', 'Permissions', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_permissions_hint', 'en', 'System permissions are not editable, only assignable.', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_title', 'en', 'Access Policies (ABAC)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_apply', 'en', 'Applies to', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_add', 'en', 'Create policy', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_label', 'en', 'Languages', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_title', 'en', 'Languages', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_code', 'en', 'Code', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_name', 'en', 'Name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_status', 'en', 'Status', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_default', 'en', 'Default', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_enabled_count', 'en', 'Enabled languages: {{count}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_add', 'en', 'Add language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_enabled', 'en', 'enabled', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_disabled', 'en', 'disabled', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_yes', 'en', 'Yes', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_no', 'en', '—', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_title', 'en', 'Translations', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_key', 'en', 'Key', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_value', 'en', 'Value', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_language', 'en', 'Language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_aliases', 'en', 'Aliases', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_label', 'en', 'Audit', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_title', 'en', 'Audit Logs', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_from', 'en', 'From', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_to', 'en', 'To', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_event', 'en', 'Event', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_any', 'en', 'Any', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_search', 'en', 'Search payload', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_limit', 'en', 'Limit', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_date', 'en', 'Date / Time', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_event', 'en', 'Event', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_user', 'en', 'User', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_entity', 'en', 'Entity', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_payload', 'en', 'Payload', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_page', 'en', 'Page {{page}} of {{total}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_prev', 'en', 'Prev', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_next', 'en', 'Next', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_read_only', 'en', 'read-only', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_payload_source', 'en', 'Source: audit.audit_log · id {{id}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_owner_name', 'en', 'Owner', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_manager_name', 'en', 'Department manager', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_viewer_name', 'en', 'Read only', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_invite_only_managers', 'en', 'Only managers can invite new users', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_support_only', 'en', 'Support role only in support group', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_vendor_scope', 'en', 'Vendors can access vendor entities only', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_title', 'en', 'Add language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_code', 'en', 'Code', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_name', 'en', 'Name', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_is_default', 'en', 'Make default', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_submit', 'en', 'Save language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_title', 'en', 'Add translation', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_key', 'en', 'Key', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_value', 'en', 'Value', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_language', 'en', 'Language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_submit', 'en', 'Save translation', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_status_toggle', 'en', 'Active', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_default_toggle', 'en', 'Default', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('app_loading', 'ru', 'Загрузка...', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_brand_title', 'ru', 'SISSOL CRM', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_brand_subtitle', 'ru', 'Интерфейс ядра', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_status_online', 'ru', 'Онлайн', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('layout_action_logout', 'ru', 'Выйти', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('sidebar_settings', 'ru', 'Настройки', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_subtitle', 'ru', 'Войдите, чтобы продолжить', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_password_label', 'ru', 'Пароль', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_email_placeholder', 'ru', 'you@example.com', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_password_placeholder', 'ru', '••••••••', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_button_idle', 'ru', 'Войти', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_button_loading', 'ru', 'Вход...', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_invalid_credentials', 'ru', 'Неверный email или пароль', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_invalid_request', 'ru', 'Введите email и пароль', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_error_generic', 'ru', 'Ошибка авторизации', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_scope_core', 'ru', 'Ядро', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_title', 'ru', 'Настройки', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_badge_admin', 'ru', 'Админ', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_system', 'ru', 'Система', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_users', 'ru', 'Пользователи', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_roles', 'ru', 'Роли и доступ', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_languages', 'ru', 'Языки и переводы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_nav_audit', 'ru', 'Аудит', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_access_denied_title', 'ru', 'Недостаточно прав', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_access_denied_body', 'ru', 'Нужен permission settings.view, чтобы открыть Core Settings.', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_label', 'ru', 'Система', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_general', 'ru', 'Общее', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_name', 'ru', 'Название системы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_default_language', 'ru', 'Язык по умолчанию', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_timezone', 'ru', 'Часовой пояс', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode', 'ru', 'Режим разработчика', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode_on', 'ru', 'Логируются payload и SQL (без паролей)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_developer_mode_off', 'ru', 'Только ошибки и предупреждения', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_save_general', 'ru', 'Сохранить общее', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_security', 'ru', 'Безопасность', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_local_passwords', 'ru', 'Включить локальные пароли', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_sso', 'ru', 'Включить SSO', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_jwt_ttl', 'ru', 'JWT TTL (минуты)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_multiple_sessions', 'ru', 'Разрешить несколько сессий', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_save', 'ru', 'Сохранить безопасность', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_system_saved', 'ru', 'Общие настройки сохранены (POST /api/core/v1/settings/system)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_security_saved', 'ru', 'Безопасность сохранена (POST /api/core/v1/settings/security)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_label', 'ru', 'Пользователи', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_title', 'ru', 'Пользователи', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_create', 'ru', 'Создать пользователя', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_deactivate', 'ru', 'Деактивировать', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_change_language', 'ru', 'Сменить язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_reset_password', 'ru', 'Сбросить пароль', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_email', 'ru', 'Email', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_first_name', 'ru', 'Имя', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_last_name', 'ru', 'Фамилия', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_company', 'ru', 'Компания', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_status', 'ru', 'Статус', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_language', 'ru', 'Язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_email_label', 'ru', 'Email', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_roles', 'ru', 'Роли', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_groups', 'ru', 'Группы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_users_department', 'ru', 'Департамент', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_active', 'ru', 'активен', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_inactive', 'ru', 'неактивен', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_title', 'ru', 'Департаменты', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_lead', 'ru', 'Руководитель', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_departments_add', 'ru', 'Добавить департамент', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_groups_title', 'ru', 'Группы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_groups_add', 'ru', 'Добавить группу', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_label', 'ru', 'Роли и доступ', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_title', 'ru', 'Роли', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_code', 'ru', 'Код', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_name', 'ru', 'Название', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_scope', 'ru', 'Область', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_permissions', 'ru', 'Права', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_roles_add', 'ru', 'Добавить роль', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_permissions_title', 'ru', 'Права доступа', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_permissions_hint', 'ru', 'Системные permissions не редактируются, только назначаются.', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_title', 'ru', 'Политики доступа (ABAC)', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_apply', 'ru', 'Применяется к', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_policies_add', 'ru', 'Создать политику', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_label', 'ru', 'Языки', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_title', 'ru', 'Языки', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_code', 'ru', 'Код', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_name', 'ru', 'Название', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_status', 'ru', 'Статус', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_default', 'ru', 'По умолчанию', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_enabled_count', 'ru', 'Включено языков: {{count}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_add', 'ru', 'Добавить язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_enabled', 'ru', 'включен', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_disabled', 'ru', 'выключен', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_yes', 'ru', 'Да', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('status_no', 'ru', '—', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_title', 'ru', 'Переводы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_key', 'ru', 'Ключ', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_value', 'ru', 'Значение', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_language', 'ru', 'Язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_aliases', 'ru', 'Алиасы', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_label', 'ru', 'Аудит', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_title', 'ru', 'Логи аудита', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_from', 'ru', 'С', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_to', 'ru', 'По', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_event', 'ru', 'Событие', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_any', 'ru', 'Любое', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_search', 'ru', 'Поиск по payload', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_filter_limit', 'ru', 'Лимит', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_date', 'ru', 'Дата / Время', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_event', 'ru', 'Событие', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_user', 'ru', 'Пользователь', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_entity', 'ru', 'Сущность', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_table_payload', 'ru', 'Payload', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_page', 'ru', 'Страница {{page}} из {{total}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_prev', 'ru', 'Назад', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_next', 'ru', 'Вперед', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('common_read_only', 'ru', 'только чтение', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_audit_payload_source', 'ru', 'Источник: audit.audit_log · id {{id}}', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_owner_name', 'ru', 'Владелец', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_manager_name', 'ru', 'Руководитель отдела', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('roles_viewer_name', 'ru', 'Только чтение', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_invite_only_managers', 'ru', 'Только менеджеры могут приглашать новых пользователей', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_support_only', 'ru', 'Роль support только в группе support', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('policies_vendor_scope', 'ru', 'Поставщики видят только свои сущности', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_title', 'ru', 'Добавить язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_code', 'ru', 'Код', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_name', 'ru', 'Название', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_is_default', 'ru', 'Сделать основным', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_form_submit', 'ru', 'Сохранить язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_title', 'ru', 'Добавить перевод', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_key', 'ru', 'Ключ', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_value', 'ru', 'Значение', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_language', 'ru', 'Язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_translations_form_submit', 'ru', 'Сохранить перевод', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_status_toggle', 'ru', 'Активен', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('settings_languages_default_toggle', 'ru', 'Основной', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('app_language_selector_label', 'en', 'Language', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('app_language_selector_label', 'pl', 'Język', '2026-01-18 06:23:31.985256+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('app_language_selector_label', 'ru', 'Язык', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_email_label', 'en', 'Email', '2026-01-17 14:21:56.738959+00');
INSERT INTO core.translations (key, lang, value, updated_at) VALUES ('auth_email_label', 'pl', 'E-mail', '2026-01-18 06:24:03.000143+00');


--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: user_identities; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--



--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: core; Owner: crm_migrator
--

INSERT INTO core.user_roles (user_id, role_id) VALUES ('deb310f2-a91e-4f73-9d1e-880003e8baa6', '34cd294f-5d7f-422b-b719-b3b997fdbdeb');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('deb310f2-a91e-4f73-9d1e-880003e8baa6', '1c28b41a-556a-4462-8323-cb341d975c11');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('1ce1ce26-1fd1-476b-9126-37e190dc5a96', 'd2563ab6-c3b7-4a0e-9241-048aa4a999e6');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('c4941cf5-f3b9-4b12-8823-b2af9064dc7a', 'd2563ab6-c3b7-4a0e-9241-048aa4a999e6');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('7ce7031c-752f-4ec7-baf3-807a3cad5d44', 'd2563ab6-c3b7-4a0e-9241-048aa4a999e6');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('20d60a58-2eb4-4725-b696-fc34eae20bc5', 'd2563ab6-c3b7-4a0e-9241-048aa4a999e6');
INSERT INTO core.user_roles (user_id, role_id) VALUES ('2b15ed09-991c-4736-96e6-5c6d5dbbb12b', 'd2563ab6-c3b7-4a0e-9241-048aa4a999e6');


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations (version) VALUES ('001');
INSERT INTO public.schema_migrations (version) VALUES ('002');
INSERT INTO public.schema_migrations (version) VALUES ('003');
INSERT INTO public.schema_migrations (version) VALUES ('004');
INSERT INTO public.schema_migrations (version) VALUES ('005');
INSERT INTO public.schema_migrations (version) VALUES ('006');
INSERT INTO public.schema_migrations (version) VALUES ('007');
INSERT INTO public.schema_migrations (version) VALUES ('008');
INSERT INTO public.schema_migrations (version) VALUES ('009');
INSERT INTO public.schema_migrations (version) VALUES ('010');


--
-- Name: authz_tuples_id_seq; Type: SEQUENCE SET; Schema: core; Owner: crm_migrator
--

SELECT pg_catalog.setval('core.authz_tuples_id_seq', 1, false);


--
-- Name: user_identities_id_seq; Type: SEQUENCE SET; Schema: core; Owner: crm_migrator
--

SELECT pg_catalog.setval('core.user_identities_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

\unrestrict a10gE68dmGxfAa7Io9HwenyO606IuQRRoZUju5PoReUFwd5LaSBhVpY9eBzGTag


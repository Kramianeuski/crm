\connect crm;

BEGIN;

CREATE SCHEMA IF NOT EXISTS core;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- MIGRATION: core.languages
-- legacy: code, name, is_active
-- target: code, title, enabled, created_at
-- ============================================================

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'core'
          AND table_name = 'languages'
          AND column_name = 'name'
    ) THEN

        -- добавить новые колонки
        ALTER TABLE core.languages
            ADD COLUMN IF NOT EXISTS title TEXT,
            ADD COLUMN IF NOT EXISTS enabled BOOLEAN DEFAULT true,
            ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();

        -- перенос данных
        UPDATE core.languages
        SET
            title = COALESCE(title, name),
            enabled = COALESCE(enabled, is_active),
            created_at = COALESCE(created_at, now());

        -- зафиксировать ограничения
        ALTER TABLE core.languages
            ALTER COLUMN title SET NOT NULL,
            ALTER COLUMN enabled SET NOT NULL,
            ALTER COLUMN created_at SET NOT NULL;

        -- удалить legacy-поля
        ALTER TABLE core.languages
            DROP COLUMN name,
            DROP COLUMN is_active;
    END IF;
END;
$$;

-- ============================================================
-- SEED LANGUAGES (safe)
-- ============================================================
INSERT INTO core.languages (code, title) VALUES
('en', 'English'),
('ru', 'Русский')
ON CONFLICT DO NOTHING;

COMMIT;

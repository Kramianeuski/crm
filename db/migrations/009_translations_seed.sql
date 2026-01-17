-- migrate:up

INSERT INTO core.translations (key, lang, value, updated_at)
SELECT key, language_code, value, now()
FROM core.i18n_translations
ON CONFLICT (key, lang) DO UPDATE
  SET value = EXCLUDED.value,
      updated_at = now();

-- migrate:down

-- Intentionally left minimal.

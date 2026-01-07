export async function listLanguages(pg) {
  const { rows } = await pg.query(
    `SELECT code, name, is_active, is_default
     FROM core.languages
     ORDER BY is_default DESC, name ASC`
  );
  return rows;
}

export async function upsertLanguage(pg, language) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    if (language.is_default) {
      await client.query('UPDATE core.languages SET is_default = false');
    }

    const { rows } = await client.query(
      `INSERT INTO core.languages (code, name, is_active, is_default)
       VALUES ($1, $2, COALESCE($3, true), COALESCE($4, false))
       ON CONFLICT (code) DO UPDATE
         SET name = EXCLUDED.name,
             is_active = EXCLUDED.is_active,
             is_default = EXCLUDED.is_default
       RETURNING code, name, is_active, is_default`,
      [language.code.toLowerCase(), language.name, language.is_active, language.is_default]
    );

    await client.query('COMMIT');
    return rows[0];
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function updateLanguage(pg, code, patch) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    if (patch.is_default === true) {
      await client.query('UPDATE core.languages SET is_default = false');
    }

    const { rows } = await client.query(
      `UPDATE core.languages
       SET name = COALESCE($2, name),
           is_active = COALESCE($3, is_active),
           is_default = COALESCE($4, is_default)
       WHERE code = $1
       RETURNING code, name, is_active, is_default`,
      [code.toLowerCase(), patch.name ?? null, patch.is_active, patch.is_default]
    );

    await client.query('COMMIT');
    return rows[0] || null;
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function upsertKey(pg, key, description = null) {
  await pg.query(
    `INSERT INTO core.i18n_keys (key, description)
     VALUES ($1, $2)
     ON CONFLICT (key) DO UPDATE
       SET description = COALESCE(EXCLUDED.description, core.i18n_keys.description)`,
    [key, description]
  );
}

export async function upsertTranslations(pg, key, translations) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    await upsertKey(client, key, null);

    const entries = Object.entries(translations || {});

    for (const [language, value] of entries) {
      if (!value) continue;
      await client.query(
        `INSERT INTO core.i18n_translations (key, language_code, value)
         VALUES ($1, $2, $3)
         ON CONFLICT (key, language_code) DO UPDATE SET value = EXCLUDED.value`,
        [key, language.toLowerCase(), value]
      );
    }

    await client.query('COMMIT');
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function loadTranslations(pg) {
  const { rows } = await pg.query(
    `SELECT t.key, t.language_code, t.value
     FROM core.i18n_translations t
     JOIN core.languages l ON l.code = t.language_code AND l.is_active = true`
  );

  const map = {};
  for (const row of rows) {
    if (!map[row.language_code]) map[row.language_code] = {};
    map[row.language_code][row.key] = row.value;
  }
  return map;
}

export async function getDefaultLanguage(pg) {
  const { rows } = await pg.query(
    `SELECT code FROM core.languages WHERE is_default = true LIMIT 1`
  );
  return rows[0]?.code || null;
}

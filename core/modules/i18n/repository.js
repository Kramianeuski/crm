export async function listLanguages(pg) {
  const { rows } = await pg.query(
    `SELECT code, name, is_active, is_default
     FROM core.languages
     ORDER BY is_default DESC, name ASC`
  );
  return rows;
}

export async function createLanguage(pg, language) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    const { rows: activeRows } = await client.query(
      `SELECT count(*)::int AS count FROM core.languages WHERE is_active = true`
    );
    const activeCount = activeRows[0]?.count ?? 0;

    if (language.is_active === false && activeCount === 0) {
      await client.query('ROLLBACK');
      return { error: 'at_least_one_language_required' };
    }

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
    return { language: rows[0] };
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

    const { rows: currentRows } = await client.query(
      `SELECT code, is_active, is_default
       FROM core.languages
       WHERE code = $1`,
      [code.toLowerCase()]
    );

    if (!currentRows.length) {
      await client.query('ROLLBACK');
      return { error: 'language_not_found' };
    }

    const current = currentRows[0];

    if (patch.is_default === true) {
      await client.query('UPDATE core.languages SET is_default = false');
      patch.is_active = true;
    }

    if (patch.is_active === false) {
      if (current.is_default) {
        await client.query('ROLLBACK');
        return { error: 'default_language_required' };
      }

      const { rows: activeRows } = await client.query(
        `SELECT count(*)::int AS count
         FROM core.languages
         WHERE is_active = true AND code <> $1`,
        [code.toLowerCase()]
      );

      if ((activeRows[0]?.count ?? 0) === 0) {
        await client.query('ROLLBACK');
        return { error: 'at_least_one_language_required' };
      }
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
    return { language: rows[0] };
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function deleteLanguage(pg, code) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    const { rows: currentRows } = await client.query(
      `SELECT code, is_active, is_default
       FROM core.languages
       WHERE code = $1`,
      [code.toLowerCase()]
    );

    if (!currentRows.length) {
      await client.query('ROLLBACK');
      return { error: 'language_not_found' };
    }

    const current = currentRows[0];

    if (current.is_default) {
      await client.query('ROLLBACK');
      return { error: 'default_language_required' };
    }

    const { rows: translationsRows } = await client.query(
      `SELECT 1 FROM core.translations WHERE lang = $1 LIMIT 1`,
      [code.toLowerCase()]
    );

    if (translationsRows.length) {
      await client.query('ROLLBACK');
      return { error: 'language_in_use' };
    }

    if (current.is_active) {
      const { rows: activeRows } = await client.query(
        `SELECT count(*)::int AS count
         FROM core.languages
         WHERE is_active = true AND code <> $1`,
        [code.toLowerCase()]
      );

      if ((activeRows[0]?.count ?? 0) === 0) {
        await client.query('ROLLBACK');
        return { error: 'at_least_one_language_required' };
      }
    }

    await client.query(
      `DELETE FROM core.languages WHERE code = $1`,
      [code.toLowerCase()]
    );

    await client.query('COMMIT');
    return { deleted: true };
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

export async function upsertTranslations(pg, key, translations) {
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    const entries = Object.entries(translations || {});

    for (const [language, value] of entries) {
      if (!value) continue;
      await client.query(
        `INSERT INTO core.translations (key, lang, value)
         VALUES ($1, $2, $3)
         ON CONFLICT (key, lang) DO UPDATE SET value = EXCLUDED.value`,
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

export async function upsertAliases(pg, key, aliases) {
  if (!aliases?.length) return;
  const client = await pg.connect();

  try {
    await client.query('BEGIN');

    const values = [];
    const placeholders = aliases.map((alias, index) => {
      values.push(alias, key, null);
      const base = index * 3;
      return `($${base + 1}, $${base + 2}, $${base + 3})`;
    });

    await client.query(
      `INSERT INTO core.translation_aliases (from_key, to_key, reason)
       VALUES ${placeholders.join(', ')}
       ON CONFLICT (from_key) DO UPDATE
         SET to_key = EXCLUDED.to_key`,
      values
    );

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
    `SELECT t.key, t.lang AS language_code, t.value
     FROM core.translations t
     JOIN core.languages l ON l.code = t.lang AND l.is_active = true`
  );

  const map = {};
  for (const row of rows) {
    if (!map[row.language_code]) map[row.language_code] = {};
    map[row.language_code][row.key] = row.value;
  }

  const { rows: aliasRows } = await pg.query(
    `SELECT from_key, to_key FROM core.translation_aliases`
  );

  for (const alias of aliasRows) {
    for (const [language, entries] of Object.entries(map)) {
      const value = entries[alias.to_key];
      if (value && !entries[alias.from_key]) {
        entries[alias.from_key] = value;
      }
      map[language] = entries;
    }
  }

  return map;
}

export async function getDefaultLanguage(pg) {
  const { rows } = await pg.query(
    `SELECT code FROM core.languages WHERE is_default = true LIMIT 1`
  );
  return rows[0]?.code || null;
}

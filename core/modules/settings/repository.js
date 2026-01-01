'use strict';

async function fetchModules(pg) {
  const { rows } = await pg.query(
    `SELECT id, code, title_key, icon, sort_order
     FROM core.settings_modules
     WHERE enabled = true
     ORDER BY sort_order ASC, code ASC`
  );
  return rows;
}

async function fetchPages(pg, moduleId) {
  const { rows } = await pg.query(
    `SELECT code, title_key, permission_code, sort_order
     FROM core.settings_pages
     WHERE module_id = $1
     ORDER BY sort_order ASC, code ASC`,
    [moduleId]
  );
  return rows;
}

async function findModule(pg, code) {
  const { rows } = await pg.query(
    `SELECT id, code FROM core.settings_modules WHERE code = $1 AND enabled = true`,
    [code]
  );
  return rows[0] || null;
}

async function findPage(pg, moduleId, pageCode) {
  const { rows } = await pg.query(
    `SELECT code, title_key, permission_code
     FROM core.settings_pages
     WHERE module_id = $1 AND code = $2`,
    [moduleId, pageCode]
  );
  return rows[0] || null;
}

async function readValue(pg, moduleCode, pageCode) {
  const { rows } = await pg.query(
    `SELECT payload FROM core.settings_values WHERE module_code = $1 AND page_code = $2`,
    [moduleCode, pageCode]
  );
  return rows[0]?.payload || null;
}

async function saveValue(pg, moduleCode, pageCode, payload, userId) {
  await pg.query(
    `INSERT INTO core.settings_values (module_code, page_code, payload, updated_by)
     VALUES ($1, $2, $3, $4)
     ON CONFLICT (module_code, page_code)
     DO UPDATE SET payload = EXCLUDED.payload, updated_by = EXCLUDED.updated_by, updated_at = now()`,
    [moduleCode, pageCode, payload, userId]
  );
}

module.exports = {
  fetchModules,
  fetchPages,
  findModule,
  findPage,
  readValue,
  saveValue
};

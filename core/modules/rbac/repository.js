export async function listPermissions(pg) {
  const { rows } = await pg.query(
    `SELECT id, code, description
     FROM core.permissions
     ORDER BY code ASC`
  );
  return rows;
}

export async function listRoles(pg) {
  const { rows } = await pg.query(
    `SELECT id, code, name_key
     FROM core.roles
     ORDER BY code ASC`
  );
  return rows;
}

export async function listRolePermissions(pg) {
  const { rows } = await pg.query(
    `SELECT r.id AS role_id,
            r.code AS role_code,
            r.name_key AS role_name_key,
            p.code AS permission_code,
            rp.scope AS scope
     FROM core.roles r
     LEFT JOIN core.role_permissions rp ON rp.role_id = r.id
     LEFT JOIN core.permissions p ON p.id = rp.permission_id
     ORDER BY r.code ASC, p.code ASC`
  );

  const roleMap = new Map();

  for (const row of rows) {
    if (!roleMap.has(row.role_id)) {
      roleMap.set(row.role_id, {
        id: row.role_id,
        code: row.role_code,
        name_key: row.role_name_key,
        permissions: []
      });
    }

    if (row.permission_code) {
      roleMap.get(row.role_id).permissions.push({
        code: row.permission_code,
        scope: row.scope
      });
    }
  }

  return Array.from(roleMap.values());
}

export async function updateRolePermissions(pg, roleId, permissions) {
  const client = await pg.connect();
  try {
    await client.query('BEGIN');

    const { rows: roleRows } = await client.query(
      `SELECT id FROM core.roles WHERE id = $1`,
      [roleId]
    );

    if (!roleRows.length) {
      await client.query('ROLLBACK');
      return { error: 'role_not_found' };
    }

    const permissionCodes = permissions.map((permission) => permission.code);
    if (permissionCodes.length) {
      const { rows: existingPermissions } = await client.query(
        `SELECT id, code FROM core.permissions WHERE code = ANY($1::text[])`,
        [permissionCodes]
      );

      const existingMap = new Map(existingPermissions.map((row) => [row.code, row.id]));
      const missing = permissionCodes.filter((code) => !existingMap.has(code));

      if (missing.length) {
        await client.query('ROLLBACK');
        return { error: 'permission_not_found', details: missing };
      }

      await client.query(
        `DELETE FROM core.role_permissions WHERE role_id = $1`,
        [roleId]
      );

      const values = [];
      const placeholders = permissions.map((permission, index) => {
        const permissionId = existingMap.get(permission.code);
        values.push(roleId, permissionId, permission.scope || 'all');
        const base = index * 3;
        return `($${base + 1}, $${base + 2}, $${base + 3})`;
      });

      if (placeholders.length) {
        await client.query(
          `INSERT INTO core.role_permissions (role_id, permission_id, scope)
           VALUES ${placeholders.join(', ')}`,
          values
        );
      }
    } else {
      await client.query(
        `DELETE FROM core.role_permissions WHERE role_id = $1`,
        [roleId]
      );
    }

    await client.query('COMMIT');
    return { saved: true };
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
}

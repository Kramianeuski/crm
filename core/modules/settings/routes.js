import {
  fetchModules,
  fetchPages,
  findModule,
  findPage,
  readValue,
  saveValue
} from './repository.js';

export default async function settingsRoutes(fastify) {
  const getPermissionResource = permissionCode => {
    const parts = permissionCode.split('.');
    if (parts.length === 1) return permissionCode;
    const action = parts[parts.length - 1];
    const actionKeywords = new Set(['view', 'edit', 'manage', 'assign']);
    if (actionKeywords.has(action)) {
      parts.pop();
      return parts.join('.');
    }
    return permissionCode;
  };

  const ensureAccess = async (request, reply, resource, action) => {
    const allowed = await fastify.canAccess(request.user, resource, action);
    if (!allowed) {
      reply.code(403).send({ error: 'forbidden' });
      return false;
    }
    return true;
  };

  fastify.get('/settings/modules', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const modules = await fetchModules(fastify.pg);
      const result = [];

      for (const module of modules) {
        const pages = await fetchPages(fastify.pg, module.id);
        const allowedPages = [];

        for (const page of pages) {
          const resource = getPermissionResource(page.permission_code);
          const allowed = await fastify.canAccess(request.user, resource, 'view');
          if (allowed) {
            allowedPages.push({
              code: page.code,
              title_key: page.title_key,
              permission_code: page.permission_code
            });
          }
        }

        if (allowedPages.length) {
          result.push({
            code: module.code,
            title_key: module.title_key,
            icon: module.icon,
            sort_order: module.sort_order,
            pages: allowedPages
          });
        }
      }

      return reply.send({ modules: result });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/navigation', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const modules = await fetchModules(fastify.pg);
      const navigation = [];

      for (const module of modules) {
        const pages = await fetchPages(fastify.pg, module.id);
        const children = [];

        for (const page of pages) {
          const resource = getPermissionResource(page.permission_code);
          const allowed = await fastify.canAccess(request.user, resource, 'view');
          if (!allowed) continue;

          children.push({
            code: page.code,
            title: page.title_key,
            title_key: page.title_key,
            route: `/${module.code}/${page.code}`
          });
        }

        if (children.length === 0) {
          continue;
        }

        navigation.push({
          code: module.code,
          title: module.title_key,
          title_key: module.title_key,
          icon: module.icon,
          route: `/${module.code}`,
          children
        });
      }

      return reply.send(navigation);
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/settings/schema/:module/:page', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const { module, page } = request.params;
      const moduleRow = await findModule(fastify.pg, module);
      if (!moduleRow) return reply.code(404).send({ error: 'module_not_found' });

      const pageRow = await findPage(fastify.pg, moduleRow.id, page);
      if (!pageRow) return reply.code(404).send({ error: 'page_not_found' });

      const permissionCode = pageRow.permission_code;
      const resource = getPermissionResource(permissionCode);
      const allowed = await fastify.canAccess(request.user, resource, 'view');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      return reply.send({
        module,
        page,
        title_key: pageRow.title_key,
        permission_code: permissionCode,
        schema: { type: 'form', fields: [] }
      });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post(
    '/settings/value/:module/:page',
    { preHandler: fastify.verifyJWT },
    async (request, reply) => {
      try {
        const { module, page } = request.params;
        const payload = request.body || {};

        const moduleRow = await findModule(fastify.pg, module);
        if (!moduleRow) return reply.code(404).send({ error: 'module_not_found' });

        const pageRow = await findPage(fastify.pg, moduleRow.id, page);
        if (!pageRow) return reply.code(404).send({ error: 'page_not_found' });

        const permissionCode = pageRow.permission_code;
        const resource = getPermissionResource(permissionCode);
        const allowed = await fastify.canAccess(request.user, resource, 'edit');
        if (!allowed) return reply.code(403).send({ error: 'forbidden' });

        const beforeValue = await readValue(fastify.pg, module, page);
        if (request.auditContext) request.auditContext.before = beforeValue;

        await saveValue(fastify.pg, module, page, payload, request.user.id);

        if (request.auditContext) request.auditContext.after = { saved: true };

        return reply.send({ saved: true });
      } catch (err) {
        request.log.error(err);
        return reply.code(500).send({ error: 'internal_error' });
      }
    }
  );

  fastify.get('/settings', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'settings', 'view');
      if (!allowed) return reply;

      const defaultLanguage = await fastify.pg.query(
        `SELECT code FROM core.languages WHERE is_default = true LIMIT 1`
      );
      const fallbackLanguage = defaultLanguage.rows[0]?.code || 'en';

      const system = await readValue(fastify.pg, 'core', 'system');
      const security = await readValue(fastify.pg, 'core', 'security');

      return reply.send({
        system: {
          systemName: system?.systemName ?? 'SISSOL CRM',
          defaultLanguage: system?.defaultLanguage ?? fallbackLanguage,
          timezone: system?.timezone ?? 'UTC',
          developerMode: system?.developerMode ?? false
        },
        security: {
          enableLocalPasswords: security?.enableLocalPasswords ?? true,
          enableSSO: security?.enableSSO ?? false,
          jwtTtl: security?.jwtTtl ?? 60,
          allowMultipleSessions: security?.allowMultipleSessions ?? false
        }
      });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/settings', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'settings', 'edit');
      if (!allowed) return reply;

      const { system, security } = request.body || {};
      if (!system && !security) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      if (system) {
        const current = (await readValue(fastify.pg, 'core', 'system')) || {};
        await saveValue(
          fastify.pg,
          'core',
          'system',
          { ...current, ...system },
          request.user.id
        );
      }

      if (security) {
        const current = (await readValue(fastify.pg, 'core', 'security')) || {};
        await saveValue(
          fastify.pg,
          'core',
          'security',
          { ...current, ...security },
          request.user.id
        );
      }

      return reply.send({ saved: true });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

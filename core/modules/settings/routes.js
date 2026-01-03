import {
  fetchModules,
  fetchPages,
  findModule,
  findPage,
  readValue,
  saveValue
} from './repository.js';

export default async function settingsRoutes(fastify) {
  const splitPermissionCode = permissionCode => {
    const parts = permissionCode.split('.');
    const action = parts.pop();
    return { resource: parts.join('.'), action };
  };

  fastify.get('/api/core/v1/settings/modules', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const modules = await fetchModules(fastify.pg);
      const result = [];

      for (const module of modules) {
        const pages = await fetchPages(fastify.pg, module.id);
        const allowedPages = [];

        for (const page of pages) {
          const { resource, action } = splitPermissionCode(page.permission_code);
          const allowed = await fastify.canAccess(request.user, resource, action);
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

  fastify.get('/api/core/v1/settings/schema/:module/:page', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const { module, page } = request.params;
      const moduleRow = await findModule(fastify.pg, module);
      if (!moduleRow) return reply.code(404).send({ error: 'module_not_found' });

      const pageRow = await findPage(fastify.pg, moduleRow.id, page);
      if (!pageRow) return reply.code(404).send({ error: 'page_not_found' });

      const permissionCode = pageRow.permission_code;
      const { resource, action } = splitPermissionCode(permissionCode);
      const allowed = await fastify.canAccess(request.user, resource, action);
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
    '/api/core/v1/settings/value/:module/:page',
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
        const { resource, action } = splitPermissionCode(permissionCode);
        const allowed = await fastify.canAccess(request.user, resource, action);
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
}

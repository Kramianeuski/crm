'use strict';

const repo = require('./repository');

module.exports = async function settingsRoutes(fastify) {
  const splitPermissionCode = permissionCode => {
    const parts = permissionCode.split('.');
    const action = parts.pop();
    return { resource: parts.join('.'), action };
  };

  fastify.get('/api/core/v1/settings/modules', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const modules = await repo.fetchModules(fastify.pg);
    const result = [];

    for (const module of modules) {
      const pages = await repo.fetchPages(fastify.pg, module.id);
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

    reply.send({ modules: result });
  });

  fastify.get('/api/core/v1/settings/schema/:module/:page', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { module, page } = request.params;
    const moduleRow = await repo.findModule(fastify.pg, module);
    if (!moduleRow) return reply.code(404).send({ error: 'module_not_found' });

    const pageRow = await repo.findPage(fastify.pg, moduleRow.id, page);
    if (!pageRow) return reply.code(404).send({ error: 'page_not_found' });

    const permissionCode = pageRow.permission_code;
    const { resource, action } = splitPermissionCode(permissionCode);
    const allowed = await fastify.canAccess(request.user, resource, action);
    if (!allowed) return reply.code(403).send({ error: 'forbidden' });

    reply.send({
      module,
      page,
      title_key: pageRow.title_key,
      permission_code: permissionCode,
      schema: { type: 'form', fields: [] }
    });
  });

  fastify.post(
    '/api/core/v1/settings/value/:module/:page',
    { preHandler: fastify.verifyJWT },
    async (request, reply) => {
      const { module, page } = request.params;
      const payload = request.body || {};

      const moduleRow = await repo.findModule(fastify.pg, module);
      if (!moduleRow) return reply.code(404).send({ error: 'module_not_found' });

      const pageRow = await repo.findPage(fastify.pg, moduleRow.id, page);
      if (!pageRow) return reply.code(404).send({ error: 'page_not_found' });

      const permissionCode = pageRow.permission_code;
      const { resource, action } = splitPermissionCode(permissionCode);
      const allowed = await fastify.canAccess(request.user, resource, action);
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const beforeValue = await repo.readValue(fastify.pg, module, page);
      if (request.auditContext) request.auditContext.before = beforeValue;

      await repo.saveValue(fastify.pg, module, page, payload, request.user.id);

      if (request.auditContext) request.auditContext.after = { saved: true };

      reply.send({ saved: true });
    }
  );
};

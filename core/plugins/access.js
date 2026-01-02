'use strict';

const fp = require('fastify-plugin');
const { canAccess } = require('../lib/canAccess');

module.exports = fp(async function accessPlugin(app) {
  app.decorate('canAccess', async (user, resource, action, entity = null) => {
    return canAccess(app.db, user, resource, action, entity);
  });

  app.decorate(
    'requirePermission',
    (resource, action) =>
      async function requirePermission(request) {
        if (!request.user) {
          const err = new Error('Unauthorized');
          err.statusCode = 401;
          err.code = 'unauthorized';
          throw err;
        }

        let allowed;
        try {
          allowed = await app.canAccess(
            request.user,
            resource,
            action,
            request.body?.entity ?? null
          );
        } catch (e) {
          app.log.error(e, 'Permission check failed');
          const err = new Error('Permission check failed');
          err.statusCode = 500;
          err.code = 'permission_check_failed';
          throw err;
        }

        if (!allowed) {
          const err = new Error('Forbidden');
          err.statusCode = 403;
          err.code = 'forbidden';
          throw err;
        }
      }
  );
});

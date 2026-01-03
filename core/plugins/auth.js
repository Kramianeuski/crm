import fp from 'fastify-plugin';

export default fp(async function authPlugin(app) {
  app.decorate('requireAuth', async function requireAuth(request) {
    if (!request.user) {
      const err = new Error('Unauthorized');
      err.statusCode = 401;
      err.code = 'unauthorized';
      throw err;
    }
  });
});

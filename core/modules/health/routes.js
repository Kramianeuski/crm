export default async function healthRoutes(fastify) {
  fastify.get('/api/v1/core/health', async () => ({
    status: 'ok',
    service: 'crm-core',
    env: process.env.CORE_ENV,
    timestamp: new Date().toISOString()
  }));

  fastify.get('/api/v1/core/ready', async () => {
    await fastify.pg.query('select 1');
    return { ready: true };
  });
}

export default async function healthRoutes(fastify) {
  fastify.get('/api/v1/core/health', async () => ({
    status: fastify.readinessState?.status || 'ok',
    service: 'crm-core',
    env: process.env.CORE_ENV,
    checks: fastify.readinessState?.checks || {},
    timestamp: new Date().toISOString()
  }));

  fastify.get('/api/v1/core/ready', async (request, reply) => {
    await fastify.pg.query('select 1');

    const readiness = fastify.readinessState || { status: 'ok', checks: {} };
    if (readiness.status !== 'ok') {
      return reply.code(503).send({
        ready: false,
        status: readiness.status,
        checks: readiness.checks
      });
    }

    return { ready: true, status: 'ok', checks: readiness.checks };
  });
}

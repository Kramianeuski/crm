'use strict';

module.exports = async function errorHandlerPlugin(fastify) {
  fastify.setErrorHandler((error, request, reply) => {
    fastify.log.error({ err: error, reqId: request.id, url: request.url }, 'Unhandled error');

    if (reply.raw.writableEnded) return;

    reply.status(error.statusCode || 500).send({
      error: error.code || 'internal_error',
      message: error.message || 'Internal server error'
    });
  });
};

import {
  deleteGrantById,
  deleteGrantByTuple,
  listEffectiveAccess,
  listGrantsByObject,
  upsertGrant
} from './repository.js';

const MODE_RELATIONS = {
  read: 'viewer',
  write: 'editor'
};

function parseObjectParam(objectParam) {
  if (!objectParam) return null;
  const [object_type, object_id] = objectParam.split(':');
  if (!object_type || !object_id) return null;
  return { object_type, object_id };
}

export default async function authzRoutes(fastify) {
  const ensureAccess = async (request, reply, resource, action) => {
    const allowed = await fastify.canAccess(request.user, resource, action);
    if (!allowed) {
      reply.code(403).send({ error: 'forbidden' });
      return false;
    }
    return true;
  };

  fastify.post('/authz/grants', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'authz.grants', 'manage');
      if (!allowed) return reply;

      const body = request.body || {};
      const object = parseObjectParam(body.object);
      const grant = {
        object_type: body.object_type || object?.object_type,
        object_id: body.object_id || object?.object_id,
        subject_type: body.subject_type,
        subject_id: body.subject_id,
        relation: body.relation,
        created_by: request.user.id
      };

      if (!grant.relation && body.mode) {
        grant.relation = MODE_RELATIONS[body.mode];
      }

      if (!grant.object_type || !grant.object_id || !grant.subject_type || !grant.subject_id || !grant.relation) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      const id = await upsertGrant(fastify.pg, grant);
      return reply.send({ id, created: Boolean(id) });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.delete('/authz/grants/:id', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'authz.grants', 'manage');
      if (!allowed) return reply;

      const removed = await deleteGrantById(fastify.pg, request.params.id);
      return reply.send({ removed });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.delete('/authz/grants', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'authz.grants', 'manage');
      if (!allowed) return reply;

      const query = request.query || {};
      const object = parseObjectParam(query.object);
      const grant = {
        object_type: query.object_type || object?.object_type,
        object_id: query.object_id || object?.object_id,
        subject_type: query.subject_type,
        subject_id: query.subject_id,
        relation: query.relation
      };

      if (!grant.object_type || !grant.object_id || !grant.subject_type || !grant.subject_id || !grant.relation) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      const removed = await deleteGrantByTuple(fastify.pg, grant);
      return reply.send({ removed });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/authz/grants', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'authz.grants', 'view');
      if (!allowed) return reply;

      const query = request.query || {};
      const object = parseObjectParam(query.object);
      const objectType = query.object_type || object?.object_type;
      const objectId = query.object_id || object?.object_id;

      if (!objectType || !objectId) {
        return reply.code(400).send({ error: 'invalid_request' });
      }

      const grants = await listGrantsByObject(fastify.pg, objectType, objectId);
      return reply.send({ grants });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/authz/effective', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await ensureAccess(request, reply, 'authz.grants', 'view');
      if (!allowed) return reply;

      const userId = request.query?.user || request.user.id;
      const effective = await listEffectiveAccess(fastify.pg, userId);
      return reply.send({ user_id: userId, effective });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

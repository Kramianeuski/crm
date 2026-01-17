import {
  createLanguage,
  deleteLanguage,
  getDefaultLanguage,
  listLanguages,
  loadTranslations,
  updateLanguage,
  upsertAliases,
  upsertTranslations
} from './repository.js';

async function optionalVerify(fastify, request) {
  const authHeader = request.headers.authorization;
  if (!authHeader) return false;
  await fastify.verifyJWT(request);
  return Boolean(request.user);
}

export default async function i18nRoutes(fastify) {
  fastify.get('/i18n/languages', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'i18n.languages', 'view');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const languages = await listLanguages(fastify.pg);
      const defaultLanguage = await getDefaultLanguage(fastify.pg);
      return reply.send({ languages, defaultLanguage });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/i18n/languages', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'i18n.languages', 'create');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const { code, name, is_active, is_default } = request.body || {};
      if (!code || !name) return reply.code(422).send({ error: 'invalid_request' });

      const result = await createLanguage(fastify.pg, { code, name, is_active, is_default });
      if (result.error) return reply.code(422).send({ error: result.error });

      return reply.code(201).send({ language: result.language });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/i18n/languages/:code', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'i18n.languages', 'edit');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const { code } = request.params;
      const { name, is_active, is_default } = request.body || {};
      const result = await updateLanguage(fastify.pg, code, { name, is_active, is_default });

      if (result.error === 'language_not_found') {
        return reply.code(404).send({ error: 'language_not_found' });
      }

      if (result.error) {
        return reply.code(422).send({ error: result.error });
      }

      return reply.send({ language: result.language });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.delete('/i18n/languages/:code', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'i18n.languages', 'delete');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const { code } = request.params;
      const result = await deleteLanguage(fastify.pg, code);

      if (result.error === 'language_not_found') {
        return reply.code(404).send({ error: 'language_not_found' });
      }

      if (result.error) {
        return reply.code(422).send({ error: result.error });
      }

      return reply.code(204).send();
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/i18n/translations', async (request, reply) => {
    try {
      const hasUser = await optionalVerify(fastify, request);
      if (hasUser) {
        const allowed = await fastify.canAccess(request.user, 'i18n.translations', 'view');
        if (!allowed) return reply.code(403).send({ error: 'forbidden' });
      }

      const languages = await listLanguages(fastify.pg);
      const defaultLanguage = await getDefaultLanguage(fastify.pg);
      const translations = await loadTranslations(fastify.pg);
      return reply.send({ languages, defaultLanguage, translations });
    } catch (err) {
      if (err.statusCode) {
        return reply.code(err.statusCode).send({ error: err.code || 'unauthorized' });
      }
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/i18n/translations', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    try {
      const allowed = await fastify.canAccess(request.user, 'i18n.translations', 'edit');
      if (!allowed) return reply.code(403).send({ error: 'forbidden' });

      const { key, translations, aliases } = request.body || {};
      if (!key || typeof translations !== 'object') {
        return reply.code(422).send({ error: 'invalid_request' });
      }

      await upsertTranslations(fastify.pg, key, translations);
      if (Array.isArray(aliases) && aliases.length) {
        await upsertAliases(fastify.pg, key, aliases);
      }
      return reply.send({ saved: true });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

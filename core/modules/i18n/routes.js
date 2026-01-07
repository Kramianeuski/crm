import {
  upsertKey,
  getDefaultLanguage,
  listLanguages,
  loadTranslations,
  updateLanguage,
  upsertLanguage,
  upsertTranslations
} from './repository.js';

export default async function i18nRoutes(fastify) {
  fastify.get('/api/core/v1/i18n/languages', async (request, reply) => {
    const languages = await listLanguages(fastify.pg);
    const defaultLanguage = await getDefaultLanguage(fastify.pg);
    return reply.send({ languages, defaultLanguage });
  });

  fastify.post('/api/core/v1/i18n/languages', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { code, name, is_active, is_default } = request.body || {};
    if (!code || !name) return reply.code(400).send({ error: 'invalid_request' });

    const language = await upsertLanguage(fastify.pg, { code, name, is_active, is_default });
    return reply.code(201).send({ language });
  });

  fastify.patch('/api/core/v1/i18n/languages/:code', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { code } = request.params;
    const { name, is_active, is_default } = request.body || {};
    const updated = await updateLanguage(fastify.pg, code, { name, is_active, is_default });
    if (!updated) return reply.code(404).send({ error: 'language_not_found' });
    return reply.send({ language: updated });
  });

  fastify.get('/api/core/v1/i18n/translations', async (request, reply) => {
    const languages = await listLanguages(fastify.pg);
    const defaultLanguage = await getDefaultLanguage(fastify.pg);
    const translations = await loadTranslations(fastify.pg);
    return reply.send({ languages, defaultLanguage, translations });
  });

  fastify.post('/api/core/v1/i18n/keys', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { key, description } = request.body || {};
    if (!key) return reply.code(400).send({ error: 'invalid_request' });

    await upsertKey(fastify.pg, key, description || null);
    return reply.code(201).send({ key });
  });

  fastify.post('/api/core/v1/i18n/translations', { preHandler: fastify.verifyJWT }, async (request, reply) => {
    const { key, translations } = request.body || {};
    if (!key || typeof translations !== 'object') {
      return reply.code(400).send({ error: 'invalid_request' });
    }

    await upsertTranslations(fastify.pg, key, translations);
    return reply.code(201).send({ saved: true });
  });
}

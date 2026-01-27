import test from 'node:test';
import assert from 'node:assert/strict';
import Fastify from 'fastify';
import jwtPlugin from '../jwt.js';

const buildApp = async () => {
  const app = Fastify();
  await app.register(jwtPlugin);
  app.setErrorHandler((error, _request, reply) => {
    reply
      .code(error.statusCode || 500)
      .send({ error: error.code || 'internal_error' });
  });
  app.get('/users', { preHandler: app.verifyJWT }, async () => ({ ok: true }));
  await app.ready();
  return app;
};

test('verifyJWT rejects tokens without a user id', async () => {
  process.env.JWT_SECRET = 'test-secret';
  const app = await buildApp();

  const token = app.signToken({ email: 'user@example.test' });
  const response = await app.inject({
    method: 'GET',
    url: '/users',
    headers: {
      authorization: `Bearer ${token}`
    }
  });

  assert.equal(response.statusCode, 401);
  const payload = response.json();
  assert.equal(payload.error, 'unauthorized');

  await app.close();
});

test('verifyJWT accepts tokens with a subject', async () => {
  process.env.JWT_SECRET = 'test-secret';
  const app = await buildApp();

  const token = app.signToken({ sub: 'user-123', email: 'user@example.test' });
  const response = await app.inject({
    method: 'GET',
    url: '/users',
    headers: {
      authorization: `Bearer ${token}`
    }
  });

  assert.equal(response.statusCode, 200);
  const payload = response.json();
  assert.deepEqual(payload, { ok: true });

  await app.close();
});

import { randomUUID } from 'crypto';
import { fetchCategories, insertCategory, updateCategory } from '../repository/categories.js';
import { fetchProducts, fetchProduct, insertProduct, updateProduct } from '../repository/products.js';
import { fetchAttributes, insertAttribute, upsertAttributeValues, fetchAttributeTypes } from '../repository/attributes.js';
import { normalizeAttributeValues } from '../service/attribute-values.js';
import { fetchEtimClasses, replaceCategoryEtimMap } from '../repository/etim.js';

const requireAuth = async (request, reply) => {
  if (!request.user) {
    return reply.code(401).send({ error: 'unauthorized' });
  }
};

function buildCategoryTree(categories) {
  const byId = new Map();
  const roots = [];

  for (const category of categories) {
    const node = { ...category, children: [] };
    byId.set(category.id, node);
  }

  for (const category of categories) {
    const node = byId.get(category.id);
    if (category.parent_id && byId.has(category.parent_id)) {
      byId.get(category.parent_id).children.push(node);
    } else {
      roots.push(node);
    }
  }

  return roots;
}

export default async function productRoutes(fastify) {
  const preHandler = [fastify.verifyJWT, requireAuth];

  fastify.get('/products', { preHandler }, async (request, reply) => {
    try {
      const products = await fetchProducts(fastify.pg, {
        lang: request.query.lang || 'ru',
        categoryId: request.query.category_id,
        brandId: request.query.brand_id,
        isActive: request.query.is_active === undefined
          ? undefined
          : request.query.is_active === 'true'
      });
      return reply.send({ products });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/products/:id', { preHandler }, async (request, reply) => {
    try {
      const product = await fetchProduct(fastify.pg, {
        id: request.params.id,
        lang: request.query.lang || 'ru'
      });
      if (!product) return reply.code(404).send({ error: 'product_not_found' });
      return reply.send({ product });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/products', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      if (!payload.sku || !payload.category_id || !payload.base_unit_id) {
        return reply.code(422).send({ error: 'missing_required_fields' });
      }

      const id = randomUUID();
      await insertProduct(fastify.pg, {
        id,
        sku: payload.sku,
        brand_id: payload.brand_id || null,
        category_id: payload.category_id,
        base_unit_id: payload.base_unit_id,
        is_active: payload.is_active !== false,
        name: payload.name,
        description: payload.description,
        lang: payload.lang || 'ru'
      });

      const product = await fetchProduct(fastify.pg, { id, lang: payload.lang || 'ru' });
      return reply.send({ product });
    } catch (err) {
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'product_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.patch('/products/:id', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      const id = request.params.id;

      const current = await fetchProduct(fastify.pg, { id, lang: payload.lang || 'ru' });
      if (!current) return reply.code(404).send({ error: 'product_not_found' });

      await updateProduct(fastify.pg, {
        id,
        sku: payload.sku ?? current.sku,
        brand_id: payload.brand_id ?? current.brand_id,
        category_id: payload.category_id ?? current.category_id,
        base_unit_id: payload.base_unit_id ?? current.base_unit_id,
        is_active: payload.is_active ?? current.is_active,
        name: payload.name,
        description: payload.description,
        lang: payload.lang || 'ru'
      });

      const product = await fetchProduct(fastify.pg, { id, lang: payload.lang || 'ru' });
      return reply.send({ product });
    } catch (err) {
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'product_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/categories', { preHandler }, async (request, reply) => {
    try {
      const categories = await fetchCategories(fastify.pg, request.query.lang || 'ru');
      const tree = buildCategoryTree(categories);
      return reply.send({ categories: tree });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/categories', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      if (!payload.code || !payload.slug) {
        return reply.code(422).send({ error: 'missing_required_fields' });
      }

      const id = randomUUID();
      await insertCategory(fastify.pg, {
        id,
        parent_id: payload.parent_id || null,
        code: payload.code,
        slug: payload.slug,
        is_active: payload.is_active !== false,
        sort_order: payload.sort_order ?? 0,
        name: payload.name,
        description: payload.description,
        lang: payload.lang || 'ru'
      });

      const categories = await fetchCategories(fastify.pg, payload.lang || 'ru');
      const created = categories.find(category => category.id === id);
      return reply.send({ category: created });
    } catch (err) {
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'category_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.patch('/categories/:id', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      const id = request.params.id;

      await updateCategory(fastify.pg, {
        id,
        parent_id: payload.parent_id || null,
        code: payload.code,
        slug: payload.slug,
        is_active: payload.is_active !== false,
        sort_order: payload.sort_order ?? 0,
        name: payload.name,
        description: payload.description,
        lang: payload.lang || 'ru'
      });

      const categories = await fetchCategories(fastify.pg, payload.lang || 'ru');
      const updated = categories.find(category => category.id === id);
      return reply.send({ category: updated });
    } catch (err) {
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'category_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/attributes', { preHandler }, async (request, reply) => {
    try {
      const attributes = await fetchAttributes(fastify.pg, request.query.lang || 'ru');
      return reply.send({ attributes });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.post('/attributes', { preHandler }, async (request, reply) => {
    try {
      const payload = request.body || {};
      if (!payload.code || !payload.value_type) {
        return reply.code(422).send({ error: 'missing_required_fields' });
      }

      const id = randomUUID();
      await insertAttribute(fastify.pg, {
        id,
        code: payload.code,
        value_type: payload.value_type,
        unit_id: payload.unit_id || null,
        is_system: payload.is_system === true,
        is_filterable: payload.is_filterable === true,
        is_required: payload.is_required === true,
        sort_order: payload.sort_order ?? 0,
        name: payload.name,
        lang: payload.lang || 'ru'
      });

      const attributes = await fetchAttributes(fastify.pg, payload.lang || 'ru');
      const attribute = attributes.find(item => item.id === id);
      return reply.send({ attribute });
    } catch (err) {
      request.log.error(err);
      if (err.code === '23505') {
        return reply.code(422).send({ error: 'attribute_exists' });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/products/:id/attributes', { preHandler }, async (request, reply) => {
    try {
      const productId = request.params.id;
      const values = Array.isArray(request.body?.values) ? request.body.values : [];
      const attributeIds = values.map(item => item.attribute_id).filter(Boolean);
      const types = await fetchAttributeTypes(fastify.pg, attributeIds);
      const normalizedValues = normalizeAttributeValues(values, types);

      await fastify.pg.query('BEGIN');
      await upsertAttributeValues(fastify.pg, productId, normalizedValues);
      await fastify.pg.query('COMMIT');

      return reply.send({ product_id: productId, values: normalizedValues });
    } catch (err) {
      await fastify.pg.query('ROLLBACK').catch(() => null);
      request.log.error(err);
      if (err.statusCode === 422) {
        return reply.code(422).send({ error: err.message });
      }
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.get('/etim/classes', { preHandler }, async (request, reply) => {
    try {
      const classes = await fetchEtimClasses(fastify.pg, request.query.version);
      return reply.send({ classes });
    } catch (err) {
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });

  fastify.put('/categories/:id/etim', { preHandler }, async (request, reply) => {
    try {
      const categoryId = request.params.id;
      const mappings = Array.isArray(request.body?.mappings) ? request.body.mappings : [];

      await fastify.pg.query('BEGIN');
      await replaceCategoryEtimMap(fastify.pg, categoryId, mappings);
      await fastify.pg.query('COMMIT');

      return reply.send({ category_id: categoryId, mappings });
    } catch (err) {
      await fastify.pg.query('ROLLBACK').catch(() => null);
      request.log.error(err);
      return reply.code(500).send({ error: 'internal_error' });
    }
  });
}

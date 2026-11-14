import type { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { InMemoryTeamAppGateway } from '../integrations/gateway.js';

const gateway = new InMemoryTeamAppGateway();

export async function registerCatalogRoutes(app: FastifyInstance) {
  const r = app.withTypeProvider<ZodTypeProvider>();
  r.get('/v1/courses', async () => gateway.listCourses());
  r.get('/v1/courses/:id', { schema: { params: z.object({ id: z.string().uuid() }) } }, async (req) => {
    const all = await gateway.listCourses();
    const c = all.find((x) => x.id === req.params.id);
    if (!c) throw Object.assign(new Error('NOT_FOUND'), { statusCode: 404 });
    return c;
  });
  r.get(
    '/v1/batches',
    { schema: { querystring: z.object({ course_id: z.string().uuid().optional(), centre_id: z.string().optional(), schedule: z.string().optional() }) } },
    async (req) => (req.query.course_id ? gateway.listBatches(req.query.course_id) : []),
  );
}

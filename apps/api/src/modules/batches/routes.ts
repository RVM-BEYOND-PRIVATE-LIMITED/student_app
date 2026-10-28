import type { FastifyInstance } from 'fastify';
export async function registerBatchRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (app as any).get('/v1/batches/detail', async () => ({ ok: true, stub: 'M2+' }));
}

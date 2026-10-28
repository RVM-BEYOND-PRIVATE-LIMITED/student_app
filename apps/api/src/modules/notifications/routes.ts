import type { FastifyInstance } from 'fastify';
export async function registerNotificationRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const a = app as any;
  a.get('/v1/me/notifications', async () => ({ notifications: [] }));
  a.post('/v1/me/notifications/:id/read', async () => ({ ok: true }));
  a.put('/v1/me/push-token', async () => ({ ok: true }));
}

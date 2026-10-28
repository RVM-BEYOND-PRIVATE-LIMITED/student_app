import type { FastifyInstance } from 'fastify';
export async function registerLiveRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const a = app as any;
  a.get('/v1/me/live-sessions', async () => ({ sessions: [] }));
  a.post('/v1/live-sessions/:id/join', async () => ({ ok: true, stub: 'M6+' }));
  a.post('/v1/live-sessions/:id/doubts', async () => ({ ok: true }));
  a.post('/v1/webhooks/live/:provider', async () => ({ ok: true }));
  a.post('/v1/webhooks/vdocipher', async () => ({ ok: true }));
  a.post('/v1/internal/live-sessions', async () => ({ ok: true, stub: 'M6+' }));
  a.post('/v1/internal/students/:id/extra-views', async () => ({ ok: true }));
}

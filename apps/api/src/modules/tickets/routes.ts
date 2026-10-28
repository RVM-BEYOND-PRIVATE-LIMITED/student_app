import type { FastifyInstance } from 'fastify';
export async function registerTicketRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const a = app as any;
  a.get('/v1/me/tickets', async () => ({ tickets: [] }));
  a.post('/v1/me/tickets', async () => ({ ok: true, stub: 'M4+' }));
  a.get('/v1/me/tickets/:id', async () => ({ ok: true, stub: 'M4+' }));
  a.post('/v1/me/tickets/:id/messages', async () => ({ ok: true }));
  a.post('/v1/me/tickets/:id/reopen', async () => ({ ok: true }));
}

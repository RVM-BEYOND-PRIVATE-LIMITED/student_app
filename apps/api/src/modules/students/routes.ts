import type { FastifyInstance } from 'fastify';
export async function registerStudentCoreRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const a = app as any;
  a.get('/v1/me/onboarding', async () => ({ step: 'profile' }));
  a.post('/v1/me/profile', async () => ({ ok: true, stub: 'M1+' }));
  a.get('/v1/me', async () => ({ ok: true, stub: 'M1+' }));
  a.get('/v1/me/dashboard', async () => ({ ok: true, stub: 'M4+' }));
  a.get('/v1/me/enrolments', async () => ({ enrolments: [] }));
  a.get('/v1/me/timetable', async () => ({ sessions: [] }));
  a.get('/v1/me/attendance', async () => ({ attendance: [] }));
  a.post('/v1/me/attendance/corrections', async () => ({ ok: true, stub: 'M4+' }));
  a.get('/v1/me/fees', async () => ({ fees: [] }));
  a.post('/v1/me/instalments/:id/razorpay-order', async () => ({ ok: true, stub: 'M3+' }));
  a.get('/v1/me/receipts/:id.pdf', async () => ({ ok: true, stub: 'M4+' }));
  a.get('/v1/me/devices', async () => ({ devices: [] }));
  a.delete('/v1/me/devices/:id', async () => ({ ok: true }));
  a.post('/v1/me/deletion-request', async () => ({ ok: true, stub: 'M4+' }));
  a.get('/v1/undertakings/current', async () => ({ version: null, stub: 'M1+' }));
  a.post('/v1/undertakings/video/heartbeat', async () => ({ ok: true }));
  a.post('/v1/undertakings/accept', async () => ({ ok: true, stub: 'M1+' }));
  a.get('/v1/me/undertaking.pdf', async () => ({ ok: true, stub: 'M1+' }));
}

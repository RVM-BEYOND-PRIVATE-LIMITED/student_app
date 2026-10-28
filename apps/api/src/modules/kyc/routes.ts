import type { FastifyInstance } from 'fastify';
export async function registerKycRoutes(app: FastifyInstance) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (app as any).post('/v1/me/kyc/upload-url', async () => ({ ok: true, stub: 'M1+' }));
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (app as any).post('/v1/me/kyc/complete', async () => ({ ok: true, stub: 'M1+' }));
}

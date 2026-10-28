import type { FastifyInstance } from 'fastify';
export async function registerFeeRoutes(app: FastifyInstance) {
  // Fee plan choice + instalment schedule proposal (team instalments stay ledger of record).
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (app as any).get('/v1/fees/plan', async () => ({ ok: true, stub: 'M3+' }));
}

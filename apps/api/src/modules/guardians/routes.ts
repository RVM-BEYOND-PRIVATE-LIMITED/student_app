import type { FastifyInstance } from 'fastify';

async function ok(app: FastifyInstance, method: 'get' | 'post' | 'put' | 'delete', path: string) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (app as any)[method](path, async () => ({ ok: true, stub: 'M1+' }));
}

export async function registerGuardianRoutes(app: FastifyInstance) {
  await ok(app, 'post', '/v1/me/guardian');
  await ok(app, 'post', '/v1/me/guardian/verify');
}

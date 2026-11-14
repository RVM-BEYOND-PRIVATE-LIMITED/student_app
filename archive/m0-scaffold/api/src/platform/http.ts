import { randomUUID } from 'node:crypto';
import type { FastifyInstance, FastifyRequest } from 'fastify';

// Port of Scheduler_Backend middleware/auditContext.js:
// per-request correlation id, client address, lazily-resolved route template.
// Writes nothing, queries nothing. AUDIT_MODE=off disables audit writes only,
// never this context.
declare module 'fastify' {
  interface FastifyRequest {
    requestId: string;
    routeTemplate?: string | undefined;
  }
}

export async function auditContext(app: FastifyInstance) {
  app.addHook('onRequest', async (req: FastifyRequest) => {
    req.requestId = (req.headers['x-request-id'] as string) || randomUUID();
  });
  app.addHook('onResponse', async (req, reply) => {
    reply.header('x-request-id', (req as FastifyRequest).requestId ?? '');
  });
}

export function routeTemplate(req: FastifyRequest): string {
  if (req.routeTemplate) return req.routeTemplate;
  // Fastify exposes routerPath; fall back to raw url without query (never store raw URL with PII).
  const t: string =
    (req as unknown as { routerPath?: string }).routerPath ?? req.url.split('?')[0] ?? req.url;
  req.routeTemplate = t;
  return t;
}

import { createHash } from 'node:crypto';
import type { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';

// Every mutating endpoint accepts Idempotency-Key and is safe to retry.
// Contract: table lms.idempotency_keys (key, route, request_hash, response, status).
// Middleware computes request_hash = sha256(method + route + body). If (key, route)
// exists and hash matches -> replay stored response. If hash differs -> 422.

export function hashRequest(route: string, body: unknown): string {
  return createHash('sha256').update(JSON.stringify({ route, body })).digest('hex');
}

export interface IdempotencyStore {
  get(key: string, route: string): Promise<{ request_hash: string; response: unknown; status: number } | null>;
  put(key: string, route: string, requestHash: string, response: unknown, status: number, studentId?: string): Promise<void>;
}

export async function idempotencyHook(
  app: FastifyInstance,
  store: IdempotencyStore,
  opts: { methods?: string[] } = {},
) {
  const methods = new Set(opts.methods ?? ['POST', 'PUT', 'PATCH', 'DELETE']);
  app.addHook('preHandler', async (req: FastifyRequest, reply: FastifyReply) => {
    if (!methods.has(req.method)) return;
    const key = req.headers['idempotency-key'] as string | undefined;
    if (!key) return; // spec says mutating routes require it; route-level zod enforces, hook replays
    const route: string = req.url.split('?')[0] ?? req.url;
    const existing = await store.get(key, route);
    const current = hashRequest(route, req.body);
    if (existing) {
      if (existing.request_hash !== current) {
        reply.status(422).send({ code: 'CONFLICT', message: 'Idempotency-Key already used with different payload' });
        return;
      }
      reply.status(existing.status).send(existing.response);
      return;
    }
    // Store onSend: wrap reply.send once per request
    const origSend = reply.send.bind(reply) as (payload: unknown) => FastifyReply;
    reply.send = ((payload: unknown) => {
      void store
        .put(key, route, current, payload, reply.statusCode)
        .catch((e) => app.log.error({ err: e }, 'idempotency put failed'));
      return origSend(payload);
    }) as typeof reply.send;
  });
}

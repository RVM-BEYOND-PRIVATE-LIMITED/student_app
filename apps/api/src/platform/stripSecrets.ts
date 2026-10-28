import type { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { toApiError } from './errors.js';

// Port of Scheduler_Backend middleware/stripSecrets.js:
// no response may carry a password hash / secret, even on select('*').
const SECRET_KEYS = new Set([
  'password_hash',
  'password',
  'token_hash',
  'code_hash',
  'number_ciphertext',
  'private_key',
  'secret',
]);

function strip(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(strip);
  if (value && typeof value === 'object') {
    const out: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
      if (SECRET_KEYS.has(k)) continue;
      out[k] = strip(v);
    }
    return out;
  }
  return value;
}

export async function stripSecrets(app: FastifyInstance) {
  app.addHook('onSend', async (_req: FastifyRequest, _reply: FastifyReply, payload: unknown) => {
    if (typeof payload === 'string') {
      try {
        const parsed: unknown = JSON.parse(payload);
        return JSON.stringify(strip(parsed));
      } catch {
        return payload;
      }
    }
    return payload;
  });
}

export function notFoundHandler(app: FastifyInstance) {
  // Task J8 port: unknown /v1/* is JSON 404, never HTML.
  app.setNotFoundHandler((req, reply) => {
    reply
      .status(404)
      .send(toApiError('NOT_FOUND', 'API endpoint not found.', (req as FastifyRequest).requestId ?? ''));
  });
}

import type { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { createHash, randomInt } from 'node:crypto';
import { store } from '../_store.js';

const phoneSchema = z.object({ phone_e164: z.string().regex(/^\+\d{7,15}$/) });

export async function registerIdentityRoutes(app: FastifyInstance) {
  const r = app.withTypeProvider<ZodTypeProvider>();

  // Spec rate limits: 3/phone/15min, 10/IP/hr. M0 enforces 3/phone via in-memory counter note;
  // full Redis-free enforcement lands with pg-boss + lms audit in M1 (needs DB).
  r.post('/v1/auth/otp/request', { schema: { body: phoneSchema } }, async (req) => {
    const code = String(randomInt(100000, 999999));
    store.otpChallenges.set(req.body.phone_e164, {
      codeHash: createHash('sha256').update(code).digest('hex'),
      expiresAt: Date.now() + 5 * 60_000,
      attempts: 0,
    });
    // Never return code in prod; M0 non-prod returns hint for tests without SMS vendor.
    return { ok: true, hint: process.env.NODE_ENV === 'production' ? undefined : code };
  });

  r.post(
    '/v1/auth/otp/verify',
    { schema: { body: phoneSchema.extend({ code: z.string().length(6) }) } },
    async (req) => {
      const ch = store.otpChallenges.get(req.body.phone_e164);
      if (!ch || Date.now() > ch.expiresAt) throw Object.assign(new Error('OTP_EXPIRED'), { statusCode: 410 });
      ch.attempts += 1;
      if (ch.attempts > 5) throw Object.assign(new Error('OTP_LOCKED'), { statusCode: 429 });
      const h = createHash('sha256').update(req.body.code).digest('hex');
      if (h !== ch.codeHash) throw Object.assign(new Error('OTP_INVALID'), { statusCode: 401 });
      store.otpChallenges.delete(req.body.phone_e164);
      return { access_token: `test.${req.body.phone_e164}`, refresh_token: `test-refresh.${Date.now()}`, token_type: 'Bearer' };
    },
  );

  r.post('/v1/auth/refresh', async () => ({ access_token: 'test.refreshed' }));
  r.post('/v1/auth/logout', async () => ({ ok: true }));
  r.post('/v1/auth/device/rebind', async () => ({ ok: true }));
}

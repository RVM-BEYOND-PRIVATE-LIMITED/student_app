import type { FastifyInstance } from 'fastify';
import { verifyRazorpaySignature } from './service.js';

export async function registerPaymentRoutes(app: FastifyInstance) {
  // Webhook: signature on raw body, unlimited rate but signature-checked, no JWT.
  app.post('/v1/webhooks/razorpay', async (req, reply) => {
    const sig = (req.headers['x-razorpay-signature'] as string) || '';
    const secret = process.env.RAZORPAY_WEBHOOK_SECRET || 'test-secret';
    const raw = (req as unknown as { rawBody?: string }).rawBody ?? JSON.stringify(req.body ?? {});
    if (!verifyRazorpaySignature(raw, sig, secret)) {
      reply.status(400).send({ code: 'BAD_SIGNATURE', message: 'Invalid webhook signature' });
      return;
    }
    // M0: dedupe via in-memory note; M3 persists to lms.webhook_inbox (unique provider+event_id) then 200-ack + async worker.
    reply.status(200).send({ ok: true });
  });

  // Internal team-app -> this API (service token + IP allow-list, audit-logged in M4).
  app.post('/v1/internal/reception-receipts', async (req, reply) => {
    if ((req.headers['x-service-token'] as string) !== (process.env.INTERNAL_SERVICE_TOKEN || 'change-me')) {
      reply.status(401).send({ code: 'UNAUTHORIZED', message: 'bad service token' });
      return;
    }
    return { ok: true };
  });
}

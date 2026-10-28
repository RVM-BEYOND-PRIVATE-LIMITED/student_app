import { createHmac, timingSafeEqual } from 'node:crypto';

// Razorpay webhook: verify HMAC-SHA256 on RAW body, insert into webhook_inbox
// (unique provider+event_id => duplicates no-op), ack 200 immediately, process async.
export function verifyRazorpaySignature(rawBody: string | Buffer, signature: string, secret: string): boolean {
  const digest = createHmac('sha256', secret).update(rawBody).digest('hex');
  const a = Buffer.from(digest);
  const b = Buffer.from(signature);
  return a.length === b.length && timingSafeEqual(a, b);
}

export function webhookDedupeKey(provider: string, providerEventId: string): string {
  return `${provider}:${providerEventId}`;
}

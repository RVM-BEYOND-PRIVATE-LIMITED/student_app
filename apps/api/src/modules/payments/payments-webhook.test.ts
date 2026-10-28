import { describe, it, expect } from 'vitest';
import { createHmac } from 'node:crypto';
import { verifyRazorpaySignature } from './service.js';

describe('razorpay webhook signature', () => {
  it('accepts valid HMAC, rejects tampered', () => {
    const secret = 'test-secret';
    const body = JSON.stringify({ event: 'payment.captured', id: 'evt_1' });
    const sig = createHmac('sha256', secret).update(body).digest('hex');
    expect(verifyRazorpaySignature(body, sig, secret)).toBe(true);
    expect(verifyRazorpaySignature(body + 'x', sig, secret)).toBe(false);
  });
});

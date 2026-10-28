import { describe, it, expect, beforeAll } from 'vitest';
import { createHmac } from 'node:crypto';
import { buildApp } from '../src/server.js';

const C1 = '11111111-1111-4111-8111-111111111111';
const B1 = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';

// M0 HTTP integration (in-memory store, no DB): auth isolation 404 matrix,
// booking lifecycle, webhook signature gate, playback single-session.
describe('v1 routes (M0, no DB)', () => {
  let app: Awaited<ReturnType<typeof buildApp>>;
  beforeAll(async () => {
    app = await buildApp();
    await app.ready();
  });

  async function otpLogin(phone: string): Promise<string> {
    const r1 = await app.inject({ method: 'POST', url: '/v1/auth/otp/request', payload: { phone_e164: phone } });
    expect(r1.statusCode).toBe(200);
    const hint = r1.json().hint as string;
    const r2 = await app.inject({ method: 'POST', url: '/v1/auth/otp/verify', payload: { phone_e164: phone, code: hint } });
    expect(r2.statusCode).toBe(200);
    return (r2.json().access_token as string).replace(/^test\./, 'test.');
  }

  it('health + config', async () => {
    expect((await app.inject({ url: '/health' })).statusCode).toBe(200);
    expect((await app.inject({ url: '/v1/config' })).statusCode).toBe(200);
  });

  it('booking isolation: student B gets 404 on student A booking', async () => {
    const tokA = await otpLogin('+911111111111');
    const tokB = await otpLogin('+912222222222');
    const create = await app.inject({
      method: 'POST', url: '/v1/bookings',
      headers: { authorization: `Bearer ${tokA}` },
      payload: { items: [{ team_course_id: C1, team_batch_id: B1, list_paise: 1550000 }], fee_plan: 'one_time' },
    });
    expect(create.statusCode).toBe(200);
    const id = create.json().id as string;
    const asB = await app.inject({ url: `/v1/bookings/${id}`, headers: { authorization: `Bearer ${tokB}` } });
    expect(asB.statusCode).toBe(404);
    const asA = await app.inject({ url: `/v1/bookings/${id}`, headers: { authorization: `Bearer ${tokA}` } });
    expect(asA.statusCode).toBe(200);
  });

  it('one active booking per student => 409', async () => {
    const tok = await otpLogin('+913333333333');
    const payload = { items: [{ team_course_id: C1, team_batch_id: B1, list_paise: 1550000 }], fee_plan: 'one_time' };
    expect((await app.inject({ method: 'POST', url: '/v1/bookings', headers: { authorization: `Bearer ${tok}` }, payload })).statusCode).toBe(200);
    expect((await app.inject({ method: 'POST', url: '/v1/bookings', headers: { authorization: `Bearer ${tok}` }, payload })).statusCode).toBe(409);
  });

  it('webhook rejects bad signature, accepts good', async () => {
    const body = { event: 'payment.captured', id: 'evt_1' };
    const raw = JSON.stringify(body);
    const bad = await app.inject({ method: 'POST', url: '/v1/webhooks/razorpay', headers: { 'x-razorpay-signature': 'nope' }, payload: body });
    expect(bad.statusCode).toBe(400);
    const sig = createHmac('sha256', 'test-secret').update(raw).digest('hex');
    const good = await app.inject({ method: 'POST', url: '/v1/webhooks/razorpay', headers: { 'x-razorpay-signature': sig }, payload: body });
    expect(good.statusCode).toBe(200);
  });

  it('playback: second concurrent session blocked', async () => {
    const tok = await otpLogin('+914444444444');
    const vid = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
    const dev = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';
    const s1 = await app.inject({ method: 'POST', url: '/v1/playback/sessions', headers: { authorization: `Bearer ${tok}` }, payload: { video_id: vid, device_id: dev } });
    expect(s1.statusCode).toBe(200);
    const s2 = await app.inject({ method: 'POST', url: '/v1/playback/sessions', headers: { authorization: `Bearer ${tok}` }, payload: { video_id: vid, device_id: dev } });
    expect(s2.statusCode).toBe(409);
  });
});

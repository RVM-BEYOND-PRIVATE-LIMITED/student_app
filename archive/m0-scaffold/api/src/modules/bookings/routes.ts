import type { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';
import { quoteRequestSchema } from '../pricing/schemas.js';
import { quote } from '../pricing/service.js';
import { nextBookingStatus, assertMoneyInvariants } from './service.js';
import { store, newBookingRef } from '../_store.js';

const createBookingSchema = quoteRequestSchema;
const bookingSchema = z.object({
  id: z.string().uuid(),
  booking_ref: z.string(),
  status: z.string(),
  total_paise: z.number().int(),
});

function studentId(req: { headers: Record<string, unknown> }): string {
  // M0 fake auth: Authorization: Bearer test.<student-uuid>. Real EdDSA (jose) lands with secrets in M1.
  const h = (req.headers['authorization'] as string) || '';
  const m = h.match(/^Bearer test\.(.+)$/);
  if (!m?.[1]) throw Object.assign(new Error('UNAUTHORIZED'), { statusCode: 401 });
  return m[1] as string;
}

export async function registerBookingRoutes(app: FastifyInstance) {
  const r = app.withTypeProvider<ZodTypeProvider>();

  r.post('/v1/bookings', { schema: { body: createBookingSchema } }, async (req) => {
    const sid = studentId(req as unknown as { headers: Record<string, unknown> });
    // One active booking per student.
    for (const b of store.bookingsById.values()) {
      if (b.student_id === sid && ['held', 'awaiting_reception', 'payment_processing'].includes(b.status)) {
        throw Object.assign(new Error('ONLY_ONE_ACTIVE_BOOKING'), { statusCode: 409 });
      }
    }
    const q = quote(req.body, [], new Date());
    assertMoneyInvariants({
      subtotal_paise: q.subtotal_paise,
      discount_paise: q.discount_paise,
      total_paise: q.total_paise,
      seat_fee_paise: q.seat_fee_paise,
      itemNets: q.items.map((i) => i.net_paise),
    });
    const id = crypto.randomUUID();
    const rec = {
      id,
      booking_ref: newBookingRef(),
      student_id: sid,
      status: 'held' as const,
      fee_plan: req.body.fee_plan,
      subtotal_paise: q.subtotal_paise,
      discount_paise: q.discount_paise,
      total_paise: q.total_paise,
      seat_fee_paise: q.seat_fee_paise,
      price_snapshot: q.price_snapshot as Record<string, unknown>,
      hold_expires_at: new Date(Date.now() + 15 * 60_000).toISOString(),
    };
    store.bookingsById.set(id, rec);
    store.bookingsByRef.set(rec.booking_ref, rec);
    return { ...rec };
  });

  r.get('/v1/bookings/:id', async (req) => {
    const sid = studentId(req as unknown as { headers: Record<string, unknown> });
    const b = store.bookingsById.get((req.params as { id: string }).id);
    if (!b || b.student_id !== sid) throw Object.assign(new Error('NOT_FOUND'), { statusCode: 404 });
    return b;
  });

  const transition = (event: 'RAZORPAY_ORDER_CREATED' | 'CHOOSE_RECEPTION' | 'WEBHOOK_CAPTURED' | 'RECEPTION_RECEIPT' | 'EXPIRE' | 'CANCEL') =>
    async (req: unknown) => {
      const sid = studentId((req as { headers: Record<string, unknown> }).headers ? (req as unknown as { headers: Record<string, unknown> }) : { headers: {} });
      const params = (req as { params: { id: string } }).params;
      const b = store.bookingsById.get(params.id);
      if (!b || b.student_id !== sid) throw Object.assign(new Error('NOT_FOUND'), { statusCode: 404 });
      b.status = nextBookingStatus(b.status as never, event as never);
      return b;
    };

  r.post('/v1/bookings/:id/razorpay-order', transition('RAZORPAY_ORDER_CREATED'));
  r.post('/v1/bookings/:id/pay-at-reception', transition('CHOOSE_RECEPTION'));
  r.post('/v1/bookings/:id/cancel', transition('CANCEL'));
  void bookingSchema;
}

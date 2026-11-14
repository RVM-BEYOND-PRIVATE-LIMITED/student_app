import { z } from 'zod';

export const bookingStatusSchema = z.enum([
  'held',
  'payment_processing',
  'awaiting_reception',
  'confirmed',
  'expired',
  'cancelled',
]);
export type BookingStatus = z.infer<typeof bookingStatusSchema>;

export const bookingEventSchema = z.enum([
  'CREATE',
  'RAZORPAY_ORDER_CREATED',
  'CHOOSE_RECEPTION',
  'WEBHOOK_CAPTURED',
  'RECEPTION_RECEIPT',
  'EXPIRE',
  'CANCEL',
]);
export type BookingEvent = z.infer<typeof bookingEventSchema>;

export const bookingRefSchema = z.string().regex(/^[A-Z0-9-]{6,32}$/);

import type { BookingEvent, BookingStatus } from './schemas.js';

// Spec § State machines: every transition commits with its outbox event in ONE tx.
// Anything not listed => 409.
const TRANSITIONS: Record<BookingStatus, Partial<Record<BookingEvent, BookingStatus>>> = {
  held: {
    RAZORPAY_ORDER_CREATED: 'payment_processing',
    CHOOSE_RECEPTION: 'awaiting_reception',
    EXPIRE: 'expired',
    CANCEL: 'cancelled',
  },
  payment_processing: {
    WEBHOOK_CAPTURED: 'confirmed',
    EXPIRE: 'expired',
  },
  awaiting_reception: {
    RECEPTION_RECEIPT: 'confirmed',
    EXPIRE: 'expired',
    CANCEL: 'cancelled',
  },
  confirmed: {},
  expired: {},
  cancelled: {},
};

export function nextBookingStatus(from: BookingStatus, event: BookingEvent): BookingStatus {
  const to = TRANSITIONS[from]?.[event];
  if (!to) {
    throw new Error(`INVALID_TRANSITION:${from}+${event}`);
  }
  return to;
}

// Invariants (unit-tested):
// - total = subtotal - discount; sum(item.net) = total; seat fee inside total.
// - price snapshot never changes after held (enforced by caller: requote => new booking).
// - one active (held/awaiting_reception/payment_processing) booking per student (enforced by repo unique partial index).
export function assertMoneyInvariants(args: {
  subtotal_paise: number;
  discount_paise: number;
  total_paise: number;
  seat_fee_paise: number;
  itemNets: number[];
}): void {
  const { subtotal_paise, discount_paise, total_paise, seat_fee_paise, itemNets } = args;
  if (total_paise !== subtotal_paise - discount_paise) throw new Error('INVARIANT_TOTAL_MISMATCH');
  if (itemNets.reduce((s, n) => s + n, 0) !== total_paise) throw new Error('INVARIANT_ITEM_SUM_MISMATCH');
  if (total_paise < seat_fee_paise) throw new Error('INVARIANT_BELOW_SEAT_FEE');
  if ([subtotal_paise, discount_paise, total_paise, seat_fee_paise].some((v) => !Number.isInteger(v) || v < 0)) {
    throw new Error('INVARIANT_NON_INTEGER_PAISE');
  }
}

// Last-seat SQL pattern (raw SQL, batch-ID order to avoid deadlocks):
//   BEGIN; SET LOCAL lock_timeout='3s';
//   SELECT capacity, version FROM lms.batch_capacity WHERE team_batch_id = ANY($1 ORDER BY 1) FOR UPDATE;
//   SELECT count(*) FROM lms.seat_holds WHERE team_batch_id = ANY($1) AND status IN ('held','confirmed');
//   -- insert holds only if holds + requested <= capacity; else ROLLBACK + 409.
//   COMMIT;
export const LAST_SEAT_SQL_HINT = 'SELECT ... FOR UPDATE ORDER BY team_batch_id; check holds + confirmed < capacity';

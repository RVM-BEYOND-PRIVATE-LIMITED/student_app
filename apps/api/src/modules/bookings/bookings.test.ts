import { describe, it, expect } from 'vitest';
import { nextBookingStatus, assertMoneyInvariants } from './service.js';

describe('booking state machine', () => {
  it('held -> payment_processing -> confirmed', () => {
    expect(nextBookingStatus('held', 'RAZORPAY_ORDER_CREATED')).toBe('payment_processing');
    expect(nextBookingStatus('payment_processing', 'WEBHOOK_CAPTURED')).toBe('confirmed');
  });
  it('held -> awaiting_reception -> confirmed via reception', () => {
    expect(nextBookingStatus('held', 'CHOOSE_RECEPTION')).toBe('awaiting_reception');
    expect(nextBookingStatus('awaiting_reception', 'RECEPTION_RECEIPT')).toBe('confirmed');
  });
  it('expiry from all active states', () => {
    expect(nextBookingStatus('held', 'EXPIRE')).toBe('expired');
    expect(nextBookingStatus('payment_processing', 'EXPIRE')).toBe('expired');
    expect(nextBookingStatus('awaiting_reception', 'EXPIRE')).toBe('expired');
  });
  it('cancel allowed only from held/awaiting_reception', () => {
    expect(nextBookingStatus('held', 'CANCEL')).toBe('cancelled');
    expect(nextBookingStatus('awaiting_reception', 'CANCEL')).toBe('cancelled');
    expect(() => nextBookingStatus('payment_processing', 'CANCEL')).toThrow('INVALID_TRANSITION');
  });
  it('rejects unlisted transitions with 409-style error', () => {
    expect(() => nextBookingStatus('confirmed', 'CANCEL')).toThrow('INVALID_TRANSITION');
    expect(() => nextBookingStatus('expired', 'WEBHOOK_CAPTURED')).toThrow('INVALID_TRANSITION');
    expect(() => nextBookingStatus('cancelled', 'EXPIRE')).toThrow('INVALID_TRANSITION');
  });
});

describe('booking money invariants', () => {
  it('accepts balanced booking with seat fee inside total', () => {
    expect(() =>
      assertMoneyInvariants({ subtotal_paise: 3350000, discount_paise: 335000, total_paise: 3015000, seat_fee_paise: 99900, itemNets: [1500000, 1515000] }),
    ).not.toThrow();
  });
  it('rejects total mismatch and item-sum mismatch', () => {
    expect(() =>
      assertMoneyInvariants({ subtotal_paise: 100, discount_paise: 10, total_paise: 100, seat_fee_paise: 99900, itemNets: [100] }),
    ).toThrow();
  });
});

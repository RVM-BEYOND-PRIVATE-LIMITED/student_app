import type { BundleRule, QuoteRequest, QuoteResponse } from './schemas.js';

// Spec: ₹999 seat fee is part of total, non-refundable, once per booking.
export const SEAT_FEE_PAISE = 99900;

// Pure domain: picks best matching bundle rule (highest discount_bps whose
// min_courses + min_subtotal_paise thresholds are met and effective window covers now).
// Discount is apportioned across items proportionally; rounding remainder goes to first item
// so sum(item.net) === total invariant always holds.
export function quote(
  req: QuoteRequest,
  rules: BundleRule[],
  now: Date = new Date(),
): QuoteResponse {
  const subtotal = req.items.reduce((s, i) => s + i.list_paise, 0);
  const eligible = rules.filter(
    (r) =>
      req.items.length >= r.min_courses &&
      subtotal >= r.min_subtotal_paise &&
      new Date(r.effective_from) <= now &&
      (!r.effective_to || now <= new Date(r.effective_to)),
  );
  eligible.sort((a, b) => b.discount_bps - a.discount_bps);
  const best = eligible[0];
  const discount = best ? Math.floor((subtotal * best.discount_bps) / 10000) : 0;
  const total = subtotal - discount;

  // Invariant: total = subtotal - discount; seat fee inside total, never on top.
  if (total < SEAT_FEE_PAISE) {
    throw new Error('TOTAL_BELOW_SEAT_FEE');
  }

  // Apportion discount proportionally (largest-remainder to keep integer paise exact).
  const items = req.items.map((it) => ({ ...it, discount_paise: 0, net_paise: it.list_paise }));
  if (discount > 0 && subtotal > 0) {
    let assigned = 0;
    items.forEach((it, idx) => {
      if (idx === items.length - 1) {
        it.discount_paise = discount - assigned;
      } else {
        it.discount_paise = Math.floor((it.list_paise * discount) / subtotal);
        assigned += it.discount_paise;
      }
      it.net_paise = it.list_paise - it.discount_paise;
    });
  }

  return {
    subtotal_paise: subtotal,
    discount_paise: discount,
    total_paise: total,
    seat_fee_paise: SEAT_FEE_PAISE,
    items,
    price_snapshot: {
      quoted_at: now.toISOString(),
      fee_plan: req.fee_plan,
      rule_id: best?.id ?? null,
      currency: 'INR-paise',
    } as Record<string, unknown>,
  };
}

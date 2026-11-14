import { describe, it, expect } from 'vitest';
import { quote, SEAT_FEE_PAISE } from './service.js';

const C1 = '11111111-1111-4111-8111-111111111111';
const C2 = '22222222-2222-4222-8222-222222222222';
const B1 = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const B2 = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';

describe('pricing.quote', () => {
  it('no rules => no discount, totals balance', () => {
    const q = quote({ items: [{ team_course_id: C1, team_batch_id: B1, list_paise: 1550000 }], fee_plan: 'one_time' }, []);
    expect(q.subtotal_paise).toBe(1550000);
    expect(q.discount_paise).toBe(0);
    expect(q.total_paise).toBe(1550000);
    expect(q.seat_fee_paise).toBe(SEAT_FEE_PAISE);
    expect(q.items.reduce((s, i) => s + i.net_paise, 0)).toBe(q.total_paise);
  });

  it('picks best bundle tier; sum(item.net) === total', () => {
    const rules = [
      { min_courses: 2, min_subtotal_paise: 2000000, discount_bps: 500, effective_from: '2020-01-01T00:00:00Z', effective_to: null as string | null },
      { min_courses: 2, min_subtotal_paise: 2000000, discount_bps: 1000, effective_from: '2020-01-01T00:00:00Z', effective_to: null as string | null },
    ];
    const q = quote(
      {
        items: [
          { team_course_id: C1, team_batch_id: B1, list_paise: 1550000 },
          { team_course_id: C2, team_batch_id: B2, list_paise: 1800000 },
        ],
        fee_plan: 'one_time',
      },
      rules,
      new Date('2026-01-01T00:00:00Z'),
    );
    expect(q.subtotal_paise).toBe(3350000);
    expect(q.discount_paise).toBe(335000); // 10%
    expect(q.total_paise).toBe(3015000);
    expect(q.items.reduce((s, i) => s + i.net_paise, 0)).toBe(q.total_paise);
    expect(q.items.reduce((s, i) => s + i.discount_paise, 0)).toBe(q.discount_paise);
  });

  it('ignores expired rules and unmet thresholds', () => {
    const q = quote(
      { items: [{ team_course_id: C1, team_batch_id: B1, list_paise: 1550000 }], fee_plan: 'one_time' },
      [{ min_courses: 2, min_subtotal_paise: 100, discount_bps: 5000, effective_from: '2020-01-01T00:00:00Z', effective_to: null as string | null }],
      new Date('2026-01-01T00:00:00Z'),
    );
    expect(q.discount_paise).toBe(0);
  });

  it('rounding: discount apportion stays exact across items', () => {
    const rules = [{ min_courses: 3, min_subtotal_paise: 0, discount_bps: 333, effective_from: '2020-01-01T00:00:00Z', effective_to: null as string | null }];
    const items = [100001, 100001, 100001].map((list_paise, i) => ({
      team_course_id: C1, team_batch_id: [B1, B2, B1][i] as string, list_paise,
    }));
    const q = quote({ items, fee_plan: 'one_time' }, rules, new Date('2026-01-01T00:00:00Z'));
    expect(q.items.reduce((s, i) => s + i.discount_paise, 0)).toBe(q.discount_paise);
    expect(q.items.reduce((s, i) => s + i.net_paise, 0)).toBe(q.total_paise);
    expect(q.items.every((i) => i.net_paise >= 0)).toBe(true);
  });

  it('rejects total below seat fee (invariant guard)', () => {
    expect(() =>
      quote({ items: [{ team_course_id: C1, team_batch_id: B1, list_paise: 1000 }], fee_plan: 'one_time' }, []),
    ).toThrow('TOTAL_BELOW_SEAT_FEE');
  });
});

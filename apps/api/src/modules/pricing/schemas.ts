import { z } from 'zod';

// Money is integer paise (bigint). Never floats. Never computed in client.
export const paiseSchema = z.number().int().min(0);

export const quoteItemSchema = z.object({
  team_course_id: z.string().uuid(),
  team_batch_id: z.string().uuid(),
  list_paise: paiseSchema,
});

export const quoteRequestSchema = z.object({
  items: z.array(quoteItemSchema).min(1).max(10),
  fee_plan: z.enum(['one_time', 'three_instalments']),
});

export const quoteResponseSchema = z.object({
  subtotal_paise: paiseSchema,
  discount_paise: paiseSchema,
  total_paise: paiseSchema,
  seat_fee_paise: paiseSchema,
  items: z.array(
    z.object({
      team_course_id: z.string().uuid(),
      team_batch_id: z.string().uuid(),
      list_paise: paiseSchema,
      discount_paise: paiseSchema,
      net_paise: paiseSchema,
    }),
  ),
  price_snapshot: z.record(z.unknown()),
});

export type QuoteRequest = z.infer<typeof quoteRequestSchema>;
export type QuoteResponse = z.infer<typeof quoteResponseSchema>;

export const bundleRuleSchema = z.object({
  id: z.string().uuid().optional(),
  min_courses: z.number().int().min(1),
  min_subtotal_paise: paiseSchema,
  discount_bps: z.number().int().min(0).max(10000),
  effective_from: z.string().datetime(),
  effective_to: z.string().datetime().nullable().optional(),
});

export type BundleRule = z.infer<typeof bundleRuleSchema>;

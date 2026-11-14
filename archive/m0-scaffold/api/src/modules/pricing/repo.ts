// pricing/repo.ts — owns ONLY lms.bundle_rules + lms.course_profiles reads.
// Writes go through migrations/human review. Money reads return integer paise.
export interface BundleRuleRow {
  id: string;
  min_courses: number;
  min_subtotal_paise: number;
  discount_bps: number;
  effective_from: string;
  effective_to: string | null;
}

export interface PricingRepo {
  listActiveRules(now: Date): Promise<BundleRuleRow[]>;
}

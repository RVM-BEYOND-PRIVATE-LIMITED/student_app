-- M0 first migration: lms schema core tables (spec § Data model).
-- Human review required. Reversible (see down.sql).
-- Conventions: lock_timeout 3s, expand-only, RLS enabled with NO policies (defence in depth).

SET lock_timeout = '3s';

CREATE SCHEMA IF NOT EXISTS lms;

-- identity
CREATE TABLE IF NOT EXISTS lms.student_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_e164 text NOT NULL UNIQUE,
  team_admission_id uuid UNIQUE,
  status text NOT NULL DEFAULT 'registering',
  dob date,
  is_minor boolean,
  onboarding_step text NOT NULL DEFAULT 'profile',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.otp_challenges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_e164 text NOT NULL,
  purpose text NOT NULL,
  code_hash text NOT NULL,
  attempts int NOT NULL DEFAULT 0,
  expires_at timestamptz NOT NULL,
  consumed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.devices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  device_key_pub text NOT NULL,
  platform text NOT NULL,
  model text,
  app_version text,
  integrity_verdict jsonb,
  is_active boolean NOT NULL DEFAULT true,
  bound_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz,
  last_seen_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS one_active_device ON lms.devices(student_id) WHERE is_active;
CREATE TABLE IF NOT EXISTS lms.refresh_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id uuid NOT NULL REFERENCES lms.devices,
  token_hash text NOT NULL UNIQUE,
  family_id uuid NOT NULL,
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz
);

-- guardians + consents (DPDP)
CREATE TABLE IF NOT EXISTS lms.guardians (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  name text NOT NULL,
  relation text NOT NULL,
  phone_e164 text NOT NULL,
  verified_at timestamptz
);
CREATE TABLE IF NOT EXISTS lms.consents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  guardian_id uuid REFERENCES lms.guardians,
  purpose text NOT NULL,
  notice_version text NOT NULL,
  granted_at timestamptz NOT NULL,
  withdrawn_at timestamptz,
  evidence jsonb NOT NULL
);

-- kyc
CREATE TABLE IF NOT EXISTS lms.kyc_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  doc_type text NOT NULL DEFAULT 'aadhaar',
  s3_keys text[] NOT NULL,
  number_last4 text NOT NULL,
  number_ciphertext bytea,
  status text NOT NULL DEFAULT 'submitted',
  reviewed_by text,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- undertakings
CREATE TABLE IF NOT EXISTS lms.undertaking_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  version text NOT NULL UNIQUE,
  video_ref text NOT NULL,
  clauses jsonb NOT NULL,
  contacts jsonb NOT NULL,
  effective_from timestamptz NOT NULL
);
CREATE TABLE IF NOT EXISTS lms.undertaking_acceptances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  version_id uuid NOT NULL REFERENCES lms.undertaking_versions,
  accepted_clause_ids text[] NOT NULL,
  optional_consents jsonb NOT NULL,
  video_completed_at timestamptz NOT NULL,
  accepted_at timestamptz NOT NULL DEFAULT now(),
  device_id uuid REFERENCES lms.devices,
  pdf_s3_key text,
  pdf_sha256 text
);

-- catalog + pricing
CREATE TABLE IF NOT EXISTS lms.course_profiles (
  team_course_id uuid PRIMARY KEY,
  brand text NOT NULL,
  domain text,
  mode text NOT NULL,
  duration_weeks int,
  description text,
  impact jsonb,
  purchasable_in_app jsonb NOT NULL DEFAULT '{"android":true,"ios":true}',
  is_listed boolean NOT NULL DEFAULT true
);
CREATE TABLE IF NOT EXISTS lms.bundle_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  min_courses int NOT NULL,
  min_subtotal_paise bigint NOT NULL,
  discount_bps int NOT NULL,
  effective_from timestamptz NOT NULL,
  effective_to timestamptz
);

-- bookings
CREATE TABLE IF NOT EXISTS lms.bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_ref text NOT NULL UNIQUE,
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  status text NOT NULL,
  fee_plan text NOT NULL,
  subtotal_paise bigint NOT NULL,
  discount_paise bigint NOT NULL,
  total_paise bigint NOT NULL,
  seat_fee_paise bigint NOT NULL DEFAULT 99900,
  price_snapshot jsonb NOT NULL,
  hold_expires_at timestamptz,
  confirmed_at timestamptz,
  confirmed_via text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.booking_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id uuid NOT NULL REFERENCES lms.bookings,
  team_course_id uuid NOT NULL,
  team_batch_id uuid NOT NULL,
  list_paise bigint NOT NULL,
  discount_paise bigint NOT NULL,
  net_paise bigint NOT NULL
);
CREATE TABLE IF NOT EXISTS lms.seat_holds (
  team_batch_id uuid NOT NULL,
  booking_item_id uuid NOT NULL REFERENCES lms.booking_items,
  status text NOT NULL,
  expires_at timestamptz,
  PRIMARY KEY (team_batch_id, booking_item_id)
);
CREATE TABLE IF NOT EXISTS lms.batch_capacity (
  team_batch_id uuid PRIMARY KEY,
  capacity int NOT NULL,
  version int NOT NULL DEFAULT 0
);

-- payments
CREATE TABLE IF NOT EXISTS lms.payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id uuid REFERENCES lms.bookings,
  purpose text NOT NULL,
  provider text NOT NULL,
  provider_order_id text UNIQUE,
  provider_payment_id text UNIQUE,
  amount_paise bigint NOT NULL,
  status text NOT NULL,
  captured_at timestamptz,
  receipt_no text,
  recorded_by text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.webhook_inbox (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider text NOT NULL,
  provider_event_id text NOT NULL,
  payload jsonb NOT NULL,
  received_at timestamptz NOT NULL DEFAULT now(),
  processed_at timestamptz,
  error text,
  UNIQUE (provider, provider_event_id)
);

-- content
CREATE TABLE IF NOT EXISTS lms.videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_course_id uuid NOT NULL,
  module text,
  title text NOT NULL,
  vdocipher_video_id text NOT NULL UNIQUE,
  duration_s int NOT NULL,
  published_at timestamptz
);
CREATE TABLE IF NOT EXISTS lms.view_policies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  scope text NOT NULL,
  scope_id uuid,
  max_views int NOT NULL DEFAULT 1,
  count_after_pct int NOT NULL DEFAULT 5,
  resume_window_min int NOT NULL DEFAULT 60
);
CREATE TABLE IF NOT EXISTS lms.entitlements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL REFERENCES lms.student_accounts,
  team_course_id uuid NOT NULL,
  source text NOT NULL,
  starts_at timestamptz NOT NULL,
  expires_at timestamptz
);
CREATE TABLE IF NOT EXISTS lms.playback_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL,
  video_id uuid NOT NULL REFERENCES lms.videos,
  device_id uuid NOT NULL REFERENCES lms.devices,
  started_at timestamptz NOT NULL DEFAULT now(),
  last_heartbeat_at timestamptz,
  position_s int NOT NULL DEFAULT 0,
  max_position_s int NOT NULL DEFAULT 0,
  counted boolean NOT NULL DEFAULT false,
  ended_at timestamptz,
  end_reason text
);
CREATE TABLE IF NOT EXISTS lms.view_counters (
  student_id uuid NOT NULL,
  video_id uuid NOT NULL REFERENCES lms.videos,
  views_used int NOT NULL DEFAULT 0,
  extra_views_granted int NOT NULL DEFAULT 0,
  PRIMARY KEY (student_id, video_id)
);

-- live
CREATE TABLE IF NOT EXISTS lms.live_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_batch_id uuid NOT NULL,
  team_faculty_id uuid,
  scheduled_start timestamptz NOT NULL,
  scheduled_end timestamptz NOT NULL,
  provider_room_id text,
  status text NOT NULL,
  recording_status text,
  recording_video_id uuid REFERENCES lms.videos
);
CREATE TABLE IF NOT EXISTS lms.live_participation (
  live_session_id uuid NOT NULL REFERENCES lms.live_sessions,
  student_id uuid NOT NULL,
  joined_at timestamptz NOT NULL,
  left_at timestamptz,
  PRIMARY KEY (live_session_id, student_id, joined_at)
);

-- platform
CREATE TABLE IF NOT EXISTS lms.outbox (
  id bigserial PRIMARY KEY,
  aggregate text NOT NULL,
  aggregate_id uuid NOT NULL,
  type text NOT NULL,
  payload jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  published_at timestamptz,
  attempts int NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS lms.idempotency_keys (
  key text NOT NULL,
  student_id uuid,
  route text NOT NULL,
  request_hash text NOT NULL,
  response jsonb,
  status int,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (key, route)
);
CREATE TABLE IF NOT EXISTS lms.audit_log (
  id bigserial PRIMARY KEY,
  actor text NOT NULL,
  action text NOT NULL,
  entity text NOT NULL,
  entity_id text,
  summary jsonb,
  request_id text,
  at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL,
  kind text NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  deep_link text,
  read_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS lms.push_tokens (
  device_id uuid PRIMARY KEY REFERENCES lms.devices,
  fcm_token text NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS on, no policies (defence in depth; service uses role grants, never anon/authenticated).
DO $$
DECLARE t text;
BEGIN
  FOR t IN SELECT tablename FROM pg_tables WHERE schemaname = 'lms' LOOP
    EXECUTE format('ALTER TABLE lms.%I ENABLE ROW LEVEL SECURITY', t);
  END LOOP;
END $$;

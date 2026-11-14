# RVM Student App — Backend Spec (Agent-Ready)

Oct 28, 2026 · @RVM CAD TECH TEAM

## Purpose and scope

Build the backend for the RVM student app: one TypeScript API and worker, deployed on AWS Lightsail, using the **existing shared Supabase Postgres**. That database already serves the operations web app, the jobs portal and the team app. The student app must never degrade those systems.

The backend serves the Flutter app only. Faculty and staff work in the existing team app, which integrates with this backend through agreed tables, events and internal endpoints.

**What it owns**

- Student identity
- Guardian consent
- KYC documents
- Course pricing
- Bookings and seat holds
- Payment capture
- Recorded-content entitlements and view counting
- Live-class join tokens
- Student-facing tickets and notifications

**What it reads but does not own** (until the integration review in M0 confirms otherwise): branches/centres, courses, batches, faculty, attendance, instalments and receipts, which already exist in the team app's tables.

**How the agent should use this doc**

- Treat it as the source of requirements.
- Copy the next section into `AGENTS.md` (and `CLAUDE.md`) at the repo root.
- Work milestone by milestone from the build plan.
- When this doc and the existing database disagree, **stop and report**. Do not guess or silently adapt.

## Agent operating rules

Paste this block verbatim into `AGENTS.md` at the repo root.

```markdown
# AGENTS.md — RVM student app backend

## Hard rules (never break)
1. The database is SHARED with production systems (ops web app, jobs portal, team app).
   - Never connect to the production database from a dev or agent session. Use the staging project only.
   - Never create, alter, drop or write to any object outside the `lms`, `lms_bridge` and `lms_jobs` schemas.
   - Reading other schemas is allowed only through views in `lms_bridge` that a human approved.
   - Every migration lives in `apps/api/migrations`, is reviewed by a human, and must be reversible or explicitly marked irreversible with a reason.
2. Investigate before you change anything. Read existing code and schema first; report findings before mutating.
   Raw command output (git, psql, test runner) beats your own summary. Paste it when reporting.
3. Money is integer paise (`bigint`). Never floats. Never compute prices in the client.
4. Every state change that matters writes an outbox event in the SAME transaction.
5. Every mutating endpoint accepts `Idempotency-Key` and is safe to retry.
6. No secrets in code, logs or test fixtures. Use env vars. Never log phone, Aadhaar, tokens or full names.
7. Tests required: a domain change ships with unit tests; an endpoint ships with an integration test against a real Postgres (Testcontainers).
8. Keep module boundaries: a module only touches its own tables; cross-module calls go through the module's public service interface.
9. When the spec is ambiguous or conflicts with what you find, STOP and ask. List the options; don't pick silently.

## Commands
- pnpm install / pnpm dev / pnpm test / pnpm lint / pnpm typecheck
- pnpm db:migrate (staging only) / pnpm db:new <name>
- pnpm openapi:build (regenerates packages/openapi/openapi.yaml)

## Definition of done
lint + typecheck + tests green, OpenAPI updated, migration reviewed, no TODOs without an issue link.
```

## Stack and monorepo layout

Use one TypeScript codebase that builds two processes from the same image: `api` (HTTP) and `worker` (outbox and jobs). A pnpm and Turborepo monorepo also holds the Flutter app and the OpenAPI contract.

| Concern | Choice |
| --- | --- |
| Runtime | Node.js 22 LTS, TypeScript `strict` |
| HTTP | Fastify + `fastify-type-provider-zod`; Zod schemas are the single source for validation and OpenAPI |
| OpenAPI | `@fastify/swagger` emits `packages/openapi/openapi.yaml` at build; CI fails if it drifts |
| Database access | Drizzle ORM with `pgSchema('lms')`; raw SQL allowed for locking queries |
| Migrations | `drizzle-kit generate` produces SQL, a human reviews it, migration history is stored in the `lms` schema |
| Jobs and queue | `pg-boss` in schema `lms_jobs` (no Redis needed) |
| Auth | Own OTP plus JWT (`jose`): short access tokens, rotating refresh tokens |
| Files (KYC, attachments) | Private S3 bucket in ap-south-1 with SSE-KMS and presigned URLs, kept out of the shared Supabase project so this service never needs its service-role key |
| Logging | `pino` JSON with redaction paths for PII |
| Errors | Sentry; OpenTelemetry traces |
| Tests | Vitest + Testcontainers (Postgres 15+ matching Supabase's major version) |

```
/
  apps/
    api/
      src/
        platform/     # config, db pool, http, auth, idempotency, outbox, jobs, errors, logging
        modules/
          identity/ students/ guardians/ kyc/ catalog/ pricing/ batches/
          bookings/ payments/ fees/ content/ live/ tickets/ notifications/
          integrations/ (team-app bridge) audit/
        server.ts     # api entrypoint
        worker.ts     # worker entrypoint
      migrations/
      test/
    mobile/           # Flutter app (separate tooling)
  packages/
    openapi/openapi.yaml
  infra/
    docker/Dockerfile
    lightsail/        # deploy scripts, container service definition
  .github/workflows/  # api-ci.yml, api-deploy.yml, mobile-ci.yml, mobile-release.yml
  pnpm-workspace.yaml  turbo.json
```

Each module has the same shape: `routes.ts`, `service.ts` (its public interface), `repo.ts` (its own tables only), `schemas.ts` (Zod), `events.ts` and `*.test.ts`.

## Shared Supabase database

The database is shared by four production systems. The design goal is containment: the student app must not be able to exhaust connections, hold locks on, expose, or migrate anything that belongs to the other apps.

### Schemas

| Schema | Owner | Contents |
| --- | --- | --- |
| `lms` | this backend | All student-app tables, outbox, idempotency keys, audit |
| `lms_bridge` | this backend, human-approved | Read-only views over team-app tables (centres, courses, batches, faculty, attendance, instalments, receipts) |
| `lms_jobs` | pg-boss | Job queue tables |
| everything else | other apps | Never written by this backend |

### Roles and limits

```sql
-- run once by a human with admin rights (staging first, then prod)
CREATE ROLE lms_migrator LOGIN PASSWORD '...';            -- owns lms objects, used only by CI migrate job
CREATE ROLE lms_app LOGIN PASSWORD '...' CONNECTION LIMIT 30;
ALTER ROLE lms_app SET statement_timeout = '15s';
ALTER ROLE lms_app SET lock_timeout = '5s';
ALTER ROLE lms_app SET idle_in_transaction_session_timeout = '30s';
CREATE SCHEMA lms AUTHORIZATION lms_migrator;
CREATE SCHEMA lms_bridge AUTHORIZATION lms_migrator;
CREATE SCHEMA lms_jobs AUTHORIZATION lms_app;
GRANT USAGE ON SCHEMA lms, lms_bridge TO lms_app;
ALTER DEFAULT PRIVILEGES FOR ROLE lms_migrator IN SCHEMA lms
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO lms_app;
ALTER DEFAULT PRIVILEGES FOR ROLE lms_migrator IN SCHEMA lms_bridge
  GRANT SELECT ON TABLES TO lms_app;
REVOKE ALL ON SCHEMA lms, lms_bridge, lms_jobs FROM anon, authenticated, public;
```

- `lms_app` has **no** grants on `public` or any team-app schema. Bridge views run with the migrator's rights, so the app reads only the columns the views expose.
- Enable RLS on every `lms` table with no policies. This is defence in depth: even if someone later adds `lms` to Supabase's exposed API schemas, the anon and authenticated keys see nothing. Do **not** add these schemas to the Data API's exposed schemas.
- Connection pooling:
  - The API connects through Supabase's transaction pooler (port 6543) with prepared statements disabled and a pool of at most 10.
  - The worker uses a session or direct connection with a pool of at most 5.
- Confirm the Supabase project's region. Lightsail must run in the same AWS region (Mumbai, ap-south-1, if the project is there).

### Environments

| Env | Database | Data |
| --- | --- | --- |
| local | Postgres in Docker | Seed scripts and synthetic data |
| staging | A **separate** Supabase project (or branch) with a schema-only copy of the team-app tables the bridge reads | Synthetic data only |
| prod | The shared production project | Real data; no human or agent ad-hoc access through `lms_app` |

### Migrations

- Expand and contract only. Add a column or table, deploy code, backfill, then remove the old one in a later release. Never rename in place.
- Every migration sets `lock_timeout = '3s'`.
- Create indexes with `CONCURRENTLY` on big tables.
- Bridge views change only when the team app's schema changes, and only after that team agrees.
- Production migrations run from a GitHub Actions job with manual approval, after a fresh logical backup of `lms`.

### Resilience

At about 100 daily users, there is no hot standby. The risk is blast radius, not capacity.

- Turn on Supabase point-in-time recovery (paid add-on) for the whole project, since it protects all four apps.
- Take a nightly `pg_dump` of `lms` to S3, retained 30 days.
- Restore drill before launch, then every quarter. Record how long it took.
- Alert when `lms_app` connections exceed 80% of the limit, or when total database connections exceed 80% of the plan's maximum.
- Recovery target: rebuild the API on a fresh Lightsail service from the container image in 30 minutes or less.

## Domain modules and boundaries

There are fifteen modules. Each owns only its own tables. Anything that already lives in the team app is reached through the `integrations` module, never queried directly by a feature module.

| Module | Owns | Reads or calls |
| --- | --- | --- |
| identity | OTP challenges, sessions, refresh tokens, devices, integrity verdicts | students |
| students | Student account (phone → team-app admission/intake ID), profile mirror, onboarding progress | integrations |
| guardians | Guardian records, guardian OTP, parental consent records | students |
| kyc | KYC document metadata (S3 keys, masked number, status) | students, integrations |
| undertakings | Undertaking versions (clauses, video, contacts), acceptances, video watch completion, generated PDFs | students, bookings |
| catalog | Course enrichment: brand, domain, mode, duration, description, impact index (extends team-app courses by ID) | integrations (course list and base price) |
| pricing | Bundle discount rules, quotes, price snapshots | catalog |
| batches | Seat holds, capacity reads, late-join rules | integrations (batches), bookings |
| bookings | Bookings, booking items, state machine, hold expiry | pricing, batches, payments |
| payments | Razorpay orders, payment records, webhook inbox, reconciliation, reception payment requests | bookings, fees |
| fees | Fee plan choice, instalment schedule proposal; the team app's instalments stay the ledger of record | integrations |
| content | Videos, entitlements, view policies, playback sessions | students, integrations (enrolments) |
| live | Live sessions, room tokens, participation, recordings | integrations (batches, faculty), content |
| tickets | Student-facing ticket view and messages (stored in the team app's tickets if they exist) | integrations |
| notifications | Push tokens, inbox, templates, delivery log (WhatsApp / SMS through the existing provider) | all (through events) |

### The team app integration

The team app (scheduler.rvmcad.org) already runs a student intake and undertaking flow, with these endpoints:

- `POST /api/intakes`, `/api/intakes/{id}/files` and `/api/intakes/{id}/finalize`
- `/api/admissions/undertaking-otp/request` and `/verify`
- `PUT /api/admissions/{id}/undertaking`
- `GET /api/courses`, which returns `id`, `name` and `price` in whole rupees

**The student app must create the same intake and admission records, not a parallel student table.**

M0 must decide one of:

1. **Service-to-service (preferred).** This backend calls internal team-app endpoints with a service credential to create and update intakes and admissions, record undertakings and read batches, attendance and instalments.
2. **Shared tables with written ownership.** This backend writes specific team-app tables under a signed-off contract. It would need an exception to the agent rule against writing outside `lms`.

Until decided, the `integrations` module defines TypeScript interfaces (`TeamAppGateway`) with an in-memory fake for tests, so feature work isn't blocked.

## Data model (`lms` schema)

This is the starting DDL. The agent turns it into Drizzle schema plus a reviewed first migration.

Conventions:

- `id uuid primary key default gen_random_uuid()`
- `created_at` / `updated_at timestamptz not null default now()`
- Money is `bigint` paise.
- Team-app references are stored as plain `uuid` columns named `team_*_id`, with no foreign key across schemas.

```sql
-- identity
create table lms.student_accounts (
  id uuid primary key default gen_random_uuid(),
  phone_e164 text not null unique,
  team_admission_id uuid unique,          -- set once the team-app intake/admission exists
  status text not null default 'registering', -- registering|active|suspended|deletion_requested
  dob date, is_minor boolean,
  onboarding_step text not null default 'profile',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table lms.otp_challenges (id uuid primary key default gen_random_uuid(), phone_e164 text not null,
  purpose text not null, code_hash text not null, attempts int not null default 0,
  expires_at timestamptz not null, consumed_at timestamptz, created_at timestamptz not null default now());
create table lms.devices (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  device_key_pub text not null, platform text not null, model text, app_version text,
  integrity_verdict jsonb, is_active boolean not null default true, bound_at timestamptz not null default now(),
  revoked_at timestamptz, last_seen_at timestamptz);
create unique index one_active_device on lms.devices(student_id) where is_active;
create table lms.refresh_tokens (id uuid primary key default gen_random_uuid(), device_id uuid not null references lms.devices,
  token_hash text not null unique, family_id uuid not null, expires_at timestamptz not null, revoked_at timestamptz);

-- guardians and consent (DPDP)
create table lms.guardians (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  name text not null, relation text not null, phone_e164 text not null, verified_at timestamptz);
create table lms.consents (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  guardian_id uuid references lms.guardians, purpose text not null,  -- service|parental|promotional_use|analytics
  notice_version text not null, granted_at timestamptz not null, withdrawn_at timestamptz, evidence jsonb not null);

-- kyc
create table lms.kyc_documents (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  doc_type text not null default 'aadhaar', s3_keys text[] not null, number_last4 text not null,
  number_ciphertext bytea,                 -- only if the team app requires the full number; KMS-encrypted
  status text not null default 'submitted', reviewed_by text, reviewed_at timestamptz, created_at timestamptz not null default now());

-- undertakings
create table lms.undertaking_versions (id uuid primary key default gen_random_uuid(), version text not null unique,
  video_ref text not null, clauses jsonb not null, contacts jsonb not null, effective_from timestamptz not null);
create table lms.undertaking_acceptances (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  version_id uuid not null references lms.undertaking_versions, accepted_clause_ids text[] not null,
  optional_consents jsonb not null, video_completed_at timestamptz not null, accepted_at timestamptz not null default now(),
  device_id uuid references lms.devices, pdf_s3_key text, pdf_sha256 text);

-- catalog and pricing
create table lms.course_profiles (team_course_id uuid primary key, brand text not null, domain text, mode text not null, -- offline|online_live|recorded
  duration_weeks int, description text, impact jsonb, purchasable_in_app jsonb not null default '{"android":true,"ios":true}', is_listed boolean not null default true);
create table lms.bundle_rules (id uuid primary key default gen_random_uuid(), min_courses int not null, min_subtotal_paise bigint not null,
  discount_bps int not null, effective_from timestamptz not null, effective_to timestamptz);

-- bookings
create table lms.bookings (id uuid primary key default gen_random_uuid(), booking_ref text not null unique, student_id uuid not null references lms.student_accounts,
  status text not null, fee_plan text not null, -- one_time|three_instalments
  subtotal_paise bigint not null, discount_paise bigint not null, total_paise bigint not null, seat_fee_paise bigint not null default 99900,
  price_snapshot jsonb not null, hold_expires_at timestamptz, confirmed_at timestamptz, confirmed_via text,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table lms.booking_items (id uuid primary key default gen_random_uuid(), booking_id uuid not null references lms.bookings,
  team_course_id uuid not null, team_batch_id uuid not null, list_paise bigint not null, discount_paise bigint not null, net_paise bigint not null);
create table lms.seat_holds (team_batch_id uuid not null, booking_item_id uuid not null references lms.booking_items, status text not null, -- held|confirmed|released
  expires_at timestamptz, primary key (team_batch_id, booking_item_id));
create table lms.batch_capacity (team_batch_id uuid primary key, capacity int not null, version int not null default 0); -- row-locked during holds

-- payments
create table lms.payments (id uuid primary key default gen_random_uuid(), booking_id uuid references lms.bookings, purpose text not null, -- seat_fee|instalment
  provider text not null, provider_order_id text unique, provider_payment_id text unique, amount_paise bigint not null,
  status text not null, captured_at timestamptz, receipt_no text, recorded_by text, created_at timestamptz not null default now());
create table lms.webhook_inbox (id uuid primary key default gen_random_uuid(), provider text not null, provider_event_id text not null,
  payload jsonb not null, received_at timestamptz not null default now(), processed_at timestamptz, error text, unique (provider, provider_event_id));

-- content
create table lms.videos (id uuid primary key default gen_random_uuid(), team_course_id uuid not null, module text, title text not null,
  vdocipher_video_id text not null unique, duration_s int not null, published_at timestamptz);
create table lms.view_policies (id uuid primary key default gen_random_uuid(), scope text not null, scope_id uuid, max_views int not null default 1,
  count_after_pct int not null default 5, resume_window_min int not null default 60);
create table lms.entitlements (id uuid primary key default gen_random_uuid(), student_id uuid not null references lms.student_accounts,
  team_course_id uuid not null, source text not null, starts_at timestamptz not null, expires_at timestamptz);
create table lms.playback_sessions (id uuid primary key default gen_random_uuid(), student_id uuid not null, video_id uuid not null references lms.videos,
  device_id uuid not null references lms.devices, started_at timestamptz not null default now(), last_heartbeat_at timestamptz,
  position_s int not null default 0, max_position_s int not null default 0, counted boolean not null default false, ended_at timestamptz, end_reason text);
create table lms.view_counters (student_id uuid not null, video_id uuid not null references lms.videos, views_used int not null default 0,
  extra_views_granted int not null default 0, primary key (student_id, video_id));

-- live
create table lms.live_sessions (id uuid primary key default gen_random_uuid(), team_batch_id uuid not null, team_faculty_id uuid,
  scheduled_start timestamptz not null, scheduled_end timestamptz not null, provider_room_id text, status text not null,
  recording_status text, recording_video_id uuid references lms.videos);
create table lms.live_participation (live_session_id uuid not null references lms.live_sessions, student_id uuid not null,
  joined_at timestamptz not null, left_at timestamptz, primary key (live_session_id, student_id, joined_at));

-- platform
create table lms.outbox (id bigserial primary key, aggregate text not null, aggregate_id uuid not null, type text not null,
  payload jsonb not null, created_at timestamptz not null default now(), published_at timestamptz, attempts int not null default 0);
create table lms.idempotency_keys (key text not null, student_id uuid, route text not null, request_hash text not null,
  response jsonb, status int, created_at timestamptz not null default now(), primary key (key, route));
create table lms.audit_log (id bigserial primary key, actor text not null, action text not null, entity text not null, entity_id text,
  summary jsonb, request_id text, at timestamptz not null default now());
create table lms.notifications (id uuid primary key default gen_random_uuid(), student_id uuid not null, kind text not null,
  title text not null, body text not null, deep_link text, read_at timestamptz, created_at timestamptz not null default now());
create table lms.push_tokens (device_id uuid primary key references lms.devices, fcm_token text not null, updated_at timestamptz not null default now());
```

The team app's course price is in whole rupees. The integrations gateway converts it to paise (×100) at the boundary. No other module ever sees rupees.

## State machines and invariants

These rules are where money and trust live. Each transition is a single transaction that also writes its outbox event. Any transition not listed is rejected with `409`.

### Booking

| From | Event | To | Side effects |
| --- | --- | --- | --- |
| (none) | `POST /bookings` | `held` | Lock each `batch_capacity` row (`SELECT ... FOR UPDATE`, in batch-ID order to avoid deadlocks), check holds + confirmed < capacity, insert seat holds with `expires_at = now() + hold_minutes` |
| `held` | Razorpay order created | `payment_processing` | Extend the hold to cover the checkout window |
| `held` | Pay at reception chosen | `awaiting_reception` | Hold extends until the next receipt run plus grace (config, default 7 PM IST next working day + 2 h); create the reception request in the team app |
| `payment_processing` | Webhook `payment.captured` (amount and order match) | `confirmed` | Seats become confirmed; create the enrolment and admission in the team app; propose the instalment schedule; queue PDF generation; notify |
| `awaiting_reception` | Team app records a receipt for the `booking_ref` | `confirmed` | Same as above, with `confirmed_via = reception` |
| `held` / `awaiting_reception` / `payment_processing` | Hold expiry job | `expired` | Release seats; notify. If a capture later arrives for an expired booking, flag it for manual refund or rebooking. Never silently confirm over capacity. |
| `held` / `awaiting_reception` | Student cancels | `cancelled` | Release seats |

**Booking invariants**

- Confirmed seats for a batch never exceed its capacity. Write a database check function plus a test that runs 50 concurrent bookings for the last seat.
- `total = subtotal - discount`, and the sum of item `net` values equals `total`. The ₹999 seat fee is part of `total`, never added on top.
- A booking's price snapshot never changes after `held`. Requotes create a new booking.
- One active (`held`, `awaiting_reception` or `payment_processing`) booking per student at a time.

### Payment

- Orders are created on the server only, with the amount taken from the booking.
- Webhook handling:
  1. Verify the HMAC signature on the raw body.
  2. Insert into `webhook_inbox`. A unique `(provider, provider_event_id)` makes duplicates no-ops.
  3. Acknowledge with `200` immediately.
  4. Process asynchronously in the worker.
- The client's success callback is only a hint. The confirmation comes from the webhook, or from the reconciliation job that fetches the order status.
- Nightly reconciliation compares Razorpay payments and settlements for the day against `lms.payments`. Mismatches go to an alert and an exception list.

### Playback (single view)

- `POST /playback/sessions` succeeds only if all of these hold:
  - The student is entitled and within `expires_at`.
  - `views_used < max_views + extra_views_granted`.
  - The request comes from the active bound device with a fresh integrity verdict.
  - No other open session exists for this student.
- A view is counted (`views_used += 1`, `counted = true`) the first time `max_position_s` passes `count_after_pct` of the duration. Opening the player alone never costs a view.
- After a crash, a session can resume within `resume_window_min` of its last heartbeat without counting a new view. After that, the session is closed.
- The server returns `stop` on a heartbeat if the device is revoked, the entitlement expires, or a second device starts.
- VdoCipher OTPs are requested per session with a short TTL and are never reused.

## API surface v1

All routes are under `/v1` and use JSON over HTTPS.

- Auth is `Authorization: Bearer <access JWT>` (15 minutes); refresh tokens last 30 days and rotate on use.
- Every route is defined with Zod and shows up in `openapi.yaml`.
- Mutating routes require `Idempotency-Key`.
- Errors use the shape `{ code, message, details, request_id }`.

| Area | Endpoints |
| --- | --- |
| Config | `GET /config` (min/latest version, flags, policy numbers, `analytics_allowed`) |
| Auth | `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh`, `POST /auth/logout`, `POST /auth/device/rebind` |
| Onboarding | `GET /me/onboarding`, `POST /me/profile`, `GET /me` |
| Guardian | `POST /me/guardian`, `POST /me/guardian/verify` |
| KYC | `POST /me/kyc/upload-url`, `POST /me/kyc/complete` |
| Undertaking | `GET /undertakings/current`, `POST /undertakings/video/heartbeat`, `POST /undertakings/accept`, `GET /me/undertaking.pdf` |
| Catalog and pricing | `GET /courses`, `GET /courses/{id}`, `POST /pricing/quote` |
| Batches | `GET /batches?course_id=&centre_id=&schedule=` |
| Bookings | `POST /bookings`, `GET /bookings/{id}`, `POST /bookings/{id}/razorpay-order`, `POST /bookings/{id}/pay-at-reception`, `POST /bookings/{id}/cancel` |
| Student core | `GET /me/dashboard`, `GET /me/enrolments`, `GET /me/timetable`, `GET /me/attendance`, `POST /me/attendance/corrections`, `GET /me/fees`, `POST /me/instalments/{id}/razorpay-order`, `GET /me/receipts/{id}.pdf` |
| Tickets | `GET /me/tickets`, `POST /me/tickets`, `GET /me/tickets/{id}`, `POST /me/tickets/{id}/messages`, `POST /me/tickets/{id}/reopen` |
| Notifications | `GET /me/notifications`, `POST /me/notifications/{id}/read`, `PUT /me/push-token` |
| Devices and account | `GET /me/devices`, `DELETE /me/devices/{id}`, `POST /me/deletion-request` |
| Content | `GET /me/library`, `POST /playback/sessions`, `POST /playback/sessions/{id}/heartbeat`, `POST /playback/sessions/{id}/end` |
| Live | `GET /me/live-sessions`, `POST /live-sessions/{id}/join`, `POST /live-sessions/{id}/doubts` |
| Webhooks | `POST /webhooks/razorpay`, `POST /webhooks/live/{provider}`, `POST /webhooks/vdocipher` (signature-verified, no JWT) |
| Internal (team app to this API) | `POST /internal/reception-receipts` (`booking_ref`, receipt number, amount, recorded by), `POST /internal/students/{id}/extra-views`, `POST /internal/live-sessions` (schedule a class), using a service token plus an IP allow-list |
| Ops | `GET /health` (liveness), `GET /ready` (database and pg-boss check) |

**Rate limits:** OTP requests are limited to 3 per phone per 15 minutes and 10 per IP per hour, other authenticated routes to 60 per minute per student, and webhooks are unlimited but signature-checked. Return `429` with `retry_after`.

**Versioning:** additive changes stay in v1. A breaking change needs a new path, and the old one stays until `min_supported_version` has moved past every app that uses it.

## Integrations

Every external system sits behind an interface in `modules/integrations` with a fake implementation for tests. Each vendor gets its own test or sandbox credentials per environment.

| System | Use | Key rules |
| --- | --- | --- |
| Team app (scheduler.rvmcad.org) | Intakes and admissions, undertaking record, courses, batches, attendance, instalments and receipts, tickets | Contract decided in M0; per-call timeout 5 s; retries with backoff only on idempotent calls; circuit breaker so team-app downtime degrades the student app to cached read data instead of erroring everywhere |
| Razorpay | Seat fee and instalment payments | Orders on the server; HMAC webhook verification on the raw body; `payment.captured`, `payment.failed`, `refund.*`; nightly reconciliation; the jobs portal's Razorpay path has never processed a real payment, so prove this one end to end in test mode first |
| VdoCipher | Recorded videos, the undertaking video, live recordings | Per-session OTP + `playbackInfo` with watermark annotation (name, phone last 4, student ID); upload through their API from the worker; webhook for processing status |
| Live video (100ms or Agora: Open) | Live rooms, join tokens, server recording, join/leave webhooks | Join tokens scoped to one room and role, expiring at session end + 15 min; recording goes to S3, then to VdoCipher, then to `lms.videos` |
| OTP and messaging | Login OTP, guardian OTP, transactional notifications | Use the existing WhatsApp provider (Gallabox) and a DLT-registered SMS route as fallback; templates pre-approved; never send amounts or complaint details |
| Push | FCM (Android and iOS through APNs) | Data and notification messages with deep links; generic text only |
| S3 (ap-south-1) | KYC images, ticket attachments, undertaking PDFs, live recordings | Private bucket, SSE-KMS, presigned PUT (5 min) and GET (2 min) URLs, content-type and size checked, malware scan before KYC is marked reviewed |
| CRM (NeoDove) | Leads for abandoned registrations and holds | Adults only; minors only through the guardian with consent; through outbox events, never inline |

**Course catalogue mismatch.** The team app's `/api/courses` prices differ from the website's pricing page, for example SolidWorks ₹18,000 there versus ₹15,500 on the website. Before pricing ships, management must name **one** price source. The backend reads only that source.

## Events, outbox and background jobs

Side effects never run inline in a request. The request commits its state change and an `lms.outbox` row together. The worker then publishes each row to pg-boss queues, and handlers do the work idempotently, keyed by the outbox ID.

**Core events:**

- `StudentRegistered`
- `GuardianConsentGranted`
- `KycSubmitted`
- `UndertakingAccepted`
- `BookingHeld`
- `BookingAwaitingReception`
- `BookingConfirmed`
- `BookingExpired`
- `PaymentCaptured`
- `PaymentMismatch`
- `InstalmentDue`
- `ViewConsumed`
- `LiveSessionEnded`
- `RecordingPublished`
- `TicketUpdated`
- `DeviceRebound`

| Job | Schedule | Does |
| --- | --- | --- |
| outbox-relay | Every 2 s | Publishes unpublished outbox rows to queues; retries with backoff, dead-letter after 10 attempts with an alert |
| expire-holds | Every minute | Expires `held` / `awaiting_reception` bookings past `hold_expires_at`, releases seats |
| razorpay-reconcile | 01:30 IST daily | Compares the previous day's Razorpay payments with `lms.payments`; flags mismatches |
| confirm-stuck-payments | Every 5 min | Fetches the order status for bookings in `payment_processing` for more than 5 min |
| close-stale-playback | Every 5 min | Closes sessions whose last heartbeat is older than the resume window |
| team-app-sync | Every 10 min | Refreshes cached reads (courses, batches, timetable) used when the team app is unreachable |
| instalment-reminders | 09:00 IST daily | Due-soon and overdue reminders, respecting consent and quiet hours |
| undertaking-pdf | On `BookingConfirmed` | Renders the undertaking PDF on the server (student details, accepted clause text and version, courses, batch, joining date, fee), stores it in S3 with a SHA-256 hash |
| backup-lms | 02:00 IST daily | `pg_dump --schema=lms`, uploaded to S3 with 30-day retention |
| purge-retention | Weekly | Deletes expired OTPs, consumed idempotency keys older than 7 days, and data past its retention window |

All times in this table are IST. Store them as UTC in cron, with `CRON_TZ` documented.

## Security, privacy and DPDP

The app holds Aadhaar images, minors' data and payment records. Least privilege and data minimisation are built in from the first migration, not added later. Have a lawyer confirm the DPDP specifics before launch.

**Authentication and authorisation**

- OTP:
  - 6 digits, 5-minute expiry, at most 5 attempts.
  - Stored as a hash.
  - Resend cooldown, and lockout after repeated failures.
- JWTs are signed with an asymmetric key (EdDSA) and include `sub`, `device_id` and `sv` (session version).
- Refresh tokens rotate. Reuse of an old token revokes the whole family.
- Every query for student data filters by `student_id` from the token. Never trust an ID from the path alone. Integration tests must prove that student A gets `404` on student B's booking, ticket, receipt, KYC and playback session.
- Internal and team-app routes use a separate service token plus an IP allow-list, and are logged in `audit_log`.

**Data handling**

- **Aadhaar:**
  - Store the images in S3 (SSE-KMS) and keep only the last 4 digits in the database.
  - Store the full number encrypted only if the team app genuinely needs it.
  - Mask it everywhere else. Never write it to logs, events or analytics.
- **Minors:**
  - Verified guardian consent is recorded before KYC or any booking.
  - No behavioural analytics.
  - CRM or marketing goes only to the guardian, with consent.
  - `GET /config` returns `analytics_allowed = false` for minors.
- **Undertaking consents:** the existing form bundles "consent to use my work for promotional purposes" with mandatory clauses. In this system, store promotional use as a separate, optional `consents` row that can be withdrawn. Mandatory clauses are recorded with the exact version text that was shown.
- **Logging:** pino redaction paths for phone, Aadhaar, OTP, tokens, names and addresses. Sentry `beforeSend` scrubs the same fields.
- **Retention (proposal, needs approval):**
  - OTPs: 24 hours
  - Abandoned registrations without a booking: 180 days
  - KYC images: course end plus 3 years
  - Audit log: 7 years
  - Playback heartbeats: aggregated after 90 days
- **Breach response:** a runbook with an owner and a 72-hour notification path to the Data Protection Board, and to affected users where required.

**Abuse controls**

- OTP rate limits per phone and per IP, plus a daily SMS and WhatsApp spend alarm.
- Only one active booking per student.
- Booking creation is rate-limited.
- Integrity verdicts are required for playback and live join.

## Testing, CI/CD, deployment and observability

One Docker image runs as two containers, `api` and `worker`, on a Lightsail container service in the same region as the Supabase project. GitHub Actions builds, tests and deploys it. Production deploys and migrations need a manual approval.

**Tests**

- **Unit tests** (Vitest) for pricing, the booking state machine, view counting and fee schedules. These carry the money logic, so aim for at least 90% branch coverage there.
- **Integration tests** with Testcontainers Postgres for every route, covering:
  - auth and isolation (the 404 matrix)
  - idempotent retries
  - webhook duplicates
  - 50 concurrent bookings for the last seat
  - hold expiry
  - crash and resume during playback
- **Contract tests:** the OpenAPI spec must match the routes; vendor fakes must match recorded sandbox responses.
- **Staging smoke test after every deploy:** OTP (test number), quote, booking, Razorpay test payment, webhook confirmation.

**Workflows (`.github/workflows`)**

1. `api-ci.yml` (pull requests touching `apps/api` or `packages/openapi`): install, lint, typecheck, unit and integration tests, OpenAPI drift check, migration lint (no unsafe locks, nothing outside the `lms` schemas).
2. `api-deploy.yml` (push to `main`):
   1. Build the image tagged with the git SHA, then `aws lightsail push-container-image`.
   2. Run migrations against staging.
   3. Deploy to the staging container service, then run the smoke test.
   4. Wait for **manual approval**.
   5. Back up `lms`, migrate production, then deploy production with `create-container-service-deployment` (health check `/health`).
3. Rollback: redeploy the previous image tag. Migrations are expand-only, so older code keeps working.

Secrets live in GitHub Environments (`staging`, `production`) with required reviewers on production, and are passed as container environment variables. Use OIDC to AWS with a deploy role limited to Lightsail and the backup bucket, instead of long-lived keys.

**Lightsail sizing:** start with the smallest plan that gives 1 GB of memory for both containers, scale 1 to 2 nodes. Resource usage is currently under 20%, so scale only when sustained CPU stays above 60% or p95 latency stays above 500 ms.

**Observability**

- Sentry for errors and performance, in both the API and the worker.
- Structured pino logs shipped to a log service (Better Stack or Axiom), with `request_id` correlated from the app.
- An uptime monitor on `/ready` every minute, alerting by WhatsApp or SMS.
- Alerts on:
  - 5xx rate above 1% for 5 minutes
  - webhook processing lag above 5 minutes
  - outbox backlog above 500
  - `lms_app` connections above 80% of the limit
  - a reconciliation mismatch
  - failed backup jobs

## Build plan for the agent

Give the agent one milestone at a time. It reports at the end of each with raw test output, the migration SQL and any spec conflicts. Don't start the next milestone until those are reviewed.

### M0: Foundation and discovery (start here)

- [ ] Scaffold the monorepo (pnpm, Turborepo, `apps/api`, `packages/openapi`, `infra/`), TypeScript strict, ESLint, Prettier, Vitest, a Dockerfile with a non-root user, and both entrypoints (`server.ts`, `worker.ts`).
- [ ] Platform layer:
  - config loading with Zod-validated environment variables (fail fast)
  - Drizzle pool with `prepare: false` for the transaction pooler
  - error shape and request ID
  - pino with redaction
  - Sentry
  - idempotency middleware
  - outbox writer and relay
  - pg-boss setup
  - `/health` and `/ready`
- [ ] **Read-only schema discovery on the staging copy:** list every schema and table that the team app, jobs portal and ops app use. Show the columns of courses, batches, branches, intakes, admissions, attendance, instalments, receipts and tickets. Write `docs/team-app-schema.md`. Make no writes.
- [ ] Write the first migration (roles excluded; a human runs those) creating the `lms` tables from the data-model section, with RLS enabled and no policies. Write a down migration.
- [ ] `TeamAppGateway` interface plus an in-memory fake, with methods for intake create/update, courses, batches, enrolment create, reception receipt lookup, attendance, instalments and tickets.
- [ ] CI workflow `api-ci.yml` green; `api-deploy.yml` deploying to staging Lightsail.
- [ ] Report: the discovered schema, a recommended integration option (service-to-service vs shared tables) with evidence, and any conflicts with this spec.

### Later milestones

| # | Milestone | Done when |
| --- | --- | --- |
| M1 | Identity and onboarding: OTP, devices, JWT and refresh, profile, guardian consent, KYC upload, undertaking (video watch tracking, clause acceptance) | Isolation tests pass; a minor cannot reach KYC or booking without guardian consent; undertaking acceptance is linked to a team-app intake |
| M2 | Catalogue, pricing and batches: course profiles, bundle rules, quote, batch window (-7 / +14 days), clash detection | Quotes match the bundle tiers in property-based tests; the batch list matches the team app |
| M3 | Bookings and payments: holds, both payment paths, webhooks, reception receipts, expiry, reconciliation, enrolment creation in the team app, undertaking PDF | The last-seat concurrency test passes; duplicate webhooks are no-ops; staging end to end in Razorpay test mode |
| M4 | Student core: dashboard, timetable, attendance and corrections, fees and instalment payments, tickets, notifications, push, deletion request | Works with the team app unavailable (served from cache, clearly marked) |
| M5 | Content: VdoCipher upload, entitlements, playback sessions, view counting, extra-view grants | Single-view rules proven by tests, including crash and resume and a second-device takeover |
| M6 | Live: vendor integration, scheduling from the team app, join tokens, participation into attendance, recording pipeline | A one-hour staging class with recording published to the library |
| M7 | Hardening: load test (5x the expected peak), restore drill, security review, runbooks | Restore time recorded; no high-severity findings open |

**First message to give the agent:** "Read `AGENTS.md` and `docs/backend-spec.md`. Do M0 only. Begin with read-only schema discovery against staging and report before writing any migration."

## Open decisions and assumptions

The build proceeds on the assumptions below. Each open decision is isolated behind config or the gateway interface, so changing it later is cheap.

**Assumptions in force**

- "Lightsail" means an AWS Lightsail container service, in the same region as the Supabase project.
- The student app is mobile-only. Faculty and staff use the team app; there is no new staff web portal.
- The ₹999 seat fee is included in the course fee, non-refundable, and charged once per booking regardless of how many courses it holds.
- Aadhaar and the undertaking are collected at first registration, matching the existing form. For minors, this happens after guardian consent.
- Batch window: started up to 7 days ago, through 14 days ahead.
- Reception receipts are recorded in the team app, around 7 PM daily.
- Live classes are recorded by RVM on the server. Students can never record.

**Open decisions**

- [ ] Team-app integration: service-to-service calls vs shared tables (decided at the end of M0).
- [ ] Single price source: the team app's course prices vs the website's pricing page (they currently disagree).
- [ ] Whether online and recorded courses can be bought inside the iOS app (App Store in-app purchase rules). This is the `purchasable_in_app` flag.
- [ ] The 3-instalment schedule: amounts and due dates relative to joining.
- [ ] Hold duration for pay-now (proposed 15 min) and the reception grace window.
- [ ] Views per recorded video, count threshold, resume window, and access duration after the course ends.
- [ ] Live video vendor (100ms or Agora), after the low-bandwidth trial.
- [ ] Whether the team app needs the full Aadhaar number, or only the last 4 digits plus the image.
- [ ] Legal review of the undertaking clauses (separate promotional consent, refund wording) and of the retention schedule.
- [ ] Supabase point-in-time recovery add-on enabled, and who owns the shared database's backups across all four apps.

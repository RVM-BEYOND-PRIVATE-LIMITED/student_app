# team-app schema discovery (M0 — static from code, live staging verification pending secrets)

> Status: STATIC ONLY — extracted from `Scheduler_Backend/supabase/migrations/20251215134244_remote_schema.sql`,
> `20260514000000_schema_gaps.sql`, `schema.sql` + route/controller code. NO DB connection made (no secrets yet).
> Live staging verification still required once `DATABASE_URL` (staging) is provided. Make NO writes.
> Pending: `SELECT schema_name FROM information_schema.schemata`, row counts, RLS policies, views.

## Schemas found (code-static)

- `public` — all team-app tables (operations web app + team app share it).
- `lms` — this backend (new, migration `0000_init_lms.sql`).
- `lms_bridge` — planned read-only views (not created yet; needs human approval).
- `lms_jobs` — pg-boss (not created yet; `pg-boss` creates on first start).

## Tables (public, from remote_schema + gaps)

activities, admin_notifications, admission_courses, admission_intakes, admissions,
announcements, application_chats, batch_students, batches, books, certificates,
chat_read_status, configuration, course_books, courses, faculty, faculty_availability,
faculty_skills, fee_installments, follow_ups, general_chats, installments, job_applications,
job_course_eligibility, jobs, locations, messages, payment_adjustments, payments,
receipt_installments, receipts, skills, student_attendance, students, system_settings,
tickets, users (+ HRMS/org/inventory/cert/email tables from later migrations — see migration list).

No `branches`/`centres` table — branches are `public.locations (id INTEGER PK, name TEXT)`.
No `intakes` table — intake flow is `public.admission_intakes` (see below).
Jobs portal tables: `jobs, job_applications, job_course_eligibility` (same DB, shared Postgres).

## Columns (key tables)

### courses (`GET /api/courses` returns id, name, price in whole rupees)
- id UUID PK, name TEXT UNIQUE NOT NULL, price NUMERIC(10,2) >= 0, created_at TIMESTAMPTZ
- Note: website pricing page disagrees (e.g. SolidWorks 18,000 vs 15,500). Open decision: single price source required. Gateway converts rupees×100 → paise at boundary.

### batches
- id UUID PK, name TEXT UNIQUE, description TEXT, start_date DATE, end_date DATE,
  start_time TIME, end_time TIME, faculty_id → faculty(id), skill_id → skills(id),
  max_students INT, status TEXT (Upcoming/Active/Completed), days_of_week TEXT[], created_at
- Spec batch window: started ≤7 days ago through +14 days. Clash detection on days_of_week + time overlap (to implement in batches module).

### branches/centres → locations
- id INTEGER PK, name TEXT NOT NULL (gap migration `20260514000000_schema_gaps.sql`).
- `users.location_id`, `admission_intakes.location_id BIGINT` reference it (loose FK).

### intakes → admission_intakes (+ files + finalize flow)
- id UUID PK, student_name/phone, father_name/phone, email, date_of_birth, date_of_joining,
  identification_type/number/files JSONB, course_ids UUID[], fee_amount NUMERIC,
  video_completed BOOL, contacts_acknowledged BOOL, terms_accepted BOOL,
  status TEXT default 'submitted', admission_id UUID, current/permanent_address TEXT, location_id BIGINT
- Team-app endpoints (spec § integration, verified in `Scheduler_Backend/server.js`):
  `POST /api/intakes`, `/api/intakes/{id}/files`, `/api/intakes/{id}/finalize`,
  `/api/admissions/undertaking-otp/request|verify`, `PUT /api/admissions/{id}/undertaking`.

### admissions (+ admission_courses junction)
- admissions: id UUID PK, student_id → students(id) CASCADE, certificate_id → certificates,
  total_fees NUMERIC, discount NUMERIC, final_fees NUMERIC, created_at
- admission_courses: (admission_id, course_id) PK, both CASCADE.

### attendance → student_attendance
- id UUID PK, student_id → students CASCADE, batch_id → batches CASCADE, date DATE,
  is_present BOOL, UNIQUE(batch_id, student_id, date).

### instalments → installments + fee_installments (duplicate legacy pair)
- installments: id UUID PK, admission_id → admissions CASCADE, due_date DATE, amount_due NUMERIC
- fee_installments: same shape. Receipts link via `receipt_installments(receipt_id, installment_id → fee_installments, amount_applied)`.
- Open: which is ledger of record? Spec says team-app instalments stay ledger of record; service proposes schedule. Needs M0 decision.

### receipts (+ receipt_installments) + payments
- receipts: id UUID PK, admission_id CASCADE, receipt_number TEXT UNIQUE, amount_paid NUMERIC,
  payment_date DATE, payment_method TEXT, generated_by → users(id)
- payments (remote_schema): exists — full columns pending live verification (file parse hit multi-line edge; verify on staging).
- Reception receipts recorded ~7PM daily (spec assumption). Internal endpoint `POST /internal/reception-receipts` will poll/map this.

### tickets
- id UUID PK, title/description TEXT NOT NULL, status ticket_status default 'Open',
  priority ticket_priority default 'Low', category TEXT, student_id → students NULL ON DELETE SET NULL,
  assignee_id → users NULL, created_at/updated_at.

### students / users / faculty / batch_students
- students: id UUID PK, name, phone_number UNIQUE, admission_number UNIQUE, father_name/phone, addresses, address_proof_id_number, remarks
- users: id UUID PK, username/phone UNIQUE, password_hash, role user_role, faculty_id → faculty NULL, password_changed_at (auth invalidation — ported)
- faculty: id UUID PK, name, email UNIQUE, phone, employment_type, is_active
- batch_students: (batch_id, student_id) PK — enrolment source of truth until M3 bridge decides.

## Recommendation (service-to-service vs shared tables) — STATIC, pending staging proof

**Recommended: service-to-service (spec option 1), with `TeamAppGateway` interface as seam.**

Evidence from code:
1. Team app already exposes the exact operations spec needs as HTTP (`/api/intakes*`, `/api/admissions/undertaking-*`, `GET /api/courses`), with auth + role guards (`routes/courseRoutes.js` public reads, admin writes; `middleware/auth.js` 401-vs-503 split). Reusing HTTP keeps the agent rule "never write outside lms*" intact — no exception needed.
2. Shared-tables would require an exception to AGENTS.md hard rule 1 (no writes outside `lms*`) for `admission_intakes/admissions/batch_students/receipts`, plus cross-schema FKs (spec forbids FK across schemas; team tables use `NUMERIC` money vs `bigint` paise — type mismatch at boundary).
3. Price-boundary evidence: team `courses.price NUMERIC` rupees vs `lms` `bigint` paise. Gateway `rupeesToPaise()` isolates this; direct table writes would leak rupee math into booking invariants.
4. Blast-radius: team app has 100+ migrations touching these tables (HRMS, inventory, certs). Bridge views (`lms_bridge`) give read containment; writes stay behind versioned team-app endpoints with 5s timeout + circuit breaker (spec § integrations).

**Needed to confirm once secrets land (staging, read-only):**
`SELECT table_schema, count(*) GROUP BY schema;` row counts for above tables; `GET /api/courses` sample vs DB `courses.price`; intake finalize side effects; `installments` vs `fee_installments` which is live; RLS/policies on team tables; Supabase region (for Lightsail co-location).

## Spec conflicts / open (STOP list per AGENTS.md rule 9)

1. `payments` DDL in remote_schema needs live column dump (parser missed multi-line block) — blocks M3 webhook mapping until verified.
2. Single price source (team `courses.price` vs website) — needs management decision before M2.
3. `installments` vs `fee_installments` duplicate — needs team-app owner to name ledger of record before M3/M4.
4. Batch capacity: team `batches.max_students INT` (nullable, no version col) vs spec `lms.batch_capacity(version)` row-locking — M3 must decide source of truth (propose: team max_students is display; lms.batch_capacity is hold enforcement with sync job).

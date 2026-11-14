# Archived: the M0 backend scaffold (28 October 2026). NOT USED.

This folder is kept for reference only. Nothing here is built, tested, deployed or run.

- The Student API is built inside the Scheduler backend (decision of 12 November 2026: one
  backend). It is not built in this repository.
- `api/migrations/0000_init_lms.sql` was never applied to any database. Do not apply it.
- The scaffold was never deployed.

## Do not copy these defects

- The payment webhook falls back to a fixed test secret and computes its signature over
  re-serialised JSON instead of the raw body.
- The service-token comparison is not constant-time.
- `trustProxy: true` with rate limits keyed on the first `X-Forwarded-For` entry, so a forged
  header bypasses the limits.

`docs/` holds the scaffold's own specification and schema notes. They describe a design that
was replaced; the published contract in `packages/openapi` is what the apps are built against.

Deleting this folder is student_app #17 and needs Prakash's OK.

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

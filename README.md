# RVM Student App — Backend (M0 scaffold)

Spec: `docs/backend-spec.md`. Rules: `AGENTS.md`.

Monorepo (`pnpm` + `turbo`):
- `apps/api` — Fastify TypeScript API + worker (single image, two processes)
- `packages/openapi` — generated `openapi.yaml` (Zod is source of truth)
- `infra/docker`, `infra/lightsail` — container + deploy
- `mobile/` — Flutter placeholder (separate tooling)

Patterns ported from `Scheduler_Backend` (Express): trust-proxy=1, 401-vs-503 auth,
`stripSecrets`, `auditContext`, JSON 404 for unknown `/v1/*`, in-process pg-boss worker.

## Quickstart (staging only — never prod DB from dev)

```bash
pnpm install
cp .env.example .env   # fill staging values
pnpm dev
pnpm test
pnpm lint
pnpm typecheck
pnpm openapi:build
pnpm db:migrate        # staging only
```

M0 entry: read `AGENTS.md` + `docs/backend-spec.md`. Do M0 only. Begin with
read-only schema discovery against staging and report before any migration.

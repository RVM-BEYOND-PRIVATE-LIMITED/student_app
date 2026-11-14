# RVM Student app

> **The backend scaffold in this repository is NOT used.** The Student API is built inside the
> Scheduler backend (decision of 12 November 2026: one backend). This repository holds the
> Flutter app, the web version and the published API contract. The old scaffold is kept for
> reference under `archive/m0-scaffold/`; nothing there is built, deployed or run.

| Folder | What it is |
|---|---|
| `mobile/` | The RVM Student app: Flutter, Android only, English and Hindi. Start with `mobile/README.md`. |
| `apps/` | The student web version will live in `apps/web` (not started). |
| `packages/openapi/` | The Student API contract the apps are built against: a copy of the backend's contract. See its README. |
| `archive/m0-scaffold/` | The 28 October backend scaffold. Not used. |

## Branches

Work goes into `develop` by pull request. `main` takes pull requests only from `develop` or a
`hotfix/*` branch (`promotion-guard`).

## Checks

- `mobile-ci`: every pull request that touches `mobile/`.
- `contract-ci`: every pull request that touches `packages/openapi/`.

No workflow here deploys anything, and none needs a secret.

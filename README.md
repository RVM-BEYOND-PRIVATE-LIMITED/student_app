# RVM Student app

> **This repository holds no backend.** The Student API is built inside the Scheduler backend
> (decision of 12 November 2026: one backend). This repository holds the Flutter app, the web
> version and the published API contract. The 28 October backend scaffold was removed on
> 16 Nov 2026 (student_app #17); it is in the history before that date, and nothing from it was used.

| Folder | What it is |
|---|---|
| `mobile/` | The RVM Student app: Flutter, Android only, English and Hindi. Start with `mobile/README.md`. |
| `apps/web` | The student web version for iPhone and laptop users (student_app #7). |
| `packages/openapi/` | The Student API contract the apps are built against: a copy of the backend's contract. See its README. |

## Branches

Work goes into `develop` by pull request. `main` takes pull requests only from `develop` or a
`hotfix/*` branch (`promotion-guard`).

## Checks

- `mobile-ci`: every pull request that touches `mobile/`.
- `contract-ci`: every pull request that touches `packages/openapi/`.

No workflow here deploys anything, and none needs a secret.

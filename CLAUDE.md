# CLAUDE.md: RVM Student app repository

This repository holds the Flutter student app (`mobile/`), the student web version (`apps/web`,
not started) and the published Student API contract (`packages/openapi`). **It holds no
backend.** The Student API is built in the backend repository, and backend rules live there.

## Hard rules (never break)
1. Do not build, run, deploy or copy from `archive/m0-scaffold/`. It is a replaced design, kept
   for reference. Never apply its migration to any database.
2. Never connect to any RVM database from this repository. Nothing here needs one.
3. The contract in `packages/openapi/openapi.yaml` is a copy of the backend's. Never edit it to
   lead the backend: a change arrives as a publish from the backend repository, with a version
   bump and the source commit.
4. Build the app against the published contract and its mock server, never against guesses.
5. No secrets in code, logs, fixtures or workflow output. Signing keys and store credentials are
   never kept here. Never log a phone number, an ID number, a token or a full name.
6. Money is integer paise. The app never computes a price; it shows what the API returns.
7. Android only. `mobile/` has no iOS, web or desktop target (`mobile/tool/android_only.sh`).
8. Investigate before you change anything. Paste raw command output when reporting.
9. When something is ambiguous or conflicts with what you find, stop and ask.

## Branches
Pull requests go into `develop`. `main` takes pull requests only from `develop` or `hotfix/*`.

## Commands
- App: see `mobile/README.md` (Flutter 3.35.7 exactly).
- Contract: `npx @redocly/cli@1.34.5 lint --config packages/openapi/redocly.yaml packages/openapi/openapi.yaml`,
  `node packages/openapi/tools/check-contract.mjs`, `node --test packages/openapi/tools/check-contract.test.mjs`.

## Definition of done
The checks for what you touched are green (`mobile-ci`, `contract-ci`), and nothing from the
archive was reused.

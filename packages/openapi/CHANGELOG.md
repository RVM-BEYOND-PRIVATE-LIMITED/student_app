# Contract changelog

Additive changes stay in v1: new paths, new optional fields, new enum values the app already
tolerates. A breaking change is never made in place: it gets a new path and a raised minimum
app version, and the old path keeps working until that version is enforced.

## 0.6.0 (15 Nov 2026)

The student's theme, from Scheduler_Backend #450 (commit 0cccfc7). Adds `GET` and `PUT
/v1/me/preferences` with `ThemePreference` and `ThemeChoice`, reachable before onboarding is
finished. The response says whether the `theme` switch is open to the student; while it is closed
the reply is `light` / `false`. This copy carries the `/v1` surface the app has implemented;
later Stage 3 paths are published when the app reaches them.

## 0.5.0 (14 Nov 2026)

All of Stage 1A is live (Scheduler_Backend #160 to #162, commit 5ef5ad5). The last `planned` routes move to `x-status: live`: branches, linking, the admission and fee plan, consent texts and choices, the age tick, Jobs access, the Campus hand-off, placement prompts and consent requests. The contract adds the onboarding and stage error rules and the `ConsentConflict`/`AnswerConflict` replies; paths and schemas are otherwise unchanged, so the app client needs no change. Versions 0.3.0 and 0.4.0 were published between this copy and the backend's; this file records the copy at 0.5.0.

## 0.2.0 (14 Nov 2026)

Sign-in is live (Scheduler_Backend #159, commit 31ad01e). The six sign-in routes (`/v1/auth/otp/request`, `/otp/resend`, `/otp/verify`, `/v1/auth/refresh`, `/v1/auth/logout`) move to `x-status: live`, with their error replies tightened. Paths and schemas are otherwise unchanged, so the app client needs no change. Linking, consents, the age tick, Jobs access, the hand-off and the prompts are still `planned` (#160 to #162).

## 0.1.0 (14 Nov 2026)

First published contract, from the Student API foundation (Scheduler_Backend #158, commit
8aa49d1). The whole Stage 1A `/v1` surface: config, sign-in, me, linking, consents and the age
tick, Jobs access, the Campus hand-off, placement prompts and consent requests. Named examples for
every state the app shell needs. Live on the server today: `GET /v1/config`, `GET /v1/me`,
`PUT /v1/me/language` (`x-status: live`); the rest answer 404 until their backend issue ships.

## 0.0.0

Nothing published. The scaffold's generated file (28 October 2026) was removed: it described
a design that was replaced.

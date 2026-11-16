# Contract changelog

Additive changes stay in v1: new paths, new optional fields, new enum values the app already
tolerates. A breaking change is never made in place: it gets a new path and a raised minimum
app version, and the old path keeps working until that version is enforced.

## 0.29.0 (16 Nov 2026)

Copied unchanged from Scheduler_Backend at commit 33d31e4. Additive changes, all off until the centre sets them:

- 0.27.0: posting and commenting in the community may answer 403 `COMMUNITY_MUTED` with `details.until`, while a member
  is muted after repeated upheld reports (Scheduler_Backend #296). No new path or field.
- 0.28.0 and 0.29.0: `POST /v1/me/link/auto` takes an optional body `{admission_number}` and, while the centre asks
  for the admission number as a second proof (Scheduler_Backend #211), answers `needs_centre` with
  `admission_number_required: true` (a new optional field; 0.28.0's state `needs_admission_number` was never
  published here, because a new response enum value is a breaking change). An app that does not know the field shows
  "Ask your centre"; asking for the number on the "I have already paid" screen is the app's follow-up.

The generated Dart client is regenerated; no path is added or removed.

## 0.26.0 (16 Nov 2026)

Copied unchanged from Scheduler_Backend at commit 9ee0905. Adds `GET /v1/me/registrations/{id}/undertaking`: the
signed undertaking PDF of the student's own registration, kept privately by the server (Scheduler_Backend #256). The
generated Dart client gains the call on `JoiningApi`; nothing else changes.

## 0.25.0 (15 Nov 2026)

The full Student API surface, copied unchanged from Scheduler_Backend at commit 12e8df2:
105 live operations across Stage 1A, Stage 3 and Stage 4, including joining, fees, payments,
receipts, attendance, complaints, community, visitor features, placement proof, referral,
learning, recorded videos and quizzes. This is the contract the generated Dart client is built
from. Later backend changes arrive as a new publish with a version bump and its source commit.

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

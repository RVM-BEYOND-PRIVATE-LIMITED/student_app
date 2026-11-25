# Contract changelog

Additive changes stay in v1: new paths, new optional fields, new enum values the app already
tolerates. A breaking change is never made in place: it gets a new path and a raised minimum
app version, and the old path keeps working until that version is enforced.

## 0.38.0 (25 Nov 2026)

Copied from Scheduler_Backend at commit 4266db6 (release #702, live in production). All additions; older apps ignore them.

- 0.38.0 (Scheduler_Backend #698, student_app #103 "Continue watching"): every `VideoLibrary` item gains
  `last_position_s` (the second the student last stopped at; null when the video was never started) and
  `last_watched_at`. New `GET /v1/me/videos/continue` (`listContinueWatching`): the started and unfinished videos,
  newest first, at most 20; a video stopped at or after 95% of its length is finished and leaves the list, and a
  locked one stays with its `locked_reason`. `PlaybackStarted` gains `last_position_s`: the player seeks there.
  `POST /v1/playback/sessions/{id}/end` takes an optional body `{ position_s }`. The heartbeat's `position_s` is
  where the player is now (the server keeps the furthest second itself); the app also sends one beat on pause.
- 0.37.0 (Scheduler_Backend #686): `Config` gains `sign_in_public`, true only while the student app is open to
  everyone. During a pilot it is false, so the website's student links and the web version stay closed.
- 0.36.0: `Config` gains `sign_in_open`, true while the student app is open for sign-in (on or in pilot). While it
  is false every sign-in answers `MODULE_OFF`.

The generated Dart client is regenerated.

## 0.35.1 (21 Nov 2026)

Copied from Scheduler_Backend at commit 3528c4b (release #662, live in production). All additions; older apps ignore them.

- 0.35.1: two descriptions quoted (an unquoted comma had split them); no route or reply change.

**One accepted breaking change (from 0.31.0, 17 Nov 2026).** `PlaybackStarted.otp` and `playback_info` may be null
since recorded videos moved to our own storage (Scheduler_Backend #192: `provider: self` plays `stream_url` and has no
VdoCipher OTP). It was made in place because no student app build was in students' hands (the app is not on Play yet),
and the app already plays `provider: self` (#85). The two lines are in `tools/breaking-accepted.txt`, which the
breaking-change check skipped until `contract-v0.35.1` was released (21 Nov 2026); the file is empty again.

- 0.35.0 (student_app #89): `GET /v1/me/payment-terms` gives the non-refundable line to show with the tick before
  paying, in the account's language, and its `version`, which is the `text_version` a payment order sends. A new
  text comes with a new version; an order with an older one is refused `ACCEPTANCE_REQUIRED`. `Registration` gains
  `joining_payment` (`referral_discount_paise`, `payable_paise`, `min_paise`): the server already takes an applied
  referral's discount off, so the first payment is from `min_paise` to `payable_paise` and the app subtracts
  nothing. `Referral` gains `items` (one row per friend: phone masked, status, and the reward with its amount,
  payout status and `paid_at`), `reward_paise` and `friend_discount_paise`.
- 0.34.0: `GET /v1/me/admissions/history` (a student who left a course midway and came back on an add-on
  admission) and an optional `earlier_course` on complaints.
- 0.33.0 (Scheduler_Backend #639): Play Integrity. The Android app sends an optional `integrity_token` in `device`
  at `POST /v1/auth/otp/verify` and in the body of `POST /v1/playback/sessions`, for the nonce described in the
  contract's description. While the server enforces the check, a phone that fails it gets 409
  `DEVICE_INTEGRITY_FAILED` with `details.reason`. `DEVICE_NOT_TRUSTED` (not the bound phone) is unchanged. The
  check is switched off on the server today.

The generated Dart client is regenerated.

## 0.32.0 (19 Nov 2026)

Copied from Scheduler_Backend at commit a69f3e9. Adds the self-hosted video stream
(`GET /v1/playback/sessions/{id}/stream`), `provider` and `watermark_text` on `PlaybackStarted`,
comment reports and comment moderation for student moderators, and the signed undertaking PDF
(`GET /v1/me/registrations/{id}/undertaking`).

## 0.30.0 (17 Nov 2026)

Copied unchanged from Scheduler_Backend at commit b83ee8a. Two optional fields on the sign-in code reply
(`OtpChallenge`), both ignored by older apps:

- `pilot: true` while the app is open only to a pilot list (Scheduler_Backend #570). The reply is then the same for
  every number, whether a code was sent or not, so the code screen says "If this number is on the pilot list, your
  code is on its way" instead of "We sent a code on WhatsApp". A number outside the pilot is now answered with the
  channel a real send would use, never WhatsApp when WhatsApp cannot be sent.
- `sms_fallback_at` when the code went on WhatsApp and the automatic SMS fallback is on (Scheduler_Backend #203,
  off until Gallabox and its webhook are configured): unless WhatsApp has confirmed delivery by then, the same code
  goes by SMS. The code screen counts down to it.

The generated Dart client is regenerated; no path is added or removed.

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

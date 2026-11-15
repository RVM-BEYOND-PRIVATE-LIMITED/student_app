# Release checklist (student_app #8, item 8)

Every screen of #2 to #6 is run on the recorded low-cost phone on the
weak-network profile before a release. This file records the pass; it is not
a pass until every row is filled on the phone.

## The phone and the network

- Phone: _model, Android version, RAM_ (from `mobile/docs/test-device.md`).
- Network: throttled, patchy 4G (`mobile/docs/test-device.md`).
- Build: release-signed pilot APK, same signing key as the Play build
  (student_app #20).
- Date and person:

## Screens

Run each screen, then its main action, on the profile above. "Pass" means it
opens, shows server data, and a failed action shows the app's own message
with a retry.

| # | Screen | Action | Result | Notes |
|---|---|---|---|---|
| 2 | Sign-in | Send code, enter code | | |
| 2 | Consent / 18+ | Tick and continue | | |
| 2 | Two doors | Open each | | |
| 2 | Already paid | Link, Ask your centre, call | | |
| 2 | Join holding | Open, call a centre | | |
| 2 | Home | Prompts and consent card | | |
| 2 | Jobs closed | Reason and next step | | |
| 2 | Jobs open | Hand-off and Campus web view | | |
| 2 | Campus web view | Browse, apply, upload, download, back | | |
| 2 | Profile | Language, consent withdraw, sign out | | |
| 3 | Joining | Every step and payment state | | |
| 4 | Fees | Plan, receipts, pay, fee hold | | |
| 4 | Timetable / attendance | Today, chat | | |
| 4 | Announcements / notifications | Open a push | | |
| 5 | Complaints | Raise, reply, reopen | | |
| 5 | Community | Post, comment, react, report | | |
| 6 | Visitor | Lecture, quiz, visit, courses | | |
| 6 | Proof / payout / referral | Each status and refusal | | |
| 9 | Join / videos | Join, play, heartbeat, lock | | |

## Weak network

- [ ] A write shows pending, is applied once, and survives the app being
      killed mid-request (#8, item 9).
- [ ] A dropped connection shows the app's own message with the request id,
      and retry does not send a second action (Idempotency-Key).
- [ ] A cold start reaches the first screen on the profile in a reasonable
      time.

## Sign-off

- [ ] Every row above passes; failures are fixed and re-run.
- [ ] The two sign-off checks above pass.
- [ ] The build number is recorded; the symbols folder is kept for this
      version (`mobile/README.md`, "Reading an obfuscated crash").

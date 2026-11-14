# Old student app to new app

The old student app (`apps/student_app` in the flutterapps repository) keeps
running while the new one is built (D15). This map says where each of its
features goes in the new app, so nothing is rebuilt twice and nothing is
lost. Source: student_app #1, "Old app to new app".

File paths below are in the old app, under `apps/student_app/lib/`.

## Features

| Old feature | Old files | New home | Notes |
| --- | --- | --- | --- |
| Phone and OTP sign-in on the job portal, the email step, password sign-in, mock and bypass flags | `features/auth/phone_login_screen.dart`, `otp_screen.dart`, `password_login_screen.dart`, `password_flow_screen.dart`, `features/auth/bloc/*`, `config/app_flags.dart`, `config/mock_data.dart` | Student API sign-in (#2) | The email step, password sign-in, mock and bypass flags are dropped. |
| Native job feed, job detail, apply, saved jobs, applications | `features/jobs/*`, `features/activity/*`, `widgets/job_card.dart`, `widgets/match_ring.dart` | Inside the Campus web view (#2) | Not rebuilt natively. |
| Companies, employer chat | `features/companies/*`, `features/chat/*` | Inside the Campus web view (#2) | Not rebuilt. |
| Experience, résumé and certificates | `features/experience/*`, `features/documents/*` | Inside the Campus web view (#2) | Not rebuilt. |
| RVM verification, ban appeal | `features/rvm_verification/*`, `features/ban_appeal/*` | Inside the Campus web view (#2) | Not rebuilt. |
| Registration wizard (PR #5), which posted Scheduler intakes straight from the phone | `features/auth/registration_wizard_screen.dart`, `registration_screen.dart`, `features/auth/bloc/registration_bloc.dart` | The joining flow through the Student API (#3) | The phone never writes Scheduler intakes directly again. |
| Learning tab: admission status by phone, branch contacts | `features/learning/learning_screen.dart` | "I have already paid" (#2) and classes (#4) | |
| Home: next class card, announcements, notification count | `features/home/*`, `features/announcements/*` | Home (#4) | |
| Support tickets and feedback | `features/support/*`, `features/feedback/*` | Complaints (#5) | The Campus feedback button stays inside the web view. |

## Reusable pieces

These carry over as patterns or are rebuilt on this app's theme; they are
not copied with private data.

| Old file | Use in the new app |
| --- | --- |
| `widgets/states.dart` | Shared states: rebuilt in `lib/widgets/states.dart` (skeleton, empty, error with request id). |
| `features/connectivity/offline_banner.dart` | Offline banner: rebuilt in `lib/features/connectivity/offline_banner.dart`. |
| `widgets/rvm_wordmark.dart`, `widgets/painters/gear_mark_painter.dart`, `widgets/painters/grid_paper_painter.dart` | The mark and wordmark: rebuilt in `lib/widgets/brand_mark.dart`. |
| `lib/theme/*` | The handoff's tokens: `lib/theme/student_tokens.dart` and `student_theme.dart` on core_ui's structure. |
| `widgets/rvm_bottom_nav.dart` | Bottom navigation, when the app has tabs (#4). |
| `util/file_pick.dart` | File picking, when an issue needs uploads. |
| `features/auth/phone_login_screen.dart`, `otp_screen.dart` | Sign-in layouts for #2. |
| `features/learning/learning_screen.dart` (branch contact card) | Branch contact card, with data from the server. |

## Do not copy

- `features/learning/enrollment_data.dart`: it hard-codes branch phone
  numbers, the undertaking video id and the terms. All three now come from
  the server.
- Anything holding phone numbers, internal hosts or test accounts: this
  repository is public (D19).

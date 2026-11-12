# RVM Student (mobile/)

The new student app: one Flutter project, Android only, in English and Hindi
(student_app #1). Every later student-app issue builds on this foundation.

What is here today: the project on the Team app's stack, the Team app's core
packages, the Student API client (headers, Idempotency-Key, session renewal
hook), the student session on secure storage, translations with bundled
fonts and a saved language switch, display helpers for money and IST times,
the launch version gate (fail-open), dev and prod configurations, on-device
crash capture, and these screens: Splash, Update required, Language, the
shared states (skeleton, empty, error with request id, offline banner) and a
dev-only Developer menu. No Student API endpoint is called yet: the API and
its contract do not exist (Scheduler_Backend #158, student_app #10).

## Flutter version

**Flutter 3.35.7** (Dart 3.9.2), exactly. CI installs the same tag
(`.github/workflows/mobile-ci.yml`), and `pubspec.yaml` refuses older SDKs.

```bash
git clone --depth 1 --branch 3.35.7 https://github.com/flutter/flutter.git
export PATH="$PWD/flutter/bin:$PATH"
flutter --version   # Flutter 3.35.7
```

## Application id and signing: permanent, not decided yet

- The application id `com.rvm.rvmstudent` and the name "RVM Student" are the
  **development defaults**. The new app has its own id, apart from the old
  student app's.
- An application id and the app signing key are **permanent once the app is
  on Google Play**: a build with another id is another app, and a build signed
  with another key cannot update the installed one. Both must be confirmed by
  Prakash (student_app #20) **before the first pilot build** is handed to
  anyone.
- **No release keystore exists in this repository, and none may be added.**
  `flutter build apk --release` does not sign: a release build is signed
  only once the key route is decided. The single exception is CI's size
  report, which sets `RVM_CI_SIZE_REPORT=true` to sign a throwaway build with
  the runner's debug key, measures it and discards it.

## Stack

The Team app's stack, at the Team app's version constraints:
`flutter_bloc`, `get_it`, `go_router`, `dio`, `equatable`,
`connectivity_plus`, `package_info_plus`, `path_provider`; tests on
`flutter_test`, `bloc_test` and `mocktail`. Translations use the SDK's
`flutter_localizations` with `intl: any` (the SDK pins the one `intl` it
works with).

### Team app core packages

`core_network`, `core_auth`, `core_bloc` and `core_ui` come from
[team_app](https://github.com/RVM-BEYOND-PRIVATE-LIMITED/team_app) as git
dependencies (`flutter_app/packages/<name>`), pinned to commit
`0134daefbc44b22c3a6cece428f69054540accdc` on `feat/issue50-core-packages`.
That commit holds the `IdempotencyInterceptor`, `Failure.requestId`, the
`Redact` helper and the paise formatter (team_app #50, #55, #61).
**Move the pin to a team_app `main` commit once that branch merges.** pub
accepts the packages through git as they are, so nothing is vendored.

## Run it

```bash
cd mobile
flutter pub get          # also generates lib/l10n/gen/ (not committed)
flutter run              # dev build, Student API on this computer
```

### Configurations (`--dart-define`)

| Define | Values | Default |
| --- | --- | --- |
| `FLAVOR` | `dev`, `prod` | `dev` |
| `STUDENT_API_HOST` | the Student API's base address | none |

- **dev with no host** sends every request to `http://127.0.0.1:3000`, this
  computer. From a phone, run `adb reverse tcp:3000 tcp:3000` first; the
  emulator can also use `--dart-define=STUDENT_API_HOST=http://10.0.2.2:3000`.
  A dev build never reaches a live host unless a developer sets one on
  purpose: every request to any other host is refused before anything is
  sent (`lib/core/network/dev_host_guard.dart`). Plain HTTP is allowed only
  to these loopback names, and only in debug builds
  (`android/app/src/debug/res/xml/network_security_config.xml`).
- **prod** needs an `https://` host. A prod build made without one does not
  start: it shows a short message and makes no request. No production
  address is written in the code; the release pipeline will pass it once the
  host exists (student_app #20).

The Scheduler_Backend #158 mock does not exist yet, so the Developer menu
shows "not available yet" for the mock, the feature switches and the
minimum version.

### Logs and crashes

- Request logging (`LoggingInterceptor`) runs in debug builds only; a
  release build logs no request.
- Uncaught errors (Flutter, platform dispatcher, zone) are cleaned of phone
  numbers, OTPs, tokens and names (`lib/core/redact/student_redact.dart`)
  and kept on the phone only, in the app's private storage, out of backups.
  The Developer menu shows them. Sending crash reports off the phone is
  student_app #12 and needs an OK first.

## Translations and fonts

- English is the template: add a key to `lib/l10n/app_en.arb`, then the same
  key to `lib/l10n/app_hi.arb`. CI fails when Hindi lacks a key
  (`l10n.yaml` writes `build/untranslated_messages.json`; it must stay `{}`).
- The language is chosen on first launch, saved on the phone (survives a
  restart) and sent as `Accept-Language` on every request.
- Fonts are bundled, never downloaded: Geist, Geist Mono, Fraunces and Noto
  Sans Devanagari, all SIL OFL 1.1. Sources, pinned versions and checksums:
  `assets/fonts/SOURCES.md`.
- Hindi wording is a draft until the Hindi reviewer reads it (student_app
  #1).

## Tests

```bash
flutter analyze
flutter test                          # everything
flutter test --exclude-tags golden    # without the golden images
flutter test --tags golden            # golden images only (Linux)
flutter test --tags golden --update-goldens   # remake them after a UI change
```

Golden images (`test/goldens/`, student_app #11) show the shared states in
English, Hindi and a test-only long-text locale, drawn with the bundled
fonts. They are made and compared on Linux only; other systems draw text a
little differently.

## CI

`.github/workflows/mobile-ci.yml` runs on every pull request that touches
`mobile/`: Flutter 3.35.7 from its git tag, the missing-translation check,
`flutter analyze`, the tests, the golden tests, a release build for size
only (split per ABI) and an APK size report in the job summary. The report
sets no budget (student_app #13).

## Waiting on the backend

- Generated Student API client and the drift check: the contract
  (student_app #10, Scheduler_Backend #158).
- Session renewal: `StudentAuthInterceptor` is ready, but the renewal call
  does not exist (Scheduler_Backend #158, #159); until then a refused token
  ends the session.
- The server's minimum version, feature switches and the student's stage:
  Scheduler_Backend #158. `VersionSource` answers "unknown" until then, so
  the launch check lets the app through.

## More

- `docs/old-app-map.md`: where each old student-app feature goes.
- `docs/test-device.md`: the test phone and the weak-network profile.

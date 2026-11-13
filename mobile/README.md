# RVM Student (mobile/)

The new student app: one Flutter project, Android only, in English and Hindi
(student_app #1). Every later student-app issue builds on this foundation.

## Android only

The student app is built and published for **Android only** (student_app
#8, item 13). No iOS target is built or published, there is no web or
desktop build, and no separate Campus app is listed. This project holds
`android/` and no other platform folder. CI's first step
(`tool/android_only.sh`) fails when `mobile/` grows `ios/`, `macos/`, `web/`,
`linux/` or `windows/`, or when `.metadata` lists another platform, so never
run `flutter create` here with another `--platforms` value.

What is here today: the project on the Team app's stack, the Team app's core
packages, the Student API client (headers, Idempotency-Key, session renewal
hook), the student session on secure storage, translations with bundled
fonts and a saved language switch, display helpers for money and IST times,
the launch version gate (fail-open), dev and prod configurations, on-device
crash capture, the capture guard and the device hints (student_app #8), the
release hardening and release checks (student_app #8), and these screens:
Splash, Update required, Language, the shared states (skeleton, empty, error
with request id, offline banner) and a dev-only Developer menu. No Student API endpoint is called yet: the API and
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
| `FLAVOR` | `dev`, `prod` | `prod` in a release build, `dev` otherwise |
| `STUDENT_API_HOST` | the Student API's base address | none |

- **dev with no host** sends every request to `http://127.0.0.1:3000`, this
  computer. From a phone, run `adb reverse tcp:3000 tcp:3000` first; the
  emulator can also use `--dart-define=STUDENT_API_HOST=http://10.0.2.2:3000`.
  A dev build never reaches a live host unless a developer sets one on
  purpose: every request to any other host is refused before anything is
  sent.
- **prod** needs an `https://` host. A prod build made without one does not
  start: it shows a short message and makes no request. No production
  address is written in the code; the release pipeline will pass it once the
  host exists (student_app #20). A release build made without `FLAVOR` is a
  prod build, so it never has the Developer menu or the loopback host; with
  no host either it shows that short message. The CI size build is such a
  build (`tool/build_release.sh` passes `FLAVOR=prod`, and CI no host).
  Only `--dart-define=FLAVOR=dev` makes a dev release build.

#### Which addresses a build may reach

The rule is checked in Dart, before every request (a retry and a replay
after renewal included), in every flavor and build mode, by `HostGuard`
(`lib/core/network/host_guard.dart`):

| Build | May reach |
| --- | --- |
| dev, no host | this computer only: 127.0.0.0/8, `localhost`, `::1`, `10.0.2.2`; http or https |
| dev, `STUDENT_API_HOST` set | this computer and that host; http or https |
| prod | https only, to any host: plain HTTP never leaves a prod build |

- Redirects are never followed: `dart:io` follows them below the guard, so
  a 3xx reaches the app as an error instead.
- A refused request becomes a typed `Failure`, like every other error.
- The session's token rides only on requests to the Student API's own
  scheme, host and port; a request to any other address carries none.
- Android's network security config does **not** limit this traffic. dio
  sends it through `dart:io`, and the Flutter 3.35.7 Android embedder does
  not apply the config to Dart sockets: it reads a policy only from an
  `io.flutter.network-policy` meta-data entry, which this app does not
  declare, and otherwise lets Dart connect insecurely to any host.
  `android/app/src/debug/res/xml/network_security_config.xml` covers only
  Android's own network stack (Java/Kotlin code), which the Student API
  client does not use. So a dev build with
  `STUDENT_API_HOST=http://192.168.1.20:3000` does reach that address over
  plain HTTP, because it was set on purpose.
- DNS: core_network's `DohHttpClientAdapter` asks the phone's resolver
  first. Only when that fails does it look the hostname up over
  DNS-over-HTTPS at `https://1.1.1.1/dns-query` (Cloudflare), outside the
  guard. That lookup carries the hostname only, never a path, header or
  body. An IP address such as the dev default needs no lookup.

The Scheduler_Backend #158 mock does not exist yet, so the Developer menu
shows "not available yet" for the mock, the feature switches and the
minimum version.

### Logs and crashes

- Request logging (`LoggingInterceptor`) runs in debug builds only; a
  release build logs no request.
- Uncaught errors (Flutter, platform dispatcher, zone) are cleaned of phone
  numbers, OTPs, tokens, email addresses, and names under name keys (such
  as `"full_name": "…"` or `name=…`; a name in free text cannot be
  recognised, so it stays)
  (`lib/core/redact/student_redact.dart`)
  and kept on the phone only, in the app's private storage, out of backups.
  The Developer menu shows them. Sending crash reports off the phone is
  student_app #12 and needs an OK first.

## Device security (student_app #8)

### Capture guard

`SecureScreen` (`lib/core/security/secure_screen.dart`) marks a screen that
must not be captured. While it can be seen, `MainActivity.kt` sets Android's
`FLAG_SECURE` on the app's window (channel `rvm_student/secure_window`):
screenshots and screen recordings come out black and the recent-apps preview
is blank. Every Flutter screen shares that one window, so the guard is
counted (`SecureWindow`) and follows what is on screen: it is on from the
marked screen's first frame and under a dialog or bottom sheet, off once an
opaque screen covers it or its go_router shell tab is not the selected one
(or `visible: false` for other tab containers), on again when it comes back,
sent again when the app returns to the foreground, and off when the screen
leaves. It does not stop a second phone's camera.

No student screen is marked yet: the ID document preview (#3), the payout
account entry (#6) and the video player (#9) are marked when they are built.
To see it work on a phone, open the Developer menu of a dev build, then
"Capture guard test": screenshots, screen recordings and the recent-apps
preview come out black, and capture works again once you go back. The exact
steps and the result table for #8 check 1 are in
[`docs/device-checks.md`](docs/device-checks.md).

### Device hints

`PlatformDeviceHints` (`lib/core/security/device_hints.dart`) reads three
hints: the phone looks rooted (an `su` binary in a usual place, or a system
built with test keys), it is an emulator (device_info_plus
`isPhysicalDevice`), a debugger is attached. They are **for messages only**:
root and emulators can be hidden, so they never refuse, hide or limit
anything, and they are not sent anywhere. The server decides from the Play
Integrity verdict (Scheduler_Backend #159 at phone binding, #192 at
play-session start; neither exists yet), and `DeviceHints.notes()` only adds
a plain sentence under the message it sends. The Developer menu shows them.
No permission is needed and no installed app is listed (no
`QUERY_ALL_PACKAGES`).

## Release builds (student_app #8)

```bash
bash tool/build_release.sh --dart-define=STUDENT_API_HOST=https://...
dart run tool/check_release.dart \
  build/app/outputs/bundle/release/app-release.aab \
  build/app/outputs/flutter-apk/app-release.apk \
  build/app/outputs/flutter-apk/app-*-release.apk
dart run tool/size_report.dart
```

- `tool/build_release.sh` builds, from a clean tree, three things, all
  `--obfuscate`d and all prod (it passes `--dart-define=FLAVOR=prod` and
  refuses any other `FLAVOR`):
  - `app-release.aab`, the App Bundle for Play;
  - `app-release.apk`, one **universal** APK holding every ABI: the pilot
    build handed out by hand until Play approves the account (D11);
  - `app-<abi>-release.apk`, one APK per ABI, **for the size report
    only**. Never hand one out (see "Version codes").

  R8 shrinks and obfuscates the code and shrinks the resources
  (`android/app/build.gradle.kts`).
- `tool/check_release.dart` fails a build that is not prod (a dev build has
  the Developer menu and its test switches; #8 check 7), targets an API
  level below Flutter's default (36), is debuggable, allows cleartext
  traffic, has a component that does not say `android:exported`, exports a
  component that was not reviewed, has no R8 mapping inside the bundle, or
  carries a keystore, signing file, `.env`, `google-services.json`,
  service-account JSON, `.pem` or `.key` file, or a private key. The
  manifest checks run on each APK and on the App Bundle's base module
  manifest. The build records its flavor for this check in the manifest
  (`com.rvm.rvmstudent.FLAVOR` meta-data, from the same `FLAVOR`
  dart-define the Dart code reads); nothing reads it at run time. The check
  needs `unzip`, `zip` and aapt2 (`ANDROID_HOME`).
- Cleartext traffic is off for the whole app
  (`android:usesCleartextTraffic="false"`); only the debug build's network
  security config lets Android's own network stack reach this computer.
- Exported components, reviewed: the launcher activity (`MainActivity`,
  needed by the home screen; it reads no extras) and androidx
  profileinstaller's `ProfileInstallReceiver`, which only a caller holding
  `android.permission.DUMP` (adb, the system) can reach. Anything else
  exported fails the check until it is reviewed and added to
  `reviewedExports`.
- The target API level is Flutter's default (`flutter.targetSdkVersion`, 36
  on Flutter 3.35.7), never a pinned number.
- `tool/size_report.dart` prints the size of the bundle and each per-ABI
  APK. It is a report: no size budget is agreed (student_app #13).
- Signing and the Play upload are not here: the release key, its secrets
  and the Play Console are student_app #20.

### Version codes (for student_app #20 to confirm)

Android installs a build over an installed one only when its versionCode
is higher (and it carries the same signing key). The versionCode comes from
the build number in `pubspec.yaml` (`version: 0.1.0+1` → 1):

| Build | versionCode |
| --- | --- |
| App Bundle (`app-release.aab`), what Play serves | the build number (1) |
| Universal APK (`app-release.apk`), the pilot build | the build number (1) |
| `app-armeabi-v7a-release.apk` | 1000 + the build number (1001) |
| `app-arm64-v8a-release.apk` | 2000 + the build number (2001) |
| `app-x86_64-release.apk` | 4000 + the build number (4001) |

Flutter raises each per-ABI APK's versionCode by 1000 × its ABI number, so
a phone with a hand-installed per-ABI APK refuses every Play build with a
build number below that (a Play build 2 is "older" than 2001): the student
would have to uninstall first, losing the app's data. So the pilot build is
always the universal APK, whose versionCode matches the App Bundle's: a
Play build with a higher build number then updates it in place, provided it
is signed with the same key (#20; Play re-signs with the app signing key).
The universal APK is larger than a per-ABI one (about 46 MiB against about
16.5 MiB for arm64-v8a on this branch), because it holds every ABI.

To confirm under #20: the build number goes up by one for every build that
leaves a computer, pilot or Play, and never reuses one.

### Reading an obfuscated crash

Keep `build/symbols/appbundle/` (Play build) or `build/symbols/apk/` (pilot
build) for every version that leaves this computer, one folder per version.
They are never committed (`.gitignore`). Each holds:

| File | Turns back into names |
| --- | --- |
| `app.android-<abi>.symbols` | a Dart stack trace (`flutter symbolize`) |
| `app.android-<abi>.obfuscation.map.json` | class and member names inside a Dart error message |
| `mapping.txt` | a Java or Kotlin stack trace (R8's `retrace`) |

The ABI is on the trace's `arch:` line (`arm64` → `android-arm64`, `arm` →
`android-arm`, `x64` → `android-x64`). The obfuscation map differs between
ABIs, so the build script saves each ABI's own map from a one-ABI build and
checks that it compiled to the same `libapp.so` as the App Bundle and the
universal APK.

```bash
cd mobile
# A Dart stack trace (the lines under "*** *** ***"), saved as crash.txt:
flutter symbolize -d build/symbols/appbundle/app.android-arm64.symbols \
  -i crash.txt
# A name in a Dart error message, such as "Instance of 'aBc'" or
# "NoSuchMethodError: ... 'xYz'". The map is a JSON list of pairs,
# original then obfuscated:
jq -r --arg name aBc \
  'range(0; length; 2) as $i | select(.[$i + 1] == $name) | .[$i]' \
  build/symbols/appbundle/app.android-arm64.obfuscation.map.json
# A Java or Kotlin stack trace, saved as java-crash.txt:
"$ANDROID_HOME"/cmdline-tools/latest/bin/retrace \
  build/symbols/appbundle/mapping.txt java-crash.txt
```

Play also de-obfuscates Java and Kotlin traces itself from the mapping
inside the App Bundle.

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
`mobile/`: the Android-only check, Flutter 3.35.7 from its git tag, the
missing-translation check, `flutter analyze`, the tests, the golden tests,
the release builds (`tool/build_release.sh`: App Bundle, universal APK and
per-ABI APKs, prod and obfuscated, signed only with the runner's throwaway
debug key), the release check (`tool/check_release.dart`) and a size report
in the job summary (`tool/size_report.dart`). The report sets no budget (student_app #13).

## Waiting on the backend

- Generated Student API client and the drift check: the contract
  (student_app #10, Scheduler_Backend #158).
- Session renewal: `StudentAuthInterceptor` is ready, but the renewal call
  does not exist (Scheduler_Backend #158, #159); until then a refused token
  ends the session.
- The server's integrity verdict and the bound-phone decision, and the
  refusal screens that show them: Scheduler_Backend #159, #192 (student_app
  #8). Until then the device hints only feed messages.
- The server's minimum version, feature switches and the student's stage:
  Scheduler_Backend #158. `VersionSource` answers "unknown" until then, so
  the launch check lets the app through. A build that cannot read its own
  version is let through too.

## More

- `docs/old-app-map.md`: where each old student-app feature goes.
- `docs/test-device.md`: the test phone and the weak-network profile.
- `docs/device-checks.md`: the on-phone steps for student_app #8's checks
  (check 1, the capture guard).

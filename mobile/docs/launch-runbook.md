# Launch runbook (student_app #8, item 12)

Who does what on launch day, how to stop a bad rollout, and how the version
gate blocks an old build. The release key, Play Console and the store listing
belong to Prakash (student_app #20); the app and its checks belong to Rishi.

## Owners

- **Rishi:** build the App Bundle and the pilot APK, run `tool/check_release.dart`,
  keep the symbols, hand the build to Prakash, and fix what the independent
  security test finds.
- **Prakash:** own the Play Console, the tester lists, the data-safety form,
  the listing and the publish button; switch the server's pilot list; retire
  the old app (D15).
- **Divyanshu:** the server's feature switches, the minimum version and the
  integrity verdict (Scheduler_Backend #159, #192).

## Build and hand-over

```bash
cd mobile
bash tool/build_release.sh --dart-define=STUDENT_API_HOST=https://<student API host>
dart run tool/check_release.dart \
  build/app/outputs/bundle/release/app-release.aab \
  build/app/outputs/flutter-apk/app-release.apk \
  build/app/outputs/flutter-apk/app-*-release.apk
```

- The App Bundle goes to Play; the **universal** APK is the hand-installed
  pilot build (student_app #20, "Version codes").
- Keep `build/symbols/` for every version that leaves a computer.
- The build is signed with the app signing key kept outside this repository;
  never add the keystore, `key.properties` or a password to the repo.

## Go-live

1. Play: internal track, then closed testing with the pilot list, then
   production with a staged rollout.
2. The server's switches open each money flow at the pilot branch first
   (D5); the app has no branch list.
3. On launch day the app is available to students of every branch at once;
   only payments, payouts and fee hold use the pilot switch.
4. No iOS build and no separate Campus app is published.

## Halt a rollout

- In Play Console: **Release overview → Halt rollout** (production). The
  installed builds keep working; new installs stop.
- If a build is bad and must be blocked: raise `min_supported_version` in
  `GET /v1/config` above that build's version. The launch gate then holds
  every older build on Update required, and the server answers 426
  `UPGRADE_REQUIRED` on every call from it.
- A halted build is never reused; the next build gets a new version code.

## Bad build and the version gate

- The gate reads `/v1/config` at launch and fails open on a weak network;
  the server still refuses an old build from `X-App-Version` on every call.
- A build that cannot read its own version is never blocked.
- `tool/check_release.dart` fails a build that is dev, debuggable, allows
  cleartext, exports an unreviewed component, targets below Flutter's API
  level, or carries a key, secret or service-account file.

## Security test (plan 6.6)

- Supply the release build and the pilot APK to the independent test.
- Fix its findings before the public launch; re-run the affected checks.

## Retire the old app

- When the new app is public, note it in `mobile/docs/old-app-map.md`.
  Prakash switches off `com.rvm.student_app` and the Scheduler's token-less
  intake grace.

## Rollback notes

- A server switch can close a money flow without an app release.
- The old student portal and the old app keep running until Prakash retires
  them (D15).

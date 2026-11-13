# Device checks

Checks of student_app #8 that only a real phone (or an emulator, where
noted) can show. Whoever has the phone runs the steps, writes the result in
the table at the end of each check, and ticks the check in student_app #8.

What you need: a computer with `adb` (Android SDK platform-tools), Flutter
3.35.7, this repository, and the phone with USB debugging on
(Settings → About phone → tap "Build number" seven times → Developer
options → USB debugging). `adb devices` must list the phone as `device`.

## Check 1: a marked screen cannot be captured; other screens can

> A screenshot and a screen recording of a marked screen come out black on
> Android; other screens can still be captured.

No student screen is marked yet (the ID document preview #3, the payout
account entry #6 and the video player #9 come later), so the check uses the
Developer menu's test screen, `/dev/capture-guard`. The Developer menu is
in dev builds only, so install a dev build:

```bash
cd mobile
flutter run --dart-define=FLAVOR=dev
# or, for a release-mode build of the same thing:
flutter run --release --dart-define=FLAVOR=dev
```

A dev build with no `STUDENT_API_HOST` reaches only this computer; the
check needs no Student API.

### Steps

Run the `adb` commands from any folder on the computer. Each file lands in
that folder.

1. On the phone: pick a language, tap **Continue**, then on Welcome tap
   **Developer menu**. Leave the Developer menu on screen.
2. Before: the Developer menu can be captured.

   ```bash
   adb exec-out screencap -p > 1-menu.png
   ```

   Open `1-menu.png`: it shows the Developer menu.
3. On the phone, tap **Capture guard test**. The screen reads "This screen
   cannot be captured".
4. Screenshot of the marked screen:

   ```bash
   adb exec-out screencap -p > 2-marked.png
   ```

   Open `2-marked.png`: the app's area is black (the status bar may still
   show).
5. Screen recording of the marked screen (5 seconds; touch nothing):

   ```bash
   adb shell screenrecord --time-limit 5 /sdcard/3-marked.mp4
   adb pull /sdcard/3-marked.mp4
   adb shell rm /sdcard/3-marked.mp4
   ```

   Play `3-marked.mp4`: the app's area is black for the whole clip.
6. Recent-apps preview of the marked screen:

   ```bash
   adb shell input keyevent KEYCODE_APP_SWITCH
   ```

   (or press the phone's Recents button, or swipe up and hold). The RVM
   Student card is blank or black, not a picture of the screen. The phone's
   own screenshot (power + volume down) is refused or black too. Tap the
   card to go back to the app.
7. On the phone, tap the back arrow: the Developer menu shows again.
8. After leaving: capture works again.

   ```bash
   adb exec-out screencap -p > 4-after.png
   adb shell screenrecord --time-limit 5 /sdcard/5-after.mp4
   adb pull /sdcard/5-after.mp4
   adb shell rm /sdcard/5-after.mp4
   adb shell input keyevent KEYCODE_APP_SWITCH
   ```

   `4-after.png` and `5-after.mp4` show the Developer menu, and the Recents
   card shows it too.
9. Back to the foreground: open **Capture guard test** again, press Home,
   reopen the app from the launcher, then repeat step 4. `2-marked.png` is
   black again.

Steps 2 to 8 also work on an emulator, but the result to record is the
phone's: an emulator's screen capture can differ from a real phone's.

### Result

| Field | Value |
| --- | --- |
| Date | _to fill in_ |
| Phone, Android version | _to fill in_ (`adb shell getprop ro.product.model`, `adb shell getprop ro.build.version.release`) |
| App commit | _to fill in_ (`git rev-parse --short HEAD`) |
| Screenshot of the marked screen black (step 4) | _yes / no_ |
| Recording of the marked screen black (step 5) | _yes / no_ |
| Recents card blank (step 6) | _yes / no_ |
| Menu captured again after leaving (step 8) | _yes / no_ |
| Black again after returning from Home (step 9) | _yes / no_ |
| Who ran it | _to fill in_ (a role) |

Keep the files of steps 2 to 8 with the result; they are the evidence.
When every row says yes, tick check 1 in student_app #8. The real marked
screens (#3, #6, #9) repeat steps 3 to 8 on their own screen once built.

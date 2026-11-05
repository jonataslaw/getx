# Native Android navigation acceptance

This standalone Android instrumentation host controls the dedicated Flutter
`device_navigation_probe.dart` application through Android UI Automator and
native input injection. It runs in a different process/package so it survives
the probe's process death. It does not replace GetX navigation, Flutter
restoration, or platform callbacks.

Use Android API 24 for legacy system-back acceptance and an API 34+ emulator with
gesture navigation enabled for the complete predictive suite. Predictive tests
fail if API/gesture prerequisites are absent; they are never silently skipped.
Every test fails if required runner arguments are missing, the
deployed fingerprint differs, or the versioned history snapshot is absent.
The predictive tests require observer start/progress/stop callbacks as well as the
correct final route, result and controller lifetime. A `KEYCODE_BACK`-only pass
does not satisfy these tests.

Build the Flutter probe first with a unique `PROBE_BUILD_FINGERPRINT`, retaining
the same installed APK for every prepare/restore pair:

```sh
cd example_nav2
flutter build apk --debug -t lib/device_navigation_probe.dart \
  --dart-define=PROBE_BUILD_FINGERPRINT=your-source-fingerprint
```

Install that APK on the dedicated emulator. Record its application ID, fully
qualified activity class, display label, APK hash and SDK version. The example's
default activity class is `com.get.example_nav2.MainActivity`. The probe chooses
Android native transitions and uses the manifest's Android back callback opt-in.

Build the independent host with the example's Gradle wrapper (run from the
repository root); supply `ANDROID_HOME` and a Java 17+ JDK as required by Gradle:

```sh
example_nav2/android/gradlew -p example_nav2/test/device/android \
  assembleDebug assembleDebugAndroidTest
```

Install both APKs from `build/outputs/apk/debug/` and
`build/outputs/apk/androidTest/debug/` below this directory. Select the emulator
explicitly with `adb -s SERIAL`; do not rely on the first connected device.

```sh
adb -s SERIAL shell am instrument -w -r \
  -e probePackage YOUR_DEDICATED_PROBE_PACKAGE \
  -e probeActivity com.get.example_nav2.MainActivity \
  -e displayName YOUR_PROBE_LAUNCHER_LABEL \
  -e buildFingerprint your-source-fingerprint \
  com.getx.deviceharness.test/androidx.test.runner.AndroidJUnitRunner
```

The ten tests cover typed results, system back, completed and cancelled native
predictive gestures, `canPop: false` with system and gesture back, root Activity
exit, inner `PopScope<int>` veto followed by enabling back, controller
creation/disposal and cold restoration. The inner PopScope tests leave the
GetPage policy at its default; they verify route-level veto is honored by system
back and predictive commit and that enabling back permits exactly one disposal.
Root Activity exit does
not require process death: Android may retain the background process.

Run all ten methods on the modern gesture emulator. On API 24 run only the
following six explicit methods by supplying this additional runner argument
(replace `C` with `com.getx.deviceharness.DeviceNavigationTests` in each entry):

```text
-e class 'C#nativeTypedResultDisposesController,C#systemBackDisposesAndReturnsNull,C#canPopFalseVetoesSystemBack,C#popScopeVetoesSystemBackThenAllowsIt,C#rootSystemBackExitsActivity,C#coldProcessRestoresSameTaskHistoryAndPageState'
```

The API 24 result must be `OK (6 tests)`; it does not claim predictive support.
Each test starts with `am force-stop` **only for initial isolation**.
The cold test then sets count/note, backgrounds the app and waits four seconds
for saved state. Activity start, initial isolation and process kill explicitly
target the validated current Android user from `am get-current-user`; the
kill command is `am kill --user USER PROBE_PACKAGE`. The test
proves PID absence, resumes the retained task through Recents,
and proves the same task ID with a new PID/boot marker. It checks restored
count/note, live increment, history back to root, then a new typed result. It
does not expect an old Dart Future to survive process death. There is no
force-stop, reinstall, clear-data or launcher fallback within the cold cycle.

The Recents lookup requires the probe's own card to be visible. If a launcher
uses a different accessibility layout, inspect the failure hierarchy and adapt
the card selection while retaining the same-task assertion; do not weaken the
restoration criterion.

Instrumentation prints evidence paths below its external files directory.
Copy screenshots/XML and the complete instrumentation result outside the
repository. An executed assertion failure is a failure; skipped tests or a
zero-exit shell without the expected `OK (10 tests)` on the modern emulator (or
`OK (6 tests)` for the legacy filter) are not acceptance. Repeat the cold test
with the `-e class` filter for additional independent cycles, recording old/new
PIDs and task IDs. Clean up only the dedicated probe and these harness packages
after verification.

## Verified emulator acceptance

On 2026-11-05, the same ARM64 Profile AOT probe APK built with Flutter 3.47.9 /
Dart 3.13.7 passed the following native checks using Android Emulator 37.2.12:

| Environment | Native suite | Complete process-death cycles |
|---|---|---|
| API 24, Google APIs ARM64 revision 29, button navigation | 6/6 passed | 3/3 passed |
| API 36, AOSP ARM64 revision 2, gesture navigation | 10/10 passed | 3/3 passed |

The three cold cycles in each lane include the suite's cold test plus two
separate repetitions. Each retained the installed APK and task between
preparation and recovery, verified a different PID/boot, restored count/note,
returned to the root and completed a new typed future with `42`. Controller
creation/disposal was checked in the new process. Predictive tests on API 36
observed actual start/progress/stop events and verified both cancellation and
commit, including enabling back after a dynamic PopScope veto.

These results cover the selected SDK, host, images and native transition.
Repeat target acceptance when those change. CI compiles the standalone harness;
its build result alone does not establish emulator runtime acceptance. Keep
screenshots, logs, emulator configuration and machine identifiers outside the
repository. The documented SDK web encoding limitation remains unchanged.

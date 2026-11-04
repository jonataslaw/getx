# Physical iOS navigation and restoration checks

`lib/device_navigation_probe.dart` is a separate native-only entry point. It
uses real GetX routes, typed results, Cupertino gestures, `RestorableInt` and
`RestorableTextEditingController`. It does not persist the test values itself.
The ordinary example entry point is unchanged.

`DeviceNavigationUITests.swift` is an XCUITest source for a dedicated signed
test host. Add it to a UI testing target whose application uses that entry
point. Supply `APP_BUNDLE_ID` in the **test runner** environment with the host's
dedicated bundle identifier. Keep signing teams, provisioning profiles and
device identifiers in local configuration. Use a separate bundle identifier
so testing does not replace another installed application.

If profile-mode debugging shows a local-network permission prompt, supply the
host's exact display name as `APP_DISPLAY_NAME` in the test runner environment.
The suite declines only a matching local-network prompt: these native UI checks
do not need Flutter's VM service. Other permission prompts are not handled.

The host needs a restoration-enabled Flutter view controller: set its
`restorationIdentifier` in the storyboard before Flutter creates its engine.
Retain Flutter's native save/restore behavior, including its application
modification-time check. The local acceptance host uses Flutter's scene
lifecycle, as does this example. Keep the scene's activity type (`flutter` in
the example) in `NSUserActivityTypes`; a Dart scope alone does not configure
the native host.

Use an AOT profile or release build for the process-death check. Keep the
phone unlocked with Developer Mode and UI Automation enabled. Build the app
and UI test target once with `xcodebuild build-for-testing`, then use
`test-without-building` with explicit test filters.

## Native back and gesture tests

Run these four methods without the restoration method:

- `testNativeTapReturnsTypedResult`: closing the pushed page returns `42`.
- `testCancelledNativeEdgeDragKeepsRouteAndResultPending`: a short edge drag
  cancels; closing the remaining page still returns `42`.
- `testCompletedNativeEdgeDragPopsWithNullResult`: a full edge drag returns
  to the root with a null result.
- `testCanPopFalseBlocksNativeEdgeDragThenResetRestoresRoot`: a veto blocks
  the edge drag; the dedicated reset replaces the stack afterward.

These inject native touches through XCUITest. Widget tests complement them
but do not establish physical-device gesture acceptance.

## Native process-death restoration

Run `testBackgroundProcessDeathRestoresHistory` alone. It opens the detail
page, sets the counter to `7`, enters `restored-note`, and backgrounds the app.
After a bounded save interval it writes these unbuffered markers:

```text
PREVIOUS_BOOT=BOOT:<process marker>
PREVIOUS_PID=PID:<native process id>
PROCESS_DEATH_READY
```

Use the selector
`<UI-test-target>/DeviceNavigationUITests/testBackgroundProcessDeathRestoresHistory`
with `-only-testing:` and allow at least 180 seconds for the complete method;
the process-death wait alone can take 60 seconds.

While that same test session waits, inspect the device's installed app and
process metadata. Verify that the reported PID's executable belongs to the
dedicated host bundle, then send **only that PID** `SIGKILL`, for example with
`xcrun devicectl device process signal`. The test waits up to 60 seconds for
process death, activates the same installed app, and checks:

- Both the native PID and the in-memory boot marker changed.
- The detail route, counter `7` and note were restored.
- Incrementing produces `8`, proving the restored UI remains live.
- Closing the restored detail returns to the root without a phantom detail.

Do not rebuild, reinstall, relaunch through a second Xcode test session, or
force-quit through the app switcher between preparation and verification.
Those operations can invalidate restoration independently of GetX. The old
Dart future and its awaiting continuation cannot survive process death;
the test deliberately does not expect that dead caller to receive `42`.
Screenshots and accessibility attachments are retained in the local
`.xcresult`. Keep device diagnostics outside the repository.

This suite covers iOS navigation. Android system back and predictive-back
gestures require a separate Android device or emulator.

## Current acceptance boundary

On Flutter 3.47.9 and a physical iPhone 16 Pro Max running iOS 27.2, all four
native back/gesture checks passed. The process-death check did not recover
the detail route, despite a changed PID and an unchanged installed bundle.
`flutter_restoration_control.dart` provides an independent control using
Flutter's `Navigator.restorablePush`, with no GetX imports. Its widget-level
restoration check passes. After validating its callback retention and handling
the profile-mode permission prompt, the physical control also failed to
recover the detail route after a verified background process kill.

Use that control as the host's alternate entry point to investigate the native
restoration boundary. Keep the same scene setup, automation and build mode;
start a new preparation cycle after switching builds. This result leaves
physical process-death acceptance open. It does not identify the exact cause
among the SDK, native host and automation, and does not invalidate the separate
GetX history round-trip/widget tests. Recorded on 2026-11-05; do not substitute
background resume or a widget restart for a successful physical retest.

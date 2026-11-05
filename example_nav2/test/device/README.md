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

Build the probe with a source identifier, for example
`--dart-define=PROBE_BUILD_FINGERPRINT=local-revision`, and supply
the identical value as `EXPECTED_PROBE_BUILD_FINGERPRINT` in the **test runner**
environment. Every native test checks the deployed `BUILD:` label and
`SNAPSHOT_PRESENT:true`. A missing identifier or URI-only GetX implementation
fails before the process-death marker. Keep source hashes and AOT artifact
UUIDs alongside the result: these runtime checks complement build provenance.

Supply the host's exact display name as `APP_DISPLAY_NAME` for the restoration
test, and keep its icon visible on the current Home-screen page. This name is
also used if profile-mode debugging shows a local-network permission prompt.
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
explicitly with `flutter build ios --profile --no-pub` and the fingerprint
define, then build its UI test target with `xcodebuild build-for-testing`.
Use `test-without-building` with explicit test filters afterward. Compare the
prepared Flutter and XCTest AOT UUIDs and check the runtime fingerprint.

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
process death, taps this application's Home-screen icon to open the same
installed app, and checks:

- Both the native PID and the in-memory boot marker changed.
- The detail route, counter `7` and note were restored.
- Incrementing produces `8`, proving the restored UI remains live.
- Closing the restored detail returns to the root without a phantom detail.
- A fresh push and close after restoration returns the typed result `42` to
  its new caller.

Do not rebuild, reinstall, relaunch through a second Xcode test session, or
force-quit through the app switcher between preparation and verification.
Those operations can invalidate restoration independently of GetX. The old
Dart future and its awaiting continuation cannot survive process death;
the test deliberately does not expect that dead caller to receive `42`.
Screenshots and accessibility attachments are retained in the local
`.xcresult`. Keep device diagnostics outside the repository.

This suite covers iOS navigation. Android system back and predictive-back
gestures require a separate Android device or emulator.

## Verified cold-start behavior

On 2026-11-05, the current scoped history implementation passed three complete
process-death cycles on a physical iPhone 16 Pro Max running iOS 27.2, using
Flutter 3.47.9 Profile AOT and the standard scene host. Each cycle started from
a fresh test installation, verified the deployed fingerprint and snapshot,
then kept that installation unchanged through background, kill and icon
relaunch. All three restored the route, counter and note, returned to the root,
and completed a newly created typed navigation future with `42`.

A controlled build of the earlier URI-only implementation (`7d4afe1f`), using
the same phone, SDK, host and probe, recovered the detail page and its values
but failed to return to the root. It saved only the selected URI, leaving out
the preceding history. The current version serializes the scoped history in
`RouteInformation.state` and rebuilds the preceding pages in the new delegate.

The regression suite supplies saved restoration data **before** mounting a
fresh app to cover that cold-start ordering. Applying it after first starting
a root page is a separate late-update test: that initial page can hide a
missing-history defect in the URI-only implementation.

`flutter_restoration_control.dart` is an independent SDK control with no GetX
imports. Its widget and physical checks passed in the follow-up investigation.
The earlier detail-absent physical failure was not reproduced; these results
do not establish that an SDK race or stale binary caused that earlier result.
No SDK modification or startup-delay workaround is part of the fix. Keep
acceptance scoped to the tested SDK, host and device, and repeat it when those
change. Background resume and widget restart alone do not prove native
process-death restoration.

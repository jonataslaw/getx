# GetX 5 Navigator 2 example

This application uses the GetX package in the parent directory through a path
dependency. Follow the [RC migration guide](../documentation/en_US/migration_guide_5.md)
for this branch; it uses Flutter's bundled Material library rather than the
standalone UI packages used by newer `master` revisions.

Use Flutter 3.47.9/Dart 3.13.7 for dependency resolution, analysis, tests and
running the application. CI tests Flutter 3.47.9. Check the CI result for your
exact revision before claiming support on a platform.

From this directory:

```sh
flutter --version
flutter pub get --offline
flutter analyze --no-pub
flutter test --no-pub --no-dds
flutter run --no-pub
```

Offline dependency resolution requires all dependencies to be cached already;
these commands do not install or upgrade an SDK. Choose an installed target
with `flutter devices` and pass `-d <device-id>` to `flutter run` when needed.
Running tests at the repository root does not run this package's tests.

The [route hierarchy](lib/app/routes/app_pages.dart) defines root, login, home,
dashboard, profile, products and settings pages. [RootView](lib/app/modules/root/views/root_view.dart)
and [HomeView](lib/app/modules/home/views/home_view.dart) render nested
`GetRouterOutlet`s. The application registers `AuthService` through
`GetMaterialApp.binds`; route-specific controllers use `Binding` classes.

The [widget smoke test](test/widget_test.dart) exercises the real application,
authentication redirects and profile navigation. Run it when changing the
route configuration or dependency ownership; a bare counter-widget test does
not cover these flows. Also check the app interactively on the intended target:

- Enter the home/dashboard route, follow the unauthenticated profile redirect,
  sign in, and navigate to profile.
- Return through the nested stack and verify controller disposal, including
  cancellation of dashboard timers.
- For web, enter a child URL directly and refresh a release build on a server
  configured to serve the application entry point for route paths.

Widget tests do not establish browser-history behavior, platform gesture
compatibility or production-host configuration.

## Android host

The Android example follows the selected Flutter 3.47.9 template: Java 17,
Gradle 9.3.1, AGP 9.1.0 and Kotlin 2.4.0. Use `flutter build apk --debug
--no-pub --target-platform android-arm64` for a single-ABI debug build.
Flutter supplies the compile/target SDK and NDK versions; the example now
requires Android API 24 or later. This is the example application's minimum,
not an independent GetX platform guarantee. A fresh build may need Gradle,
Maven and Flutter runtime artifacts even when Dart dependencies are cached.
Debug signing is for testing; configure your own release signing before
publishing an application.


For real Chrome deep links, refresh, back/forward, nested redirects and WASM
runtime checks, see [the browser integration harness](test/browser/README.md).

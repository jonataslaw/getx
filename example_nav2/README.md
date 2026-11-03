# GetX 5 Navigator 2 example

This application uses the GetX package in the parent directory through a path
dependency. Follow the [RC migration guide](../documentation/en_US/migration_guide_5.md)
for this branch; it uses Flutter's bundled Material library rather than the
standalone UI packages used by newer `master` revisions.

Use the same selected Flutter SDK for dependency resolution, analysis, tests and
running the application. The provisional validation environment is Flutter
3.47.5; validation on Flutter 3.47.8 and 3.47.9 remains pending.

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

# GetX 5 example

This application uses the parent checkout through a path dependency. Read the
[RC migration guide](../documentation/en_US/migration_guide_5.md) and the
[example walkthrough](example.md) for the APIs in this branch.

Use one selected Flutter SDK for resolution, analysis and tests. Local checks
use Flutter 3.47.5; the [CI workflow](../.github/workflows/main.yml) also tests
this example on Flutter 3.47.8 and 3.47.9. Check the CI result for the exact
revision you consume. From this directory:

```sh
flutter --version
flutter pub get --offline
flutter analyze --no-pub
flutter test --no-pub --no-dds
flutter run --no-pub
```

Offline resolution requires an existing dependency cache. These commands do not
install or upgrade an SDK. Root-package tests do not include this package's
tests. See [example_nav2](../example_nav2/README.md) for the nested Navigator 2
application and authentication/route smoke checks.

Flutter resources:

- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter cookbook](https://docs.flutter.dev/cookbook)

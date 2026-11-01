# Migrating to GetX 5 release candidates

This guide covers the `5.0.0-release-candidate-9.3.3` source in this repository.
It highlights SDK, UI package, and dependency factory changes when moving from
GetX 4.x; it is not a complete list of changes between releases. Check the
version of GetX used by your application before applying these examples.

## Check the SDK requirements

The current candidate requires Flutter 3.47 or later and Dart 3.13 or later
(with Dart below 4.0). These constraints are declared in the
[package manifest](../../pubspec.yaml). They describe this candidate, rather
than the requirements of every GetX 4.x release.

Run `flutter --version` before updating dependencies. After the upgrade, run
`flutter pub get`, `flutter analyze`, and your application's tests.

## Use the standalone UI packages

The current `GetMaterialApp` accepts Material theme types from `material_ui`.
Import those types from the same package in your application:

```dart
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const Scaffold(),
    ),
  );
}
```

Add `material_ui` as a direct dependency if your application imports it. The
current GetX manifest uses `material_ui: ^1.8.0`. Mixing its `ThemeData` or
`ThemeMode` with values from `package:flutter/material.dart` causes incompatible
Dart types, so update the imports where those values are constructed or passed
to GetX.

For Cupertino applications, use `package:cupertino_ui/cupertino_ui.dart` for
Cupertino widgets passed to `GetCupertinoApp`, and declare `cupertino_ui` as a
direct dependency. The current GetX manifest uses `cupertino_ui: ^1.1.4`.

## Replace `Get.create` with `Get.spawn`

GetX 4.x examples may register a factory using `Get.create`. The corresponding
API in the current candidate is `Get.spawn`:

```dart
import 'package:get/get.dart';

class ItemController {}

void main() {
  Get.spawn<ItemController>(() => ItemController(), tag: 'item');

  final first = Get.find<ItemController>(tag: 'item');
  final second = Get.find<ItemController>(tag: 'item');
  assert(!identical(first, second));
}
```

Each `Get.find` call invokes the registered factory and returns a new instance.
Use the same `tag` when registering and finding the factory. `Get.spawn` accepts
`tag` and `permanent`; `permanent` defaults to `true`. See the
[implementation and API documentation](../../lib/get_instance/src/extension_instance.dart)
for lifecycle details.

`Get.put` and `Get.lazyPut` serve different registration needs; do not replace
those calls with `Get.spawn` merely as part of this rename.

Some [dependency management examples](dependency_management.md) still use
GetX 4.x API names. When reading those examples against this candidate, use
`Get.spawn` for the factory registration described above.

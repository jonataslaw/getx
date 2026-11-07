# Migrating from GetX 4 to GetX 5 RC

This guide describes stabilization work based on `latest-getx5-RC`. This
working tree's package version is `5.0.0-release-candidate-9.4.0`, an unreleased
candidate. The guide is specific to this source tree, rather than
an announcement of a stable GetX 5 release or a guide to the newer `master`
branch. Check your resolved GetX revision before applying it.

See the [release scope and master reconciliation](release_scope_5.md) for
included fixes, retained contracts and work deferred to later releases.

## SDK and imports

This stabilization branch requires **Flutter 3.47.9 or later** and
**Dart 3.13.7 or later, below 4.0.0**. These match the selected stable SDK;
the historical Flutter 3.22/Dart 3.4 lower bounds are no longer supported.
The [CI workflow](../../.github/workflows/main.yml) pins Flutter 3.47.9 for
analysis, root and example tests, real Chrome transport/navigation checks and
JS/WASM builds. Check the CI result for your exact revision. Later SDKs and
every target platform are not automatically certified by these lower bounds.
This candidate has not been published as a stable release.

The Navigator 2 example's native hosts target Android API 24 or later and iOS
15 or later. Its iOS host uses Flutter's scene lifecycle and implicit-engine
plugin registration. Keep that host migration when testing on current iOS.

This RC uses Flutter's bundled design libraries:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
```

For Cupertino widgets, import `package:flutter/cupertino.dart`. This branch does
not depend on the standalone `material_ui` or `cupertino_ui` packages. The
migration on `master` has different SDK and UI type requirements; do not combine
those instructions with this RC's package manifest.

Before upgrading an application, record `flutter --version` and its resolved
GetX version/revision. Resolve dependencies with your selected SDK, analyze the
application, and run its tests. Test web deep links, platform back gestures,
overlays, and controller ownership in the actual application as well as unit
and widget tests. A successful root-package test run does not test the separate
example packages or every target platform.

## Factory registrations: `Get.create` becomes `Get.spawn`

`Get.spawn` registers a factory that is invoked for each `Get.find`. It is not a
lazy singleton:

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

Use `tag`, not the old factory example's `name`, both when registering and when
finding. `permanent` defaults to `true` and controls retention of the factory
registration; it does not turn all instances produced by the factory into one
singleton. `Get.put` registers an instance, and `Get.lazyPut` registers a lazy
singleton. Keep those lifetimes when migrating.

Do **not** rename `Bind.create` to `Bind.spawn` mechanically. `Bind.create`
receives a `BuildContext` callback and creates a local binding. It is a different
API from the removed global `Get.create` registration.

The old `Get.putAsync` examples are not supported by this RC. Initialize an
asynchronous dependency before registering its resolved value:

```dart
Future<void> registerSettings(Future<Settings> Function() load) async {
  final settings = await load();
  Get.put<Settings>(settings, permanent: true);
}
```

Here `Settings` is your application's type. Handle initialization errors before
running the application or showing a screen that needs that dependency.

## Route bindings and application bindings

The new `Binding` class (singular) returns `List<Bind>`. The deprecated
`Bindings` class (plural) returns `void`; changing only its return type is not
the migration. `BindingsBuilder` is not available in this RC.

```dart
class HomeController extends GetxController {}

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<HomeController>(() => HomeController()),
      ];
}
```

Attach a binding through a list. For named routes:

```dart
GetPage(
  name: '/home',
  page: () => HomePage(),
  bindings: [HomeBinding()],
);
```

For direct navigation:

```dart
Get.to<void>(() => HomePage(), bindings: [HomeBinding()]);
```

`HomePage` is your application's widget. `GetPage` also has `binds` for a list
of `Bind` values, while `bindings` takes objects such as `HomeBinding`.
The old `binding` property remains on `GetPage` for compatibility, but direct
navigation methods use `bindings`, not `binding`.

`GetMaterialApp` uses `binds`, rather than `initialBinding`:

```dart
GetMaterialApp(
  binds: [Bind.lazyPut<HomeController>(() => HomeController())],
  home: HomePage(),
);
```

Review dependency lifetime as well as syntax. Test creation, sharing across
routes, and disposal after the final owner leaves. Do not add `permanent: true`
to every controller to hide a lifecycle failure. A `GetView` resolves its
controller through dependency lookup; retain `GetWidget` only where its cached
controller behavior is intentional, especially with a per-find factory.

## StateMixin: status carries the successful value

GetX 4 used `change(data, status: RxStatus.success())`. This RC uses
`change(GetStatus<T>.success(data))` inside a controller, or the public
`setSuccess(data)` helper. Loading, empty, and error states are explicit:

```dart
class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);

  void load(Future<List<String>> Function() fetch) {
    futurize(fetch);
  }
}
```

`futurize` receives a function returning a future, rather than an already
started future. With `useEmpty: true` (the default), an empty iterable, map,
trimmed string, or null result maps to empty status; `useEmpty: false` retains
successful empty data. It returns `void` in this RC; do not `await` it as an
application completion signal.

Concurrent `futurize` calls apply each result in completion order. An older
request can finish later and replace a newer result. Loading is not a count
of pending requests. Serialize requests or manage request ownership in your
controller when your application requires a different policy. Closing the
controller ignores later results without canceling the underlying operation.

In `controller.obx`, handle loading, empty and error as well as success. The
success callback receives the typed data; it is not an `RxStatus` object.
Do not assume the status classes are sealed or provide the proposed
`match`/`when` APIs from an unmerged PR.

## Updating a custom reactive object

`Rx.update` expects a callback returning the next value. The mutation-only
callback from GetX 4 examples does not meet that signature. Prefer returning a
new value, so equality checks can detect the change:

```dart
class Person {
  const Person(this.name);
  final String name;
}

final person = const Person('John').obs;

void renamePerson() {
  person.update((previous) => const Person('Roi'));
}
```

Custom fields do not become reactive automatically. For an intentionally mutable
model, mutate the value and explicitly notify with `refresh()`; do not rely on
returning the same object from `update` to notify observers:

```dart
user.value.name = 'Roi';
user.refresh();
```

Here `user` is your application's reactive mutable model. This is a separate
choice from making individual model fields reactive.

## Navigation uses Navigator 2

Pass widget factories to direct navigation methods:

```dart
Get.to(() => DetailsPage());
Get.off(() => LoginPage());
Get.offAll(() => HomePage());
```

For results, specify the intended type and return a matching value:

```dart
final accepted = await Get.to<bool>(() => ConfirmationPage());
// On ConfirmationPage:
Get.back<bool>(result: true);
```

These fragments belong at the two corresponding call sites. A platform back
operation may return null, so callers must handle it.

Nested navigation uses the configured `GetPage.children` hierarchy and
`GetRouterOutlet`, rather than copying the GetX 4 recipe with
`Navigator(key: Get.nestedKey(1), onGenerateRoute: ...)`. For a parent `/shell`
with a registered child `/shell/home`, the shell view can render:

```dart
GetRouterOutlet(
  anchorRoute: '/shell',
  initialRoute: '/shell/home',
);
```

Define the matching parent and children in `getPages` first. See the
[Navigator 2 example](../../example_nav2/lib/app/routes/app_pages.dart) and its
[root outlet](../../example_nav2/lib/app/modules/root/views/root_view.dart).
Configure the delegate/outlet before navigating to a nested destination. Nested
navigator IDs are strings in this RC, not the integers in older examples;
`id` identifies a navigator/delegate, not an arbitrary dialog instance.

For web apps, test entering a child URL directly and refreshing it after a
release build. Path URL hosting must serve the application entry point for
those paths. Test parent and child bindings on that first load.

Flutter 3.47.9 has a known web-engine limitation: reporting an encoded URL to
browser history can decode reserved characters, changing query values after a
refresh. GetX and an independent Flutter router reproduce this behavior.
Flutter documents the correction for
[3.50 or later](https://docs.flutter.dev/deployment/web#url-percent-encoding-in-browser-history).
That version is not this branch's tested stable baseline. Before relying on
arbitrary encoded URLs, run the [strict browser checks](../../example_nav2/test/browser/README.md)
on your selected SDK. This remains a documented SDK limitation for the current
RC baseline; passing the other navigation tests does not resolve it. No global
double-encoding workaround is applied.

`WillPopScope` recipes from Navigator 1 are not a drop-in solution for this
router. Choose the back handler appropriate to your selected Flutter SDK and
route configuration, and test platform back, browser back and swipe gestures.
Do not assume every back source follows the same path as a direct `Get.back`.

## Low-level page removal callbacks

`GetNavigator`, `GetNavigator.onGenerateRoute` and
`GetRouterOutlet.pickPages` replace the `onPopPage` constructor argument with
`onDidRemovePage`. This is a low-level API migration: the new callback takes
`Page<Object?>` and returns `void`, after Flutter has committed the removal.
Do not call `route.didPop` again or return a veto from this notification.
Configure back policy ahead of time with `GetPage.canPop` / `PopScope`.

For a custom GetNavigator, its page owner must remove that exact page and
rebuild. For example, inside a State with a `pages` list of GetPage values:

```dart
GetNavigator(
  pages: pages,
  onDidRemovePage: (page) {
    setState(() => pages.removeWhere((entry) => identical(entry, page)));
  },
);
```

GetNavigator's omitted callback is a no-op; it does not mutate a caller-owned
list. The default GetDelegate and GetRouterOutlet provide history cleanup.
If you replace an outlet's callback to add observation, also forward the page
to that outlet's delegate with `delegate.didRemovePage(page)`.

The notification does not receive the popped result. GetX forwards native
route completion to the pending typed page future separately, preserving an
already completed declarative result. History cleanup identifies the removed
entry rather than always popping the current entry. Replacement of a covered
page therefore retains the foreground page and its pending result; delayed
notifications for an older page cannot delete a replacement with the same key.

## Named-route history and restoration

Setting `GetMaterialApp.restorationScopeId` or
`GetCupertinoApp.restorationScopeId` opts the default GetDelegate into restoring
named-route history, as well as enabling Flutter restoration scopes. With a
custom delegate, set its `GetDelegate.restorationScopeId` explicitly and enable
the app's restoration scope too. A delegate without a scope keeps the previous
URI-only behavior and accepts transient arguments as before.

Give restorable pages distinct, stable `GetPage.restorationId` values and use
Flutter's RestorationMixin/restorable properties for page data. Named routes
must be registered again after startup. The delegate persists ordered history
in versioned `RouteInformation.state`; the selected URI retains its normal
meaning. Browser back/forward can import these snapshots without appending the
whole saved history to the live stack. Common live entries keep their keys and
pending result futures; removed live entries complete with null.

Restorable arguments are JSON-shaped values: null, booleans, finite numbers,
strings, lists and maps with string keys. The wire carries validated argument
JSON as text to preserve numeric representations across platform bridges,
including Dart WASM's integer/double distinction. This does not restore custom
model classes or generic collection runtime types. Supported snapshots contain
at most 128 entries, arguments at most 16 levels deep, and a complete encoded
payload at most 64 KiB. Unsupported or cyclic arguments, incompatible page
identities and excessive payloads fall back to the selected URI without saved
history or arguments. Use URI identifiers to reload application data instead
of passing controllers, widgets, closures or arbitrary model objects.

Unknown/malformed snapshots, a different scope, an unregistered destination or
a mismatch with the selected URI also fall back to ordinary guarded deep-link
handling. Middleware runs for restored entries; a cancellation, redirect or
in-place mutation rejects that complete snapshot, then the selected URI goes
through the normal guard pipeline. A guard may therefore run again. Pending
imports are discarded after disposal, a newer import or a change to live
history, rather than overwriting accepted navigation.

A restored process receives fresh runtime completers and controllers. An old
Dart call's awaiting Future or continuation cannot survive process death.
`Get.back<int>(result: value)` and new navigation futures still work after a
history restore, but do not treat a former process's pending callback as a
restoration mechanism. Verify both page data and returning to preceding pages.

On the tested Flutter 3.47.9 web bootstrap, a full browser reload supplies only
the initial URI, rather than the previous RouteInformation.state. That is a
cold deep-link load: do not claim full-history restoration from reload.
Browser back/forward snapshot replay and OS-driven Flutter state restoration
are separate checks. Neither a widget restart test nor background/foreground
resume alone proves restoration after native process death.
See the [physical-device checks](../../example_nav2/test/device/README.md) for
host setup, deployed-build verification and the tested iOS process-death
contract. Cold-start tests must provide saved data before mounting the fresh
app; starting a root page first can conceal missing history.

For Android, see the [native instrumentation checks](../../example_nav2/test/device/android/README.md).
On Flutter 3.47.9, the ARM64 Profile AOT probe passed system-back checks on
API 24 and predictive start/progress/cancel/commit checks on API 36, including
static and dynamic back vetoes and controller disposal. Both emulator lanes
passed three same-task process-death restoration cycles. The probe uses
`Transition.native` on Android and the example manifest explicitly enables
`android:enableOnBackInvokedCallback`. Custom transitions and host settings
need their own platform acceptance; a widget back callback is not a native
predictive gesture test.

## Pages and overlays have separate closing operations

`GetQueue.cancelAllJobs()` discards work that has not started. Its active job
continues; futures for discarded jobs remain pending, without a cancellation
result. Account for this when retaining or awaiting those futures. The snackbar
queue manages its own completion: canceling queued snackbars completes their
show futures and removes their controllers.

| Intention | API in this RC |
|---|---|
| Return one page, optionally with a result | `Get.back<T>(result: value)` |
| Return several pages | `Get.back(times: count)` |
| Close the current dialog | `Get.closeDialog<T>(result: value)` |
| Close the current bottom sheet | `Get.closeBottomSheet<T>(result: value)` |
| Close the current popup overlay | `Get.closeOverlay<T>(result: value)` |
| Close the current snackbar | `Get.closeCurrentSnackbar()` |
| Close all snackbars | `Get.closeAllSnackbars()` |
| Close selected overlay categories | `Get.close(...)` |
| Transitional Navigator-pop behavior | `Get.backLegacy(...)` |

`Get.back()` no longer means “close whichever page or overlay is on top”.
`Get.close()` no longer takes a number of pages. Migrate each call according to
its purpose; replacing every call with the same helper obscures that purpose.
`backLegacy` is a migration aid, not a guarantee that every application mixing
Navigator 1, nested routers and overlays preserves its old behavior.

This RC's overlay helpers use navigator popping. Do not interpret a helper name
or `id` as a guarantee that an arbitrary lower overlay can be removed through
another overlay. Test stacked dialogs, bottom sheets and snackbars together.
Also test the intended result recipient when popping multiple pages; the
single-page result example does not promise result propagation to every route.

## Check the migration in your application

- Verify factory/singleton identity, tags and controller disposal.
- Exercise StateMixin success, loading, error, empty and retry paths.
- Check custom-model notifications and workers after updating state.
- Test named/direct routes, nested outlets, typed results and deep links.
- Test dialog, bottom sheet and snackbar closing with the actual overlay order.
- Analyze and test each example/application package separately with the selected
  SDK. Repeat platform checks when the target SDK becomes available.

The translated manuals retain historical explanations where marked
**GetX 4 legacy**. Use this guide for the RC API at those points; a legacy
snippet is not presented as an equivalent GetX 5 implementation.

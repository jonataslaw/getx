# GetX

[![pub package](https://img.shields.io/pub/v/get.svg?label=get)](https://pub.dev/packages/get)

[English](README.md) · [فارسی](README-fa.md) · [العربية](README-ar.md) · [বাংলা](README-bn.md) · [Español](README-es.md) · [Français](README-fr.md) · [हिन्दी](README-hi.md) · [Tiếng Việt](README-vi.md) · [Indonesia](README.id-ID.md) · [日本語](README.ja-JP.md) · [한국어](README.ko-kr.md) · [Polski](README.pl.md) · [Português](README.pt-br.md) · [Русский](README.ru.md) · [Türkçe](README.tr-TR.md) · [اردو](README.ur-PK.md) · [中文](README.zh-cn.md)

A complete guide to this GetX 5 RC checkout, including current examples, migration, candidate changes and known limits.

## Contents

- [About GetX](#about)
- [Compatibility and installation](#installation)
- [Counter application](#counter)
- [The three pillars: state management](#state)
- [Reactive values, collections and models](#rx)
- [Workers and cleanup](#workers)
- [StateMixin and asynchronous state](#status)
- [The three pillars: dependency management](#dependency)
- [Bindings, ownership and lifecycle](#bindings)
- [GetxService and async initialization](#services)
- [The three pillars: route management](#navigation)
- [Nested routes, deep links and app configuration](#nested)
- [Dialogs, bottom sheets and snackbars](#overlays)
- [Named-route history and restoration](#restoration)
- [Internationalization and locale](#translations)
- [Themes and application settings](#themes)
- [GetConnect: HTTP and uploads](#http)
- [Modifiers, authentication and response handling](#interceptors)
- [WebSockets and disposal](#socket)
- [GetPage middleware](#middleware)
- [Advanced navigation, platform and context APIs](#advanced)
- [Global settings, logging and custom routers](#configuration)
- [Local state widgets: ValueBuilder and ObxValue](#local)
- [GetView, GetWidget and responsive views](#views)
- [Queued work and cancellation](#queue)
- [Testing controllers, widgets and platforms](#tests)
- [Migrating from earlier GetX releases](#migration)
- [Changes included in this candidate](#changes)
- [Known limits and support boundaries](#limitations)
- [Examples and verification commands](#examples)
- [Why GetX and its ecosystem](#why)
- [Community, contribution and license](#community)

<a id="about"></a>

## About GetX

GetX provides reactive and simple state management, dependency injection, navigation, overlays, translations and networking for Flutter. Its three priorities are productivity, performance and organization. Use the modules you need; state management and dependency lookup do not require a GetMaterialApp.

Separate views from application logic with controllers and bindings. Keep reactive rebuilds small and give subscriptions, timers and controllers explicit owners. GetX includes stream APIs; you do not need to build a StreamController/StreamBuilder pair for each observable. Choosing GetX does not remove the need to profile an application or manage external resources.

<a id="installation"></a>

## Compatibility and installation

This README describes this GetX 5 RC checkout, not the different API/type choices on master. The package is **5.0.0-release-candidate-9.4.0, an unreleased candidate**. Publication of a stable package is a separate action.

The validated baseline is **Flutter 3.47.9 / Dart 3.13.7**. The manifest requires Flutter >=3.47.9 and Dart >=3.13.7 <4.0.0; these lower bounds do not automatically certify every later SDK/platform. This tree uses Flutter's bundled Material and Cupertino libraries. Do not mix standalone material_ui/cupertino_ui types with its constructors.

To try this checkout, place it next to a separate Flutter application and use the path below. Run `flutter --version`, `flutter pub get`, `flutter analyze` and `flutter test` in that application. A pub.dev dependency can resolve different code: select an actually published version and read that version's docs. Record and pin the reviewed revision for a source dependency. The pub.dev badge describes published packages, not this candidate.

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

<a id="counter"></a>

## Counter application

Put this complete example in lib/main.dart. It demonstrates app bindings, GetView, Obx and a controller action. Register the controller once through the app binding instead of creating it during every build. GetMaterialApp configures the router and GetX app facilities; it is unnecessary when only the independent state/DI modules are used.

Later recipes assume the Flutter Material and GetX imports shown here. Their helper functions are called from your application's setup or UI events; they are not all startup actions.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(const CounterApp());

class CounterController extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    binds: [Bind.lazyPut<CounterController>(() => CounterController())],
    home: const CounterPage(),
  );
}

class CounterPage extends GetView<CounterController> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('GetX 5')),
    body: Center(child: Obx(() => Text('${controller.count.value}'))),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.increment,
      child: const Icon(Icons.add),
    ),
  );
}
```

<a id="state"></a>

## The three pillars: state management

Choose reactive Obx/GetX for values observed through .obs, or GetBuilder for explicit update notifications. Read the observable inside the reactive builder so GetX can track that dependency. A normal field mutation does not become reactive automatically. StatefulWidget remains appropriate for local widget lifecycle and Flutter resources.

```dart
class SimpleCounter extends GetxController {
  int count = 0;
  void increment() {
    count++;
    update();
  }
}

Widget simpleCounter() => GetBuilder<SimpleCounter>(
  init: SimpleCounter(),
  builder: (controller) => TextButton(
    onPressed: controller.increment,
    child: Text('${controller.count}'),
  ),
);
```

<a id="rx"></a>

## Reactive values, collections and models

Use .value to read/write Rx values. RxList, RxMap and RxSet notify through their collection operations. Empty constructors allocate independent mutable backing collections in this candidate; explicitly supplied collections keep their identity and mutability, including immutability restrictions. Snapshotting assignAll inputs makes self/aliased assignment safe.

Fields inside a custom model are not automatically observed. Return a replacement model from update() to notify observers without relying on protected notifier methods. Rx stream subscriptions can be canceled and recreated; close resources when their owner is finished.

```dart
class Person {
  Person({required this.name});
  String name;
}

void reactiveExamples() {
  final name = 'GetX'.obs;
  name.value = 'Hello';
  final enabled = false.obs;
  enabled.toggle();

  final items = RxList<int>()..add(1);
  final counters = RxMap<String, int>()..['visits'] = 1;
  final labels = RxSet<String>()..add('new');
  items.assignAll(items.where((value) => value > 0));

  final person = Person(name: 'Sara').obs;
  person.update((previous) => Person(name: '${previous!.name}!'));

  name.close();
  enabled.close();
  items.close();
  counters.close();
  labels.close();
  person.close();
}
```

<a id="workers"></a>

## Workers and cleanup

ever observes each change; once runs on the first matching change; debounce waits for a quiet interval; interval limits callback frequency. These are effects rather than UI builders. Retain their Worker handles and dispose them in onClose. Also cancel timers/stream subscriptions and dispose scroll or animation controllers that your controller creates. Do not keep a BuildContext in a long-lived service.

```dart
class SearchController extends GetxController {
  final query = ''.obs;
  final List<Worker> _workers = [];

  @override
  void onInit() {
    super.onInit();
    _workers.add(ever<String>(query, (value) => Get.log('query: $value')));
    _workers.add(once<String>(query, (value) => Get.log('first: $value')));
    _workers.add(debounce<String>(
      query, (value) => Get.log('search: $value'),
      time: const Duration(milliseconds: 300),
    ));
    _workers.add(interval<String>(
      query, (value) => Get.log('sample: $value'),
      time: const Duration(seconds: 1),
    ));
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    query.close();
    super.onClose();
  }
}
```

<a id="status"></a>

## StateMixin and asynchronous state

`StateMixin<T>` represents loading, success(data), empty and error states. In GetX 5 the successful status carries the value: use change(`GetStatus<T>.success(data)`) or setSuccess(data), not the old data-plus-RxStatus signature. Register NamesController through a binding before using NamesView.

futurize takes a function that creates a Future and returns void. With useEmpty:true (default), null or empty iterable/map/trimmed string becomes empty state; useEmpty:false retains successful empty data. Concurrent calls apply results in completion order, not latest-started-request order. Completion after controller disposal is ignored; application-level request cancellation/order still needs an explicit policy.

```dart
class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);
}

class NamesView extends GetView<NamesController> {
  const NamesView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: controller.obx(
      (names) => Text(names.join(', ')),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data'),
      onError: (error) => Text(error ?? 'Unknown error'),
    ),
  );
}
```

<a id="dependency"></a>

## The three pillars: dependency management

Get.put registers an instance immediately; Get.lazyPut registers a lazy singleton. Get.spawn registers a factory that creates a new instance for every Get.find, not a lazy singleton. Use the same type and tag for registration and lookup. Independent instances from a factory still need lifetime owners.

Get.spawn replaces the old global Get.create; Bind.create is a different, context-based local-binding API and must not be mechanically renamed. A spawn factory is permanent by default; that retains the factory, not a shared singleton. Use Get.delete with the intended tag/lifetime, and reserve forced removal/reset for deliberate cleanup.

```dart
class Repository {}

void dependencyExamples() {
  Get.put<Repository>(Repository(), tag: 'primary');
  final repository = Get.find<Repository>(tag: 'primary');
  assert(identical(repository, Get.find<Repository>(tag: 'primary')));

  Get.lazyPut<Repository>(() => Repository(), tag: 'lazy');
  Get.spawn<Repository>(() => Repository(), tag: 'factory');
  final first = Get.find<Repository>(tag: 'factory');
  final second = Get.find<Repository>(tag: 'factory');
  assert(!identical(first, second));
}
```

<a id="bindings"></a>

## Bindings, ownership and lifecycle

A Binding (singular) returns `List<Bind>`. Attach it with GetPage.bindings or the bindings argument of direct navigation. GetPage.binds accepts individual Bind values; GetMaterialApp.binds configures application dependencies. The deprecated plural Bindings and old initialBinding/BindingsBuilder recipes are not the current setup.

Default SmartManagement.full and binding ownership determine cleanup; permanent, fenix, autoRemove and factory registrations have different meanings. Shared binding owners retain a registration until its final relevant owner leaves. Replacement registrations must not be removed by stale owners. GetView resolves by lookup; it does not create a missing registration. Do not set every controller permanent to hide a disposal bug.

Lifecycle order includes onInit, post-frame onReady, and onClose. A deleted controller must not receive a late onReady. Test creation, ordinary app rebuilds, sharing, replacement, and final disposal.

```dart
class NamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<NamesController>(() => NamesController()),
  ];
}

Widget namesApplication() => GetMaterialApp(
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      page: () => const NamesView(),
      bindings: [NamesBinding()],
    ),
  ],
);
```

<a id="services"></a>

## GetxService and async initialization

GetxService shares controller lifecycle hooks but is intended for application-lifetime services. Ordinary deletion protects services; deliberate force/reset cleanup is still possible. It is not persistent storage across process death.

Get.putAsync is unavailable in this RC. Await initialization first, handle its errors, then register the resolved instance. Initialize dependencies in their required order before runApp. This example's settings values are illustrative; connect your own storage implementation.

```dart
class SettingsService extends GetxService {
  String language = 'en';

  Future<SettingsService> init() async {
    language = await Future<String>.value('en');
    return this;
  }
}

Future<void> startWithServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
  runApp(const CounterApp());
}
```

<a id="navigation"></a>

## The three pillars: route management

This RC routes through Navigator 2. Pass widget factories to Get.to, Get.off and Get.offAll. Named destinations must be registered in getPages. off replaces a destination; offAll removes previous history. Returning with Get.`back<T>` completes a matching typed result; system back/cancellation may return null. Keep navigation actions in UI events or suitable lifecycle callbacks, not every build.

```dart
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => Get.back<int>(result: 42),
      child: const Text('Return 42'),
    ),
  );
}

Future<int?> openDetails() async {
  final result = await Get.to<int>(() => const DetailsPage());
  return result;
}

Widget routedApplication() => GetMaterialApp(
  initialRoute: '/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(name: '/home', page: () => const CounterPage()),
    GetPage<int>(name: '/details', page: () => const DetailsPage()),
  ],
);

Future<int?> openNamedDetails() async => await Get.toNamed<int>('/details');
```

<a id="nested"></a>

## Nested routes, deep links and app configuration

Define child routes with GetPage.children, then render them through GetRouterOutlet. Nested delegate IDs are strings in this RC. An ID identifies a navigator/delegate, not a particular dialog. Register the matching hierarchy before navigating into it. The full example includes authentication redirects and nested dashboard/profile routes.

Path-URL hosting must serve the app entry point for child paths. Test cold deep links, refresh, parent/child bindings and browser back/forward on the actual host. GetMaterialApp.router and GetCupertinoApp.router accept supported custom router configurations. The default router also adapts routes maps; unsupported RouteFactory callbacks are reported explicitly. Theme/locale/settings and binding ownership survive ordinary app rebuilds.

```dart
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GetRouterOutlet(
      anchorRoute: '/shell',
      initialRoute: '/shell/home',
    ),
  );
}

Widget nestedApplication() => GetMaterialApp(
  initialRoute: '/shell/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(
      name: '/shell',
      page: () => const ShellPage(),
      children: [
        GetPage<void>(name: '/home', page: () => const CounterPage()),
      ],
    ),
  ],
);
```

<a id="overlays"></a>

## Dialogs, bottom sheets and snackbars

Pages and overlays have separate closing operations. Get.back returns pages in this RC; do not assume master's overlay-first behavior. Use the typed helper matching the overlay. closeOverlay closes the current dialog or sheet; closeCurrentSnackbar and closeAllSnackbars cover snackbar cleanup. backLegacy is a migration aid, not the recommended new closing API.

Create overlays only after the app/overlay has mounted. Optional Get.context/Get.overlayContext are null before mount and after teardown. Queued snackbar cancellation, swipe dismissal and teardown complete snackbar show futures and clean up controllers. A custom transition or PopScope policy still requires target-device testing.

```dart
Future<bool?> confirmAction() => Get.dialog<bool>(
  AlertDialog(
    title: const Text('Continue?'),
    actions: [
      TextButton(
        onPressed: () => Get.closeDialog<bool>(result: true),
        child: const Text('Yes'),
      ),
    ],
  ),
);

Future<int?> chooseValue() => Get.bottomSheet<int>(
  Material(
    child: TextButton(
      onPressed: () => Get.closeBottomSheet<int>(result: 7),
      child: const Text('Choose 7'),
    ),
  ),
);

void showMessage() {
  Get.snackbar('Saved', 'Your changes were saved');
}

void dismissMessage() => Get.closeCurrentSnackbar();
```

<a id="restoration"></a>

## Named-route history and restoration

Set an app restorationScopeId to opt the default GetDelegate into named-route history restoration. Give restorable pages stable, distinct restorationId values and use Flutter RestorationMixin/restorable properties for page data. With a custom delegate, set its restorationScopeId as well as the app scope.

History is stored in versioned RouteInformation.state; the URI keeps its ordinary meaning. Arguments support JSON-shaped null, bool, finite numbers, strings, lists and string-keyed maps, not widgets/controllers/closures/arbitrary model types. Limits are 128 history entries, argument depth 16, and 64 KiB for the encoded payload. Invalid/oversized/cyclic data, scope/page mismatch or rejected middleware falls back to guarded URI navigation.

Restored processes create fresh controllers and result completers. An awaiting Future from a dead process cannot resume. New typed navigation results work after restoration. Browser back/forward imports valid snapshots while retaining common live entries; a full browser reload on the tested bootstrap starts with the URI and does not guarantee restoration of the entire old stack. See the migration guide for precise fallback/guard behavior and the native harness for real process-death checks.

```dart
Widget restorableApplication() => GetMaterialApp(
  restorationScopeId: 'example-history',
  initialRoute: '/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(
      name: '/home',
      restorationId: 'home',
      page: () => const CounterPage(),
    ),
    GetPage<int>(
      name: '/details',
      restorationId: 'details',
      page: () => const DetailsPage(),
    ),
  ],
);
```

<a id="translations"></a>

## Internationalization and locale

Extend Translations with locale-keyed dictionaries. .tr translates a key; trParams substitutes named parameters; trPlural selects singular/plural keys with the supplied count (not a complete language-specific plural-rules engine). Configure locale and fallbackLocale on the app and call Get.updateLocale to change it. Get.deviceLocale reads the device locale.

For Flutter's own localized widgets, also configure flutter_localizations delegates and supportedLocales as required by your app. GetX key translations do not replace those delegates. Test RTL layout, fonts, number/date formatting and fallback behavior for the languages you ship.

```dart
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'greeting': 'Hello @name',
      'item': 'One item',
      'items': 'Many items',
    },
    'fa_IR': {
      'hello': 'سلام',
      'greeting': 'سلام @name',
      'item': 'یک مورد',
      'items': 'چند مورد',
    },
  };
}

Widget translatedApplication() => GetMaterialApp(
  translations: Messages(),
  locale: const Locale('fa', 'IR'),
  fallbackLocale: const Locale('en', 'US'),
  home: const TranslationPage(),
);

class TranslationPage extends StatelessWidget {
  const TranslationPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
      Text('hello'.tr),
      Text('greeting'.trParams({'name': 'Sara'})),
      Text('item'.trPlural('items', 2)),
    ]),
  );
}

Future<void> useEnglish() => Get.updateLocale(const Locale('en', 'US'));
```

<a id="themes"></a>

## Themes and application settings

Set theme, darkTheme and themeMode on GetMaterialApp; use Get.changeTheme/Get.changeThemeMode for live changes. Get.isDarkMode reflects the mounted app's effective theme. Avoid replacing bindings/controllers just to update a theme or locale. This branch preserves their ownership during ordinary app reconfiguration.

```dart
Widget themedApplication() => GetMaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
  home: const Scaffold(body: Text('Theme example')),
);

void toggleTheme() {
  Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
}

void followSystemTheme() => Get.changeThemeMode(ThemeMode.system);
```

<a id="http"></a>

## GetConnect: HTTP and uploads

Extend GetConnect for typed HTTP requests. post takes its body as a positional argument. Give a decoder that matches your API and check both status and nullable body before consuming it. URLs below are placeholders on example.com; they are not a running sample service. Do not embed private credentials in app source.

FormData/MultipartFile support uploads. Browser CORS and platform TLS/network policies still apply. Handle timeout, cancellation, decoding failures and non-success responses deliberately; successful transport is not automatically a successful application response.

```dart
class ApiUser {
  ApiUser(this.name);
  final String name;

  static ApiUser fromJson(dynamic data) =>
      ApiUser((data as Map<String, dynamic>)['name'] as String);
}

class UserProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response<ApiUser>> getUser(int id) =>
      get<ApiUser>('/users/$id', decoder: ApiUser.fromJson);

  Future<Response<dynamic>> createUser(String name) =>
      post<dynamic>('/users', {'name': name});

  Future<Response<dynamic>> uploadAvatar(List<int> bytes) =>
      post<dynamic>('/upload', FormData({
        'file': MultipartFile(bytes, filename: 'avatar.png'),
      }));
}
```

<a id="interceptors"></a>

## Modifiers, authentication and response handling

Request modifiers/authenticators return the request they want sent; response modifiers return the response to pass onward. Use modifier generics that accept the client’s response types; this mixed-endpoint example uses dynamic modifiers while getUser still decodes ApiUser. Keep a callback reference when you plan to remove it. removeResponseModifier now removes from the response collection without affecting request modifiers. The example below uses ApiUser from the previous section and a token supplied by your application's authentication service.

Set maxAuthRetries deliberately. A real token-refresh flow must handle refresh failure and avoid recursive authentication of its own refresh request. This candidate keeps asynchronous retry failures within their error-handling scope and honors replacement authentication requests.

```dart
import 'package:get/get_connect/http/src/request/request.dart';

void configureUserClient(UserProvider client, String Function() token) {
  client.httpClient.addRequestModifier<dynamic>((request) {
    request.headers['Accept'] = 'application/json';
    return request;
  });
  client.httpClient.addAuthenticator<dynamic>((request) {
    request.headers['Authorization'] = 'Bearer ${token()}';
    return request;
  });
  client.httpClient.maxAuthRetries = 2;

  Response<dynamic> observeResponse(
    Request<dynamic> request, Response<dynamic> response,
  ) {
    Get.log('HTTP status: ${response.statusCode}');
    return response;
  }

  client.httpClient.addResponseModifier<dynamic>(observeResponse);
  client.httpClient.removeResponseModifier<dynamic>(observeResponse);
}

Future<String?> readUserName(UserProvider client) async {
  final response = await client.getUser(1);
  if (response.isOk && response.body != null) {
    return response.body!.name;
  }
  return null;
}
```

<a id="socket"></a>

## WebSockets and disposal

Use ws:// or wss:// endpoints and define an application protocol for messages. GetSocket supports open/message/close/error callbacks. Own the socket and dispose it when finished; replacing a connection must release the old one and its heartbeat/subscriptions. This candidate tests text and binary transport in real JS/WASM browsers as well as IO sockets. It does not make a server's TLS/CORS setup automatic.

```dart
class ChatController extends GetxController {
  final client = GetConnect();
  late final GetSocket connection;

  @override
  void onInit() {
    super.onInit();
    connection = client.socket('wss://example.com/chat');
    connection.onOpen(() => connection.send('hello'));
    connection.onMessage((message) => Get.log('message: $message'));
    connection.onError((error) => Get.log('socket: $error', isError: true));
    connection.connect();
  }

  @override
  void onClose() {
    connection.dispose();
    client.onClose();
    super.onClose();
  }
}
```

<a id="middleware"></a>

## GetPage middleware

Attach concrete subclasses of GetMiddleware to GetPage.middlewares; GetMiddleware itself is abstract. Lower priority numbers run first. For the Navigator 2 delegate, override redirectDelegate: return the incoming RouteDecoder to continue, another decoder to redirect, or null to cancel. Ensure the login route is registered and does not use a guard that redirects to itself. Middleware also guards restored histories.

The page lifecycle hooks are onPageCalled(GetPage?), generic `onBindingsStart<R>`(`List<R>`?), onPageBuildStart(GetPageBuilder?), onPageBuilt(Widget) and onPageDispose(). Keep nullable/generic signatures when overriding; do not insert an arbitrary Binding into a list whose element type is R. Prefer explicit route bindings for DI changes. The legacy redirect(String?) RouteSettings hook is different from redirectDelegate; overriding only the former is not the Navigator 2 guard recipe.

```dart
class AuthService extends GetxService {
  final authed = false.obs;
}

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({super.priority});

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final auth = Get.find<AuthService>();
    return auth.authed.value ? route : RouteDecoder.fromRoute('/login');
  }
}

class PageLifecycleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Protected');

  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() => Get.log('Page disposed');
}
```

<a id="advanced"></a>

## Advanced navigation, platform and context APIs

Get.arguments, Get.parameters, Get.currentRoute, Get.previousRoute and Get.routing expose the configured router's current state. removeRoute takes a route name; until takes a predicate over GetPage. Do not copy empty-argument shorthand as executable calls.

Use GetPlatform for platform flags, and a mounted BuildContext's size/media-query getters for responsive UI. context.mediaQuerySize and context.orientation are getters, not methods. context.textScaleFactor returns TextScaler on this SDK. Get.context and Get.overlayContext are nullable outside the app lifetime; strict root-controller access still requires a mounted GetX root. Do not retain those contexts across disposal/async gaps.

```dart
String environmentSummary(BuildContext context) {
  final size = context.mediaQuerySize;
  final padding = context.mediaQueryPadding;
  final orientation = context.orientation;
  final scaledText = context.textScaleFactor.scale(16);
  return '${GetPlatform.isWeb}: $size, $padding, $orientation, $scaledText';
}

void returnToHome() => Get.until((page) => page.name == '/home');
void removeDetails() => Get.removeRoute('/details');
```

<a id="configuration"></a>

## Global settings, logging and custom routers

Configure supported options on GetMaterialApp/GetCupertinoApp rather than the removed Get.config recipe. routingCallback observes route changes, and logWriterCallback redirects GetX logs; treat the callback's isError flag appropriately. A callback can receive logs even when console logging is disabled, so apply your own filtering/redaction policy.

For a custom RouterConfig/delegate, use the app's router constructor and wire its configuration consistently. A bare MaterialApp with only Get.key/GetObserver is not equivalent to setting up this RC's Navigator 2 root, bindings and overlays.

```dart
Widget configuredApplication() => GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 250),
  popGesture: true,
  logWriterCallback: localLogWriter,
  routingCallback: (routing) {
    if (routing != null) {
      debugPrint('Route: ${routing.current}');
    }
  },
  home: const Scaffold(body: Text('Configuration')),
);

void localLogWriter(String text, {bool isError = false}) {
  debugPrint('${isError ? "ERROR" : "GETX"}: $text');
}
```

<a id="local"></a>

## Local state widgets: ValueBuilder and ObxValue

ValueBuilder owns a local value updated through its callback; ObxValue rebuilds from an Rx value. These are useful for switches, expansion state or a local selected index. They do not require moving every small interaction into a global controller. Choose an owner and cleanup policy for externally supplied Rx values.

```dart
Widget localSwitch() => ValueBuilder<bool>(
  initialValue: false,
  builder: (value, update) => Switch(value: value, onChanged: update),
);

Widget reactiveSwitch(RxBool value) => ObxValue<RxBool>(
  (data) => Switch(
    value: data.value,
    onChanged: (next) => data.value = next,
  ),
  value,
);
```

<a id="views"></a>

## GetView, GetWidget and responsive views

`GetView<T>` is a stateless view with a controller getter using Get.`find<T>`; the counter example uses it. `GetWidget<T>` caches a controller for that widget instance, useful with Get.spawn per-find factories. It does not make a registration permanent; its factory-created controller is closed when its owning widget is removed. Select it deliberately rather than assuming every lookup is cached.

GetResponsiveView provides screen dimensions/type and builder/desktop/tablet/phone/watch methods. Use alwaysUseBuilder:false to select device-specific builders and configure ResponsiveScreenSettings thresholds where needed. A matching screen type must have a builder or valid fallback. Context dimensions can change on resize; a platform flag alone is not a layout breakpoint.

```dart
class ResponsivePage extends GetResponsiveView<CounterController> {
  ResponsivePage({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const Center(child: Text('Compact layout'));

  @override
  Widget tablet() => const Center(child: Text('Tablet layout'));

  @override
  Widget desktop() => const Center(child: Text('Wide layout'));
}

class ItemController extends GetxController {
  final label = 'Item'.obs;
}

void registerItemFactory() => Get.spawn<ItemController>(() => ItemController());

class ItemView extends GetWidget<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Text(controller.label.value));
}
```

<a id="queue"></a>

## Queued work and cancellation

GetQueue runs jobs sequentially and forwards original errors/stack traces without stopping later jobs. cancelAllJobs drops jobs that have not started; the active job continues. Futures for dropped jobs remain pending, so it is not an awaitable cancellation-result API. Do not await discarded futures expecting an automatic cancellation exception. Snackbar queues manage their own completion separately.

```dart
Future<int> queuedCalculation() async {
  final queue = GetQueue();
  final first = queue.add<int>(() async => 20);
  final second = queue.add<int>(() => 22);
  return await first + await second;
}
```

<a id="tests"></a>

## Testing controllers, widgets and platforms

Use flutter_test for Flutter-dependent controllers/widgets and reset global GetX registrations between tests. The following belongs in a test file and uses CounterController/CounterApp from your application, not copied duplicate production definitions. In isolated controller tests with navigation, Get.testMode can suppress navigation side effects; it does not replace a mounted router when testing actual navigation.

Test DI lifecycle, route results/guards, disposal and error paths as well as visible values. Prefer fakes for your own interfaces; if a mocking package is already used, follow its current setup rather than adding it just for GetX. Root tests do not recurse into the independent example packages. Native back/predictive gestures and process-death restoration need their actual device/emulator harnesses; CI APK/harness compilation alone is not a native acceptance run.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_app/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('counter increments', (tester) async {
    await tester.pumpWidget(const CounterApp());
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('dependency lookup returns the registered instance', () {
    final controller = Get.put(CounterController());
    controller.increment();
    expect(Get.find<CounterController>(), same(controller));
    expect(controller.count.value, 1);
  });
}
```

<a id="migration"></a>

## Migrating from earlier GetX releases

Review the complete [GetX 4 → 5 migration guide](documentation/en_US/migration_guide_5.md), then migrate behavior as well as syntax:

| Earlier recipe | This RC |
|---|---|
| Global `Get.create` factory | `Get.spawn`, same type/tag on lookup |
| `Get.putAsync` | Await initialization, then `Get.put` |
| `initialBinding` / `BindingsBuilder` | App `binds`; route `Binding` returning `List<Bind>` |
| `change(data, status: RxStatus.success())` | `change(GetStatus<T>.success(data))` / `setSuccess(data)` |
| Widget instances in direct navigation | Page factories such as `Get.to(() => Page())` |
| One `Get.back` recipe for every popup | Explicit dialog/sheet/snackbar helpers; `Get.back` for pages |
| Navigator 1 nested-key recipe | `GetPage.children` + `GetRouterOutlet`, string IDs |
| Global `Get.config` | App constructor settings / supported custom router setup |

For historical GetX 2 migrations, StringX/IntX/MapX/ListX/NumX/DoubleX became RxString/RxInt/RxMap/RxList/RxNum/RxDouble, and namedRoutes/GetRoute recipes became getPages/GetPage with page factories. These are historical notes, not supported old constructors to copy into current code.

<a id="changes"></a>

## Changes included in this candidate

This candidate stabilizes the selected RC contracts, not every historical upstream issue. See the [CHANGELOG](CHANGELOG.md) and [release scope / master reconciliation](documentation/en_US/release_scope_5.md) for the complete record.

- **State and DI:** recover Rx stream subscriptions after cancellation, handle aliased collection assignment, fresh mutable default Rx collections, safer controller readiness/disposal, binding ownership/replacement and StateMixin completion after disposal.
- **Navigation and app:** typed result completion for displaced routes, middleware before history replacement, nested routes, back vetoes, optional contexts, explicit overlay closing, snackbar queue/timer/swipe cleanup, Cupertino sheet transitions and forwarded app configuration.
- **Restoration:** opt-in bounded named-route history with validated arguments and middleware; fresh controllers/completers after process recovery; native probes check real cold restoration and new typed results.
- **Networking:** correct modifier removal, authentication replacement/retry handling, IO/browser timeout/abort/decoding errors, WebSocket reconnection, JS text/binary transport and disposal.
- **SDK/hosts:** Flutter 3.47.9 / Dart 3.13.7 baseline, current Android host and iOS scene lifecycle, TickerMode settings and memory/accessibility callbacks.
- **Verification/docs:** unit/widget regressions, independent example packages, real Chrome JS/WASM transport/history checks, native harnesses, current migration docs and comprehensive English/Persian READMEs with updated translated recipes.

Master changes were selected by behavior; standalone UI public-type migration and a different Get.back contract were not blindly merged. Existing upstream PRs and source attribution are recorded in the release scope and stabilization PR.

<a id="limitations"></a>

## Known limits and support boundaries

On Flutter 3.47.9, the web engine can decode percent-encoded route characters while writing browser history: `?tag=a%2Bb` becomes `?tag=a+b`, and refresh can turn the intended `a+b` into `a b`. A pure Flutter control without GetX reproduces the loss. It is an SDK limitation; no global double-encoding or raw browser-history workaround is applied. Flutter documents preservation for 3.50 or later, but that is not a claim that this project has validated that SDK.

The strict encoded-query gate is a separate manual diagnostic; green ordinary web CI does not claim it fixed. Full browser reload's URI-only startup is a separate history-restoration boundary. See the [browser harness](example_nav2/test/browser/README.md) for exact commands and evidence.

Native acceptance is scoped to the tested transition/host/OS configuration. The example hosts require Android API 24+ and iOS 15+; these are host minima, not universal platform guarantees for every app. Unreproduced old issues, additional SDK/host combinations and standalone UI migration remain follow-up work. New regressions in selected contracts still require assessment before publication.

<a id="examples"></a>

## Examples and verification commands

The independent [example](example/README.md) and [Navigator 2 example](example_nav2/README.md) use this checkout through path dependencies. Run checks in each package. Commands below do not install or upgrade an SDK; offline resolution additionally requires cached dependencies. Use an installed target with flutter run when checking an app interactively.

The [workflow](.github/workflows/main.yml) pins the selected SDK and performs analyzer/tests, Chrome transport/navigation checks, web JS/WASM builds, Android APK build and native-harness compilation. Check the run for the exact revision you consume. The [device guide](example_nav2/test/device/README.md) and [Android emulator guide](example_nav2/test/device/android/README.md) describe back, predictive gestures, process-death restoration and artifact identity checks.

```sh
flutter --version
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test

cd example
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test

cd ../example_nav2
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test
```

<a id="why"></a>

## Why GetX and its ecosystem

GetX offers a consistent way to connect state, DI and navigation while allowing separate use of the modules. Controllers separate presentation logic from widgets; bindings expose ownership; reactive builders update observed UI. These are design tools, not a promise of automatic correctness, minimum memory or compatibility with every future Flutter release. Choose and measure what suits your application.

Related projects include [Get CLI](https://github.com/jonataslaw/get_cli), [Get Server](https://github.com/jonataslaw/get_server), the [VS Code snippets](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) and [Android Studio/IntelliJ plugin](https://plugins.jetbrains.com/plugin/14975-getx-snippets). They are separately versioned tools: verify their compatibility before using generated code. Persistence packages and backend services are not bundled storage guarantees of GetX.

<a id="community"></a>

## Community, contribution and license

Ask usage questions through community channels and report reproducible library defects in this repository. Existing channels include [Discord](https://discord.com/invite/9Hpt99N), [Slack](https://communityinviter.com/apps/getxworkspace/getx) and [Telegram](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g).

Contributions can improve runtime behavior, tests, examples, docs and translations. Before proposing a fix, check existing issues/PRs, include a minimal reproducer, state the actual GetX/Flutter/Dart versions and platform, add a focused regression and run relevant root/example checks. Update the public guide where a contract changes. Preserve module ownership rather than hiding lifecycle bugs with permanent registrations.

The project is distributed under the [MIT license](LICENSE). The English and Persian READMEs share the same guide topics and code examples; translated READMEs retain their explanations with current RC recipes integrated into their text.

## Articles and videos

Previously listed community resources are retained for further reading. They may show older APIs or separately versioned tools; reconcile their examples with this branch’s migration guide.


- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - Tutorial by [Pesa Coder](https://github.com/UsamaElgendy).
- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman).
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Dependency Injection by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter.
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - by [Roi Peker](https://github.com/roipeker)
- [GetConnect: The best way to perform API operations in Flutter with Get.](https://absyz.com/getconnect-the-best-way-to-perform-api-operations-in-flutter-with-getx/) - by [MD Sarfaraj](https://github.com/socialmad)
- [How To Create an App with GetX Architect in Flutter with Get CLI](https://www.youtube.com/watch?v=7mb4qBA7kTk&t=1380s) - by [MD Sarfaraj](https://github.com/socialmad)

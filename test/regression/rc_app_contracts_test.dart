import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Widget app(bool cupertino,
    {Widget? home,
    Map<String, WidgetBuilder> routes = const {},
    String? initialRoute,
    List<GetPage>? getPages,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    InitialRouteListFactory? onGenerateInitialRoutes,
    ThemeData? theme,
    ThemeData? darkTheme,
    ThemeMode themeMode = ThemeMode.system,
    Locale? locale,
    VoidCallback? onInit,
    bool? popGesture,
    bool? opaqueRoute,
    Duration? transitionDuration,
    List<Bind> binds = const []}) {
  if (cupertino) {
    return GetCupertinoApp(
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        getPages: getPages,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        locale: locale,
        supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
        onInit: onInit,
        popGesture: popGesture,
        opaqueRoute: opaqueRoute,
        transitionDuration: transitionDuration,
        binds: binds);
  }
  return GetMaterialApp(
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      getPages: getPages,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
      onInit: onInit,
      popGesture: popGesture,
      opaqueRoute: opaqueRoute,
      transitionDuration: transitionDuration,
      binds: binds);
}

void main() {
  tearDown(() {
    Get.reset();
    Get.locale = null;
    Get.fallbackLocale = null;
  });
  for (final cupertino in [false, true]) {
    final family = cupertino ? 'Cupertino' : 'Material';
    testWidgets('$family adapts simple route builders to declarative pages',
        (tester) async {
      await tester.pumpWidget(app(cupertino, initialRoute: '/', routes: {
        '/': (_) => const Center(child: Text('map root')),
        '/detail': (context) => Center(child: Text('detail:${Get.arguments}')),
      }));
      await tester.pumpAndSettle();
      expect(find.text('map root'), findsOneWidget);
      final result = <String?>[];
      Get.toNamed<String>('/detail', arguments: 'argument')!.then(result.add);
      await tester.pumpAndSettle();
      expect(find.text('detail:argument'), findsOneWidget);
      Get.back<String>(result: 'returned');
      await tester.pumpAndSettle();
      expect(result, ['returned']);
      expect(find.text('map root'), findsOneWidget);
    });

    testWidgets(
        '$family combines home, routes and GetPages without losing entries',
        (tester) async {
      await tester.pumpWidget(app(cupertino,
          home: const Center(child: Text('home')),
          routes: {
            '/map': (_) => const Center(child: Text('map'))
          },
          getPages: [
            GetPage(
                name: '/declared',
                page: () => const Center(child: Text('declared')))
          ]));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
      Get.toNamed('/map');
      await tester.pumpAndSettle();
      expect(find.text('map'), findsOneWidget);
      Get.toNamed('/declared');
      await tester.pumpAndSettle();
      expect(find.text('declared'), findsOneWidget);
    });

    for (final callback in [
      'onGenerateRoute',
      'onUnknownRoute',
      'onGenerateInitialRoutes'
    ]) {
      testWidgets(
          '$family explicitly rejects unsupported $callback instead of ignoring it',
          (tester) async {
        await tester.pumpWidget(app(cupertino,
            home: const SizedBox.shrink(),
            onGenerateRoute: callback == 'onGenerateRoute' ? (_) => null : null,
            onUnknownRoute: callback == 'onUnknownRoute' ? (_) => null : null,
            onGenerateInitialRoutes:
                callback == 'onGenerateInitialRoutes' ? (_) => [] : null));
        expect(
            tester.takeException(),
            isA<UnsupportedError>().having((error) => error.message,
                'migration guidance', contains('getPages')));
      });
    }

    testWidgets('$family applies navigation defaults', (tester) async {
      await tester.pumpWidget(app(cupertino,
          home: const SizedBox.shrink(),
          popGesture: true,
          opaqueRoute: false,
          transitionDuration: const Duration(milliseconds: 41)));
      await tester.pumpAndSettle();
      expect(Get.defaultPopGesture, isTrue);
      expect(Get.defaultOpaqueRoute, isFalse);
      expect(Get.defaultTransitionDuration, const Duration(milliseconds: 41));
    });
  }

  for (final cupertino in [false, true]) {
    testWidgets(
        '${cupertino ? 'Cupertino' : 'Material'} builder precedence and explicit initial route are deterministic',
        (tester) async {
      await tester.pumpWidget(app(cupertino,
          home: const Center(child: Text('home winner')),
          initialRoute: '/map',
          routes: {
            '/': (_) => const Center(child: Text('shadow home')),
            '/map': (_) => const Center(child: Text('map winner'))
          },
          getPages: [
            GetPage(
                name: '/map',
                page: () => const Center(child: Text('shadow map')))
          ]));
      await tester.pumpAndSettle();
      expect(find.text('map winner'), findsOneWidget);
      Get.toNamed('/');
      await tester.pumpAndSettle();
      expect(find.text('home winner'), findsOneWidget);
      expect(find.text('shadow home'), findsNothing);
    });

    testWidgets(
        '${cupertino ? 'Cupertino' : 'Material'} inline page definitions survive ordinary parent config rebuilds',
        (tester) async {
      Widget build(Locale locale, bool gesture) => app(cupertino,
          getPages: [
            GetPage(
                name: '/root', page: () => const Center(child: Text('root'))),
            GetPage(
                name: '/detail',
                page: () => const Center(child: Text('detail')))
          ],
          locale: locale,
          popGesture: gesture,
          opaqueRoute: !gesture,
          transitionDuration: Duration(milliseconds: gesture ? 41 : 82));
      await tester.pumpWidget(build(const Locale('en', 'US'), true));
      await tester.pumpAndSettle();
      final delegate = Get.rootController.rootDelegate;
      final results = <String?>[];
      Get.toNamed<String>('/detail')!.then(results.add);
      await tester.pumpAndSettle();
      await tester.pumpWidget(build(const Locale('en', 'GB'), false));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(Get.rootController.rootDelegate, same(delegate));
      expect(Get.currentRoute, '/detail');
      expect(Get.defaultPopGesture, isFalse);
      expect(Get.defaultOpaqueRoute, isTrue);
      expect(Get.defaultTransitionDuration, const Duration(milliseconds: 82));
      Get.back<String>(result: 'kept');
      await tester.pumpAndSettle();
      expect(results, ['kept']);
    });
  }

  testWidgets(
      'parent theme and locale updates preserve navigation and root ownership',
      (tester) async {
    final pages = [
      GetPage(name: '/root', page: () => const Scaffold(body: Text('root'))),
      GetPage(name: '/detail', page: () => const Scaffold(body: Text('detail')))
    ];
    var initCalls = 0;
    final light =
        ThemeData(brightness: Brightness.light, primaryColor: Colors.red);
    final dark =
        ThemeData(brightness: Brightness.dark, primaryColor: Colors.green);
    Widget build(ThemeMode mode, Locale locale) => app(false,
        getPages: pages,
        theme: light,
        darkTheme: dark,
        themeMode: mode,
        locale: locale,
        onInit: () => initCalls++);
    await tester.pumpWidget(build(ThemeMode.light, const Locale('en', 'US')));
    await tester.pumpAndSettle();
    final delegate = Get.rootController.rootDelegate;
    final queue = Get.rootController.config.snackBarQueue;
    final results = <String?>[];
    Get.toNamed<String>('/detail')!.then(results.add);
    await tester.pumpAndSettle();
    await tester.pumpWidget(build(ThemeMode.dark, const Locale('en', 'GB')));
    await tester.pumpAndSettle();
    expect(Get.theme.brightness, Brightness.dark);
    expect(Get.locale, const Locale('en', 'GB'));
    expect(Get.rootController.rootDelegate, same(delegate));
    expect(Get.rootController.config.snackBarQueue, same(queue));
    expect(Get.currentRoute, '/detail');
    expect(initCalls, 1);
    expect(results, isEmpty);
    Get.back<String>(result: 'preserved');
    await tester.pumpAndSettle();
    expect(results, ['preserved']);
  });

  testWidgets('changing theme at runtime preserves the active snackbar queue',
      (tester) async {
    await tester
        .pumpWidget(app(false, home: const Scaffold(body: Text('home'))));
    await tester.pumpAndSettle();
    final queue = Get.rootController.config.snackBarQueue;
    final snackbar = Get.rawSnackbar(message: 'active', duration: null);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    Get.changeTheme(ThemeData(primaryColor: Colors.blue));
    await tester.pump();
    expect(Get.rootController.config.snackBarQueue, same(queue));
    expect(Get.isSnackbarOpen, isTrue);
    await snackbar.close(withAnimations: false);
    await tester.pump();
    expect(Get.isSnackbarOpen, isFalse);
  });

  testWidgets(
      'clearing declared themes restores fallback and preserves runtime overrides on unrelated rebuilds',
      (tester) async {
    const home = Scaffold(body: Text('home'));
    final declared = ThemeData(primaryColor: Colors.red);
    final runtime = ThemeData(primaryColor: Colors.blue);
    final replacement = ThemeData(primaryColor: Colors.green);
    final dark = ThemeData(brightness: Brightness.dark);
    await tester
        .pumpWidget(app(false, home: home, theme: declared, darkTheme: dark));
    await tester.pumpAndSettle();
    Get.changeTheme(runtime);
    await tester.pumpAndSettle();
    await tester.pumpWidget(app(false,
        home: home,
        theme: declared,
        darkTheme: dark,
        locale: const Locale('en', 'GB')));
    await tester.pumpAndSettle();
    expect(Get.theme.primaryColor, runtime.primaryColor);
    await tester.pumpWidget(
        app(false, home: home, theme: replacement, darkTheme: dark));
    await tester.pumpAndSettle();
    expect(Get.theme.primaryColor, replacement.primaryColor);
    await tester.pumpWidget(app(false, home: home));
    await tester.pumpAndSettle();
    expect(Get.rootController.config.theme, isNull);
    expect(Get.rootController.config.darkTheme, isNull);
    expect(Get.rootController.config.locale, isNull);
    expect(Get.locale, isNull);
  });

  for (final cupertino in [false, true]) {
    testWidgets(
        '${cupertino ? 'Cupertino' : 'Material'} app binds retain scoped controllers during config updates',
        (tester) async {
      final controller = _AppController();
      final binds = [Bind.create<_AppController>((_) => controller)];
      final home = Builder(
          builder: (context) => Center(
              child: Text('bound:${context.get<_AppController>().value}')));
      await tester.pumpWidget(app(cupertino,
          home: home, binds: binds, locale: const Locale('en', 'US')));
      await tester.pumpAndSettle();
      expect(find.text('bound:42'), findsOneWidget);
      expect(controller.inits, 1);
      await tester.pumpWidget(app(cupertino,
          home: home, binds: binds, locale: const Locale('en', 'GB')));
      await tester.pumpAndSettle();
      expect(find.text('bound:42'), findsOneWidget);
      expect(controller.inits, 1);
      expect(controller.closes, 0);
      expect(Get.locale, const Locale('en', 'GB'));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(controller.closes, 1);
    });
  }

  testWidgets('Cupertino initialBinding executes once before onInit',
      (tester) async {
    final binding = _InitialBinding();
    var initCalls = 0;
    Widget build(Locale locale) => GetCupertinoApp(
        home: const SizedBox.shrink(),
        locale: locale,
        initialBinding: binding,
        onInit: () {
          initCalls++;
          expect(Get.isRegistered<_GlobalController>(), isTrue);
        });
    await tester.pumpWidget(build(const Locale('en', 'US')));
    await tester.pumpAndSettle();
    expect(binding.calls, 1);
    await tester.pumpWidget(build(const Locale('en', 'GB')));
    await tester.pumpAndSettle();
    expect(binding.calls, 1);
    expect(initCalls, 1);
  });
  for (final cupertino in [false, true]) {
    testWidgets(
        '${cupertino ? 'Cupertino' : 'Material'} incoming platform deep link takes precedence over initialRoute',
        (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = '/deep';
      addTearDown(
          tester.binding.platformDispatcher.clearDefaultRouteNameTestValue);
      await tester.pumpWidget(app(cupertino,
          home: const Center(child: Text('root')),
          initialRoute: '/configured',
          routes: {
            '/configured': (_) => const Center(child: Text('configured')),
            '/deep': (_) => const Center(child: Text('incoming'))
          }));
      await tester.pumpAndSettle();
      expect(find.text('incoming'), findsOneWidget);
      expect(Get.currentRoute, '/deep');
    });
  }

  testWidgets('custom route information provider stays caller-owned',
      (tester) async {
    final provider = _TrackingProvider('/deep');
    await tester.pumpWidget(
        GetMaterialApp.router(routeInformationProvider: provider, getPages: [
      GetPage(
          name: '/deep',
          page: () => const Center(child: Text('external provider')))
    ]));
    await tester.pumpAndSettle();
    expect(find.text('external provider'), findsOneWidget);
    expect(Get.rootController.config.routeInformationProvider, same(provider));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(provider.disposed, isFalse);
    provider.dispose();
  });

  testWidgets(
      'generated initial route provider survives parent rebuild and is disposed with root',
      (tester) async {
    Widget build(Locale locale) => app(false,
        home: const Center(child: Text('root')),
        initialRoute: '/configured',
        routes: {'/configured': (_) => const Center(child: Text('configured'))},
        locale: locale);
    await tester.pumpWidget(build(const Locale('en', 'US')));
    await tester.pumpAndSettle();
    final provider = Get.rootController.config.routeInformationProvider!;
    await tester.pumpWidget(build(const Locale('en', 'GB')));
    await tester.pumpAndSettle();
    expect(Get.rootController.config.routeInformationProvider, same(provider));
    expect(find.text('configured'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(() => provider.addListener(() {}), throwsFlutterError);
  });
  testWidgets('removing the declared transition restores the theme default',
      (tester) async {
    final theme = ThemeData(
        platform: TargetPlatform.android,
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()}));
    const home = Scaffold();
    await tester.pumpWidget(GetMaterialApp(
        home: home, theme: theme, defaultTransition: Transition.fade));
    await tester.pumpAndSettle();
    final delegate = Get.rootController.rootDelegate;
    expect(Get.defaultTransition, Transition.fade);
    await tester.pumpWidget(GetMaterialApp(home: home, theme: theme));
    await tester.pumpAndSettle();
    expect(Get.defaultTransition, Transition.zoom);
    expect(Get.rootController.rootDelegate, same(delegate));
  });

  testWidgets('transition removal uses the newly declared active dark theme',
      (tester) async {
    final light = ThemeData(
        platform: TargetPlatform.android,
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()}));
    final dark = ThemeData(
        brightness: Brightness.dark,
        platform: TargetPlatform.android,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
        }));
    const home = Scaffold();
    await tester.pumpWidget(GetMaterialApp(
        home: home, theme: light, defaultTransition: Transition.rightToLeft));
    await tester.pumpAndSettle();
    await tester.pumpWidget(GetMaterialApp(
        home: home, theme: light, darkTheme: dark, themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();
    expect(Get.defaultTransition, Transition.fade);
  });

  testWidgets('transition removal can clear an unrecognized theme transition',
      (tester) async {
    final theme = ThemeData(
        platform: TargetPlatform.android,
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: {TargetPlatform.android: _CustomTransitions()}));
    const home = Scaffold();
    await tester.pumpWidget(GetMaterialApp(
        home: home, theme: theme, defaultTransition: Transition.fade));
    await tester.pumpAndSettle();
    await tester.pumpWidget(GetMaterialApp(home: home, theme: theme));
    await tester.pumpAndSettle();
    expect(Get.defaultTransition, isNull);
  });

  testWidgets('unchanged declared transition preserves a runtime override',
      (tester) async {
    const home = Scaffold();
    await tester.pumpWidget(
        const GetMaterialApp(home: home, defaultTransition: Transition.fade));
    await tester.pumpAndSettle();
    final root = Get.rootController;
    root.config =
        root.config.copyWith(defaultTransition: Transition.rightToLeft);
    await tester.pumpWidget(GetMaterialApp(
        home: home,
        defaultTransition: Transition.fade,
        theme: ThemeData(primaryColor: Colors.green)));
    await tester.pumpAndSettle();
    expect(Get.defaultTransition, Transition.rightToLeft);
  });
}

class _AppController extends GetxController {
  final value = 42;
  int inits = 0;
  int closes = 0;
  @override
  void onInit() {
    inits++;
    super.onInit();
  }

  @override
  void onClose() {
    closes++;
    super.onClose();
  }
}

class _GlobalController extends GetxController {}

class _InitialBinding implements BindingsInterface<void> {
  int calls = 0;
  @override
  void dependencies() {
    calls++;
    Get.put(_GlobalController());
  }
}

class _TrackingProvider extends PlatformRouteInformationProvider {
  _TrackingProvider(String route)
      : super(initialRouteInformation: RouteInformation(uri: Uri.parse(route)));
  bool disposed = false;
  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

class _CustomTransitions extends PageTransitionsBuilder {
  const _CustomTransitions();
  @override
  Widget buildTransitions<T>(
          PageRoute<T> route,
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      child;
}

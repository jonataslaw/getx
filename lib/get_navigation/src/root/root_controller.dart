import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get.dart';

class ConfigData {
  final ValueChanged<Routing?>? routingCallback;
  final Transition? defaultTransition;
  final bool? opaqueRoute;
  final VoidCallback? onInit;
  final VoidCallback? onReady;
  final VoidCallback? onDispose;
  final bool? enableLog;
  final LogWriterCallback? logWriterCallback;
  final bool? popGesture;
  final SmartManagement smartManagement;
  final List<Bind> binds;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final List<NavigatorObserver>? navigatorObservers;
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Map<String, Map<String, String>>? translationsKeys;
  final Translations? translations;
  final Locale? locale;
  final Locale? fallbackLocale;
  final String? initialRoute;
  final CustomTransition? customTransition;
  final Widget? home;

  ConfigData({
    required this.routingCallback,
    required this.defaultTransition,
    required this.opaqueRoute,
    required this.onInit,
    required this.onReady,
    required this.onDispose,
    required this.enableLog,
    required this.logWriterCallback,
    required this.popGesture,
    required this.smartManagement,
    required this.binds,
    required this.transitionDuration,
    required this.defaultGlobalState,
    required this.getPages,
    required this.unknownRoute,
    required this.routeInformationProvider,
    required this.routeInformationParser,
    required this.routerDelegate,
    required this.backButtonDispatcher,
    required this.navigatorObservers,
    required this.navigatorKey,
    required this.scaffoldMessengerKey,
    required this.translationsKeys,
    required this.translations,
    required this.locale,
    required this.fallbackLocale,
    required this.initialRoute,
    required this.customTransition,
    required this.home,
  });
}

class GetMaterialController extends FullLifeCycleController {
  GetMaterialController(this.config);

  static GetMaterialController get to {
    return Get.find();
  }

  late final RouterDelegate<Object> routerDelegate;
  late final RouteInformationParser<Object> routeInformationParser;
  final ConfigData config;

  @override
  void onReady() {
    config.onReady?.call();
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();

    if (config.getPages == null && config.home == null) {
      throw 'You need add pages or home';
    }

    routerDelegate = config.routerDelegate ??
        createDelegate(
          pages: config.getPages ??
              [
                GetPage(
                  name: cleanRouteName("/${config.home.runtimeType}"),
                  page: () => config.home!,
                ),
              ],
          notFoundRoute: config.unknownRoute,
          navigatorKey: config.navigatorKey,
          navigatorObservers: (config.navigatorObservers == null
              ? <NavigatorObserver>[
                  GetObserver(config.routingCallback, Get.routing)
                ]
              : <NavigatorObserver>[
                  GetObserver(config.routingCallback, routing),
                  ...config.navigatorObservers!
                ]),
        );

    routeInformationParser = config.routeInformationParser ??
        createInformationParser(
          initialRoute: config.initialRoute ??
              config.getPages?.first.name ??
              cleanRouteName("/${config.home.runtimeType}"),
        );

    if (config.locale != null) Get.locale = config.locale;

    if (config.fallbackLocale != null) {
      Get.fallbackLocale = config.fallbackLocale;
    }

    if (config.translations != null) {
      Get.addTranslations(config.translations!.keys);
    } else if (config.translationsKeys != null) {
      Get.addTranslations(config.translationsKeys!);
    }

    customTransition = config.customTransition;

    //Get.setDefaultDelegate(routerDelegate);
    Get.smartManagement = config.smartManagement;
    config.onInit?.call();

    Get.isLogEnable = config.enableLog ?? kDebugMode;
    Get.log = config.logWriterCallback ?? defaultLogWriterCallback;
    defaultTransition = config.defaultTransition;
    defaultOpaqueRoute = config.opaqueRoute ?? true;
    defaultPopGesture = config.popGesture ?? GetPlatform.isIOS;
    defaultTransitionDuration =
        config.transitionDuration ?? Duration(milliseconds: 300);

    // defaultTransitionCurve = Curves.easeOutQuad;
    // defaultDialogTransitionCurve = Curves.easeOutQuad;
    // defaultDialogTransitionDuration = Duration(milliseconds: 300);
  }

  String cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  bool testMode = false;
  Key? unikey;
  ThemeData? theme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;
  Transition? defaultTransition;
  Duration defaultTransitionDuration = Duration(milliseconds: 300);
  Curve defaultTransitionCurve = Curves.easeOutQuad;
  Curve defaultDialogTransitionCurve = Curves.easeOutQuad;
  Duration defaultDialogTransitionDuration = Duration(milliseconds: 300);

  final routing = Routing();

  Map<String, String?> parameters = {};
  CustomTransition? customTransition;

  Map<dynamic, GetDelegate> keys = {};

  GlobalKey<NavigatorState> get key => rootDelegate.navigatorKey;

  GetDelegate get rootDelegate => routerDelegate as GetDelegate;

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    rootDelegate.navigatorKey = newKey;
    return key;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    Get.asap(() {
      final locale = Get.deviceLocale;
      if (locale != null) {
        Get.updateLocale(locale);
      }
    });
  }

  void restartApp() {
    unikey = UniqueKey();
    update();
  }

  void setTheme(ThemeData value) {
    if (darkTheme == null) {
      theme = value;
    } else {
      if (value.brightness == Brightness.light) {
        theme = value;
      } else {
        darkTheme = value;
      }
    }
    update();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    update();
  }

  GetDelegate? nestedKey(String? key) {
    if (key == null) {
      return routerDelegate as GetDelegate;
    }
    keys.putIfAbsent(
      key,
      () => GetDelegate(
        showHashOnUrl: true,
        //debugLabel: 'Getx nested key: ${key.toString()}',
        pages: RouteDecoder.fromRoute(key).currentChildrens ?? [],
      ),
    );
    return keys[key];
  }

  GetInformationParser createInformationParser({String initialRoute = '/'}) {
    return GetInformationParser(
      initialRoute: initialRoute,
    );
  }

  // static GetDelegate? _delegate;

  GetDelegate createDelegate({
    GetPage<dynamic>? notFoundRoute,
    List<GetPage> pages = const [],
    List<NavigatorObserver>? navigatorObservers,
    TransitionDelegate<dynamic>? transitionDelegate,
    PopMode backButtonPopMode = PopMode.history,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return GetDelegate(
      notFoundRoute: notFoundRoute,
      navigatorObservers: navigatorObservers,
      transitionDelegate: transitionDelegate,
      backButtonPopMode: backButtonPopMode,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
      pages: pages,
      navigatorKey: navigatorKey,
    );
  }
}

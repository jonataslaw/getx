import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/get_instance.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../../get_navigation.dart';
import 'get_root.dart';

class GetCupertinoApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The initial home widget owned by this app's root navigator.
  final Widget? home;

  /// The named builders adapted to Navigator 2 pages.
  ///
  /// When combined with routes, [home] supplies `/`. Builders take precedence
  /// over [getPages] with the same name. Use [getPages] for bindings, middleware,
  /// and route options. Read arguments through [Get.arguments].
  final Map<String, WidgetBuilder>? routes;

  /// The initial route used when the platform starts at `/`.
  ///
  /// An incoming platform deep link takes precedence.
  final String? initialRoute;

  /// The unsupported Navigator 1 route factory.
  ///
  /// Supplying this callback throws [UnsupportedError]. Use [getPages] and
  /// [GetMiddleware] or provide a custom router instead.
  final RouteFactory? onGenerateRoute;

  /// The unsupported Navigator 1 initial route factory.
  ///
  /// Supplying this callback throws [UnsupportedError]. Use [initialRoute]
  /// with [getPages] or provide a custom router instead.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// The unsupported Navigator 1 fallback route factory.
  ///
  /// Supplying this callback throws [UnsupportedError]. Use [unknownRoute]
  /// with [getPages] or provide a custom router instead.
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final CustomTransition? customTransition;
  final Color? color;
  final Map<String, Map<String, String>>? translationsKeys;
  final Translations? translations;
  final TextDirection? textDirection;
  final Locale? locale;
  final Locale? fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final Map<Type, Action<Intent>>? actions;
  final Function(Routing?)? routingCallback;
  final Transition? defaultTransition;
  final bool? opaqueRoute;
  final VoidCallback? onInit;
  final VoidCallback? onReady;
  final VoidCallback? onDispose;
  final bool? enableLog;
  final LogWriterCallback? logWriterCallback;
  final bool? popGesture;
  final SmartManagement smartManagement;

  /// The dependency registration run once before [onInit].
  final BindingsInterface? initialBinding;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;

  /// The initial declarative route definitions.
  ///
  /// Changing routing definitions or the home widget requires a new app key.
  /// Ordinary theme and locale rebuilds preserve the existing navigation stack.
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final RouterConfig<Object>? routerConfig;

  /// The restoration scope identifier for the app and its root navigator.
  final String? restorationScopeId;
  final BackButtonDispatcher? backButtonDispatcher;
  final CupertinoThemeData? theme;
  final bool useInheritedMediaQuery;

  /// The initial scoped dependencies retained until the app is unmounted.
  final List<Bind> binds;
  final ScrollBehavior? scrollBehavior;

  const GetCupertinoApp({
    super.key,
    this.restorationScopeId,
    this.theme,
    this.navigatorKey,
    this.home,
    Map<String, Widget Function(BuildContext)> this.routes =
        const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    List<NavigatorObserver> this.navigatorObservers =
        const <NavigatorObserver>[],
    this.builder,
    this.translationsKeys,
    this.translations,
    this.textDirection,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.customTransition,
    this.onInit,
    this.onDispose,
    this.locale,
    this.binds = const [],
    this.scrollBehavior,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.useInheritedMediaQuery = false,
    this.unknownRoute,
    this.routingCallback,
    this.defaultTransition,
    this.onReady,
    this.getPages,
    this.opaqueRoute,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
  })  : routeInformationProvider = null,
        backButtonDispatcher = null,
        routeInformationParser = null,
        routerDelegate = null,
        routerConfig = null;

  const GetCupertinoApp.router({
    super.key,
    this.restorationScopeId,
    this.theme,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.useInheritedMediaQuery = false,
    this.color,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.binds = const [],
    this.scrollBehavior,
    this.actions,
    this.customTransition,
    this.translationsKeys,
    this.translations,
    this.textDirection,
    this.fallbackLocale,
    this.routingCallback,
    this.defaultTransition,
    this.opaqueRoute,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.transitionDuration,
    this.defaultGlobalState,
    this.getPages,
    this.navigatorObservers,
    this.unknownRoute,
  })  : navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null;

  @override
  Widget build(BuildContext context) {
    if (onGenerateRoute != null ||
        onGenerateInitialRoutes != null ||
        onUnknownRoute != null) {
      throw UnsupportedError(
        'Navigator 1 route factories are not supported by GetX 5. '
        'Use getPages with initialRoute, GetMiddleware, and unknownRoute, '
        'or provide a custom router with the .router constructor.',
      );
    }
    return GetRoot(
      config: ConfigData(
        backButtonDispatcher: backButtonDispatcher,
        binds: binds,
        initialBinding: initialBinding,
        customTransition: customTransition,
        defaultGlobalState: defaultGlobalState,
        defaultTransition: defaultTransition,
        enableLog: enableLog,
        fallbackLocale: fallbackLocale,
        getPages: getPages,
        routes: routes,
        home: home,
        initialRoute: initialRoute,
        locale: locale,
        logWriterCallback: logWriterCallback,
        navigatorKey: navigatorKey,
        navigatorObservers: navigatorObservers,
        onDispose: onDispose,
        onInit: onInit,
        onReady: onReady,
        routeInformationParser: routeInformationParser,
        routeInformationProvider: routeInformationProvider,
        routerDelegate: routerDelegate,
        routerConfig: routerConfig,
        restorationScopeId: restorationScopeId,
        routingCallback: routingCallback,
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
        smartManagement: smartManagement,
        transitionDuration: transitionDuration,
        defaultTransitionDuration:
            transitionDuration ?? const Duration(milliseconds: 300),
        defaultPopGesture: popGesture,
        defaultOpaqueRoute: opaqueRoute ?? true,
        translations: translations,
        translationsKeys: translationsKeys,
        unknownRoute: unknownRoute,
      ),
      child: Builder(builder: (context) {
        final controller = GetRoot.of(context);
        return CupertinoApp.router(
          routerDelegate:
              routerConfig == null ? controller.config.routerDelegate : null,
          routeInformationParser: routerConfig == null
              ? controller.config.routeInformationParser
              : null,
          backButtonDispatcher: backButtonDispatcher,
          routeInformationProvider: controller.config.routeInformationProvider,
          routerConfig: routerConfig,
          restorationScopeId: restorationScopeId,
          key: controller.config.unikey,
          builder: (context, child) => Directionality(
            textDirection: textDirection ??
                (rtlLanguages.contains(Get.locale?.languageCode)
                    ? TextDirection.rtl
                    : TextDirection.ltr),
            child: builder == null
                ? (child ?? const Material())
                : builder!(context, child ?? const Material()),
          ),
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          theme: theme,
          locale: Get.locale ?? locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          scrollBehavior: scrollBehavior,
        );
      }),
    );
  }
}

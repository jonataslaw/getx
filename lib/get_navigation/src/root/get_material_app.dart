import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../get_core/get_core.dart';
import '../../../get_instance/get_instance.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../../get_navigation.dart';
import 'root_controller.dart';

class GetMaterialApp extends StatelessWidget {
  const GetMaterialApp({
    Key key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.textDirection,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.customTransition,
    this.translationsKeys,
    this.translations,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.routingCallback,
    this.defaultTransition,
    this.getPages,
    this.opaqueRoute,
    this.enableLog,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.unknownRoute,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
  })  : assert(routes != null),
        assert(navigatorObservers != null),
        assert(title != null),
        assert(debugShowMaterialGrid != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
        routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;
  final Map<String, WidgetBuilder> routes;
  final String initialRoute;
  final RouteFactory onGenerateRoute;
  final InitialRouteListFactory onGenerateInitialRoutes;
  final RouteFactory onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder builder;
  final String title;
  final GenerateAppTitle onGenerateTitle;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final CustomTransition customTransition;
  final Color color;
  final Map<String, Map<String, String>> translationsKeys;
  final Translations translations;
  final TextDirection textDirection;
  final Locale locale;
  final Locale fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final LocaleListResolutionCallback localeListResolutionCallback;
  final LocaleResolutionCallback localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent> shortcuts;
  final ThemeData highContrastTheme;
  final ThemeData highContrastDarkTheme;
  final Map<Type, Action<Intent>> actions;
  final bool debugShowMaterialGrid;
  final Function(Routing) routingCallback;
  final Transition defaultTransition;
  final bool opaqueRoute;
  final VoidCallback onInit;
  final VoidCallback onReady;
  final VoidCallback onDispose;
  final bool enableLog;
  final LogWriterCallback logWriterCallback;
  final bool popGesture;
  final SmartManagement smartManagement;
  final Bindings initialBinding;
  final Duration transitionDuration;
  final bool defaultGlobalState;
  final List<GetPage> getPages;
  final GetPage unknownRoute;
  final RouteInformationProvider routeInformationProvider;
  final RouteInformationParser<Object> routeInformationParser;
  final RouterDelegate<Object> routerDelegate;
  final BackButtonDispatcher backButtonDispatcher;

  const GetMaterialApp.router({
    Key key,
    this.routeInformationProvider,
    @required this.routeInformationParser,
    @required this.routerDelegate,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
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
    this.enableLog,
    this.logWriterCallback,
    this.popGesture,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.transitionDuration,
    this.defaultGlobalState,
    this.getPages,
    this.unknownRoute,
  })  : assert(routeInformationParser != null),
        assert(routerDelegate != null),
        assert(title != null),
        assert(debugShowMaterialGrid != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
        navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null,
        super(key: key);

  Route<dynamic> generator(RouteSettings settings) {
    return PageRedirect(settings, unknownRoute).page();
  }

  List<Route<dynamic>> initialRoutesGenerate(String name) {
    final match = Get.routeTree.matchRoute(name);
    Get.parameters = match?.parameters;

    //Route can be nullable, just pass the unknown route
    if (match?.route == null) {
      return [
        GetPageRoute(
          page: unknownRoute.page,
          parameter: unknownRoute.parameter,
          settings: RouteSettings(name: name, arguments: null),
          curve: unknownRoute.curve,
          opaque: unknownRoute.opaque,
          routeName: unknownRoute.name,
          customTransition: unknownRoute.customTransition,
          binding: unknownRoute.binding,
          bindings: unknownRoute.bindings,
          transitionDuration: (unknownRoute.transitionDuration ??
              Get.defaultTransitionDuration),
          transition: unknownRoute.transition,
          popGesture: unknownRoute.popGesture,
          fullscreenDialog: unknownRoute.fullscreenDialog,
        )
      ];
    }

    return [
      GetPageRoute(
        page: match.route.page,
        parameter: match.route.parameter,
        settings: RouteSettings(name: name, arguments: null),
        curve: match.route.curve,
        opaque: match.route.opaque,
        binding: match.route.binding,
        routeName: match.route.name,
        bindings: match.route.bindings,
        transitionDuration:
            (match.route.transitionDuration ?? Get.defaultTransitionDuration),
        transition: match.route.transition,
        popGesture: match.route.popGesture,
        fullscreenDialog: match.route.fullscreenDialog,
      )
    ];
  }

  @override
  Widget build(BuildContext context) => GetBuilder<GetMaterialController>(
      init: Get.rootController,
      dispose: (d) {
        onDispose?.call();
      },
      initState: (i) {
        Get.engine.addPostFrameCallback((timeStamp) {
          onReady?.call();
        });
        if (locale != null) Get.locale = locale;

        if (fallbackLocale != null) Get.fallbackLocale = fallbackLocale;

        if (translations != null) {
          Get.addTranslations(translations.keys);
        } else if (translationsKeys != null) {
          Get.addTranslations(translationsKeys);
        }

        Get.customTransition = customTransition;

        initialBinding?.dependencies();
        Get.addPages(getPages);
        Get.smartManagement = smartManagement;
        onInit?.call();

        Get.config(
          enableLog: enableLog ?? Get.isLogEnable,
          logWriterCallback: logWriterCallback,
          defaultTransition: defaultTransition ?? Get.defaultTransition,
          defaultOpaqueRoute: opaqueRoute ?? Get.isOpaqueRouteDefault,
          defaultPopGesture: popGesture ?? Get.isPopGestureEnable,
          defaultDurationTransition:
              transitionDuration ?? Get.defaultTransitionDuration,
        );
      },
      builder: (_) => routerDelegate != null
          ? MaterialApp.router(
              routerDelegate: routerDelegate,
              routeInformationParser: routeInformationParser,
              backButtonDispatcher: backButtonDispatcher,
              routeInformationProvider: routeInformationProvider,
              key: _.unikey,
              builder: (context, child) {
                return Directionality(
                  textDirection: textDirection ??
                      (rtlLanguages.contains(Get.locale?.languageCode)
                          ? TextDirection.rtl
                          : TextDirection.ltr),
                  child: builder == null ? child : builder(context, child),
                );
              },
              title: title ?? '',
              onGenerateTitle: onGenerateTitle,
              color: color,
              theme: _.theme ?? theme ?? ThemeData.fallback(),
              darkTheme: darkTheme,
              themeMode: _.themeMode ?? themeMode ?? ThemeMode.system,
              locale: Get.locale ?? locale,
              localizationsDelegates: localizationsDelegates,
              localeListResolutionCallback: localeListResolutionCallback,
              localeResolutionCallback: localeResolutionCallback,
              supportedLocales:
                  supportedLocales ?? const <Locale>[Locale('en', 'US')],
              debugShowMaterialGrid: debugShowMaterialGrid ?? false,
              showPerformanceOverlay: showPerformanceOverlay ?? false,
              checkerboardRasterCacheImages:
                  checkerboardRasterCacheImages ?? false,
              checkerboardOffscreenLayers: checkerboardOffscreenLayers ?? false,
              showSemanticsDebugger: showSemanticsDebugger ?? false,
              debugShowCheckedModeBanner: debugShowCheckedModeBanner ?? true,
              shortcuts: shortcuts,
            )
          : MaterialApp(
              key: _.unikey,
              navigatorKey:
                  (navigatorKey == null ? Get.key : Get.addKey(navigatorKey)),
              home: home,
              routes: routes ?? const <String, WidgetBuilder>{},
              initialRoute: initialRoute,
              onGenerateRoute: (getPages != null ? generator : onGenerateRoute),
              onGenerateInitialRoutes: (getPages == null || home != null)
                  ? onGenerateInitialRoutes
                  : initialRoutesGenerate,
              onUnknownRoute: onUnknownRoute,
              navigatorObservers: (navigatorObservers == null
                  ? <NavigatorObserver>[
                      GetObserver(routingCallback, Get.routing)
                    ]
                  : <NavigatorObserver>[
                      GetObserver(routingCallback, Get.routing)
                    ]
                ..addAll(navigatorObservers)),
              builder: (context, child) {
                return Directionality(
                  textDirection: textDirection ??
                      (rtlLanguages.contains(Get.locale?.languageCode)
                          ? TextDirection.rtl
                          : TextDirection.ltr),
                  child: builder == null ? child : builder(context, child),
                );
              },
              title: title ?? '',
              onGenerateTitle: onGenerateTitle,
              color: color,
              theme: _.theme ?? theme ?? ThemeData.fallback(),
              darkTheme: darkTheme,
              themeMode: _.themeMode ?? themeMode ?? ThemeMode.system,
              locale: Get.locale ?? locale,
              localizationsDelegates: localizationsDelegates,
              localeListResolutionCallback: localeListResolutionCallback,
              localeResolutionCallback: localeResolutionCallback,
              supportedLocales:
                  supportedLocales ?? const <Locale>[Locale('en', 'US')],
              debugShowMaterialGrid: debugShowMaterialGrid ?? false,
              showPerformanceOverlay: showPerformanceOverlay ?? false,
              checkerboardRasterCacheImages:
                  checkerboardRasterCacheImages ?? false,
              checkerboardOffscreenLayers: checkerboardOffscreenLayers ?? false,
              showSemanticsDebugger: showSemanticsDebugger ?? false,
              debugShowCheckedModeBanner: debugShowCheckedModeBanner ?? true,
              shortcuts: shortcuts,
              //   actions: actions,
            ));
}

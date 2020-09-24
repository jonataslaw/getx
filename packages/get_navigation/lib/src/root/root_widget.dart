import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_core/get_core.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:get_utils/get_utils.dart';
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
    this.translationsKeys,
    this.translations,
    this.textDirection,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.customTransition,
    this.onInit,
    this.onDispose,
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
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.unknownRoute,
    this.routingCallback,
    this.defaultTransition,
    // this.actions,
    this.getPages,
    this.opaqueRoute,
    this.enableLog,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
  })  : assert(routes != null),
        assert(navigatorObservers != null),
        assert(title != null),
        assert(debugShowMaterialGrid != null),
        assert(showPerformanceOverlay != null),
        assert(checkerboardRasterCacheImages != null),
        assert(checkerboardOffscreenLayers != null),
        assert(showSemanticsDebugger != null),
        assert(debugShowCheckedModeBanner != null),
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

  // final Map<LocalKey, ActionFactory> actions;
  final bool debugShowMaterialGrid;
  final Function(Routing) routingCallback;
  final Transition defaultTransition;
  final bool opaqueRoute;
  final VoidCallback onInit;
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

  Route<dynamic> generator(RouteSettings settings) {
    final match = Get.routeTree.matchRoute(settings.name);
    Get.parameters = match?.parameters;

    if (match?.route == null) {
      return GetPageRoute(
        page: unknownRoute.page,
        parameter: unknownRoute.parameter,
        settings:
            RouteSettings(name: settings.name, arguments: settings.arguments),
        curve: unknownRoute.curve,
        opaque: unknownRoute.opaque,
        customTransition: unknownRoute.customTransition,
        binding: unknownRoute.binding,
        bindings: unknownRoute.bindings,
        transitionDuration:
            (transitionDuration ?? unknownRoute.transitionDuration),
        transition: unknownRoute.transition,
        popGesture: unknownRoute.popGesture,
        fullscreenDialog: unknownRoute.fullscreenDialog,
      );
    }

    return GetPageRoute(
      page: match.route.page,
      parameter: match.route.parameter,
      settings:
          RouteSettings(name: settings.name, arguments: settings.arguments),
      curve: match.route.curve,
      opaque: match.route.opaque,
      customTransition: match.route.customTransition,
      binding: match.route.binding,
      bindings: match.route.bindings,
      transitionDuration:
          (transitionDuration ?? match.route.transitionDuration),
      transition: match.route.transition,
      popGesture: match.route.popGesture,
      fullscreenDialog: match.route.fullscreenDialog,
    );
  }

  List<Route<dynamic>> initialRoutesGenerate(String name) {
    final match = Get.routeTree.matchRoute(name);
    Get.parameters = match?.parameters;

    return [
      GetPageRoute(
        page: match.route.page,
        parameter: match.route.parameter,
        settings: RouteSettings(name: name, arguments: null),
        curve: match.route.curve,
        opaque: match.route.opaque,
        binding: match.route.binding,
        bindings: match.route.bindings,
        transitionDuration:
            (transitionDuration ?? match.route.transitionDuration),
        transition: match.route.transition,
        popGesture: match.route.popGesture,
        fullscreenDialog: match.route.fullscreenDialog,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetMaterialController>(
        init: Get.rootController,
        dispose: (d) {
          onDispose?.call();
        },
        initState: (i) {
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
        builder: (_) {
          return MaterialApp(
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
                ? <NavigatorObserver>[GetObserver(routingCallback, Get.routing)]
                : <NavigatorObserver>[GetObserver(routingCallback, Get.routing)]
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
          );
        });
  }
}

const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur',
];

abstract class Translations {
  Map<String, Map<String, String>> get keys;
}

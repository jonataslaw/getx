import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/src/routes/get_route.dart';
import '../get_instance.dart';
import 'parse_route.dart';
import 'root_controller.dart';
import 'smart_management.dart';

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
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.onInit,
    this.onDispose,
    this.theme,
    this.darkTheme,
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
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.routingCallback,
    this.defaultTransition,
    // this.actions,
    this.getPages,
    this.opaqueRoute,
    this.enableLog,
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
  final Color color;
  final Map<String, Map<String, String>> translationsKeys;
  final Translations translations;
  final Locale locale;
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
  final bool popGesture;
  final SmartManagement smartManagement;
  final Bindings initialBinding;
  final Duration transitionDuration;
  final bool defaultGlobalState;
  final List<GetPage> getPages;

  Route<dynamic> generator(RouteSettings settings) {
    final match = Get.routeTree.matchRoute(settings.name);
    Get.parameters = match?.parameters;

    return GetPageRoute(
      page: match.route.page,
      parameter: match.route.parameter,
      settings:
          RouteSettings(name: settings.name, arguments: settings.arguments),
      curve: match.route.curve,
      opaque: match.route.opaque,
      binding: match.route.binding,
      bindings: match.route.bindings,
      duration: (transitionDuration ?? match.route.transitionDuration),
      transition: match.route.transition,
      popGesture: match.route.popGesture,
      fullscreenDialog: match.route.fullscreenDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetMaterialController>(
        init: Get.getxController,
        dispose: (d) {
          onDispose?.call();
        },
        initState: (i) {
          if (locale != null) {
            Get.locale = locale;
          }

          if (translations != null) {
            if (Get.locale == null) Get.translations = translations.keys;
          }
          if (translationsKeys != null) {
            Get.translations = translationsKeys;
          }

          initialBinding?.dependencies();
          Get.addPages(getPages);
          GetConfig.smartManagement = smartManagement;
          onInit?.call();

          Get.config(
            enableLog: enableLog ?? GetConfig.isLogEnable,
            defaultTransition: defaultTransition ?? Get.defaultTransition,
            defaultOpaqueRoute: opaqueRoute ?? Get.isOpaqueRouteDefault,
            defaultPopGesture: popGesture ?? Get.isPopGestureEnable,
            defaultDurationTransition:
                transitionDuration ?? Get.defaultDurationTransition,
            defaultGlobalState: defaultGlobalState ?? Get.defaultGlobalState,
          );
        },
        builder: (_) {
          return MaterialApp(
            key: key,
            navigatorKey:
                (navigatorKey == null ? Get.key : Get.addKey(navigatorKey)),
            home: home,
            routes: routes ?? const <String, WidgetBuilder>{},
            initialRoute: initialRoute,
            onGenerateRoute: (getPages != null ? generator : onGenerateRoute),
            onGenerateInitialRoutes: (getPages == null || home != null)
                ? onGenerateInitialRoutes
                : (st) {
                    GetPageMatch match;
                    if (initialRoute == null && getPages != null) {
                      match = Get.routeTree?.matchRoute(getPages.first.name);
                    } else {
                      match = Get.routeTree?.matchRoute(initialRoute);
                    }
                    Get.parameters = match?.parameters;
                    return [
                      GetPageRoute(
                        page: match.route.page,
                        parameter: match.parameters,
                        settings:
                            RouteSettings(name: initialRoute, arguments: null),
                        curve: match.route.curve,
                        opaque: match.route.opaque,
                        binding: match.route.binding,
                        bindings: match.route.bindings,
                        duration: (transitionDuration ??
                            match.route.transitionDuration),
                        transition: match.route.transition,
                        popGesture: match.route.popGesture,
                        fullscreenDialog: match.route.fullscreenDialog,
                      )
                    ];
                  },
            onUnknownRoute: onUnknownRoute,
            navigatorObservers: (navigatorObservers == null
                ? <NavigatorObserver>[GetObserver(routingCallback)]
                : <NavigatorObserver>[GetObserver(routingCallback)]
              ..addAll(navigatorObservers)),
            builder: builder,
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

abstract class Translations {
  Map<String, Map<String, String>> get keys;
}

extension Trans on String {
  String get tr {
    if (Get.translations
        .containsKey("${Get.locale.languageCode}_${Get.locale.countryCode}")) {
      return Get.translations[
          "${Get.locale.languageCode}_${Get.locale.countryCode}"][this];
    } else if (Get.translations.containsKey(Get.locale.languageCode)) {
      return Get.translations[Get.locale.languageCode][this];
    }
    return Get.translations.values.first[this];
  }

  String trArgs([List<String> args]) {
    String key = tr;
    if (args != null) {
      args.forEach((arg) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      });
    }
    return key;
  }
}

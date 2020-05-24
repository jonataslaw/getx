import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/src/routes/get_route.dart';
import 'package:get/src/routes/utils/parse_arguments.dart';
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
    this.routingCallback,
    this.defaultTransition,
    // this.actions,
    this.opaqueRoute,
    this.enableLog,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.namedRoutes,
    this.unknownRoute,
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
  final Duration transitionDuration;
  final bool defaultGlobalState;
  final Map<String, GetRoute> namedRoutes;
  final GetRoute unknownRoute;

  Route<dynamic> namedRoutesGenerate(RouteSettings settings) {
    Get.setSettings(settings);

    /// onGenerateRoute to FlutterWeb is Broken on Dev/Master. This is a temporary
    /// workaround until they fix it, because the problem is with the 'Flutter engine',
    /// which changes the initial route for an empty String, not the main Flutter,
    /// so only Team can fix it.
    var parsedString = Get().getController.parse.split(
        (settings.name == '' || settings.name == null)
            ? (initialRoute ?? '/')
            : settings.name);

    if (parsedString == null) {
      parsedString = AppRouteMatch();
      parsedString.route = settings.name;
    }

    String settingsName = parsedString.route;
    Map<String, GetRoute> newNamedRoutes = {};

    namedRoutes.forEach((key, value) {
      String newName = Get().getController.parse.split(key).route;
      newNamedRoutes.addAll({newName: value});
    });

    if (newNamedRoutes.containsKey(settingsName)) {
      Get.setParameter(parsedString.parameters);

      return GetRouteBase(
        page: newNamedRoutes[settingsName].page,
        title: newNamedRoutes[settingsName].title,
        parameter: parsedString.parameters,
        settings:
            RouteSettings(name: settings.name, arguments: settings.arguments),
        maintainState: newNamedRoutes[settingsName].maintainState,
        curve: newNamedRoutes[settingsName].curve,
        alignment: newNamedRoutes[settingsName].alignment,
        opaque: newNamedRoutes[settingsName].opaque,
        transitionDuration: (transitionDuration == null
            ? newNamedRoutes[settingsName].transitionDuration
            : transitionDuration),
        transition: newNamedRoutes[settingsName].transition,
        popGesture: newNamedRoutes[settingsName].popGesture,
        fullscreenDialog: newNamedRoutes[settingsName].fullscreenDialog,
      );
    } else {
      return ((unknownRoute == null
          ? GetRouteBase(
              page: Scaffold(
              body: Center(
                child: Text("Route not found :("),
              ),
            ))
          : GetRouteBase(
              page: unknownRoute.page,
              title: unknownRoute.title,
              settings: unknownRoute.settings,
              maintainState: unknownRoute.maintainState,
              curve: unknownRoute.curve,
              alignment: unknownRoute.alignment,
              parameter: unknownRoute.parameter,
              opaque: unknownRoute.opaque,
              transitionDuration: unknownRoute.transitionDuration,
              popGesture: unknownRoute.popGesture,
              transition: unknownRoute.transition,
              fullscreenDialog: unknownRoute.fullscreenDialog,
            )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetMaterialController>(
        init: Get().getController,
        dispose: (d) {
          onDispose?.call();
        },
        initState: (i) {
          onInit?.call();
          if (namedRoutes != null) {
            namedRoutes.forEach((key, value) {
              Get().getController.parse.addRoute(key);
            });
          }
          Get.config(
            enableLog: enableLog ?? Get.isLogEnable,
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
            key: _.key,
            navigatorKey:
                (navigatorKey == null ? Get.key : Get.addKey(navigatorKey)),
            home: home,
            routes: routes ?? const <String, WidgetBuilder>{},
            initialRoute: initialRoute,
            onGenerateRoute: (namedRoutes == null || onUnknownRoute != null
                ? onGenerateRoute
                : namedRoutesGenerate),
            onGenerateInitialRoutes: onGenerateInitialRoutes,
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
            locale: locale,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/src/routes/utils/parse_arguments.dart';

class GetMaterialApp extends StatefulWidget {
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
  final bool enableLog;
  final bool popGesture;
  final Duration transitionDuration;
  final bool defaultGlobalState;
  final Map<String, GetRoute> namedRoutes;
  final GetRoute unknownRoute;

  @override
  _GetMaterialAppState createState() => _GetMaterialAppState();
}

class _GetMaterialAppState extends State<GetMaterialApp> {
  ParseRoute parse = ParseRoute();
  @override
  void initState() {
    if (widget.namedRoutes != null) {
      widget.namedRoutes.forEach((key, value) {
        parse.addRoute(key);
      });
    }
    Get.config(
      enableLog: widget.enableLog ?? Get.isLogEnable,
      defaultTransition: widget.defaultTransition ?? Get.defaultTransition,
      defaultOpaqueRoute: widget.opaqueRoute ?? Get.isOpaqueRouteDefault,
      defaultPopGesture: widget.popGesture ?? Get.isPopGestureEnable,
      defaultDurationTransition:
          widget.transitionDuration ?? Get.defaultDurationTransition,
      defaultGlobalState: widget.defaultGlobalState ?? Get.defaultGlobalState,
    );
    super.initState();
  }

  Route<dynamic> namedRoutesGenerate(RouteSettings settings) {
    Get.setSettings(settings);
    // final parsedString = parse.split(settings.name);

    /// onGenerateRoute to FlutterWeb is Broken on Dev/Master. This is a temporary
    /// workaround until they fix it, because the problem is with the 'Flutter engine',
    /// which changes the initial route for an empty String, not the main Flutter,
    /// so only Team can fix it.
    final parsedString = parse.split(
        settings.name == '' ? (widget.initialRoute ?? '/') : settings.name);

    String settingsname = parsedString.route;
    Map<String, GetRoute> newNamedRoutes = {};

    widget.namedRoutes.forEach((key, value) {
      String newName = parse.split(key).route;
      newNamedRoutes.addAll({newName: value});
    });

    if (newNamedRoutes.containsKey(settingsname)) {
      Get.setParameter(parsedString.parameters);
      return GetRoute(
        page: newNamedRoutes[settingsname].page,
        title: newNamedRoutes[settingsname].title,
        parameter: parsedString.parameters,
        settings:
            RouteSettings(name: settings.name, arguments: settings.arguments),
        maintainState: newNamedRoutes[settingsname].maintainState,
        curve: newNamedRoutes[settingsname].curve,
        alignment: newNamedRoutes[settingsname].alignment,
        opaque: newNamedRoutes[settingsname].opaque,
        transitionDuration: (widget.transitionDuration == null
            ? newNamedRoutes[settingsname].transitionDuration
            : widget.transitionDuration),
        transition: newNamedRoutes[settingsname].transition,
        popGesture: newNamedRoutes[settingsname].popGesture,
        fullscreenDialog: newNamedRoutes[settingsname].fullscreenDialog,
      );
    } else {
      return (widget.unknownRoute ??
          GetRoute(
              page: Scaffold(
            body: Center(
              child: Text("Route not found :("),
            ),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: (widget.navigatorKey == null
          ? Get.key
          : Get.addKey(widget.navigatorKey)),
      home: widget.home,
      routes: widget.routes ?? const <String, WidgetBuilder>{},
      initialRoute: widget.initialRoute,
      onGenerateRoute: (widget.namedRoutes == null
          ? widget.onGenerateRoute
          : namedRoutesGenerate),
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      navigatorObservers: (widget.navigatorObservers == null
          ? <NavigatorObserver>[GetObserver(widget.routingCallback)]
          : <NavigatorObserver>[GetObserver(widget.routingCallback)]
        ..addAll(widget.navigatorObservers)),
      builder: widget.builder,
      title: widget.title ?? '',
      onGenerateTitle: widget.onGenerateTitle,
      color: widget.color,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode ?? ThemeMode.system,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales:
          widget.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      debugShowMaterialGrid: widget.debugShowMaterialGrid ?? false,
      showPerformanceOverlay: widget.showPerformanceOverlay ?? false,
      checkerboardRasterCacheImages:
          widget.checkerboardRasterCacheImages ?? false,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers ?? false,
      showSemanticsDebugger: widget.showSemanticsDebugger ?? false,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner ?? true,
      shortcuts: widget.shortcuts,
      //   actions: widget.actions,
    );
  }
}

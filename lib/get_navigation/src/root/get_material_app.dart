import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/get_instance.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../../get_navigation.dart';
import '../router_report.dart';

class GetMaterialApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
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
  final ScrollBehavior? scrollBehavior;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final Map<Type, Action<Intent>>? actions;
  final bool debugShowMaterialGrid;
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
  final bool useInheritedMediaQuery;

  const GetMaterialApp({
    Key? key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    Map<String, Widget Function(BuildContext)> this.routes =
        const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.useInheritedMediaQuery = false,
    List<NavigatorObserver> this.navigatorObservers =
        const <NavigatorObserver>[],
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
    this.scrollBehavior,
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
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.smartManagement = SmartManagement.full,
    this.binds = const [],
    this.unknownRoute,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
  })  : routeInformationProvider = null,
        backButtonDispatcher = null,
        routeInformationParser = null,
        routerDelegate = null,
        super(key: key);

  GetMaterialApp.router({
    Key? key,
    this.routeInformationProvider,
    this.scaffoldMessengerKey,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.useInheritedMediaQuery = false,
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
    this.binds = const [],
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
        initialRoute = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Binds(
      binds: [
        Bind.lazyPut<GetMaterialController>(
          () => GetMaterialController(
            ConfigData(
              backButtonDispatcher: backButtonDispatcher,
              binds: binds,
              customTransition: customTransition,
              defaultGlobalState: defaultGlobalState,
              defaultTransition: defaultTransition,
              enableLog: enableLog,
              fallbackLocale: fallbackLocale,
              getPages: getPages,
              home: home,
              initialRoute: initialRoute,
              locale: locale,
              logWriterCallback: logWriterCallback,
              navigatorKey: navigatorKey,
              navigatorObservers: navigatorObservers,
              onDispose: onDispose,
              onInit: onInit,
              onReady: onReady,
              opaqueRoute: opaqueRoute,
              popGesture: popGesture,
              routeInformationParser: routeInformationParser,
              routeInformationProvider: routeInformationProvider,
              routerDelegate: routerDelegate,
              routingCallback: routingCallback,
              scaffoldMessengerKey: scaffoldMessengerKey,
              smartManagement: smartManagement,
              transitionDuration: transitionDuration,
              translations: translations,
              translationsKeys: translationsKeys,
              unknownRoute: unknownRoute,
            ),
          ),
          onClose: () {
            Get.clearTranslations();
            RouterReportManager.dispose();
            Get.resetInstance(clearRouteBindings: true);
          },
        ),
        ...binds,
      ],
      child: Builder(builder: (context) {
        final controller = context.listen<GetMaterialController>();
        return MaterialApp.router(
          routerDelegate: controller.routerDelegate,
          routeInformationParser: controller.routeInformationParser,
          backButtonDispatcher: backButtonDispatcher,
          routeInformationProvider: routeInformationProvider,
          key: controller.unikey,
          builder: (context, child) => Directionality(
            textDirection: textDirection ??
                (rtlLanguages.contains(Get.locale?.languageCode)
                    ? TextDirection.rtl
                    : TextDirection.ltr),
            child: builder == null
                ? (child ?? Material())
                : builder!(context, child ?? Material()),
          ),
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          theme: controller.theme ?? theme ?? ThemeData.fallback(),
          darkTheme: controller.darkTheme ??
              darkTheme ??
              theme ??
              ThemeData.fallback(),
          themeMode: controller.themeMode ?? themeMode,
          locale: Get.locale ?? locale,
          scaffoldMessengerKey:
              scaffoldMessengerKey ?? controller.scaffoldMessengerKey,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          scrollBehavior: scrollBehavior,
          useInheritedMediaQuery: useInheritedMediaQuery,
        );
      }),
    );
  }
}

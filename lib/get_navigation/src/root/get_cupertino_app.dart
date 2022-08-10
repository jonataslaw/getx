import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/get_instance.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../../get_navigation.dart';

class GetCupertinoApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

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
  final BindingsInterface? initialBinding;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final CupertinoThemeData? theme;
  final bool useInheritedMediaQuery;
  GetCupertinoApp({
    Key? key,
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
        super(key: key);

  static String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  GetCupertinoApp.router({
    Key? key,
    this.theme,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
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
        initialRoute = null,
        super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<GetMaterialController>(
        init: Get.rootController,
        dispose: (d) {
          onDispose?.call();
          // Get.clearRouteTree();
          //  Get.clearTranslations();
          // Get.resetRootNavigator();
          // Get.routerDelegate = null;
          // Get.routeInformationParser = null;
        },
        initState: (i) {
          Get.engine.addPostFrameCallback((timeStamp) {
            onReady?.call();
          });
          if (locale != null) Get.locale = locale;

          if (fallbackLocale != null) Get.fallbackLocale = fallbackLocale;

          if (translations != null) {
            Get.addTranslations(translations!.keys);
          } else if (translationsKeys != null) {
            Get.addTranslations(translationsKeys!);
          }

          //  Get.customTransition = customTransition;

          initialBinding?.dependencies();
          // if (getPages != null) {
          //   Get.addPages(getPages!);
          // } else {
          //   Get.addPage(
          //     GetPage(
          //       name: _cleanRouteName("/${home.runtimeType}"),
          //       page: () => home!,
          //     ),
          //   );
          // }

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
          final routerDelegate = _.createDelegate(
              pages: getPages ?? [],
              notFoundRoute: unknownRoute,
              navigatorKey: navigatorKey,
              navigatorObservers: (navigatorObservers == null
                  ? <NavigatorObserver>[
                      GetObserver(routingCallback, Get.routing)
                    ]
                  : <NavigatorObserver>[
                      GetObserver(routingCallback, Get.routing)
                    ]
                ..addAll(navigatorObservers!)));
          final routeInformationParser = _.createInformationParser(
            initialRoute: initialRoute ??
                getPages?.first.name ??
                _cleanRouteName("/${home.runtimeType}"),
          );

          return CupertinoApp.router(
            routerDelegate: routerDelegate,
            routeInformationParser: routeInformationParser,
            backButtonDispatcher: backButtonDispatcher,
            routeInformationProvider: routeInformationProvider,
            key: _.unikey,
            theme: theme,
            builder: defaultBuilder,
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
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
            useInheritedMediaQuery: useInheritedMediaQuery,
          );
        },
      );

  Widget defaultBuilder(BuildContext context, Widget? child) {
    return Directionality(
      textDirection: textDirection ??
          (rtlLanguages.contains(Get.locale?.languageCode)
              ? TextDirection.rtl
              : TextDirection.ltr),
      child: builder == null
          ? (child ?? Material())
          : builder!(context, child ?? Material()),
    );
  }

  // Route<dynamic> generator(RouteSettings settings) {
  //   return PageRedirect(settings: settings, unknownRoute: unknownRoute).page();
  // }

  // List<Route<dynamic>> initialRoutesGenerate(String name) {
  //   return [
  //     PageRedirect(
  //       settings: RouteSettings(name: name),
  //       unknownRoute: unknownRoute,
  //     ).page()
  //   ];
  // }
}

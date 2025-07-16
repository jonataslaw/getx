import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/get_instance.dart';
import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../../get_navigation.dart';

class GetWidgetsApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final String title;
  final TextDirection? textDirection;
  final Locale? locale;
  final Locale? fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final Map<String, Map<String, String>>? translationsKeys;
  final Translations? translations;
  final TransitionBuilder? builder;
  final CustomTransition? customTransition;
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
  final Bindings? initialBinding;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  const GetWidgetsApp({
    super.key,
    this.navigatorKey,
    this.home,
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.title = '',
    this.textDirection,
    this.locale,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.translationsKeys,
    this.translations,
    this.builder,
    this.customTransition,
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
    this.unknownRoute,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
  });

  @override
  Widget build(BuildContext context) => GetBuilder(
    init: Get.rootController,
    dispose: (_) => onDispose?.call(),
    initState: (_) {
      Get.engine.addPostFrameCallback((_) => onReady?.call());

      if (locale != null) Get.locale = locale;
      if (fallbackLocale != null) Get.fallbackLocale = fallbackLocale;

      if (translations != null) {
        Get.addTranslations(translations!.keys);
      } else if (translationsKeys != null) {
        Get.addTranslations(translationsKeys!);
      }

      Get.customTransition = customTransition;

      initialBinding?.dependencies();
      if (getPages != null) {
        Get.addPages(getPages!);
      }

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
      if (routerDelegate != null && routeInformationParser != null) {
        return WidgetsApp.router(
          routerDelegate: routerDelegate!,
          routeInformationParser: routeInformationParser!,
          routeInformationProvider: routeInformationProvider,
          backButtonDispatcher: backButtonDispatcher,
          builder: defaultBuilder,
          title: title,
          locale: Get.locale ?? locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          color: Color(0xFFFFFFFF),
        );
      }

      return WidgetsApp(
        color: Color(0xFFFFFFFF),
        navigatorKey: navigatorKey == null
            ? Get.key
            : Get.addKey(navigatorKey!),
        builder: defaultBuilder,
        home: home,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            GetPageRoute<T>(
              settings: settings,
              page: () => Builder(builder: builder),
            ),
        routes: routes ?? const <String, WidgetBuilder>{},
        initialRoute: initialRoute,
        onGenerateRoute: getPages != null ? generator : onGenerateRoute,
        onGenerateInitialRoutes: (getPages == null || home != null)
            ? onGenerateInitialRoutes
            : initialRoutesGenerate,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers == null
            ? <NavigatorObserver>[GetObserver(routingCallback, Get.routing)]
            : <NavigatorObserver>[
                GetObserver(routingCallback, Get.routing),
                ...navigatorObservers!,
              ],
        localizationsDelegates: localizationsDelegates,
        locale: Get.locale ?? locale,
        supportedLocales: supportedLocales,
      );
    },
  );

  Widget defaultBuilder(BuildContext context, Widget? child) {
    return Directionality(
      textDirection:
          textDirection ??
          (rtlLanguages.contains(Get.locale?.languageCode)
              ? TextDirection.rtl
              : TextDirection.ltr),
      child: builder == null
          ? (child ?? const Placeholder())
          : builder!(context, child ?? const Placeholder()),
    );
  }

  Route<dynamic> generator(RouteSettings settings) {
    return PageRedirect(settings: settings, unknownRoute: unknownRoute).page();
  }

  List<Route<dynamic>> initialRoutesGenerate(String name) {
    return [
      PageRedirect(
        settings: RouteSettings(name: name),
        unknownRoute: unknownRoute,
      ).page(),
    ];
  }
}
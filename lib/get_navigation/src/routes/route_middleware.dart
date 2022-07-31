import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../get.dart';

abstract class _RouteMiddleware {
  /// The Order of the Middlewares to run.
  ///
  /// {@tool snippet}
  /// This Middewares will be called in this order.
  /// ```dart
  /// final middlewares = [
  ///   GetMiddleware(priority: 2),
  ///   GetMiddleware(priority: 5),
  ///   GetMiddleware(priority: 4),
  ///   GetMiddleware(priority: -8),
  /// ];
  /// ```
  ///  -8 => 2 => 4 => 5
  /// {@end-tool}
  int? priority;

  /// This function will be called when the page of
  /// the called route is being searched for.
  /// It take RouteSettings as a result an redirect to the new settings or
  /// give it null and there will be no redirecting.
  /// {@tool snippet}
  /// ```dart
  /// GetPage redirect(String route) {
  ///   final authService = Get.find<AuthService>();
  ///   return authService.authed.value ? null : RouteSettings(name: '/login');
  /// }
  /// ```
  /// {@end-tool}
  RouteSettings? redirect(String route);

  /// Similar to [redirect],
  /// This function will be called when the router delegate changes the
  /// current route.
  ///
  /// The default implmentation is to navigate to
  /// the input route, with no redirection.
  ///
  /// if this returns null, the navigation is stopped,
  /// and no new routes are pushed.
  /// {@tool snippet}
  /// ```dart
  /// GetNavConfig? redirect(GetNavConfig route) {
  ///   final authService = Get.find<AuthService>();
  ///   return authService.authed.value ? null : RouteSettings(name: '/login');
  /// }
  /// ```
  /// {@end-tool}
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route);

  /// This function will be called when this Page is called
  /// you can use it to change something about the page or give it new page
  /// {@tool snippet}
  /// ```dart
  /// GetPage onPageCalled(GetPage page) {
  ///   final authService = Get.find<AuthService>();
  ///   return page.copyWith(title: 'Welcome ${authService.UserName}');
  /// }
  /// ```
  /// {@end-tool}
  GetPage? onPageCalled(GetPage page);

  /// This function will be called right before the [BindingsInterface] are initialize.
  /// Here you can change [BindingsInterface] for this page
  /// {@tool snippet}
  /// ```dart
  /// List<Bindings> onBindingsStart(List<Bindings> bindings) {
  ///   final authService = Get.find<AuthService>();
  ///   if (authService.isAdmin) {
  ///     bindings.add(AdminBinding());
  ///   }
  ///   return bindings;
  /// }
  /// ```
  /// {@end-tool}
  List<R>? onBindingsStart<R>(List<R> bindings);

  /// This function will be called right after the [BindingsInterface] are initialize.
  GetPageBuilder? onPageBuildStart(GetPageBuilder page);

  /// This function will be called right after the
  /// GetPage.page function is called and will give you the result
  /// of the function. and take the widget that will be showed.
  Widget onPageBuilt(Widget page);

  void onPageDispose();
}

/// The Page Middlewares.
/// The Functions will be called in this order
/// (( [redirect] -> [onPageCalled] -> [onBindingsStart] ->
/// [onPageBuildStart] -> [onPageBuilt] -> [onPageDispose] ))
class GetMiddleware implements _RouteMiddleware {
  @override
  int? priority = 0;

  GetMiddleware({this.priority});

  @override
  RouteSettings? redirect(String? route) => null;

  @override
  GetPage? onPageCalled(GetPage? page) => page;

  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) => bindings;

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() {}

  @override
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route) => (route);
}

class MiddlewareRunner {
  MiddlewareRunner(this._middlewares);

  final List<GetMiddleware>? _middlewares;

  List<GetMiddleware> _getMiddlewares() {
    final _m = _middlewares ?? <GetMiddleware>[];
    return _m
      ..sort(
        (a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0),
      );
  }

  GetPage? runOnPageCalled(GetPage? page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageCalled(page);
    });
    return page;
  }

  RouteSettings? runRedirect(String? route) {
    RouteSettings? to;
    for (final element in _getMiddlewares()) {
      to = element.redirect(route);
      if (to != null) {
        break;
      }
    }
    Get.log('Redirect to $to');
    return to;
  }

  List<R>? runOnBindingsStart<R>(List<R>? bindings) {
    _getMiddlewares().forEach((element) {
      bindings = element.onBindingsStart(bindings);
    });
    return bindings;
  }

  GetPageBuilder? runOnPageBuildStart(GetPageBuilder? page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuildStart(page);
    });
    return page;
  }

  Widget runOnPageBuilt(Widget page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuilt(page);
    });
    return page;
  }

  void runOnPageDispose() =>
      _getMiddlewares().forEach((element) => element.onPageDispose());
}

class PageRedirect {
  GetPage? route;
  GetPage? unknownRoute;
  RouteSettings? settings;
  bool isUnknown;

  PageRedirect({
    this.route,
    this.unknownRoute,
    this.isUnknown = false,
    this.settings,
  });

  // redirect all pages that needes redirecting
  GetPageRoute<T> getPageToRoute<T>(
      GetPage rou, GetPage? unk, BuildContext context) {
    while (needRecheck(context)) {}
    final _r = (isUnknown ? unk : rou)!;

    return GetPageRoute<T>(
      page: _r.page,
      parameter: _r.parameters,
      alignment: _r.alignment,
      title: _r.title,
      maintainState: _r.maintainState,
      routeName: _r.name,
      settings: _r,
      curve: _r.curve,
      showCupertinoParallax: _r.showCupertinoParallax,
      gestureWidth: _r.gestureWidth,
      opaque: _r.opaque,
      customTransition: _r.customTransition,
      bindings: _r.bindings,
      binding: _r.binding,
      binds: _r.binds,
      transitionDuration:
          _r.transitionDuration ?? Get.defaultTransitionDuration,
      reverseTransitionDuration:
          _r.reverseTransitionDuration ?? Get.defaultTransitionDuration,
      // performIncomeAnimation: _r.performIncomeAnimation,
      // performOutGoingAnimation: _r.performOutGoingAnimation,
      transition: _r.transition,
      popGesture: _r.popGesture,
      fullscreenDialog: _r.fullscreenDialog,
      middlewares: _r.middlewares,
    );
  }

  /// check if redirect is needed
  bool needRecheck(BuildContext context) {
    if (settings == null && route != null) {
      settings = route;
    }
    final match = context.navigation
        .matchRoute((settings!.arguments as PageSettings).name);
    Get.parameters = match!.parameters;

    // No Match found
    if (match.route == null) {
      isUnknown = true;
      return false;
    }

    final runner = MiddlewareRunner(match.route!.middlewares);
    route = runner.runOnPageCalled(match.route);
    addPageParameter(route!);

    // No middlewares found return match.
    if (match.route!.middlewares == null || match.route!.middlewares!.isEmpty) {
      return false;
    }
    final newSettings = runner.runRedirect(settings!.name);
    if (newSettings == null) {
      return false;
    }
    settings = newSettings;
    return true;
  }

  void addPageParameter(GetPage route) {
    if (route.parameters == null) return;

    final parameters = Map<String, String?>.from(Get.parameters);
    parameters.addEntries(route.parameters!.entries);
    // Get.parameters = parameters;
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../get.dart';

/// The Page Middlewares.
/// The Functions will be called in this order
/// (( [redirect] -> [onPageCalled] -> [onBindingsStart] ->
/// [onPageBuildStart] -> [onPageBuilt] -> [onPageDispose] ))
abstract class GetMiddleware {
  GetMiddleware({this.priority = 0});

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
  final int priority;

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
  RouteSettings? redirect(String? route) => null;

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
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route) => (route);

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
  GetPage? onPageCalled(GetPage? page) => page;

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
  List<R>? onBindingsStart<R>(List<R>? bindings) => bindings;

  /// This function will be called right after the [BindingsInterface] are initialize.
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  /// This function will be called right after the
  /// GetPage.page function is called and will give you the result
  /// of the function. and take the widget that will be showed.
  Widget onPageBuilt(Widget page) => page;

  void onPageDispose() {}
}

class MiddlewareRunner {
  MiddlewareRunner(List<GetMiddleware>? middlewares)
      : _middlewares = middlewares != null
            ? (List.of(middlewares)..sort(_compareMiddleware))
            : const [];

  final List<GetMiddleware> _middlewares;

  static int _compareMiddleware(GetMiddleware a, GetMiddleware b) =>
      a.priority.compareTo(b.priority);

  GetPage? runOnPageCalled(GetPage? page) {
    for (final middleware in _middlewares) {
      page = middleware.onPageCalled(page);
    }
    return page;
  }

  RouteSettings? runRedirect(String? route) {
    for (final middleware in _middlewares) {
      final redirectTo = middleware.redirect(route);
      if (redirectTo != null) {
        return redirectTo;
      }
    }
    return null;
  }

  List<R>? runOnBindingsStart<R>(List<R>? bindings) {
    for (final middleware in _middlewares) {
      bindings = middleware.onBindingsStart(bindings);
    }
    return bindings;
  }

  GetPageBuilder? runOnPageBuildStart(GetPageBuilder? page) {
    for (final middleware in _middlewares) {
      page = middleware.onPageBuildStart(page);
    }
    return page;
  }

  Widget runOnPageBuilt(Widget page) {
    for (final middleware in _middlewares) {
      page = middleware.onPageBuilt(page);
    }
    return page;
  }

  void runOnPageDispose() {
    for (final middleware in _middlewares) {
      middleware.onPageDispose();
    }
  }
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
    final r = (isUnknown ? unk : rou)!;

    return GetPageRoute<T>(
      page: r.page,
      parameter: r.parameters,
      alignment: r.alignment,
      title: r.title,
      maintainState: r.maintainState,
      routeName: r.name,
      settings: r,
      curve: r.curve,
      showCupertinoParallax: r.showCupertinoParallax,
      gestureWidth: r.gestureWidth,
      opaque: r.opaque,
      customTransition: r.customTransition,
      bindings: r.bindings,
      binding: r.binding,
      binds: r.binds,
      transitionDuration: r.transitionDuration ?? Get.defaultTransitionDuration,
      reverseTransitionDuration:
          r.reverseTransitionDuration ?? Get.defaultTransitionDuration,
      // performIncomeAnimation: _r.performIncomeAnimation,
      // performOutGoingAnimation: _r.performOutGoingAnimation,
      transition: r.transition,
      popGesture: r.popGesture,
      fullscreenDialog: r.fullscreenDialog,
      middlewares: r.middlewares,
    );
  }

  /// check if redirect is needed
  bool needRecheck(BuildContext context) {
    if (settings == null && route != null) {
      settings = route;
    }
    final match = context.delegate.matchRoute(settings!.name!);

    // No Match found
    if (match.route == null) {
      isUnknown = true;
      return false;
    }

    // No middlewares found return match.
    if (match.route!.middlewares.isEmpty) {
      return false;
    }

    final runner = MiddlewareRunner(match.route!.middlewares);
    route = runner.runOnPageCalled(match.route);
    addPageParameter(route!);

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

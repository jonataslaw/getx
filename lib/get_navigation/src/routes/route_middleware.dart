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
  int priority;

  /// This function will be the first thing to call when this Page is called
  /// you can use it to redirect befor anything in this page happend.
  /// {@tool snippet}
  /// ```dart
  /// GetPage redirect( ) {
  ///   final authService = Get.find<AuthService>();
  ///   return authService.isAuthed ? null : '/login';
  /// }
  /// ```
  /// {@end-tool}
  RouteSettings redirect();

  /// This function will be called when this Page is called
  /// you can use it to change something about the page or give it new page
  /// {@tool snippet}
  /// ```dart
  /// GetPage onPageCalled(GetPage page) {
  ///   final authService = Get.find<AuthService>();
  ///   page.title = 'Wellcome ${authService.UserName}';
  ///   return page;
  /// }
  /// ```
  /// {@end-tool}
  GetPage onPageCalled(GetPage page);

  /// This function will be called right before the [Bindings] are initialize.
  /// Here you can change [Bindings] for this page
  List<Bindings> onBindingsStart(List<Bindings> bindings);

  /// This function will be called right after the [Bindings] are initialize.
  /// Here you can change the Page to build
  GetPageBuilder onPageBuildStart(GetPageBuilder page);

  // Get the built page
  Widget onPageBuilt(Widget page);

  void onPageDispose();
}

/// The Page Middlewares.
/// The Functions will be called in this order
/// (( [redirect] -> [onBindingsStart] -> [onPageBuildStart] ->
/// [onPageBuilt] -> [onPageDispose] ))
class GetMiddleware implements _RouteMiddleware {
  @override
  int priority = 0;

  GetMiddleware({this.priority});

  @override
  RouteSettings redirect() => null;

  @override
  GetPage onPageCalled(GetPage page) => page;

  @override
  List<Bindings> onBindingsStart(List<Bindings> bindings) => bindings;

  @override
  GetPageBuilder onPageBuildStart(GetPageBuilder page) => page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() {}
}

class MiddlewareRunner {
  MiddlewareRunner(this._middlewares);

  final List<GetMiddleware> _middlewares;

  List<GetMiddleware> _getMiddlewares() {
    if (_middlewares != null) {
      _middlewares.sort((a, b) => a.priority.compareTo(b.priority));
      return _middlewares;
    }
    return <GetMiddleware>[];
  }

  GetPage runOnPageCalled(GetPage page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageCalled(page);
    });
    return page;
  }

  RouteSettings runRedirect() {
    RouteSettings to;
    _getMiddlewares().forEach((element) {
      to = element.redirect();
    });
    if (to != null) {
      Get.log('Redirect to $to');
    }
    return to;
  }

  List<Bindings> runOnBindingsStart(List<Bindings> bindings) {
    _getMiddlewares().forEach((element) {
      bindings = element.onBindingsStart(bindings);
    });
    return bindings;
  }

  GetPageBuilder runOnPageBuildStart(GetPageBuilder page) {
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
  GetPage route;
  GetPage unknownRoute;
  RouteSettings settings;
  bool isUnknown;

  PageRedirect(this.settings, this.unknownRoute,
      {this.isUnknown = false, this.route});

  // redirect all pages that needes redirecting
  GetPageRoute page() {
    while (needRecheck()) {}
    return isUnknown
        ? GetPageRoute(
            page: unknownRoute.page,
            parameter: unknownRoute.parameter,
            settings: RouteSettings(
                name: settings.name, arguments: settings.arguments),
            curve: unknownRoute.curve,
            opaque: unknownRoute.opaque,
            customTransition: unknownRoute.customTransition,
            binding: unknownRoute.binding,
            bindings: unknownRoute.bindings,
            transitionDuration: (unknownRoute.transitionDuration ??
                Get.defaultTransitionDuration),
            transition: unknownRoute.transition,
            popGesture: unknownRoute.popGesture,
            fullscreenDialog: unknownRoute.fullscreenDialog,
            middlewares: unknownRoute.middlewares,
          )
        : GetPageRoute(
            page: route.page,
            parameter: route.parameter,
            settings: RouteSettings(
                name: settings.name, arguments: settings.arguments),
            curve: route.curve,
            opaque: route.opaque,
            customTransition: route.customTransition,
            binding: route.binding,
            bindings: route.bindings,
            transitionDuration:
                (route.transitionDuration ?? Get.defaultTransitionDuration),
            transition: route.transition,
            popGesture: route.popGesture,
            fullscreenDialog: route.fullscreenDialog,
            middlewares: route.middlewares);
  }

  /// check if redirect is needed
  bool needRecheck() {
    final match = Get.routeTree.matchRoute(settings.name);
    Get.parameters = match?.parameters;

    // No Match found
    if (match?.route == null) {
      isUnknown = true;
      return false;
    }

    final runner = MiddlewareRunner(match.route.middlewares);
    route = runner.runOnPageCalled(match.route);

    // No middlewares found return match.
    if (match.route.middlewares == null || match.route.middlewares.isEmpty) {
      return false;
    }

    return runner.runRedirect() != null;
  }
}

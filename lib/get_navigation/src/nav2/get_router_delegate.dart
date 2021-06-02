import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/nav2/router_outlet.dart';
import '../../../get.dart';
import '../../../get_state_manager/src/simple/list_notifier.dart';

class GetDelegate extends RouterDelegate<GetPage>
    with ListenableMixin, ListNotifierMixin {
  final List<GetPage> routes = <GetPage>[];

  final pageRoutes = <GetPage, GetPageRoute>{};

  GetPage? notFoundRoute;

  final List<NavigatorObserver>? dipNavObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  GlobalKey<NavigatorState> get navigatorKey =>
      GetNavigation.getxController.key;

  GetDelegate(
      {this.notFoundRoute, this.dipNavObservers, this.transitionDelegate});

  List<GetPage> getVisiblePages() {
    return routes.where((r) {
      final mware =
          (r.middlewares ?? []).whereType<RouterOutletContainerMiddleWare>();
      if (mware.length == 0) return true;
      return r.name == mware.first.stayAt;
    }).toList();
  }

  /// Called by the [Router] at startup with the structure that the
  /// [RouteInformationParser] obtained from parsing the initial route.
  @override
  Widget build(BuildContext context) {
    final pages = getVisiblePages();
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: pages,
      observers: [
        GetObserver(),
      ],
      transitionDelegate:
          transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
    );
  }

  final _resultCompleter = <GetPage, Completer<Object?>>{};

  @override
  Future<void> setInitialRoutePath(GetPage configuration) async {
    await pushRoute(configuration);
  }

  @override
  Future<void> setNewRoutePath(GetPage configuration) {
    /// incorrect, remove routes until you reach the page in configuration.
    /// if it's not found push it.
    routes.clear();
    pageRoutes.clear();
    return pushRoute(configuration);
  }

  /// Called by the [Router] when it detects a route information may have
  /// changed as a result of rebuild.
  @override
  GetPage get currentConfiguration {
    final route = routes.last;
    return route;
  }

  GetPageRoute? get currentRoute => pageRoutes[currentConfiguration];

  Future<T?> toNamed<T>(String route) {
    final page = Get.routeTree.matchRoute(route);
    if (page.route != null) {
      return pushRoute(page.route!.copy(name: route));
    } else {
      return pushRoute(_notFound());
    }
  }

  Future<T?> offUntil<T>(String route) {
    final page = Get.routeTree.matchRoute(route);
    if (page.route != null) {
      return pushRoute(page.route!.copy(name: route), removeUntil: true);
    } else {
      return pushRoute(_notFound());
    }
  }

  GetPage _notFound() {
    return notFoundRoute ??= GetPage(
      name: '/404',
      page: () => Scaffold(
        body: Text('not found'),
      ),
    );
  }

  Future<T?> pushRoute<T>(
    GetPage page, {
    bool removeUntil = false,
    bool replaceCurrent = false,
    bool rebuildStack = true,
  }) {
    final completer = Completer<T?>();
    _resultCompleter[page] = completer;

    page = page.copy(unknownRoute: _notFound());
    assert(!(removeUntil && replaceCurrent),
        'Only removeUntil or replaceCurrent should by true!');
    if (removeUntil) {
      routes.clear();
      pageRoutes.clear();
    } else if (replaceCurrent && routes.isNotEmpty) {
      final lastPage = routes.removeLast();
      pageRoutes.remove(lastPage);
    }
    addPage(page);
    if (rebuildStack) {
      refresh();
    }
    //emulate the old push with result
    return completer.future;
  }

  Future<bool> handlePopupRoutes({
    Object? result,
  }) async {
    Route? currentRoute;
    navigatorKey.currentState!.popUntil((route) {
      currentRoute = route;
      return true;
    });
    if (currentRoute is PopupRoute) {
      return await navigatorKey.currentState!.maybePop(result);
    }
    return false;
  }

  @override
  Future<bool> popRoute({
    Object? result,
  }) async {
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) return true;

    if (canPop()) {
      //emulate the old pop with result
      final lastRoute = routes.last;
      final lastCompleter = _resultCompleter.remove(lastRoute);
      lastCompleter?.complete(result);
      //route to be removed
      removePage(lastRoute);
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool canPop() {
    return routes.length > 1;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    final settings = route.settings;
    if (settings is GetPage) {
      removePage(settings);
    }
    refresh();
    return true;
  }

  void removePage(GetPage page) {
    final isLast = routes.last == page;
    //check if it's last
    routes.remove(page);
    final oldPageRoute = pageRoutes.remove(page);
    if (isLast && oldPageRoute != null) {
      _currentRoutePopped(oldPageRoute);
      final newPageRoute = pageRoutes[routes.last];
      if (newPageRoute != null) _currentRouteChanged(newPageRoute);
    }
    refresh();
  }

  void addPage(GetPage route) {
    routes.add(
      route,
    );
    final pageRoute =
        pageRoutes[route] = PageRedirect(route, _notFound()).page();
    _currentRouteChanged(pageRoute);
    refresh();
  }

  void addRoutes(List<GetPage> pages) {
    routes.addAll(pages);
    for (var item in pages) {
      pageRoutes[item] = PageRedirect(item, _notFound()).page();
    }
    final pageRoute = pageRoutes[routes.last];
    if (pageRoute != null) _currentRouteChanged(pageRoute);
    refresh();
  }

  void _currentRoutePopped(GetPageRoute route) {
    route.dispose();
  }

  void _currentRouteChanged(GetPageRoute route) {
    //is this method useful ?
    //transition? -> in router outlet ??
    //buildPage? -> in router outlet
  }
}

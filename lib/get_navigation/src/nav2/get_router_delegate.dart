import 'dart:async';

import 'package:flutter/material.dart';
import '../../../get.dart';
import '../../../get_state_manager/src/simple/list_notifier.dart';

class GetDelegate extends RouterDelegate<GetPage>
    with ListenableMixin, ListNotifierMixin {
  final List<GetPage> routes = <GetPage>[];

  final GetPage? notFoundRoute;

  final List<NavigatorObserver>? dipNavObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  GlobalKey<NavigatorState> get navigatorKey =>
      GetNavigation.getxController.key;

  GetDelegate(
      {this.notFoundRoute, this.dipNavObservers, this.transitionDelegate});

  /// Called by the [Router] at startup with the structure that the
  /// [RouteInformationParser] obtained from parsing the initial route.
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: routes.toList(),
      observers: [GetObserver()],
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
    routes.clear();
    return pushRoute(configuration);
  }

  /// Called by the [Router] when it detects a route information may have
  /// changed as a result of rebuild.
  @override
  GetPage get currentConfiguration {
    final route = routes.last;
    return route;
  }

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
    return notFoundRoute ??
        GetPage(
          name: '/404',
          page: () => Scaffold(
            body: Text('not found'),
          ),
        );
  }

  Future<T?> pushRoute<T>(
    GetPage route, {
    bool removeUntil = false,
    bool replaceCurrent = false,
    bool rebuildStack = true,
  }) {
    final completer = Completer<T?>();
    _resultCompleter[route] = completer;

    route = route.copy(unknownRoute: _notFound());
    assert(!(removeUntil && replaceCurrent),
        'Only removeUntil or replaceCurrent should by true!');
    if (removeUntil) {
      routes.clear();
    } else if (replaceCurrent && routes.isNotEmpty) {
      routes.removeLast();
    }
    addPage(route);
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
    return routes.isNotEmpty;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    routes.remove(route.settings);
    refresh();
    return true;
  }

  void removePage(GetPage page) {
    routes.remove(page);

    refresh();
  }

  void addPage(GetPage route) {
    routes.add(
      route,
    );
    refresh();
  }

  void addRoutes(List<GetPage> pages) {
    routes.addAll(pages);
    refresh();
  }
}

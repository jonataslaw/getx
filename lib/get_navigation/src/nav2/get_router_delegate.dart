import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../get.dart';
import '../../../get_state_manager/src/simple/list_notifier.dart';

/// Enables the user to customize the intended pop behavior
///
/// Goes to either the previous history entry or the previous page entry
///
/// e.g. if the user navigates to these pages
/// 1) /home
/// 2) /home/products/1234
///
/// when popping on [History] mode, it will emulate a browser back button.
///
/// so the new history stack will be:
/// 1) /home
///
/// when popping on [Page] mode, it will only remove the last part of the route
/// so the new history stack will be:
/// 1) /home
/// 2) /home/products
///
/// another pop will change the history stack to:
/// 1) /home
enum PopMode {
  History,
  Page,
}

/// Enables the user to customize the behavior when pushing multiple routes that
/// shouldn't be duplicates
enum PreventDuplicateHandlingMode {
  /// Removes the history entries until it reaches the old route
  PopUntilOriginalRoute,

  /// Simply don't push the new route
  DoNothing,

  /// Recommended - Moves the old route entry to the front
  ///
  /// With this mode, you guarantee there will be only one
  /// route entry for each location
  ReorderRoutes
}

class GetDelegate extends RouterDelegate<GetNavConfig>
    with ListenableMixin, ListNotifierMixin {
  final List<GetNavConfig> history = <GetNavConfig>[];
  final PopMode backButtonPopMode;
  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;

  GetPage? notFoundRoute;

  final List<NavigatorObserver>? navigatorObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;
  final _resultCompleter = <GetNavConfig, Completer<Object?>>{};

  GlobalKey<NavigatorState> get navigatorKey =>
      GetNavigation.getxController.key;

  GetDelegate({
    this.notFoundRoute,
    this.navigatorObservers,
    this.transitionDelegate,
    this.backButtonPopMode = PopMode.History,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.ReorderRoutes,
  }) {
    Get.log('GetDelegate is created !');
  }

  GetNavConfig? runMiddleware(GetNavConfig config) {
    final middlewares = config.currentTreeBranch.last.middlewares ?? [];
    var iterator = config;
    for (var item in middlewares) {
      var redirectRes = item.redirectDelegate(iterator);
      if (redirectRes == null) return null;
      iterator = redirectRes;
    }
    return iterator;
  }

  void _unsafeHistoryAdd(GetNavConfig config) {
    final res = runMiddleware(config);
    if (res == null) return;
    history.add(res);
  }

  void _unsafeHistoryRemove(GetNavConfig config) {
    var index = history.indexOf(config);
    if (index >= 0) _unsafeHistoryRemoveAt(index);
  }

  GetNavConfig? _unsafeHistoryRemoveAt(int index) {
    if (index == history.length - 1 && history.length > 1) {
      //removing WILL update the current route
      final toCheck = history[history.length - 2];
      final resMiddleware = runMiddleware(toCheck);
      if (resMiddleware == null) return null;
      history[history.length - 2] = resMiddleware;
    }
    return history.removeAt(index);
  }

  void _unsafeHistoryClear() {
    history.clear();
  }

  /// Adds a new history entry and waits for the result
  Future<T?> pushHistory<T>(
    GetNavConfig config, {
    bool rebuildStack = true,
  }) {
    //this changes the currentConfiguration
    final completer = Completer<T?>();
    _resultCompleter[config] = completer;
    _pushHistory(config);
    if (rebuildStack) {
      refresh();
    }
    return completer.future;
  }

  void _removeHistoryEntry(GetNavConfig entry) {
    _unsafeHistoryRemove(entry);
    final lastCompleter = _resultCompleter.remove(entry);
    lastCompleter?.complete(entry);
  }

  void _pushHistory(GetNavConfig config) {
    if (config.currentPage!.preventDuplicates) {
      final originalEntryIndex =
          history.indexWhere((element) => element.location == config.location);
      if (originalEntryIndex >= 0) {
        switch (preventDuplicateHandlingMode) {
          case PreventDuplicateHandlingMode.PopUntilOriginalRoute:
            until(config.location!, popMode: PopMode.Page);
            break;
          case PreventDuplicateHandlingMode.ReorderRoutes:
            _unsafeHistoryRemoveAt(originalEntryIndex);
            _unsafeHistoryAdd(config);
            break;
          case PreventDuplicateHandlingMode.DoNothing:
          default:
            break;
        }
        return;
      }
    }
    _unsafeHistoryAdd(config);
  }

  // GetPageRoute getPageRoute(RouteSettings? settings) {
  //   return PageRedirect(settings ?? RouteSettings(name: '/404'), _notFound())
  //       .page();
  // }

  GetNavConfig? _popHistory() {
    if (!_canPopHistory()) return null;
    return _doPopHistory();
  }

  GetNavConfig? _doPopHistory() {
    return _unsafeHistoryRemoveAt(history.length - 1);
  }

  GetNavConfig? _popPage() {
    if (!_canPopPage()) return null;
    return _doPopPage();
  }

  GetNavConfig? _pop(PopMode mode) {
    switch (mode) {
      case PopMode.History:
        return _popHistory();
      case PopMode.Page:
        return _popPage();
      default:
        return null;
    }
  }

  // returns the popped page
  GetNavConfig? _doPopPage() {
    final currentBranch = currentConfiguration?.currentTreeBranch;
    if (currentBranch != null && currentBranch.length > 1) {
      //remove last part only
      final remaining = currentBranch.take(currentBranch.length - 1);
      final prevHistoryEntry =
          history.length > 1 ? history[history.length - 2] : null;

      //check if current route is the same as the previous route
      if (prevHistoryEntry != null) {
        //if so, pop the entire history entry
        final newLocation = remaining.last.name;
        final prevLocation = prevHistoryEntry.location;
        if (newLocation == prevLocation) {
          //pop the entire history entry
          return _popHistory();
        }
      }

      //create a new route with the remaining tree branch
      final res = _popHistory();
      _pushHistory(
        GetNavConfig(
          currentTreeBranch: remaining.toList(),
          location: remaining.last.name,
          state: null, //TOOD: persist state??
        ),
      );
      return res;
    } else {
      //remove entire entry
      return _popHistory();
    }
  }

  Future<GetNavConfig?> popHistory() {
    return SynchronousFuture(_popHistory());
  }

  bool _canPopHistory() {
    return history.length > 1;
  }

  Future<bool> canPopHistory() {
    return SynchronousFuture(_canPopHistory());
  }

  bool _canPopPage() {
    final currentTreeBranch = currentConfiguration?.currentTreeBranch;
    if (currentTreeBranch == null) return false;
    return currentTreeBranch.length > 1 ? true : _canPopHistory();
  }

  Future<bool> canPopPage() {
    return SynchronousFuture(_canPopPage());
  }

  bool _canPop(PopMode mode) {
    switch (mode) {
      case PopMode.History:
        return _canPopHistory();
      case PopMode.Page:
      default:
        return _canPopPage();
    }
  }

  /// gets the visual pages from the current history entry
  ///
  /// visual pages must have the [RouterOutletContainerMiddleWare] middleware
  /// with `stayAt` equal to the route name of the visual page
  List<GetPage> getVisualPages() {
    final currentHistory = currentConfiguration;
    if (currentHistory == null) return <GetPage>[];

    final res = currentHistory.currentTreeBranch
        .where((r) => r.participatesInRootNavigator != null);
    if (res.length == 0) {
      //default behavoir, all routes participate in root navigator
      return currentHistory.currentTreeBranch;
    } else {
      //user specified at least one participatesInRootNavigator
      return res
          .where((element) => element.participatesInRootNavigator == true)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = getVisualPages();
    final extraObservers = navigatorObservers;
    return GetNavigator(
      name: 'root',
      key: navigatorKey,
      onPopPage: _onPopVisualRoute,
      pages: pages,
      observers: [
        GetObserver(),
        if (extraObservers != null) ...extraObservers,
      ],
      transitionDelegate:
          transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
    );
  }

  @override
  Future<void> setInitialRoutePath(GetNavConfig configuration) async {
    //no need to clear history with Reorder route strategy
    // _unsafeHistoryClear();
    // _resultCompleter.clear();
    await pushHistory(configuration);
  }

  @override
  Future<void> setNewRoutePath(GetNavConfig configuration) async {
    await pushHistory(configuration);
  }

  @override
  GetNavConfig? get currentConfiguration {
    if (history.isEmpty) return null;
    final route = history.last;
    return route;
  }

  Future<T?> toNamed<T>(String fullRoute) {
    final decoder = Get.routeTree.matchRoute(fullRoute);
    return pushHistory<T>(
      GetNavConfig(
        currentTreeBranch: decoder.treeBranch,
        location: fullRoute,
        state: null, //TODO: persist state?
      ),
    );
  }

  Future<T?> offNamed<T>(String fullRoute) async {
    await popHistory();
    return await toNamed(fullRoute);
  }

  /// Removes routes according to [PopMode]
  /// until it reaches the specifc [fullRoute],
  /// DOES NOT remove the [fullRoute]
  void until(
    String fullRoute, {
    PopMode popMode = PopMode.Page,
  }) {
    // remove history or page entries until you meet route

    var iterator = currentConfiguration;
    while (_canPop(popMode) &&
        iterator != null &&
        iterator.location != fullRoute) {
      _pop(popMode);
      // replace iterator
      iterator = currentConfiguration;
    }
    refresh();
  }

  // GetPage _notFound() {
  //   return notFoundRoute ??= GetPage(
  //     name: '/404',
  //     page: () => Scaffold(
  //       body: Text('not found'),
  //     ),
  //   );
  // }

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
    PopMode popMode = PopMode.Page,
  }) async {
    //Returning false will cause the entire app to be popped.
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) return true;
    final _popped = _pop(popMode);
    refresh();
    if (_popped != null) {
      //emulate the old pop with result
      final lastCompleter = _resultCompleter.remove(_popped);
      lastCompleter?.complete(result);
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool _onPopVisualRoute(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    final settings = route.settings;
    if (settings is GetPage) {
      final config = history.cast<GetNavConfig?>().firstWhere(
            (element) => element?.currentPage == settings,
            orElse: () => null,
          );
      if (config != null) {
        _removeHistoryEntry(config);
      }
    }
    refresh();
    return true;
  }
}

class GetNavigator extends Navigator {
  GetNavigator({
    GlobalKey<NavigatorState>? key,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required List<Page> pages,
    List<NavigatorObserver>? observers,
    bool reportsRouteUpdateToEngine = false,
    TransitionDelegate? transitionDelegate,
    String? name,
  })  : assert(key != null || name != null,
            'GetNavigator should either have a key or a name set'),
        super(
          key: key ?? Get.nestedKey(name),
          onPopPage: onPopPage,
          reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
          pages: pages,
          observers: [
            GetObserver(),
            if (observers != null) ...observers,
          ],
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}

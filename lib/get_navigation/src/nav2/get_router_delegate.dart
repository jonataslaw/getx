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

  final GetPage notFoundRoute;

  final List<NavigatorObserver>? navigatorObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  GlobalKey<NavigatorState> get navigatorKey => Get.key;

  GetDelegate({
    GetPage? notFoundRoute,
    this.navigatorObservers,
    this.transitionDelegate,
    this.backButtonPopMode = PopMode.History,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.ReorderRoutes,
  }) : notFoundRoute = notFoundRoute ??
            GetPage(
              name: '/404',
              page: () => Scaffold(
                body: Text('Route not found'),
              ),
            ) {
    Get.log('GetDelegate is created !');
  }

  Future<GetNavConfig?> runMiddleware(GetNavConfig config) async {
    final middlewares = config.currentTreeBranch.last.middlewares;
    if (middlewares == null) {
      return config;
    }
    var iterator = config;
    for (var item in middlewares) {
      var redirectRes = await item.redirectDelegate(iterator);
      if (redirectRes == null) return null;
      iterator = redirectRes;
    }
    return iterator;
  }

  Future<void> _unsafeHistoryAdd(GetNavConfig config) async {
    final res = await runMiddleware(config);
    if (res == null) return;
    history.add(res);
  }

  Future<void> _unsafeHistoryRemove(GetNavConfig config) async {
    var index = history.indexOf(config);
    if (index >= 0) await _unsafeHistoryRemoveAt(index);
  }

  Future<GetNavConfig?> _unsafeHistoryRemoveAt(int index) async {
    if (index == history.length - 1 && history.length > 1) {
      //removing WILL update the current route
      final toCheck = history[history.length - 2];
      final resMiddleware = await runMiddleware(toCheck);
      if (resMiddleware == null) return null;
      history[history.length - 2] = resMiddleware;
    }
    return history.removeAt(index);
  }

  T arguments<T>() {
    return currentConfiguration?.currentPage?.arguments as T;
  }

  Map<String, String> get parameters {
    return currentConfiguration?.currentPage?.parameters ?? {};
  }

  // void _unsafeHistoryClear() {
  //   history.clear();
  // }

  /// Adds a new history entry and waits for the result
  Future<void> pushHistory(
    GetNavConfig config, {
    bool rebuildStack = true,
  }) async {
    //this changes the currentConfiguration
    await _pushHistory(config);
    if (rebuildStack) {
      refresh();
    }
  }

  Future<void> _removeHistoryEntry(GetNavConfig entry) async {
    await _unsafeHistoryRemove(entry);
  }

  Future<void> _pushHistory(GetNavConfig config) async {
    if (config.currentPage!.preventDuplicates) {
      final originalEntryIndex =
          history.indexWhere((element) => element.location == config.location);
      if (originalEntryIndex >= 0) {
        switch (preventDuplicateHandlingMode) {
          case PreventDuplicateHandlingMode.PopUntilOriginalRoute:
            await backUntil(config.location!, popMode: PopMode.Page);
            break;
          case PreventDuplicateHandlingMode.ReorderRoutes:
            await _unsafeHistoryRemoveAt(originalEntryIndex);
            await _unsafeHistoryAdd(config);
            break;
          case PreventDuplicateHandlingMode.DoNothing:
          default:
            break;
        }
        return;
      }
    }
    await _unsafeHistoryAdd(config);
  }

  // GetPageRoute getPageRoute(RouteSettings? settings) {
  //   return PageRedirect(settings ?? RouteSettings(name: '/404'), _notFound())
  //       .page();
  // }

  Future<GetNavConfig?> _popHistory() async {
    if (!_canPopHistory()) return null;
    return await _doPopHistory();
  }

  Future<GetNavConfig?> _doPopHistory() async {
    return await _unsafeHistoryRemoveAt(history.length - 1);
  }

  Future<GetNavConfig?> _popPage() async {
    if (!_canPopPage()) return null;
    return await _doPopPage();
  }

  Future<GetNavConfig?> _pop(PopMode mode) async {
    switch (mode) {
      case PopMode.History:
        return await _popHistory();
      case PopMode.Page:
        return await _popPage();
      default:
        return null;
    }
  }

  // returns the popped page
  Future<GetNavConfig?> _doPopPage() async {
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
          return await _popHistory();
        }
      }

      //create a new route with the remaining tree branch
      final res = await _popHistory();
      await _pushHistory(
        GetNavConfig(
          currentTreeBranch: remaining.toList(),
          location: remaining.last.name,
          state: null, //TOOD: persist state??
        ),
      );
      return res;
    } else {
      //remove entire entry
      return await _popHistory();
    }
  }

  Future<GetNavConfig?> popHistory() async {
    return await _popHistory();
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
  /// visual pages must have [participatesInRootNavigator] set to true
  List<GetPage> getVisualPages() {
    final currentHistory = currentConfiguration;
    if (currentHistory == null) return <GetPage>[];

    final res = currentHistory.currentTreeBranch
        .where((r) => r.participatesInRootNavigator != null);
    if (res.length == 0) {
      //default behavoir, all routes participate in root navigator
      return history.map((e) => e.currentPage!).toList();
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
    if (pages.length == 0) return SizedBox.shrink();
    final extraObservers = navigatorObservers;
    return GetNavigator(
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

  // @override
  // Future<void> setInitialRoutePath(GetNavConfig configuration) async {
  //   //no need to clear history with Reorder route strategy
  //   // _unsafeHistoryClear();
  //   // _resultCompleter.clear();
  //   await pushHistory(configuration);
  // }

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

  Future<T> toNamed<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    final decoder = Get.routeTree.matchRoute(page, arguments: arguments);
    decoder.replaceArguments(arguments);

    final completer = Completer<T>();

    if (decoder.route != null) {
      _allCompleters[decoder.route!] = completer;
      await pushHistory(
        GetNavConfig(
          currentTreeBranch: decoder.treeBranch,
          location: page,
          state: null, //TODO: persist state?
        ),
      );

      return completer.future;
    } else {
      ///TODO: IMPLEMENT ROUTE NOT FOUND

      return Future.value();
    }
  }

  Future<T?>? offAndToNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    dynamic result,
    Map<String, String>? parameters,
    PopMode popMode = PopMode.History,
  }) async {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    await popRoute(result: result);
    return toNamed(page, arguments: arguments, parameters: parameters);
  }

  Future<T> offNamed<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    history.removeLast();
    return toNamed<T>(page, arguments: arguments, parameters: parameters);
  }

  /// Removes routes according to [PopMode]
  /// until it reaches the specifc [fullRoute],
  /// DOES NOT remove the [fullRoute]
  Future<void> backUntil(
    String fullRoute, {
    PopMode popMode = PopMode.Page,
  }) async {
    // remove history or page entries until you meet route
    var iterator = currentConfiguration;
    while (_canPop(popMode) &&
        iterator != null &&
        iterator.location != fullRoute) {
      await _pop(popMode);
      // replace iterator
      iterator = currentConfiguration;
    }
    refresh();
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
    PopMode popMode = PopMode.Page,
  }) async {
    //Returning false will cause the entire app to be popped.
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) return true;
    final _popped = await _pop(popMode);
    refresh();
    if (_popped != null) {
      //emulate the old pop with result
      return true;
    }
    return false;
  }

  final _allCompleters = <GetPage, Completer>{};

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
      if (_allCompleters.containsKey(settings)) {
        _allCompleters[settings]?.complete(route.popped);
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
  }) : super(
          //keys should be optional
          key: key,
          onPopPage: onPopPage ??
              (route, result) {
                final didPop = route.didPop(result);
                if (!didPop) {
                  return false;
                }
                return true;
              },
          reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
          pages: pages,
          observers: [
            // GetObserver(),
            if (observers != null) ...observers,
          ],
          transitionDelegate:
              transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );
}

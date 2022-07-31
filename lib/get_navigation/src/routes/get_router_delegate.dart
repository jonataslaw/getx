import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_instance/src/bindings_interface.dart';
import '../../../get_utils/src/platform/platform.dart';
import '../../../route_manager.dart';

class GetDelegate extends RouterDelegate<RouteDecoder>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<RouteDecoder>,
        IGetNavigation {
  final List<RouteDecoder> _activePages = <RouteDecoder>[];
  final PopMode backButtonPopMode;
  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;

  final GetPage notFoundRoute;

  final List<NavigatorObserver>? navigatorObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  final Iterable<GetPage> Function(RouteDecoder currentNavStack)?
      pickPagesForRootNavigator;

  List<RouteDecoder> get activePages => _activePages;

  final _routeTree = ParseRouteTree();

  final List<GetPage> _routes = [];

  List<GetPage> get registeredRoutes => _routes;

  void addPages(List<GetPage> getPages) {
    _routes.addRoutes(getPages);
  }

  void clearRouteTree() {
    _routes.clear();
  }

  void addPage(GetPage getPage) {
    _routes.addRoute(getPage);
  }

  void removePage(GetPage getPage) {
    _routes.removeRoute(getPage);
  }

  RouteDecoder? matchRoute(String name, {PageSettings? arguments}) {
    final settings = _buildPageSettings(name, arguments);
    return _getRouteDecoder(settings);
  }

  // GlobalKey<NavigatorState> get navigatorKey => Get.key;

  @override
  GlobalKey<NavigatorState> navigatorKey;

  final String? restorationScopeId;

  GetDelegate({
    GetPage? notFoundRoute,
    this.navigatorObservers,
    this.transitionDelegate,
    this.backButtonPopMode = PopMode.history,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    this.pickPagesForRootNavigator,
    this.restorationScopeId,
    bool showHashOnUrl = false,
    GlobalKey<NavigatorState>? navigatorKey,
    required List<GetPage> pages,
  })  : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        notFoundRoute = notFoundRoute ??= GetPage(
          name: '/404',
          page: () => Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        ) {
    if (!showHashOnUrl && GetPlatform.isWeb) setUrlStrategy();
    addPages(pages);
    addPage(notFoundRoute);
    Get.log('GetDelegate is created !');
  }

  Future<RouteDecoder?> runMiddleware(RouteDecoder config) async {
    final middlewares = config.currentTreeBranch.last.middlewares;
    if (middlewares == null) {
      return config;
    }
    var iterator = config;
    for (var item in middlewares) {
      var redirectRes = await item.redirectDelegate(iterator);
      if (redirectRes == null) return null;
      iterator = redirectRes;
      // Stop the iteration over the middleware if we changed page
      // and that redirectRes is not the same as the current config.
      if (config != redirectRes) {
        break;
      }
    }
    // If the target is not the same as the source, we need
    // to run the middlewares for the new route.
    if (iterator != config) {
      return await runMiddleware(iterator);
    }
    return iterator;
  }

  Future<void> _unsafeHistoryAdd(RouteDecoder config) async {
    final res = await runMiddleware(config);
    if (res == null) return;
    _activePages.add(res);
  }

  Future<T?> _unsafeHistoryRemove<T>(RouteDecoder config, T result) async {
    var index = _activePages.indexOf(config);
    if (index >= 0) return _unsafeHistoryRemoveAt(index, result);
    return null;
  }

  Future<T?> _unsafeHistoryRemoveAt<T>(int index, T result) async {
    if (index == _activePages.length - 1 && _activePages.length > 1) {
      //removing WILL update the current route
      final toCheck = _activePages[_activePages.length - 2];
      final resMiddleware = await runMiddleware(toCheck);
      if (resMiddleware == null) return null;
      _activePages[_activePages.length - 2] = resMiddleware;
    }

    final completer = _activePages.removeAt(index).route?.completer;
    if (completer?.isCompleted == false) completer!.complete(result);

    return completer?.future as T?;
  }

  T arguments<T>() {
    return currentConfiguration?.pageSettings?.arguments as T;
  }

  Map<String, String> get parameters {
    return currentConfiguration?.route?.parameters ??
        // currentConfiguration?.pageSettings?.params ??
        {};
  }

  PageSettings? get pageSettings {
    return currentConfiguration?.pageSettings;
  }

  Future<T?> _removeHistoryEntry<T>(RouteDecoder entry, T result) async {
    return _unsafeHistoryRemove<T>(entry, result);
  }

  Future<void> _pushHistory(RouteDecoder config) async {
    if (config.route!.preventDuplicates) {
      final originalEntryIndex = _activePages.indexWhere(
          (element) => element.pageSettings?.name == config.pageSettings?.name);
      if (originalEntryIndex >= 0) {
        switch (preventDuplicateHandlingMode) {
          case PreventDuplicateHandlingMode.popUntilOriginalRoute:
            popModeUntil(config.pageSettings!.name, popMode: PopMode.page);
            break;
          case PreventDuplicateHandlingMode.reorderRoutes:
            await _unsafeHistoryRemoveAt(originalEntryIndex, null);
            await _unsafeHistoryAdd(config);
            break;
          case PreventDuplicateHandlingMode.doNothing:
          default:
            break;
        }
        return;
      }
    }
    await _unsafeHistoryAdd(config);
  }

  Future<T?> _popHistory<T>(T result) async {
    if (!_canPopHistory()) return null;
    return await _doPopHistory(result);
  }

  Future<T?> _doPopHistory<T>(T result) async {
    return _unsafeHistoryRemoveAt<T>(_activePages.length - 1, result);
  }

  Future<T?> _popPage<T>(T result) async {
    if (!_canPopPage()) return null;
    return await _doPopPage(result);
  }

  // returns the popped page
  Future<T?> _doPopPage<T>(T result) async {
    final currentBranch = currentConfiguration?.currentTreeBranch;
    if (currentBranch != null && currentBranch.length > 1) {
      //remove last part only
      final remaining = currentBranch.take(currentBranch.length - 1);
      final prevHistoryEntry = _activePages.length > 1
          ? _activePages[_activePages.length - 2]
          : null;

      //check if current route is the same as the previous route
      if (prevHistoryEntry != null) {
        //if so, pop the entire _activePages entry
        final newLocation = remaining.last.name;
        final prevLocation = prevHistoryEntry.pageSettings?.name;
        if (newLocation == prevLocation) {
          //pop the entire _activePages entry
          return await _popHistory(result);
        }
      }

      //create a new route with the remaining tree branch
      final res = await _popHistory<T>(result);
      await _pushHistory(
        RouteDecoder(
          remaining.toList(),
          null,
          //TOOD: persist state??
        ),
      );
      return res;
    } else {
      //remove entire entry
      return await _popHistory(result);
    }
  }

  Future<T?> _pop<T>(PopMode mode, T result) async {
    switch (mode) {
      case PopMode.history:
        return await _popHistory<T>(result);
      case PopMode.page:
        return await _popPage<T>(result);
      default:
        return null;
    }
  }

  Future<T?> popHistory<T>(T result) async {
    return await _popHistory<T>(result);
  }

  bool _canPopHistory() {
    return _activePages.length > 1;
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

  bool _canPop(mode) {
    switch (mode) {
      case PopMode.history:
        return _canPopHistory();
      case PopMode.page:
      default:
        return _canPopPage();
    }
  }

  /// gets the visual pages from the current _activePages entry
  ///
  /// visual pages must have [GetPage.participatesInRootNavigator] set to true
  Iterable<GetPage> getVisualPages(RouteDecoder? currentHistory) {
    final res = currentHistory!.currentTreeBranch
        .where((r) => r.participatesInRootNavigator != null);
    if (res.isEmpty) {
      //default behavoir, all routes participate in root navigator
      return _activePages.map((e) => e.route!);
    } else {
      //user specified at least one participatesInRootNavigator
      return res
          .where((element) => element.participatesInRootNavigator == true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHistory = currentConfiguration;
    final pages = currentHistory == null
        ? <GetPage>[]
        : pickPagesForRootNavigator?.call(currentHistory).toList() ??
            getVisualPages(currentHistory).toList();
    if (pages.isEmpty) {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
      );
    }
    return GetNavigator(
      key: navigatorKey,
      onPopPage: _onPopVisualRoute,
      pages: pages,
      observers: navigatorObservers,
      transitionDelegate:
          transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
    );
  }

  @override
  Future<void> goToUnknownPage([bool clearPages = false]) async {
    if (clearPages) _activePages.clear();

    final pageSettings = _buildPageSettings(notFoundRoute.name);
    final routeDecoder = _getRouteDecoder(pageSettings);

    _push(routeDecoder!);
  }

  @protected
  void _popWithResult<T>([T? result]) {
    final completer = _activePages.removeLast().route?.completer;
    if (completer?.isCompleted == false) completer!.complete(result);
  }

  @override
  Future<T?> toNamed<T>(
    String page, {
    dynamic arguments,
    dynamic id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route != null) {
      return _push<T>(route);
    } else {
      goToUnknownPage();
    }
    return null;
  }

  @override
  Future<T?> to<T>(
    Widget Function() page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    int? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
    bool rebuildStack = true,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");
    // if (preventDuplicateHandlingMode ==
    // PreventDuplicateHandlingMode.Recreate) {
    //   routeName = routeName + page.hashCode.toString();
    // }

    final getPage = GetPage<T>(
      name: routeName,
      opaque: opaque ?? true,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Get.defaultPopGesture,
      transition: transition ?? Get.defaultTransition,
      curve: curve ?? Get.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      bindings: bindings,
      transitionDuration: duration ?? Get.defaultTransitionDuration,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
    );

    _routes.addRoute(getPage);
    final args = _buildPageSettings(routeName, arguments);
    final route = _getRouteDecoder<T>(args);
    final result = await _push<T>(
      route!,
      rebuildStack: rebuildStack,
    );
    _routes.removeRoute(getPage);
    return result;
  }

  @override
  Future<T?> off<T>(
    Widget Function() page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    int? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");
    final route = GetPage<T>(
      name: routeName,
      opaque: opaque ?? true,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Get.defaultPopGesture,
      transition: transition ?? Get.defaultTransition,
      curve: curve ?? Get.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      bindings: bindings,
      transitionDuration: duration ?? Get.defaultTransitionDuration,
    );

    final args = _buildPageSettings(routeName, arguments);
    return _replace(args, route);
  }

  @override
  Future<T?>? offAll<T>(
    Widget Function() page, {
    bool Function(GetPage route)? predicate,
    bool opaque = true,
    bool? popGesture,
    int? id,
    String? routeName,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool fullscreenDialog = false,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    routeName = _cleanRouteName("/${page.runtimeType}");
    final route = GetPage<T>(
      name: routeName,
      opaque: opaque,
      page: page,
      gestureWidth: gestureWidth,
      showCupertinoParallax: showCupertinoParallax,
      popGesture: popGesture ?? Get.defaultPopGesture,
      transition: transition ?? Get.defaultTransition,
      curve: curve ?? Get.defaultTransitionCurve,
      fullscreenDialog: fullscreenDialog,
      bindings: bindings,
      transitionDuration: duration ?? Get.defaultTransitionDuration,
    );

    final args = _buildPageSettings(routeName, arguments);

    final newPredicate = predicate ?? (route) => false;

    while (_activePages.length > 1 && !newPredicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _replace(args, route);
  }

  @override
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    // bool Function(GetPage route)? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(newRouteName, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;

    while (_activePages.length > 1) {
      _activePages.removeLast();
    }

    return _replaceNamed(route);
  }

  @override
  Future<T?>? offNamedUntil<T>(
    String page, {
    bool Function(GetPage route)? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;

    final newPredicate = predicate ?? (route) => false;

    while (_activePages.length > 1 && newPredicate(_activePages.last.route!)) {
      _activePages.removeLast();
    }

    return _replaceNamed(route);
  }

  @override
  Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<T>(args);
    if (route == null) return null;
    _popWithResult();
    return _push<T>(route);
  }

  @override
  Future<T?> toNamedAndOffUntil<T>(
    String page,
    bool Function(GetPage) predicate, [
    Object? data,
  ]) async {
    final arguments = _buildPageSettings(page, data);

    final route = _getRouteDecoder<T>(arguments);

    if (route == null) return null;

    while (_activePages.isNotEmpty && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _push<T>(route);
  }

  @override
  Future<T?> offUntil<T>(
    Widget Function() page,
    bool Function(GetPage) predicate, [
    Object? arguments,
  ]) async {
    while (_activePages.isNotEmpty && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return to<T>(page, arguments: arguments);
  }

  @override
  void removeRoute<T>(String name) {
    _activePages.remove(RouteDecoder.fromRoute(name));
  }

  @override
  void back<T>([T? result]) {
    _checkIfCanBack();
    _popWithResult<T>(result);
    notifyListeners();
  }

  bool get canBack {
    return _activePages.length > 1;
  }

  void _checkIfCanBack() {
    assert(() {
      if (!canBack) {
        final last = _activePages.last;
        final name = last.route?.name;
        throw 'The page $name cannot be popped';
      }
      return true;
    }());
  }

  @override
  Future<R?> backAndtoNamed<T, R>(String page,
      {T? result, Object? arguments}) async {
    final args = _buildPageSettings(page, arguments);
    final route = _getRouteDecoder<R>(args);
    if (route == null) return null;
    _popWithResult<T>(result);
    return _push<R>(route);
  }

  /// Removes routes according to [PopMode]
  /// until it reaches the specifc [fullRoute],
  /// DOES NOT remove the [fullRoute]
  @override
  Future<void> popModeUntil(
    String fullRoute, {
    PopMode popMode = PopMode.history,
  }) async {
    // remove history or page entries until you meet route
    var iterator = currentConfiguration;
    while (_canPop(popMode) &&
        iterator != null &&
        iterator.pageSettings?.name != fullRoute) {
      await _pop(popMode, null);
      // replace iterator
      iterator = currentConfiguration;
    }
    notifyListeners();
  }

  @override
  void backUntil(bool Function(GetPage) predicate) {
    while (_activePages.length <= 1 && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    notifyListeners();
  }

  Future<T?> _replace<T>(PageSettings arguments, GetPage<T> page) async {
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;
    _routes.addRoute(page);

    final activePage = _getRouteDecoder(arguments);

    // final activePage = _configureRouterDecoder<T>(route!, arguments);

    _activePages[index] = activePage!;

    notifyListeners();
    final result = await activePage.route?.completer?.future as Future<T?>?;
    _routes.removeRoute(page);

    return result;
  }

  Future<T?> _replaceNamed<T>(RouteDecoder activePage) async {
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;
    // final activePage = _configureRouterDecoder<T>(page, arguments);
    _activePages[index] = activePage;

    notifyListeners();
    final result = await activePage.route?.completer?.future as Future<T?>?;
    return result;
  }

  /// Takes a route [name] String generated by [to], [off], [offAll]
  /// (and similar context navigation methods), cleans the extra chars and
  /// accommodates the format.
  /// TODO: check for a more "appealing" URL naming convention.
  /// `() => MyHomeScreenView` becomes `/my-home-screen-view`.
  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  PageSettings _buildPageSettings(String page, [Object? data]) {
    var uri = Uri.parse(page);
    return PageSettings(uri, data);
  }

  @protected
  RouteDecoder? _getRouteDecoder<T>(PageSettings arguments) {
    var page = arguments.uri.path;
    final parameters = arguments.params;
    if (parameters.isNotEmpty) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    final decoder =
        _routeTree.matchRoute(registeredRoutes, page, arguments: arguments);
    final route = decoder.route;
    if (route == null) return null;

    return _configureRouterDecoder(decoder, arguments);
  }

  @protected
  RouteDecoder _configureRouterDecoder<T>(
      RouteDecoder decoder, PageSettings arguments) {
    final parameters =
        arguments.params.isEmpty ? arguments.query : arguments.params;
    if (arguments.params.isEmpty) {
      arguments.params.addAll(arguments.query);
    }
    if (decoder.parameters.isEmpty) {
      decoder.parameters.addAll(parameters);
    }

    decoder.route = decoder.route?.copy(
      completer: _activePages.isEmpty ? null : Completer(),
      arguments: arguments,
      parameters: parameters,
      //  key: ValueKey(arguments.name),
    );

    return decoder;
  }

  Future<T?> _push<T>(RouteDecoder decoder, {bool rebuildStack = true}) async {
    var mid = await runMiddleware(decoder);
    final res = mid ?? decoder;
    // if (res == null) res = decoder;

    final preventDuplicateHandlingMode =
        res.route?.preventDuplicateHandlingMode ??
            PreventDuplicateHandlingMode.reorderRoutes;

    final onStackPage = _activePages
        .firstWhereOrNull((element) => element.route?.key == res.route?.key);

    /// There are no duplicate routes in the stack
    if (onStackPage == null) {
      _activePages.add(res);
    } else {
      /// There are duplicate routes, reorder
      switch (preventDuplicateHandlingMode) {
        case PreventDuplicateHandlingMode.doNothing:
          break;
        case PreventDuplicateHandlingMode.reorderRoutes:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          break;
        case PreventDuplicateHandlingMode.popUntilOriginalRoute:
          while (_activePages.last == onStackPage) {
            _popWithResult();
          }
          break;
        case PreventDuplicateHandlingMode.recreate:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          break;
        default:
      }
    }
    if (rebuildStack) {
      notifyListeners();
    }

    return decoder.route?.completer?.future as Future<T?>?;
  }

  @override
  Future<void> setNewRoutePath(RouteDecoder configuration) async {
    final page = configuration.route;
    if (page == null) {
      goToUnknownPage();
      return;
    } else {
      _push(configuration);
    }
  }

  @override
  RouteDecoder? get currentConfiguration {
    if (_activePages.isEmpty) return null;
    final route = _activePages.last;
    return route;
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
    PopMode? popMode,
  }) async {
    //Returning false will cause the entire app to be popped.
    final wasPopup = await handlePopupRoutes(result: result);
    if (wasPopup) return true;
    final _popped = await _pop(popMode ?? backButtonPopMode, result);
    notifyListeners();
    if (_popped != null) {
      //emulate the old pop with result
      return true;
    }
    return false;
  }

  bool _onPopVisualRoute(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    final settings = route.settings;
    if (settings is GetPage) {
      final config = _activePages.cast<RouteDecoder?>().firstWhere(
            (element) => element?.route == settings,
            orElse: () => null,
          );
      if (config != null) {
        _removeHistoryEntry(config, result);
      }
    }
    notifyListeners();
    //return !route.navigator!.userGestureInProgress;
    return true;
  }
}

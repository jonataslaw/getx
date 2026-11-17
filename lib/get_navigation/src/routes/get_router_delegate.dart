import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_instance/src/bindings_interface.dart';
import '../../../get_utils/src/platform/platform.dart';
import '../../../route_manager.dart';

import 'parse_route.dart';

class GetDelegate extends RouterDelegate<RouteDecoder>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<RouteDecoder>,
        IGetNavigation {
  factory GetDelegate.createDelegate({
    GetPage<dynamic>? notFoundRoute,
    List<GetPage> pages = const [],
    List<NavigatorObserver>? navigatorObservers,
    TransitionDelegate<dynamic>? transitionDelegate,
    PopMode backButtonPopMode = PopMode.history,
    PreventDuplicateHandlingMode preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
  }) {
    return GetDelegate(
      notFoundRoute: notFoundRoute,
      navigatorObservers: navigatorObservers,
      transitionDelegate: transitionDelegate,
      backButtonPopMode: backButtonPopMode,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
      pages: pages,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
    );
  }

  final List<RouteDecoder> _activePages = <RouteDecoder>[];
  bool _isDisposed = false;
  int _restorationImport = 0;
  int _nextRestorationId = 0;
  final _restorationIds = Expando<int>('GetX navigation restoration');
  final _pendingMiddleware = <Completer<RouteDecoder?>>{};

  @override
  void dispose() {
    _isDisposed = true;
    _restorationImport++;
    for (final pending in _pendingMiddleware.toList()) {
      pending.complete(null);
    }
    _pendingMiddleware.clear();
    while (_activePages.isNotEmpty) {
      _popWithResult();
    }
    super.dispose();
  }

  final PopMode backButtonPopMode;
  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;

  final GetPage notFoundRoute;

  final List<NavigatorObserver>? navigatorObservers;
  final TransitionDelegate<dynamic>? transitionDelegate;

  final Iterable<GetPage> Function(RouteDecoder currentNavStack)?
      pickPagesForRootNavigator;

  List<RouteDecoder> get activePages => _activePages;

  final _routeTree = ParseRouteTree(routes: []);

  List<GetPage> get registeredRoutes => _routeTree.routes;

  void addPages(List<GetPage> getPages) {
    _routeTree.addRoutes(getPages);
  }

  void clearRouteTree() {
    _routeTree.routes.clear();
  }

  void addPage(GetPage getPage) {
    _routeTree.addRoute(getPage);
  }

  void removePage(GetPage getPage) {
    _routeTree.removeRoute(getPage);
  }

  RouteDecoder matchRoute(String name, {PageSettings? arguments}) {
    return _routeTree.matchRoute(name, arguments: arguments);
  }

  // GlobalKey<NavigatorState> get navigatorKey => Get.key;

  @override
  GlobalKey<NavigatorState> navigatorKey;

  /// The navigator scope and opt-in for named-route history restoration.
  ///
  /// When non-null, route information includes up to 128 registered named
  /// entries and JSON-shaped arguments: null, booleans, finite numbers,
  /// strings, lists and maps with string keys. Arguments travel as JSON text
  /// inside the versioned state so platform JSON bridges preserve numeric types.
  /// Arguments are limited to depth
  /// 16 and the complete payload to 64 KiB. Unsupported values, cycles,
  /// incompatible page identities or excessive payloads fall back to the
  /// selected URI without history or arguments. Destinations must still be
  /// registered when restoring; middleware is evaluated again.
  ///
  /// Existing runtime futures for a retained history prefix remain live.
  /// Futures and their continuations cannot be restored after process death.
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
          page: () => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        ) {
    if (!showHashOnUrl && GetPlatform.isWeb) setUrlStrategy();
    addPages(pages);
    addPage(notFoundRoute);
    Get.log('GetDelegate is created !');
  }

  Future<RouteDecoder?> runMiddleware(RouteDecoder config) async {
    if (_isDisposed) {
      _completePage(config);
      return null;
    }
    final middlewares = config.currentTreeBranch.last.middlewares;
    if (middlewares.isEmpty) {
      return config;
    }
    var iterator = config;
    for (var item in middlewares) {
      final pending = Completer<RouteDecoder?>();
      _pendingMiddleware.add(pending);
      RouteDecoder? redirectRes;
      try {
        redirectRes = await Future.any<RouteDecoder?>([
          Future.sync(() => item.redirectDelegate(iterator)),
          pending.future,
        ]);
      } finally {
        _pendingMiddleware.remove(pending);
      }
      if (_isDisposed) {
        _completePage(config);
        return null;
      }

      if (redirectRes == null) {
        _completePage(config);
        return null;
      }
      if (config != redirectRes) {
        _completePage(config);
        Get.log('Redirect to ${redirectRes.pageSettings?.name}');
      }

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

  // Future<T?> _unsafeHistoryRemove<T>(RouteDecoder config, T result) async {
  //   var index = _activePages.indexOf(config);
  //   if (index >= 0) return _unsafeHistoryRemoveAt(index, result);
  //   return null;
  // }

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

    return result;
  }

  T arguments<T>() {
    return currentConfiguration?.pageSettings?.arguments as T;
  }

  Map<String, String> get parameters {
    return currentConfiguration?.pageSettings?.params ?? {};
  }

  PageSettings? get pageSettings {
    return currentConfiguration?.pageSettings;
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

  bool _canPop(PopMode mode) {
    switch (mode) {
      case PopMode.history:
        return _canPopHistory();
      case PopMode.page:
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
      //default behavior, all routes participate in root navigator
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
      onDidRemovePage: didRemovePage,
      pages: pages,
      restorationScopeId: restorationScopeId,
      observers: navigatorObservers,
      transitionDelegate:
          transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
    );
  }

  @override
  Future<void> goToUnknownPage([bool clearPages = false]) async {
    if (clearPages) {
      while (_activePages.isNotEmpty) {
        _popWithResult();
      }
    }

    final pageSettings = _buildPageSettings(notFoundRoute.name);
    final routeDecoder = _getRouteDecoder(pageSettings);

    _push(routeDecoder!);
  }

  @protected
  void _popWithResult<T>([T? result]) {
    _completePage(_activePages.removeLast(), result);
  }

  void _completePage<T>(RouteDecoder page, [T? result]) {
    final completer = page.route?.completer;
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
      if (!preventDuplicates) {
        route.route = route.route!.copyWith(
          preventDuplicates: false,
          key: UniqueKey(),
        );
      }
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
    String? id,
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
    routeName ??= _cleanRouteName("/${page.runtimeType}");
    // if (preventDuplicateHandlingMode ==
    //PreventDuplicateHandlingMode.Recreate) {
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
      preventDuplicates: preventDuplicates,
    );

    _routeTree.addRoute(getPage);
    final args = _buildPageSettings(routeName, arguments);
    final route = _getRouteDecoder<T>(args);
    final result = await _push<T>(
      route!,
      rebuildStack: rebuildStack,
    );
    _routeTree.removeRoute(getPage);
    return result;
  }

  @override
  Future<T?> off<T>(
    Widget Function() page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    String? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    routeName ??= _cleanRouteName("/${page.runtimeType}");
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
    String? id,
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
    routeName ??= _cleanRouteName("/${page.runtimeType}");
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

    return _replace(args, route, predicate: newPredicate);
  }

  @override
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    // bool Function(GetPage route)? predicate,
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(newRouteName, arguments);
    final decoded = _getRouteDecoder<T>(args);
    if (decoded == null) return null;
    final route = await runMiddleware(decoded);
    if (route == null) return null;

    while (_activePages.length > 1) {
      _popWithResult();
    }

    return _replaceNamed(route);
  }

  @override
  Future<T?>? offNamedUntil<T>(
    String page, {
    bool Function(GetPage route)? predicate,
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final decoded = _getRouteDecoder<T>(args);
    if (decoded == null) return null;
    final route = await runMiddleware(decoded);
    if (route == null) return null;

    final newPredicate = predicate ?? (route) => false;

    while (_activePages.length > 1 && !newPredicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _push<T>(route, middlewareAlreadyRun: true);
  }

  @override
  Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async {
    final args = _buildPageSettings(page, arguments);
    final decoded = _getRouteDecoder<T>(args);
    if (decoded == null) return null;
    final route = await runMiddleware(decoded);
    if (route == null) return null;
    _popWithResult();
    return _push<T>(route, middlewareAlreadyRun: true);
  }

  @override
  Future<T?> toNamedAndOffUntil<T>(
    String page,
    bool Function(GetPage) predicate, [
    Object? data,
  ]) async {
    final arguments = _buildPageSettings(page, data);

    final decoded = _getRouteDecoder<T>(arguments);
    if (decoded == null) return null;
    final route = await runMiddleware(decoded);
    if (route == null) return null;

    while (_activePages.isNotEmpty && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    return _push<T>(route, middlewareAlreadyRun: true);
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
    final index = _activePages.indexWhere(
        (page) => page.pageSettings?.name == name || page.route?.name == name);
    if (index < 0) return;
    _completePage(_activePages.removeAt(index));
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
    final decoded = _getRouteDecoder<R>(args);
    if (decoded == null) return null;
    final route = await runMiddleware(decoded);
    if (route == null) return null;
    _popWithResult<T>(result);
    return _push<R>(route, middlewareAlreadyRun: true);
  }

  /// Removes routes according to [PopMode]
  /// until it reaches the specific [fullRoute],
  /// DOES NOT remove the [fullRoute]
  @override
  Future<void> popModeUntil(
    String fullRoute, {
    PopMode popMode = PopMode.history,
  }) async {
    // remove history or page entries until you meet route
    var iterator = currentConfiguration;
    while (_canPop(popMode) && iterator != null) {
      //the next line causes wasm compile error if included in the while loop
      //https://github.com/flutter/flutter/issues/140110
      if (iterator.pageSettings?.name == fullRoute) {
        break;
      }
      await _pop(popMode, null);
      // replace iterator
      iterator = currentConfiguration;
    }
    notifyListeners();
  }

  @override
  void backUntil(bool Function(GetPage) predicate) {
    while (_activePages.length > 1 && !predicate(_activePages.last.route!)) {
      _popWithResult();
    }

    notifyListeners();
  }

  Future<T?> _replace<T>(PageSettings arguments, GetPage<T> page,
      {bool Function(GetPage)? predicate}) async {
    _routeTree.addRoute(page);
    final decoded = _getRouteDecoder<T>(arguments);
    final activePage = decoded == null ? null : await runMiddleware(decoded);
    if (activePage == null) {
      _routeTree.removeRoute(page);
      return null;
    }
    if (predicate != null) {
      while (_activePages.length > 1 && !predicate(_activePages.last.route!)) {
        _popWithResult();
      }
    }
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;
    final previousPage = _activePages.isEmpty ? null : _activePages[index];
    if (_activePages.isEmpty) {
      _activePages.add(activePage);
    } else {
      _activePages[index] = activePage;
    }
    if (previousPage != null &&
        !identical(
            previousPage.route?.completer, activePage.route?.completer)) {
      _completePage(previousPage);
    }

    notifyListeners();
    final result = await (activePage.route?.completer?.future as Future<T?>?);
    _routeTree.removeRoute(page);

    return result;
  }

  Future<T?> _replaceNamed<T>(RouteDecoder activePage) async {
    final index = _activePages.length > 1 ? _activePages.length - 1 : 0;
    // final activePage = _configureRouterDecoder<T>(page, arguments);
    final previousPage = _activePages.isEmpty ? null : _activePages[index];
    if (_activePages.isEmpty) {
      _activePages.add(activePage);
    } else {
      _activePages[index] = activePage;
    }
    if (previousPage != null &&
        !identical(
            previousPage.route?.completer, activePage.route?.completer)) {
      _completePage(previousPage);
    }

    notifyListeners();
    final result = await (activePage.route?.completer?.future as Future<T?>?);
    return result;
  }

  /// Takes a route [name] String generated by [to], [off], [offAll]
  /// (and similar context navigation methods), cleans the extra chars and
  /// accommodates the format.
  /// TODO: check for a more "appealing" URL naming convention.
  /// `() => MyHomeScreenView` becomes `/my-home-screen-view`.
  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncomment for URL styling.
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

    final decoder = _routeTree.matchRoute(page, arguments: arguments);
    final route = decoder.route;
    if (route == null) return null;

    return _configureRouterDecoder<T>(decoder, arguments);
  }

  @protected
  RouteDecoder _configureRouterDecoder<T>(
      RouteDecoder decoder, PageSettings arguments) {
    final parameters =
        arguments.params.isEmpty ? arguments.query : arguments.params;
    arguments.params.addAll(arguments.query);
    if (decoder.parameters.isEmpty) {
      decoder.parameters.addAll(parameters);
    }

    decoder.route = decoder.route?.copyWith(
      completer: _activePages.isEmpty ? null : Completer<T?>(),
      arguments: arguments,
      parameters: parameters,
      key: decoder.route!.preventDuplicates
          ? ValueKey(arguments.name)
          : UniqueKey(),
    );

    return decoder;
  }

  Future<T?> _push<T>(RouteDecoder decoder,
      {bool rebuildStack = true, bool middlewareAlreadyRun = false}) async {
    var res = middlewareAlreadyRun ? decoder : await runMiddleware(decoder);
    if (res == null) return null;
    // final res = mid ?? decoder;
    // if (res == null) res = decoder;

    final preventDuplicateHandlingMode =
        res.route?.preventDuplicateHandlingMode ??
            PreventDuplicateHandlingMode.reorderRoutes;

    final onStackPage = res.route!.preventDuplicates
        ? _activePages
            .firstWhereOrNull((element) => element.route?.key == res.route?.key)
        : null;

    /// There are no duplicate routes in the stack
    if (onStackPage == null) {
      _activePages.add(res);
    } else {
      /// There are duplicate routes, reorder
      switch (preventDuplicateHandlingMode) {
        case PreventDuplicateHandlingMode.doNothing:
          if (!identical(onStackPage.route?.completer, res.route?.completer)) {
            _completePage(res);
          }
          break;
        case PreventDuplicateHandlingMode.reorderRoutes:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          if (!identical(onStackPage.route?.completer, res.route?.completer)) {
            _completePage(onStackPage);
          }
          break;
        case PreventDuplicateHandlingMode.popUntilOriginalRoute:
          while (_activePages.last != onStackPage) {
            _popWithResult();
          }
          if (!identical(onStackPage.route?.completer, res.route?.completer)) {
            _completePage(res);
          }
          break;
        case PreventDuplicateHandlingMode.recreate:
          _activePages.remove(onStackPage);
          _activePages.add(res);
          if (!identical(onStackPage.route?.completer, res.route?.completer)) {
            _completePage(onStackPage);
          }
      }
    }
    if (rebuildStack) {
      notifyListeners();
    }

    return decoder.route?.completer?.future as Future<T?>?;
  }

  @override
  Future<void> setNewRoutePath(RouteDecoder configuration) async {
    final generation = ++_restorationImport;
    final history = configuration.restorationHistory;
    if (history != null) {
      if (history.scope == restorationScopeId &&
          await _restoreHistory(history, generation)) {
        return;
      }
      if (_isDisposed || generation != _restorationImport) return;
      // Invalid or rejected history retains ordinary guarded deep-link behavior.
      final uri = configuration.pageSettings?.uri;
      if (uri == null) return;
      final args = PageSettings(uri);
      configuration = matchRoute(uri.toString(), arguments: args);
      configuration.route = configuration.route?.copyWith(
        arguments: args,
        parameters: args.params,
      );
    }
    final page = configuration.route;
    if (page == null) {
      goToUnknownPage();
    } else {
      _push(configuration);
    }
  }

  @override
  Future<void> setRestoredRoutePath(RouteDecoder configuration) =>
      setNewRoutePath(configuration);

  bool _sameLiveHistory(List<RouteDecoder> previous) =>
      previous.length == _activePages.length &&
      List.generate(
        previous.length,
        (index) => identical(previous[index], _activePages[index]),
      ).every((same) => same);

  RouteDecoder? _restoredEntry(RestorableRouteEntry entry) {
    final args = PageSettings(entry.uri, entry.copyArguments());
    final decoder = matchRoute(entry.uri.toString(), arguments: args);
    final page = decoder.route;
    if (page == null || !page.path.regex.hasMatch(entry.uri.path)) return null;
    decoder.route = page.withFreshCompleter().copyWith(
      arguments: args,
      parameters: args.params,
      preventDuplicates: entry.preventDuplicates,
      key: entry.preventDuplicates ? ValueKey(args.name) : UniqueKey(),
    );
    return decoder;
  }

  Future<bool> _restoreHistory(
    RestorableRouteHistory history,
    int generation,
  ) async {
    final previous = List<RouteDecoder>.of(_activePages);
    final candidates = <RouteDecoder>[];
    final keys = <LocalKey?>{};
    final restorationIds = <String>{};
    for (final entry in history.entries) {
      final candidate = _restoredEntry(entry);
      if (candidate == null ||
          !keys.add(candidate.route!.key) ||
          (candidate.route!.restorationId != null &&
              !restorationIds.add(candidate.route!.restorationId!))) {
        return false;
      }
      candidates.add(candidate);
    }

    bool stale() =>
        _isDisposed ||
        generation != _restorationImport ||
        !_sameLiveHistory(previous);
    for (var index = 0; index < candidates.length; index++) {
      final candidate = candidates[index];
      final page = candidate.route;
      final branch = List<GetPage>.of(candidate.currentTreeBranch);
      final guarded = await runMiddleware(candidate);
      if (stale()) return true;
      if (!identical(guarded, candidate) || !identical(candidate.route, page) ||
          candidate.currentTreeBranch.length != branch.length ||
          Iterable<int>.generate(branch.length).any((index) =>
              !identical(branch[index], candidate.currentTreeBranch[index])) ||
          !history.entries[index].hasArguments(candidate.pageSettings?.arguments)) {
        return false;
      }
    }
    if (stale()) return true;

    var retained = 0;
    while (retained < previous.length && retained < candidates.length) {
      final old = previous[retained];
      final entry = history.entries[retained];
      final replacement = candidates[retained];
      if (_restorationIds[old] != entry.id ||
          old.pageSettings?.uri != entry.uri ||
          old.route?.preventDuplicates != entry.preventDuplicates ||
          old.route?.restorationId != replacement.route?.restorationId ||
          old.route?.page != replacement.route?.page ||
          !entry.hasArguments(old.pageSettings?.arguments)) {
        break;
      }
      candidates[retained] = old;
      retained++;
    }
    for (var index = 0; index < candidates.length; index++) {
      final id = history.entries[index].id;
      _restorationIds[candidates[index]] = id;
      if (_nextRestorationId <= id) _nextRestorationId = id + 1;
    }
    _activePages
      ..clear()
      ..addAll(candidates);
    // Settle only removed live entries after publishing a coherent replacement.
    for (final removed in previous.skip(retained)) {
      _completePage(removed);
    }
    if (!_isDisposed) notifyListeners();
    return true;
  }

  @override
  RouteDecoder? get currentConfiguration {
    if (_activePages.isEmpty) return null;
    final selected = _activePages.last;
    final scope = restorationScopeId;
    if (scope == null) return selected;
    final entries = <RestorableRouteEntry>[];
    final keys = <LocalKey?>{};
    final restorationIds = <String>{};
    for (final page in _activePages) {
      final settings = page.pageSettings;
      final route = page.route;
      if (settings == null ||
          route == null ||
          !keys.add(route.key) ||
          (route.restorationId != null &&
              !restorationIds.add(route.restorationId!))) {
        return selected;
      }
      final id = _restorationIds[page] ??= _nextRestorationId++;
      entries.add(
        RestorableRouteEntry(
          id,
          settings.uri,
          settings.arguments,
          route.preventDuplicates,
        ),
      );
    }
    final history = RestorableRouteHistory.create(scope, entries);
    if (history == null) return selected;
    return RouteDecoder(
      List.of(selected.currentTreeBranch),
      selected.pageSettings,
      restorationHistory: history,
    );
  }

  Future<bool> handlePopupRoutes({
    Object? result,
  }) async {
    Route? currentRoute;
    navigatorKey.currentState!.popUntil((route) {
      currentRoute = route;
      return true;
    });
    if (currentRoute is PopupRoute ||
        currentRoute?.popDisposition == RoutePopDisposition.doNotPop) {
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

    if (_canPop(popMode ?? backButtonPopMode)) {
      await _pop(popMode ?? backButtonPopMode, result);
      notifyListeners();
      return true;
    }

    return super.popRoute();
  }

  @override
  void back<T>([T? result]) {
    _checkIfCanBack();
    _popWithResult<T>(result);
    notifyListeners();
  }

  /// Removes the history entry whose page the navigator has already removed.
  ///
  /// This is a notification, not a back veto. The route completes its typed
  /// result through [GetPageRoute.didComplete]. Identity checks prevent an old
  /// removal from deleting a replacement page with the same key or name.
  void didRemovePage(Page<Object?> page) {
    if (_isDisposed) return;
    final completer = page is GetPage ? page.completer : null;
    final index = _activePages.indexWhere(
      (entry) =>
          identical(entry.route, page) ||
          (completer != null && identical(entry.route?.completer, completer)),
    );
    if (index < 0) return;
    _activePages.removeAt(index);
    notifyListeners();
  }
}

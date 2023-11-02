import 'package:flutter/foundation.dart';

import '../../../get.dart';

@immutable
class RouteDecoder {
  const RouteDecoder(
    this.currentTreeBranch,
    this.pageSettings,
  );

  factory RouteDecoder.fromRoute(final String location) {
    final uri = Uri.parse(location);
    final args = PageSettings(uri);
    final decoder =
        Get.rootController.rootDelegate.matchRoute(location, arguments: args);
    decoder.route = decoder.route?.copyWith(
      completer: null,
      arguments: args,
      parameters: args.params,
    );
    return decoder;
  }
  final List<GetPage> currentTreeBranch;
  final PageSettings? pageSettings;

  GetPage? get route =>
      currentTreeBranch.isEmpty ? null : currentTreeBranch.last;

  GetPage routeOrUnknown(final GetPage onUnknow) =>
      currentTreeBranch.isEmpty ? onUnknow : currentTreeBranch.last;

  set route(final GetPage? getPage) {
    if (getPage == null) return;
    if (currentTreeBranch.isEmpty) {
      currentTreeBranch.add(getPage);
    } else {
      currentTreeBranch[currentTreeBranch.length - 1] = getPage;
    }
  }

  List<GetPage>? get currentChildren => route?.children;

  Map<String, String> get parameters => pageSettings?.params ?? {};

  dynamic get args {
    return pageSettings?.arguments;
  }

  T? arguments<T>() {
    final args = pageSettings?.arguments;
    if (args is T) {
      return pageSettings?.arguments as T;
    } else {
      return null;
    }
  }

  void replaceArguments(final Object? arguments) {
    final newRoute = route;
    if (newRoute != null) {
      final index = currentTreeBranch.indexOf(newRoute);
      currentTreeBranch[index] = newRoute.copyWith(arguments: arguments);
    }
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is RouteDecoder &&
        listEquals(other.currentTreeBranch, currentTreeBranch) &&
        other.pageSettings == pageSettings;
  }

  @override
  int get hashCode => currentTreeBranch.hashCode ^ pageSettings.hashCode;

  @override
  String toString() =>
      'RouteDecoder(currentTreeBranch: $currentTreeBranch, pageSettings: $pageSettings)';
}

class ParseRouteTree {
  ParseRouteTree({
    required this.routes,
  });

  final List<GetPage> routes;

  RouteDecoder matchRoute(final String name, {final PageSettings? arguments}) {
    final uri = Uri.parse(name);
    final split = uri.path.split('/').where((final element) => element.isNotEmpty);
    var curPath = '/';
    final cumulativePaths = <String>[
      '/',
    ];
    for (final item in split) {
      if (curPath.endsWith('/')) {
        curPath += item;
      } else {
        curPath += '/$item';
      }
      cumulativePaths.add(curPath);
    }

    final treeBranch = cumulativePaths
        .map((final e) => MapEntry(e, _findRoute(e)))
        .where((final element) => element.value != null)

        ///Prevent page be disposed
        .map((final e) => MapEntry(e.key, e.value!.copyWith(key: ValueKey(e.key))))
        .toList();

    final params = Map<String, String>.from(uri.queryParameters);
    if (treeBranch.isNotEmpty) {
      //route is found, do further parsing to get nested query params
      final lastRoute = treeBranch.last;
      final parsedParams = _parseParams(name, lastRoute.value.path);
      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }
      //copy parameters to all pages.
      final mappedTreeBranch = treeBranch
          .map(
            (final e) => e.value.copyWith(
              parameters: {
                if (e.value.parameters != null) ...e.value.parameters!,
                ...params,
              },
              name: e.key,
            ),
          )
          .toList();
      arguments?.params.clear();
      arguments?.params.addAll(params);
      return RouteDecoder(
        mappedTreeBranch,
        arguments,
      );
    }

    arguments?.params.clear();
    arguments?.params.addAll(params);

    //route not found
    return RouteDecoder(
      treeBranch.map((final e) => e.value).toList(),
      arguments,
    );
  }

  void addRoutes<T>(final List<GetPage<T>> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void removeRoutes<T>(final List<GetPage<T>> getPages) {
    for (final route in getPages) {
      removeRoute(route);
    }
  }

  void removeRoute<T>(final GetPage<T> route) {
    routes.remove(route);
    for (final page in _flattenPage(route)) {
      removeRoute(page);
    }
  }

  void addRoute<T>(final GetPage<T> route) {
    routes.add(route);

    // Add Page children.
    for (final page in _flattenPage(route)) {
      addRoute(page);
    }
  }

  List<GetPage> _flattenPage(final GetPage route) {
    final result = <GetPage>[];
    if (route.children.isEmpty) {
      return result;
    }

    final parentPath = route.name;
    for (final page in route.children) {
      // Add Parent middlewares to children
      final parentMiddlewares = [
        if (page.middlewares.isNotEmpty) ...page.middlewares,
        if (route.middlewares.isNotEmpty) ...route.middlewares
      ];

      final parentBindings = [
        if (page.binding != null) page.binding!,
        if (page.bindings.isNotEmpty) ...page.bindings,
        if (route.bindings.isNotEmpty) ...route.bindings
      ];

      final parentBinds = [
        if (page.binds.isNotEmpty) ...page.binds,
        if (route.binds.isNotEmpty) ...route.binds
      ];

      result.add(
        _addChild(
          page,
          parentPath,
          parentMiddlewares,
          parentBindings,
          parentBinds,
        ),
      );

      final children = _flattenPage(page);
      for (final child in children) {
        result.add(_addChild(
          child,
          parentPath,
          [
            ...parentMiddlewares,
            if (child.middlewares.isNotEmpty) ...child.middlewares,
          ],
          [
            ...parentBindings,
            if (child.binding != null) child.binding!,
            if (child.bindings.isNotEmpty) ...child.bindings,
          ],
          [
            ...parentBinds,
            if (child.binds.isNotEmpty) ...child.binds,
          ],
        ));
      }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  GetPage _addChild(
    final GetPage origin,
    final String parentPath,
    final List<GetMiddleware> middlewares,
    final List<BindingsInterface> bindings,
    final List<Bind> binds,
  ) {
    return origin.copyWith(
      middlewares: middlewares,
      name: origin.inheritParentPath
          ? (parentPath + origin.name).replaceAll(r'//', '/')
          : origin.name,
      bindings: bindings,
      binds: binds,
      // key:
    );
  }

  GetPage? _findRoute(final String name) {
    final value = routes.firstWhereOrNull(
      (final route) => route.path.regex.hasMatch(name),
    );

    return value;
  }

  Map<String, String> _parseParams(String path, final PathDecoded routePath) {
    final params = <String, String>{};
    final idx = path.indexOf('?');
    if (idx > -1) {
      path = path.substring(0, idx);
      final uri = Uri.tryParse(path);
      if (uri != null) {
        params.addAll(uri.queryParameters);
      }
    }
    final paramsMatch = routePath.regex.firstMatch(path);

    for (var i = 0; i < routePath.keys.length; i++) {
      final param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
  }
}

extension FirstWhereOrNullExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(final bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

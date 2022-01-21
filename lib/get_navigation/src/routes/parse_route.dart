import '../../../route_manager.dart';

class RouteDecoder {
  const RouteDecoder(
    this.currentTreeBranch,
    this.pageSettings,
  );
  final List<GetPage> currentTreeBranch;
  final PageSettings? pageSettings;

  factory RouteDecoder.fromRoute(String location) {
    var uri = Uri.parse(location);
    final args = PageSettings(uri);
    final decoder = Get.routeTree.matchRoute(location, arguments: args);
    decoder.route = decoder.route?.copy(
      completer: null,
      arguments: args,
      parameters: args.params,
    );
    return decoder;
  }

  GetPage? get route =>
      currentTreeBranch.isEmpty ? null : currentTreeBranch.last;

  GetPage routeOrUnknown(GetPage onUnknow) =>
      currentTreeBranch.isEmpty ? onUnknow : currentTreeBranch.last;

  set route(GetPage? getPage) {
    if (getPage == null) return;
    if (currentTreeBranch.isEmpty) {
      currentTreeBranch.add(getPage);
    } else {
      currentTreeBranch[currentTreeBranch.length - 1] = getPage;
    }
  }

  List<GetPage>? get currentChildrens => route?.children;

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

  void replaceArguments(Object? arguments) {
    final _route = route;
    if (_route != null) {
      final index = currentTreeBranch.indexOf(_route);
      currentTreeBranch[index] = _route.copy(arguments: arguments);
    }
  }
}

class ParseRouteTree {
  ParseRouteTree({
    required this.routes,
  });

  final List<GetPage> routes;

  RouteDecoder matchRoute(String name, {PageSettings? arguments}) {
    final uri = Uri.parse(name);
    // /home/profile/123 => home,profile,123 => /,/home,/home/profile,/home/profile/123
    final split = uri.path.split('/').where((element) => element.isNotEmpty);
    var curPath = '/';
    final cumulativePaths = <String>[
      '/',
    ];
    for (var item in split) {
      if (curPath.endsWith('/')) {
        curPath += '$item';
      } else {
        curPath += '/$item';
      }
      cumulativePaths.add(curPath);
    }

    final treeBranch = cumulativePaths
        .map((e) => MapEntry(e, _findRoute(e)))
        .where((element) => element.value != null)
        .map((e) => MapEntry(e.key, e.value!))
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
            (e) => e.value.copy(
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
      treeBranch.map((e) => e.value).toList(),
      arguments,
    );
  }

  void addRoutes<T>(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void removeRoutes<T>(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      removeRoute(route);
    }
  }

  void removeRoute<T>(GetPage<T> route) {
    routes.remove(route);
    for (var page in _flattenPage(route)) {
      removeRoute(page);
    }
  }

  void addRoute<T>(GetPage<T> route) {
    routes.add(route);

    // Add Page children.
    for (var page in _flattenPage(route)) {
      addRoute(page);
    }
  }

  List<GetPage> _flattenPage(GetPage route) {
    final result = <GetPage>[];
    if (route.children.isEmpty) {
      return result;
    }

    final parentPath = route.name;
    for (var page in route.children) {
      // Add Parent middlewares to children
      final parentMiddlewares = [
        if (page.middlewares != null) ...page.middlewares!,
        if (route.middlewares != null) ...route.middlewares!
      ];
      result.add(
        _addChild(
          page,
          parentPath,
          parentMiddlewares,
        ),
      );

      final children = _flattenPage(page);
      for (var child in children) {
        result.add(_addChild(
          child,
          parentPath,
          [
            ...parentMiddlewares,
            if (child.middlewares != null) ...child.middlewares!,
          ],
        ));
      }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  GetPage _addChild(
          GetPage origin, String parentPath, List<GetMiddleware> middlewares) =>
      origin.copy(
        middlewares: middlewares,
        name: (parentPath + origin.name).replaceAll(r'//', '/'),
      );

  GetPage? _findRoute(String name) {
    final value = routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );

    return value;
  }

  Map<String, String> _parseParams(String path, PathDecoded routePath) {
    final params = <String, String>{};
    var idx = path.indexOf('?');
    if (idx > -1) {
      path = path.substring(0, idx);
      final uri = Uri.tryParse(path);
      if (uri != null) {
        params.addAll(uri.queryParameters);
      }
    }
    var paramsMatch = routePath.regex.firstMatch(path);

    for (var i = 0; i < routePath.keys.length; i++) {
      var param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
  }
}

extension FirstWhereOrNullExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

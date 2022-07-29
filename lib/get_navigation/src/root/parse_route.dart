import '../../get_navigation.dart';

class RouteDecoder {
  final List<GetPage> treeBranch;
  GetPage? get route => treeBranch.isEmpty ? null : treeBranch.last;
  final Map<String, String> parameters;
  final Object? arguments;
  const RouteDecoder(
    this.treeBranch,
    this.parameters,
    this.arguments,
  );
  void replaceArguments(Object? arguments) {
    final _route = route;
    if (_route != null) {
      final index = treeBranch.indexOf(_route);
      treeBranch[index] = _route.copy(arguments: arguments);
    }
  }

  void replaceParameters(Object? arguments) {
    final _route = route;
    if (_route != null) {
      final index = treeBranch.indexOf(_route);
      treeBranch[index] = _route.copy(parameters: parameters);
    }
  }
}

class ParseRouteTree {
  ParseRouteTree({
    required this.routes,
  });

  final List<GetPage> routes;

  RouteDecoder matchRoute(String name, {Object? arguments}) {
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
      return RouteDecoder(
        mappedTreeBranch,
        params,
        arguments,
      );
    }

    //route not found
    return RouteDecoder(
      treeBranch.map((e) => e.value).toList(),
      params,
      arguments,
    );
  }

  void addRoutes(List<GetPage> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void addRoute(GetPage route) {
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
    return routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );
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

extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

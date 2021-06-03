import '../../get_navigation.dart';
import '../routes/get_route.dart';

class RouteDecoder {
  final List<GetPage> treeBranch;
  GetPage? get route => treeBranch.isEmpty ? null : treeBranch.last;
  final Map<String, String> parameters;
  const RouteDecoder(
    this.treeBranch,
    this.parameters,
  );
}

class ParseRouteTree {
  ParseRouteTree({
    required this.routes,
  });

  final List<GetPage> routes;

  RouteDecoder matchRoute(String name) {
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
        .map(
          (p) {
            final res = _findRoute(p);
            //change GetPage name from the regex to the actual name
            return res?.copy(
              name: p,
            );
          },
        )
        .where((element) => element != null)
        .cast<GetPage>()
        .toList();
    final params = Map<String, String>.from(uri.queryParameters);
    if (treeBranch.isNotEmpty) {
      //route is found, do further parsing to get nested query params
      final lastRoute = treeBranch.last;
      final parsedParams = _parseParams(name, lastRoute.path);
      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }
      //copy parameters to all pages.
      final mappedTreeBranch = treeBranch
          .map(
            (e) => e.copy(
              parameter: params,
            ),
          )
          .toList();
      return RouteDecoder(
        mappedTreeBranch,
        params,
      );
    }

    //route not found
    return RouteDecoder(
      treeBranch,
      params,
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
    if (route.children == null || route.children!.isEmpty) {
      return result;
    }

    final parentPath = route.name;
    for (var page in route.children!) {
      // Add Parent middlewares to children
      final pageMiddlewares = page.middlewares ?? <GetMiddleware>[];
      pageMiddlewares.addAll(route.middlewares ?? <GetMiddleware>[]);
      result.add(_addChild(page, parentPath, pageMiddlewares));

      final children = _flattenPage(page);
      for (var child in children) {
        pageMiddlewares.addAll(child.middlewares ?? <GetMiddleware>[]);
        result.add(_addChild(child, parentPath, pageMiddlewares));
      }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  GetPage _addChild(
          GetPage origin, String parentPath, List<GetMiddleware> middlewares) =>
      GetPage(
        name: parentPath + origin.name,
        page: origin.page,
        title: origin.title,
        alignment: origin.alignment,
        transition: origin.transition,
        binding: origin.binding,
        bindings: origin.bindings,
        curve: origin.curve,
        customTransition: origin.customTransition,
        fullscreenDialog: origin.fullscreenDialog,
        maintainState: origin.maintainState,
        opaque: origin.opaque,
        parameter: origin.parameter,
        popGesture: origin.popGesture,
        //  settings: origin.settings,
        transitionDuration: origin.transitionDuration,
        middlewares: middlewares,
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

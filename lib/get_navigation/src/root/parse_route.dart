import 'package:collection/collection.dart' show IterableExtension;

import '../../../get_core/src/get_main.dart';
import '../../get_navigation.dart';
import '../routes/get_route.dart';

class RouteDecoder {
  final GetPage? route;
  final Map<String, String?> parameters;
  const RouteDecoder(this.route, this.parameters);
}

class ParseRouteTree {
  final _routes = <GetPage>[];

  RouteDecoder matchRoute(String name) {
    final uri = Uri.parse(name);
    final route = _findRoute(uri.path);
    final params = Map<String, String?>.from(uri.queryParameters);
    if (route != null) {
      final parsedParams = _parseParams(name, route.path);
      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }
    } else {
      Get.log('Route "${uri.path}" not found');
    }

    return RouteDecoder(route, params);
  }

  void addRoutes(List<GetPage> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void addRoute(GetPage route) {
    _routes.add(route);

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
        settings: origin.settings,
        transitionDuration: origin.transitionDuration,
        middlewares: middlewares,
      );

  GetPage? _findRoute(String name) {
    return _routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );
  }

  Map<String, String?> _parseParams(String path, PathDecoded routePath) {
    final params = <String, String?>{};
    Match? paramsMatch = routePath.regex.firstMatch(path);

    for (var i = 0; i < routePath.keys.length; i++) {
      var param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
  }
}

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../route_manager.dart';

@immutable
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
    final decoder = (Get.rootController.routerDelegate as GetDelegate)
        .matchRoute(location, arguments: args);

    decoder!.route = decoder.route?.copy(
      completer: null,
      arguments: args,
      parameters: decoder.parameters,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteDecoder &&
        listEquals(other.currentTreeBranch, currentTreeBranch) &&
        other.pageSettings == pageSettings;
  }

  @override
  int get hashCode => currentTreeBranch.hashCode ^ pageSettings.hashCode;
}

class ParseRouteTree {
  RouteDecoder matchRoute(List<GetPage> routes, String name,
      {PageSettings? arguments}) {
    final args = arguments ?? PageSettings(Uri.parse(name));
    final treeBranch = routes
        .where((e) => RouteParser.hasMatch(
            pushedRoute: name, routeName: e.name, withChildren: true))
        .map((e) {
      final parameters =
          RouteParser.parse(pushedRoute: name, routeName: e.name).parameters;
      final routeParams = e.parameters;
      if (routeParams != null) {
        parameters.addAll(routeParams);
      }
      if (args.params.isNotEmpty) {
        parameters.addAll(args.params);
      }

      args.params.clear();
      args.params.addAll(parameters);

      return e.copy(
        settings: args,
        parameters: parameters,
      );
    }).toList();

    //route not found
    return RouteDecoder(
      treeBranch,
      arguments,
    );
  }
}

extension FirstWhereOrNullExt<T> on List<GetPage<T>> {
  void addRoutes(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void removeRoutes(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      removeRoute(route);
    }
  }

  void removeRoute(GetPage<T> route) {
    remove(route);
    for (var page in _flattenPage(route)) {
      removeRoute(page);
    }
  }

  void addRoute(GetPage<T> route) {
    add(route);

    // Add Page children.
    for (var page in _flattenPage(route)) {
      addRoute(page);
    }
  }

  List<GetPage<T>> _flattenPage(GetPage<T> route) {
    final result = <GetPage<T>>[];
    if (route.children.isEmpty) {
      return result;
    }

    var parentPathOld = route.name;
    for (var page in route.children) {
      final parentPath2 = (parentPathOld + page.name).replaceAll(r'//', '/');
      // Add Parent middlewares to children
      final parentMiddlewares = [
        if (page.middlewares != null) ...page.middlewares!,
        if (route.middlewares != null) ...route.middlewares!
      ];
      result.add(
        _addChild(
          page as GetPage<T>,
          parentPath2,
          parentMiddlewares,
        ),
      );

      final children = _flattenPage(page);
      // for (var child in children) {
      //   final parentPath = (parentPath2 + page.name).replaceAll(r'//', '/');
      //   result.add(_addChild(
      //     child,
      //     parentPath,
      //     [
      //       ...parentMiddlewares,
      //       if (child.middlewares != null) ...child.middlewares!,
      //     ],
      //   ));
      // }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  GetPage<T> _addChild(
      GetPage<T> origin, String parentPath, List<GetMiddleware> middlewares) {
    return origin.copy(
      middlewares: middlewares,
      name: parentPath,
      key: ValueKey(parentPath),
    );
  }

  // GetPage<T>? _findRoute(String name) {
  //   final value = firstWhereOrNull(
  //     (route) => route.path.regex.hasMatch(name),
  //   );

  //   return value;
  // }
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

class RouteParser {
  static RouteParser parse({required String pushedRoute, required routeName}) {
    final data = RouteParser(pushedRoute: pushedRoute, routeName: routeName);

    final minLength =
        min(data.originalPathSegments.length, data.newPathSegments.length);

    for (var i = 0; i < minLength; i++) {
      final originalPathSegment = data.originalPathSegments[i];
      final newPathSegment = Uri.parse(data.newPathSegments[i]);

      if (originalPathSegment.startsWith(':')) {
        final key = originalPathSegment.replaceFirst(':', '');
        data.parameters[key] = newPathSegment.toString();
        data.matchingSegments.add(newPathSegment);
        continue;
      }

      if (newPathSegment.path == originalPathSegment) {
        data.matchingSegments.add(newPathSegment);
        data.parameters.addAll(data.newRouteUri.queryParameters);

        continue;
      } else {
        break;
      }
    }

    return data;
  }

  static bool hasMatch({
    required String pushedRoute,
    required routeName,
    bool withChildren = false,
  }) {
    final data = RouteParser(pushedRoute: pushedRoute, routeName: routeName);
    final matches = <bool>[];

    final minLength =
        min(data.originalPathSegments.length, data.newPathSegments.length);

    if ((!withChildren &&
            data.newPathSegments.length > data.originalPathSegments.length) ||
        data.newPathSegments.length < data.originalPathSegments.length) {
      matches.add(false);
    }

    for (var i = 0; i < minLength; i++) {
      final originalPathSegment = data.originalPathSegments[i];
      final newPathSegment = Uri.parse(data.newPathSegments[i]);

      if (originalPathSegment.startsWith(':')) {
        matches.add(true);
        continue;
      }

      if (newPathSegment.path == originalPathSegment) {
        matches.add(true);
        continue;
      } else {
        matches.add(false);
        break;
      }
    }

    return matches.every((element) => element);
  }

  RouteParser({required String routeName, required String pushedRoute})
      : _cleanRouteName = '/' +
            routeName
                .replaceAll(RegExp(r'^\s+|\s+$'), '')
                .replaceAll(RegExp(r'^\/+|\/+$'), ''),
        newRouteUri = Uri.parse(pushedRoute) {
    originalRouteUri = Uri(path: _cleanRouteName);
  }
  late final Uri originalRouteUri;

  final Uri newRouteUri;
  final Map<String, String> parameters = <String, String>{};
  final List<Uri> matchingSegments = <Uri>[];
  final String _cleanRouteName;

  List<String> get newPathSegments => newRouteUri.pathSegments;
  List<String> get originalPathSegments => originalRouteUri.pathSegments;
  String get matchingPath => '/' + matchingSegments.join('/');

  @override
  String toString() =>
      'RouteParser(originalRouteUri: $originalRouteUri, newRouteUri: $newRouteUri, _cleanRouteName: $_cleanRouteName)';
}

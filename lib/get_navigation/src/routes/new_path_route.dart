import 'dart:async';

import 'package:flutter/widgets.dart';

import 'get_route.dart';

class RouteMatcher {
  final RouteNode _root = RouteNode('/', '/');

  RouteNode addRoute(final String path) {
    final segments = _parsePath(path);
    var currentNode = _root;

    for (final segment in segments) {
      final existingChild = currentNode.findChild(segment);
      if (existingChild != null) {
        currentNode = existingChild;
      } else {
        final newChild = RouteNode(segment, path);
        currentNode.addChild(newChild);
        currentNode = newChild;
      }
    }
    return currentNode;
  }

  void removeRoute(final String path) {
    final segments = _parsePath(path);
    var currentNode = _root;
    RouteNode? nodeToDelete;

    // Traverse the tree to find the node to delete
    for (final segment in segments) {
      final child = currentNode.findChild(segment);
      if (child == null) {
        return; // Node not found, nothing to delete
      }
      if (child.nodeSegments.length == segments.length) {
        nodeToDelete = child;
        break;
      }
      currentNode = child;
    }

    if (nodeToDelete == null) {
      return; // Node not found, nothing to delete
    }

    final parent = nodeToDelete.parent!;
    parent.nodeSegments.remove(nodeToDelete);
  }

  RouteNode? _findChild(final RouteNode currentNode, final String segment) {
    return currentNode.nodeSegments
        .firstWhereOrNull((final node) => node.matches(segment));
  }

  MatchResult? matchRoute(final String path) {
    final uri = Uri.parse(path);
    final segments = _parsePath(uri.path);
    var currentNode = _root;
    final parameters = <String, String>{};
    final urlParameters = uri.queryParameters;

    for (final segment in segments) {
      if (segment.isEmpty) continue;
      final child = _findChild(currentNode, segment);
      if (child == null) {
        return null;
      } else {
        if (child.path.startsWith(':')) {
          parameters[child.path.substring(1)] = segment;
        }

        if (child.nodeSegments.length == segments.length) {
          return null;
        }

        currentNode = child;
      }
    }

    return MatchResult(
      currentNode,
      parameters,
      path,
      urlParameters: urlParameters,
    );
  }

  List<String> _parsePath(final String path) {
    return path.split('/').where((final segment) => segment.isNotEmpty).toList();
  }
}

class RouteTreeResult {

  RouteTreeResult({
    required this.route,
    required this.matchResult,
  });
  final GetPage? route;
  final MatchResult matchResult;

  @override
  String toString() {
    return 'RouteTreeResult(route: $route, matchResult: $matchResult)';
  }

  RouteTreeResult configure(final String page, final Object? arguments) {
    return copyWith(
        route: route?.copyWith(
      key: ValueKey(page),
      settings: RouteSettings(name: page, arguments: arguments),
      completer: Completer(),
      arguments: arguments,
    ));
  }

  RouteTreeResult copyWith({
    final GetPage? route,
    final MatchResult? matchResult,
  }) {
    return RouteTreeResult(
      route: route ?? this.route,
      matchResult: matchResult ?? this.matchResult,
    );
  }
}

class RouteTree {
  static final instance = RouteTree();
  final Map<String, GetPage> tree = {};
  final RouteMatcher matcher = RouteMatcher();

  void addRoute(final GetPage route) {
    matcher.addRoute(route.name);
    tree[route.name] = route;
    handleChild(route);
  }

  void addRoutes(final List<GetPage> routes) {
    for (final route in routes) {
      addRoute(route);
    }
  }

  void handleChild(final GetPage route) {
    final children = route.children;
    for (var child in children) {
      final middlewares = List.of(route.middlewares);
      final bindings = List.of(route.bindings);
      middlewares.addAll(child.middlewares);
      bindings.addAll(child.bindings);
      child = child.copyWith(middlewares: middlewares, bindings: bindings);
      if (child.inheritParentPath) {
        child = child.copyWith(
            name: '${route.path}/${child.path}'.replaceAll(r'//', '/'));
      }
      addRoute(child);
    }
  }

  void removeRoute(final GetPage route) {
    matcher.removeRoute(route.name);
    tree.remove(route.path);
  }

  void removeRoutes(final List<GetPage> routes) {
    for (final route in routes) {
      removeRoute(route);
    }
  }

  RouteTreeResult? matchRoute(final String path) {
    final matchResult = matcher.matchRoute(path);
    if (matchResult != null) {
      final route = tree[matchResult.node.originalPath];
      return RouteTreeResult(
        route: route,
        matchResult: matchResult,
      );
    }
    return null;
  }
}

/// A class representing the result of a route matching operation.
class MatchResult {

  MatchResult(this.node, this.parameters, this.currentPath,
      {this.urlParameters = const {}});
  /// The route found that matches the result
  final RouteNode node;

  /// The current path of match, eg: adding 'user/:id' the match result for 'user/123' will be: 'user/123'
  final String currentPath;

  /// Route parameters eg: adding 'user/:id' the match result for 'user/123' will be: {id: 123}
  final Map<String, String> parameters;

  /// Route url parameters eg: adding 'user' the match result for 'user?foo=bar' will be: {foo: bar}
  final Map<String, String> urlParameters;

  @override
  String toString() =>
      'MatchResult(node: $node, currentPath: $currentPath, parameters: $parameters, urlParameters: $urlParameters)';
}

// A class representing a node in a routing tree.
class RouteNode {

  RouteNode(this.path, this.originalPath, {this.parent});
  String path;
  String originalPath;
  RouteNode? parent;
  List<RouteNode> nodeSegments = [];

  bool get isRoot => parent == null;

  String get fullPath {
    if (isRoot) {
      return '/';
    } else {
      final parentPath = parent?.fullPath == '/' ? '' : parent?.fullPath;
      return '$parentPath/$path';
    }
  }

  bool get hasChildren => nodeSegments.isNotEmpty;

  void addChild(final RouteNode child) {
    nodeSegments.add(child);
    child.parent = this;
  }

  RouteNode? findChild(final String name) {
    return nodeSegments.firstWhereOrNull((final node) => node.path == name);
  }

  bool matches(final String name) {
    return name == path || path == '*' || path.startsWith(':');
  }

  @override
  String toString() =>
      'RouteNode(name: $path, nodeSegments: $nodeSegments, fullPath: $fullPath )';
}

extension Foo<T> on Iterable<T> {
  T? firstWhereOrNull(final bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

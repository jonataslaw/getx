import 'package:flutter/widgets.dart';

import '../routes/get_route.dart';

class ParseRouteTree {
  final List<_ParseRouteTreeNode> _nodes = <_ParseRouteTreeNode>[];

  // bool _hasDefaultRoute = false;

  void addRoute(GetPage route) {
    var path = route.name;

    if (path == Navigator.defaultRouteName) {
      // if (_hasDefaultRoute) {
      //   throw ("Default route was already defined");
      // }
      var node = _ParseRouteTreeNode(path, _ParseRouteTreeNodeType.component);
      node.routes = [route];
      _nodes.add(node);
      // _hasDefaultRoute = true;
      return;
    }
    if (path.startsWith("/")) {
      path = path.substring(1);
    }
    var pathComponents = path.split('/');
    _ParseRouteTreeNode parent;
    for (var i = 0; i < pathComponents.length; i++) {
      var component = pathComponents[i];
      var node = _nodeForComponent(component, parent);
      if (node == null) {
        var type = _typeForComponent(component);
        node = _ParseRouteTreeNode(component, type);
        node.parent = parent;
        if (parent == null) {
          _nodes.add(node);
        } else {
          parent.nodes.add(node);
        }
      }
      if (i == pathComponents.length - 1) {
        if (node.routes == null) {
          node.routes = [route];
        } else {
          node.routes.add(route);
        }
      }
      parent = node;
    }
  }

  _GetPageMatch matchRoute(String path) {
    var usePath = path;
    if (usePath.startsWith("/")) {
      usePath = path.substring(1);
    }

    // should take off url parameters first..
    final uri = Uri.tryParse(usePath);
//    List<String> components = usePath.split("/");
    var components = uri.pathSegments;
    if (path == Navigator.defaultRouteName) {
      components = ["/"];
    }
    var nodeMatches = <_ParseRouteTreeNode, _ParseRouteTreeNodeMatch>{};
    var nodesToCheck = _nodes;
    for (final checkComponent in components) {
      final currentMatches = <_ParseRouteTreeNode, _ParseRouteTreeNodeMatch>{};
      final nextNodes = <_ParseRouteTreeNode>[];
      for (final node in nodesToCheck) {
        var pathPart = checkComponent;
        var queryMap = <String, String>{};

        if (checkComponent.contains("?") && !checkComponent.contains("=")) {
          var splitParam = checkComponent.split("?");
          pathPart = splitParam[0];
          queryMap = {pathPart: splitParam[1]};
        } else if (checkComponent.contains("?")) {
          var splitParam = checkComponent.split("?");
          var splitParam2 = splitParam[1].split("=");
          if (!splitParam2[1].contains("&")) {
            pathPart = splitParam[0];
            queryMap = {splitParam2[0]: splitParam2[1]};
          } else {
            pathPart = splitParam[0];
            final second = splitParam[1];
            var other = second.split(RegExp(r"[&,=]"));
            for (var i = 0; i < (other.length - 1); i++) {
              var isOdd = (i % 2 == 0);
              if (isOdd) {
                queryMap.addAll({other[0 + i]: other[1 + i]});
              }
            }
          }
        }

        final isMatch = (node.part == pathPart || node.isParameter());
        if (isMatch) {
          final parentMatch = nodeMatches[node.parent];
          final match = _ParseRouteTreeNodeMatch.fromMatch(parentMatch, node);

          // TODO: find a way to clean this implementation.
          match.parameters.addAll(uri.queryParameters);

          if (node.isParameter()) {
            final paramKey = node.part.substring(1);
            match.parameters[paramKey] = pathPart;
          }
          if (queryMap != null) {
            match.parameters.addAll(queryMap);
          }

          currentMatches[node] = match;
          if (node.nodes != null) {
            nextNodes.addAll(node.nodes);
          }
        }
      }
      nodeMatches = currentMatches;
      nodesToCheck = nextNodes;
      if (currentMatches.values.length == 0) {
        return null;
      }
    }
    var matches = nodeMatches.values.toList();
    if (matches.length > 0) {
      var match = matches.first;
      var nodeToUse = match.node;

      if (nodeToUse != null &&
          nodeToUse.routes != null &&
          nodeToUse.routes.length > 0) {
        var routes = nodeToUse.routes;
        var routeMatch = _GetPageMatch(routes[0]);

        routeMatch.parameters = match.parameters;

        return routeMatch;
      }
    }
    return null;
  }

  _ParseRouteTreeNode _nodeForComponent(
    String component,
    _ParseRouteTreeNode parent,
  ) {
    var nodes = _nodes;
    if (parent != null) {
      nodes = parent.nodes;
    }
    for (var node in nodes) {
      if (node.part == component) {
        return node;
      }
    }
    return null;
  }

  _ParseRouteTreeNodeType _typeForComponent(String component) {
    var type = _ParseRouteTreeNodeType.component;
    if (_isParameterComponent(component)) {
      type = _ParseRouteTreeNodeType.parameter;
    }
    return type;
  }

  bool _isParameterComponent(String component) {
    return component.startsWith(":");
  }

  Map<String, String> parseQueryString(String query) {
    var search = RegExp('([^&=]+)=?([^&]*)');
    var params = <String, String>{};
    if (query.startsWith('?')) query = query.substring(1);
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    for (Match match in search.allMatches(query)) {
      var key = decode(match.group(1));
      final value = decode(match.group(2));
      params[key] = value;
    }
    return params;
  }
}

class _ParseRouteTreeNodeMatch {
  _ParseRouteTreeNodeMatch(this.node);

  _ParseRouteTreeNodeMatch.fromMatch(
      _ParseRouteTreeNodeMatch match, this.node) {
    parameters = <String, String>{};
    if (match != null) {
      parameters.addAll(match.parameters);
    }
  }

  _ParseRouteTreeNode node;
  Map<String, String> parameters = <String, String>{};
}

class _ParseRouteTreeNode {
  _ParseRouteTreeNode(this.part, this.type);

  String part;
  _ParseRouteTreeNodeType type;
  List<GetPage> routes = <GetPage>[];
  List<_ParseRouteTreeNode> nodes = <_ParseRouteTreeNode>[];
  _ParseRouteTreeNode parent;

  bool isParameter() {
    return type == _ParseRouteTreeNodeType.parameter;
  }
}

class _GetPageMatch {
  _GetPageMatch(this.route);

  GetPage route;
  Map<String, String> parameters = <String, String>{};
}

enum _ParseRouteTreeNodeType {
  component,
  parameter,
}

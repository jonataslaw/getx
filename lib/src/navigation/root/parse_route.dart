import 'package:flutter/widgets.dart';
import 'package:get/src/navigation/routes/get_route.dart';

class GetPageMatch {
  GetPageMatch(this.route);

  GetPage route;
  Map<String, String> parameters = <String, String>{};
}

class ParseRouteTree {
  final List<ParseRouteTreeNode> _nodes = <ParseRouteTreeNode>[];
  // bool _hasDefaultRoute = false;

  void addRoute(GetPage route) {
    String path = route.name;

    if (path == Navigator.defaultRouteName) {
      // if (_hasDefaultRoute) {
      //   throw ("Default route was already defined");
      // }
      var node = ParseRouteTreeNode(path, ParseRouteTreeNodeType.component);
      node.routes = [route];
      _nodes.add(node);
      // _hasDefaultRoute = true;
      return;
    }
    if (path.startsWith("/")) {
      path = path.substring(1);
    }
    List<String> pathComponents = path.split('/');
    ParseRouteTreeNode parent;
    for (int i = 0; i < pathComponents.length; i++) {
      String component = pathComponents[i];
      ParseRouteTreeNode node = _nodeForComponent(component, parent);
      if (node == null) {
        ParseRouteTreeNodeType type = _typeForComponent(component);
        node = ParseRouteTreeNode(component, type);
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

  GetPageMatch matchRoute(String path) {
    String usePath = path;
    if (usePath.startsWith("/")) {
      usePath = path.substring(1);
    }
    List<String> components = usePath.split("/");
    if (path == Navigator.defaultRouteName) {
      components = ["/"];
    }

    Map<ParseRouteTreeNode, ParseRouteTreeNodeMatch> nodeMatches =
        <ParseRouteTreeNode, ParseRouteTreeNodeMatch>{};
    List<ParseRouteTreeNode> nodesToCheck = _nodes;
    for (String checkComponent in components) {
      Map<ParseRouteTreeNode, ParseRouteTreeNodeMatch> currentMatches =
          <ParseRouteTreeNode, ParseRouteTreeNodeMatch>{};
      List<ParseRouteTreeNode> nextNodes = <ParseRouteTreeNode>[];
      for (ParseRouteTreeNode node in nodesToCheck) {
        String pathPart = checkComponent;
        Map<String, String> queryMap = {};

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
            final segunda = splitParam[1];
            var other = segunda.split(RegExp(r"[&,=]"));
            for (var i = 0; i < (other.length - 1); i++) {
              bool impar = (i % 2 == 0);
              if (impar) {
                queryMap.addAll({other[0 + i]: other[1 + i]});
              }
            }
          }
        }

        bool isMatch = (node.part == pathPart || node.isParameter());
        if (isMatch) {
          ParseRouteTreeNodeMatch parentMatch = nodeMatches[node.parent];
          ParseRouteTreeNodeMatch match =
              ParseRouteTreeNodeMatch.fromMatch(parentMatch, node);
          if (node.isParameter()) {
            String paramKey = node.part.substring(1);
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
    List<ParseRouteTreeNodeMatch> matches = nodeMatches.values.toList();
    if (matches.length > 0) {
      ParseRouteTreeNodeMatch match = matches.first;
      ParseRouteTreeNode nodeToUse = match.node;

      if (nodeToUse != null &&
          nodeToUse.routes != null &&
          nodeToUse.routes.length > 0) {
        List<GetPage> routes = nodeToUse.routes;
        GetPageMatch routeMatch = GetPageMatch(routes[0]);

        routeMatch.parameters = match.parameters;

        return routeMatch;
      }
    }
    return null;
  }

  ParseRouteTreeNode _nodeForComponent(
      String component, ParseRouteTreeNode parent) {
    List<ParseRouteTreeNode> nodes = _nodes;
    if (parent != null) {
      nodes = parent.nodes;
    }
    for (ParseRouteTreeNode node in nodes) {
      if (node.part == component) {
        return node;
      }
    }
    return null;
  }

  ParseRouteTreeNodeType _typeForComponent(String component) {
    ParseRouteTreeNodeType type = ParseRouteTreeNodeType.component;
    if (_isParameterComponent(component)) {
      type = ParseRouteTreeNodeType.parameter;
    }
    return type;
  }

  bool _isParameterComponent(String component) {
    return component.startsWith(":");
  }

  Map<String, String> parseQueryString(String query) {
    var search = RegExp('([^&=]+)=?([^&]*)');
    var params = Map<String, String>();
    if (query.startsWith('?')) query = query.substring(1);
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));
    for (Match match in search.allMatches(query)) {
      String key = decode(match.group(1));
      String value = decode(match.group(2));
      params[key] = value;
    }
    return params;
  }
}

class ParseRouteTreeNodeMatch {
  ParseRouteTreeNodeMatch(this.node);

  ParseRouteTreeNodeMatch.fromMatch(ParseRouteTreeNodeMatch match, this.node) {
    parameters = <String, String>{};
    if (match != null) {
      parameters.addAll(match.parameters);
    }
  }

  ParseRouteTreeNode node;
  Map<String, String> parameters = <String, String>{};
}

class ParseRouteTreeNode {
  ParseRouteTreeNode(this.part, this.type);

  String part;
  ParseRouteTreeNodeType type;
  List<GetPage> routes = <GetPage>[];
  List<ParseRouteTreeNode> nodes = <ParseRouteTreeNode>[];
  ParseRouteTreeNode parent;

  bool isParameter() {
    return type == ParseRouteTreeNodeType.parameter;
  }
}

enum ParseRouteTreeNodeType {
  component,
  parameter,
}

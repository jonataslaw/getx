import 'package:flutter/material.dart';

class ParseRoute {
  final List<ParseRouteSplit> _routeSplits = <ParseRouteSplit>[];

  void addRoute(String routePath) {
    String path = routePath;

    if (path == Navigator.defaultRouteName) {
      var routeSplit = ParseRouteSplit(path, ParseRouteSplitType.component);
      routeSplit.routes = [routePath];
      _routeSplits.add(routeSplit);
      return;
    }
    if (path.startsWith("/")) {
      path = path.substring(1);
    }
    List<String> pathComponents = path.split('/');
    ParseRouteSplit parent;
    for (int i = 0; i < pathComponents.length; i++) {
      String component = pathComponents[i];
      ParseRouteSplit routeSplit = _routeSplitForComponent(component, parent);
      if (routeSplit == null) {
        ParseRouteSplitType type = _typeForComponent(component);
        routeSplit = ParseRouteSplit(component, type);
        routeSplit.parent = parent;
        if (parent == null) {
          _routeSplits.add(routeSplit);
        } else {
          parent.routeSplits.add(routeSplit);
        }
      }
      if (i == pathComponents.length - 1) {
        if (routeSplit.routes == null) {
          routeSplit.routes = [routePath];
        } else {
          routeSplit.routes.add(routePath);
        }
      }
      parent = routeSplit;
    }
  }

  AppRouteMatch split(String path) {
    String usePath = path;
    if (usePath.startsWith("/")) {
      usePath = path.substring(1);
    }
    List<String> components = usePath.split("/");
    if (path == Navigator.defaultRouteName) {
      components = ["/"];
    }

    Map<ParseRouteSplit, ParseRouteSplitMatch> routeSplitMatches =
        <ParseRouteSplit, ParseRouteSplitMatch>{};
    List<ParseRouteSplit> routeSplitsToCheck = _routeSplits;
    for (String checkComponent in components) {
      Map<ParseRouteSplit, ParseRouteSplitMatch> currentMatches =
          <ParseRouteSplit, ParseRouteSplitMatch>{};
      List<ParseRouteSplit> nextrouteSplits = <ParseRouteSplit>[];
      for (ParseRouteSplit routeSplit in routeSplitsToCheck) {
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
        bool isMatch =
            (routeSplit.part == pathPart || routeSplit.isParameter());
        if (isMatch) {
          ParseRouteSplitMatch parentMatch =
              routeSplitMatches[routeSplit.parent];
          ParseRouteSplitMatch match =
              ParseRouteSplitMatch.fromMatch(parentMatch, routeSplit);
          if (routeSplit.isParameter()) {
            String paramKey = routeSplit.part.substring(1);
            match.parameters[paramKey] = pathPart;
          }
          if (queryMap != null) {
            match.parameters.addAll(queryMap);
          }

          currentMatches[routeSplit] = match;
          if (routeSplit.routeSplits != null) {
            nextrouteSplits.addAll(routeSplit.routeSplits);
          }
        }
      }
      routeSplitMatches = currentMatches;
      routeSplitsToCheck = nextrouteSplits;
      if (currentMatches.values.length == 0) {
        return null;
      }
    }
    List<ParseRouteSplitMatch> matches = routeSplitMatches.values.toList();
    if (matches.length > 0) {
      ParseRouteSplitMatch match = matches.first;
      ParseRouteSplit routeSplitToUse = match.routeSplit;

      if (routeSplitToUse != null &&
          routeSplitToUse.routes != null &&
          routeSplitToUse.routes.length > 0) {
        AppRouteMatch routeMatch = AppRouteMatch();
        routeMatch.parameters = match.parameters;
        if (routeSplitToUse.isParameter()) {
          routeMatch.route = match.routeSplit.parent.part;
        } else {
          routeMatch.route = match.routeSplit.part;
        }
        return routeMatch;
      }
    }
    return null;
  }

  ParseRouteSplit _routeSplitForComponent(
      String component, ParseRouteSplit parent) {
    List<ParseRouteSplit> routeSplits = _routeSplits;
    if (parent != null) {
      routeSplits = parent.routeSplits;
    }
    for (ParseRouteSplit routeSplit in routeSplits) {
      if (routeSplit.part == component) {
        return routeSplit;
      }
    }
    return null;
  }

  ParseRouteSplitType _typeForComponent(String component) {
    ParseRouteSplitType type = ParseRouteSplitType.component;
    if (_isParameterComponent(component)) {
      type = ParseRouteSplitType.parameter;
    }
    return type;
  }

  bool _isParameterComponent(String component) {
    return component.startsWith(":");
  }
}

enum ParseRouteSplitType {
  component,
  parameter,
}

class AppRouteMatch {
  Map<String, String> parameters = <String, String>{};
  String route = '/';
}

class ParseRouteSplitMatch {
  ParseRouteSplitMatch(this.routeSplit);

  ParseRouteSplitMatch.fromMatch(ParseRouteSplitMatch match, this.routeSplit) {
    parameters = <String, String>{};
    if (match != null) {
      parameters.addAll(match.parameters);
    }
  }

  ParseRouteSplit routeSplit;
  Map<String, String> parameters = <String, String>{};
}

class ParseRouteSplit {
  ParseRouteSplit(this.part, this.type);

  String part;
  ParseRouteSplitType type;
  List<String> routes = [];
  List<ParseRouteSplit> routeSplits = <ParseRouteSplit>[];
  ParseRouteSplit parent;

  bool isParameter() {
    return type == ParseRouteSplitType.parameter;
  }
}

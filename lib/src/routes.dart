import 'package:flutter/widgets.dart';
import 'getroute.dart';

class Get {
  static Get _get;
  static GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

  factory Get() {
    if (_get == null) _get = Get._();
    return _get;
  }

  Get._();

  static to(Widget page, {bool rebuildRoutes = false}) {
    return key.currentState
        .push(GetRoute(opaque: rebuildRoutes, builder: (_) => page));
  }

  static toNamed(String page, {arguments}) {
    return key.currentState.pushNamed(page, arguments: arguments);
  }

  static offNamed(String page, {arguments}) {
    return key.currentState
        .pushReplacementNamed(page, arguments: arguments);
  }

  static offAllNamed(
      String newRouteName,
      RoutePredicate predicate, {
        Object arguments,
      }) {
    return key.currentState
        .pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }

  static back() {
    return key.currentState.pop();
  }

  static off(Widget page, {bool rebuildRoutes = false}) {
    return key.currentState
        .pushReplacement(GetRoute(opaque: rebuildRoutes, builder: (_) => page));
  }

  static offAll(Widget page, RoutePredicate predicate,
      {bool rebuildRoutes = false}) {
    return key.currentState.pushAndRemoveUntil(
        GetRoute(opaque: rebuildRoutes, builder: (_) => page), predicate);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dialog.dart';
import 'getroute.dart';

class Get {
  static Get _get;
  static GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

  ///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
  ///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
  ///To return to the previous screen, use Get.back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.
  factory Get() {
    if (_get == null) _get = Get._();
    return _get;
  }

  ///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
  ///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
  ///To return to the previous screen, use Get.back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.
  Get._();

  /// It replaces Navigator.push, but needs no context, and it doesn't have the Navigator.push
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use rebuildRoutes = true as the parameter.
  static to(Widget page, {bool rebuildRoutes = false}) {
    return key.currentState
        .push(GetRoute(opaque: rebuildRoutes, builder: (_) => page));
  }

  /// It replaces Navigator.pushNamed, but needs no context, and it doesn't have the Navigator.pushNamed
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use rebuildRoutes = true as the parameter.
  static toNamed(String page, {arguments}) {
    return key.currentState.pushNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.pushReplacementNamed, but needs no context.
  static offNamed(String page, {arguments}) {
    return key.currentState.pushReplacementNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.popUntil, but needs no context.
  static until(String page, predicate) {
    return key.currentState.popUntil(predicate);
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context.
  static offUntil(page, predicate) {
    return key.currentState.pushAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static offNamedUntil(page, predicate) {
    return key.currentState.pushNamedAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.removeRoute, but needs no context.
  static removeRoute(route) {
    return key.currentState.removeRoute(route);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static offAllNamed(
    String newRouteName,
    RoutePredicate predicate, {
    arguments,
  }) {
    return key.currentState
        .pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }

  /// It replaces Navigator.pop, but needs no context.
  static back({result}) {
    return key.currentState.pop(result);
  }

  /// It replaces Navigator.pushReplacement, but needs no context, and it doesn't have the Navigator.pushReplacement
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use rebuildRoutes = true as the parameter.
  static off(Widget page, {bool rebuildRoutes = false}) {
    return key.currentState
        .pushReplacement(GetRoute(opaque: rebuildRoutes, builder: (_) => page));
  }

  /// Show a dialog. You can choose color and opacity of background
  static dialog(Widget page, {Color color, double opacity = 0.5}) {
    Get.to(DialogGet(child: page, color: color, opacity: opacity));
  }

  static defaultDialog(
      {Color color,
      double opacity = 0.5,
      String title = "Alert dialog",
      Widget content,
      Widget cancel,
      Widget confirm}) {
    Get.to(DefaultDialogGet(
      color: color,
      opacity: opacity,
      title: title,
      content: content,
      cancel: cancel,
      confirm: confirm,
    ));
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  static offAll(Widget page, RoutePredicate predicate,
      {bool rebuildRoutes = false}) {
    return key.currentState.pushAndRemoveUntil(
        GetRoute(opaque: rebuildRoutes, builder: (_) => page), predicate);
  }
}

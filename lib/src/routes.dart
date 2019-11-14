import 'package:flutter/widgets.dart';
import 'material.dart';

class Get {
  static to(BuildContext context, Widget page, {bool rebuildRoutes = false}) {
    return Navigator.push(
        context,
        GetRoute(
            opaque: rebuildRoutes, builder: (BuildContext context) => page));
  }

  static back(BuildContext context) {
    return Navigator.pop(context);
  }

  static off(BuildContext context, Widget page, {bool rebuildRoutes = false}) {
    return Navigator.pushReplacement(
        context,
        GetRoute(
            opaque: rebuildRoutes, builder: (BuildContext context) => page));
  }

  static offAll(BuildContext context, Widget page, RoutePredicate predicate,
      {bool rebuildRoutes = false}) {
    return Navigator.pushAndRemoveUntil(
        context,
        GetRoute(
            opaque: rebuildRoutes, builder: (BuildContext context) => page),
        predicate);
  }
}

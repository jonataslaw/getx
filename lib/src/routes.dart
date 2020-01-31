import 'package:flutter/material.dart';
import 'bottomsheet.dart';
import 'dialog.dart';
import 'snack.dart';
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
  static to(Widget page,
      {bool rebuildRoutes = false, Transition transition = Transition.fade}) {
    return key.currentState.push(
        GetRoute(opaque: rebuildRoutes, child: page, transition: transition));
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
  static off(Widget page,
      {bool rebuildRoutes = false,
      Transition transition = Transition.rightToLeft}) {
    return key.currentState.pushReplacement(
        GetRoute(opaque: rebuildRoutes, child: page, transition: transition));
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  static offAll(Widget page, RoutePredicate predicate,
      {bool rebuildRoutes = false,
      Transition transition = Transition.rightToLeft}) {
    return key.currentState.pushAndRemoveUntil(
        GetRoute(opaque: rebuildRoutes, child: page, transition: transition),
        predicate);
  }

  /// Show a dialog. You can choose color and opacity of background
  static Future<T> dialog<T>(
    Widget child, {
    bool barrierDismissible = true,
    //  WidgetBuilder builder,
    bool useRootNavigator = true,
  }) {
    assert(child != null);
    assert(useRootNavigator != null);
    final ThemeData theme =
        Theme.of(Get.key.currentContext, shadowThemeOnly: true);
    return getShowGeneralDialog(
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = child; // ?? Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(Get.key.currentContext)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      // transitionBuilder: _buildMaterialDialogTransitions,
      useRootNavigator: useRootNavigator,
    );
  }

  static defaultDialog(
      {Color color,
      double opacity = 0.2,
      String title = "Alert dialog",
      Widget content,
      Widget cancel,
      Widget confirm}) {
    final child = DefaultDialogGet(
      color: color,
      opacity: opacity,
      title: title,
      content: content,
      cancel: cancel,
      confirm: confirm,
    );

    dialog(child);
  }

  static Future<T> bottomSheet<T>({
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    assert(builder != null);
    assert(isScrollControlled != null);
    assert(useRootNavigator != null);
    assert(isDismissible != null);
    assert(enableDrag != null);

    return Get.key.currentState.push<T>(GetModalBottomSheetRoute<T>(
      builder: builder,
      theme: Theme.of(Get.key.currentContext, shadowThemeOnly: true),
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(Get.key.currentContext)
          .modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      enableDrag: enableDrag,
    ));
  }

  static snackbar(title, message,
      {Color colorText, Duration duration, SnackPosition snackPosition}) {
    return GetBar(
      titleText: Text(
        title,
        style: TextStyle(
            color: colorText ?? Theme.of(Get.key.currentContext).accentColor,
            fontWeight: FontWeight.w800,
            fontSize: 16),
      ),
      messageText: Text(
        message,
        style: TextStyle(
            color: colorText ?? Theme.of(Get.key.currentContext).accentColor,
            fontWeight: FontWeight.w300,
            fontSize: 14),
      ),
      snackPosition: snackPosition ?? SnackPosition.TOP,
      borderRadius: 15,
      margin: EdgeInsets.symmetric(horizontal: 10),
      duration: duration ?? Duration(seconds: 3),
      barBlur: 7.0,
      backgroundColor: Colors.grey.withOpacity(0.2),
    )..show();
  }
}

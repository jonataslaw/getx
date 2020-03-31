import 'package:flutter/material.dart';
import 'getroute_cupertino.dart';
import 'getroute_material.dart';
import 'transitions_type.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
PageRoute<T> GetRoute<T>({
  Key key,
  RouteSettings settings,
  String title,
  bool rebuildRoutes,
  bool maintainState = true,
  @required Widget page,
  Transition transition,
  Curve curve = Curves.linear,
  Alignment alignment,
  Duration duration = const Duration(milliseconds: 400),
  bool fullscreenDialog = false,
}) {
  return GetPlatform.isIOS
      ? GetCupertino(
          settings: settings,
          title: title,
          opaque: rebuildRoutes ?? true,
          maintainState: maintainState,
          page: page,
          transition: transition ?? Transition.cupertino,
          curve: curve,
          alignment: alignment,
          duration: duration,
          fullscreenDialog: fullscreenDialog)
      : GetMaterial(
          settings: settings,
          opaque: rebuildRoutes ?? false,
          maintainState: maintainState,
          page: page,
          transition: transition ?? Transition.fade,
          curve: curve,
          alignment: alignment,
          duration: duration,
          fullscreenDialog: fullscreenDialog);
}

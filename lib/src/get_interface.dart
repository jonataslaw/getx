import 'package:flutter/material.dart';
import 'navigation/root/parse_route.dart';
import 'navigation/root/root_controller.dart';
import 'navigation/routes/custom_transition.dart';
import 'navigation/routes/observers/route_observer.dart';
import 'navigation/routes/transitions_type.dart';
import 'utils/utils.dart';

///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
///To return to the previous screen, use Get.back().
///No need to pass any context to Get, just put the name of the route inside
///the parentheses and the magic will occur.

abstract class GetInterface {
  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;
  Transition defaultTransition;
  Duration defaultDurationTransition = Duration(milliseconds: 400);
  bool defaultGlobalState = true;
  RouteSettings settings;
  String defaultSeparator = "_";

  final routing = Routing();

  Map<String, String> parameters = {};

  ParseRouteTree routeTree;

  CustomTransition customTransition;

  GetMaterialController getxController = GetMaterialController();

  Locale locale;

  GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  Map<int, GlobalKey<NavigatorState>> keys = {};

  Map<String, Map<String, String>> translations = {};
}

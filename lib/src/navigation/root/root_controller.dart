import 'package:flutter/material.dart';
import '../../state_manager/simple/get_state.dart';
import '../../utils/platform/platform.dart';
import '../routes/custom_transition.dart';
import '../routes/observers/route_observer.dart';
import '../routes/transitions_type.dart';
import 'parse_route.dart';

class GetMaterialController extends GetxController {
  Key unikey;
  ThemeData theme;
  ThemeMode themeMode;

  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;

  Transition defaultTransition;
  Duration defaultTransitionDuration = Duration(milliseconds: 400);
  Curve defaultTransitionCurve = Curves.easeOutQuad;

  Curve defaultDialogTransitionCurve = Curves.easeOutQuad;
  Duration defaultDialogTransitionDuration = Duration(milliseconds: 400);

  final routing = Routing();

  Map<String, String> parameters = {};

  ParseRouteTree routeTree;

  CustomTransition customTransition;

  GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  Map<int, GlobalKey<NavigatorState>> keys = {};

  void setTheme(ThemeData value) {
    theme = value;
    update();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    update();
  }

  void restartApp() {
    unikey = UniqueKey();
    update();
  }
}

import 'package:flutter/material.dart';

import '../../../get_state_manager/get_state_manager.dart';
import '../../../get_utils/get_utils.dart';
import '../routes/custom_transition.dart';
import '../routes/observers/route_observer.dart';
import '../routes/transitions_type.dart';

class GetMaterialController extends GetxController {
  bool testMode = false;
  Key? unikey;
  ThemeData? theme;
  ThemeData? darkTheme;
  ThemeMode? themeMode;

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;

  Transition? defaultTransition;
  Duration defaultTransitionDuration = Duration(milliseconds: 300);
  Curve defaultTransitionCurve = Curves.easeOutQuad;

  Curve defaultDialogTransitionCurve = Curves.easeOutQuad;

  Duration defaultDialogTransitionDuration = Duration(milliseconds: 300);

  final routing = Routing();

  Map<String, String?> parameters = {};

  CustomTransition? customTransition;

  var _key = GlobalKey<NavigatorState>(debugLabel: 'Key Created by default');

  Map<dynamic, GlobalKey<NavigatorState>> keys = {};

  GlobalKey<NavigatorState> get key => _key;

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    _key = newKey;
    return key;
  }

  void restartApp() {
    unikey = UniqueKey();
    update();
  }

  void setTheme(ThemeData value) {
    if (darkTheme == null) {
      theme = value;
    } else {
      if (value.brightness == Brightness.light) {
        theme = value;
      } else {
        darkTheme = value;
      }
    }
    update();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    update();
  }
}

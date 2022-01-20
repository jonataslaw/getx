import 'package:flutter/material.dart';

import '../../../get.dart';

class GetMaterialController extends SuperController {
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

  Map<dynamic, GetDelegate> keys = {};

  GlobalKey<NavigatorState> get key => rootDelegate.navigatorKey;

  GetDelegate get rootDelegate => Get.createDelegate();

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    rootDelegate.navigatorKey = newKey;
    return key;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    Get.asap(() {
      final locale = Get.deviceLocale;
      if (locale != null) {
        Get.updateLocale(locale);
      }
    });
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

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

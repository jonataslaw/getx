import 'package:flutter/material.dart';

import '../../state_manager/simple/get_state.dart';

class GetMaterialController extends GetxController {
  Key key;
  ThemeData theme;
  ThemeMode themeMode;

  void setTheme(ThemeData value) {
    theme = value;
    update();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    update();
  }

  void restartApp() {
    key = UniqueKey();
    update();
  }
}

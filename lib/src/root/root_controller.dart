import 'package:flutter/material.dart';
import 'package:get/src/routes/utils/parse_arguments.dart';
import 'package:get/src/state/get_state.dart';

class GetMaterialController extends GetController {
  ParseRoute parse = ParseRoute();
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
    print("restart chamado");
    key = UniqueKey();
    update();
  }
}

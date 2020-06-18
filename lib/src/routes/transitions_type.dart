import 'package:flutter/widgets.dart';

enum Transition {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
  cupertino,
  custom
}

typedef GetPageBuilder = Widget Function();

import 'package:flutter/widgets.dart';

enum Transition {
  fade,
  fadeIn,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  rightToLeftWithFade,
  leftToRightWithFade,
  zoom,
  noTransition,
  cupertino,
  cupertinoDialog,
  size,
  native
}

typedef GetPageBuilder = Widget Function();

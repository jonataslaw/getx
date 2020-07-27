import 'package:flutter/widgets.dart';

abstract class CustomTransition {
  Widget buildTransition(
    BuildContext context,
    Curve curve,
    Alignment alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}

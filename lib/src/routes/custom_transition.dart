import 'package:flutter/widgets.dart';

abstract class CustomTransition {
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  );
}

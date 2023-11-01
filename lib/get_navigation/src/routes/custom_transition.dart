import 'package:flutter/widgets.dart';

// ignore: one_member_abstracts
abstract class CustomTransition {
  Widget buildTransition(
    final BuildContext context,
    final Curve? curve,
    final Alignment? alignment,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  );
}

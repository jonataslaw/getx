import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'circular_reveal_clipper.dart';

class LeftToRightFadeTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).animate(secondaryAnimation),
            child: child,),
      ),
    );
  }
}

class RightToLeftFadeTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1.0, 0.0),
            ).animate(secondaryAnimation),
            child: child,),
      ),
    );
  }
}

class NoTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve curve,
      final Alignment alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return child;
  }
}

class FadeInTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class SlideDownTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class SlideLeftTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class SlideRightTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class SlideTopTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class ZoomInTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}

class SizeTransitions {
  Widget buildTransitions(
      final BuildContext context,
      final Curve curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return Align(
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
        child: child,
      ),
    );
  }
}

class CircularRevealTransition {
  Widget buildTransitions(
      final BuildContext context,
      final Curve? curve,
      final Alignment? alignment,
      final Animation<double> animation,
      final Animation<double> secondaryAnimation,
      final Widget child,) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: animation.value,
        centerAlignment: Alignment.center,
        centerOffset: Offset.zero,
        minRadius: 0,
        maxRadius: 800,
      ),
      child: child,
    );
  }
}

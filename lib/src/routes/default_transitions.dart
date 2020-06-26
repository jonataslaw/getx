import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'transitions_component.dart';

class LeftToRightFadeTransition extends TransitionInterface {
  LeftToRightFadeTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
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
            child: child),
      ),
    );
  }
}

class RightToLeftFadeTransition extends TransitionInterface {
  RightToLeftFadeTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
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
            child: child),
      ),
    );
  }
}

class NoTransition extends TransitionInterface {
  NoTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return transitionComponent.buildChildWithTransition(
        context, animation, secondaryAnimation, child);
  }
}

class FadeInTransition extends TransitionInterface {
  FadeInTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: animation,
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

class SlideDownTransition extends TransitionInterface {
  SlideDownTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

class SlideLeftTransition extends TransitionInterface {
  SlideLeftTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

class SlideRightTransition extends TransitionInterface {
  SlideRightTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

class SlideTopTransition extends TransitionInterface {
  SlideTopTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(animation),
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

class ZoomInTransition extends TransitionInterface {
  ZoomInTransition({
    TransitionComponent transitionComponent,
  }) : super(transitionComponent: transitionComponent);

  @override
  Widget buildChildWithTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: animation,
      child: transitionComponent.buildChildWithTransition(
          context, animation, secondaryAnimation, child),
    );
  }
}

abstract class TransitionInterface implements TransitionComponent {
  TransitionComponent transitionComponent;
  TransitionInterface({this.transitionComponent});
}

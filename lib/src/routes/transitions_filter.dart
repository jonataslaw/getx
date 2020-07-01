import 'default_transitions.dart';
import 'transitions_component.dart';
import 'transitions_type.dart';

class TransitionFilter {
  static TransitionComponent newTransitionComponent(
    Transition transition,
  ) {
    TransitionComponent transitionComponent = TransitionComponent();
    switch (transition) {
      case Transition.leftToRight:
        return SlideLeftTransition(transitionComponent: transitionComponent);

      case Transition.downToUp:
        return SlideDownTransition(transitionComponent: transitionComponent);

      case Transition.upToDown:
        return SlideTopTransition(transitionComponent: transitionComponent);

      case Transition.rightToLeft:
        return SlideRightTransition(transitionComponent: transitionComponent);

      case Transition.zoom:
        return ZoomInTransition(transitionComponent: transitionComponent);

      case Transition.fadeIn:
        return FadeInTransition(transitionComponent: transitionComponent);

      case Transition.rightToLeftWithFade:
        return RightToLeftFadeTransition(
            transitionComponent: transitionComponent);

      case Transition.leftToRightWithFade:
        return LeftToRightFadeTransition(
            transitionComponent: transitionComponent);

      case Transition.cupertino:
        return CupertinoTransitions(transitionComponent: transitionComponent);

      case Transition.size:
        return SizeTransitions(transitionComponent: transitionComponent);

      default:
        return FadeInTransition(transitionComponent: transitionComponent);
    }
  }
}

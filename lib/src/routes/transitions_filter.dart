import 'default_transitions.dart';
import 'transitions_component.dart';
import 'transitions_type.dart';

class TransitionFilter {
  static TransitionComponent newTransitionComponent(
    Transition transition,
  ) {
    switch (transition) {
      case Transition.leftToRight:
        return SlideLeftTransition();

      case Transition.downToUp:
        return SlideDownTransition();

      case Transition.upToDown:
        return SlideTopTransition();

      case Transition.rightToLeft:
        return SlideRightTransition();

      case Transition.zoom:
        return ZoomInTransition();

      case Transition.fadeIn:
        return FadeInTransition();

      case Transition.rightToLeftWithFade:
        return RightToLeftFadeTransition();

      case Transition.leftToRightWithFade:
        return LeftToRightFadeTransition();

      case Transition.cupertino:
        return CupertinoTransitions();

      case Transition.size:
        return SizeTransitions();

      default:
        return FadeInTransition();
    }
  }
}

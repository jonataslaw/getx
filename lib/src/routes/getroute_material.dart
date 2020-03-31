import 'package:flutter/material.dart';
import 'transitions_type.dart';

class GetMaterial<T> extends PageRouteBuilder<T> {
  /// Construct a Modified PageRoute whose contents are defined by child.
  /// The values of [child], [maintainState], [opaque], and [fullScreenDialog] must not
  /// be null.
  GetMaterial({
    Key key,
    RouteSettings settings,
    this.opaque = false,
    this.maintainState = true,
    @required this.page,
    this.transition = Transition.fade,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 400),
    bool fullscreenDialog = false,
  })  : assert(page != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque != null),
        super(
            fullscreenDialog: fullscreenDialog,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return page;
            },
            transitionDuration: duration,
            settings: settings,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              switch (transition) {
                case Transition.fade:
                  return FadeTransition(opacity: animation, child: child);
                  break;
                case Transition.rightToLeft:
                  return SlideTransition(
                    transformHitTests: false,
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                  break;
                case Transition.leftToRight:
                  return SlideTransition(
                    transformHitTests: false,
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                  break;
                case Transition.upToDown:
                  return SlideTransition(
                    transformHitTests: false,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(0.0, 1.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                  break;
                case Transition.downToUp:
                  return SlideTransition(
                    transformHitTests: false,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(0.0, -1.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                  break;
                case Transition.scale:
                  return ScaleTransition(
                    alignment: alignment,
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.00,
                        0.50,
                        curve: curve,
                      ),
                    ),
                    child: child,
                  );
                  break;
                case Transition.rotate:
                  return RotationTransition(
                    alignment: alignment,
                    turns: animation,
                    child: ScaleTransition(
                      alignment: alignment,
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                  break;
                case Transition.size:
                  return Align(
                    alignment: alignment,
                    child: SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      ),
                      child: child,
                    ),
                  );
                  break;
                case Transition.rightToLeftWithFade:
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
                        child: child,
                      ),
                    ),
                  );
                  break;
                case Transition.leftToRightWithFade:
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
                        child: child,
                      ),
                    ),
                  );
                  break;
                default:
                  return FadeTransition(opacity: animation, child: child);
              }
            });

  @override
  final bool maintainState;

  /// Allows you to set opaque to false to prevent route reconstruction.
  @override
  final bool opaque;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  // @override
  // bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
  //   return previousRoute is GetMaterial || previousRoute is CupertinoPageRoute;
  // }

  // @override
  // bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
  //   // Don't perform outgoing animation if the next route is a fullscreen dialog.
  //   return (nextRoute is GetMaterial && !nextRoute.fullscreenDialog) ||
  //       (nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog);
  // }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  final Widget page;

  final Transition transition;

  final Curve curve;

  final Alignment alignment;

  final Duration duration;
}

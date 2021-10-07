import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../get.dart';

import 'default_transitions.dart';
import 'transitions_type.dart';

const double _kBackGestureWidth = 20.0;
const double _kMinFlingVelocity = 1.0; // Screen widths per second.

// An eyeballed value for the maximum time it takes
//for a page to animate forward
// if the user releases a page mid swipe.
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.

// The maximum time for a page to get reset to it's original position if the
// user releases a page mid swipe.
const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

mixin GetPageRouteTransitionMixin<T> on PageRoute<T> {
  /// Builds the primary contents of the route.
  @protected
  Widget buildContent(BuildContext context);

  /// {@template flutter.cupertino.CupertinoRouteTransitionMixin.title}
  /// A title string for this route.
  ///
  /// Used to auto-populate [CupertinoNavigationBar] and
  /// [CupertinoSliverNavigationBar]'s `middle`/`largeTitle` widgets when
  /// one is not manually supplied.
  /// {@endtemplate}
  String? get title;

  double Function(BuildContext context)? get gestureWidth;

  ValueNotifier<String?>? _previousTitle;

  /// The title string of the previous [CupertinoPageRoute].
  ///
  /// The [ValueListenable]'s value is readable after the route is installed
  /// onto a [Navigator]. The [ValueListenable] will also notify its listeners
  /// if the value changes (such as by replacing the previous route).
  ///
  /// The [ValueListenable] itself will be null before the route is installed.
  /// Its content value will be null if the previous route has no title or
  /// is not a [CupertinoPageRoute].
  ///
  /// See also:
  ///
  ///  * [ValueListenableBuilder], which can be used to listen and rebuild
  ///    widgets based on a ValueListenable.
  ValueListenable<String?> get previousTitle {
    assert(
      _previousTitle != null,
      '''
Cannot read the previousTitle for a route that has not yet been installed''',
    );
    return _previousTitle!;
  }

  @override
  void didChangePrevious(Route<dynamic>? previousRoute) {
    final previousTitleString = previousRoute is CupertinoRouteTransitionMixin
        ? previousRoute.title
        : null;
    if (_previousTitle == null) {
      _previousTitle = ValueNotifier<String?>(previousTitleString);
    } else {
      _previousTitle!.value = previousTitleString;
    }
    super.didChangePrevious(previousRoute);
  }

  @override
  // A relatively rigorous eyeball estimation.
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  bool get showCupertinoParallax;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a
    // fullscreen dialog.

    return nextRoute is GetPageRouteTransitionMixin &&
        !nextRoute.fullscreenDialog &&
        nextRoute.showCupertinoParallax;
  }

  /// True if an iOS-style back swipe pop gesture is currently
  /// underway for [route].
  ///
  /// This just check the route's [NavigatorState.userGestureInProgress].
  ///
  /// See also:
  ///
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  /// True if an iOS-style back swipe pop gesture is currently
  /// underway for this route.
  ///
  /// See also:
  ///
  ///  * [isPopGestureInProgress], which returns true if a Cupertino pop gesture
  ///    is currently underway for specific route.
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  bool get popGestureInProgress => isPopGestureInProgress(this);

  /// Whether a pop gesture can be started by the user.
  ///
  /// Returns true if the user can edge-swipe to a previous route.
  ///
  /// Returns false once [isPopGestureInProgress] is true, but
  /// [isPopGestureInProgress] can only become true if [popGestureEnabled] was
  /// true first.
  ///
  /// This should only be used between frames, not during build.
  bool get popGestureEnabled => _isPopGestureEnabled(this);

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst) return false;
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes),
    //so disallow it.
    if (route.willHandlePopInternally) return false;
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback) return false;
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) return false;
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation!.status != AnimationStatus.completed) return false;
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route)) return false;

    // Looks like a back gesture would be welcome!
    return true;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final child = buildContent(context);
    final Widget result = Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
    return result;
  }

  // Called by CupertinoBackGestureDetector when a pop ("back") drag start
  // gesture is detected. The returned controller handles all of the subsequent
  // drag events.
  static CupertinoBackGestureController<T> _startPopGesture<T>(
      PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return CupertinoBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!, // protected access
    );
  }

  /// Returns a [CupertinoFullscreenDialogTransition] if [route] is a full
  /// screen dialog, otherwise a [CupertinoPageTransition] is returned.
  ///
  /// Used by [CupertinoPageRoute.buildTransitions].
  ///
  /// This method can be applied to any [PageRoute], not just
  /// [CupertinoPageRoute]. It's typically used to provide a Cupertino style
  /// horizontal transition for material widgets when the target platform
  /// is [TargetPlatform.iOS].
  ///
  /// See also:
  ///
  ///  * [CupertinoPageTransitionsBuilder], which uses this method to define a
  ///    [PageTransitionsBuilder] for the [PageTransitionsTheme].
  static Widget buildPageTransitions<T>(
    PageRoute<T> rawRoute,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Check if the route has an animation that's currently participating
    // in a back swipe gesture.
    //
    // In the middle of a back gesture drag, let the transition be linear to
    // match finger motions.
    final route = rawRoute as GetPageRoute<T>;
    final linearTransition = isPopGestureInProgress(route);
    final finalCurve = route.curve ?? Get.defaultTransitionCurve;
    final hasCurve = route.curve != null;
    if (route.fullscreenDialog && route.transition == null) {
      return CupertinoFullscreenDialogTransition(
        primaryRouteAnimation: hasCurve
            ? CurvedAnimation(parent: animation, curve: finalCurve)
            : animation,
        secondaryRouteAnimation: secondaryAnimation,
        child: child,
        linearTransition: linearTransition,
      );
    } else {
      if (route.customTransition != null) {
        return route.customTransition!.buildTransition(
          context,
          finalCurve,
          route.alignment,
          animation,
          secondaryAnimation,
          route.popGesture ?? Get.defaultPopGesture
              ? CupertinoBackGestureDetector<T>(
                  gestureWidth:
                      route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                  enabledCallback: () => _isPopGestureEnabled<T>(route),
                  onStartPopGesture: () => _startPopGesture<T>(route),
                  child: child)
              : child,
        );
      }

      /// Apply the curve by default...
      final iosAnimation = animation;
      animation = CurvedAnimation(parent: animation, curve: finalCurve);

      switch (route.transition ?? Get.defaultTransition) {
        case Transition.leftToRight:
          return SlideLeftTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.downToUp:
          return SlideDownTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.upToDown:
          return SlideTopTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.noTransition:
          return route.popGesture ?? Get.defaultPopGesture
              ? CupertinoBackGestureDetector<T>(
                  gestureWidth:
                      route.gestureWidth?.call(context) ?? _kBackGestureWidth,
                  enabledCallback: () => _isPopGestureEnabled<T>(route),
                  onStartPopGesture: () => _startPopGesture<T>(route),
                  child: child)
              : child;

        case Transition.rightToLeft:
          return SlideRightTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.zoom:
          return ZoomInTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.fadeIn:
          return FadeInTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.rightToLeftWithFade:
          return RightToLeftFadeTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.leftToRightWithFade:
          return LeftToRightFadeTransition().buildTransitions(
              context,
              route.curve,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.cupertino:
          return CupertinoPageTransition(
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: linearTransition,
            child: CupertinoBackGestureDetector<T>(
              gestureWidth:
                  route.gestureWidth?.call(context) ?? _kBackGestureWidth,
              enabledCallback: () => _isPopGestureEnabled<T>(route),
              onStartPopGesture: () => _startPopGesture<T>(route),
              child: child,
            ),
          );

        case Transition.size:
          return SizeTransitions().buildTransitions(
              context,
              route.curve!,
              route.alignment,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.fade:
          return FadeUpwardsPageTransitionsBuilder().buildTransitions(
              route,
              context,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.topLevel:
          return ZoomPageTransitionsBuilder().buildTransitions(
              route,
              context,
              animation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        case Transition.native:
          return PageTransitionsTheme().buildTransitions(
              route,
              context,
              iosAnimation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);

        default:
          if (Get.customTransition != null) {
            return Get.customTransition!.buildTransition(context, route.curve,
                route.alignment, animation, secondaryAnimation, child);
          }

          return PageTransitionsTheme().buildTransitions(
              route,
              context,
              iosAnimation,
              secondaryAnimation,
              route.popGesture ?? Get.defaultPopGesture
                  ? CupertinoBackGestureDetector<T>(
                      gestureWidth: route.gestureWidth?.call(context) ??
                          _kBackGestureWidth,
                      enabledCallback: () => _isPopGestureEnabled<T>(route),
                      onStartPopGesture: () => _startPopGesture<T>(route),
                      child: child)
                  : child);
      }
    }
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}

class CupertinoBackGestureDetector<T> extends StatefulWidget {
  const CupertinoBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
    required this.gestureWidth,
  }) : super(key: key);

  final Widget child;
  final double gestureWidth;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<CupertinoBackGestureController<T>> onStartPopGesture;

  @override
  CupertinoBackGestureDetectorState<T> createState() =>
      CupertinoBackGestureDetectorState<T>();
}

class CupertinoBackGestureDetectorState<T>
    extends State<CupertinoBackGestureDetector<T>> {
  CupertinoBackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with
    // the "down" event
    // that we don't consider here.
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer.addPointer(event);
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    var dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, widget.gestureWidth);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class CupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  CupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  /// The drag gesture has changed by [fractionalDelta]. The total range of the
  /// drag should be 0.0 to 1.0.
  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of
  /// [fractionalVelocity] as a fraction of screen width per second.
  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    if (velocity.abs() >= _kMinFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final droppedPageForwardAnimationTime = min(
        lerpDouble(
                _kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the
      // target destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final droppedPageBackAnimationTime = lerpDouble(
                0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!
            .floor();
        controller.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

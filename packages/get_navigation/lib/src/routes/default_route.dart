import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_core/get_core.dart';
import 'package:get_state_manager/get_state_manager.dart';
import '../../get_navigation.dart';
import 'custom_transition.dart';
import 'default_transitions.dart';
import 'transitions_type.dart';

class GetPageRoute<T> extends PageRoute<T> {
  GetPageRoute({
    RouteSettings settings,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.opaque = true,
    this.parameter,
    this.curve,
    this.alignment,
    this.transition,
    this.popGesture,
    this.customTransition,
    this.barrierDismissible = false,
    this.barrierColor,
    this.binding,
    this.bindings,
    this.routeName,
    this.page,
    this.barrierLabel,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(opaque != null),
        assert(barrierDismissible != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  final Duration transitionDuration;

  final GetPageBuilder page;

  final String routeName;

  final CustomTransition customTransition;

  final Bindings binding;

  final Map<String, String> parameter;

  final List<Bindings> bindings;

  @override
  final bool opaque;

  final bool popGesture;

  @override
  final bool barrierDismissible;

  final Transition transition;

  final Curve curve;

  final Alignment alignment;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a
    // fullscreen dialog.
    return nextRoute is PageRoute && !nextRoute.fullscreenDialog;
  }

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // ignore: lines_longer_than_80_chars
    if (route.isFirst ||
        route.willHandlePopInternally ||
        route.hasScopedWillPopCallback ||
        route.fullscreenDialog ||
        route.animation.status != AnimationStatus.completed ||
        route.secondaryAnimation.status != AnimationStatus.dismissed ||
        isPopGestureInProgress(route)) return false;

    return true;
  }

  static _CupertinoBackGestureController<T> _startPopGesture<T>(
      PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));

    return _CupertinoBackGestureController<T>(
      navigator: route.navigator,
      controller: route.controller,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Get.reference = settings.name ?? routeName;
    binding?.dependencies();
    if (bindings != null) {
      for (final binding in bindings) {
        binding.dependencies();
      }
    }
    // final pageWidget = page();
    return page();
  }

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator.userGestureInProgress;
  }

  bool get popGestureInProgress => isPopGestureInProgress(this);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final finalCurve = curve ?? Get.defaultTransitionCurve;
    final hasCurve = curve != null;
    if (fullscreenDialog && transition == null) {
      /// by default, if no curve is defined, use Cupertino transition in the
      /// default way (no linearTransition)... otherwise take the curve passed.
      return CupertinoFullscreenDialogTransition(
          primaryRouteAnimation: hasCurve
              ? CurvedAnimation(parent: animation, curve: finalCurve)
              : animation,
          secondaryRouteAnimation: secondaryAnimation,
          child: child,
          linearTransition: hasCurve);
    }
    if (customTransition != null) {
      return customTransition.buildTransition(
        context,
        finalCurve,
        alignment,
        animation,
        secondaryAnimation,
        popGesture ?? Get.defaultPopGesture
            ? _CupertinoBackGestureDetector<T>(
                enabledCallback: () => _isPopGestureEnabled<T>(this),
                onStartPopGesture: () => _startPopGesture<T>(this),
                child: child)
            : child,
      );
    }

    /// Apply the curve by default...
    final iosAnimation = animation;
    animation = CurvedAnimation(parent: animation, curve: finalCurve);

    switch (transition ?? Get.defaultTransition) {
      case Transition.leftToRight:
        return SlideLeftTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.downToUp:
        return SlideDownTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.upToDown:
        return SlideTopTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.noTransition:
        return popGesture ?? Get.defaultPopGesture
            ? _CupertinoBackGestureDetector<T>(
                enabledCallback: () => _isPopGestureEnabled<T>(this),
                onStartPopGesture: () => _startPopGesture<T>(this),
                child: child)
            : child;

      case Transition.rightToLeft:
        return SlideRightTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.zoom:
        return ZoomInTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.fadeIn:
        return FadeInTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.rightToLeftWithFade:
        return RightToLeftFadeTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.leftToRightWithFade:
        return LeftToRightFadeTransition().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.cupertino:
        return CupertinoPageTransitionsBuilder().buildTransitions(
            this,
            context,
            iosAnimation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.size:
        return SizeTransitions().buildTransitions(
            context,
            curve,
            alignment,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.fade:
        return FadeUpwardsPageTransitionsBuilder().buildTransitions(
            this,
            context,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.topLevel:
        return ZoomPageTransitionsBuilder().buildTransitions(
            this,
            context,
            animation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      case Transition.native:
        return PageTransitionsTheme().buildTransitions(
            this,
            context,
            iosAnimation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);

      default:
        if (Get.customTransition != null) {
          return Get.customTransition.buildTransition(
              context, curve, alignment, animation, secondaryAnimation, child);
        }

        return PageTransitionsTheme().buildTransitions(
            this,
            context,
            iosAnimation,
            secondaryAnimation,
            popGesture ?? Get.defaultPopGesture
                ? _CupertinoBackGestureDetector<T>(
                    enabledCallback: () => _isPopGestureEnabled<T>(this),
                    onStartPopGesture: () => _startPopGesture<T>(this),
                    child: child)
                : child);
    }
  }

  @override
  void dispose() {
    if (Get.smartManagement != SmartManagement.onlyBuilder) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GetInstance()
          .removeDependencyByRoute("${settings?.name ?? routeName}"));
    }
    super.dispose();
  }
}

const double _kBackGestureWidth = 20.0;
const double _kMinFlingVelocity = 1.0;
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.

// The maximum time for a page to get reset to it's original position if the
// user releases a page mid swipe.
const int _kMaxPageBackAnimationTime = 300;

class _CupertinoBackGestureDetector<T> extends StatefulWidget {
  const _CupertinoBackGestureDetector({
    Key key,
    @required this.enabledCallback,
    @required this.onStartPopGesture,
    @required this.child,
  })  : assert(enabledCallback != null),
        assert(onStartPopGesture != null),
        assert(child != null),
        super(key: key);

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_CupertinoBackGestureController<T>> onStartPopGesture;

  @override
  _CupertinoBackGestureDetectorState<T> createState() =>
      _CupertinoBackGestureDetectorState<T>();
}

class _CupertinoBackGestureDetectorState<T>
    extends State<_CupertinoBackGestureDetector<T>> {
  _CupertinoBackGestureController<T> _backGestureController;

  HorizontalDragGestureRecognizer _recognizer;

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
    _backGestureController.dragUpdate(
        _convertToLogical(details.primaryDelta / context.size.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with
    // the "down" event that we don't consider here.
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
    // FIXME: shouldn't we return a default here?
    //  or perhaps throw error
    // ignore: avoid_returning_null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    var dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth);
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

class _CupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  _CupertinoBackGestureController({
    @required this.navigator,
    @required this.controller,
  })  : assert(navigator != null),
        assert(controller != null) {
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
    bool animateForward;

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
          _kMaxDroppedSwipePageForwardAnimationTime,
          0,
          controller.value,
        ).floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the target
      // destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final droppedPageBackAnimationTime = lerpDouble(
          0,
          _kMaxDroppedSwipePageForwardAnimationTime,
          controller.value,
        ).floor();
        controller.animateBack(
          0.0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      AnimationStatusListener animationStatusCallback;
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

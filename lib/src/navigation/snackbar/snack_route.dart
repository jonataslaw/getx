import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'snack.dart';

class SnackRoute<T> extends OverlayRoute<T> {
  Animation<double> _filterBlurAnimation;
  Animation<Color> _filterColorAnimation;

  SnackRoute({
    @required this.snack,
    RouteSettings settings,
  }) : super(settings: settings) {
    _builder = Builder(builder: (innerContext) {
      return GestureDetector(
        child: snack,
        onTap: snack.onTap != null ? () => snack.onTap(snack) : null,
      );
    });

    _configureAlignment(snack.snackPosition);
    _snackbarStatus = snack.snackbarStatus;
  }

  _configureAlignment(SnackPosition snackPosition) {
    switch (snack.snackPosition) {
      case SnackPosition.TOP:
        {
          _initialAlignment = Alignment(-1.0, -2.0);
          _endAlignment = Alignment(-1.0, -1.0);
          break;
        }
      case SnackPosition.BOTTOM:
        {
          _initialAlignment = Alignment(-1.0, 2.0);
          _endAlignment = Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  GetBar snack;
  Builder _builder;

  Future<T> get completed => _transitionCompleter.future;
  final Completer<T> _transitionCompleter = Completer<T>();

  SnackbarStatusCallback _snackbarStatus;
  Alignment _initialAlignment;
  Alignment _endAlignment;
  bool _wasDismissedBySwipe = false;

  Timer _timer;

  bool get opaque => false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    var overlays = <OverlayEntry>[];

    if (snack.overlayBlur > 0.0) {
      overlays.add(
        OverlayEntry(
          builder: (context) {
            return GestureDetector(
              onTap: snack.isDismissible ? () => snack.dismiss() : null,
              child: AnimatedBuilder(
                animation: _filterBlurAnimation,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _filterBlurAnimation.value,
                        sigmaY: _filterBlurAnimation.value),
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      color: _filterColorAnimation.value,
                    ),
                  );
                },
              ),
            );
          },
          maintainState: false,
          opaque: opaque,
        ),
      );
    }

    overlays.add(
      OverlayEntry(
        builder: (context) {
          final Widget annotatedChild = Semantics(
            child: AlignTransition(
              alignment: _animation,
              child: snack.isDismissible
                  ? _getDismissibleSnack(_builder)
                  : _getSnack(),
            ),
            focused: false,
            container: true,
            explicitChildNodes: true,
          );
          return annotatedChild;
        },
        maintainState: false,
        opaque: opaque,
      ),
    );

    return overlays;
  }

  String dismissibleKeyGen = "";

  Widget _getDismissibleSnack(Widget child) {
    return Dismissible(
      direction: _getDismissDirection(),
      resizeDuration: null,
      confirmDismiss: (_) {
        if (currentStatus == SnackbarStatus.OPENING ||
            currentStatus == SnackbarStatus.CLOSING) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      key: Key(dismissibleKeyGen),
      onDismissed: (_) {
        dismissibleKeyGen += "1";
        _cancelTimer();
        _wasDismissedBySwipe = true;

        if (isCurrent) {
          navigator.pop();
        } else {
          navigator.removeRoute(this);
        }
      },
      child: _getSnack(),
    );
  }

  Widget _getSnack() {
    return Container(
      margin: snack.margin,
      child: _builder,
    );
  }

  DismissDirection _getDismissDirection() {
    if (snack.dismissDirection == SnackDismissDirection.HORIZONTAL) {
      return DismissDirection.horizontal;
    } else {
      if (snack.snackPosition == SnackPosition.TOP) {
        return DismissDirection.up;
      }
      return DismissDirection.down;
    }
  }

  @override
  bool get finishedWhenPopped =>
      _controller.status == AnimationStatus.dismissed;

  /// The animation that drives the route's transition and the previous route's
  /// forward transition.
  Animation<Alignment> get animation => _animation;
  Animation<Alignment> _animation;

  /// The animation controller that the route uses to drive the transitions.
  ///
  /// The animation itself is exposed by the [animation] property.
  @protected
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// Called to create the animation controller that will drive the transitions
  /// to this route from the previous one, and back to the previous route
  /// from this one.
  AnimationController createAnimationController() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    assert(snack.animationDuration != null &&
        snack.animationDuration >= Duration.zero);
    return AnimationController(
      duration: snack.animationDuration,
      debugLabel: debugLabel,
      vsync: navigator,
    );
  }

  /// Called to create the animation that exposes the current progress of
  /// the transition controlled by the animation controller created by
  /// [createAnimationController()].
  Animation<Alignment> createAnimation() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot reuse a $runtimeType after disposing it.');
    assert(_controller != null);
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller,
        curve: snack.forwardAnimationCurve,
        reverseCurve: snack.reverseAnimationCurve,
      ),
    );
  }

  Animation<double> createBlurFilterAnimation() {
    return Tween(begin: 0.0, end: snack.overlayBlur).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
  }

  Animation<Color> createColorFilterAnimation() {
    return ColorTween(begin: Color(0x00000000), end: snack.overlayColor)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
  }

  T _result;
  SnackbarStatus currentStatus;

  //copy of `routes.dart`
  void _handleStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        currentStatus = SnackbarStatus.OPEN;
        _snackbarStatus(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = opaque;

        break;
      case AnimationStatus.forward:
        currentStatus = SnackbarStatus.OPENING;
        _snackbarStatus(currentStatus);
        break;
      case AnimationStatus.reverse:
        currentStatus = SnackbarStatus.CLOSING;
        _snackbarStatus(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = false;
        break;
      case AnimationStatus.dismissed:
        assert(!overlayEntries.first.opaque);
        // We might still be the current route if a subclass is controlling the
        // the transition and hits the dismissed status. For example, the iOS
        // back gesture drives this animation to the dismissed status before
        // popping the navigator.
        currentStatus = SnackbarStatus.CLOSED;
        _snackbarStatus(currentStatus);

        if (!isCurrent) {
          navigator.finalizeRoute(this);
          assert(overlayEntries.isEmpty);
        }
        break;
    }
    changedInternalState();
  }

  @override
  void install() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot install a $runtimeType after disposing it.');
    _controller = createAnimationController();
    assert(_controller != null,
        '$runtimeType.createAnimationController() returned null.');
    _filterBlurAnimation = createBlurFilterAnimation();
    _filterColorAnimation = createColorFilterAnimation();
    _animation = createAnimation();
    assert(_animation != null, '$runtimeType.createAnimation() returned null.');
    super.install();
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    assert(
      _controller != null,
      // ignore: lines_longer_than_80_chars
      '$runtimeType.didPush called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );
    _animation.addStatusListener(_handleStatusChanged);
    _configureTimer();
    return _controller.forward();
  }

  @override
  void didReplace(Route<dynamic> oldRoute) {
    assert(
      _controller != null,
      // ignore: lines_longer_than_80_chars
      '$runtimeType.didReplace called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );

    if (oldRoute is SnackRoute) {
      _controller.value = oldRoute._controller.value;
    }
    _animation.addStatusListener(_handleStatusChanged);
    super.didReplace(oldRoute);
  }

  @override
  bool didPop(T result) {
    assert(
      _controller != null,
      // ignore: lines_longer_than_80_chars
      '$runtimeType.didPop called before calling install() or after calling dispose().',
    );
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot reuse a $runtimeType after disposing it.',
    );

    _result = result;
    _cancelTimer();

    if (_wasDismissedBySwipe) {
      Timer(Duration(milliseconds: 200), () {
        _controller.reset();
      });

      _wasDismissedBySwipe = false;
    } else {
      _controller.reverse();
    }

    return super.didPop(result);
  }

  void _configureTimer() {
    if (snack.duration != null) {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
      _timer = Timer(snack.duration, () {
        if (isCurrent) {
          navigator.pop();
        } else if (isActive) {
          navigator.removeRoute(this);
        }
      });
    } else {
      if (_timer != null) {
        _timer.cancel();
      }
    }
  }

  void _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  /// Whether this route can perform a transition to the given route.
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionTo(SnackRoute<dynamic> nextRoute) => true;

  /// Whether this route can perform a transition from the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionFrom(SnackRoute<dynamic> previousRoute) => true;

  @override
  void dispose() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot dispose a $runtimeType twice.');
    _controller?.dispose();
    _transitionCompleter.complete(_result);
    super.dispose();
  }

  /// A short description of this route useful for debugging.
  String get debugLabel => '$runtimeType';

  @override
  String toString() => '$runtimeType(animation: $_controller)';
}

SnackRoute showSnack<T>({@required GetBar snack}) {
  assert(snack != null);

  return SnackRoute<T>(
    snack: snack,
    settings: RouteSettings(name: "snackbar"),
  );
}

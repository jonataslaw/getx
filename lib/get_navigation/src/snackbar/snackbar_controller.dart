import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../get.dart';

class SnackbarController {
  static final _snackBarQueue = _SnackBarQueue();
  static bool get isSnackbarBeingShown => _snackBarQueue.isJobInProgress;

  late Animation<double> _filterBlurAnimation;
  late Animation<Color?> _filterColorAnimation;

  final GetSnackBar snack;
  final _transitionCompleter = Completer<SnackbarController>();

  late SnackbarStatusCallback? _snackbarStatus;
  late final Alignment? _initialAlignment;
  late final Alignment? _endAlignment;

  bool _wasDismissedBySwipe = false;

  bool _onTappedDismiss = false;

  Timer? _timer;

  /// The animation that drives the route's transition and the previous route's
  /// forward transition.
  late final Animation<Alignment> _animation;

  /// The animation controller that the route uses to drive the transitions.
  ///
  /// The animation itself is exposed by the [animation] property.
  late final AnimationController _controller;

  SnackbarStatus? _currentStatus;

  final _overlayEntries = <OverlayEntry>[];

  OverlayState? _overlayState;

  SnackbarController(this.snack);

  Future<SnackbarController> get future => _transitionCompleter.future;

  Future<void> close() async {
    _removeEntry();
    await future;
  }

  Future<void> show() {
    return _snackBarQueue.addJob(this);
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  // ignore: avoid_returning_this
  void _configureAlignment(SnackPosition snackPosition) {
    switch (snack.snackPosition) {
      case SnackPosition.TOP:
        {
          _initialAlignment = const Alignment(-1.0, -2.0);
          _endAlignment = const Alignment(-1.0, -1.0);
          break;
        }
      case SnackPosition.BOTTOM:
        {
          _initialAlignment = const Alignment(-1.0, 2.0);
          _endAlignment = const Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  void _configureOverlay() {
    _overlayState = Overlay.of(Get.overlayContext!);
    _overlayEntries.clear();
    _overlayEntries.addAll(_createOverlayEntries(_getBodyWidget()));
    _overlayState!.insertAll(_overlayEntries);
    _configureSnackBarDisplay();
  }

  void _configureSnackBarDisplay() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot configure a snackbar after disposing it.');
    _controller = _createAnimationController();
    _configureAlignment(snack.snackPosition);
    _snackbarStatus = snack.snackbarStatus;
    _filterBlurAnimation = _createBlurFilterAnimation();
    _filterColorAnimation = _createColorOverlayColor();
    _animation = _createAnimation();
    _animation.addStatusListener(_handleStatusChanged);
    _configureTimer();
    _controller.forward();
  }

  void _configureTimer() {
    if (snack.duration != null) {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      _timer = Timer(snack.duration!, _removeEntry);
    } else {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
  }

  /// Called to create the animation that exposes the current progress of
  /// the transition controlled by the animation controller created by
  /// `createAnimationController()`.
  Animation<Alignment> _createAnimation() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot create a animation from a disposed snackbar');
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller,
        curve: snack.forwardAnimationCurve,
        reverseCurve: snack.reverseAnimationCurve,
      ),
    );
  }

  /// Called to create the animation controller that will drive the transitions
  /// to this route from the previous one, and back to the previous route
  /// from this one.
  AnimationController _createAnimationController() {
    assert(!_transitionCompleter.isCompleted,
        'Cannot create a animationController from a disposed snackbar');
    assert(snack.animationDuration >= Duration.zero);
    return AnimationController(
      duration: snack.animationDuration,
      debugLabel: '$runtimeType',
      vsync: navigator!,
    );
  }

  Animation<double> _createBlurFilterAnimation() {
    return Tween(begin: 0.0, end: snack.overlayBlur).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
  }

  Animation<Color?> _createColorOverlayColor() {
    return ColorTween(begin: const Color(0x00000000), end: snack.overlayColor)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
  }

  Iterable<OverlayEntry> _createOverlayEntries(Widget child) {
    return <OverlayEntry>[
      if (snack.overlayBlur > 0.0) ...[
        OverlayEntry(
          builder: (context) => GestureDetector(
            onTap: () {
              if (snack.isDismissible && !_onTappedDismiss) {
                _onTappedDismiss = true;
                Get.back();
              }
            },
            child: AnimatedBuilder(
              animation: _filterBlurAnimation,
              builder: (context, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: _filterBlurAnimation.value,
                      sigmaY: _filterBlurAnimation.value),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    color: _filterColorAnimation.value,
                  ),
                );
              },
            ),
          ),
          maintainState: false,
          opaque: false,
        ),
      ],
      OverlayEntry(
        builder: (context) => Semantics(
          child: AlignTransition(
            alignment: _animation,
            child: snack.isDismissible
                ? _getDismissibleSnack(child)
                : _getSnackbarContainer(child),
          ),
          focused: false,
          container: true,
          explicitChildNodes: true,
        ),
        maintainState: false,
        opaque: false,
      ),
    ];
  }

  Widget _getBodyWidget() {
    return Builder(builder: (_) {
      return GestureDetector(
        child: snack,
        onTap: snack.onTap != null ? () => snack.onTap?.call(snack) : null,
      );
    });
  }

  DismissDirection _getDefaultDismissDirection() {
    if (snack.snackPosition == SnackPosition.TOP) {
      return DismissDirection.up;
    }
    return DismissDirection.down;
  }

  Widget _getDismissibleSnack(Widget child) {
    return Dismissible(
      direction: snack.dismissDirection ?? _getDefaultDismissDirection(),
      resizeDuration: null,
      confirmDismiss: (_) {
        if (_currentStatus == SnackbarStatus.OPENING ||
            _currentStatus == SnackbarStatus.CLOSING) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      key: const Key('dismissible'),
      onDismissed: (_) {
        _onDismiss();
      },
      child: _getSnackbarContainer(child),
    );
  }

  Widget _getSnackbarContainer(Widget child) {
    return Container(
      margin: snack.margin,
      child: child,
    );
  }

  void _handleStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        _currentStatus = SnackbarStatus.OPEN;
        _snackbarStatus?.call(_currentStatus);
        if (_overlayEntries.isNotEmpty) _overlayEntries.first.opaque = false;

        break;
      case AnimationStatus.forward:
        _currentStatus = SnackbarStatus.OPENING;
        _snackbarStatus?.call(_currentStatus);
        break;
      case AnimationStatus.reverse:
        _currentStatus = SnackbarStatus.CLOSING;
        _snackbarStatus?.call(_currentStatus);
        if (_overlayEntries.isNotEmpty) _overlayEntries.first.opaque = false;
        break;
      case AnimationStatus.dismissed:
        assert(!_overlayEntries.first.opaque);
        _currentStatus = SnackbarStatus.CLOSED;
        _snackbarStatus?.call(_currentStatus);
        _removeOverlay();
        break;
    }
  }

  void _onDismiss() {
    _cancelTimer();
    _wasDismissedBySwipe = true;
    _removeEntry();
  }

  void _removeEntry() {
    assert(
      !_transitionCompleter.isCompleted,
      'Cannot remove entry from a disposed snackbar',
    );

    _cancelTimer();

    if (_wasDismissedBySwipe) {
      Timer(const Duration(milliseconds: 200), _controller.reset);

      _wasDismissedBySwipe = false;
    } else {
      _controller.reverse();
    }
  }

  void _removeOverlay() {
    for (var element in _overlayEntries) {
      element.remove();
    }

    assert(!_transitionCompleter.isCompleted, 'Cannot remove overlay twice.');
    _controller.dispose();
    _overlayEntries.clear();
    _transitionCompleter.complete(this);
  }

  Future<void> _show() {
    _configureOverlay();
    return future;
  }

  static void cancelAllSnackbars() {
    _snackBarQueue.cancelAllJobs();
  }

  static void closeCurrentSnackbar() {
    _snackBarQueue.closeCurrentJob();
  }
}

class _SnackBarQueue {
  final _queue = GetQueue();

  bool _isJobInProgress = false;

  SnackbarController? _currentSnackbar;

  bool get isJobInProgress => _isJobInProgress;

  Future<void> addJob(SnackbarController job) async {
    _isJobInProgress = true;
    _currentSnackbar = job;
    final data = await _queue.add(job._show);
    _isJobInProgress = false;
    _currentSnackbar = null;
    return data;
  }

  void cancelAllJobs() {
    _currentSnackbar?.close();
    _queue.cancelAllJobs();
  }

  void closeCurrentJob() {
    _currentSnackbar?.close();
  }
}

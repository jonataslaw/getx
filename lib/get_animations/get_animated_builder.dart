import 'package:flutter/material.dart';

import 'animations.dart';

class GetAnimatedBuilder<T> extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final Widget child;
  final ValueSetter<AnimationController>? onComplete;
  final ValueSetter<AnimationController>? onStart;
  final Tween<T> tween;
  final T idleValue;
  final ValueWidgetBuilder<T> builder;
  final Curve curve;

  Duration get totalDuration => duration + delay;

  const GetAnimatedBuilder({
    super.key,
    this.curve = Curves.linear,
    this.onComplete,
    this.onStart,
    required this.duration,
    required this.tween,
    required this.idleValue,
    required this.builder,
    required this.child,
    required this.delay,
  });
  @override
  GetAnimatedBuilderState<T> createState() => GetAnimatedBuilderState<T>();
}

class GetAnimatedBuilderState<T> extends State<GetAnimatedBuilder<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<T> _animation;

  // AnimationController get controller => _controller;
  // Animation<T> get animation => _animation;

  bool _wasStarted = false;
  // bool get wasStarted => _wasStarted;

  late T _idleValue;

  bool _willResetOnDispose = false;

  bool get willResetOnDispose => _willResetOnDispose;

  void _listener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        widget.onComplete?.call(_controller);
        if (_willResetOnDispose) {
          _controller.reset();
        }
        break;
      // case AnimationStatus.dismissed:
      case AnimationStatus.forward:
        widget.onStart?.call(_controller);
        break;
      // case AnimationStatus.reverse:
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget is OpacityAnimation) {
      final current =
          context.findRootAncestorStateOfType<GetAnimatedBuilderState>();
      final isLast = current == null;

      if (widget is FadeInAnimation) {
        _idleValue = 1.0 as dynamic;
      } else {
        if (isLast) {
          _willResetOnDispose = false;
        } else {
          _willResetOnDispose = true;
        }
        _idleValue = widget.idleValue;
      }
    } else {
      _idleValue = widget.idleValue;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_listener);

    _animation = widget.tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _wasStarted = true;
          _controller.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _wasStarted ? _animation.value : _idleValue;
        return widget.builder(context, value, child);
      },
      child: widget.child,
    );
  }
}

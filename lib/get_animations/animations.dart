import 'dart:math';

import 'package:flutter/widgets.dart';

import 'get_animated_builder.dart';

class FadeInAnimation extends OpacityAnimation {
  FadeInAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 0,
    super.end = 1,
    super.idleValue = 0,
  });
}

class FadeOutAnimation extends OpacityAnimation {
  FadeOutAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 1,
    super.end = 0,
    super.idleValue = 1,
  });
}

class OpacityAnimation extends GetAnimatedBuilder<double> {
  OpacityAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    required super.onComplete,
    required double begin,
    required double end,
    required super.idleValue,
  }) : super(
          tween: Tween<double>(begin: begin, end: end),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child!,
            );
          },
        );
}

class RotateAnimation extends GetAnimatedBuilder<double> {
  RotateAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.rotate(
            angle: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class ScaleAnimation extends GetAnimatedBuilder<double> {
  ScaleAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SlideAnimation extends GetAnimatedBuilder<Offset> {
  SlideAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required Offset begin,
    required Offset end,
    super.idleValue = const Offset(0, 0),
  }) : super(
          builder: (context, value, child) => Transform.translate(
            offset: value,
            child: child,
          ),
          tween: Tween(begin: begin, end: end),
        );
}

class BounceAnimation extends GetAnimatedBuilder<double> {
  BounceAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.curve = Curves.bounceOut,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.scale(
            scale: 1 + value.abs(),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class ShakeAnimation extends GetAnimatedBuilder<double> {
  ShakeAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.rotate(
            angle: value * pi / 180.0,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SpinAnimation extends GetAnimatedBuilder<double> {
  SpinAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.rotate(
            angle: value * pi / 180.0,
            child: child,
          ),
          tween: Tween<double>(begin: 0, end: 360),
        );
}

class ColorAnimation extends GetAnimatedBuilder<Color?> {
  ColorAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required Color begin,
    required Color end,
    Color? idleColor,
  }) : super(
          builder: (context, value, child) => ColorFiltered(
            colorFilter: ColorFilter.mode(
              Color.lerp(begin, end, value!.value.toDouble())!,
              BlendMode.srcIn,
            ),
            child: child,
          ),
          idleValue: idleColor ?? begin,
          tween: ColorTween(begin: begin, end: end),
        );
}

class SizeAnimation extends GetAnimatedBuilder<double> {
  SizeAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
    required double begin,
    required double end,
  }) : super(
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

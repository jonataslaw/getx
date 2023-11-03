import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'get_animated_builder.dart';

typedef OffsetBuilder = Offset Function(BuildContext, double);

class FadeInAnimation extends OpacityAnimation {
  FadeInAnimation({
    required super.duration, required super.delay, required super.child, super.key,
    super.onComplete,
    super.begin = 0,
    super.end = 1,
    super.idleValue = 0,
  });
}

class FadeOutAnimation extends OpacityAnimation {
  FadeOutAnimation({
    required super.duration, required super.delay, required super.child, super.key,
    super.onComplete,
    super.begin = 1,
    super.end = 0,
    super.idleValue = 1,
  });
}

class OpacityAnimation extends GetAnimatedBuilder<double> {
  OpacityAnimation({
    required super.duration, required super.delay, required super.child, required super.onComplete, required final double begin, required final double end, required super.idleValue, super.key,
  }) : super(
          tween: Tween<double>(begin: begin, end: end),
          builder: (final context, final value, final child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
        );
}

class RotateAnimation extends GetAnimatedBuilder<double> {
  RotateAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.rotate(
            angle: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class ScaleAnimation extends GetAnimatedBuilder<double> {
  ScaleAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.scale(
            scale: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

// class SlideAnimation extends GetAnimatedBuilder<Offset> {
//   SlideAnimation({
//     super.key,
//     required super.duration,
//     required super.delay,
//     required super.child,
//     super.onComplete,
//     required Offset begin,
//     required Offset end,
//     super.idleValue = const Offset(0, 0),
//   }) : super(
//           builder: (context, value, child) => Transform.translate(
//             offset: value,
//             child: child,
//           ),
//           tween: Tween(begin: begin, end: end),
//         );
// }

class BounceAnimation extends GetAnimatedBuilder<double> {
  BounceAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.curve = Curves.bounceOut,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.scale(
            scale: 1 + value.abs(),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SpinAnimation extends GetAnimatedBuilder<double> {
  SpinAnimation({
    required super.duration, required super.delay, required super.child, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.rotate(
            angle: value * pi / 180.0,
            child: child,
          ),
          tween: Tween<double>(begin: 0, end: 360),
        );
}

class SizeAnimation extends GetAnimatedBuilder<double> {
  SizeAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.scale(
            scale: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class BlurAnimation extends GetAnimatedBuilder<double> {
  BlurAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: value,
              sigmaY: value,
            ),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class FlipAnimation extends GetAnimatedBuilder<double> {
  FlipAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) {
            final radians = value * pi;
            return Transform(
              transform: Matrix4.rotationY(radians),
              alignment: Alignment.center,
              child: child,
            );
          },
          tween: Tween<double>(begin: begin, end: end),
        );
}

class WaveAnimation extends GetAnimatedBuilder<double> {
  WaveAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform(
            transform: Matrix4.translationValues(
              0.0,
              20.0 * sin(value * pi * 2),
              0.0,
            ),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class WobbleAnimation extends GetAnimatedBuilder<double> {
  WobbleAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateZ(sin(value * pi * 2) * 0.1),
            alignment: Alignment.center,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SlideInLeftAnimation extends SlideAnimation {
  SlideInLeftAnimation({
    required super.duration, required super.delay, required super.child, required super.begin, required super.end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (final context, final value) =>
              Offset(value * MediaQuery.of(context).size.width, 0),
        );
}

class SlideInRightAnimation extends SlideAnimation {
  SlideInRightAnimation({
    required super.duration, required super.delay, required super.child, required super.begin, required super.end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (final context, final value) =>
              Offset((1 - value) * MediaQuery.of(context).size.width, 0),
        );
}

class SlideInUpAnimation extends SlideAnimation {
  SlideInUpAnimation({
    required super.duration, required super.delay, required super.child, required super.begin, required super.end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (final context, final value) =>
              Offset(0, value * MediaQuery.of(context).size.height),
        );
}

class SlideInDownAnimation extends SlideAnimation {
  SlideInDownAnimation({
    required super.duration, required super.delay, required super.child, required super.begin, required super.end, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (final context, final value) =>
              Offset(0, (1 - value) * MediaQuery.of(context).size.height),
        );
}

class SlideAnimation extends GetAnimatedBuilder<double> {
  SlideAnimation({
    required super.duration, required super.delay, required super.child, required final double begin, required final double end, required final OffsetBuilder offsetBuild, super.key,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (final context, final value, final child) => Transform.translate(
            offset: offsetBuild(context, value),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

// class ZoomAnimation extends GetAnimatedBuilder<double> {
//   ZoomAnimation({
//     super.key,
//     required super.duration,
//     required super.delay,
//     required super.child,
//     super.onComplete,
//     required double begin,
//     required double end,
//     super.idleValue = 0,
//   }) : super(
//           builder: (context, value, child) => Transform.scale(
//             scale: lerpDouble(1, end, value)!,
//             child: child,
//           ),
//           tween: Tween<double>(begin: begin, end: end),
//         );
// }

class ColorAnimation extends GetAnimatedBuilder<Color?> {
  ColorAnimation({
    required super.duration, required super.delay, required super.child, required final Color begin, required final Color end, super.key,
    super.onComplete,
    final Color? idleColor,
  }) : super(
          builder: (final context, final value, final child) => ColorFiltered(
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

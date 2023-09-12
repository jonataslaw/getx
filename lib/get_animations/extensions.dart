import 'package:flutter/material.dart';

import 'animations.dart';
import 'get_animated_builder.dart';

const Duration _defaultDuration = Duration(seconds: 2);
const Duration _defaultDelay = Duration.zero;

extension AnimationExtension<T> on Widget {
  GetAnimatedBuilder<T>? get _currentAnimation =>
      (this is GetAnimatedBuilder<T>) ? this as GetAnimatedBuilder<T> : null;

  FadeInAnimation fadeIn({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeOutAnimation,
        'Can not use fadeOut + fadeIn when isSequential is false');

    return FadeInAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  FadeOutAnimation fadeOut({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeInAnimation,
        'Can not use fadeOut() + fadeIn when isSequential is false');

    return FadeOutAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  RotateAnimation rotate({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return RotateAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  ScaleAnimation scale({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return ScaleAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  SlideAnimation slide({
    required OffsetBuilder offset,
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SlideAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      offsetBuild: offset,
      child: this,
    );
  }

  BounceAnimation bounce({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BounceAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  SpinAnimation spin({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SpinAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  SizeAnimation size({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SizeAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  BlurAnimation blur({
    double begin = 0,
    double end = 15,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BlurAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  FlipAnimation flip({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return FlipAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  WaveAnimation wave({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return WaveAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  Duration _getDelay(bool isSequential, Duration delay) {
    assert(!(isSequential && delay != Duration.zero),
        'Error: When isSequential is true, delay must be non-zero. Context: isSequential: $isSequential delay: $delay');

    return isSequential
        ? (_currentAnimation?.totalDuration ?? Duration.zero)
        : delay;
  }
}

import 'package:flutter/material.dart';

import 'animations.dart';
import 'get_animated_builder.dart';

const Duration _defaultDuration = Duration(seconds: 2);
const Duration _defaultDelay = Duration.zero;

extension AnimationExtension on Widget {
  GetAnimatedBuilder? get _currentAnimation =>
      (this is GetAnimatedBuilder) ? this as GetAnimatedBuilder : null;

  GetAnimatedBuilder fadeIn({
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder fadeOut({
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder rotate({
    required final double begin,
    required final double end,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder scale({
    required final double begin,
    required final double end,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder slide({
    required final OffsetBuilder offset,
    final double begin = 0,
    final double end = 1,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder bounce({
    required final double begin,
    required final double end,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder spin({
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
  }) {
    return SpinAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder size({
    required final double begin,
    required final double end,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder blur({
    final double begin = 0,
    final double end = 15,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder flip({
    final double begin = 0,
    final double end = 1,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  GetAnimatedBuilder wave({
    final double begin = 0,
    final double end = 1,
    final Duration duration = _defaultDuration,
    final Duration delay = _defaultDelay,
    final ValueSetter<AnimationController>? onComplete,
    final bool isSequential = false,
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

  Duration _getDelay(final bool isSequential, final Duration delay) {
    assert(!(isSequential && delay != Duration.zero),
        'Error: When isSequential is true, delay must be non-zero. Context: isSequential: $isSequential delay: $delay');

    return isSequential
        ? (_currentAnimation?.totalDuration ?? Duration.zero)
        : delay;
  }
}

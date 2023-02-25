import 'package:flutter/material.dart';

import 'animations.dart';
import 'get_animated_builder.dart';

const _defaultDuration = Duration(seconds: 2);
const _defaultDelay = Duration.zero;

extension AnimationExtension on Widget {
  GetAnimatedBuilder? get _currentAnimation =>
      (this is GetAnimatedBuilder) ? this as GetAnimatedBuilder : null;

  GetAnimatedBuilder fadeIn({
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

  GetAnimatedBuilder fadeOut({
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

  GetAnimatedBuilder rotate({
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

  GetAnimatedBuilder scale({
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

  GetAnimatedBuilder slide({
    required Offset begin,
    required Offset end,
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
      child: this,
    );
  }

  GetAnimatedBuilder bounce({
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

  GetAnimatedBuilder shake({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return ShakeAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder spin({
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

  GetAnimatedBuilder size({
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

  Duration _getDelay(bool isSequential, Duration delay) {
    assert(!(isSequential && delay != Duration.zero),
        "Error: When isSequential is true, delay must be non-zero. Context: isSequential: $isSequential delay: $delay");

    return isSequential
        ? (_currentAnimation?.totalDuration ?? Duration.zero)
        : delay;
  }
}

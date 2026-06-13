import 'dart:math';

extension DoubleExt on double {
  double toPrecision(int fractionDigits) {
    if (fractionDigits < 0) {
      throw RangeError('fractionDigits must be non-negative: $fractionDigits');
    }
    if (isNaN || isInfinite) {
      return this;
    }

    var factor = pow(10, fractionDigits.toDouble()).toDouble();
    return ((this * factor).round().toDouble() / factor);
  }

  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  Duration get ms => milliseconds;

  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}

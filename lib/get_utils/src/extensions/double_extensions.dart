import 'dart:math';

/// An extension on [double] providing utility methods for working with double-precision numbers.
extension DoubleExt on double {
  /// Rounds the double value to a specified number of decimal places (fractional digits).
  ///
  /// This method is useful when you want to limit the precision of a double value.
  ///
  /// Example usage:
  /// ```dart
  /// final value = 3.14159265359;
  /// final roundedValue = value.toPrecision(2); // Result: 3.14
  /// ```
  double toPrecision(int fractionDigits) {
    final double mod = pow(10, fractionDigits.toDouble()).toDouble();
    return (this * mod).round().toDouble() / mod;
  }

  /// Converts the double value to a [Duration] representing milliseconds.
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  /// An alias for [milliseconds], representing milliseconds as a [Duration].
  Duration get ms => milliseconds;

  /// Converts the double value to a [Duration] representing seconds.
  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  /// Converts the double value to a [Duration] representing minutes.
  Duration get minutes =>
      Duration(seconds: (this * Duration.secondsPerMinute).round());

  /// Converts the double value to a [Duration] representing hours.
  Duration get hours =>
      Duration(minutes: (this * Duration.minutesPerHour).round());

  /// Converts the double value to a [Duration] representing days.
  Duration get days => Duration(hours: (this * Duration.hoursPerDay).round());
}

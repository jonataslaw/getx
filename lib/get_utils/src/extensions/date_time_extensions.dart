import 'package:flutter/material.dart';

extension GetDateTimeExtensions on DateTime {
  /// Add Duration to DateTime
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts Duration from DateTime
  DateTime operator -(Duration duration) => subtract(duration);

  /// return time of day is before or after noon.
  DayPeriod get period => TimeOfDay.fromDateTime(this).period;

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return isUtc
        ? DateTime.utc(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          )
        : DateTime(
            year ?? this.year,
            month ?? this.month,
            day ?? this.day,
            hour ?? this.hour,
            minute ?? this.minute,
            second ?? this.second,
            millisecond ?? this.millisecond,
            microsecond ?? this.microsecond,
          );
  }
}

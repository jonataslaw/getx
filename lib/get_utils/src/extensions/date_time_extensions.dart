import 'package:flutter/material.dart';

extension GetDateTimeExtensions on DateTime {
  /// Add Duration to DateTime
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts Duration from DateTime
  DateTime operator -(Duration duration) => subtract(duration);

  /// return time of day is before or after noon.
  DayPeriod get period => TimeOfDay.fromDateTime(this).period;


}

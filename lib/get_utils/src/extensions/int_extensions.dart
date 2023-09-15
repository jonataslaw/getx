/// An extension on [int] to simplify creating [Duration] objects based on various time units.
extension DurationExt on int {
  /// Creates a [Duration] object representing the given number of seconds.
  Duration get seconds => Duration(seconds: this);

  /// Creates a [Duration] object representing the given number of days.
  Duration get days => Duration(days: this);

  /// Creates a [Duration] object representing the given number of hours.
  Duration get hours => Duration(hours: this);

  /// Creates a [Duration] object representing the given number of minutes.
  Duration get minutes => Duration(minutes: this);

  /// Creates a [Duration] object representing the given number of milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Creates a [Duration] object representing the given number of microseconds.
  Duration get microseconds => Duration(microseconds: this);

  /// Creates a [Duration] object representing the given number of milliseconds
  /// (an alias for [milliseconds]).
  Duration get ms => milliseconds;
}

extension GetDateTimeExtensions on DateTime {
  /// Add Duration to DateTime
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts Duration from DateTime
  DateTime operator -(Duration duration) => subtract(duration);
}

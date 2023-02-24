import 'package:flutter/material.dart';

extension GetDateTimeExtensionsOnInt on int {
  DateTime get fromUnixTimeStamp {
    return GetTimestamp.fromSecondsSinceEpoch(this).toDate();
  }
}

extension GetDateTimeExtensions on DateTime {
  /// Add Duration to DateTime
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts Duration from DateTime
  DateTime operator -(Duration duration) => subtract(duration);

  /// return time of day is before or after noon.
  DayPeriod get period => TimeOfDay.fromDateTime(this).period;

  /// return year is Leap Year
  bool get isLeapYear {
    // Leap years started from 1582.
    return (year % 4 == 0) &&
        (year % 100 != 0 || year % 400 == 0) &&
        (year >= 1582);
  }

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
    return isUtc == true
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

  /// convert DateTime to Unix Timestamp
  int get unixTimeStamp => GetTimestamp.fromDate(this).seconds;

  bool get isToday {
    return _dateDiffInDayFromNow(this) == 0;
  }

  bool get willTomorrow {
    return _dateDiffInDayFromNow(this) == 1;
  }

  bool get wasYesterday {
    return _dateDiffInDayFromNow(this) == -1;
  }

  int _dateDiffInDayFromNow(DateTime d) {
    var now = DateTime.now();
    return DateTime(d.year, d.month, d.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  DateTime get previousWeek {
    return subtract(Duration(days: 7));
  }

  DateTime get nextWeek {
    return add(Duration(days: 7));
  }

  String get weekDayName {
    var _dayNameMap = <int, String>{
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    return _dayNameMap[weekday]!;
  }

  int get daysInMonth {
    final monthDays = <int, int>{
      1: 31, // January
      2: isLeapYear ? 29 : 28, // February
      3: 31, // March
      4: 30, // April
      5: 31, // May
      6: 30, // June
      7: 31, // July
      8: 31, // August
      9: 30, // September
      10: 31, // October
      11: 30, // November
      12: 31, // December
    };
    return monthDays[month]!;
  }
}

///[GetTimestamp] borrowed from firestore cloud store
const int _kThousand = 1000;
const int _kMillion = 1000000;
const int _kBillion = 1000000000;

void _check(bool expr, String name, int value) {
  if (!expr) {
    throw ArgumentError('Timestamp $name out of range: $value');
  }
}

/// A Timestamp represents a point in time independent of any time zone or calendar,
/// represented as seconds and fractions of seconds at nanosecond resolution in UTC
/// Epoch time. It is encoded using the Proleptic Gregorian Calendar which extends
/// the Gregorian calendar backwards to year one. It is encoded assuming all minutes
/// are 60 seconds long, i.e. leap seconds are "smeared" so that no leap second table
/// is needed for interpretation. Range is from 0001-01-01T00:00:00Z to
/// 9999-12-31T23:59:59.999999999Z. By restricting to that range, we ensure that we
/// can convert to and from RFC 3339 date strings.
///
/// For more information, see [the reference timestamp definition](https://github.com/google/protobuf/blob/master/src/google/protobuf/timestamp.proto)
@immutable
class GetTimestamp implements Comparable<GetTimestamp> {
  /// Creates a [GetTimestamp]
  GetTimestamp(this._seconds, this._nanoseconds) {
    _validateRange(_seconds, _nanoseconds);
  }

  /// Create a [GetTimestamp] fromSecondsSinceEpoch
  factory GetTimestamp.fromSecondsSinceEpoch(int seconds) {
    return GetTimestamp.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  /// Create a [GetTimestamp] fromMillisecondsSinceEpoch
  factory GetTimestamp.fromMillisecondsSinceEpoch(int milliseconds) {
    var seconds = (milliseconds / _kThousand).floor();
    final nanoseconds = (milliseconds - seconds * _kThousand) * _kMillion;
    return GetTimestamp(seconds, nanoseconds);
  }

  /// Create a [GetTimestamp] fromMicrosecondsSinceEpoch
  factory GetTimestamp.fromMicrosecondsSinceEpoch(int microseconds) {
    final seconds = microseconds ~/ _kMillion;
    final nanoseconds = (microseconds - seconds * _kMillion) * _kThousand;
    return GetTimestamp(seconds, nanoseconds);
  }

  /// Create a [GetTimestamp] from [DateTime] instance
  factory GetTimestamp.fromDate(DateTime date) {
    return GetTimestamp.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
  }

  /// Create a [GetTimestamp] from [DateTime].now()
  factory GetTimestamp.now() {
    return GetTimestamp.fromMicrosecondsSinceEpoch(
      DateTime.now().microsecondsSinceEpoch,
    );
  }

  final int _seconds;
  final int _nanoseconds;

  static const int _kStartOfTime = -62135596800;
  static const int _kEndOfTime = 253402300800;

  // ignore: public_member_api_docs
  int get seconds => _seconds;

  // ignore: public_member_api_docs
  int get nanoseconds => _nanoseconds;

  // ignore: public_member_api_docs
  int get millisecondsSinceEpoch =>
      seconds * _kThousand + nanoseconds ~/ _kMillion;

  // ignore: public_member_api_docs
  int get microsecondsSinceEpoch =>
      seconds * _kMillion + nanoseconds ~/ _kThousand;

  /// Converts [GetTimestamp] to [DateTime]
  DateTime toDate() {
    return DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
  }

  @override
  int get hashCode => Object.hash(seconds, nanoseconds);

  @override
  bool operator ==(Object other) =>
      other is GetTimestamp &&
      other.seconds == seconds &&
      other.nanoseconds == nanoseconds;

  @override
  int compareTo(GetTimestamp other) {
    if (seconds == other.seconds) {
      return nanoseconds.compareTo(other.nanoseconds);
    }

    return seconds.compareTo(other.seconds);
  }

  @override
  String toString() {
    return 'Timestamp(seconds=$seconds, nanoseconds=$nanoseconds)';
  }

  static void _validateRange(int seconds, int nanoseconds) {
    _check(nanoseconds >= 0, 'nanoseconds', nanoseconds);
    _check(nanoseconds < _kBillion, 'nanoseconds', nanoseconds);
    _check(seconds >= _kStartOfTime, 'seconds', seconds);
    _check(seconds < _kEndOfTime, 'seconds', seconds);
  }
}

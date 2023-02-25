import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('DurationExt', () {
    test('seconds', () {
      expect(1.seconds, equals(Duration(seconds: 1)));
      expect(2.5.seconds, equals(Duration(seconds: 2, milliseconds: 500)));
      expect((-1).seconds, equals(Duration(seconds: -1)));
    });

    test('days', () {
      expect(1.days, equals(Duration(days: 1)));
      expect((-1).days, equals(Duration(days: -1)));
    });

    test('hours', () {
      expect(1.hours, equals(Duration(hours: 1)));
      expect((-1).hours, equals(Duration(hours: -1)));
    });

    test('minutes', () {
      expect(1.minutes, equals(Duration(minutes: 1)));
      expect((-1).minutes, equals(Duration(minutes: -1)));
    });

    test('milliseconds', () {
      expect(1.milliseconds, equals(Duration(milliseconds: 1)));
      expect((-1).milliseconds, equals(Duration(milliseconds: -1)));
    });

    test('microseconds', () {
      expect(1.microseconds, equals(Duration(microseconds: 1)));
      expect((-1).microseconds, equals(Duration(microseconds: -1)));
    });

    test('ms', () {
      expect(1.ms, equals(Duration(milliseconds: 1)));
      expect((-1).ms, equals(Duration(milliseconds: -1)));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  group('DoubleExt', () {
    test('toPrecision', () {
      expect(3.14159.toPrecision(2), equals(3.14));
      expect(3.14159.toPrecision(4), equals(3.1416));
      expect(1.0.toPrecision(0), equals(1.0));
      expect(123456789.123456789.toPrecision(4), equals(123456789.1235));
      expect((-3.14159).toPrecision(2), equals(-3.14));
    });

    test('milliseconds', () {
      expect(1000.0.ms, equals(Duration(milliseconds: 1000)));
      expect(1.5.ms, equals(Duration(milliseconds: 1, microseconds: 500)));
      expect((-2000.0).ms, equals(Duration(milliseconds: -2000)));
    });

    test('seconds', () {
      expect(60.0.seconds, equals(Duration(seconds: 60)));
      expect(1.5.seconds, equals(Duration(milliseconds: 1500)));
      expect((-120.0).seconds, equals(Duration(seconds: -120)));
    });

    test('minutes', () {
      expect(2.5.minutes, equals(Duration(minutes: 2, seconds: 30)));
      expect(1.2.minutes, equals(Duration(seconds: 72)));
      expect((-3.0).minutes, equals(Duration(minutes: -3)));
    });

    test('hours', () {
      expect(1.5.hours, equals(Duration(hours: 1, minutes: 30)));
      expect(0.25.hours, equals(Duration(minutes: 15)));
      expect((-2.0).hours, equals(Duration(hours: -2)));
    });

    test('days', () {
      expect(1.5.days, equals(Duration(days: 1, hours: 12)));
      expect(0.25.days, equals(Duration(hours: 6)));
      expect((-3.0).days, equals(Duration(days: -3)));
    });
  });
}

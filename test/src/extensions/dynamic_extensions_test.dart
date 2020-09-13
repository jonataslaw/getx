import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test group for extension: isNullOrBlank', () {
    dynamic testString;
    test('String extension: isNullOrBlank', () {
      expect(testString.isNullOrBlank, equals(true));
    });
    test('String extension: isNullOrBlank', () {
      testString = 'Not null anymore';
      expect(testString.isNullOrBlank, equals(false));
    });
    test('String extension: isNullOrBlank', () {
      testString = '';
      expect(testString.isNullOrBlank, equals(true));
    });
  });
}

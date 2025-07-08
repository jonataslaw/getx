import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('IterableExt', () {
    test('firstWhereOrNull', () {
      expect([1, 2, 3].firstWhereOrNull((e) => e == 1), equals(1));
      expect([1, 2, 3].firstWhereOrNull((e) => e == 4), equals(null));
    });
  });
}

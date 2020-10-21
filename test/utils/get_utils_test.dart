import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// Identity util to convert to iterables
dynamic _id(dynamic e) => e;

void main() {
  // Tests for GetUtils.isNullOrBlank are located at dynamic extensions
  group('GetUtils.isLength* functions', () {
    test('isLengthEqualTo should validate iterable lengths', () {
      // iterables should cover list and set
      expect(GetUtils.isLengthEqualTo([].map(_id), 0), true);
      expect(GetUtils.isLengthEqualTo([1, 2].map(_id), 2), true);

      expect(GetUtils.isLengthEqualTo({}, 0), true);
      expect(GetUtils.isLengthEqualTo({1: 1, 2: 1}, 2), true);
      expect(GetUtils.isLengthEqualTo({}, 2), false);

      expect(GetUtils.isLengthEqualTo("", 0), true);
      expect(GetUtils.isLengthEqualTo("a", 0), false);
      expect(GetUtils.isLengthEqualTo("a", 1), true);
    });

    test('isLengthGreaterOrEqual should validate lengths', () {
      // iterables should cover list and set
      expect(GetUtils.isLengthGreaterOrEqual([].map(_id), 0), true);
      expect(GetUtils.isLengthGreaterOrEqual([1, 2].map(_id), 2), true);
      expect(GetUtils.isLengthGreaterOrEqual([1, 2].map(_id), 1), true);

      expect(GetUtils.isLengthGreaterOrEqual({}, 0), true);
      expect(GetUtils.isLengthGreaterOrEqual({1: 1, 2: 1}, 1), true);
      expect(GetUtils.isLengthGreaterOrEqual({1: 1, 2: 1}, 2), true);
      expect(GetUtils.isLengthGreaterOrEqual({}, 2), false);

      expect(GetUtils.isLengthGreaterOrEqual("", 0), true);
      expect(GetUtils.isLengthGreaterOrEqual("a", 0), true);
      expect(GetUtils.isLengthGreaterOrEqual("", 1), false);
    });

    test('isLengthLessOrEqual should validate lengths', () {
      // iterables should cover list and set
      expect(GetUtils.isLengthLessOrEqual([].map(_id), 0), true);
      expect(GetUtils.isLengthLessOrEqual([1, 2].map(_id), 2), true);
      expect(GetUtils.isLengthLessOrEqual([1, 2].map(_id), 1), false);

      expect(GetUtils.isLengthLessOrEqual({}, 0), true);
      expect(GetUtils.isLengthLessOrEqual({1: 1, 2: 1}, 1), false);
      expect(GetUtils.isLengthLessOrEqual({1: 1, 2: 1}, 3), true);
      expect(GetUtils.isLengthLessOrEqual({}, 2), true);

      expect(GetUtils.isLengthLessOrEqual("", 0), true);
      expect(GetUtils.isLengthLessOrEqual("a", 2), true);
      expect(GetUtils.isLengthLessOrEqual("a", 0), false);
    });
  });
}

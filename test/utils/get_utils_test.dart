import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class TestClass {
  final name = "John";
}

class EmptyClass {}

void main() {
  dynamic _id(dynamic e) => e;

  test('null isNullOrBlank should be true for null', () {
    expect(GetUtils.isNullOrBlank(null), true);
  });

  test('isNullOrBlank should be false for unsupported types', () {
    expect(GetUtils.isNullOrBlank(5), false);
    expect(GetUtils.isNullOrBlank(0), false);

    expect(GetUtils.isNullOrBlank(5.0), equals(false));
    expect(GetUtils.isNullOrBlank(0.0), equals(false));

    TestClass? testClass;
    expect(GetUtils.isNullOrBlank(testClass), equals(true));
    expect(GetUtils.isNullOrBlank(TestClass()), equals(false));
    expect(GetUtils.isNullOrBlank(EmptyClass()), equals(false));
  });

  test('isNullOrBlank should validate strings', () {
    expect(GetUtils.isNullOrBlank(""), true);
    expect(GetUtils.isNullOrBlank("  "), true);

    expect(GetUtils.isNullOrBlank("foo"), false);
    expect(GetUtils.isNullOrBlank(" foo "), false);

    expect(GetUtils.isNullOrBlank("null"), false);
  });

  test('isNullOrBlank should validate iterables', () {
    expect(GetUtils.isNullOrBlank([].map(_id)), true);
    expect(GetUtils.isNullOrBlank([1].map(_id)), false);
  });

  test('isNullOrBlank should validate lists', () {
    expect(GetUtils.isNullOrBlank(const []), true);
    expect(GetUtils.isNullOrBlank(['oi', 'foo']), false);
    expect(GetUtils.isNullOrBlank([{}, {}]), false);
    expect(GetUtils.isNullOrBlank(['foo'][0]), false);
  });

  test('isNullOrBlank should validate sets', () {
    expect(GetUtils.isNullOrBlank(<dynamic>{}), true);
    expect(GetUtils.isNullOrBlank({1}), false);
    expect(GetUtils.isNullOrBlank({'fluorine', 'chlorine', 'bromine'}), false);
  });

  test('isNullOrBlank should validate maps', () {
    expect(GetUtils.isNullOrBlank({}), true);
    expect(GetUtils.isNullOrBlank({1: 1}), false);
    expect(GetUtils.isNullOrBlank({"other": "thing"}), false);

    final map = {"foo": 'bar', "one": "um"};
    expect(GetUtils.isNullOrBlank(map["foo"]), false);
    expect(GetUtils.isNullOrBlank(map["other"]), true);
  });
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

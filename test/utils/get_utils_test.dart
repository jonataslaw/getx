import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class TestClass {
  final name = "John";
}

class EmptyClass {}

void main() {
  dynamic newId(dynamic e) => e;

  group('GetUtils.isImage', () {
    test('recognizes every capitalization of the WebP extension', () {
      for (var mask = 0; mask < 16; mask++) {
        const letters = 'webp';
        final extension = List.generate(letters.length, (index) {
          final letter = letters[index];
          return mask & (1 << index) == 0 ? letter : letter.toUpperCase();
        }).join();
        final path = 'photo.$extension';
        expect(GetUtils.isImage(path), isTrue, reason: path);
      }
    });

    test('recognizes WebP at the end of file names and paths', () {
      for (final path in [
        'photo.webp',
        '.webp',
        'photo.preview.webp',
        'my photo.webp',
        '/images/photo.webp',
        r'C:\images\photo.webp',
        'images/عکس.webp',
        'https://example.com/images/photo.webp',
      ]) {
        expect(GetUtils.isImage(path), isTrue, reason: path);
      }
    });

    test('preserves support for existing image extensions', () {
      for (final extension in ['jpg', 'jpeg', 'png', 'gif', 'bmp']) {
        for (final variant in [extension, extension.toUpperCase()]) {
          final path = 'photo.$variant';
          expect(GetUtils.isImage(path), isTrue, reason: path);
        }
      }
    });

    test('requires a supported extension at the end of the string', () {
      for (final path in [
        '',
        'photo',
        'webp',
        'photowebp',
        'photo.webp2',
        'photo.webp.exe',
        '/images.webp/photo',
        'photo.webp ',
        'photo.webp\n',
        'photo.webp?size=100',
        'photo.webp#preview',
        'photo.svg',
        'photo.avif',
        'photo.txt',
      ]) {
        expect(GetUtils.isImage(path), isFalse, reason: path);
      }
    });
  });

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
    expect(GetUtils.isNullOrBlank([].map(newId)), true);
    expect(GetUtils.isNullOrBlank([1].map(newId)), false);
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
      expect(GetUtils.isLengthEqualTo([].map(newId), 0), true);
      expect(GetUtils.isLengthEqualTo([1, 2].map(newId), 2), true);

      expect(GetUtils.isLengthEqualTo({}, 0), true);
      expect(GetUtils.isLengthEqualTo({1: 1, 2: 1}, 2), true);
      expect(GetUtils.isLengthEqualTo({}, 2), false);

      expect(GetUtils.isLengthEqualTo("", 0), true);
      expect(GetUtils.isLengthEqualTo("a", 0), false);
      expect(GetUtils.isLengthEqualTo("a", 1), true);
    });

    test('isLengthGreaterOrEqual should validate lengths', () {
      // iterables should cover list and set
      expect(GetUtils.isLengthGreaterOrEqual([].map(newId), 0), true);
      expect(GetUtils.isLengthGreaterOrEqual([1, 2].map(newId), 2), true);
      expect(GetUtils.isLengthGreaterOrEqual([1, 2].map(newId), 1), true);

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
      expect(GetUtils.isLengthLessOrEqual([].map(newId), 0), true);
      expect(GetUtils.isLengthLessOrEqual([1, 2].map(newId), 2), true);
      expect(GetUtils.isLengthLessOrEqual([1, 2].map(newId), 1), false);

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

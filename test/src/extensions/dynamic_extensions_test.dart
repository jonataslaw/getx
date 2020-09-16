import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

class TestClass {
  final name = "John";
}

class EmptyClass {}

void main() {
  group('isNullOrBlank on dynamic', () {
    // Identity util to convert to iterables
    dynamic _id(dynamic e) => e;

    test('null isNullOrBlank should be true for null', () {
      expect((null).isNullOrBlank, true);
    });

    test('isNullOrBlank should be false for unsupported types', () {
      expect(5.isNullOrBlank, false);
      expect(0.isNullOrBlank, false);

      expect(5.0.isNullOrBlank, equals(false));
      expect(0.0.isNullOrBlank, equals(false));

      TestClass testClass;
      expect(testClass.isNullOrBlank, equals(true));
      expect(TestClass().isNullOrBlank, equals(false));
      expect(EmptyClass().isNullOrBlank, equals(false));
    });

    test('isNullOrBlank should validate strings', () {
      expect("".isNullOrBlank, true);
      expect("  ".isNullOrBlank, true);

      expect("foo".isNullOrBlank, false);
      expect(" foo ".isNullOrBlank, false);

      expect("null".isNullOrBlank, false);
    });

    test('isNullOrBlank should validate iterables', () {
      expect([].map(_id).isNullOrBlank, true);
      expect([1].map(_id).isNullOrBlank, false);
    });

    test('isNullOrBlank should validate lists', () {
      expect([].isNullOrBlank, true);
      expect(['oi', 'foo'].isNullOrBlank, false);
      expect([{}, {}].isNullOrBlank, false);
      expect(['foo'][0].isNullOrBlank, false);
    });

    test('isNullOrBlank should validate sets', () {
      expect((<dynamic>{}).isNullOrBlank, true);
      expect(({1}).isNullOrBlank, false);
      expect({'fluorine', 'chlorine', 'bromine'}.isNullOrBlank, false);
    });

    test('isNullOrBlank should validate maps', () {
      expect(({}).isNullOrBlank, true);
      expect(({1: 1}).isNullOrBlank, false);
      expect({"other": "thing"}.isNullOrBlank, false);

      final map = {"foo": 'bar', "one": "um"};
      expect(map["foo"].isNullOrBlank, false);
      expect(map["other"].isNullOrBlank, true);
    });
  });

  test('String test', () {
    var value = 'string';
    var expected = '';
    void logFunction(String prefix, dynamic value, String info,
        {bool isError = false}) {
      print('algo');
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: String string');
  });
  test('Int test', () {
    var value = 1;
    var expected = '';
    void logFunction(String prefix, dynamic value, String info,
        {bool isError = false}) {
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: int 1');
  });
  test('Double test', () {
    var value = 1.0;
    var expected = '';
    void logFunction(String prefix, dynamic value, String info,
        {bool isError = false}) {
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: double 1.0');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

class TestClass {
  final name = "John";
}

class EmptyClass {}

void main() {
  group('dynamic extensions', () {
    test('var.isNullOrBlank on a string ', () {
      var string = '';
      expect('foo'.isNullOrBlank, equals(false));
      expect(string.isNullOrBlank, equals(true));
    });
    test('var.isNullOrBlank on a int ', () {
      expect(5.isNullOrBlank, equals(false));
      expect(0.isNullOrBlank, equals(false));
    });

    test('var.isNullOrBlank on a double ', () {
      expect(5.0.isNullOrBlank, equals(false));
      expect(0.0.isNullOrBlank, equals(false));
    });

    test('var.isNullOrBlank on a list ', () {
      var list = ['foo'];
      expect([].isNullOrBlank, equals(true));
      expect(['oi', 'foo'].isNullOrBlank, equals(false));
      expect([{}, {}].isNullOrBlank, equals(false));
      expect(list[0].isNullOrBlank, equals(false));
    });

    test('var.isNullOrBlank on a set ', () {
      var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
      expect(<String>{}.isNullOrBlank, equals(true));
      expect({'foo', 'bar'}.isNullOrBlank, equals(false));
      expect(halogens.isNullOrBlank, equals(false));
    });

    test('var.isNullOrBlank on a map ', () {
      var map = {"foo": 'bar', "one": "um"};
      expect({}.isNullOrBlank, equals(true));
      expect({"other": "thing"}.isNullOrBlank, equals(false));
      expect({'first': [], 'second': []}.isNullOrBlank, equals(false));
      expect(map["foo"].isNullOrBlank, equals(false));
      expect(map["other"].isNullOrBlank, equals(true));
    });

    test('var.isNullOrBlank on a function ', () {
      someFunction({String string, int integer}) {
        expect(string.isNullOrBlank, equals(false));
        expect(integer.isNullOrBlank, equals(true));
      }

      someFunction(string: 'some value');
    });

    test('var.isNullOrBlank on a class ', () {
      TestClass testClass;
      expect(TestClass().isNullOrBlank, equals(false));
      expect(testClass.isNullOrBlank, equals(true));
      expect(EmptyClass().isNullOrBlank, equals(false));
    });
  });
}

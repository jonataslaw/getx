import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/src/extensions/iterable_extensions.dart';

void main() {
  test('Test some method for int list', () {
    var ages = [3, 10, 18, 20];

    var resultTrue = ages.some((age) => age == 18);
    expect(resultTrue, true);

    var resultFalse = ages.some((age) => age == 21);
    expect(resultFalse, false);
  });
  test('Test some method for double list', () {
    var ages = [3.5, 10.11, 18.56, 20.0, 88.89];

    var resultTrue = ages.some((age) => age == 88.89);
    expect(resultTrue, true);

    var resultFalse = ages.some((age) => age == 21.0);
    expect(resultFalse, false);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  test('Test for toPrecision on Double', () {
    var testVar = 5.4545454;
    expect(testVar.toPrecision(2), equals(5.45));
  });
}

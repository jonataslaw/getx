import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  num x = 5;
  num y = 7;
  test('Test for var.isLowerThan(value)', () {
    expect(x.isLowerThan(y), true);
    expect(y.isLowerThan(x), false);
  });
  test('Test for var.isGreaterThan(value)', () {
    expect(x.isGreaterThan(y), false);
    expect(y.isGreaterThan(x), true);
  });
  test('Test for var.isGreaterThan(value)', () {
    expect(x.isEqual(y), false);
    expect(y.isEqual(x), false);
    expect(x.isEqual(5), true);
    expect(y.isEqual(7), true);
  });
}

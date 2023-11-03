import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  const num x = 5;
  const num y = 7;
  const num z = 5;

  const doubleX = 2.1;
  const doubleY = 3.1;
  const doubleZ = 5.0;
  const pi = 3.14159265359;

  group('num extensions text', () {
    test('var.isLowerThan(value)', () {
      expect(x.isLowerThan(y), true);
      expect(y.isLowerThan(x), false);
      expect(x.isLowerThan(z), false);
      expect(doubleX.isLowerThan(doubleY), true);
      expect(doubleY.isLowerThan(pi), true);
      expect(x.isLowerThan(doubleX), false);
      expect(z.isLowerThan(doubleZ), false);
    });
    test('var.isGreaterThan(value)', () {
      expect(x.isGreaterThan(y), false);
      expect(y.isGreaterThan(x), true);
      expect(x.isGreaterThan(z), false);
      expect(doubleX.isGreaterThan(doubleY), false);
      expect(doubleY.isGreaterThan(pi), false);
      expect(pi.isGreaterThan(3.14159265359), false);
      expect(y.isGreaterThan(doubleY), true);
      expect(z.isGreaterThan(doubleZ), false);
    });
    test('var.isEqual(value)', () {
      expect(x.isEqual(y), false);
      expect(y.isEqual(x), false);
      expect(x.isEqual(5), true);
      expect(y.isEqual(7), true);
      expect(doubleX.isEqual(doubleY), false);
      expect(doubleY.isEqual(pi), false);
      expect(pi.isEqual(3.14159265359), true);
      expect(z.isEqual(doubleZ), true);
    });
  });
}

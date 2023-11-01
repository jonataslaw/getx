import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  test('String test', () {
    const value = 'string';
    var expected = '';
    void logFunction(final String prefix, final dynamic value, final String info,
        {final bool isError = false,}) {
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: String string');
  });
  test('Int test', () {
    const value = 1;
    var expected = '';
    void logFunction(final String prefix, final dynamic value, final String info,
        {final bool isError = false,}) {
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: int 1');
  });
  test('Double test', () {
    const value = 1.0;
    var expected = '';
    void logFunction(final String prefix, final dynamic value, final String info,
        {final bool isError = false,}) {
      expected = '$prefix $value $info'.trim();
    }

    value.printError(logFunction: logFunction);
    expect(expected, 'Error: double 1.0');
  });
}

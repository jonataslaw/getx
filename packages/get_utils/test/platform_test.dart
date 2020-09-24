@TestOn('vm')
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_utils/get_utils.dart';

void main() {
  test('Platform test', () {
    expect(GetPlatform.isAndroid, Platform.isAndroid);
    expect(GetPlatform.isIOS, Platform.isIOS);
    expect(GetPlatform.isFuchsia, Platform.isFuchsia);
    expect(GetPlatform.isLinux, Platform.isLinux);
    expect(GetPlatform.isMacOS, Platform.isMacOS);
    expect(GetPlatform.isWindows, Platform.isWindows);
    expect(GetPlatform.isWeb, false);
  });
}

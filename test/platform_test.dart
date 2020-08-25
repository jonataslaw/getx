import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/src/utils/platform/platform_web.dart';

void main() {
  test('Platform test', () {
    expect(GetPlatform.isAndroid, Platform.isAndroid);
    expect(GetPlatform.isIOS, Platform.isIOS);
    expect(GetPlatform.isFuchsia, Platform.isFuchsia);
    expect(GetPlatform.isLinux, Platform.isLinux);
    expect(GetPlatform.isMacOS, Platform.isMacOS);
    expect(GetPlatform.isWindows, Platform.isWindows);
    expect(GetPlatform.isWeb, false);
    expect(GeneralPlatform.isWeb, true);
    expect(GeneralPlatform.isAndroid, false);
    expect(GeneralPlatform.isIOS, false);
    expect(GeneralPlatform.isFuchsia, false);
    expect(GeneralPlatform.isLinux, false);
    expect(GeneralPlatform.isMacOS, false);
    expect(GeneralPlatform.isWindows, false);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'util/wrapper.dart';

void main() {
  testWidgets("Get.dialog close test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    expect(Get.isDarkMode, false);
    Get.changeTheme(ThemeData.dark());
    await Future.delayed(Duration.zero);
    expect(Get.isDarkMode, true);
    await tester.pumpAndSettle();
  });
}

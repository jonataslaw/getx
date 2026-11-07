import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(() {
    Get.reset();
  });
  testWidgets('GetRoot recognizes the Cupertino page transition builder',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: const Scaffold(body: Text('home')),
    ));
    await tester.pump(const Duration(milliseconds: 1));
    expect(Get.rootController.getThemeTransition(), Transition.cupertino);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
}

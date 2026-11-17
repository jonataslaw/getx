import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> _pump(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  tearDown(Get.reset);
  for (final replace in [false, true]) {
    testWidgets('page navigation honors app opacity default ($replace)',
        (tester) async {
      await tester.pumpWidget(const GetMaterialApp(
          opaqueRoute: false, home: Scaffold(body: Text('root'))));
      await _pump(tester);
      expect(Get.defaultOpaqueRoute, isFalse);
      if (replace) {
        Get.off<void>(() => const Scaffold(body: Text('target')),
            routeName: '/target');
      } else {
        Get.to<void>(() => const Scaffold(body: Text('target')),
            routeName: '/target');
      }
      await _pump(tester);
      expect(find.text('target'), findsOneWidget);
      expect(
          Get.rootController.rootDelegate.currentConfiguration!.route!.opaque,
          isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }

  testWidgets('explicit page opacity overrides app default', (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(opaqueRoute: false, home: Scaffold()));
    await _pump(tester);
    Get.to<void>(() => const Scaffold(), opaque: true, routeName: '/explicit');
    await _pump(tester);
    expect(Get.rootController.rootDelegate.currentConfiguration!.route!.opaque,
        isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

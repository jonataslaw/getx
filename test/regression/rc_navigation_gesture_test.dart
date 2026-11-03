import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);
  for (final complete in [false, true]) {
    testWidgets(
        'Cupertino edge swipe ${complete ? 'completes' : 'cancels'} without corrupting history',
        (tester) async {
      await tester.pumpWidget(GetMaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          initialRoute: '/root',
          getPages: [
            GetPage(
                name: '/root', page: () => const Scaffold(body: Text('root'))),
            GetPage(
                name: '/detail',
                page: () => const Scaffold(body: Text('detail')),
                popGesture: true,
                transition: Transition.cupertino),
          ]));
      await tester.pumpAndSettle();
      final results = <String?>[];
      Get.toNamed<String>('/detail')!.then(results.add);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(const Offset(1, 300));
      await gesture.moveBy(Offset(complete ? 650 : 60, 0));
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(Get.currentRoute, complete ? '/root' : '/detail');
      expect(results, complete ? [null] : isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}

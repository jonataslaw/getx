import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);
  testWidgets('system back respects canPop false and reports a denied pop',
      (tester) async {
    final invocations = <bool>[];
    await tester.pumpWidget(GetMaterialApp(initialRoute: '/root', getPages: [
      GetPage(name: '/root', page: () => const Scaffold(body: Text('root'))),
      GetPage(
          name: '/locked',
          page: () => const Scaffold(body: Text('locked')),
          canPop: false,
          onPopInvoked: (didPop, result) => invocations.add(didPop)),
    ]));
    await tester.pumpAndSettle();
    Get.toNamed('/locked');
    await tester.pumpAndSettle();
    final handled = await Get.rootController.rootDelegate.popRoute();
    await tester.pumpAndSettle();
    expect(handled, isTrue);
    expect(find.text('locked'), findsOneWidget);
    expect(Get.currentRoute, '/locked');
    expect(invocations, [false]);
  });

  testWidgets('system back respects a route PopScope veto', (tester) async {
    await tester.pumpWidget(GetMaterialApp(initialRoute: '/root', getPages: [
      GetPage(name: '/root', page: () => const Scaffold(body: Text('root'))),
      GetPage(
          name: '/locked',
          page: () => const PopScope(
              canPop: false, child: Scaffold(body: Text('locked')))),
    ]));
    await tester.pumpAndSettle();
    Get.toNamed('/locked');
    await tester.pumpAndSettle();
    expect(await Get.rootController.rootDelegate.popRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('locked'), findsOneWidget);
    expect(Get.currentRoute, '/locked');
  });
}

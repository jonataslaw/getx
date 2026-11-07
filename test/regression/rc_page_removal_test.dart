import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> mountRoutes(WidgetTester tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      initialRoute: '/root',
      getPages: [
        for (final name in ['/root', '/one', '/two'])
          GetPage(
            name: name,
            page: () => Scaffold(body: Text(name)),
          ),
      ],
    ),
  );
  await tester.pumpAndSettle();
}

List<String> history() => Get.rootController.rootDelegate.activePages
    .map((entry) => entry.route!.name)
    .toList();

void main() {
  tearDown(Get.reset);

  testWidgets('imperative pop completes the typed result exactly once', (
    tester,
  ) async {
    await mountRoutes(tester);
    final results = <int?>[];
    Get.toNamed<int>('/one')!.then(results.add);
    await tester.pumpAndSettle();
    Get.key.currentState!.pop<int>(42);
    await tester.pumpAndSettle();
    expect(results, [42]);
    expect(history(), ['/root']);
    await tester.pump();
    expect(results, [42]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'imperative replacement settles the removed page and its history',
    (tester) async {
      await mountRoutes(tester);
      final results = <int?>[];
      Get.toNamed<int>('/one')!.then(results.add);
      await tester.pumpAndSettle();
      Get.key.currentState!.pushReplacement<void, int>(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('replacement')),
        ),
        result: 42,
      );
      await tester.pumpAndSettle();
      expect(results, [42]);
      expect(history(), ['/root']);
      Get.key.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.text('/root'), findsOneWidget);
      expect(results, [42]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'replacing a covered page preserves the current page and future',
    (tester) async {
      await mountRoutes(tester);
      final first = <String?>[];
      final current = <int?>[];
      Get.toNamed<String>('/one')!.then(first.add);
      await tester.pumpAndSettle();
      final covered = ModalRoute.of(tester.element(find.text('/one')))!;
      Get.toNamed<int>('/two')!.then(current.add);
      await tester.pumpAndSettle();
      Get.key.currentState!.replace(
        oldRoute: covered,
        newRoute: MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('covered replacement')),
        ),
      );
      await tester.pumpAndSettle();
      expect(history(), ['/root', '/two']);
      expect(first, [null]);
      expect(current, isEmpty);
      expect(find.text('/two'), findsOneWidget);
      Get.back<int>(result: 7);
      await tester.pumpAndSettle();
      expect(current, [7]);
      expect(first, [null]);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> _pump(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

SnackbarController _snackbar(String message) => SnackbarController(GetSnackBar(
      title: 'notice',
      message: message,
      duration: const Duration(seconds: 10),
    ));

void main() {
  tearDown(Get.reset);
  testWidgets('instant close cancels the automatic timer', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _pump(tester);
    final controller = _snackbar('active');
    controller.show();
    await _pump(tester);
    await controller.close(withAnimations: false);
    await tester.pump(const Duration(seconds: 11));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }, timeout: const Timeout(Duration(seconds: 10)));

  testWidgets(
      'unmount closes active and queued snackbars and their show futures',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _pump(tester);
    final first = _snackbar('active');
    final second = _snackbar('queued');
    var completed = 0;
    first.show().then((_) => completed++);
    second.show().then((_) => completed++);
    await _pump(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    expect(tester.takeException(), isNull);
    expect(completed, 2);
  }, timeout: const Timeout(Duration(seconds: 10)));

  testWidgets('cancel all settles queued show futures without showing them',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _pump(tester);
    final first = _snackbar('active');
    final second = _snackbar('queued');
    var completed = 0;
    first.show().then((_) => completed++);
    second.show().then((_) => completed++);
    await _pump(tester);
    var canceled = false;
    SnackbarController.cancelAllSnackbars().then((_) => canceled = true);
    await _pump(tester);
    await _pump(tester);
    expect(canceled, isTrue);
    expect(completed, 2);
    expect(find.text('queued'), findsNothing);
    expect(Get.isSnackbarOpen, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }, timeout: const Timeout(Duration(seconds: 10)));

  testWidgets('teardown cancels delayed swipe cleanup', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _pump(tester);
    final controller = _snackbar('active');
    controller.show();
    await _pump(tester);
    final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
    dismissible.onDismissed!(DismissDirection.horizontal);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  }, timeout: const Timeout(Duration(seconds: 10)));

  testWidgets('closing an already closed snackbar is harmless', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _pump(tester);
    final controller = _snackbar('active');
    controller.show();
    await _pump(tester);
    await controller.close(withAnimations: false);
    await controller.close(withAnimations: false);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }, timeout: const Timeout(Duration(seconds: 10)));
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);
  testWidgets('snackbar uses the navigator overlay and queued jobs still run',
      (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await tester.pump();
    final first = Get.rawSnackbar(
        message: 'first',
        duration: const Duration(milliseconds: 50),
        animationDuration: const Duration(milliseconds: 20));
    final second = Get.rawSnackbar(
        message: 'second',
        duration: const Duration(milliseconds: 50),
        animationDuration: const Duration(milliseconds: 20));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    expect(find.text('first'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    expect(find.text('second'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 30));
    await first.future;
    await second.future;
    expect(Get.isSnackbarOpen, isFalse);
    expect(tester.takeException(), isNull);
  });
}

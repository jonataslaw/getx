import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> pumpOverlay(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  tearDown(Get.reset);

  testWidgets('closeAllOverlays closes a lone dialog without popping its page',
      (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await tester.pump();
    Get.dialog<void>(const AlertDialog(content: Text('dialog')));
    await pumpOverlay(tester);
    expect(find.text('dialog'), findsOneWidget);
    Get.closeAllOverlays();
    await pumpOverlay(tester);
    expect(find.text('dialog'), findsNothing);
    expect(find.text('root'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closeAllOverlays drains alternating dialogs and sheets',
      (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await tester.pump();
    Get.dialog<void>(const AlertDialog(content: Text('dialog')));
    await pumpOverlay(tester);
    Get.bottomSheet<void>(const Material(child: Text('sheet')));
    await pumpOverlay(tester);
    Get.closeAllOverlays();
    await pumpOverlay(tester);
    expect(find.text('dialog'), findsNothing);
    expect(find.text('sheet'), findsNothing);
    expect(find.text('root'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('close forwards a typed overlay result once', (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await tester.pump();
    final results = <String?>[];
    Get.dialog<String>(const AlertDialog(content: Text('dialog')))
        .then(results.add);
    await pumpOverlay(tester);
    Get.close<String>(
        closeAll: false,
        closeSnackbar: false,
        closeBottomSheet: false,
        result: 'picked');
    await pumpOverlay(tester);
    expect(results, ['picked']);
    expect(find.text('root'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closeDialog does not pop a bottom sheet covering a dialog',
      (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await tester.pump();
    final results = <String?>[];
    Get.dialog<void>(const AlertDialog(content: Text('dialog')));
    await pumpOverlay(tester);
    Get.bottomSheet<String>(const Material(child: Text('sheet')))
        .then(results.add);
    await pumpOverlay(tester);
    Get.closeDialog();
    await pumpOverlay(tester);
    expect(find.text('sheet'), findsOneWidget);
    expect(results, isEmpty);
    Get.closeAllOverlays();
    await pumpOverlay(tester);
  });
}

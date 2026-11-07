import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  tearDown(Get.reset);
  test('Get routes transition to a native Cupertino sheet', () {
    final route = GetPageRoute<void>(page: () => const SizedBox.shrink());
    final sheet = CupertinoSheetRoute<void>(
        scrollableBuilder: (_, __) => const SizedBox.shrink());
    expect(route.canTransitionTo(sheet), isTrue);
    final fullScreen = CupertinoPageRoute<void>(
        fullscreenDialog: true, builder: (_) => const SizedBox.shrink());
    expect(route.canTransitionTo(fullScreen), isFalse);
  });

  testWidgets('GetObserver accepts its optional Routing argument',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      navigatorObservers: [GetObserver()],
      home: const Scaffold(body: Text('root')),
    ));
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('root'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets(
      'observer replacement uses empty previous name rather than null text',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _settle(tester);
    final routing = Routing();
    GetObserver(null, routing).didReplace(
      newRoute: MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/new'),
          builder: (_) => const SizedBox.shrink()),
      oldRoute:
          MaterialPageRoute<void>(builder: (_) => const SizedBox.shrink()),
    );
    expect(routing.previous, '');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('closeBottomSheet returns its result without closing the page',
      (tester) async {
    await tester
        .pumpWidget(const GetMaterialApp(home: Scaffold(body: Text('root'))));
    await _settle(tester);
    final result = Get.bottomSheet<int>(const Material(child: Text('sheet')));
    await _settle(tester);
    Get.closeBottomSheet<int>(result: 7);
    await _settle(tester);
    expect(await result, 7);
    expect(find.text('root'), findsOneWidget);
    Get.closeBottomSheet<void>();
    expect(find.text('root'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('closeBottomSheet leaves a dialog covering the sheet intact',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await _settle(tester);
    Get.bottomSheet<void>(const Material(child: Text('sheet')));
    await _settle(tester);
    Get.dialog<void>(const AlertDialog(content: Text('dialog')));
    await _settle(tester);
    Get.closeBottomSheet<void>();
    await _settle(tester);
    expect(find.text('dialog'), findsOneWidget);
    Get.closeDialog<void>();
    await _settle(tester);
    expect(find.text('sheet'), findsOneWidget);
    Get.closeBottomSheet<void>();
    await _settle(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

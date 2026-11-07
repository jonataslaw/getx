import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_demo/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('example navigates through pages and disposes dependencies',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('page one'), findsOneWidget);
    expect(Get.isRegistered<FirstController>(), isTrue);

    await tester.tap(find.text('next screen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('page two 123'), findsOneWidget);
    expect(Get.isRegistered<SecondController>(), isTrue);

    await tester.tap(find.text('next screen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('page three'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    expect(Get.isRegistered<FirstController>(), isFalse);
    expect(Get.isRegistered<SecondController>(), isFalse);
  });
}

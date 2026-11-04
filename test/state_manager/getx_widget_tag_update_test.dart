import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class TestController extends GetxController {
  final String id;
  final count = 0.obs;
  TestController(this.id);
}

void main() {
  testWidgets('GetX widget should update controller when tag changes', (tester) async {
    // Setup
    final c1 = TestController('First');
    final c2 = TestController('Second');
    c1.count.value = 10;
    c2.count.value = 20;

    Get.put(c1, tag: 'first');
    Get.put(c2, tag: 'second');

    // Build with tag 'first'
    await tester.pumpWidget(MaterialApp(
      home: GetX<TestController>(
        tag: 'first',
        builder: (controller) => Text('Count: ${controller.count.value}'),
      ),
    ));

    expect(find.text('Count: 10'), findsOneWidget);

    // Rebuild with tag 'second'
    await tester.pumpWidget(MaterialApp(
      home: GetX<TestController>(
        tag: 'second',
        builder: (controller) => Text('Count: ${controller.count.value}'),
      ),
    ));
    await tester.pump();

    // Should show count from second controller
    expect(find.text('Count: 20'), findsOneWidget);
  });
}

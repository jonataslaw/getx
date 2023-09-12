import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('GetxController smoke test', (WidgetTester tester) async {
    final Controller<dynamic> controller = Get.put(Controller<dynamic>());
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: <Widget>[
            Obx(
              () => Column(children: <Widget>[
                Text('Count: ${controller.counter.value}'),
                Text('Double: ${controller.doubleNum.value}'),
                Text('String: ${controller.string.value}'),
                Text('List: ${controller.list.length}'),
                Text('Bool: ${controller.boolean.value}'),
                Text('Map: ${controller.map.length}'),
                TextButton(
                  onPressed: controller.increment,
                  child: const Text('increment'),
                ),
                Obx(() => Text('Obx: ${controller.map.length}'))
              ]),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Double: 0.0'), findsOneWidget);
    expect(find.text('String: string'), findsOneWidget);
    expect(find.text('Bool: true'), findsOneWidget);
    expect(find.text('List: 0'), findsOneWidget);
    expect(find.text('Map: 0'), findsOneWidget);
    expect(find.text('Obx: 0'), findsOneWidget);

    Controller.to.increment();

    await tester.pump();

    expect(find.text('Count: 1'), findsOneWidget);

    await tester.tap(find.text('increment'));

    await tester.pump();

    expect(find.text('Count: 2'), findsOneWidget);
  });
}

class Controller<T> extends GetxController {
  static Controller<dynamic> get to => Get.find();

  RxInt counter = 0.obs;
  RxDouble doubleNum = 0.0.obs;
  RxString string = 'string'.obs;
  RxList<dynamic> list = <dynamic>[].obs;
  RxMap<dynamic, dynamic> map = <dynamic, dynamic>{}.obs;
  RxBool boolean = true.obs;

  void increment() {
    counter.value++;
  }
}

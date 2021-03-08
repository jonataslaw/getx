import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  final controller = Get.put(Controller());
  testWidgets("GetxController smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Obx(
              () => Column(children: [
                Text('Count: ${controller.counter.value}'),
                Text('Double: ${controller.doubleNum.value}'),
                Text('String: ${controller.string.value}'),
                Text('List: ${controller.list.length}'),
                Text('Bool: ${controller.boolean.value}'),
                Text('Map: ${controller.map.length}'),
                TextButton(
                  child: Text("increment"),
                  onPressed: controller.increment,
                ),
                Obx(() => Text('Obx: ${controller.map.length}'))
              ]),
            ),
          ],
        ),
      ),
    );

    expect(find.text("Count: 0"), findsOneWidget);
    expect(find.text("Double: 0.0"), findsOneWidget);
    expect(find.text("String: string"), findsOneWidget);
    expect(find.text("Bool: true"), findsOneWidget);
    expect(find.text("List: 0"), findsOneWidget);
    expect(find.text("Map: 0"), findsOneWidget);
    expect(find.text("Obx: 0"), findsOneWidget);

    Controller.to.increment();

    await tester.pump();

    expect(find.text("Count: 1"), findsOneWidget);

    await tester.tap(find.text('increment'));

    await tester.pump();

    expect(find.text("Count: 2"), findsOneWidget);
  });
}

class Controller extends GetxController {
  static Controller get to => Get.find();

  RxInt counter = 0.obs;
  RxDouble doubleNum = 0.0.obs;
  RxString string = "string".obs;
  RxList list = [].obs;
  RxMap map = {}.obs;
  RxBool boolean = true.obs;

  void increment() {
    counter.value++;
  }
}

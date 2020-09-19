import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_core/get_core.dart';
import 'package:get_instance/get_instance.dart';
import 'package:get_state_manager/get_state_manager.dart';

void main() {
  testWidgets("MixinBuilder smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MixinBuilder<Controller>(
          init: Controller(),
          builder: (controller) {
            return Column(
              children: [
                Text(
                  'Count: ${controller.counter.value}',
                ),
                Text(
                  'Count2: ${controller.count}',
                ),
                Text(
                  'Double: ${controller.doubleNum.value}',
                ),
                Text(
                  'String: ${controller.string.value}',
                ),
                Text(
                  'List: ${controller.list.length}',
                ),
                Text(
                  'Bool: ${controller.boolean.value}',
                ),
                Text(
                  'Map: ${controller.map.length}',
                ),
                FlatButton(
                  child: Text("increment"),
                  onPressed: () => controller.increment(),
                )
              ],
            );
          },
        ),
      ),
    );

    expect(find.text("Count: 0"), findsOneWidget);
    expect(find.text("Count2: 0"), findsOneWidget);
    expect(find.text("Double: 0.0"), findsOneWidget);
    expect(find.text("String: string"), findsOneWidget);
    expect(find.text("Bool: true"), findsOneWidget);
    expect(find.text("List: 0"), findsOneWidget);
    expect(find.text("Map: 0"), findsOneWidget);

    Controller.to.increment();

    await tester.pump();

    expect(find.text("Count: 1"), findsOneWidget);

    await tester.tap(find.text('increment'));

    await tester.pump();

    expect(find.text("Count: 2"), findsOneWidget);
  });

  testWidgets(
    "MixinBuilder with build null",
    (tester) async {
      expect(
        () => MixinBuilder<Controller>(
          init: Controller(),
          builder: null,
        ),
        throwsAssertionError,
      );
    },
  );
}

class Controller extends GetxController {
  static Controller get to => Get.find();
  int count = 0;
  RxInt counter = 0.obs;
  RxDouble doubleNum = 0.0.obs;
  RxString string = "string".obs;
  RxList list = [].obs;
  RxMap map = {}.obs;
  RxBool boolean = true.obs;

  void increment() {
    counter.value++;
  }

  void increment2() {
    count++;
    update();
  }
}

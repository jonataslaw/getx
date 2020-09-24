import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_core/get_core.dart';
import 'package:get_instance/get_instance.dart';
import 'package:get_state_manager/get_state_manager.dart';

void main() {
  Get.lazyPut<Controller2>(() => Controller2());
  testWidgets("GetxController smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GetX<Controller>(
          init: Controller(),
          builder: (controller) {
            return Column(
              children: [
                Text(
                  'Count: ${controller.counter.value}',
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
                ),
                GetX<Controller2>(builder: (controller) {
                  return Text('lazy ${controller.lazy.value}');
                }),
                GetX<ControllerNonGlobal>(
                    init: ControllerNonGlobal(),
                    global: false,
                    builder: (controller) {
                      return Text('single ${controller.nonGlobal.value}');
                    })
              ],
            );
          },
        ),
      ),
    );

    expect(find.text("Count: 0"), findsOneWidget);
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
    expect(find.text("lazy 0"), findsOneWidget);
    expect(find.text("single 0"), findsOneWidget);
  });
}

class Controller2 extends GetxController {
  RxInt lazy = 0.obs;
}

class ControllerNonGlobal extends GetxController {
  RxInt nonGlobal = 0.obs;
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

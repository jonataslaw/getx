import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
                TextButton(
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

  testWidgets("GetX should close non-global controller on dispose",
          (test) async {

        final controller = ControllerNonGlobal();

        await test.pumpWidget(
          MaterialApp(
            home: GetX<ControllerNonGlobal>(
                init: controller,
                global: false,
                builder: (controller) {
                  return Column(
                    children: [
                      Text(controller.nonGlobal.value.toString(),),
                      Builder(builder: (context) {
                        return TextButton(
                          child: Text('go-to-new-screen'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c) =>
                                Text('new-screen')));
                          },
                        );
                      }),
                    ],
                  );
                }),
          ),
        );

        await test.pump();

        expect(find.text("go-to-new-screen"), findsOneWidget);

        expect(controller.isClosed, false,
            reason: "controller should not be closed here");

        await test.tap(find.text('go-to-new-screen'));

        await test.pumpAndSettle();

        expect(find.text("new-screen"), findsOneWidget);

        expect(controller.isClosed, true,
            reason: "controller should be closed "
                "after GetX is removed from widget tree");
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

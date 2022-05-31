import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  Get.lazyPut<Controller2>(() => Controller2());
  testWidgets("GetxController smoke test", (test) async {
    await test.pumpWidget(
      MaterialApp(
        home: GetBuilder<Controller>(
          init: Controller(),
          builder: (controller) => Column(
            children: [
              Text(
                '${controller.counter}',
              ),
              TextButton(
                child: Text("increment"),
                onPressed: () => controller.increment(),
              ),
              TextButton(
                child: Text("incrementWithId"),
                onPressed: () => controller.incrementWithId(),
              ),
              GetBuilder<Controller>(
                  id: '1',
                  didChangeDependencies: (_) {
                    // print("didChangeDependencies called");
                  },
                  builder: (controller) {
                    return Text('id ${controller.counter}');
                  }),
              GetBuilder<Controller2>(builder: (controller) {
                return Text('lazy ${controller.test}');
              }),
              GetBuilder<ControllerNonGlobal>(
                  init: ControllerNonGlobal(),
                  global: false,
                  builder: (controller) {
                    return Text('single ${controller.nonGlobal}');
                  })
            ],
          ),
        ),
      ),
    );

    expect(find.text("0"), findsOneWidget);

    Controller.to.increment();

    await test.pump();

    expect(find.text("1"), findsOneWidget);

    await test.tap(find.text('increment'));

    await test.pump();

    expect(find.text("2"), findsOneWidget);

    await test.tap(find.text('incrementWithId'));

    await test.pump();

    expect(find.text("id 3"), findsOneWidget);
    expect(find.text("lazy 0"), findsOneWidget);
    expect(find.text("single 0"), findsOneWidget);
  });

  testWidgets("GetBuilder should close non-global controller on dispose",
          (test) async {

    final controller = ControllerNonGlobal();

    await test.pumpWidget(
      MaterialApp(
        home: GetBuilder<ControllerNonGlobal>(
            init: controller,
            global: false,
            builder: (controller) {
              return Builder(builder: (context) {
                return TextButton(
                  child: Text('non-local'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c) =>
                        Text('new screen')));
                  },
                );
              });
            }),
      ),
    );

    await test.pump();

    expect(find.text("non-local"), findsOneWidget);

    expect(controller.isClosed, false,
        reason: "controller should note be closed");

    await test.tap(find.text('non-local'));

    await test.pumpAndSettle();

    expect(find.text("new screen"), findsOneWidget);

    expect(controller.isClosed, true,
        reason: "controller should be closed "
            "after GetBuilder is removed from tree");
  });

  // testWidgets(
  //   "MixinBuilder with build null",
  //   (test) async {
  //     expect(
  //       () => GetBuilder<Controller>(
  //         init: Controller(),
  //         builder: null,
  //       ),
  //       throwsAssertionError,
  //     );
  //   },
  // );
}

class Controller extends GetxController {
  static Controller get to => Get.find();

  int counter = 0;

  void increment() {
    counter++;
    update();
  }

  void incrementWithId() {
    counter++;
    update(['1']);
  }
}

class Controller2 extends GetxController {
  int test = 0;
}

class ControllerNonGlobal extends GetxController {
  int nonGlobal = 0;
}

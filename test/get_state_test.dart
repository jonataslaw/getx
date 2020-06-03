import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  Get.lazyPut<Controller2>(() => Controller2());
  testWidgets("GetController smoke test", (testr) async {
    await testr.pumpWidget(
      MaterialApp(
        home: GetBuilder<Controller>(
          init: Controller(),
          builder: (controller) => Column(
            children: [
              Text(
                '${controller.counter}',
              ),
              FlatButton(
                child: Text("increment"),
                onPressed: () => controller.increment(),
              ),
              FlatButton(
                child: Text("incrementWithId"),
                onPressed: () => controller.incrementWithId(),
              ),
              GetBuilder<Controller>(
                  id: '1',
                  didChangeDependencies: (_) {
                    print("didChangeDependencies called");
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

    await testr.pump();

    expect(find.text("1"), findsOneWidget);

    await testr.tap(find.text('increment'));

    await testr.pump();

    expect(find.text("2"), findsOneWidget);

    await testr.tap(find.text('incrementWithId'));

    await testr.pump();

    expect(find.text("id 3"), findsOneWidget);
    expect(find.text("lazy 0"), findsOneWidget);
    expect(find.text("single 0"), findsOneWidget);
  });

  testWidgets(
    "MixinBuilder with build null",
    (WidgetTester testr) async {
      expect(
          () => GetBuilder<Controller>(
                init: Controller(),
                builder: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetBuilder controller error",
    (WidgetTester testr) async {
      expect(() => ControllerError().callBuild(),
          throwsA("build method can\'t be called"));
    },
  );
}

class Controller extends GetController {
  static Controller get to => Get.find();

  int counter = 0;
  void increment() {
    counter++;
    update(this);
  }

  void incrementWithId() {
    counter++;
    update(this, ['1']);
  }
}

class Controller2 extends GetController {
  int test = 0;
}

class ControllerError extends GetController {
  int test = 0;

  callBuild() {
    BuildContext context;
    build(context);
  }
}

class ControllerNonGlobal extends GetController {
  int nonGlobal = 0;
}

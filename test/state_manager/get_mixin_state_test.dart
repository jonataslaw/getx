import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/mixin_builder.dart';

void main() {
  testWidgets('MixinBuilder with reactive and not reactive',
      (final WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MixinBuilder<Controller<dynamic>>(
          init: Controller<dynamic>(),
          builder: (final Controller<dynamic> controller) {
            return Column(
              children: <Widget>[
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
                TextButton(
                  child: const Text('increment'),
                  onPressed: () => controller.increment(),
                ),
                TextButton(
                  child: const Text('increment2'),
                  onPressed: () => controller.increment2(),
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('Count: 0'), findsOneWidget);
    expect(find.text('Count2: 0'), findsOneWidget);
    expect(find.text('Double: 0.0'), findsOneWidget);
    expect(find.text('String: string'), findsOneWidget);
    expect(find.text('Bool: true'), findsOneWidget);
    expect(find.text('List: 0'), findsOneWidget);
    expect(find.text('Map: 0'), findsOneWidget);

    Controller.to.increment();

    await tester.pump();

    expect(find.text('Count: 1'), findsOneWidget);

    await tester.tap(find.text('increment'));

    await tester.pump();

    expect(find.text('Count: 2'), findsOneWidget);

    await tester.tap(find.text('increment2'));

    await tester.pump();

    expect(find.text('Count2: 1'), findsOneWidget);
  });

  // testWidgets(
  //   "MixinBuilder with build null",
  //   (tester) async {
  //     expect(
  //       () => MixinBuilder<Controller>(
  //         init: Controller(),
  //         builder: null,
  //       ),
  //       throwsAssertionError,
  //     );
  //   },
  // );
}

class Controller<T> extends GetxController {
  static Controller<dynamic> get to => Get.find();
  int count = 0;
  RxInt counter = 0.obs;
  RxDouble doubleNum = 0.0.obs;
  RxString string = 'string'.obs;
  RxList<dynamic> list = <dynamic>[].obs;
  RxMap<dynamic, dynamic> map = <dynamic, dynamic>{}.obs;
  RxBool boolean = true.obs;

  void increment() {
    counter.value++;
  }

  void increment2() {
    count++;
    update();
  }
}

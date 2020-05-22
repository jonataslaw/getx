import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets("GetController smoke test", (tester) async {
    await tester.pumpWidget(
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
              )
            ],
          ),
        ),
      ),
    );

    expect(find.text("0"), findsOneWidget);

    Controller.to.increment();

    await tester.pump();

    expect(find.text("1"), findsOneWidget);

    await tester.tap(find.text('increment'));

    await tester.pump();

    expect(find.text("2"), findsOneWidget);
  });
}

class Controller extends GetController {
  static Controller get to => Get.find();

  int counter = 0;
  void increment() {
    counter++;
    update(this);
  }
}

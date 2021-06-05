import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class IntController extends GetxStreamController<int, StreamController<int>> {
  IntController(StreamController<int> s) : super(s);

  static IntController get to => Get.find();
}

void main() {
  var counter = 0;
  final s = StreamController<int>();
  final c = StreamController<int>();
  // must init like this, details see:https://github.com/dart-lang/sdk/issues/46117
  late final controller =
      GetxStreamControllerBind<int, StreamController<int>>(s).bind;

  late var othercontroller = IntController(c);

  Get.put(controller);
  final f = Get.find<GetxStreamController<int, StreamController<int>>>();
  testWidgets("GetxStreamController smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(children: [
          GetX<GetxStreamController<int, StreamController<int>>>(
            init: controller,
            builder: (_) {
              return Column(
                children: [
                  Text(
                    'Count: ${_.value ?? 0}',
                  ),
                  TextButton(
                      child: Text("increment"),
                      onPressed: () {
                        s.sink.add(++counter);
                        c.sink.add(counter);
                      }),
                ],
              );
            },
          ),
          Obx(() => Text(
                'Count1: ${controller.value ?? 0}',
              )),
          Obx(() => Text(
                'Count2: ${f.value ?? 0}',
              )),
          GetX<IntController>(
              init: othercontroller,
              builder: (_) {
                return Text('Count3: ${_.value ?? 0}');
              }),
        ]),
      ),
    );

    expect(find.text("Count: 0"), findsOneWidget);
    expect(find.text("Count1: 0"), findsOneWidget);
    expect(find.text("Count2: 0"), findsOneWidget);
    expect(find.text("Count3: 0"), findsOneWidget);

    await tester.tap(find.text('increment'));
    await tester.pump();

    expect(find.text("Count: 1"), findsOneWidget);
    expect(find.text("Count1: 1"), findsOneWidget);
    expect(find.text("Count2: 1"), findsOneWidget);
    expect(find.text("Count3: 1"), findsOneWidget);

    s.sink.add(2);
    c.sink.add(2);
    await tester.pump();

    expect(find.text("Count: 2"), findsOneWidget);
    expect(find.text("Count1: 2"), findsOneWidget);
    expect(find.text("Count2: 2"), findsOneWidget);
    expect(find.text("Count3: 2"), findsOneWidget);

    c.close();
    s.close();
  });
}

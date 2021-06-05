import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  var counter = 0;
  final s = StreamController<int>();
  late final controller =
      GetxStreamControllerBind<int, StreamController<int>>(s).bind;

  Get.put(controller);
  final f = Get.find<GetxStreamController<int, StreamController<int>>>();
  testWidgets("GetxStreamController smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(children: [
          GetX<GetxStreamController>(
            init: controller,
            builder: (_) {
              return Column(
                children: [
                  Text(
                    'Count: ${controller.value ?? 0}',
                  ),
                  TextButton(
                    child: Text("increment"),
                    onPressed: () => s.sink.add(++counter),
                  ),
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
        ]),
      ),
    );

    expect(find.text("Count: 0"), findsOneWidget);
    expect(find.text("Count1: 0"), findsOneWidget);
    expect(find.text("Count2: 0"), findsOneWidget);

    await tester.tap(find.text('increment'));
    await tester.pump();

    expect(find.text("Count: 1"), findsOneWidget);
    expect(find.text("Count1: 1"), findsOneWidget);
    expect(find.text("Count2: 1"), findsOneWidget);

    s.sink.add(2);
    await tester.pump();

    expect(find.text("Count: 2"), findsOneWidget);
    expect(find.text("Count1: 2"), findsOneWidget);
    expect(find.text("Count2: 2"), findsOneWidget);

    s.close();
  });
}

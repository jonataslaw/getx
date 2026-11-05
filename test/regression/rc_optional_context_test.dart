import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('Get.context is absent before a GetX app mounts', (tester) async {
    expect(Get.context, isNull);
    expect(Get.theme.brightness, ThemeData.fallback().brightness);
  });

  testWidgets('Get.overlayContext is absent before a GetX app mounts', (
    tester,
  ) async {
    expect(Get.overlayContext, isNull);
  });

  testWidgets('optional contexts track app mounting, disposal and remounting', (
    tester,
  ) async {
    for (var mount = 0; mount < 2; mount++) {
      await tester.pumpWidget(
        GetMaterialApp(
          key: ValueKey(mount),
          theme: ThemeData.dark(),
          home: const Scaffold(body: Text('mounted')),
        ),
      );
      await tester.pumpAndSettle();
      expect(Get.context, isNotNull);
      expect(Get.context!.mounted, isTrue);
      expect(Get.overlayContext, isNotNull);
      expect(Get.overlayContext!.mounted, isTrue);
      expect(Get.theme.brightness, Brightness.dark);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(Get.context, isNull);
      expect(Get.overlayContext, isNull);
      expect(Get.theme.brightness, ThemeData.fallback().brightness);
      expect(tester.takeException(), isNull);
    }
  });
}

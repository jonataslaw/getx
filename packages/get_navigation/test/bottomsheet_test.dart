import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_navigation/get_navigation.dart';
import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.bottomSheet smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.bottomSheet(Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Music'),
              onTap: () => {}),
        ],
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets("Get.bottomSheet close test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.bottomSheet(Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Music'),
              onTap: () => {}),
        ],
      ),
    ));

    expect(Get.isBottomSheetOpen, true);

    Get.back();
    expect(Get.isBottomSheetOpen, false);

    expect(() => Get.bottomSheet(Container(), isScrollControlled: null),
        throwsAssertionError);

    expect(() => Get.bottomSheet(Container(), isDismissible: null),
        throwsAssertionError);

    expect(() => Get.bottomSheet(Container(), enableDrag: null),
        throwsAssertionError);

    await tester.pumpAndSettle();
  });

  testWidgets(
    "GetMaterialApp with debugShowMaterialGrid null",
    (tester) async {
      expect(
        () => GetMaterialApp(
          debugShowMaterialGrid: null,
        ),
        throwsAssertionError,
      );
    },
  );
}

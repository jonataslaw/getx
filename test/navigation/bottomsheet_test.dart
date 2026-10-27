import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.bottomSheet smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    await tester.pump();

    Get.bottomSheet(Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.music_note),
          title: const Text('Music'),
          onTap: () {},
        ),
      ],
    ));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets("Get.bottomSheet close test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    await tester.pump();

    Get.bottomSheet(Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.music_note),
          title: const Text('Music'),
          onTap: () {},
        ),
      ],
    ));

    await tester.pumpAndSettle();

    expect(Get.isBottomSheetOpen, true);

    Get.backLegacy();
    await tester.pumpAndSettle();

    expect(Get.isBottomSheetOpen, false);

    // expect(() => Get.bottomSheet(Container(), isScrollControlled: null),
    //     throwsAssertionError);

    // expect(() => Get.bottomSheet(Container(), isDismissible: null),
    //     throwsAssertionError);

    // expect(() => Get.bottomSheet(Container(), enableDrag: null),
    //     throwsAssertionError);

    await tester.pumpAndSettle();
  });

  Finder dragHandle() {
    return find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byWidgetPredicate((widget) {
        return widget is Container &&
            widget.constraints ==
                const BoxConstraints.tightFor(width: 32, height: 4);
      }),
    );
  }

  Future<void> openSheet(
    WidgetTester tester, {
    ThemeData? theme,
    bool? showDragHandle,
    bool passShowDragHandle = true,
  }) async {
    await tester.pumpWidget(GetMaterialApp(
      theme: theme,
      home: const Scaffold(body: SizedBox.shrink()),
    ));
    await tester.pump();

    if (passShowDragHandle) {
      Get.bottomSheet(
        const Text('sheet-body'),
        showDragHandle: showDragHandle,
      );
    } else {
      Get.bottomSheet(const Text('sheet-body'));
    }
    await tester.pumpAndSettle();
  }

  const handleTheme = BottomSheetThemeData(showDragHandle: true);

  testWidgets('Get.bottomSheet showDragHandle true builds the drag handle',
      (tester) async {
    await openSheet(tester, showDragHandle: true);

    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
        isTrue);
    expect(dragHandle(), findsOneWidget);
    expect(find.text('sheet-body'), findsOneWidget);
  });

  testWidgets('Get.bottomSheet showDragHandle false overrides the theme',
      (tester) async {
    await openSheet(
      tester,
      showDragHandle: false,
      theme: ThemeData(bottomSheetTheme: handleTheme),
    );

    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
        isFalse);
    expect(dragHandle(), findsNothing);
  });

  testWidgets('Get.bottomSheet omits showDragHandle and follows the theme',
      (tester) async {
    await openSheet(
      tester,
      passShowDragHandle: false,
      theme: ThemeData(bottomSheetTheme: handleTheme),
    );

    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
        isNull);
    expect(dragHandle(), findsOneWidget);
  });

  testWidgets('Get.bottomSheet defaults showDragHandle to null', (tester) async {
    await openSheet(tester, passShowDragHandle: false);

    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).showDragHandle,
        isNull);
    expect(dragHandle(), findsNothing);
  });

  // testWidgets(
  //   "GetMaterialApp with debugShowMaterialGrid null",
  //   (tester) async {
  //     expect(
  //       () => GetMaterialApp(
  //         debugShowMaterialGrid: null,
  //       ),
  //       throwsAssertionError,
  //     );
  //   },
  // );
}

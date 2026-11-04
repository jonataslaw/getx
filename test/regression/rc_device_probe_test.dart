import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// The native probe belongs to the independent example package.
// ignore: avoid_relative_lib_imports
import '../../example_nav2/lib/device_navigation_probe.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('probe exposes root and completes a typed result', (
    tester,
  ) async {
    await tester.pumpWidget(const DeviceNavigationProbeApp());
    await tester.pumpAndSettle();
    expect(find.text('ROOT_ROUTE'), findsOneWidget);
    await tester.tap(find.text('OPEN_DETAIL'));
    await tester.pumpAndSettle();
    expect(find.text('DETAIL_ROUTE'), findsOneWidget);
    await tester.tap(find.text('CLOSE_WITH_42'));
    await tester.pumpAndSettle();
    expect(find.text('ROOT_ROUTE'), findsOneWidget);
    expect(find.text('RESULT:42'), findsOneWidget);
  });

  testWidgets(
    'probe exposes native accessibility identifiers without VoiceOver',
    (tester) async {
      await tester.pumpWidget(
        const DeviceNavigationProbeApp(bootId: 'test-run'),
      );
      await tester.pumpAndSettle();
      final marker = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.identifier == 'probe.root.marker',
      );
      expect(
        tester.getSemantics(marker).getSemanticsData().identifier,
        'probe.root.marker',
      );
      expect(find.text('BOOT:test-run'), findsOneWidget);
      expect(find.textContaining('PID:'), findsOneWidget);
    },
  );

  testWidgets(
    'probe veto rejects system back and reset is explicit replacement',
    (tester) async {
      await tester.pumpWidget(const DeviceNavigationProbeApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('OPEN_VETO'));
      await tester.pumpAndSettle();
      expect(find.text('CAN_POP:false'), findsOneWidget);
      expect(await Get.rootController.rootDelegate.popRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('VETO_ROUTE'), findsOneWidget);
      await tester.tap(find.text('RESET_TO_ROOT'));
      await tester.pumpAndSettle();
      expect(find.text('ROOT_ROUTE'), findsOneWidget);
    },
  );

  testWidgets(
    'probe restores detail count and note with fixed detail control',
    (tester) async {
      await tester.pumpWidget(
        const DeviceNavigationProbeApp(
          initialRoute: '/probe/detail',
          bootId: 'restoration-control',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('COUNTER_PLUS'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'restored-note');
      await tester.pump();
      expect(find.text('COUNT:1'), findsOneWidget);
      expect(find.text('NOTE:restored-note'), findsOneWidget);
      await tester.restartAndRestore();
      await tester.pumpAndSettle();
      expect(find.text('DETAIL_ROUTE'), findsOneWidget);
      expect(find.text('COUNT:1'), findsOneWidget);
      expect(find.text('NOTE:restored-note'), findsOneWidget);
    },
  );

  testWidgets(
    'probe restores current detail state and returns to the restored root',
    (tester) async {
      await tester.pumpWidget(const DeviceNavigationProbeApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('OPEN_DETAIL'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('COUNTER_PLUS'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'stack-note');
      await tester.pump();
      await tester.restartAndRestore();
      await tester.pumpAndSettle();
      expect(find.text('DETAIL_ROUTE'), findsOneWidget);
      expect(find.text('COUNT:1'), findsOneWidget);
      expect(find.text('NOTE:stack-note'), findsOneWidget);
      expect(Get.rootController.rootDelegate.canBack, isTrue);
      await tester.tap(find.text('CLOSE_WITH_42'));
      await tester.pumpAndSettle();
      expect(find.text('ROOT_ROUTE'), findsOneWidget);
      expect(Get.rootController.rootDelegate.canBack, isFalse);
    },
  );

  for (final complete in [false, true]) {
    testWidgets('probe Cupertino edge ${complete ? 'completes' : 'cancels'}', (
      tester,
    ) async {
      await tester.pumpWidget(const DeviceNavigationProbeApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('OPEN_DETAIL'));
      await tester.pumpAndSettle();
      final route = ModalRoute.of(tester.element(find.text('DETAIL_ROUTE')))!;
      final gesture = await tester.startGesture(const Offset(1, 300));
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.moveBy(Offset(complete ? 630 : 40, 0));
      await tester.pump(const Duration(milliseconds: 500));
      expect(route.navigator!.userGestureInProgress, isTrue);
      expect(route.animation!.value, lessThan(1));
      await gesture.up();
      await tester.pumpAndSettle();
      if (complete) {
        expect(find.text('ROOT_ROUTE'), findsOneWidget);
        expect(find.text('RESULT:null'), findsOneWidget);
      } else {
        expect(find.text('DETAIL_ROUTE'), findsOneWidget);
        await tester.tap(find.text('CLOSE_WITH_42'));
        await tester.pumpAndSettle();
        expect(find.text('RESULT:42'), findsOneWidget);
      }
    });
  }
}

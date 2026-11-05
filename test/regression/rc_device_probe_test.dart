import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// The native probe belongs to the independent example package.
// ignore: avoid_relative_lib_imports
import '../../example_nav2/lib/device_navigation_probe.dart';

// Injects the Android framework channel as Flutter's own predictive-back tests
// do. These are widget regressions; native input is tested by the Android suite.
Future<Object?> _backGesture(
  WidgetTester tester,
  String method, [
  double? progress,
]) async {
  const codec = StandardMethodCodec();
  Object? reply;
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    codec.encodeMethodCall(
      MethodCall(
        method,
        progress == null
            ? null
            : {
                'touchOffset': <double>[5 + 300 * progress, 300],
                'progress': progress,
                'swipeEdge': 0,
              },
      ),
    ),
    (message) => reply = message == null ? null : codec.decodeEnvelope(message),
  );
  await tester.pump();
  return reply;
}

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
      await tester.pumpWidget(
        const DeviceNavigationProbeApp(platform: TargetPlatform.iOS),
      );
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

  for (final complete in [false, true]) {
    testWidgets(
      'Android predictive channel ${complete ? 'commits once' : 'cancels without disposal'}',
      (tester) async {
        await tester.pumpWidget(
          const DeviceNavigationProbeApp(platform: TargetPlatform.android),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('OPEN_DETAIL'));
        await tester.pumpAndSettle();
        expect(
          find.text('LIFETIME:created=1,closed=0,active=1'),
          findsOneWidget,
        );
        final route = ModalRoute.of(tester.element(find.text('DETAIL_ROUTE')))!;
        expect(await _backGesture(tester, 'startBackGesture', 0), isTrue);
        await _backGesture(tester, 'updateBackGestureProgress', 0.35);
        expect(route.navigator!.userGestureInProgress, isTrue);
        expect(route.animation!.value, lessThan(1));
        expect(
          find.text('GESTURES:started=1,stopped=0,progressed=1'),
          findsNWidgets(2),
        );
        expect(
          find.text('RESULT:pending', skipOffstage: false),
          findsOneWidget,
        );
        await _backGesture(
          tester,
          complete ? 'commitBackGesture' : 'cancelBackGesture',
        );
        await tester.pumpAndSettle();
        if (complete) {
          expect(find.text('ROOT_ROUTE'), findsOneWidget);
          expect(find.text('RESULT:null'), findsOneWidget);
          expect(Get.rootController.rootDelegate.canBack, isFalse);
        } else {
          expect(find.text('DETAIL_ROUTE'), findsOneWidget);
          expect(
            find.text('LIFETIME:created=1,closed=0,active=1'),
            findsOneWidget,
          );
          expect(
            find.text('RESULT:pending', skipOffstage: false),
            findsOneWidget,
          );
          expect(Get.rootController.rootDelegate.canBack, isTrue);
          await tester.ensureVisible(find.text('CLOSE_WITH_42'));
          await tester.tap(find.text('CLOSE_WITH_42'));
          await tester.pumpAndSettle();
          expect(find.text('RESULT:42'), findsOneWidget);
        }
        expect(
          find.text('LIFETIME:created=1,closed=1,active=0'),
          findsOneWidget,
        );
        expect(
          find.text('GESTURES:started=1,stopped=1,progressed=1'),
          findsOneWidget,
        );
        // A fresh push must create a new route-owned dependency and future.
        await tester.tap(find.text('OPEN_DETAIL'));
        await tester.pumpAndSettle();
        expect(
          find.text('LIFETIME:created=2,closed=1,active=1'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('CLOSE_WITH_42'));
        await tester.tap(find.text('CLOSE_WITH_42'));
        await tester.pumpAndSettle();
        expect(find.text('RESULT:42'), findsOneWidget);
        expect(
          find.text('LIFETIME:created=2,closed=2,active=0'),
          findsOneWidget,
        );
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }

  testWidgets(
    'Android predictive channel and system back respect canPop veto',
    (tester) async {
      await tester.pumpWidget(
        const DeviceNavigationProbeApp(platform: TargetPlatform.android),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('OPEN_VETO'));
      await tester.pumpAndSettle();
      expect(await _backGesture(tester, 'startBackGesture', 0), isFalse);
      await _backGesture(tester, 'commitBackGesture');
      await tester.pumpAndSettle();
      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('VETO_ROUTE'), findsOneWidget);
      expect(find.text('LIFETIME:created=1,closed=0,active=1'), findsOneWidget);
      expect(
        find.text('GESTURES:started=0,stopped=0,progressed=0'),
        findsOneWidget,
      );
      expect(find.text('RESULT:pending', skipOffstage: false), findsOneWidget);
      await tester.ensureVisible(find.text('RESET_TO_ROOT'));
      await tester.tap(find.text('RESET_TO_ROOT'));
      await tester.pumpAndSettle();
      expect(find.text('ROOT_ROUTE'), findsOneWidget);
      expect(find.text('LIFETIME:created=1,closed=1,active=0'), findsOneWidget);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets('Android dynamic PopScope veto becomes predictive-back enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const DeviceNavigationProbeApp(platform: TargetPlatform.android),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN_SCOPE_VETO'));
    await tester.pumpAndSettle();
    expect(find.text('SCOPE_VETO_ROUTE'), findsOneWidget);
    expect(find.text('CAN_POP:false'), findsOneWidget);
    expect(find.text('LIFETIME:created=1,closed=0,active=1'), findsOneWidget);
    expect(await _backGesture(tester, 'startBackGesture', 0), isFalse);
    await _backGesture(tester, 'commitBackGesture');
    await tester.pumpAndSettle();
    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('SCOPE_VETO_ROUTE'), findsOneWidget);
    expect(find.text('RESULT:pending', skipOffstage: false), findsOneWidget);
    expect(find.text('LIFETIME:created=1,closed=0,active=1'), findsOneWidget);
    expect(
      find.text('GESTURES:started=0,stopped=0,progressed=0'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('ALLOW_SCOPE_BACK'));
    await tester.tap(find.text('ALLOW_SCOPE_BACK'));
    await tester.pumpAndSettle();
    expect(find.text('CAN_POP:true'), findsOneWidget);
    expect(await _backGesture(tester, 'startBackGesture', 0), isTrue);
    await _backGesture(tester, 'updateBackGestureProgress', 0.35);
    expect(
      find.text('GESTURES:started=1,stopped=0,progressed=1'),
      findsNWidgets(2),
    );
    await _backGesture(tester, 'commitBackGesture');
    await tester.pumpAndSettle();
    expect(find.text('ROOT_ROUTE'), findsOneWidget);
    expect(find.text('RESULT:null'), findsOneWidget);
    expect(find.text('LIFETIME:created=1,closed=1,active=0'), findsOneWidget);
    expect(
      find.text('GESTURES:started=1,stopped=1,progressed=1'),
      findsOneWidget,
    );
    expect(Get.rootController.rootDelegate.canBack, isFalse);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}

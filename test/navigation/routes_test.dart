import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Back swipe dismiss interrupted by route push', (tester) async {
    // final scaffoldKey = GlobalKey();

    await tester.pumpWidget(
      GetCupertinoApp(
        popGesture: true,
        home: CupertinoPageScaffold(
          // key: scaffoldKey,
          child: Center(
            child: CupertinoButton(
              onPressed: () {
                Get.to(() => CupertinoPageScaffold(
                      child: Center(child: Text('route')),
                    ));
              },
              child: const Text('push'),
            ),
          ),
        ),
      ),
    );

    // Check the basic iOS back-swipe dismiss transition. Dragging the pushed
    // route halfway across the screen will trigger the iOS dismiss animation

    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
    expect(find.text('push'), findsNothing);

    var gesture = await tester.startGesture(const Offset(5, 300));
    await gesture.moveBy(const Offset(400, 0));
    await gesture.up();
    await tester.pump();
    expect(
      // The 'route' route has been dragged to the right, halfway across
      // the screen
      tester.getTopLeft(find.ancestor(
          of: find.text('route'),
          matching: find.byType(CupertinoPageScaffold))),
      const Offset(400, 0),
    );
    expect(
      // The 'push' route is sliding in from the left.
      tester
          .getTopLeft(find.ancestor(
              of: find.text('push'),
              matching: find.byType(CupertinoPageScaffold)))
          .dx,
      0,
    );
    await tester.pumpAndSettle();
    expect(find.text('push'), findsOneWidget);
    expect(
      tester.getTopLeft(find.ancestor(
          of: find.text('push'), matching: find.byType(CupertinoPageScaffold))),
      Offset.zero,
    );
    expect(find.text('route'), findsNothing);

    // Run the dismiss animation 60%, which exposes the route "push" button,
    // and then press the button.

    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
    expect(find.text('push'), findsNothing);

    gesture = await tester.startGesture(const Offset(5, 300));
    await gesture.moveBy(const Offset(400, 0)); // Drag halfway.
    await gesture.up();
    // Trigger the snapping animation.
    // Since the back swipe drag was brought to >=50% of the screen, it will
    // self snap to finish the pop transition as the gesture is lifted.
    //
    // This drag drop animation is 400ms when dropped exactly halfway
    // (800 / [pixel distance remaining], see
    // _CupertinoBackGestureController.dragEnd). It follows a curve that is very
    // steep initially.
    await tester.pump();
    expect(
      tester.getTopLeft(find.ancestor(
          of: find.text('route'),
          matching: find.byType(CupertinoPageScaffold))),
      const Offset(400, 0),
    );
    // Let the dismissing snapping animation go 60%.
    await tester.pump(const Duration(milliseconds: 240));
    expect(
      tester
          .getTopLeft(find.ancestor(
              of: find.text('route'),
              matching: find.byType(CupertinoPageScaffold)))
          .dx,
      moreOrLessEquals(798, epsilon: 1),
    );

    // Use the navigator to push a route instead of tapping the 'push' button.
    // The topmost route (the one that's animating away), ignores input while
    // the pop is underway because route.navigator.userGestureInProgress.
    Get.to(() => const CupertinoPageScaffold(
          child: Center(child: Text('route')),
        ));

    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
    expect(find.text('push'), findsNothing);
    expect(
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .userGestureInProgress,
      false,
    );
  });
}

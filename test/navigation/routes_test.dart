import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  // testWidgets('Back swipe dismiss interrupted by route push',
  // (tester) async {
  //   // final scaffoldKey = GlobalKey();

  //   await tester.pumpWidget(
  //     GetCupertinoApp(
  //       popGesture: true,
  //       home: CupertinoPageScaffold(
  //         // key: scaffoldKey,
  //         child: Center(
  //           child: CupertinoButton(
  //             onPressed: () {
  //               Get.to(
  //                   () => CupertinoPageScaffold(
  //                         child: Center(child: Text('route')),
  //                       ),
  //                   preventDuplicateHandlingMode:
  //                       PreventDuplicateHandlingMode.Recreate);
  //             },
  //             child: const Text('push'),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   // Check the basic iOS back-swipe dismiss transition. Dragging the pushed
  //   // route halfway across the screen will trigger the iOS dismiss animation

  //   await tester.tap(find.text('push'));
  //   await tester.pumpAndSettle();
  //   expect(find.text('route'), findsOneWidget);
  //   expect(find.text('push'), findsNothing);

  //   var gesture = await tester.startGesture(const Offset(5, 300));
  //   await gesture.moveBy(const Offset(400, 0));
  //   await gesture.up();
  //   await tester.pump();
  //   expect(
  //     // The 'route' route has been dragged to the right, halfway across
  //     // the screen
  //     tester.getTopLeft(find.ancestor(
  //         of: find.text('route'),
  //         matching: find.byType(CupertinoPageScaffold))),
  //     const Offset(400, 0),
  //   );
  //   expect(
  //     // The 'push' route is sliding in from the left.
  //     tester
  //         .getTopLeft(find.ancestor(
  //             of: find.text('push'),
  //             matching: find.byType(CupertinoPageScaffold)))
  //         .dx,
  //     moreOrLessEquals(-(400 / 3), epsilon: 1),
  //   );
  //   await tester.pumpAndSettle();
  //   expect(find.text('push'), findsOneWidget);
  //   expect(
  //     tester.getTopLeft(find.ancestor(
  //         of: find.text('push'),
  // matching: find.byType(CupertinoPageScaffold))),
  //     Offset.zero,
  //   );
  //   expect(find.text('route'), findsNothing);

  //   // Run the dismiss animation 60%, which exposes the route "push" button,
  //   // and then press the button.

  //   await tester.tap(find.text('push'));
  //   await tester.pumpAndSettle();
  //   expect(find.text('route'), findsOneWidget);
  //   expect(find.text('push'), findsNothing);

  //   gesture = await tester.startGesture(const Offset(5, 300));
  //   await gesture.moveBy(const Offset(400, 0)); // Drag halfway.
  //   await gesture.up();
  //   // Trigger the snapping animation.
  //   // Since the back swipe drag was brought to >=50% of the screen, it will
  //   // self snap to finish the pop transition as the gesture is lifted.
  //   //
  //   // This drag drop animation is 400ms when dropped exactly halfway
  //   // (800 / [pixel distance remaining], see
  //   // _CupertinoBackGestureController.dragEnd). It follows a curve that is very
  //   // steep initially.
  //   await tester.pump();
  //   expect(
  //     tester.getTopLeft(find.ancestor(
  //         of: find.text('route'),
  //         matching: find.byType(CupertinoPageScaffold))),
  //     const Offset(400, 0),
  //   );
  //   // Let the dismissing snapping animation go 60%.
  //   await tester.pump(const Duration(milliseconds: 240));
  //   expect(
  //     tester
  //         .getTopLeft(find.ancestor(
  //             of: find.text('route'),
  //             matching: find.byType(CupertinoPageScaffold)))
  //         .dx,
  //     moreOrLessEquals(798, epsilon: 1),
  //   );
  // });
  testWidgets("test previousTitle dispose", (tester) async {
    GetPageRoute? secondRoute;
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
      ],
      navigatorObservers: [
        GetObserver(
          (routing) {
            if (routing?.current == '/second') {
              secondRoute = routing?.route as GetPageRoute?;
            }
          },
          Routing(),
        ),
      ],
    ));

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    assert(secondRoute != null);

    ValueNotifier<String?> previousTitle =
        secondRoute?.previousTitle as ValueNotifier<String?>;

    // Check if the previousTitle not disposed
    bool isNoDisposed = ChangeNotifier.debugAssertNotDisposed(previousTitle);

    assert(isNoDisposed, true);

    Get.back();

    await tester.pumpAndSettle();

    try {
      // Check whether previousTitle has been disposed
      // if disposed, an exception will be thrown
      isNoDisposed = ChangeNotifier.debugAssertNotDisposed(previousTitle);
      expect(isNoDisposed, false);
    } catch (e) {
      expect(e.toString(),
          contains("A ValueNotifier<String?> was used after being disposed."));
    }
  });
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(child: const Text('FirstScreen'));
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

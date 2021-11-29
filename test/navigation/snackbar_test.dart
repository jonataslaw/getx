import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets("test if Get.isSnackbarOpen works with Get.snackbar",
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: true,
        home: ElevatedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.snackbar(
              'title',
              "message",
              duration: Duration(seconds: 1),
              mainButton: TextButton(onPressed: () {}, child: Text('button')),
              isDismissible: false,
            );
          },
        ),
      ),
    );

    expect(Get.isSnackbarOpen, false);
    await tester.tap(find.text('Open Snackbar'));

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(seconds: 1));
    expect(Get.isSnackbarOpen, false);
  });

  testWidgets("Get.rawSnackbar test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: true,
        home: ElevatedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.rawSnackbar(
              title: 'title',
              message: "message",
              onTap: (_) {
                print('snackbar tapped');
              },
              shouldIconPulse: true,
              icon: Icon(Icons.alarm),
              showProgressIndicator: true,
              duration: Duration(seconds: 1),
              isDismissible: true,
              leftBarIndicatorColor: Colors.amber,
              overlayBlur: 1.0,
            );
          },
        ),
      ),
    );

    expect(Get.isSnackbarOpen, false);
    await tester.tap(find.text('Open Snackbar'));

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(seconds: 1));
    expect(Get.isSnackbarOpen, false);
  });

  testWidgets("test snackbar queue", (tester) async {
    final messageOne = Text('title');

    final messageTwo = Text('titleTwo');

    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: true,
        home: ElevatedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.rawSnackbar(
                messageText: messageOne, duration: Duration(seconds: 1));
            Get.rawSnackbar(
                messageText: messageTwo, duration: Duration(seconds: 1));
          },
        ),
      ),
    );

    expect(Get.isSnackbarOpen, false);
    await tester.tap(find.text('Open Snackbar'));
    expect(Get.isSnackbarOpen, true);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('title'), findsOneWidget);
    expect(find.text('titleTwo'), findsNothing);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('title'), findsNothing);
    expect(find.text('titleTwo'), findsOneWidget);
    Get.closeAllSnackbars();
  });

  testWidgets("test snackbar dismissible", (tester) async {
    const dismissDirection = DismissDirection.vertical;
    const snackBarTapTarget = Key('snackbar-tap-target');

    late final GetSnackBar getBar;

    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  key: snackBarTapTarget,
                  onTap: () {
                    getBar = GetSnackBar(
                      message: 'bar1',
                      icon: Icon(Icons.alarm),
                      mainButton:
                          TextButton(onPressed: () {}, child: Text('button')),
                      duration: const Duration(seconds: 2),
                      isDismissible: true,
                      dismissDirection: dismissDirection,
                    );
                    Get.showSnackbar(getBar);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ));

    expect(Get.isSnackbarOpen, false);
    expect(find.text('bar1'), findsNothing);

    await tester.tap(find.byKey(snackBarTapTarget));
    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byWidget(getBar), findsOneWidget);
    await tester.ensureVisible(find.byWidget(getBar));
    await tester.drag(find.byWidget(getBar), Offset(0.0, 50.0));
    await tester.pump(const Duration(milliseconds: 500));

    expect(Get.isSnackbarOpen, false);
  });

  testWidgets("test snackbar onTap", (tester) async {
    const dismissDirection = DismissDirection.vertical;
    const snackBarTapTarget = Key('snackbar-tap-target');
    var counter = 0;

    late final GetSnackBar getBar;

    late final SnackbarController getBarController;

    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  key: snackBarTapTarget,
                  onTap: () {
                    getBar = GetSnackBar(
                      message: 'bar1',
                      onTap: (_) {
                        counter++;
                      },
                      duration: const Duration(seconds: 2),
                      isDismissible: true,
                      dismissDirection: dismissDirection,
                    );
                    getBarController = Get.showSnackbar(getBar);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, false);
    expect(find.text('bar1'), findsNothing);

    await tester.tap(find.byKey(snackBarTapTarget));
    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byWidget(getBar), findsOneWidget);
    await tester.ensureVisible(find.byWidget(getBar));
    await tester.tap(find.byWidget(getBar));
    expect(counter, 1);
    await tester.pump(const Duration(milliseconds: 3000));
    await getBarController.close(withAnimations: false);
  });
}

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
          child: const Text('Open Snackbar'),
          onPressed: () {
            Get.snackbar(
              'title',
              "message",
              duration: const Duration(seconds: 1),
              mainButton:
                  TextButton(onPressed: () {}, child: const Text('button')),
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
          child: const Text('Open Snackbar'),
          onPressed: () {
            Get.rawSnackbar(
              title: 'title',
              message: "message",
              onTap: (_) {
                debugPrint('snackbar tapped');
              },
              shouldIconPulse: true,
              icon: const Icon(Icons.alarm),
              showProgressIndicator: true,
              duration: const Duration(seconds: 1),
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
    const messageOne = Text('title');

    const messageTwo = Text('titleTwo');

    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: true,
        home: ElevatedButton(
          child: const Text('Open Snackbar'),
          onPressed: () {
            Get.rawSnackbar(
                messageText: messageOne, duration: const Duration(seconds: 1));
            Get.rawSnackbar(
                messageText: messageTwo, duration: const Duration(seconds: 1));
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
                    getBar = const GetSnackBar(
                      message: 'bar1',
                      duration: Duration(seconds: 2),
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
    await tester.drag(find.byWidget(getBar), const Offset(0.0, 50.0));
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

  testWidgets("Get test actions and icon", (tester) async {
    const icon = Icon(Icons.alarm);
    final action = TextButton(onPressed: () {}, child: const Text('button'));

    late final GetSnackBar getBar;

    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

    expect(Get.isSnackbarOpen, false);
    expect(find.text('bar1'), findsNothing);

    getBar = GetSnackBar(
      message: 'bar1',
      icon: icon,
      mainButton: action,
      leftBarIndicatorColor: Colors.yellow,
      showProgressIndicator: true,
      // maxWidth: 100,
      borderColor: Colors.red,
      duration: const Duration(seconds: 1),
      isDismissible: false,
    );
    Get.showSnackbar(getBar);

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byWidget(getBar), findsOneWidget);
    expect(find.byWidget(icon), findsOneWidget);
    expect(find.byWidget(action), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));

    expect(Get.isSnackbarOpen, false);
  });
}

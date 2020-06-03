import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets(
    "GetMaterialApp with routes null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                routes: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with navigatorObservers null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                navigatorObservers: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with title null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                title: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with debugShowMaterialGrid null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                debugShowMaterialGrid: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with showPerformanceOverlay null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                showPerformanceOverlay: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with showSemanticsDebugger null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                showSemanticsDebugger: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with debugShowCheckedModeBanner null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                debugShowCheckedModeBanner: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with checkerboardRasterCacheImages null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                checkerboardRasterCacheImages: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with checkerboardOffscreenLayers null",
    (WidgetTester testr) async {
      expect(
          () => GetMaterialApp(
                checkerboardOffscreenLayers: null,
              ),
          throwsAssertionError);
    },
  );
}

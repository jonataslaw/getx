import 'package:flutter_test/flutter_test.dart';
import 'package:get_navigation/get_navigation.dart';

void main() {
  testWidgets(
    "GetMaterialApp with routes null",
    (tester) async {
      expect(
          () => GetMaterialApp(
                routes: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with navigatorObservers null",
    (tester) async {
      expect(
          () => GetMaterialApp(
                navigatorObservers: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with title null",
    (tester) async {
      expect(
          () => GetMaterialApp(
                title: null,
              ),
          throwsAssertionError);
    },
  );
  testWidgets(
    "GetMaterialApp with debugShowMaterialGrid null",
    (test) async {
      expect(
        () => GetMaterialApp(
          debugShowMaterialGrid: null,
        ),
        throwsAssertionError,
      );
    },
  );
  testWidgets(
    "GetMaterialApp with showPerformanceOverlay null",
    (test) async {
      expect(
        () => GetMaterialApp(
          showPerformanceOverlay: null,
        ),
        throwsAssertionError,
      );
    },
  );
  testWidgets(
    "GetMaterialApp with showSemanticsDebugger null",
    (test) async {
      expect(
        () => GetMaterialApp(
          showSemanticsDebugger: null,
        ),
        throwsAssertionError,
      );
    },
  );
  testWidgets(
    "GetMaterialApp with debugShowCheckedModeBanner null",
    (tester) async {
      expect(
          () => GetMaterialApp(
                debugShowCheckedModeBanner: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with checkerboardRasterCacheImages null",
    (tester) async {
      expect(
          () => GetMaterialApp(
                checkerboardRasterCacheImages: null,
              ),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetMaterialApp with checkerboardOffscreenLayers null",
    (tester) async {
      expect(
        () => GetMaterialApp(
          checkerboardOffscreenLayers: null,
        ),
        throwsAssertionError,
      );
    },
  );
}

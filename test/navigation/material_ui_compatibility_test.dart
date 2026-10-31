import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('GetMaterialApp accepts standalone Material theme types', (
    tester,
  ) async {
    final theme = ThemeData();
    final darkTheme = ThemeData.dark();

    await tester.pumpWidget(
      GetMaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: const _ThemeProbe(),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(_ThemeProbe));
    final ThemeData resolvedTheme = context.theme;

    expect(resolvedTheme.brightness, Brightness.dark);
    expect(find.text(Brightness.dark.name), findsOneWidget);
  });

  testWidgets(
    'Get.changeTheme and Get.changeThemeMode accept standalone Material types',
    (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          home: const _ThemeProbe(),
        ),
      );
      await tester.pumpAndSettle();

      Get.changeTheme(ThemeData.dark());
      Get.changeThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(_ThemeProbe));
      final ThemeData resolvedTheme = context.theme;

      expect(resolvedTheme.brightness, Brightness.dark);
    },
  );
}

class _ThemeProbe extends StatelessWidget {
  const _ThemeProbe();

  @override
  Widget build(BuildContext context) {
    return Text(context.theme.brightness.name);
  }
}

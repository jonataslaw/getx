import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pumpToMidTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 100));
}

Future<double> _homeSecondaryAnimationMidTransition(
  WidgetTester tester,
  void Function(BuildContext homeContext) push,
) async {
  await tester.pumpWidget(GetMaterialApp(home: const _HomePage()));
  await tester.pumpAndSettle();

  final homeContext = tester.element(find.text('home'));
  push(homeContext);
  await _pumpToMidTransition(tester);

  final value = ModalRoute.of(homeContext)!.secondaryAnimation!.value;
  await tester.pumpAndSettle();
  return value;
}

void main() {
  tearDown(() => Get.reset());

  testWidgets(
    'previous GetPageRoute animates out when a MaterialPageRoute is pushed',
    (tester) async {
      final value = await _homeSecondaryAnimationMidTransition(
        tester,
        (context) => Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const _NextPage())),
      );

      expect(value, greaterThan(0.0));
    },
  );

  testWidgets(
    'previous GetPageRoute does not animate out for a fullscreen dialog',
    (tester) async {
      final value = await _homeSecondaryAnimationMidTransition(
        tester,
        (context) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => const _NextPage(),
          ),
        ),
      );

      expect(value, 0.0);
    },
  );

  testWidgets('previous GetPageRoute animates out when Get.to is used', (
    tester,
  ) async {
    final value = await _homeSecondaryAnimationMidTransition(
      tester,
      (_) => Get.to(() => const _NextPage()),
    );

    expect(value, greaterThan(0.0));
  });

  testWidgets(
    'previous GetPageRoute stays still when showCupertinoParallax is false',
    (tester) async {
      final value = await _homeSecondaryAnimationMidTransition(
        tester,
        (_) => Get.to(() => const _NextPage(), showCupertinoParallax: false),
      );

      expect(value, 0.0);
    },
  );

  group('with a transition builder that moves the previous page', () {
    final theme = ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    double homeX(WidgetTester tester) =>
        tester.getTopLeft(find.text('home', skipOffstage: false)).dx;

    testWidgets(
      'previous page slides out while a MaterialPageRoute is pushed',
      (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(theme: theme, home: const _HomePage()),
        );
        await tester.pumpAndSettle();
        final restingX = homeX(tester);

        Navigator.of(tester.element(find.text('home')))
            .push(MaterialPageRoute<void>(builder: (_) => const _NextPage()));
        await _pumpToMidTransition(tester);

        expect(homeX(tester), lessThan(restingX));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'previous page slides back while a MaterialPageRoute is popped',
      (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(theme: theme, home: const _HomePage()),
        );
        await tester.pumpAndSettle();
        final restingX = homeX(tester);

        final navigator = Navigator.of(tester.element(find.text('home')));
        navigator.push(
          MaterialPageRoute<void>(builder: (_) => const _NextPage()),
        );
        await tester.pumpAndSettle();
        final coveredX = homeX(tester);
        expect(coveredX, lessThan(restingX));

        navigator.pop();
        await _pumpToMidTransition(tester);

        final midPopX = homeX(tester);
        expect(midPopX, greaterThan(coveredX));
        expect(midPopX, lessThan(restingX));

        await tester.pumpAndSettle();
        expect(homeX(tester), restingX);
      },
    );
  });
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('home'));
  }
}

class _NextPage extends StatelessWidget {
  const _NextPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('next'));
  }
}

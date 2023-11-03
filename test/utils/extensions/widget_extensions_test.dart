import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

class Foo extends StatelessWidget {
  const Foo({super.key});

  @override
  Widget build(final BuildContext context) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('Group test for PaddingX Extension', () {
    testWidgets('Test of paddingAll', (final tester) async {
      const Widget containerTest = Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingAll(16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingOnly', (final tester) async {
      const Widget containerTest = Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingOnly(top: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingSymmetric', (final tester) async {
      const Widget containerTest = Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingSymmetric(vertical: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingZero', (final tester) async {
      const Widget containerTest = Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingZero);

      expect(find.byType(Padding), findsOneWidget);
    });
  });

  group('Group test for MarginX Extension', () {
    testWidgets('Test of marginAll', (final tester) async {
      const Widget containerTest = Foo();

      await tester.pumpWidget(containerTest.marginAll(16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginOnly', (final tester) async {
      const Widget containerTest = Foo();

      await tester.pumpWidget(containerTest.marginOnly(top: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginSymmetric', (final tester) async {
      const Widget containerTest = Foo();

      await tester.pumpWidget(containerTest.marginSymmetric(vertical: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginZero', (final tester) async {
      const Widget containerTest = Foo();

      await tester.pumpWidget(containerTest.marginZero);

      expect(find.byType(Container), findsOneWidget);
    });
  });
}

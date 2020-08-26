import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

void main() {
  group('Group test for PaddingX Extension', () {
    testWidgets('Test of paddingAll', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingAll(16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingOnly', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingOnly(top: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingSymmetric', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingSymmetric(vertical: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingZero', (WidgetTester tester) async {
      Widget containerTest;

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingZero);

      expect(find.byType(Padding), findsOneWidget);
    });
  });

  group('Group test for MarginX Extension', () {
    testWidgets('Test of marginAll', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginAll(16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginOnly', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginOnly(top: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginSymmetric', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginSymmetric(vertical: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginZero', (WidgetTester tester) async {
      Widget containerTest;

      await tester.pumpWidget(containerTest.marginZero);

      expect(find.byType(Container), findsOneWidget);
    });
  });
}

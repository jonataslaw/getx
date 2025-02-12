import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

class Foo extends StatelessWidget {
  const Foo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('Group test for PaddingX Extension', () {
    testWidgets('Test of paddingAll', (tester) async {
      Widget containerTest = const Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingAll(16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingOnly', (tester) async {
      Widget containerTest = const Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingOnly(top: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingSymmetric', (tester) async {
      Widget containerTest = const Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingSymmetric(vertical: 16));

      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('Test of paddingZero', (tester) async {
      Widget containerTest = const Foo();

      expect(find.byType(Padding), findsNothing);

      await tester.pumpWidget(containerTest.paddingZero);

      expect(find.byType(Padding), findsOneWidget);
    });
  });

  group('Group test for MarginX Extension', () {
    testWidgets('Test of marginAll', (tester) async {
      Widget containerTest = const Foo();

      await tester.pumpWidget(containerTest.marginAll(16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginOnly', (tester) async {
      Widget containerTest = const Foo();

      await tester.pumpWidget(containerTest.marginOnly(top: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginSymmetric', (tester) async {
      Widget containerTest = const Foo();

      await tester.pumpWidget(containerTest.marginSymmetric(vertical: 16));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test of marginZero', (tester) async {
      Widget containerTest = const Foo();

      await tester.pumpWidget(containerTest.marginZero);

      expect(find.byType(Container), findsOneWidget);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

final _created = <_FormController>[];

class _FormController extends GetxController {
  _FormController() {
    _created.add(this);
  }

  final textController = TextEditingController();

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

class _FormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => _FormController());
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('home'));
  }
}

class _FormPage extends GetView<_FormController> {
  const _FormPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TextField(controller: controller.textController));
  }
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const _HomePage()),
        GetPage(
          name: '/form',
          page: () => const _FormPage(),
          binding: _FormBinding(),
        ),
      ],
    ),
  );
}

Future<void> _openFormThenGoBackAndReopen(
  WidgetTester tester, {
  required Duration delayBeforeReopen,
}) async {
  Get.toNamed('/form');
  await tester.pumpAndSettle();

  Get.back();
  await tester.pump();
  await tester.pump(delayBeforeReopen);

  Get.toNamed('/form');
  await tester.pumpAndSettle();
}

void main() {
  setUp(_created.clear);
  tearDown(() => Get.reset());

  for (final delay in const [Duration.zero, Duration(milliseconds: 150)]) {
    testWidgets(
      'reopening a route while it is popping gives it a new controller '
      '(reopened after ${delay.inMilliseconds}ms)',
      (tester) async {
        await _pumpApp(tester);
        await _openFormThenGoBackAndReopen(tester, delayBeforeReopen: delay);

        expect(_created, hasLength(2));
        final [first, second] = _created;
        expect(first.isClosed, isTrue);
        expect(second.isClosed, isFalse);
        expect(Get.find<_FormController>(), same(second));

        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.controller, same(second.textController));

        await tester.enterText(find.byType(TextField), 'typed');
        await tester.pump();
        expect(second.textController.text, 'typed');
      },
    );
  }

  testWidgets('controller of the reopened route is deleted when it is closed', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openFormThenGoBackAndReopen(
      tester,
      delayBeforeReopen: const Duration(milliseconds: 150),
    );

    Get.back();
    await tester.pumpAndSettle();

    expect(_created, hasLength(2));
    expect(_created.every((c) => c.isClosed), isTrue);
    expect(Get.isRegistered<_FormController>(), isFalse);
  });

  testWidgets('controller is deleted when its route is popped', (tester) async {
    await _pumpApp(tester);

    Get.toNamed('/form');
    await tester.pumpAndSettle();
    Get.back();
    await tester.pumpAndSettle();

    expect(_created, hasLength(1));
    expect(_created.single.isClosed, isTrue);
    expect(Get.isRegistered<_FormController>(), isFalse);
  });
}

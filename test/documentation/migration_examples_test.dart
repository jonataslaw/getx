import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';

class ItemController {}

class Settings {}

class HomeController extends GetxController {}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<HomeController>(() => HomeController()),
      ];
}

class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);
  void load(Future<List<String>> Function() fetch) {
    futurize(fetch);
  }
}

class Person {
  const Person(this.name);
  final String name;
}

final person = const Person('John').obs;
void renamePerson() {
  person.update((previous) => const Person('Roi'));
}

void factoryExample() {
  Get.spawn<ItemController>(() => ItemController(), tag: 'item');
  final first = Get.find<ItemController>(tag: 'item');
  final second = Get.find<ItemController>(tag: 'item');
  assert(!identical(first, second));
}

Future<void> registerSettings(Future<Settings> Function() load) async {
  final settings = await load();
  Get.put<Settings>(settings, permanent: true);
}

GetPage<void> routeExample() => GetPage<void>(
      name: '/home',
      page: () => const HomePage(),
      bindings: [HomeBinding()],
    );
Widget rootExample() => GetMaterialApp(
      binds: [Bind.lazyPut<HomeController>(() => HomeController())],
      home: const HomePage(),
    );
Widget outletExample() => GetRouterOutlet(
      anchorRoute: '/shell',
      initialRoute: '/shell/home',
    );
void directRouteExample() {
  Get.to<void>(() => const HomePage(), bindings: [HomeBinding()]);
}

Future<bool?> resultExample() async {
  return await Get.to<bool>(() => const HomePage());
}

void closingExamples() {
  Get.back<bool>(result: true);
  Get.back(times: 2);
  Get.closeDialog<bool>(result: true);
  Get.closeOverlay<bool>(result: true);
  Get.closeCurrentSnackbar();
  Get.closeAllSnackbars();
  Get.close();
  Get.backLegacy();
}

void main() {
  tearDown(Get.reset);
  test('factory migration returns independent instances', factoryExample);
  test('initialized dependency can be registered', () async {
    await registerSettings(() async => Settings());
    expect(Get.isRegistered<Settings>(), isTrue);
  });
  test('immutable Rx update replaces the value', () {
    renamePerson();
    expect(person.value.name, 'Roi');
  });
  test('StateMixin migration uses typed statuses', () {
    final controller = NamesController();
    controller.showNames(['Ada']);
    expect(controller.status.isSuccess, isTrue);
    expect(controller.state, ['Ada']);
    controller.showEmpty();
    expect(controller.status.isEmpty, isTrue);
    controller.showError('failure');
    expect(controller.status.isError, isTrue);
    controller.showLoading();
    expect(controller.status.isLoading, isTrue);
    controller.dispose();
  });
  testWidgets('root bindings migration builds and disposes', (tester) async {
    await tester.pumpWidget(rootExample());
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    expect(Get.isRegistered<HomeController>(), isFalse);
  });
}

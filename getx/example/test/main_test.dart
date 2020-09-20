import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_demo/pages/home/domain/adapters/repository_adapter.dart';
import 'package:get_demo/pages/home/domain/entity/cases_model.dart';
import 'package:get_demo/pages/home/presentation/controllers/home_controller.dart';
import 'package:get_demo/routes/app_pages.dart';
import 'package:get_test/get_test.dart';
import 'package:matcher/matcher.dart' as m;

class MockRepository implements IHomeRepository {
  @override
  Future<CasesModel> getCases() async {
    await Future.delayed(Duration(milliseconds: 100));

    if (Random().nextBool()) {
      return CasesModel(
        global: Global(totalDeaths: 100, totalConfirmed: 200),
      );
    }

    return Future<CasesModel>.error('error');
  }
}

void main() {
  final binding = BindingsBuilder(() {
    Get.lazyPut<IHomeRepository>(() => MockRepository());
    Get.lazyPut<HomeController>(
        () => HomeController(homeRepository: Get.find()));
  });

  test('Test Binding', () {
    expect(Get.isPrepared<HomeController>(), false);
    expect(Get.isPrepared<IHomeRepository>(), false);

    /// test you Binding class with BindingsBuilder
    binding.builder();

    expect(Get.isPrepared<HomeController>(), true);
    expect(Get.isPrepared<IHomeRepository>(), true);

    Get.reset();
  });
  test('Test Controller', () async {
    /// Controller can't be on memory
    expect(() => Get.find<HomeController>(), throwsA(m.TypeMatcher<String>()));

    /// build Binding
    binding.builder();

    /// recover your controller
    final controller = Get.find<HomeController>();

    /// check if onInit was called
    expect(controller.initialized, true);

    /// check initial Status
    expect(controller.status.value, Status.loading);

    /// await time request
    await Future.delayed(Duration(milliseconds: 100));

    if (controller.status.value == Status.error) {
      expect(controller.cases.value, null);
    }

    if (controller.status.value == Status.success) {
      expect(controller.cases.value.global.totalDeaths, 100);
      expect(controller.cases.value.global.totalConfirmed, 200);
    }
  });

  /// Tests with GetTests
  getTest(
    "test description",
    getPages: AppPages.routes,
    initialRoute: AppPages.INITIAL,
    widgetTest: (tester) async {
      expect('/home', Get.currentRoute);

      Get.toNamed('/country');
      expect('/country', Get.currentRoute);

      Get.toNamed('/details');
      expect('/details', Get.currentRoute);

      Get.back();

      expect('/country', Get.currentRoute);
    },
  );

  testGetX(
    'GetX test',
    widget: GetX<Controller>(
      init: Controller(),
      builder: (controller) {
        return Text("ban:${controller.count}");
      },
    ),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testGetBuilder(
    'GetBuilder test',
    widget: GetBuilder<Controller>(
      init: Controller(),
      builder: (controller) {
        return Text("ban:${controller.count}");
      },
    ),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testObx(
    'Obx test',
    widget: (controller) => Obx(
      () => Text("ban:${controller.count}"),
    ),
    controller: Controller(),
    test: (e) {
      expect(find.text("ban:0"), findsOneWidget);
      expect(e.count.value, 0);
    },
  );

  testController<Controller>(
    'Controller test',
    (controller) {
      print('controllllllll ${controller.count}');
    },
    controller: Controller(),
    onInit: (c) {
      c.increment();
      print('onInit');
    },
    onReady: (c) {
      print('onReady');
      c.increment();
    },
    onClose: (c) {
      print('onClose');
    },
  );
}

class Controller extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;

  @override
  void onInit() {
    print('inittt');
    super.onInit();
  }

  @override
  void onReady() {
    print('onReady');
    super.onReady();
  }

  void onClose() {
    print('onClose');
  }
}

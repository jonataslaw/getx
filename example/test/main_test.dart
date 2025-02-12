import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_demo/pages/home/domain/adapters/repository_adapter.dart';
import 'package:get_demo/pages/home/domain/entity/cases_model.dart';
import 'package:get_demo/pages/home/presentation/controllers/home_controller.dart';
// import 'package:get_demo/routes/app_pages.dart';
// import 'package:get_test/get_test.dart';
import 'package:matcher/matcher.dart' as m;

class MockRepository implements IHomeRepository {
  @override
  Future<CasesModel> getCases() async {
    await Future.delayed(Duration(milliseconds: 100));

    if (Random().nextBool()) {
      return CasesModel(
        global: Global(
            totalDeaths: 100,
            totalConfirmed: 200,
            date: DateTime.now(),
            newConfirmed: 0,
            newDeaths: 0,
            newRecovered: 0,
            totalRecovered: 0),
        countries: [],
        date: DateTime.now(),
        id: '',
        message: '',
      );
    }

    return Future<CasesModel>.error('error');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = null);
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
    expect(controller.status.isLoading, true);

    /// await time request
    await Future.delayed(Duration(milliseconds: 100));

    if (controller.status.isError) {
      expect(controller.state, null);
    }

    if (controller.status.isSuccess) {
      expect(controller.state!.global.totalDeaths, 100);
      expect(controller.state!.global.totalConfirmed, 200);
    }
  });

  test('ever', () async {
    final count = ''.obs;
    var result = '';
    ever<String>(count, (value) {
      result = value;
    });
    count.value = '1';
    expect('1', result);
  });

  /// Tests with GetTests
  /// TEMPORARILY REMOVED from the null-safetym branch as
  /// get_test is not yet null safety.
  /* getTest(
    "test description",
    getPages: AppPages.routes,
    initialRoute: AppPages.INITIAL,
    widgetTest: (tester) async {
      expect('/home', Get.currentRoute);

      Get.toNamed('/home/country');
      expect('/home/country', Get.currentRoute);

      Get.toNamed('/home/country/details');
      expect('/home/country/details', Get.currentRoute);

      Get.back();

      expect('/home/country', Get.currentRoute);
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
  );*/
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

  @override
  void onClose() {
    super.onClose();
    print('onClose');
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
// import 'package:get_demo/routes/app_pages.dart';
// import 'package:get_test/get_test.dart';
import 'package:matcher/matcher.dart' as m;

import '../lib/pages/home/domain/adapters/repository_adapter.dart';
import '../lib/pages/home/domain/entity/cases_model.dart';
import '../lib/pages/home/presentation/controllers/home_controller.dart';

class MockRepositorySuccess implements IHomeRepository {
  @override
  Future<CasesModel> getCases() async {
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
}

class MockRepositoryFailure implements IHomeRepository {
  @override
  Future<CasesModel> getCases() async {
    return Future<CasesModel>.error('error');
  }
}

class MockBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<IHomeRepository>(() => MockRepositorySuccess()),
      Bind.lazyPut<HomeController>(
        () => HomeController(homeRepository: Get.find()),
      )
    ];
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = null);
  final binding = MockBinding();

  test('Test Controller', () async {
    /// Controller can't be on memory
    expect(() => Get.find<HomeController>(tag: 'success'),
        throwsA(m.TypeMatcher<String>()));

    /// binding will put the controller on memory
    binding.dependencies();

    /// recover your controller
    final controller = Get.find<HomeController>();

    /// check if onInit was called
    expect(controller.initialized, true);

    /// check initial Status
    expect(controller.status.isLoading, true);

    /// await time request
    await Future.delayed(Duration(milliseconds: 100));

    /// test if status is success
    expect(controller.status.isSuccess, true);
    expect(controller.state.global.totalDeaths, 100);
    expect(controller.state.global.totalConfirmed, 200);

    /// test if status is error
    Get.lazyReplace<IHomeRepository>(() => MockRepositoryFailure());
    expect(controller.status.isError, true);
    expect(controller.state, null);
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

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_state/pages/home/domain/adapters/repository_adapter.dart';
import 'package:get_state/pages/home/domain/entity/cases_model.dart';
import 'package:get_state/pages/home/presentation/controllers/home_controller.dart';
import 'package:matcher/matcher.dart';

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
    expect(() => Get.find<HomeController>(), throwsA(TypeMatcher<String>()));

    /// build Binding
    binding.builder();

    /// recover your controller
    HomeController controller = Get.find();

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
}

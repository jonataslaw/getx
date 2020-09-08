import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../data/home_repository.dart';
import '../domain/adapters/repository_adapter.dart';
import '../presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());
    Get.lazyPut<IHomeRepository>(() => HomeRepository(dio: Get.find()));
    Get.lazyPut(() => HomeController(homeRepository: Get.find()));
  }
}

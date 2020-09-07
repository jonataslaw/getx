import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_demo/pages/home/domain/adapters/repository_adapter.dart';
import 'package:get_demo/pages/home/presentation/controllers/home_controller.dart';
import '../data/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio());
    Get.lazyPut<IHomeRepository>(() => HomeRepository(dio: Get.find()));
    Get.lazyPut(() => HomeController(homeRepository: Get.find()));
  }
}

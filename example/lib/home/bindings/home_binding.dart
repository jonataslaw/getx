import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../data/home_provider.dart';
import '../data/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() {
      Get.put(Dio());
      Get.put(HomeProvider(dio: Get.find()));
      Get.put(HomeRepository(homeProvider: Get.find()));
      return HomeController(homeRepository: Get.find());
    });
  }
}

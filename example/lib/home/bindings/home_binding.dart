import 'package:get/get.dart';
import 'package:get_state/home/controllers/home_controller.dart';
import 'package:get_state/home/data/home_provider.dart';
import 'package:get_state/home/data/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() {
      final homeProvider = HomeProvider();
      final homeRepository = HomeRepository(homeProvider);
      return HomeController(homeRepository);
    });
  }
}

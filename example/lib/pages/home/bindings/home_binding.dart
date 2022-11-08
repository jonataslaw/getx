import 'package:get/get.dart';

import '../data/home_api_provider.dart';
import '../data/home_repository.dart';
import '../domain/adapters/repository_adapter.dart';
import '../presentation/controllers/home_controller.dart';

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<IHomeProvider>(() => HomeProvider()),
      Bind.lazyPut<IHomeRepository>(() => HomeRepository(provider: Get.find())),
      Bind.lazyPut(() => HomeController(homeRepository: Get.find())),
    ];
  }
}

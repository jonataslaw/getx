import 'package:get/get.dart';
import 'package:get_state/home/data/home_model.dart';
import 'package:get_state/home/data/home_repository.dart';

class HomeController extends GetxController {
  HomeController(this.homeRepository);
  final HomeRepository homeRepository;

  Rx<ApiModel> data = Rx<ApiModel>();

  @override
  void onInit() => fetchDataFromApi();

  void fetchDataFromApi() async {
    data.value = await homeRepository.getData();
    if (data.value == null) {
      Get.snackbar("Error", "Can't connect to server");
    }
  }
}

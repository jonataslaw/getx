import 'package:get/get.dart';

class SettingsController extends GetxController {
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

import 'package:get/get.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
}

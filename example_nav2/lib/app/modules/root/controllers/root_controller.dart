import 'package:get/get.dart';

class RootController extends GetxController {
  //TODO: Implement RootController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
}

import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final now = DateTime.now().obs;
  @override
  void onReady() {
    super.onReady();
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        now.value = DateTime.now();
      },
    );
  }
}

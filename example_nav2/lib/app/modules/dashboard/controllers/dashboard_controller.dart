import 'dart:async';

import 'package:get/get.dart';

class DashboardController extends GetxController {
  final now = DateTime.now().obs;
  Timer? _timer;
  @override
  void onReady() {
    super.onReady();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        now.value = DateTime.now();
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

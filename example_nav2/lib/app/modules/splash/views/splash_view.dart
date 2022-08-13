import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_service.dart';

class SplashView extends GetView<SplashService> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Text(
                controller.welcomeStr[controller.activeStr.value],
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

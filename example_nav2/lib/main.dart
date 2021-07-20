import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/splash',
    getPages: [
      GetPage(
        name: '/splash',
        page: () => SplashPage(),
        binding: SplashBinding(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginPage(),
        binding: LoginBinding(),
      ),
    ],
  ));
}

class SplashPage extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash')),
      body: Center(
        child: RaisedButton(
          onPressed: () => Get.offNamed('/login'),
          child: Obx(() => Text(
              'Login ${controller.service.title} >>> ${controller.service.counter}')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.service.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController()); // or lazyPut
    Get.lazyPut(() => SplashController(service: Get.find()));
  }
}

class SplashController extends GetxController {
  // final service = Get.find<ServiceController>();
  final ServiceController service;
  SplashController({
    required this.service,
  });
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController()); // or lazyPut
    Get.lazyPut(() => LoginController(service: Get.find()));
  }
}

class LoginController extends GetxController {
  // final service = Get.find<ServiceController>();
  final ServiceController service;
  LoginController({
    required this.service,
  });
}

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Obx(() => Text(
            'Login ${controller.service.title} >>> ${controller.service.counter}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.service.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ServiceController extends GetxController {
  final title = Random().nextInt(99999).toString();
  final counter = 0.obs;

  increment() => counter.value++;

  @override
  void onInit() {
    print('onInit $counter');
    super.onInit();
  }

  @override
  void onClose() {
    print('onClose $counter');
    super.onClose();
  }
}

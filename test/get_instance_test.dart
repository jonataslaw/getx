import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class Mock {
  static Future<String> test() async {
    await Future.delayed(Duration.zero);
    return 'test';
  }
}

class Controller {}

abstract class Service {
  String post();
}

class Api implements Service {
  @override
  String post() {
    return 'test';
  }
}

void main() {
  test('Get.putAsync test', () async {
    await Get.putAsync<String>(() => Mock.test());
    expect('test', Get.find<String>());
    Get.reset();
  });

  test('Get.put test', () async {
    final instance = Get.put<Controller>(Controller());
    expect(instance, Get.find<Controller>());
    Get.reset();
  });

  test('Get.lazyPut test', () async {
    final controller = Controller();
    Get.lazyPut<Controller>(() => controller);
    final ct1 = Get.find<Controller>();
    expect(ct1, controller);
    Get.reset();
  });

  test('Get.lazyPut with abstract class test', () async {
    final api = Api();
    Get.lazyPut<Service>(() => api);
    final ct1 = Get.find<Service>();
    expect(ct1, api);
    Get.reset();
  });
}

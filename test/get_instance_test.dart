import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:get/get.dart';

class Mock {
  static Future<String> test() async {
    await Future.delayed(Duration.zero);
    return 'test';
  }
}

class Controller {}

class DisposableController extends DisposableInterface {
  bool initialized = false;

  void onInit() async {
    initialized = true;
  }
}

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

  test('Get.create with abstract class test', () async {
    Get.create<Service>(() => Api());
    final ct1 = Get.find<Service>();
    final ct2 = Get.find<Service>();
    expect(ct1 is Service, true);
    expect(ct2 is Service, true);
    expect(ct1 == ct2, false);
    Get.reset();
  });

  group('test put, delete and check onInit execution', () {
    tearDownAll(() {
      Get.reset();
    });

    test('Get.put test with init check', () async {
      final instance = Get.put<DisposableController>(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });

    test('Get.delete test with disposable controller', () async {
      expect(await Get.delete<DisposableController>(), true);
      expect(() => Get.find<DisposableController>(),
          throwsA(TypeMatcher<String>()));
    });

    test('Get.put test after delete with disposable controller and init check',
        () async {
      final instance = Get.put<DisposableController>(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });
  });
}

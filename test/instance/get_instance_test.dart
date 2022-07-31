// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'util/matcher.dart' as m;

class Mock {
  static Future<String> test() async {
    await Future.delayed(Duration.zero);
    return 'test';
  }
}

abstract class MyController with GetLifeCycleMixin {}

class DisposableController extends MyController {}

// ignore: one_member_abstracts
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
    await Get.putAsync<String>(Mock.test);
    expect('test', Get.find<String>());
    Get.reset();
  });

  test('Get.put test', () async {
    final instance = Get.put<Controller>(Controller());
    expect(instance, Get.find<Controller>());
    Get.reset();
  });

  test('Get start and delete called just one time', () async {
    Get
      ..put(Controller())
      ..put(Controller());

    final controller = Get.find<Controller>();
    expect(controller.init, 1);

    Get
      ..delete<Controller>()
      ..delete<Controller>();
    expect(controller.close, 1);
    Get.reset();
  });

  test('Get.put tag test', () async {
    final instance = Get.put<Controller>(Controller(), tag: 'one');
    final instance2 = Get.put<Controller>(Controller(), tag: 'two');
    expect(instance == instance2, false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'two'),
        false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'one'),
        true);
    expect(Get.find<Controller>(tag: 'two') == Get.find<Controller>(tag: 'two'),
        true);
    Get.reset();
  });

  test('Get.lazyPut tag test', () async {
    Get.lazyPut<Controller>(() => Controller(), tag: 'one');
    Get.lazyPut<Controller>(() => Controller(), tag: 'two');

    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'two'),
        false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'one'),
        true);
    expect(Get.find<Controller>(tag: 'two') == Get.find<Controller>(tag: 'two'),
        true);
    Get.reset();
  });

  test('Get.lazyPut test', () async {
    final controller = Controller();
    Get.lazyPut<Controller>(() => controller);
    final ct1 = Get.find<Controller>();
    expect(ct1, controller);
    Get.reset();
  });

  test('Get.lazyPut fenix test', () async {
    Get.lazyPut<Controller>(() => Controller(), fenix: true);
    Get.find<Controller>().increment();

    expect(Get.find<Controller>().count, 1);
    Get.delete<Controller>();
    expect(Get.find<Controller>().count, 0);
    Get.reset();
  });

  test('Get.lazyPut without fenix', () async {
    Get.lazyPut<Controller>(() => Controller());
    Get.find<Controller>().increment();

    expect(Get.find<Controller>().count, 1);
    Get.delete<Controller>();
    expect(() => Get.find<Controller>(), throwsA(m.TypeMatcher<String>()));
    Get.reset();
  });

  test('Get.reloadInstance test', () async {
    Get.lazyPut<Controller>(() => Controller());
    var ct1 = Get.find<Controller>();
    ct1.increment();
    expect(ct1.count, 1);
    ct1 = Get.find<Controller>();
    expect(ct1.count, 1);
    Get.reload<Controller>();
    ct1 = Get.find<Controller>();
    expect(ct1.count, 0);
    Get.reset();
  });

  test('GetxService test', () async {
    Get.lazyPut<PermanentService>(() => PermanentService());
    var sv1 = Get.find<PermanentService>();
    var sv2 = Get.find<PermanentService>();
    expect(sv1, sv2);
    expect(Get.isRegistered<PermanentService>(), true);
    Get.delete<PermanentService>();
    expect(Get.isRegistered<PermanentService>(), true);
    Get.delete<PermanentService>(force: true);
    expect(Get.isRegistered<PermanentService>(), false);
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
    // expect(ct1 is Service, true);
    // expect(ct2 is Service, true);
    expect(ct1 == ct2, false);
    Get.reset();
  });

  group('test put, delete and check onInit execution', () {
    tearDownAll(Get.reset);

    test('Get.put test with init check', () async {
      final instance = Get.put(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });

    test('Get.delete test with disposable controller', () async {
      // Get.put(DisposableController());
      expect(Get.delete<DisposableController>(), true);
      expect(() => Get.find<DisposableController>(),
          throwsA(m.TypeMatcher<String>()));
    });

    test('Get.put test after delete with disposable controller and init check',
        () async {
      final instance = Get.put<DisposableController>(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });
  });

  group('Get.replace test for replacing parent instance that is', () {
    tearDown(Get.reset);
    test('temporary', () async {
      Get.put(DisposableController());
      Get.replace<DisposableController>(Controller());
      final instance = Get.find<DisposableController>();
      expect(instance is Controller, isTrue);
      expect((instance as Controller).init, greaterThan(0));
    });

    test('permanent', () async {
      Get.put(DisposableController(), permanent: true);
      Get.replace<DisposableController>(Controller());
      final instance = Get.find<DisposableController>();
      expect(instance is Controller, isTrue);
      expect((instance as Controller).init, greaterThan(0));
    });

    test('tagged temporary', () async {
      final tag = 'tag';
      Get.put(DisposableController(), tag: tag);
      Get.replace<DisposableController>(Controller(), tag: tag);
      final instance = Get.find<DisposableController>(tag: tag);
      expect(instance is Controller, isTrue);
      expect((instance as Controller).init, greaterThan(0));
    });

    test('tagged permanent', () async {
      final tag = 'tag';
      Get.put(DisposableController(), permanent: true, tag: tag);
      Get.replace<DisposableController>(Controller(), tag: tag);
      final instance = Get.find<DisposableController>(tag: tag);
      expect(instance is Controller, isTrue);
      expect((instance as Controller).init, greaterThan(0));
    });

    test('a generic parent type', () async {
      final tag = 'tag';
      Get.put<MyController>(DisposableController(), permanent: true, tag: tag);
      Get.replace<MyController>(Controller(), tag: tag);
      final instance = Get.find<MyController>(tag: tag);
      expect(instance is Controller, isTrue);
      expect((instance as Controller).init, greaterThan(0));
    });
  });

  group('Get.lazyReplace replaces parent instance', () {
    tearDown(Get.reset);
    test('without fenix', () async {
      Get.put(DisposableController());
      Get.lazyReplace<DisposableController>(() => Controller());
      final instance = Get.find<DisposableController>();
      expect(instance, isA<Controller>());
      expect((instance as Controller).init, greaterThan(0));
    });

    test('with fenix', () async {
      Get.put(DisposableController());
      Get.lazyReplace<DisposableController>(() => Controller(), fenix: true);
      expect(Get.find<DisposableController>(), isA<Controller>());
      (Get.find<DisposableController>() as Controller).increment();

      expect((Get.find<DisposableController>() as Controller).count, 1);
      Get.delete<DisposableController>();
      expect((Get.find<DisposableController>() as Controller).count, 0);
    });

    test('with fenix when parent is permanent', () async {
      Get.put(DisposableController(), permanent: true);
      Get.lazyReplace<DisposableController>(() => Controller());
      final instance = Get.find<DisposableController>();
      expect(instance, isA<Controller>());
      (instance as Controller).increment();

      expect((Get.find<DisposableController>() as Controller).count, 1);
      Get.delete<DisposableController>();
      expect((Get.find<DisposableController>() as Controller).count, 0);
    });
  });
}

class PermanentService extends GetxService {}

class Controller extends DisposableController {
  int init = 0;
  int close = 0;
  int count = 0;
  @override
  void onInit() {
    init++;
    super.onInit();
  }

  @override
  void onClose() {
    close++;
    super.onClose();
  }

  void increment() {
    count++;
  }
}

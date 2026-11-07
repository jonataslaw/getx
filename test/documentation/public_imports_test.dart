import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' as umbrella;
import 'package:get/instance_manager.dart' as instance;
import 'package:get/state_manager.dart' as state;
import 'package:get/route_manager.dart' as route;
import 'package:get/utils.dart' as utils;
import 'package:get/get_connect.dart' as connect;

class _Service {}

void main() {
  tearDown(instance.Get.reset);
  test('public facades share dependency and reactive APIs', () {
    final service = instance.Get.put(_Service());
    expect(state.Get.find<_Service>(), same(service));
    expect(umbrella.Get.find<_Service>(), same(service));
    final count = state.RxInt(1);
    count.value++;
    expect(count.value, 2);
    count.close();
    expect(utils.GetUtils.isEmail('user@example.com'), isTrue);
    final page = route.GetPage<void>(
        name: '/public', page: () => const SizedBox.shrink());
    expect(page.name, '/public');
    final client = connect.GetConnect();
    client.onClose();
  });
}

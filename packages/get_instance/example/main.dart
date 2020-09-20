import 'package:get_instance/get_instance.dart';

void main() {
  Get.put(Foo());

  final foo = Get.find<Foo>();
  final foo2 = Get.find<Foo>();
  print(foo == foo2); // true
}

class Foo {}

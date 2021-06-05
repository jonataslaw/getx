import 'dart:async';
import 'get.dart';

class GetxStreamController<T, S extends StreamController<T>>
    extends GetxController {
  final S _s;
  final _value = Rx<T?>(null);

  GetxStreamController(S s) : _s = s {
    _s.stream.listen((event) {
      value = event;
    });
  }

  T? get value => _value.value;
  set value(T? t) {
    _value.value = t;
    update();
  }
}

extension GetxStreamControllerBind<T, S extends StreamController<T>> on S {
  GetxStreamController<T, S> get bind => GetxStreamController<T, S>(this);
}

import 'dart:async';
import 'get.dart';

class GetxStreamController<T, S extends StreamController<T>>
    extends GetxController {
  final S _s;
  final _data = Rx<T?>(null);

  GetxStreamController(S s) : _s = s {
    _s.stream.listen((event) {
      data = event;
    });
  }

  T? get data => _data.value;
  set data(T? t) {
    _data.value = t;
    update();
  }
}

extension GetxStreamControllerBind<T, S extends StreamController<T>> on S {
  GetxStreamController<T, S> get bind => GetxStreamController<T, S>(this);
}

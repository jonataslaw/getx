import 'package:get/get.dart';
import 'rx_interface.dart';
import 'utils/debouncer.dart';

void ever(RxInterface listener, Function(dynamic) callback,
    {bool condition = true}) {
  listener.subject.stream.listen((event) {
    if (condition) {
      callback(event.$new);
    }
  });
}

void once(RxInterface listener, Function(dynamic) callback,
    {bool condition = true}) {
  int times = 0;
  listener.subject.stream.listen((event) {
    if (!condition) return null;
    times++;
    if (times < 2) {
      callback(event.$new);
    }
  });
}

void interval(RxInterface listener, Function(dynamic) callback,
    {Duration time, bool condition = true}) {
  bool debounceActive = false;
  listener.subject.stream.listen((event) async {
    if (debounceActive || !condition) return null;
    debounceActive = true;
    await Future.delayed(time ?? Duration(seconds: 1));
    debounceActive = false;
    callback(event.$new);
  });
}

void debounce(RxInterface listener, Function(dynamic) callback,
    {Duration time}) {
  final _debouncer = Debouncer(delay: time ?? Duration(milliseconds: 800));
  listener.subject.stream.listen((event) {
    _debouncer(() {
      callback(event.$new);
    });
  });
}

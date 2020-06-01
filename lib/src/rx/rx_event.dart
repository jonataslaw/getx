import 'package:get/get.dart';
import 'rx_interface.dart';
import 'utils/debouncer.dart';

void ever(RxInterface listener, Function(dynamic) callback) {
  listener.subject.stream.listen((event) {
    callback(event.$new);
  });
}

void once(RxInterface listener, Function(dynamic) callback) {
  int times = 0;
  listener.subject.stream.listen((event) {
    times++;
    if (times < 2) {
      callback(event.$new);
    }
  });
}

void interval(RxInterface listener, Function(dynamic) callback,
    {Duration time}) {
  bool debounceActive = false;
  Duration timer = time ?? Duration(seconds: 1);

  listener.subject.stream.listen((event) async {
    if (debounceActive) return null;
    debounceActive = true;
    await Future.delayed(timer);
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

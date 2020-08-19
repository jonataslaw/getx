import 'dart:async';
import 'package:get/get.dart';
import 'rx_interface.dart';
import 'utils/debouncer.dart';

Worker ever(RxInterface listener, Function(dynamic) callback,
    {bool condition = true}) {
  StreamSubscription sub = listener.subject.stream.listen((event) {
    if (condition) callback(event);
  });

  Future<void> cancel() {
    return sub.cancel();
  }

  return Worker(cancel, '[ever]');
}

Worker everAll(List<RxInterface> listener, Function(dynamic) callback,
    {bool condition = true}) {
  List<StreamSubscription> evers = <StreamSubscription>[];

  for (var i in listener) {
    StreamSubscription sub = i.subject.stream.listen((event) {
      if (condition) callback(event);
    });
    evers.add(sub);
  }

  Future<void> cancel() {
    for (var i in evers) {
      i.cancel();
    }
    return Future.value(() {});
  }

  return Worker(cancel, '[everAll]');
}

Worker once(RxInterface listener, Function(dynamic) callback,
    {bool condition = true}) {
  StreamSubscription sub;
  int times = 0;

  sub = listener.subject.stream.listen((event) {
    if (!condition) return null;
    times++;
    if (times < 2) {
      callback(event);
    } else {
      sub.cancel();
    }
  });

  Future<void> cancel() {
    return sub.cancel();
  }

  return Worker(cancel, '[once]');
}

Worker interval(RxInterface listener, Function(dynamic) callback,
    {Duration time, bool condition = true}) {
  bool debounceActive = false;
  StreamSubscription sub = listener.subject.stream.listen((event) async {
    if (debounceActive || !condition) return null;
    debounceActive = true;
    await Future.delayed(time ?? Duration(seconds: 1));
    debounceActive = false;
    callback(event);
  });

  Future<void> cancel() {
    return sub.cancel();
  }

  return Worker(cancel, '[interval]');
}

Worker debounce(RxInterface listener, Function(dynamic) callback,
    {Duration time}) {
  final _debouncer = Debouncer(delay: time ?? Duration(milliseconds: 800));
  StreamSubscription sub = listener.subject.stream.listen((event) {
    _debouncer(() {
      callback(event);
    });
  });

  Future<void> cancel() {
    return sub.cancel();
  }

  return Worker(cancel, '[debounce]');
}

class Worker {
  Worker(this.worker, this.type);

  final Future<void> Function() worker;
  final String type;

  void _message() {
    GetConfig.log('[Getx] Worker $type disposed');
  }

  void dispose() {
    worker();
    _message();
  }

  void call() {
    worker();
    _message();
  }
}

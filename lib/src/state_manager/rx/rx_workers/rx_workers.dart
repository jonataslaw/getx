import 'dart:async';

import '../../../../get.dart';
import '../rx_core/rx_interface.dart';
import 'utils/debouncer.dart';

Worker ever<T>(RxInterface<T> listener, Function(T) callback,
    {bool condition = true}) {
  StreamSubscription sub = listener.subject.stream.listen((event) {
    if (condition) callback(event);
  });

  Future<void> cancel() {
    return sub.cancel();
  }

  return Worker(cancel, '[ever]');
}

Worker everAll(List<RxInterface> listeners, Function(dynamic) callback,
    {bool condition = true}) {
  var evers = <StreamSubscription>[];

  for (final listener in listeners) {
    final sub = listener.subject.stream.listen((event) {
      if (condition) {
        callback(event);
      }
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

Worker once<T>(
  RxInterface<T> listener,
  Function(T) callback, {
  bool condition = true,
}) {
  StreamSubscription subscription;
  var times = 0;

  subscription = listener.subject.stream.listen((event) {
    if (!condition) return null;
    times++;
    if (times < 2) {
      callback(event);
    } else {
      subscription.cancel();
    }
  });

  Future<void> cancel() {
    return subscription.cancel();
  }

  return Worker(cancel, '[once]');
}

Worker interval<T>(RxInterface<T> listener, Function(T) callback,
    {Duration time, bool condition = true}) {
  var debounceActive = false;
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

Worker debounce<T>(RxInterface<T> listener, Function(T) callback,
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
    GetConfig.log('Worker $type disposed');
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

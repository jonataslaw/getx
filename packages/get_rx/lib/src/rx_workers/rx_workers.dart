import 'dart:async';
import 'package:get_core/get_core.dart';

import '../rx_core/rx_interface.dart';
import 'utils/debouncer.dart';

bool _conditional(dynamic condition) {
  if (condition == null) return true;
  if (condition is bool) return condition;
  if (condition is bool Function()) return condition();
  return true;
}

///
/// Called every time [listener] changes. As long as the [condition]
/// returns true.
///
/// Sample:
/// Every time increment() is called, ever() will process the [condition]
/// (can be a [bool] expression or a [bool Function()]), and only call
/// the callback when [condition] is true.
/// In our case, only when count is bigger to 5. In order to "dispose"
/// this Worker
/// that will run forever, we made a [worker] variable. So, when the count value
/// reaches 10, the worker gets disposed, and releases any memory resources.
///
/// ```
/// // imagine some counter widget...
///
/// class _CountController extends GetxController {
///   final count = 0.obs;
///   Worker worker;
///
///   void onInit() {
///     worker = ever(count, (value) {
///       print('counter changed to: $value');
///       if (value == 10) worker.dispose();
///     }, condition: () => count > 5);
///   }
///
///   void increment() => count + 1;
/// }
/// ```
Worker ever<T>(RxInterface<T> listener, Function(T) callback,
    {dynamic condition = true}) {
  StreamSubscription sub = listener.subject.stream.listen((event) {
    if (_conditional(condition)) callback(event);
  });
  return Worker(sub.cancel, '[ever]');
}

/// Similar to [ever], but takes a list of [listeners], the condition
/// for the [callback] is common to all [listeners],
/// and the [callback] is executed to each one of them. The [Worker] is
/// common to all, so [worker.dispose()] will cancel all streams.
Worker everAll(List<RxInterface> listeners, Function(dynamic) callback,
    {dynamic condition = true}) {
  final evers = <StreamSubscription>[];
  for (var i in listeners) {
    final sub = i.subject.stream.listen((event) {
      if (_conditional(condition)) callback(event);
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

/// [once()] will execute only 1 time when [condition] is met and cancel
/// the subscription to the [listener] stream right after that.
/// [condition] defines when [callback] is called, and
/// can be a [bool] or a [bool Function()].
///
/// Sample:
/// ```
///  class _CountController extends GetxController {
///   final count = 0.obs;
///   Worker worker;
///
///   @override
///   Future<void> onInit() async {
///     worker = once(count, (value) {
///       print("counter reached $value before 3 seconds.");
///     }, condition: () => count() > 2);
///     3.delay(worker.dispose);
///   }
///   void increment() => count + 1;
/// }
///```
Worker once<T>(RxInterface<T> listener, Function(T) callback,
    {dynamic condition}) {
  Worker ref;
  StreamSubscription sub;
  sub = listener.subject.stream.listen((event) {
    if (!_conditional(condition)) return;
    ref._disposed = true;
    ref._log('called');
    sub?.cancel();
    callback(event);
  });
  ref = Worker(sub.cancel, '[once]');
  return ref;
}

/// Ignore all changes in [listener] during [time] (1 sec by default) or until
/// [condition] is met (can be a [bool] expression or a [bool Function()]),
/// It brings the 1st "value" since the period of time, so
/// if you click a counter button 3 times in 1 sec, it will show you "1"
/// (after 1 sec of the first press)
/// click counter 3 times in 1 sec, it will show you "4" (after 1 sec)
/// click counter 2 times in 1 sec, it will show you "7" (after 1 sec).
///
/// Sample:
/// // wait 1 sec each time an event starts, only if counter is lower than 20.
/// worker = interval(
///    count,
///    (value) => print(value),
///    time: 1.seconds,
///    condition: () => count < 20,
/// );
/// ```
Worker interval<T>(RxInterface<T> listener, Function(T) callback,
    {Duration time = const Duration(seconds: 1), dynamic condition = true}) {
  var debounceActive = false;
  time ??= const Duration(seconds: 1);
  StreamSubscription sub = listener.subject.stream.listen((event) async {
    if (debounceActive || !_conditional(condition)) return;
    debounceActive = true;
    await Future.delayed(time);
    debounceActive = false;
    callback(event);
  });
  return Worker(sub.cancel, '[interval]');
}

/// [debounce] is similar to [interval], but sends the last value.
/// Useful for Anti DDos, every time the user stops typing for 1 second,
/// for instance.
/// When [listener] emits the last "value", when [time] hits,
/// it calls [callback] with the last "value" emitted.
///
/// Sample:
///
/// ```
/// worker = debounce(
///      count,
///      (value) {
///        print(value);
///        if( value > 20 ) worker.dispose();
///      },
///      time: 1.seconds,
///    );
///  }
///  ```
Worker debounce<T>(RxInterface<T> listener, Function(T) callback,
    {Duration time}) {
  final _debouncer =
      Debouncer(delay: time ?? const Duration(milliseconds: 800));
  StreamSubscription sub = listener.subject.stream.listen((event) {
    _debouncer(() {
      callback(event);
    });
  });
  return Worker(sub.cancel, '[debounce]');
}

class Worker {
  Worker(this.worker, this.type);

  /// subscription.cancel() callback
  final Future<void> Function() worker;

  /// type of worker (debounce, interval, ever)..
  final String type;
  bool _disposed = false;

  //final bool _verbose = true;
  void _log(String msg) {
    //  if (!_verbose) return;
    Get.log('$runtimeType $type $msg');
  }

  void dispose() {
    if (_disposed) {
      _log('already disposed');
      return;
    }
    _disposed = true;
    worker();
    _log('disposed');
  }

  void call() => dispose();
}

import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:get/src/rx/rx_callbacks.dart';

abstract class RxInterface<T> {
  RxInterface([T initial]);

  /// add listener to stream
  addListener(Stream<T> rxGetx);

  /// close stream
  close() {
    subject?.close();
  }

  StreamController<T> subject;

  /// Convert value on string
  // String get string;

  /// Calls [callback] with current value, when the value changes.
  StreamSubscription<T> listen(ValueCallback<T> callback);

  /// Maps the changes into a [Stream] of [S]
  // Stream<S> map<S>(S mapper(T data));
}

abstract class DisposableInterface {
  /// Called at the exact moment that the widget is allocated in memory.
  /// Do not overwrite this method.
  void onStart() {
    onInit();
    SchedulerBinding.instance?.addPostFrameCallback((_) => onReady());
  }

  /// Called Called immediately after the widget is allocated in memory.
  void onInit() async {}

  /// Called after rendering the screen. It is the perfect place to enter navigation events,
  /// be it snackbar, dialogs, or a new route.
  void onReady() async {}

  /// Called before the onDelete method. onClose is used to close events
  /// before the controller is destroyed, such as closing streams, for example.
  onClose() async {}
}

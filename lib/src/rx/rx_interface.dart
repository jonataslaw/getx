import 'dart:async';
import 'package:get/src/rx/rx_callbacks.dart';
import 'package:get/src/rx/rx_model.dart';

abstract class RxInterface<T> {
  RxInterface([T initial]);

  /// Get current value
  get v;

  /// Set value
  set v(T val);

  /// Cast [val] to [T] before setting
  void setCast(dynamic /* T */ val);

  /// Stream of record of [Change]s of value
  // Stream<Change<T>> get onChange;

  /// add listener to stream
  addListener(Stream<Change<T>> rxGetx);

  /// close stream
  close() {
    subject?.close();
  }

  StreamController<Change<T>> subject;

  /// Stream of changes of value
  Stream<T> get stream;

  /// Convert value on string
  // String get string;

  /// Binds if [other] is [Stream] or [RxInterface] of type [T]. Sets if [other] is
  /// instance of [T]
  void bindOrSet(/* T | Stream<T> | Reactive<T> */ other);

  /// Binds [other] to this
  void bind(RxInterface<T> other);

  /// Binds the [stream] to this
  void bindStream(Stream<T> stream);

  /// Calls [callback] with current value, when the value changes.
  StreamSubscription<T> listen(ValueCallback<T> callback);

  /// Maps the changes into a [Stream] of [S]
  // Stream<S> map<S>(S mapper(T data));
}

class RxController implements DisposableInterface {
  void onInit() async {}
  void onClose() async {}
}

abstract class DisposableInterface {
  void onClose() async {}
  void onInit() async {}
}

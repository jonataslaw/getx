import 'dart:async';
import '../rx_typedefs/rx_typedefs.dart';

/// This class is the foundation for all reactive (Rx) classes that makes Get
/// so powerful.
/// This interface is the contract that [_RxImpl]<[T]> uses in all it's
/// subclass.
abstract class RxInterface<T> {
  RxInterface([T initial]);

  StreamController<T> subject;

  /// Adds a listener to stream
  void addListener(Stream<T> rxGetx);

  bool get canUpdate;

  set value(T val);

  T get value;

  /// Closes the stream
  // FIXME: shouldn't we expose the returned future?
  void close() => subject?.close();

  /// Calls [callback] with current value, when the value changes.
  StreamSubscription<T> listen(ValueCallback<T> callback);
}

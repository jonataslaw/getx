part of rx_types;

/// This class is the foundation for all reactive (Rx) classes that makes Get
/// so powerful.
/// This interface is the contract that [_RxImpl]<[T]> uses in all it's
/// subclass.
abstract class RxInterface<T> {
  RxInterface([T initial]);

  GetStream<T> subject;

  /// Adds a listener to stream
  void addListener(GetStream<T> rxGetx);

  bool get canUpdate;

  set value(T val);

  T get value;

  /// Closes the stream
  // FIXME: shouldn't we expose the returned future?
  void close();

  /// Calls [callback] with current value, when the value changes.
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError});
}


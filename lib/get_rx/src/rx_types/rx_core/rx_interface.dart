part of rx_types;

/// This class is the foundation for all reactive (Rx) classes that makes Get
/// so powerful.
/// This interface is the contract that [_RxImpl]<[T]> uses in all it's
/// subclass.
abstract class RxInterface<T> {
  RxInterface([T? initial]);

  bool get canUpdate;

  /// Adds a listener to stream
  void addListener(GetStream<T> rxGetx);

  /// Close the Rx Variable
  void close();

  static RxInterface? proxy;

  /// Calls [callback] with current value, when the value changes.
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError});
}

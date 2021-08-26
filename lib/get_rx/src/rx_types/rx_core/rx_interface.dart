part of rx_types;

/// This class is the foundation for all reactive (Rx) classes that makes Get
/// so powerful.
/// This interface is the contract that _RxImpl]<T> uses in all it's
/// subclass.
abstract class RxInterface<T> {
  bool get canUpdate;

  /// Adds a listener to stream
  void addListener(GetStream<T> rxGetx);

  /// Close the Rx Variable
  void close();

  static RxInterface? proxy;

  /// Calls `callback` with current value, when the value changes.
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError});

  /// Avoids an unsafe usage of the `proxy`
  static T notifyChildren<T>(RxNotifier observer, ValueGetter<T> builder) {
    final _observer = RxInterface.proxy;
    RxInterface.proxy = observer;
    final result = builder();
    if (!observer.canUpdate) {
      RxInterface.proxy = _observer;
      throw """
      [Get] the improper use of a GetX has been detected. 
      You should only use GetX or Obx for the specific widget that will be updated.
      If you are seeing this error, you probably did not insert any observable variables into GetX/Obx 
      or insert them outside the scope that GetX considers suitable for an update 
      (example: GetX => HeavyWidget => variableObservable).
      If you need to update a parent widget and a child widget, wrap each one in an Obx/GetX.
      """;
    }
    RxInterface.proxy = _observer;
    return result;
  }
}

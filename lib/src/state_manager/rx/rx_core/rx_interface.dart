import 'dart:async';

import 'package:flutter/scheduler.dart';

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

/// Unlike GetxController, which serves to control events on each of its pages,
/// GetxService is not automatically disposed (nor can be removed with
/// Get.delete()).
/// It is ideal for situations where, once started, that service will
/// remain in memory, such as Auth control for example. Only way to remove
/// it is Get.reset().
abstract class GetxService extends DisposableInterface {}

/// Special callable class to keep the contract of a regular method, and avoid
/// overrides if you extend the class that uses it, as Dart has no final
/// methods.
/// Used in [DisposableInterface] to avoid the danger of overriding onStart.
///
class _InternalFinalCallback<T> {
  T Function() callback;

  _InternalFinalCallback();

  T call() => callback.call();
}

abstract class DisposableInterface {
  /// Called at the exact moment the widget is allocated in memory.
  /// It uses an internal "callable" type, to avoid any @overrides in subclases.
  /// This method should be internal and is required to define the
  /// lifetime cycle of the subclass.
  final onStart = _InternalFinalCallback<void>();

  bool _initialized = false;

  /// Checks whether the controller has already been initialized.
  bool get initialized => _initialized;

  DisposableInterface() {
    onStart.callback = _onStart;
  }

  // Internal callback that starts the cycle of this controller.
  void _onStart() {
    onInit();
    _initialized = true;
    SchedulerBinding.instance?.addPostFrameCallback((_) => onReady());
  }

  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  void onInit() {}

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  void onReady() async {}

  /// Called before [onDelete] method. [onClose] might be used to
  /// dispose resources used by the controller. Like closing events,
  /// or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  FutureOr onClose() async {}
}

/// Used like [SingleTickerProviderMixin] but only with Get Controllers.
/// Simplifies AnimationController creation inside GetxController.
///
/// Example:
///```
///class SplashController extends GetxController with
///    SingleGetTickerProviderMixin {
///  AnimationController _ac;
///
///  @override
///  void onInit() {
///    final dur = const Duration(seconds: 2);
///    _ac = AnimationController.unbounded(duration: dur, vsync: this);
///    _ac.repeat();
///    _ac.addListener(() => print("Animation Controller value: ${_ac.value}"));
///  }
///  ...
/// ```
mixin SingleGetTickerProviderMixin on DisposableInterface
    implements TickerProvider {
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

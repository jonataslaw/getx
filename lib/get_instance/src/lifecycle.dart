import 'package:meta/meta.dart';
import '../../get_core/get_core.dart';

/// Special callable class to keep the contract of a regular method, and avoid
/// overrides if you extend the class that uses it, as Dart has no final
/// methods.
/// Used in [DisposableInterface] to avoid the danger of overriding onStart.
class _InternalFinalCallback<T> {
  ValueUpdater<T> _callback;

  _InternalFinalCallback({ValueUpdater<T> callback}) : _callback = callback;

  T call() => _callback.call();
}

/// The [GetLifeCycle]
///
/// ```dart
/// class SomeController with GetLifeCycle {
///   SomeController() {
///     initLifeCycle();
///   }
/// }
/// ```
mixin GetLifeCycle {
  /// The `initLifeCycle` works as a constructor for the [GetLifeCycle]
  ///
  /// This method must be invoked in the constructor of the implementation
  void initLifeCycle() {
    onStart._callback = _onStart;
    onDelete._callback = _onDelete;
  }

  /// Called at the exact moment the widget is allocated in memory.
  /// It uses an internal "callable" type, to avoid any @overrides in subclases.
  /// This method should be internal and is required to define the
  /// lifetime cycle of the subclass.
  final onStart = _InternalFinalCallback<void>();

  /// Internal callback that starts the cycle of this controller.
  final onDelete = _InternalFinalCallback<void>();

  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  @mustCallSuper
  void onInit() {}

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  void onReady() {}

  /// Called before [onDelete] method. [onClose] might be used to
  /// dispose resources used by the controller. Like closing events,
  /// or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  void onClose() {}

  bool _initialized = false;

  /// Checks whether the controller has already been initialized.
  bool get initialized => _initialized;

  // Internal callback that starts the cycle of this controller.
  void _onStart() {
    if (_initialized) return;
    onInit();
    _initialized = true;
  }

  bool _isClosed = false;

  /// Checks whether the controller has already been closed.
  bool get isClosed => _isClosed;

  // Internal callback that starts the cycle of this controller.
  void _onDelete() {
    if (_isClosed) return;
    _isClosed = true;
    onClose();
  }
}

/// Allow track difference between GetxServices and GetxControllers
mixin GetxServiceMixin {}

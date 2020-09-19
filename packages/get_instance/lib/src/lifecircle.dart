import 'dart:async';

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

abstract class GetLifeCycle {
  /// Called at the exact moment the widget is allocated in memory.
  /// It uses an internal "callable" type, to avoid any @overrides in subclases.
  /// This method should be internal and is required to define the
  /// lifetime cycle of the subclass.
  final onStart = _InternalFinalCallback<void>();

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

/// Allow track difference between GetxServices and GetxControllers
mixin GetxServiceMixin {}

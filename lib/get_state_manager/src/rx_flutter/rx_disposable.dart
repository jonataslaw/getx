import 'package:flutter/material.dart';

import '../../../get.dart';

/// Unlike GetxController, which serves to control events on each of its pages,
/// GetxService is not automatically disposed (nor can be removed with
/// Get.delete()).
/// It is ideal for situations where, once started, that service will
/// remain in memory, such as Auth control for example. Only way to remove
/// it is Get.reset().
abstract class GetxService extends DisposableInterface with GetxServiceMixin {}

abstract class DisposableInterface extends GetLifeCycle {
  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  @override
  @mustCallSuper
  void onInit() {
    super.onInit();

    Get.engine.addPostFrameCallback((_) => onReady());
  }

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  @override
  void onReady() {
    super.onReady();
  }

  /// Called before [onDelete] method. [onClose] might be used to
  /// dispose resources used by the controller. Like closing events,
  /// or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  @override
  void onClose() {
    super.onClose();
  }
}

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/src/get_main.dart';
import 'rx_impl.dart';
import 'rx_interface.dart';

class GetX<T extends RxController> extends StatefulWidget {
  final Widget Function(T) builder;
  final bool global;
  // final Stream Function(T) stream;
  // final StreamController Function(T) streamController;
  final bool autoRemove;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final T init;
  const GetX({
    this.builder,
    this.global = true,
    this.autoRemove = true,
    this.initState,
    //  this.stream,
    this.dispose,
    this.didChangeDependencies,
    this.init,
    // this.streamController
  });
  _GetXState<T> createState() => _GetXState<T>();
}

class _GetXState<T extends RxController> extends State<GetX<T>> {
  RxInterface _observer;
  StreamSubscription _listenSubscription;
  T controller;
  bool isCreator = false;

  _GetXState() {
    _observer = ListX();
  }

  @override
  void initState() {
    if (widget.global) {
      if (Get.isPrepared<T>()) {
        isCreator = true;
        controller = Get.find<T>();
      } else if (Get.isRegistred<T>() && !Get.isPrepared<T>()) {
        controller = Get.find<T>();
        isCreator = false;
      } else {
        controller = widget.init;
        isCreator = true;
        Get.put<T>(controller);
      }
    } else {
      controller = widget.init;
      isCreator = true;
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator) {
      try {
        controller?.onInit();
      } catch (e) {
        if (Get.isLogEnable) print("Failure on call onInit");
      }
    }

    _listenSubscription = _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose(this);

    if (isCreator) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        // controller.onClose();
        Get.delete<T>();
      }
      // } else {
      //   controller.onClose();
    }
    // controller.onClose();
    _observer.close();
    _listenSubscription?.cancel();

    controller = null;
    isCreator = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _observer.close();
    final observer = Get.obs;
    Get.obs = this._observer;
    final result = widget.builder(controller);
    Get.obs = observer;
    return result;
  }
}

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
  final bool assignId;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final T init;
  const GetX({
    this.builder,
    this.global = true,
    this.autoRemove = true,
    this.initState,
    this.assignId = false,
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
    _observer = Rx();
  }

  @override
  void initState() {
    bool isPrepared = Get.isPrepared<T>();
    bool isRegistred = Get.isRegistred<T>();
    if (widget.global) {
      // if (Get().smartManagement == SmartManagement.full) {
      //   Get.isDependencyInit<T>();
      // }
      if (isPrepared) {
        isCreator = true;
        controller = Get.find<T>();
      } else if (isRegistred) {
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
      controller?.onInit();
    }

    _listenSubscription = _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose(this);

    if (isCreator || widget.assignId) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        print("DISPOSEEER CHAMADOOO");
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
    final observer = Get.obs;
    Get.obs = this._observer;
    final result = widget.builder(controller);
    Get.obs = observer;
    return result;
  }
}

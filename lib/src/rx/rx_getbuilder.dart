import 'package:flutter/widgets.dart';
import 'package:get/src/get_main.dart';
import 'package:get/src/root/smart_management.dart';
import 'rx_impl.dart';
import 'rx_interface.dart';

class GetX<T extends DisposableInterface> extends StatefulWidget {
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

class _GetXState<T extends DisposableInterface> extends State<GetX<T>> {
  RxInterface _observer;
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
      controller?.onInit();
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator && Get().smartManagement == SmartManagement.onlyBuilder) {
      controller?.onInit();
    }

    _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose(this);

    if (isCreator || widget.assignId) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        // controller.onClose();
        Get.delete<T>();
      }
      // } else {
      //   controller.onClose();
    }
    // controller.onClose();
    _observer.close();
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

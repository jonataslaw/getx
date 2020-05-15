import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/src/get_main.dart';
import 'rx_impl.dart';
import 'rx_interface.dart';

class GetX<T extends RxController> extends StatefulWidget {
  final Widget Function(T) builder;
  final bool global;
  final Stream Function(T) stream;
  final StreamController Function(T) streamController;
  final bool autoRemove;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final T init;
  GetX(
      {this.builder,
      this.global = true,
      this.autoRemove = true,
      this.initState,
      this.stream,
      this.dispose,
      this.didChangeDependencies,
      this.init,
      this.streamController});
  _GetXState<T> createState() => _GetXState<T>();
}

class _GetXState<T extends RxController> extends State<GetX<T>> {
  RxInterface _observer;
  StreamSubscription _listenSubscription;
  T controller;

  _GetXState() {
    _observer = Rx();
  }

  @override
  void initState() {
    if (widget.global) {
      if (Get.isRegistred<T>()) {
        controller = Get.find<T>();
      } else {
        controller = widget.init;
        Get.put<T>(controller);
      }
    } else {
      controller = widget.init;
    }
    if (widget.initState != null) widget.initState(this);
    try {
      controller?.onInit();
    } catch (e) {
      if (Get.isLogEnable) print("Failure on call onInit");
    }
    _listenSubscription = _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.close();
    _listenSubscription?.cancel();
    _observer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _observer.close();
    final observer = Get.obs;
    Get.obs = this._observer;
    final result = widget.builder(controller);
    Get.obs = observer;
    return result;
  }
}

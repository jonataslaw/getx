import 'package:flutter/widgets.dart';
import 'package:get/src/root/smart_management.dart';
import '../get_instance.dart';
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
  GetImplXState<T> createState() => GetImplXState<T>();
}

class GetImplXState<T extends DisposableInterface> extends State<GetX<T>> {
  RxInterface _observer;
  T controller;
  bool isCreator = false;

  @override
  void initState() {
    _observer = Rx();
    bool isPrepared = GetInstance().isPrepared<T>();
    bool isRegistred = GetInstance().isRegistred<T>();
    if (widget.global) {
      if (isPrepared) {
        if (GetConfig.smartManagement != SmartManagement.keepFactory) {
          isCreator = true;
        }
        controller = GetInstance().find<T>();
      } else if (isRegistred) {
        controller = GetInstance().find<T>();
        isCreator = false;
      } else {
        controller = widget.init;
        isCreator = true;
        GetInstance().put<T>(controller);
      }
    } else {
      controller = widget.init;
      isCreator = true;
      controller?.onStart();
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator && GetConfig.smartManagement == SmartManagement.onlyBuilder) {
      controller?.onStart();
    }
    _observer.subject.stream.listen((data) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose(this);
    if (isCreator || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistred<T>()) {
        GetInstance().delete<T>();
      }
    }

    _observer.close();
    controller = null;
    isCreator = null;
    super.dispose();
  }

  Widget get notifyChilds {
    final observer = getObs;
    getObs = _observer;
    final result = widget.builder(controller);
    getObs = observer;
    return result;
  }

  @override
  Widget build(BuildContext context) => notifyChilds;
}

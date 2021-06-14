import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/src/get_instance.dart';
import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../get_state_manager.dart';

typedef GetXControllerBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

class GetX<T extends DisposableInterface> extends StatefulWidget {
  final GetXControllerBuilder<T> builder;
  final bool global;

  // final Stream Function(T) stream;
  // final StreamController Function(T) streamController;
  final bool autoRemove;
  final bool assignId;
  final void Function(GetXState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(GetX oldWidget, GetXState<T> state)? didUpdateWidget;
  final T? init;
  final String? tag;

  const GetX({
    this.tag,
    required this.builder,
    this.global = true,
    this.autoRemove = true,
    this.initState,
    this.assignId = false,
    //  this.stream,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.init,
    // this.streamController
  });

  @override
  GetXState<T> createState() => GetXState<T>();
}

class GetXState<T extends DisposableInterface> extends State<GetX<T>> {
  final _observer = RxNotifier();
  T? controller;
  bool? _isCreator = false;
  late StreamSubscription _subs;

  @override
  void initState() {
    // var isPrepared = GetInstance().isPrepared<T>(tag: widget.tag);
    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        _isCreator = true;
        GetInstance().put<T>(controller!, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      _isCreator = true;
      controller?.onStart();
    }
    widget.initState?.call(this);
    if (widget.global && Get.smartManagement == SmartManagement.onlyBuilder) {
      controller?.onStart();
    }
    _subs = _observer.listen((data) => setState(() {}), cancelOnError: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies!(this);
    }
  }

  @override
  void didUpdateWidget(GetX oldWidget) {
    super.didUpdateWidget(oldWidget as GetX<T>);
    widget.didUpdateWidget?.call(oldWidget, this);
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose!(this);
    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }
    _subs.cancel();
    _observer.close();
    controller = null;
    _isCreator = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RxInterface.notifyChildren(
        _observer,
        () => widget.builder(controller!),
      );
}

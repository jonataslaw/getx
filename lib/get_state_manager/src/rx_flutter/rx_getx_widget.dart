import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/src/get_instance.dart';
import '../../../get_instance/src/lifecycle.dart';
import '../simple/list_notifier.dart';

typedef GetXControllerBuilder<T extends GetLifeCycleMixin> = Widget Function(
    T controller);

class GetX<T extends GetLifeCycleMixin> extends StatefulWidget {
  final GetXControllerBuilder<T> builder;
  final bool global;
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
  StatefulElement createElement() => StatefulElement(this);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<T>('controller', init),
      )
      ..add(DiagnosticsProperty<String>('tag', tag))
      ..add(
          ObjectFlagProperty<GetXControllerBuilder<T>>.has('builder', builder));
  }

  @override
  GetXState<T> createState() => GetXState<T>();
}

class GetXState<T extends GetLifeCycleMixin> extends State<GetX<T>> {
  T? controller;
  bool? _isCreator = false;

  @override
  void initState() {
    // var isPrepared = GetInstance().isPrepared<T>(tag: widget.tag);
    final isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        _isCreator = GetInstance().isPrepared<T>(tag: widget.tag);
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

    for (final disposer in disposers) {
      disposer();
    }

    disposers.clear();

    controller = null;
    _isCreator = null;
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  final disposers = <Disposer>[];

  @override
  Widget build(BuildContext context) => Notifier.instance.append(
      NotifyData(disposers: disposers, updater: _update),
      () => widget.builder(controller!));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('controller', controller));
  }
}

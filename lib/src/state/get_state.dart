import 'package:flutter/material.dart';
import '../get_main.dart';

class GetController extends State {
  Map<GetController, State> _allStates = {};

  /// Update GetBuilder with update(this)
  void update(GetController id) {
    if (id != null) {
      final State state = _allStates[id];
      if (state != null && state.mounted) state.setState(() {});
    }
  }

  @override
  Widget build(_) => throw ("build method can't be called");
}

class GetBuilder<T extends GetController> extends StatefulWidget {
  @required
  final Widget Function(T) builder;
  final bool global;
  final bool autoRemove;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final void Function(GetBuilder oldWidget, State state) didUpdateWidget;
  final T controller;
  GetBuilder({
    Key key,
    this.controller,
    this.global = true,
    this.builder,
    this.autoRemove = true,
    this.initState,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
  })  : assert(builder != null, controller != null),
        super(key: key);
  @override
  _GetBuilderState<T> createState() => _GetBuilderState<T>();
}

class _GetBuilderState<T extends GetController> extends State<GetBuilder<T>> {
  T controller;
  @override
  void initState() {
    super.initState();
    if (widget.global) {
      if (Get.isRegistred<T>()) {
        controller = Get.find<T>();
      } else {
        controller = widget.controller;
        controller._allStates[controller] = this;
        Get.put(controller);
      }
    } else {
      controller = widget.controller;
      controller._allStates[controller] = this;
    }
    if (widget.initState != null) widget.initState(this);
  }

  @override
  void dispose() {
    if (controller != null) {
      var b = controller;
      if (b._allStates[controller].hashCode == this.hashCode) {
        b._allStates.remove(controller);
      }
    }
    if (widget.dispose != null) widget.dispose(this);
    if (widget.autoRemove && Get.isRegistred<T>()) {
      Get.delete(controller);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.didChangeDependencies != null)
      widget.didChangeDependencies(this);
  }

  @override
  void didUpdateWidget(GetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.didUpdateWidget != null) widget.didUpdateWidget(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(controller);
  }
}

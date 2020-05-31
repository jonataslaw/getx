import 'package:flutter/material.dart';
import '../get_main.dart';

class RealState {
  final State state;
  final String id;
  final bool isCreator;
  const RealState({this.state, this.id, this.isCreator = false});
}

class GetController extends State {
  List<RealState> _allStates = [];

  /// Update GetBuilder with update(this)
  void update(GetController controller,
      [List<String> ids, bool condition = true]) {
    if (controller == null || !condition) return;

    if (ids == null) {
      // _allStates[controller.hashCode];
      _allStates.forEach((rs) {
        if (rs.state != null && rs.state.mounted) rs.state.setState(() {});
      });
    } else {
      ids.forEach(
        (s) {
          //  var all = _allStates[controller.hashCode];
          _allStates.forEach((rs) {
            if (rs.state != null && rs.state.mounted && rs.id == s)
              rs.state.setState(() {});
          });
        },
      );
    }
  }

  void onClose() async {}
  void onInit() async {}

  @override
  Widget build(_) => throw ("build method can't be called");
}

class GetBuilder<T extends GetController> extends StatefulWidget {
  @required
  final Widget Function(T) builder;
  final bool global;
  final String id;
  final bool autoRemove;
  final bool assignId;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final void Function(GetBuilder oldWidget, State state) didUpdateWidget;
  final T init;
  const GetBuilder({
    Key key,
    this.init,
    this.global = true,
    this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  })  : assert(builder != null),
        super(key: key);
  @override
  _GetBuilderState<T> createState() => _GetBuilderState<T>();
}

class _GetBuilderState<T extends GetController> extends State<GetBuilder<T>> {
  T controller;
  RealState real;
  bool isCreator = false;
  @override
  void initState() {
    super.initState();

    if (widget.global) {
      if (Get.isPrepared<T>()) {
        isCreator = true;
        controller = Get.find<T>();

        real = RealState(state: this, id: widget.id, isCreator: isCreator);
        controller._allStates.add(real);
      } else if (Get.isRegistred<T>() && !Get.isPrepared<T>()) {
        controller = Get.find<T>();
        isCreator = false;
        real = RealState(state: this, id: widget.id, isCreator: isCreator);
        controller._allStates.add(real);
      } else {
        controller = widget.init;
        isCreator = true;

        real = RealState(state: this, id: widget.id, isCreator: isCreator);
        controller._allStates.add(real);
        Get.put<T>(controller);
      }
    } else {
      controller = widget.init;

      isCreator = true;
      real = RealState(state: this, id: widget.id, isCreator: isCreator);
      controller._allStates.add(real);
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator) {
      try {
        controller?.onInit();
      } catch (e) {
        if (Get.isLogEnable) print("[GET] error: $e");
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();

    if (widget.dispose != null) widget.dispose(this);

    if (isCreator || widget.assignId) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        // controller.onClose();
        controller._allStates.remove(real);
        Get.delete<T>();
      }
    } else {
      // controller._allStates[controller].remove(this);
      controller._allStates.remove(real);
    }

    /// force GC remove this
    controller = null;
    real = null;
    isCreator = null;
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

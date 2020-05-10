import 'package:flutter/material.dart';
import '../get_main.dart';

class RealState {
  final State state;
  final String id;
  RealState({this.state, this.id});
}

class GetController extends State {
  Map<GetController, List<RealState>> _allStates = {};

  /// Update GetBuilder with update(this)
  void update(GetController controller, [List<String> ids]) {
    if (controller != null) {
      if (ids == null) {
        var all = _allStates[controller];
        all.forEach((rs) {
          if (rs.state != null && rs.state.mounted) rs.state.setState(() {});
        });
      } else {
        ids.forEach(
          (s) {
            var all = _allStates[controller];
            all.forEach((rs) {
              if (rs.state != null && rs.state.mounted && rs.id == s)
                rs.state.setState(() {});
            });
          },
        );
      }
    }
  }

  @override
  Widget build(_) => throw ("build method can't be called");
}

class GetBuilder<T extends GetController> extends StatefulWidget {
  @required
  final Widget Function(T) builder;
  final bool global;
  final String id;
  final bool autoRemove;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final void Function(GetBuilder oldWidget, State state) didUpdateWidget;
  final T init;
  GetBuilder({
    Key key,
    this.init,
    this.global = true,
    this.builder,
    this.autoRemove = true,
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
  @override
  void initState() {
    super.initState();
    if (widget.global) {
      if (Get.isRegistred<T>()) {
        controller = Get.find<T>();
        if (controller._allStates[controller] == null) {
          controller._allStates[controller] = [];
        }
        controller._allStates[controller]
            .add(RealState(state: this, id: widget.id));
      } else {
        controller = widget.init;
        if (controller._allStates[controller] == null) {
          controller._allStates[controller] = [];
        }
        controller._allStates[controller]
            .add(RealState(state: this, id: widget.id));
        Get.put<T>(controller);
      }
    } else {
      controller = widget.init;
      controller._allStates[controller]
          .add(RealState(state: this, id: widget.id));
    }
    if (widget.initState != null) widget.initState(this);
  }

  @override
  void dispose() {
    if (widget.init != null) {
      var b = controller;
      if (b._allStates[controller].hashCode == this.hashCode) {
        b._allStates.remove(controller);
      }
    } else {
      var b = controller;
      if (b._allStates[controller].hashCode == this.hashCode) {
        b._allStates.remove(controller);
      }
    }
    if (widget.dispose != null) widget.dispose(this);

    if (widget.init != null) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        Get.delete<T>();
      }
    } else {
      // controller._allStates[controller].remove(this);
      controller._allStates[controller]
          .remove(RealState(state: this, id: widget.id));
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

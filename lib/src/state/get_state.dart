import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/src/root/smart_management.dart';
import 'package:get/src/rx/rx_interface.dart';
import '../get_main.dart';

class GetController extends DisposableInterface {
  void onClose() async {}
  void onInit() async {}
  List<RealState> _allStates = [];

  /// Update GetBuilder with update();
  void update([List<String> ids, bool condition = true]) {
    if (!condition) return;

    if (ids == null) {
      _allStates.forEach((rs) {
        rs.updater(() {});
      });
    } else {
      ids.forEach(
        (s) {
          _allStates.forEach((rs) {
            if (rs.id == s) rs.updater(() {});
          });
        },
      );
    }
  }
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
      bool isPrepared = Get.isPrepared<T>();
      bool isRegistred = Get.isRegistred<T>();

      if (isPrepared) {
        if (Get().smartManagement != SmartManagement.keepFactory) {
          isCreator = true;
        }
        controller = Get.find<T>();
        real = RealState(updater: setState, id: widget.id);
        controller._allStates.add(real);
      } else if (isRegistred) {
        controller = Get.find<T>();
        isCreator = false;
        real = RealState(updater: setState, id: widget.id);
        controller._allStates.add(real);
      } else {
        controller = widget.init;
        isCreator = true;
        real = RealState(updater: setState, id: widget.id);
        controller._allStates.add(real);
        Get.put<T>(controller);
      }
    } else {
      controller = widget.init;
      isCreator = true;
      real = RealState(updater: setState, id: widget.id);
      controller._allStates.add(real);
      controller?.onInit();
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator && Get().smartManagement == SmartManagement.onlyBuilder) {
      controller?.onInit();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.dispose != null) widget.dispose(this);
    if (isCreator || widget.assignId) {
      if (widget.autoRemove && Get.isRegistred<T>()) {
        controller._allStates.remove(real);
        Get.delete<T>();
      }
    } else {
      controller._allStates.remove(real);
    }
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

typedef ShouldRebuild<T> = bool Function(T previous, T next);

class RealState {
  final StateSetter updater;
  final String id;
  const RealState({this.updater, this.id});
}

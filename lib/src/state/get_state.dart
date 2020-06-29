import 'package:flutter/widgets.dart';
import 'package:get/src/instance/get_instance.dart';
import 'package:get/src/root/smart_management.dart';
import 'package:get/src/rx/rx_interface.dart';

class GetxController extends DisposableInterface {
  final List<Updater> _updaters = [];

  /// Update GetBuilder with update();
  void update([List<String> ids, bool condition = true]) {
    if (!condition) return;
    (ids == null)
        ? _updaters.forEach((rs) {
            rs.updater(() {});
          })
        : _updaters
            .where((element) => ids.contains(element.id))
            .forEach((rs) => rs.updater(() {}));
  }

  @override
  void onInit() async {}

  @override
  void onReady() async {}

  @override
  void onClose() async {}
}

class GetBuilder<T extends GetxController> extends StatefulWidget {
  final Widget Function(T) builder;
  final bool global;
  final String id;
  final String tag;
  final bool autoRemove;
  final bool assignId;
  final void Function(State state) initState, dispose, didChangeDependencies;
  final void Function(GetBuilder oldWidget, State state) didUpdateWidget;
  final T init;
  const GetBuilder({
    Key key,
    this.init,
    this.global = true,
    @required this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  })  : assert(builder != null),
        super(key: key);
  @override
  _GetBuilderState<T> createState() => _GetBuilderState<T>();
}

class _GetBuilderState<T extends GetxController> extends State<GetBuilder<T>> {
  T controller;
  Updater real;
  bool isCreator = false;
  @override
  void initState() {
    super.initState();

    if (widget.global) {
      final isPrepared = GetInstance().isPrepared<T>(tag: widget.tag);
      final isRegistred = GetInstance().isRegistred<T>(tag: widget.tag);

      if (isPrepared) {
        if (GetConfig.smartManagement != SmartManagement.keepFactory) {
          isCreator = true;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
        real = Updater(updater: setState, id: widget.id);
        controller._updaters.add(real);
      } else if (isRegistred) {
        controller = GetInstance().find<T>(tag: widget.tag);
        isCreator = false;
        real = Updater(updater: setState, id: widget.id);
        controller._updaters.add(real);
      } else {
        controller = widget.init;
        isCreator = true;
        real = Updater(updater: setState, id: widget.id);
        controller._updaters.add(real);
        GetInstance().put<T>(controller, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      isCreator = true;
      real = Updater(updater: setState, id: widget.id);
      controller._updaters.add(real);
      controller?.onStart();
    }
    if (widget.initState != null) widget.initState(this);
    if (isCreator && GetConfig.smartManagement == SmartManagement.onlyBuilder) {
      controller?.onStart();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.dispose != null) widget.dispose(this);
    if (isCreator || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistred<T>(tag: widget.tag)) {
        controller._updaters.remove(real);
        GetInstance().delete<T>(tag: widget.tag);
      }
    } else {
      controller._updaters.remove(real);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.didChangeDependencies != null) {
      widget.didChangeDependencies(this);
    }
  }

  @override
  void didUpdateWidget(GetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget as GetBuilder<T>);
    if (widget.didUpdateWidget != null) widget.didUpdateWidget(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(controller);
  }
}

class Updater {
  final StateSetter updater;
  final String id;
  const Updater({this.updater, this.id});
}

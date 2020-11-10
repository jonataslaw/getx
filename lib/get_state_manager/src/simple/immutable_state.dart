//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:get/state_manager.dart';
//
//import '../../instance/get_instance.dart';
//
//abstract class GetState<T> extends DisposableInterface {
//  GetState(this.initialValue) {
//    _state = initialValue;
//  }
//
//  final Set<StateSetter> _updaters = <StateSetter>{};
//
//  @protected
//  void update(T value, [bool condition = true]) {
//    if (!condition) return;
//    _state = value;
//    _updaters.forEach((rs) => rs(() {}));
//  }
//
//  T _state;
//
//  final T initialValue;
//
//  void addListener(StateSetter value) {
//    _updaters.add(value);
//  }
//
//  void removeListener(StateSetter value) {
//    _updaters.add(value);
//  }
//
//  // @protected
//  T get state => _state;
//
//  @protected
//  void updater(void fn(T value)) {
//    fn(_state);
//    update(_state);
//  }
//}
//
//class StateBuilder<T extends GetState> extends StatefulWidget {
//  final Widget Function(dynamic) builder;
//  final bool global;
//  final String tag;
//  final bool autoRemove;
//  final bool assignId;
//  final void Function(State state) initState, dispose, didChangeDependencies;
//  final void Function(StateBuilder oldWidget, State state) didUpdateWidget;
//  final T Function() state;
//
//  const StateBuilder({
//    Key key,
//    this.state,
//    this.global = true,
//    @required this.builder,
//    this.autoRemove = true,
//    this.assignId = false,
//    this.initState,
//    this.tag,
//    this.dispose,
//    this.didChangeDependencies,
//    this.didUpdateWidget,
//  })  : assert(builder != null),
//        super(key: key);
//
//  @override
//  _StateBuilderState<T> createState() => _StateBuilderState<T>();
//}
//
//class _StateBuilderState<T extends GetState> extends State<StateBuilder<T>> {
//  T controller;
//
//  bool isCreator = false;
//
//  @override
//  void initState() {
//    super.initState();
//    if (widget.initState != null) widget.initState(this);
//    if (widget.global) {
//      final isPrepared = GetInstance().isPrepared<T>(tag: widget.tag);
//      final isRegistred = GetInstance().isRegistred<T>(tag: widget.tag);
//
//      if (isPrepared) {
//        isCreator = true;
//      } else if (isRegistred) {
//        isCreator = false;
//      } else {
//        isCreator = true;
//      }
//
//      if (isCreator) {
//        controller?.onStart();
//      }
//
//      final instance = GetInstance().putOrFind(
//        widget.state,
//        tag: widget.tag,
//      );
//      controller = instance;
//      controller._updaters.add(setState);
//    } else {
//      controller = widget.state();
//      isCreator = true;
//      controller._updaters.add(setState);
//      controller?.onStart();
//    }
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    if (widget.dispose != null) widget.dispose(this);
//    if (isCreator || widget.assignId) {
//      if (widget.autoRemove &&
//          GetInstance().isRegistred<T>(
//            tag: widget.tag,
//          )) {
//        controller._updaters.remove(setState);
//        GetInstance().delete<T>(tag: widget.tag);
//      }
//    } else {
//      controller._updaters.remove(setState);
//    }
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    if (widget.didChangeDependencies != null) {
//      widget.didChangeDependencies(this);
//    }
//  }
//
//  @override
//  void didUpdateWidget(StateBuilder oldWidget) {
//    super.didUpdateWidget(oldWidget as StateBuilder<T>);
//    if (widget.didUpdateWidget != null) {
//      widget.didUpdateWidget(oldWidget, this);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return widget.builder(controller.state);
//  }
//}

import 'package:flutter/material.dart';
import '../../../get_instance/src/get_instance.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import 'list_notifier.dart';

/// Complies with [GetStateUpdater]
///
/// This mixin's function represents a [GetStateUpdater], and might be used
/// by [GetBuilder()], [SimpleBuilder()] (or similar) to comply
/// with [GetStateUpdate] signature. REPLACING the [StateSetter].
/// Avoids the potential (but extremely unlikely) issue of having
/// the Widget in a dispose() state, and abstracts the
/// API from the ugly fn((){}).
mixin GetStateUpdaterMixin<T extends StatefulWidget> on State<T> {
  // To avoid the creation of an anonym function to be GC later.
  // ignore: prefer_function_declarations_over_variables

  /// Experimental method to replace setState((){});
  /// Used with GetStateUpdate.
  void getUpdate() {
    if (mounted) setState(() {});
  }
}

typedef GetControllerBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

// class _InheritedGetxController<T extends GetxController>
//     extends InheritedWidget {
//   final T model;
//   final int version;

//   _InheritedGetxController({
//     Key key,
//     @required Widget child,
//     @required this.model,
//   })  : version = model.notifierVersion,
//         super(key: key, child: child);

//   @override
//   bool updateShouldNotify(_InheritedGetxController<T> oldWidget) =>
//       (oldWidget.version != version);
// }

// extension WatchEtx on GetxController {
//   T watch<T extends GetxController>() {
//     final instance = Get.find<T>();
//     _GetBuilderState._currentState.watch(instance.update);
//     return instance;
//   }
// }

class GetBuilder<T extends GetxController> extends StatefulWidget {
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object id;
  final String tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value) filter;
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
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  })  : assert(builder != null),
        super(key: key);

  // static T of<T extends GetxController>(
  //   BuildContext context, {
  //   bool rebuild = false,
  // }) {
  //   var widget = rebuild
  //       ? context
  //       .dependOnInheritedWidgetOfExactType<_InheritedGetxController<T>>()
  //       : context
  //           .getElementForInheritedWidgetOfExactType<
  //               _InheritedGetxController<T>>()
  //           ?.widget;

  //   if (widget == null) {
  //     throw 'Error: Could not find the correct dependency.';
  //   } else {
  //     return (widget as _InheritedGetxController<T>).model;
  //   }
  // }

  @override
  _GetBuilderState<T> createState() => _GetBuilderState<T>();
}

class _GetBuilderState<T extends GetxController> extends State<GetBuilder<T>>
    with GetStateUpdaterMixin {
  T controller;
  bool isCreator = false;
  VoidCallback remove;
  Object _filter;
  List<VoidCallback> _watchs;

  // static _GetBuilderState _currentState;

  void watch(VoidCallback listener) {
    (_watchs ??= <VoidCallback>[]).add(listener);
  }

  @override
  void initState() {
    // _GetBuilderState._currentState = this;
    super.initState();
    widget.initState?.call(this);

    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          isCreator = true;
        } else {
          isCreator = false;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        isCreator = true;
        GetInstance().put<T>(controller, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      isCreator = true;
      controller?.onStart();
    }

    if (widget.filter != null) {
      _filter = widget.filter(controller);
    }

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    remove?.call();
    remove = (widget.id == null)
        ? controller?.addListener(
            _filter != null ? _filterUpdate : getUpdate,
          )
        : controller?.addListenerId(
            widget.id,
            _filter != null ? _filterUpdate : getUpdate,
          );
  }

  void _filterUpdate() {
    var newFilter = widget.filter(controller);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(this);
    if (isCreator || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }

    remove?.call();

    controller = null;
    isCreator = null;
    remove = null;
    _filter = null;
    _watchs = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(this);
  }

  @override
  void didUpdateWidget(GetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget as GetBuilder<T>);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
    widget.didUpdateWidget?.call(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    // return _InheritedGetxController<T>(
    //   model: controller,
    //   child: widget.builder(controller),
    // );
    return widget.builder(controller);
  }
}

// extension FindExt on BuildContext {
//   T find<T extends GetxController>() {
//     return GetBuilder.of<T>(this, rebuild: false);
//   }
// }

// extension ObserverEtx on BuildContext {
//   T obs<T extends GetxController>() {
//     return GetBuilder.of<T>(this, rebuild: true);
//   }
// }

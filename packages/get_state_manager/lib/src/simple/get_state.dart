import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_core/get_core.dart';
import 'package:get_instance/get_instance.dart';
import '../../get_state_manager.dart';

import 'simple_builder.dart';

// Changed to VoidCallback.
//typedef Disposer = void Function();

// replacing StateSetter, return if the Widget is mounted for extra validation.
// if it brings overhead the extra call,
typedef GetStateUpdate = void Function();
//typedef GetStateUpdate = void Function(VoidCallback fn);

/// Complies with [GetStateUpdater]
///
/// This mixin's function represents a [GetStateUpdater], and might be used
/// by [GetBuilder()], [SimpleBuilder()] (or similar) to comply
/// with [GetStateUpdate] signature. REPLACING the [StateSetter].
/// Avoids the potential (but extremely unlikely) issue of having
/// the Widget in a dispose() state, and abstracts the
/// API from the ugly fn((){}).
// TODO: check performance HIT for the extra method call.
mixin GetStateUpdaterMixin<T extends StatefulWidget> on State<T> {
  // To avoid the creation of an anonym function to be GC later.
  // ignore: prefer_function_declarations_over_variables
  static final VoidCallback _stateCallback = () {};

  /// Experimental method to replace setState((){});
  /// Used with GetStateUpdate.
  void getUpdate() {
    if (mounted) setState(_stateCallback);
  }
}

class GetxController extends DisposableInterface {
  final _updaters = HashSet<GetStateUpdate>();

//  final _updatersIds = HashMap<String, StateSetter>(); //<old>
  final _updatersIds = HashMap<String, GetStateUpdate>();

  final _updatersGroupIds = HashMap<String, HashSet<GetStateUpdate>>();

  /// Rebuilds [GetBuilder] each time you call [update()];
  /// Can take a List of [ids], that will only update the matching
  /// `GetBuilder( id: )`,
  /// [ids] can be reused among `GetBuilders` like group tags.
  /// The update will only notify the Widgets, if [condition] is true.
  void update([List<String> ids, bool condition = true]) {
    if (!condition) {
      return;
    }
    if (ids == null) {
//      _updaters?.forEach((rs) => rs(() {})); //<old>
      for (final updater in _updaters) {
        updater();
      }
    } else {
      // @jonny, remove this commented code if it's not more optimized.
//      for (final id in ids) {
//        if (_updatersIds[id] != null) _updatersIds[id]();
//        if (_updatersGroupIds[id] != null)
//          for (final rs in _updatersGroupIds[id]) rs();
//      }

      for (final id in ids) {
        _updatersIds[id]?.call();
        // ignore: avoid_function_literals_in_foreach_calls
        _updatersGroupIds[id]?.forEach((rs) => rs());
      }
    }
  }

//  VoidCallback addListener(StateSetter listener) {//<old>
  VoidCallback addListener(GetStateUpdate listener) {
    _updaters.add(listener);
    return () => _updaters.remove(listener);
  }

//  VoidCallback addListenerId(String key, StateSetter listener) {//<old>
  VoidCallback addListenerId(String key, GetStateUpdate listener) {
//    _printCurrentIds();
    if (_updatersIds.containsKey(key)) {
      _updatersGroupIds[key] ??= HashSet<GetStateUpdate>.identity();
      _updatersGroupIds[key].add(listener);
      return () {
        _updatersGroupIds[key].remove(listener);
      };
    } else {
      _updatersIds[key] = listener;
      return () => _updatersIds.remove(key);
    }
  }

  /// To dispose an [id] from future updates(), this ids are registered
  /// by [GetBuilder()] or similar, so is a way to unlink the state change with
  /// the Widget from the Controller.
  void disposeId(String id) {
    _updatersIds.remove(id);
    _updatersGroupIds.remove(id);
  }

  /// Remove this after checking the new implementation makes sense.
  /// Uncomment this if you wanna control the removal of ids..
  ///  bool _debugging = false;
  /// Future<void> _printCurrentIds() async {
  /// if (_debugging) return;
  /// _debugging = true;
  /// print('about to debug...');
  /// await Future.delayed(Duration(milliseconds: 10));
  /// int totalGroups = 0;
  /// _updatersGroupIds.forEach((key, value) {
  /// totalGroups += value.length;
  /// });
  /// int totalIds = _updatersIds.length;
  /// print(
  ///     'Total: ${totalIds + totalGroups},'+
  ///     'in groups:$totalGroups, solo ids:$totalIds',);
  /// _debugging = false;
  /// }
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

class _GetBuilderState<T extends GetxController> extends State<GetBuilder<T>>
    with GetStateUpdaterMixin {
  T controller;

  bool isCreator = false;
  VoidCallback remove;

  @override
  void initState() {
    super.initState();

    if (widget.initState != null) widget.initState(this);
    if (widget.global) {
      final isPrepared = GetInstance().isPrepared<T>(tag: widget.tag);
      final isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

      if (isPrepared) {
        if (Get.smartManagement != SmartManagement.keepFactory) {
          isCreator = true;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else if (isRegistered) {
        controller = GetInstance().find<T>(tag: widget.tag);
        isCreator = false;
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

    if (widget.global && Get.smartManagement == SmartManagement.onlyBuilder) {
      controller?.onStart();
    }
    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    remove?.call();
    remove = (widget.id == null)
//        ? controller?.addListener(setState) //<old>
//        : controller?.addListenerId(widget.id, setState); //<old>
        ? controller?.addListener(getUpdate)
        : controller?.addListenerId(widget.id, getUpdate);
  }

  /// Sample for [GetStateUpdate] when you don't wanna
  /// use [GetStateHelper mixin].
  ///  bool _getUpdater() {
  ///    final _mounted = mounted;
  ///    if (_mounted) setState(() {});
  ///    return _mounted;
  ///  }

  @override
  void dispose() {
    super.dispose();
    if (widget.dispose != null) widget.dispose(this);
    if (isCreator || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }

    remove?.call();
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
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
    if (widget.didUpdateWidget != null) widget.didUpdateWidget(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) => widget.builder(controller);
}

/// This is a experimental feature.
/// Meant to be used with SimpleBuilder, it auto-registers the variable
/// like Rx() does with Obx().
class Value<T> extends GetxController {
  Value([this._value]);

  T _value;

  T get value {
    TaskManager.instance.notify(_updaters);
    return _value;
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    update();
  }
}

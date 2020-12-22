import 'package:flutter/material.dart';
import '../../../get_instance/src/get_instance.dart';
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

// ignore: prefer_mixin
class GetxController extends DisposableInterface with ListNotifier {
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
      refresh();
    } else {
      for (final id in ids) {
        refreshGroup(id);
      }
    }
  }
}

typedef GetControllerBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

class GetBuilder<T extends GetxController> extends StatefulWidget {
  final GetControllerBuilder<T> builder;
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

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    remove?.call();
    remove = (widget.id == null)
        ? controller?.addListener(getUpdate)
        : controller?.addListenerId(widget.id, getUpdate);
  }

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

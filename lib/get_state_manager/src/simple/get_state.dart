import 'package:flutter/material.dart';

import '../../../get_instance/src/get_instance.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';

typedef GetControllerBuilder<T extends DisposableInterface> = Widget Function(
    T controller);

extension WatchExt on BuildContext {
  T listen<T extends GetxController>() {
    return Scope.of(this, rebuild: true);
  }
}

extension ReadExt on BuildContext {
  T find<T extends GetxController>() {
    return Scope.of(this);
  }
}

// extension FilterExt on BuildContext {
//   T filter<T extends GetxController>(Object Function(T value)? filter) {
//     return Scope.of(this, filter: filter, rebuild: true);
//   }
// }

class GetBuilder<T extends GetxController> extends StatelessWidget {
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(ScopeElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Scope<T> oldWidget, ScopeElement<T> state)?
      didUpdateWidget;
  final T? init;

  const GetBuilder({
    Key? key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scope<T>(
      init: init,
      global: global,
      autoRemove: autoRemove,
      assignId: assignId,
      initState: initState,
      filter: filter,
      tag: tag,
      dispose: dispose,
      id: id,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      child: Builder(builder: (context) {
        final controller = Scope.of<T>(context, rebuild: true);
        return builder(controller);
      }),
    );
    // return widget.builder(controller!);
  }
}

class Scope<T extends GetxController> extends InheritedWidget {
  /// Create an inherited widget that updates its dependents when [controller]
  /// sends notifications.
  ///
  /// The [child] argument is required
  const Scope({
    Key? key,
    required Widget child,
    this.init,
    this.global = true,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key, child: child);

  /// The [Listenable] object to which to listen.
  ///
  /// Whenever this object sends change notifications, the dependents of this
  /// widget are triggered.
  ///
  /// By default, whenever the [controller] is changed (including when changing to
  /// or from null), if the old controller is not equal to the new controller (as
  /// determined by the `==` operator), notifications are sent. This behavior
  /// can be overridden by overriding [updateShouldNotify].
  ///
  /// While the [controller] is null, no notifications are sent, since the null
  /// object cannot itself send notifications.
  final T? init;

  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(ScopeElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Scope<T> oldWidget, ScopeElement<T> state)?
      didUpdateWidget;

  static T of<T extends GetxController>(
    BuildContext context, {
    bool rebuild = false,
    // Object Function(T value)? filter,
  }) {
    final inheritedElement = context
        .getElementForInheritedWidgetOfExactType<Scope<T>>() as ScopeElement<T>;

    if (rebuild) {
      // var newFilter = filter?.call(inheritedElement.controller!);
      // if (newFilter != null) {
      //   context.dependOnInheritedElement(inheritedElement, aspect: newFilter);
      // } else {
      context.dependOnInheritedElement(inheritedElement);
      // }
    }

    var widget = inheritedElement.controller;

    if (widget == null) {
      throw 'Error: Could not find the correct dependency.';
    } else {
      return widget;
    }
  }

  @override
  bool updateShouldNotify(Scope<T> oldWidget) {
    return oldWidget.id != id ||
        oldWidget.global != global ||
        oldWidget.autoRemove != autoRemove ||
        oldWidget.assignId != assignId;
  }

  @override
  InheritedElement createElement() => ScopeElement<T>(this);
}

/// The ScopeElement is responsible for injecting dependencies into the widget
/// tree so that they can be observed
class ScopeElement<T extends GetxController> extends InheritedElement {
  ScopeElement(Scope<T> widget) : super(widget) {
    initState();
  }

  T? controller;
  bool? _isCreator = false;
  VoidCallback? _remove;
  Object? _filter;

  void initState() {
    widget.initState?.call(this);

    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }
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

    if (widget.filter != null) {
      _filter = widget.filter!(controller!);
    }

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _remove?.call();
    _remove = (widget.id == null)
        ? controller?.addListener(
            _filter != null ? _filterUpdate : getUpdate,
          )
        : controller?.addListenerId(
            widget.id,
            _filter != null ? _filterUpdate : getUpdate,
          );
  }

  void _filterUpdate() {
    var newFilter = widget.filter!(controller!);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  void dispose() {
    widget.dispose?.call(this);
    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }

    _remove?.call();

    controller = null;
    _isCreator = null;
    _remove = null;
    _filter = null;
  }

  @override
  Scope<T> get widget => super.widget as Scope<T>;

  var _dirty = false;

  @override
  void update(Scope<T> newWidget) {
    final oldNotifier = widget.id;
    final newNotifier = newWidget.id;
    if (oldNotifier != newNotifier) {
      _subscribeToController();
    }
    widget.didUpdateWidget?.call(widget, this);
    super.update(newWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(this);
  }

  @override
  Widget build() {
    if (_dirty) {
      notifyClients(widget);
    }
    return super.build();
  }

  void getUpdate() {
    _dirty = true;
    markNeedsBuild();
  }

  @override
  void notifyClients(Scope<T> oldWidget) {
    super.notifyClients(oldWidget);
    _dirty = false;
  }

  @override
  void unmount() {
    dispose();
    super.unmount();
  }
}

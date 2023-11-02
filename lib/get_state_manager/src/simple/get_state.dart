// ignore_for_file: overridden_fields

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import 'list_notifier.dart';

typedef InitBuilder<T> = T Function();

typedef GetControllerBuilder<T extends GetLifeCycleMixin> = Widget Function(
    T controller);

extension WatchExt on BuildContext {
  T listen<T>() {
    return Bind.of(this, rebuild: true);
  }
}

extension ReadExt on BuildContext {
  T get<T>() {
    return Bind.of(this);
  }
}

// extension FilterExt on BuildContext {
//   T filter<T extends GetxController>(Object Function(T value)? filter) {
//     return Bind.of(this, filter: filter, rebuild: true);
//   }
// }

class GetBuilder<T extends GetxController> extends StatelessWidget {
  const GetBuilder({
    required this.builder,
    super.key,
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
  });
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(BindElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Binder<T> oldWidget, BindElement<T> state)?
      didUpdateWidget;
  final T? init;

  @override
  Widget build(final BuildContext context) {
    return Binder(
      init: init == null ? null : () => init!,
      global: global,
      autoRemove: autoRemove,
      assignId: assignId,
      initState: initState,
      filter: filter,
      tag: tag,
      dispose: dispose,
      id: id,
      lazy: false,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      child: Builder(builder: (final BuildContext context) {
        final T controller = Bind.of<T>(context, rebuild: true);
        return builder(controller);
      }),
    );
    // return widget.builder(controller!);
  }
}

abstract class Bind<T> extends StatelessWidget {
  const Bind({
    required this.child,
    super.key,
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
  });
  factory Bind.builder({
    final Widget? child,
    final InitBuilder<T>? init,
    final InstanceCreateBuilderCallback<T>? create,
    final bool global = true,
    final bool autoRemove = true,
    final bool assignId = false,
    final Object Function(T value)? filter,
    final String? tag,
    final Object? id,
    final void Function(BindElement<T> state)? initState,
    final void Function(BindElement<T> state)? dispose,
    final void Function(BindElement<T> state)? didChangeDependencies,
    final void Function(Binder<T> oldWidget, BindElement<T> state)?
        didUpdateWidget,
  }) =>
      _FactoryBind<T>(
        // key: key,
        init: init,
        create: create,
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
        child: child,
      );

  final InitBuilder<T>? init;

  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(BindElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Binder<T> oldWidget, BindElement<T> state)?
      didUpdateWidget;

  final Widget? child;

  static Bind put<S>(
    final S dependency, {
    final String? tag,
    final bool permanent = false,
  }) {
    Get.put<S>(dependency, tag: tag, permanent: permanent);
    return _FactoryBind<S>(
      autoRemove: permanent,
      assignId: true,
      tag: tag,
    );
  }

  static Bind lazyPut<S>(
    final InstanceBuilderCallback<S> builder, {
    final String? tag,
    final bool fenix = true,
    // VoidCallback? onInit,
    final VoidCallback? onClose,
  }) {
    Get.lazyPut<S>(builder, tag: tag, fenix: fenix);
    return _FactoryBind<S>(
      tag: tag,
      // initState: (_) {
      //   onInit?.call();
      // },
      dispose: (final _) {
        onClose?.call();
      },
    );
  }

  static Bind create<S>(final InstanceCreateBuilderCallback<S> builder,
      {final String? tag, final bool permanent = true}) {
    return _FactoryBind<S>(
      create: builder,
      tag: tag,
      global: false,
    );
  }

  static Bind spawn<S>(final InstanceBuilderCallback<S> builder,
      {final String? tag, final bool permanent = true}) {
    Get.spawn<S>(builder, tag: tag, permanent: permanent);
    return _FactoryBind<S>(
      tag: tag,
      global: false,
      autoRemove: permanent,
    );
  }

  static S find<S>({final String? tag}) => Get.find<S>(tag: tag);

  static Future<bool> delete<S>(
          {final String? tag, final bool force = false}) async =>
      Get.delete<S>(tag: tag, force: force);

  static Future<void> deleteAll({final bool force = false}) async =>
      Get.deleteAll(force: force);

  static void reloadAll({final bool force = false}) =>
      Get.reloadAll(force: force);

  static void reload<S>(
          {final String? tag, final String? key, final bool force = false}) =>
      Get.reload<S>(tag: tag, key: key, force: force);

  static bool isRegistered<S>({final String? tag}) =>
      Get.isRegistered<S>(tag: tag);

  static bool isPrepared<S>({final String? tag}) => Get.isPrepared<S>(tag: tag);

  static void replace<P>(final P child, {final String? tag}) {
    final InstanceInfo info = Get.getInstanceInfo<P>(tag: tag);
    final bool permanent = info.isPermanent ?? false;
    delete<P>(tag: tag, force: permanent);
    Get.put(child, tag: tag, permanent: permanent);
  }

  static void lazyReplace<P>(final InstanceBuilderCallback<P> builder,
      {final String? tag, final bool? fenix}) {
    final InstanceInfo info = Get.getInstanceInfo<P>(tag: tag);
    final bool permanent = info.isPermanent ?? false;
    delete<P>(tag: tag, force: permanent);
    Get.lazyPut(builder, tag: tag, fenix: fenix ?? permanent);
  }

  static T of<T>(
    final BuildContext context, {
    final bool rebuild = false,
    // Object Function(T value)? filter,
  }) {
    final BindElement<T>? inheritedElement =
        context.getElementForInheritedWidgetOfExactType<Binder<T>>()
            as BindElement<T>?;

    if (inheritedElement == null) {
      throw BindError(controller: '$T', tag: null);
    }

    if (rebuild) {
      // var newFilter = filter?.call(inheritedElement.controller!);
      // if (newFilter != null) {
      //  context.dependOnInheritedElement(inheritedElement, aspect: newFilter);
      // } else {
      context.dependOnInheritedElement(inheritedElement);
      // }
    }

    final controller = inheritedElement.controller;

    return controller;
  }

  @factory
  Bind<T> _copyWithChild(final Widget child);
}

class _FactoryBind<T> extends Bind<T> {
  const _FactoryBind({
    super.key,
    this.child,
    this.init,
    this.create,
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
  }) : super(child: child);
  @override
  final InitBuilder<T>? init;

  final InstanceCreateBuilderCallback<T>? create;

  @override
  final bool global;
  @override
  final Object? id;
  @override
  final String? tag;
  @override
  final bool autoRemove;
  @override
  final bool assignId;
  @override
  final Object Function(T value)? filter;

  @override
  final void Function(BindElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  @override
  final void Function(Binder<T> oldWidget, BindElement<T> state)?
      didUpdateWidget;

  @override
  final Widget? child;

  @override
  Bind<T> _copyWithChild(final Widget child) {
    return Bind<T>.builder(
      init: init,
      create: create,
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
      child: child,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Binder<T>(
      create: create,
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
      child: child!,
    );
  }
}

class Binds extends StatelessWidget {
  Binds({
    required this.binds,
    required this.child,
    super.key,
  }) : assert(binds.isNotEmpty);
  final List<Bind<dynamic>> binds;
  final Widget child;

  @override
  Widget build(final BuildContext context) => binds.reversed.fold(
      child, (final Widget widget, final Bind e) => e._copyWithChild(widget));
}

class Binder<T> extends InheritedWidget {
  /// Create an inherited widget that updates its dependents when [controller]
  /// sends notifications.
  ///
  /// The [child] argument is required
  const Binder({
    required super.child,
    super.key,
    this.init,
    this.global = true,
    this.autoRemove = true,
    this.assignId = false,
    this.lazy = true,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.create,
  });

  final InitBuilder<T>? init;
  final InstanceCreateBuilderCallback? create;
  final bool global;
  final Object? id;
  final String? tag;
  final bool lazy;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(BindElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Binder<T> oldWidget, BindElement<T> state)?
      didUpdateWidget;

  @override
  bool updateShouldNotify(final Binder<T> oldWidget) {
    return oldWidget.id != id ||
        oldWidget.global != global ||
        oldWidget.autoRemove != autoRemove ||
        oldWidget.assignId != assignId;
  }

  @override
  InheritedElement createElement() => BindElement<T>(this);
}

/// The BindElement is responsible for injecting dependencies into the widget
/// tree so that they can be observed
class BindElement<T> extends InheritedElement {
  BindElement(Binder<T> super.widget) {
    initState();
  }

  final List<Disposer> disposers = <Disposer>[];

  InitBuilder<T>? _controllerBuilder;

  T? _controller;

  T get controller {
    if (_controller == null) {
      _controller = _controllerBuilder?.call();
      _subscribeToController();
      if (_controller == null) {
        throw BindError(controller: T, tag: widget.tag);
      }
      return _controller!;
    } else {
      return _controller!;
    }
  }

  bool? _isCreator = false;
  bool? _needStart = false;
  bool _wasStarted = false;
  VoidCallback? _remove;
  Object? _filter;

  void initState() {
    widget.initState?.call(this);

    final bool isRegistered = Get.isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (Get.isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }

        _controllerBuilder = () => Get.find<T>(tag: widget.tag);
      } else {
        _controllerBuilder =
            () => (widget.create?.call(this) ?? widget.init?.call()) as T;
        _isCreator = true;
        if (widget.lazy) {
          Get.lazyPut<T>(_controllerBuilder!, tag: widget.tag);
        } else {
          Get.put<T>(_controllerBuilder!(), tag: widget.tag);
        }
      }
    } else {
      if (widget.create != null) {
        _controllerBuilder = () => widget.create!.call(this) as T;
        Get.spawn<T>(_controllerBuilder!, tag: widget.tag, permanent: false);
      } else {
        _controllerBuilder = widget.init;
      }
      _controllerBuilder = (widget.create != null
              ? () => widget.create!.call(this) as T
              : null) ??
          widget.init;
      _isCreator = true;
      _needStart = true;
    }
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    if (widget.filter != null) {
      _filter = widget.filter!(_controller as T);
    }
    final void Function() filter = _filter != null ? _filterUpdate : getUpdate;
    final localController = _controller;

    if (_needStart == true && localController is GetLifeCycleMixin) {
      localController.onStart();
      _needStart = false;
      _wasStarted = true;
    }

    if (localController is GetxController) {
      _remove?.call();
      _remove = (widget.id == null)
          ? localController.addListener(filter)
          : localController.addListenerId(widget.id, filter);
    } else if (localController is Listenable) {
      _remove?.call();
      localController.addListener(filter);
      _remove = () => localController.removeListener(filter);
    } else if (localController is StreamController) {
      _remove?.call();
      final StreamSubscription stream =
          localController.stream.listen((final _) => filter());
      _remove = () => stream.cancel();
    }
  }

  void _filterUpdate() {
    final Object newFilter = widget.filter!(_controller as T);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  void dispose() {
    widget.dispose?.call(this);
    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && Get.isRegistered<T>(tag: widget.tag)) {
        Get.delete<T>(tag: widget.tag);
      }
    }

    for (final Disposer disposer in disposers) {
      disposer();
    }

    disposers.clear();

    _remove?.call();
    _controller = null;
    _isCreator = null;
    _remove = null;
    _filter = null;
    _needStart = null;
    _controllerBuilder = null;
    _controller = null;
  }

  @override
  Binder<T> get widget => super.widget as Binder<T>;

  bool _dirty = false;

  @override
  void update(final Binder<T> newWidget) {
    final Object? oldNotifier = widget.id;
    final Object? newNotifier = newWidget.id;
    if (oldNotifier != newNotifier && _wasStarted) {
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
    // return Notifier.instance.notifyAppend(
    //   NotifyData(
    //       disposers: disposers, updater: getUpdate, throwException: false),
    return super.build();
    //);
  }

  void getUpdate() {
    _dirty = true;
    markNeedsBuild();
  }

  @override
  void notifyClients(final Binder<T> oldWidget) {
    super.notifyClients(oldWidget);
    _dirty = false;
  }

  @override
  void unmount() {
    dispose();
    super.unmount();
  }
}

class BindError<T> extends Error {
  /// Creates a [BindError]
  BindError({required this.controller, required this.tag});

  /// The type of the class the user tried to retrieve
  final T controller;
  final String? tag;

  @override
  String toString() {
    if (controller == 'dynamic') {
      return '''Error: please specify type [<T>] when calling context.listen<T>() or context.find<T>() method.''';
    }

    return '''Error: No Bind<$controller>  ancestor found. To fix this, please add a Bind<$controller> widget ancestor to the current context.
      ''';
  }
}

/// [Binding] should be extended.
/// When using `GetMaterialApp`, all `GetPage`s and navigation
/// methods (like Get.to()) have a `binding` property that takes an
/// instance of Bindings to manage the
/// dependencies() (via Get.put()) for the Route you are opening.
// ignore: one_member_abstracts
abstract class Binding extends BindingsInterface<List<Bind>> {}

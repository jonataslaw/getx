import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../../get.dart';

class RouterReportManager<T> {
  /// Holds a reference to `Get.reference` when the Instance was
  /// created to manage the memory.
  static final Map<String, Route?> _routesKey = {};

  /// Stores the onClose() references of instances created with `Get.create()`
  /// using the `Get.reference`.
  /// Experimental feature to keep the lifecycle and memory management with
  /// non-singleton instances.
  static final Map<Route?, HashSet<Function>> _routesByCreate = {};

  void printInstanceStack() {
    Get.log(_routesKey.toString());
  }

  static Route? _current;

  // ignore: use_setters_to_change_properties
  static void reportCurrentRoute(Route newRoute) {
    _current = newRoute;
  }

  /// Links a Class instance [S] (or [tag]) to the current route.
  /// Requires usage of `GetMaterialApp`.
  static void reportDependencyLinkedToRoute(String depedencyKey) {
    _routesKey.putIfAbsent(depedencyKey, () => _current);
  }

  static void clearRouteKeys() {
    _routesKey.clear();
  }

  static void appendRouteByCreate(GetLifeCycleBase i) {
    _routesByCreate[_current] ??= HashSet<Function>();
    // _routesByCreate[Get.reference]!.add(i.onDelete as Function);
    _routesByCreate[_current]!.add(i.onDelete);
  }

  static void reportRouteDispose(Route disposed) {
    if (Get.smartManagement != SmartManagement.onlyBuilder) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ///TODO: Is necessary this comparator?
        if (_current != disposed) {
          _removeDependencyByRoute(disposed);
        }
      });
    }
  }

  static void reportRouteWillDispose(Route disposed) {
    final keysToRemove = <String>[];
    _routesKey.forEach((key, value) {
      if (value == disposed) {
        keysToRemove.add(key);
      }
    });

    /// Removes `Get.create()` instances registered in `routeName`.
    if (_routesByCreate.containsKey(disposed)) {
      for (final onClose in _routesByCreate[disposed]!) {
        // assure the [DisposableInterface] instance holding a reference
        // to onClose() wasn't disposed.
        onClose();
      }
      _routesByCreate[disposed]!.clear();
      _routesByCreate.remove(disposed);
    }

    for (final element in keysToRemove) {
      GetInstance().reload(key: element, closeInstance: false);
      //_routesKey.remove(element);
    }

    keysToRemove.clear();
  }

  /// Clears from memory registered Instances associated with [routeName] when
  /// using `Get.smartManagement` as [SmartManagement.full] or
  /// [SmartManagement.keepFactory]
  /// Meant for internal usage of `GetPageRoute` and `GetDialogRoute`
  static void _removeDependencyByRoute(Route routeName) {
    final keysToRemove = <String>[];
    _routesKey.forEach((key, value) {
      if (value == routeName) {
        keysToRemove.add(key);
      }
    });

    /// Removes `Get.create()` instances registered in `routeName`.
    if (_routesByCreate.containsKey(routeName)) {
      for (final onClose in _routesByCreate[routeName]!) {
        // assure the [DisposableInterface] instance holding a reference
        // to onClose() wasn't disposed.
        onClose();
      }
      _routesByCreate[routeName]!.clear();
      _routesByCreate.remove(routeName);
    }

    for (final element in keysToRemove) {
      GetInstance().delete(key: element);
      _routesKey.remove(element);
    }

    keysToRemove.clear();
  }
}

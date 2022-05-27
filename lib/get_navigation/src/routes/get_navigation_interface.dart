import 'package:flutter/widgets.dart';

import '../../../get_instance/src/bindings_interface.dart';
import '../routes/get_route.dart';
import '../routes/transitions_type.dart';

/// Enables the user to customize the intended pop behavior
///
/// Goes to either the previous _activePages entry or the previous page entry
///
/// e.g. if the user navigates to these pages
/// 1) /home
/// 2) /home/products/1234
///
/// when popping on [History] mode, it will emulate a browser back button.
///
/// so the new _activePages stack will be:
/// 1) /home
///
/// when popping on [Page] mode, it will only remove the last part of the route
/// so the new _activePages stack will be:
/// 1) /home
/// 2) /home/products
///
/// another pop will change the _activePages stack to:
/// 1) /home
enum PopMode {
  History,
  Page,
}

/// Enables the user to customize the behavior when pushing multiple routes that
/// shouldn't be duplicates
enum PreventDuplicateHandlingMode {
  /// Removes the _activePages entries until it reaches the old route
  PopUntilOriginalRoute,

  /// Simply don't push the new route
  DoNothing,

  /// Recommended - Moves the old route entry to the front
  ///
  /// With this mode, you guarantee there will be only one
  /// route entry for each location
  ReorderRoutes,

  Recreate,
}

mixin IGetNavigation {
  Future<T?> to<T>(
    Widget Function() page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    int? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<void> popModeUntil(
    String fullRoute, {
    PopMode popMode = PopMode.History,
  });

  Future<T?> off<T>(
    Widget Function() page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    int? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool preventDuplicates = true,
    bool? popGesture,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<T?>? offAll<T>(
    Widget Function() page, {
    bool Function(GetPage route)? predicate,
    bool opaque = true,
    bool? popGesture,
    int? id,
    String? routeName,
    dynamic arguments,
    List<BindingsInterface> bindings = const [],
    bool fullscreenDialog = false,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    bool showCupertinoParallax = true,
    double Function(BuildContext context)? gestureWidth,
  });

  Future<T?> toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  });

  Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    // bool Function(GetPage route)? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  Future<T?>? offNamedUntil<T>(
    String page, {
    bool Function(GetPage route)? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  });

  Future<T?> toNamedAndOffUntil<T>(
    String page,
    bool Function(GetPage) predicate, [
    Object? data,
  ]);

  Future<T?> offUntil<T>(
    Widget Function() page,
    bool Function(GetPage) predicate, [
    Object? arguments,
  ]);

  void back<T>([T? result]);

  Future<R?> backAndtoNamed<T, R>(String page, {T? result, Object? arguments});

  void backUntil(bool Function(GetPage) predicate);

  void goToUnknownPage([bool clearPages = true]);
}

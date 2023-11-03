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
  history,
  page,
}

/// Enables the user to customize the behavior when pushing multiple routes that
/// shouldn't be duplicates
enum PreventDuplicateHandlingMode {
  /// Removes the _activePages entries until it reaches the old route
  popUntilOriginalRoute,

  /// Simply don't push the new route
  doNothing,

  /// Recommended - Moves the old route entry to the front
  ///
  /// With this mode, you guarantee there will be only one
  /// route entry for each location
  reorderRoutes,

  recreate,
}

mixin IGetNavigation {
  Future<T?> to<T>(
    final Widget Function() page, {
    final bool? opaque,
    final Transition? transition,
    final Curve? curve,
    final Duration? duration,
    final String? id,
    final String? routeName,
    final bool fullscreenDialog = false,
    final dynamic arguments,
    final List<BindingsInterface> bindings = const [],
    final bool preventDuplicates = true,
    final bool? popGesture,
    final bool showCupertinoParallax = true,
    final double Function(BuildContext context)? gestureWidth,
  });

  Future<void> popModeUntil(
    final String fullRoute, {
    final PopMode popMode = PopMode.history,
  });

  Future<T?> off<T>(
    final Widget Function() page, {
    final bool? opaque,
    final Transition? transition,
    final Curve? curve,
    final Duration? duration,
    final String? id,
    final String? routeName,
    final bool fullscreenDialog = false,
    final dynamic arguments,
    final List<BindingsInterface> bindings = const [],
    final bool preventDuplicates = true,
    final bool? popGesture,
    final bool showCupertinoParallax = true,
    final double Function(BuildContext context)? gestureWidth,
  });

  Future<T?>? offAll<T>(
    final Widget Function() page, {
    final bool Function(GetPage route)? predicate,
    final bool opaque = true,
    final bool? popGesture,
    final String? id,
    final String? routeName,
    final dynamic arguments,
    final List<BindingsInterface> bindings = const [],
    final bool fullscreenDialog = false,
    final Transition? transition,
    final Curve? curve,
    final Duration? duration,
    final bool showCupertinoParallax = true,
    final double Function(BuildContext context)? gestureWidth,
  });

  Future<T?> toNamed<T>(
    final String page, {
    final dynamic arguments,
    final String? id,
    final bool preventDuplicates = true,
    final Map<String, String>? parameters,
  });

  Future<T?> offNamed<T>(
    final String page, {
    final dynamic arguments,
    final String? id,
    final Map<String, String>? parameters,
  });

  Future<T?>? offAllNamed<T>(
    final String newRouteName, {
    // bool Function(GetPage route)? predicate,
    final dynamic arguments,
    final String? id,
    final Map<String, String>? parameters,
  });

  Future<T?>? offNamedUntil<T>(
    final String page, {
    final bool Function(GetPage route)? predicate,
    final dynamic arguments,
    final String? id,
    final Map<String, String>? parameters,
  });

  Future<T?> toNamedAndOffUntil<T>(
    final String page,
    final bool Function(GetPage) predicate, [
    final Object? data,
  ]);

  Future<T?> offUntil<T>(
    final Widget Function() page,
    final bool Function(GetPage) predicate, [
    final Object? arguments,
  ]);

  void removeRoute<T>(final String name);

  void back<T>([final T? result]);

  Future<R?> backAndtoNamed<T, R>(final String page, {final T? result, final Object? arguments});

  void backUntil(final bool Function(GetPage) predicate);

  void goToUnknownPage([final bool clearPages = true]);
}

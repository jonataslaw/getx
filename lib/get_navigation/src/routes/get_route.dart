// ignore_for_file: overridden_fields

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_instance/src/bindings_interface.dart';
import '../../../get_state_manager/src/simple/get_state.dart';
import '../../get_navigation.dart';

class GetPage<T> extends Page<T> {

  GetPage({
    required this.name,
    required this.page,
    this.title,
    this.participatesInRootNavigator,
    this.gestureWidth,
    // RouteSettings settings,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameters,
    this.opaque = true,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.popGesture,
    this.binding,
    this.bindings = const [],
    this.binds = const [],
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.children = const <GetPage>[],
    this.middlewares = const [],
    this.unknownRoute,
    this.arguments,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
    this.preventDuplicateHandlingMode =
        PreventDuplicateHandlingMode.reorderRoutes,
    this.completer,
    this.inheritParentPath = true,
    final LocalKey? key,
  })  : path = _nameToRegex(name),
        assert(name.startsWith('/'),
            'It is necessary to start route name [$name] with a slash: /$name'),
        super(
          key: key ?? ValueKey(name),
          name: name,
          // arguments: Get.arguments,
        );
  final GetPageBuilder page;
  final bool? popGesture;
  final Map<String, String>? parameters;
  final String? title;
  final Transition? transition;
  final Curve curve;
  final bool? participatesInRootNavigator;
  final Alignment? alignment;
  final bool maintainState;
  final bool opaque;
  final double Function(BuildContext context)? gestureWidth;
  final BindingsInterface? binding;
  final List<BindingsInterface> bindings;
  final List<Bind> binds;
  final CustomTransition? customTransition;
  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;
  final bool fullscreenDialog;
  final bool preventDuplicates;
  final Completer<T?>? completer;
  // @override
  // final LocalKey? key;

  // @override
  // RouteSettings get settings => this;

  @override
  final Object? arguments;

  @override
  final String name;

  final bool inheritParentPath;

  final List<GetPage> children;
  final List<GetMiddleware> middlewares;
  final PathDecoded path;
  final GetPage? unknownRoute;
  final bool showCupertinoParallax;

  final PreventDuplicateHandlingMode preventDuplicateHandlingMode;
  // settings = RouteSettings(name: name, arguments: Get.arguments);

  GetPage<T> copyWith({
    final LocalKey? key,
    final String? name,
    final GetPageBuilder? page,
    final bool? popGesture,
    final Map<String, String>? parameters,
    final String? title,
    final Transition? transition,
    final Curve? curve,
    final Alignment? alignment,
    final bool? maintainState,
    final bool? opaque,
    final List<BindingsInterface>? bindings,
    final BindingsInterface? binding,
    final List<Bind>? binds,
    final CustomTransition? customTransition,
    final Duration? transitionDuration,
    final Duration? reverseTransitionDuration,
    final bool? fullscreenDialog,
    final RouteSettings? settings,
    final List<GetPage<T>>? children,
    final GetPage? unknownRoute,
    final List<GetMiddleware>? middlewares,
    final bool? preventDuplicates,
    final double Function(BuildContext context)? gestureWidth,
    final bool? participatesInRootNavigator,
    final Object? arguments,
    final bool? showCupertinoParallax,
    final Completer<T?>? completer,
    final bool? inheritParentPath,
  }) {
    return GetPage(
      key: key ?? this.key,
      participatesInRootNavigator:
          participatesInRootNavigator ?? this.participatesInRootNavigator,
      preventDuplicates: preventDuplicates ?? this.preventDuplicates,
      name: name ?? this.name,
      page: page ?? this.page,
      popGesture: popGesture ?? this.popGesture,
      parameters: parameters ?? this.parameters,
      title: title ?? this.title,
      transition: transition ?? this.transition,
      curve: curve ?? this.curve,
      alignment: alignment ?? this.alignment,
      maintainState: maintainState ?? this.maintainState,
      opaque: opaque ?? this.opaque,
      bindings: bindings ?? this.bindings,
      binds: binds ?? this.binds,
      binding: binding ?? this.binding,
      customTransition: customTransition ?? this.customTransition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
      children: children ?? this.children,
      unknownRoute: unknownRoute ?? this.unknownRoute,
      middlewares: middlewares ?? this.middlewares,
      gestureWidth: gestureWidth ?? this.gestureWidth,
      arguments: arguments ?? this.arguments,
      showCupertinoParallax:
          showCupertinoParallax ?? this.showCupertinoParallax,
      completer: completer ?? this.completer,
      inheritParentPath: inheritParentPath ?? this.inheritParentPath,
    );
  }

  @override
  Route<T> createRoute(final BuildContext context) {
    // return GetPageRoute<T>(settings: this, page: page);
    final page = PageRedirect(
      route: this,
      settings: this,
      unknownRoute: unknownRoute,
    ).getPageToRoute<T>(this, unknownRoute, context);

    return page;
  }

  static PathDecoded _nameToRegex(final String path) {
    final keys = <String?>[];

    String recursiveReplace(final Match pattern) {
      final buffer = StringBuffer('(?:');

      if (pattern[1] != null) buffer.write('.');
      buffer.write("([\\w%+-._~!\$&'()*,;=:@]+))");
      if (pattern[3] != null) buffer.write('?');

      keys.add(pattern[2]);
      return '$buffer';
    }

    final stringPath = '$path/?'
        .replaceAllMapped(RegExp(r'(\.)?:(\w+)(\?)?'), recursiveReplace)
        .replaceAll('//', '/');

    return PathDecoded(RegExp('^$stringPath\$'), keys);
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    return other is GetPage<T> && other.key == key;
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'Page')}("$name", $key, $arguments)';

  @override
  int get hashCode {
    return key.hashCode;
  }
}

@immutable
class PathDecoded {
  const PathDecoded(this.regex, this.keys);
  final RegExp regex;
  final List<String?> keys;

  @override
  int get hashCode => regex.hashCode;

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is PathDecoded &&
        other.regex == regex; // && listEquals(other.keys, keys);
  }
}

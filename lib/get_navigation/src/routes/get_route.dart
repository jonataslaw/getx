import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../get_core/src/get_main.dart';
import '../../../get_instance/get_instance.dart';
import '../../get_navigation.dart';
import 'custom_transition.dart';
import 'transitions_type.dart';

@immutable
class PathDecoded {
  const PathDecoded(this.regex, this.keys);
  final RegExp regex;
  final List<String?> keys;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PathDecoded &&
        other.regex == regex; // && listEquals(other.keys, keys);
  }

  @override
  int get hashCode => regex.hashCode;
}

class GetPage<T> extends Page<T> {
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
  final Bindings? binding;
  final List<Bindings> bindings;
  final CustomTransition? customTransition;
  final Duration? transitionDuration;
  final bool fullscreenDialog;
  final bool preventDuplicates;
  // @override
  // final LocalKey? key;

  // @override
  // RouteSettings get settings => this;

  @override
  final Object? arguments;

  @override
  final String name;

  final List<GetPage> children;
  final List<GetMiddleware>? middlewares;
  final PathDecoded path;
  final GetPage? unknownRoute;
  final bool showCupertinoParallax;

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
    this.popGesture,
    this.binding,
    this.bindings = const [],
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.children = const <GetPage>[],
    this.middlewares,
    this.unknownRoute,
    this.arguments,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
  })  : path = _nameToRegex(name),
        super(
          key: ValueKey(name),
          name: name,
          arguments: Get.arguments,
        );
  // settings = RouteSettings(name: name, arguments: Get.arguments);

  static PathDecoded _nameToRegex(String path) {
    var keys = <String?>[];

    String _replace(Match pattern) {
      var buffer = StringBuffer('(?:');

      if (pattern[1] != null) buffer.write('\.');
      buffer.write('([\\w%+-._~!\$&\'()*,;=:@]+))');
      if (pattern[3] != null) buffer.write('?');

      keys.add(pattern[2]);
      return "$buffer";
    }

    var stringPath = '$path/?'
        .replaceAllMapped(RegExp(r'(\.)?:(\w+)(\?)?'), _replace)
        .replaceAll('//', '/');

    return PathDecoded(RegExp('^$stringPath\$'), keys);
  }

  GetPage<T> copy({
    String? name,
    GetPageBuilder? page,
    bool? popGesture,
    Map<String, String>? parameters,
    String? title,
    Transition? transition,
    Curve? curve,
    Alignment? alignment,
    bool? maintainState,
    bool? opaque,
    Bindings? binding,
    List<Bindings>? bindings,
    CustomTransition? customTransition,
    Duration? transitionDuration,
    bool? fullscreenDialog,
    RouteSettings? settings,
    List<GetPage>? children,
    GetPage? unknownRoute,
    List<GetMiddleware>? middlewares,
    bool? preventDuplicates,
    final double Function(BuildContext context)? gestureWidth,
    bool? participatesInRootNavigator,
    Object? arguments,
    bool? showCupertinoParallax,
  }) {
    return GetPage(
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
      binding: binding ?? this.binding,
      bindings: bindings ?? this.bindings,
      customTransition: customTransition ?? this.customTransition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
      children: children ?? this.children,
      unknownRoute: unknownRoute ?? this.unknownRoute,
      middlewares: middlewares ?? this.middlewares,
      gestureWidth: gestureWidth ?? this.gestureWidth,
      arguments: arguments ?? this.arguments,
      showCupertinoParallax:
          showCupertinoParallax ?? this.showCupertinoParallax,
    );
  }

  @override
  Route<T> createRoute(BuildContext context) {
    // return GetPageRoute<T>(settings: this, page: page);
    return PageRedirect(
      route: this,
      settings: this,
      unknownRoute: unknownRoute,
    ).getPageToRoute<T>(this, unknownRoute);
  }
}

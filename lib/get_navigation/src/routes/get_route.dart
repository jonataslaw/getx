import 'package:flutter/widgets.dart';

import '../../../get_core/src/get_main.dart';
import '../../../get_instance/get_instance.dart';
import '../../get_navigation.dart';
import 'custom_transition.dart';
import 'transitions_type.dart';

class PathDecoded {
  const PathDecoded(this.regex, this.keys);
  final RegExp regex;
  final List<String?> keys;
}

class GetPage<T> extends Page<T> {
  @override
  final String name;
  final GetPageBuilder page;
  final bool? popGesture;
  final Map<String, String>? parameter;
  final String? title;
  final Transition? transition;
  final Curve curve;
  final Alignment? alignment;
  final bool maintainState;
  final bool opaque;
  final Bindings? binding;
  final List<Bindings> bindings;
  final CustomTransition? customTransition;
  final Duration? transitionDuration;
  final bool fullscreenDialog;
  final RouteSettings? settings;
  final List<GetPage>? children;
  final List<GetMiddleware>? middlewares;
  final PathDecoded path;
  final GetPage? unknownRoute;

  GetPage({
    required this.name,
    required this.page,
    this.title,
    this.settings,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameter,
    this.opaque = true,
    this.transitionDuration,
    this.popGesture,
    this.binding,
    this.bindings = const [],
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.children,
    this.middlewares,
    this.unknownRoute,
  }) : path = _nameToRegex(name);

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

  GetPage copy({
    String? name,
    GetPageBuilder? page,
    bool? popGesture,
    Map<String, String>? parameter,
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
    List<GetMiddleware>? middlewares,
  }) {
    return GetPage(
      name: name ?? this.name,
      page: page ?? this.page,
      popGesture: popGesture ?? this.popGesture,
      parameter: parameter ?? this.parameter,
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
      settings: settings ?? this.settings,
      children: children ?? this.children,
      middlewares: middlewares ?? this.middlewares,
    );
  }

  @override
  Object? get arguments => Get.arguments;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRedirect(
            RouteSettings(name: name, arguments: Get.arguments), unknownRoute)
        .page<T>();
  }
}

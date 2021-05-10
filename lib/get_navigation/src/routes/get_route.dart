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

  // @override
  // final LocalKey? key;

  // @override
  // RouteSettings get settings => this;

  @override
  Object? get arguments => Get.arguments;

  @override
  final String name;

  final List<GetPage>? children;
  final List<GetMiddleware>? middlewares;
  final PathDecoded path;
  final GetPage? unknownRoute;

  GetPage({
    required this.name,
    required this.page,
    this.title,
    // RouteSettings settings,
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
    GetPage? unknownRoute,
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
      // settings: settings ?? this.settings,
      children: children ?? this.children,
      unknownRoute: unknownRoute ?? this.unknownRoute,
      middlewares: middlewares ?? this.middlewares,
    );
  }

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRedirect(
      this,
      unknownRoute,
    ).page<T>();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is GetPage<T>) {
      print(other.path.hashCode == path.hashCode);
    }

    return other is GetPage<T> &&
        other.page.runtimeType == page.runtimeType &&
        other.popGesture == popGesture &&
        //   mapEquals(other.parameter, parameter) &&
        other.title == title &&
        other.transition == transition &&
        other.curve == curve &&
        other.alignment == alignment &&
        other.maintainState == maintainState &&
        other.opaque == opaque &&
        other.binding == binding &&
        //    listEquals(other.bindings, bindings) &&
        other.customTransition == customTransition &&
        other.transitionDuration == transitionDuration &&
        other.fullscreenDialog == fullscreenDialog &&
        other.name == name &&
        //     listEquals(other.children, children) &&
        //     listEquals(other.middlewares, middlewares) &&
        other.path == path &&
        other.unknownRoute == unknownRoute;
  }

  @override
  int get hashCode {
    return //page.hashCode ^
        popGesture.hashCode ^
            // parameter.hashCode ^
            title.hashCode ^
            transition.hashCode ^
            curve.hashCode ^
            alignment.hashCode ^
            maintainState.hashCode ^
            opaque.hashCode ^
            binding.hashCode ^
            // bindings.hashCode ^
            customTransition.hashCode ^
            transitionDuration.hashCode ^
            fullscreenDialog.hashCode ^
            name.hashCode ^
            //  children.hashCode ^
            // middlewares.hashCode ^
            path.hashCode ^
            unknownRoute.hashCode;
  }
}

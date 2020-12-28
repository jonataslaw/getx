import 'package:flutter/widgets.dart';

import '../../../get_instance/get_instance.dart';
import '../../get_navigation.dart';
import 'custom_transition.dart';
import 'transitions_type.dart';

class GetPage {
  final String name;
  final GetPageBuilder page;
  final bool popGesture;
  final Map<String, String> parameter;
  final String title;
  final Transition transition;
  final Curve curve;
  final Alignment alignment;
  final bool maintainState;
  final bool opaque;
  final Bindings binding;
  final List<Bindings> bindings;
  final CustomTransition customTransition;
  final Duration transitionDuration;
  final bool fullscreenDialog;
  final RouteSettings settings;
  final List<GetPage> children;
  final List<GetMiddleware> middlewares;
  final Map<String, dynamic> path;
  final List<String> keys;
  GetPage({
    @required this.name,
    @required this.page,
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
    this.bindings,
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.children,
    this.keys,
    this.middlewares,
  })  : path = normalize(name, keysList: keys),
        assert(page != null),
        assert(name != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null);

  static Map<String, dynamic> normalize(
    String path, {
    List<String> keysList,
  }) {
    var keys = List<String>.from(keysList ?? const <String>[]);
    var stringPath =
        '$path/?'.replaceAllMapped(RegExp(r'(\.)?:(\w+)(\?)?'), (placeholder) {
      var replace = StringBuffer('(?:');

      if (placeholder[1] != null) {
        replace.write('\.');
      }

      replace.write('([\\w%+-._~!\$&\'()*,;=:@]+))');

      if (placeholder[3] != null) {
        replace.write('?');
      }

      keys.add(placeholder[2]);
      return replace.toString();
    }).replaceAll('//', '/');

    return {'regex': RegExp('^$stringPath\$'), 'keys': keys};
  }

  GetPage copyWith({
    String name,
    GetPageBuilder page,
    bool popGesture,
    Map<String, String> parameter,
    String title,
    Transition transition,
    Curve curve,
    Alignment alignment,
    bool maintainState,
    bool opaque,
    Bindings binding,
    List<Bindings> bindings,
    CustomTransition customTransition,
    Duration transitionDuration,
    bool fullscreenDialog,
    RouteSettings settings,
    List<String> keys,
    List<GetPage> children,
    List<GetMiddleware> middlewares,
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
      keys: keys ?? this.keys,
      children: children ?? this.children,
      middlewares: middlewares ?? this.middlewares,
    );
  }
}

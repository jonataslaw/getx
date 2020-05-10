import 'package:flutter/widgets.dart';

import 'transitions_type.dart';

class GetRoute {
  final Widget page;
  final bool popGesture;
  final Map<String, String> parameter;
  final String title;
  final Transition transition;
  final Curve curve;
  final Alignment alignment;
  final bool maintainState;
  final bool opaque;
  final Duration transitionDuration;
  final bool fullscreenDialog;
  final RouteSettings settings;

  GetRoute({
    @required this.page,
    this.title,
    this.settings,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameter,
    this.opaque = true,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.popGesture,
    this.transition,
    this.fullscreenDialog = false,
  })  : assert(page != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null);
}

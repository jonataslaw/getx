import 'package:flutter/widgets.dart';

import '../router_report.dart';

class GetDialogRoute<T> extends PopupRoute<T> {
  GetDialogRoute({
    required RoutePageBuilder pageBuilder,
    this._barrierDismissible = true,
    this._barrierLabel,
    this._barrierColor = const Color(0x80000000),
    this._transitionDuration = const Duration(milliseconds: 200),
    this._transitionBuilder,
    super.settings,
  }) : widget = pageBuilder {
    RouterReportManager.instance.reportCurrentRoute(this);
  }

  final RoutePageBuilder widget;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  void dispose() {
    RouterReportManager.instance.reportRouteDispose(this);
    super.dispose();
  }

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder? _transitionBuilder;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: widget(context, animation, secondaryAnimation),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (_transitionBuilder == null) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
        child: child,
      );
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}

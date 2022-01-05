import 'package:flutter/material.dart';

import '../../../get.dart';
import '../router_report.dart';
import 'get_transition_mixin.dart';


mixin RouteReportMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    RouterReportManager.instance.reportCurrentRoute(this);
  }

  @override
  void dispose() {
    super.dispose();
    RouterReportManager.instance.reportRouteDispose(this);
  }
}

mixin PageRouteReportMixin<T> on Route<T> {
  @override
  void install() {
    super.install();
    RouterReportManager.instance.reportCurrentRoute(this);
  }

  @override
  void dispose() {
    super.dispose();
    RouterReportManager.instance.reportRouteDispose(this);
  }
}

class GetPageRoute<T> extends PageRoute<T> //MaterialPageRoute<T>
    with
        GetPageRouteTransitionMixin<T>,
        PageRouteReportMixin {
  /// Creates a page route for use in an iOS designed app.
  ///
  /// The [builder], [maintainState], and [fullscreenDialog] arguments must not
  /// be null.
  GetPageRoute({
    RouteSettings? settings,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.parameter,
    this.gestureWidth,
    this.curve,
    this.alignment,
    this.transition,
    this.popGesture,
    this.customTransition,
    this.barrierDismissible = false,
    this.barrierColor,
    this.binding,
    this.binds,
    this.routeName,
    this.page,
    this.title,
    this.showCupertinoParallax = true,
    this.barrierLabel,
    this.maintainState = true,
    bool fullscreenDialog = false,
    this.middlewares,
  }) : super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          // builder: (context) => Container(),
        );

  @override
  final Duration transitionDuration;
  final GetPageBuilder? page;
  final String? routeName;
  //final String reference;
  final CustomTransition? customTransition;
  final BindingsInterface? binding;
  final Map<String, String>? parameter;
  final List<Bind>? binds;

  @override
  final bool showCupertinoParallax;

  @override
  final bool opaque;
  final bool? popGesture;

  @override
  final bool barrierDismissible;
  final Transition? transition;
  final Curve? curve;
  final Alignment? alignment;
  final List<GetMiddleware>? middlewares;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  void dispose() {
    super.dispose();
    final middlewareRunner = MiddlewareRunner(middlewares);
    middlewareRunner.runOnPageDispose();
  }

  Widget? _child;

  Widget _getChild() {
    if (_child != null) return _child!;
    final middlewareRunner = MiddlewareRunner(middlewares);

    final localbinds = [
      if (binds != null) ...binds!,
    ];

    final localbindings = [
      if (binding != null) ...<BindingsInterface>[binding!],
    ];

    final bindingsToBind = middlewareRunner
        .runOnBindingsStart(binding != null ? localbindings : localbinds);

    /// Retrocompatibility workaround, remove this when Bindings api
    /// have been removed
    if (bindingsToBind != null &&
        bindingsToBind is! List<Bind> &&
        bindingsToBind is List<BindingsInterface>) {
      for (final binding in bindingsToBind) {
        binding.dependencies();
      }
    }

    final pageToBuild = middlewareRunner.runOnPageBuildStart(page)!;

    if (bindingsToBind != null &&
        bindingsToBind.isNotEmpty &&
        bindingsToBind is List<Bind>) {
      _child = Binds(
        child: middlewareRunner.runOnPageBuilt(pageToBuild()),
        binds: bindingsToBind,
      );
    } else {
      _child = middlewareRunner.runOnPageBuilt(pageToBuild());
    }

    return _child!;
  }

  @override
  Widget buildContent(BuildContext context) {
    return _getChild();
  }

  @override
  final String? title;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  final double Function(BuildContext context)? gestureWidth;
}

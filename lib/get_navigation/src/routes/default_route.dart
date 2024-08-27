import 'package:flutter/cupertino.dart';

import '../../../get.dart';
import '../router_report.dart';

@optionalTypeArgs
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

class GetPageRoute<T> extends PageRoute<T>
    with GetPageRouteTransitionMixin<T>, PageRouteReportMixin {
  /// Creates a page route for use in an iOS designed app.
  ///
  /// The [builder], [maintainState], and [fullscreenDialog] arguments must not
  /// be null.
  GetPageRoute({
    super.settings,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
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
    BindingsInterface? binding,
    List<BindingsInterface> bindings = const [],
    this.binds,
    this.routeName,
    this.page,
    this.title,
    this.showCupertinoParallax = true,
    this.barrierLabel,
    this.maintainState = true,
    super.fullscreenDialog,
    this.middlewares,
  })  : bindings = (binding == null) ? bindings : [...bindings, binding],
        _middlewareRunner = MiddlewareRunner(middlewares);

  @override
  final Duration transitionDuration;
  @override
  final Duration reverseTransitionDuration;

  final GetPageBuilder? page;
  final String? routeName;
  //final String reference;
  final CustomTransition? customTransition;
  final List<BindingsInterface> bindings;
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

  final MiddlewareRunner _middlewareRunner;

  @override
  void dispose() {
    super.dispose();
    _middlewareRunner.runOnPageDispose();
    _child = null;
  }

  Widget? _child;

  Widget _getChild() {
    if (_child != null) return _child!;

    final localBinds = [if (binds != null) ...binds!];

    final bindingsToBind = _middlewareRunner
        .runOnBindingsStart(bindings.isNotEmpty ? bindings : localBinds);

    final pageToBuild = _middlewareRunner.runOnPageBuildStart(page)!;

    if (bindingsToBind != null && bindingsToBind.isNotEmpty) {
      if (bindingsToBind is List<BindingsInterface>) {
        for (final item in bindingsToBind) {
          final dep = item.dependencies();
          if (dep is List<Bind>) {
            _child = Binds(
              binds: dep,
              child: _middlewareRunner.runOnPageBuilt(pageToBuild()),
            );
          }
        }
      } else if (bindingsToBind is List<Bind>) {
        _child = Binds(
          binds: bindingsToBind,
          child: _middlewareRunner.runOnPageBuilt(pageToBuild()),
        );
      }
    }

    return _child ??= _middlewareRunner.runOnPageBuilt(pageToBuild());
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

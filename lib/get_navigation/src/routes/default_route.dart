import 'package:flutter/material.dart';

import '../../../get.dart';
import 'custom_transition.dart';
import 'get_transition_mixin.dart';
import 'route_middleware.dart';
import 'transitions_type.dart';

class GetPageRoute<T> extends PageRoute<T> with GetPageRouteTransitionMixin<T> {
  /// Creates a page route for use in an iOS designed app.
  ///
  /// The [builder], [maintainState], and [fullscreenDialog] arguments must not
  /// be null.
  GetPageRoute({
    RouteSettings? settings,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.parameter,
    this.gestureWidth = 20.0,
    this.curve,
    this.alignment,
    this.transition,
    this.popGesture,
    this.customTransition,
    this.barrierDismissible = false,
    this.barrierColor,
    this.binding,
    this.bindings,
    this.routeName,
    this.page,
    this.title,
    this.barrierLabel,
    this.maintainState = true,
    bool fullscreenDialog = false,
    this.middlewares,
  })  : reference = "$routeName: ${settings?.hashCode ?? page.hashCode}",
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  final Duration transitionDuration;
  final GetPageBuilder? page;
  final String? routeName;
  final String reference;
  final CustomTransition? customTransition;
  final Bindings? binding;
  final Map<String, String>? parameter;
  final List<Bindings>? bindings;

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
    if (Get.smartManagement != SmartManagement.onlyBuilder) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (Get.reference != reference) {
          GetInstance().removeDependencyByRoute("$reference");
        }
      });
    }

    // if (Get.smartManagement != SmartManagement.onlyBuilder) {
    //   GetInstance().removeDependencyByRoute("$reference");
    // }

    final middlewareRunner = MiddlewareRunner(middlewares);
    middlewareRunner.runOnPageDispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    Get.reference = reference;
    final middlewareRunner = MiddlewareRunner(middlewares);
    final bindingsToBind = middlewareRunner.runOnBindingsStart(bindings);

    binding?.dependencies();
    if (bindingsToBind != null) {
      for (final binding in bindingsToBind) {
        binding.dependencies();
      }
    }

    final pageToBuild = middlewareRunner.runOnPageBuildStart(page)!;
    return middlewareRunner.runOnPageBuilt(pageToBuild());
  }

  @override
  final String? title;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  final double gestureWidth;
}

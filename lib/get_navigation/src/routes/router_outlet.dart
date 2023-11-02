import 'package:flutter/material.dart';

import '../../../get.dart';

class RouterOutlet<TDelegate extends RouterDelegate<T>, T extends Object>
    extends StatefulWidget {

  RouterOutlet({
    required final Iterable<GetPage> Function(T currentNavStack) pickPages, required final Widget Function(
      BuildContext context,
      TDelegate,
      Iterable<GetPage>? page,
    ) pageBuilder, final Key? key,
    final TDelegate? delegate,
  }) : this.builder(
            builder: (final context) {
              final currentConfig = context.delegate.currentConfiguration as T?;
              final rDelegate = context.delegate as TDelegate;
              var picked =
                  currentConfig == null ? null : pickPages(currentConfig);
              if (picked?.isEmpty ?? true) {
                picked = null;
              }
              return pageBuilder(context, rDelegate, picked);
            },
            delegate: delegate,
            key: key);

  RouterOutlet.builder({
    required this.builder, super.key,
    final TDelegate? delegate,
  }) : routerDelegate = delegate ?? Get.delegate<TDelegate, T>()!;
  final TDelegate routerDelegate;
  final Widget Function(BuildContext context) builder;
  @override
  RouterOutletState<TDelegate, T> createState() =>
      RouterOutletState<TDelegate, T>();
}

class RouterOutletState<TDelegate extends RouterDelegate<T>, T extends Object>
    extends State<RouterOutlet<TDelegate, T>> {
  RouterDelegate? delegate;
  late ChildBackButtonDispatcher _backButtonDispatcher;

  void _listener() {
    setState(() {});
  }

  VoidCallback? disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    disposer?.call();
    final router = Router.of(context);
    delegate ??= router.routerDelegate;
    delegate?.addListener(_listener);
    disposer = () => delegate?.removeListener(_listener);

    _backButtonDispatcher =
        router.backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  @override
  void dispose() {
    super.dispose();
    disposer?.call();
  }

  @override
  Widget build(final BuildContext context) {
    _backButtonDispatcher.takePriority();
    return widget.builder(context);
  }
}

class GetRouterOutlet extends RouterOutlet<GetDelegate, RouteDecoder> {
  GetRouterOutlet({
    required final String initialRoute, final Key? key,
    final String? anchorRoute,
    final Iterable<GetPage> Function(Iterable<GetPage> afterAnchor)? filterPages,
    final GetDelegate? delegate,
    final String? restorationScopeId,
  }) : this.pickPages(
          restorationScopeId: restorationScopeId,
          pickPages: (final config) {
            Iterable<GetPage<dynamic>> ret;
            if (anchorRoute == null) {
              // jump the ancestor path
              final length = Uri.parse(initialRoute).pathSegments.length;

              return config.currentTreeBranch
                  .skip(length)
                  .take(length)
                  .toList();
            }
            ret = config.currentTreeBranch.pickAfterRoute(anchorRoute);
            if (filterPages != null) {
              ret = filterPages(ret);
            }
            return ret;
          },
          key: key,
          emptyPage: (final delegate) =>
              delegate.matchRoute(initialRoute).route ?? delegate.notFoundRoute,
          navigatorKey: Get.nestedKey(anchorRoute)?.navigatorKey,
          delegate: delegate,
        );
  GetRouterOutlet.pickPages({
    required super.pickPages, super.key,
    final Widget Function(GetDelegate delegate)? emptyWidget,
    final GetPage Function(GetDelegate delegate)? emptyPage,
    final bool Function(Route<dynamic>, dynamic)? onPopPage,
    final String? restorationScopeId,
    final GlobalKey<NavigatorState>? navigatorKey,
    final GetDelegate? delegate,
  }) : super(
          pageBuilder: (final context, final rDelegate, final pages) {
            final pageRes = <GetPage?>[
              ...?pages,
              if (pages == null || pages.isEmpty) emptyPage?.call(rDelegate),
            ].whereType<GetPage>();

            if (pageRes.isNotEmpty) {
              return InheritedNavigator(
                navigatorKey: navigatorKey ??
                    Get.rootController.rootDelegate.navigatorKey,
                child: GetNavigator(
                  restorationScopeId: restorationScopeId,
                  onPopPage: onPopPage ??
                      (final route, final result) {
                        final didPop = route.didPop(result);
                        if (!didPop) {
                          return false;
                        }
                        return true;
                      },
                  pages: pageRes.toList(),
                  key: navigatorKey,
                ),
              );
            }
            return emptyWidget?.call(rDelegate) ?? const SizedBox.shrink();
          },
          delegate: delegate ?? Get.rootController.rootDelegate,
        );

  GetRouterOutlet.builder({
    required super.builder, super.key,
    final String? route,
    final GetDelegate? routerDelegate,
  }) : super.builder(
          delegate: routerDelegate ??
              (route != null
                  ? Get.nestedKey(route)
                  : Get.rootController.rootDelegate),
        );
}

class InheritedNavigator extends InheritedWidget {
  const InheritedNavigator({
    required super.child, required this.navigatorKey, super.key,
  });
  final GlobalKey<NavigatorState> navigatorKey;

  static InheritedNavigator? of(final BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedNavigator>();
  }

  @override
  bool updateShouldNotify(final InheritedNavigator oldWidget) {
    return true;
  }
}

extension NavKeyExt on BuildContext {
  GlobalKey<NavigatorState>? get parentNavigatorKey {
    return InheritedNavigator.of(this)?.navigatorKey;
  }
}

extension PagesListExt on List<GetPage> {
  /// Returns the route and all following routes after the given route.
  Iterable<GetPage> pickFromRoute(final String route) {
    return skipWhile((final value) => value.name != route);
  }

  /// Returns the routes after the given route.
  Iterable<GetPage> pickAfterRoute(final String route) {
    // If the provided route is root, we take the first route after root.
    if (route == '/') {
      return pickFromRoute(route).skip(1).take(1);
    }
    // Otherwise, we skip the route and take all routes after it.
    return pickFromRoute(route).skip(1);
  }
}

typedef NavigatorItemBuilderBuilder = Widget Function(
    BuildContext context, List<String> routes, int index);

class IndexedRouteBuilder<T> extends StatelessWidget {
  const IndexedRouteBuilder({
    required this.builder, required this.routes, super.key,
  });
  final List<String> routes;
  final NavigatorItemBuilderBuilder builder;

// Method to get the current index based on the route
  int _getCurrentIndex(final String currentLocation) {
    for (int i = 0; i < routes.length; i++) {
      if (currentLocation.startsWith(routes[i])) {
        return i;
      }
    }
    return 0; // default index
  }

  @override
  Widget build(final BuildContext context) {
    final location = context.location;
    final index = _getCurrentIndex(location);

    return builder(context, routes, index);
  }
}

mixin RouterListenerMixin<T extends StatefulWidget> on State<T> {
  RouterDelegate? delegate;

  void _listener() {
    setState(() {});
  }

  VoidCallback? disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    disposer?.call();
    final router = Router.of(context);
    delegate ??= router.routerDelegate as GetDelegate;

    delegate?.addListener(_listener);
    disposer = () => delegate?.removeListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    disposer?.call();
  }
}

class RouterListenerInherited extends InheritedWidget {
  const RouterListenerInherited({
    required super.child, super.key,
  });

  static RouterListenerInherited? of(final BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RouterListenerInherited>();
  }

  @override
  bool updateShouldNotify(covariant final InheritedWidget oldWidget) {
    return true;
  }
}

class RouterListener extends StatefulWidget {
  const RouterListener({
    required this.builder, super.key,
  });
  final WidgetBuilder builder;

  @override
  State<RouterListener> createState() => RouteListenerState();
}

class RouteListenerState extends State<RouterListener>
    with RouterListenerMixin {
  @override
  Widget build(final BuildContext context) {
    return RouterListenerInherited(child: Builder(builder: widget.builder));
  }
}

class BackButtonCallback extends StatefulWidget {
  const BackButtonCallback({required this.builder, super.key});
  final WidgetBuilder builder;

  @override
  State<BackButtonCallback> createState() => RouterListenerState();
}

class RouterListenerState extends State<BackButtonCallback>
    with RouterListenerMixin {
  late ChildBackButtonDispatcher backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = Router.of(context);
    backButtonDispatcher =
        router.backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  @override
  Widget build(final BuildContext context) {
    backButtonDispatcher.takePriority();
    return widget.builder(context);
  }
}

import 'package:flutter/material.dart';

import '../../../get.dart';

class RouterOutlet<TDelegate extends RouterDelegate<T>, T extends Object>
    extends StatefulWidget {
  final TDelegate routerDelegate;
  final Widget Function(BuildContext context) builder;

  RouterOutlet.builder({
    super.key,
    TDelegate? delegate,
    required this.builder,
  }) : routerDelegate = delegate ?? Get.delegate<TDelegate, T>()!;

  RouterOutlet({
    Key? key,
    TDelegate? delegate,
    required Iterable<GetPage> Function(T currentNavStack) pickPages,
    required Widget Function(
      BuildContext context,
      TDelegate,
      Iterable<GetPage>? page,
    ) pageBuilder,
  }) : this.builder(
            builder: (context) {
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
  Widget build(BuildContext context) {
    _backButtonDispatcher.takePriority();
    return widget.builder(context);
  }
}

class GetRouterOutlet extends RouterOutlet<GetDelegate, RouteDecoder> {
  GetRouterOutlet({
    Key? key,
    String? anchorRoute,
    required String initialRoute,
    Iterable<GetPage> Function(Iterable<GetPage> afterAnchor)? filterPages,
    GetDelegate? delegate,
  }) : this.pickPages(
          pickPages: (config) {
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
          emptyPage: (delegate) =>
              delegate.matchRoute(initialRoute).route ?? delegate.notFoundRoute,
          navigatorKey: Get.nestedKey(anchorRoute)?.navigatorKey,
          delegate: delegate,
        );
  GetRouterOutlet.pickPages({
    super.key,
    Widget Function(GetDelegate delegate)? emptyWidget,
    GetPage Function(GetDelegate delegate)? emptyPage,
    required Iterable<GetPage> Function(RouteDecoder currentNavStack) pickPages,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    GlobalKey<NavigatorState>? navigatorKey,
    GetDelegate? delegate,
  }) : super(
          pageBuilder: (context, rDelegate, pages) {
            final pageRes = <GetPage?>[
              ...?pages,
              if (pages == null || pages.isEmpty) emptyPage?.call(rDelegate),
            ].whereType<GetPage>();

            if (pageRes.isNotEmpty) {
              return GetNavigator(
                onPopPage: onPopPage ??
                    (route, result) {
                      final didPop = route.didPop(result);
                      if (!didPop) {
                        return false;
                      }
                      return true;
                    },
                pages: pageRes.toList(),
                key: navigatorKey,
              );
            }
            return (emptyWidget?.call(rDelegate) ?? const SizedBox.shrink());
          },
          pickPages: pickPages,
          delegate: delegate ?? Get.rootController.rootDelegate,
        );

  GetRouterOutlet.builder({
    super.key,
    required Widget Function(
      BuildContext context,
    ) builder,
    String? route,
    GetDelegate? routerDelegate,
  }) : super.builder(
          builder: builder,
          delegate: routerDelegate ??
              (route != null
                  ? Get.nestedKey(route)
                  : Get.rootController.rootDelegate),
        );
}

extension PagesListExt on List<GetPage> {
  Iterable<GetPage> pickAtRoute(String route) {
    return skipWhile((value) {
      return value.name != route;
    });
  }

  Iterable<GetPage> pickAfterRoute(String route) {
    return pickAtRoute(route).skip(1);
  }
}

class GetRouterOutletInherited extends InheritedWidget {
  final String anchorRoute;

  const GetRouterOutletInherited({
    super.key,
    required this.anchorRoute,
    required Widget child,
  }) : super(child: child);

  static GetRouterOutletInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GetRouterOutletInherited>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

typedef NavigatorItemBuilderBuilder = Widget Function(
    BuildContext context, List<String> routes, int index);

class IndexedRouteBuilder<T> extends StatelessWidget {
  const IndexedRouteBuilder({
    Key? key,
    required this.builder,
    required this.routes,
  }) : super(key: key);
  final List<String> routes;
  final NavigatorItemBuilderBuilder builder;

// Method to get the current index based on the route
  int _getCurrentIndex(String currentLocation) {
    for (int i = 0; i < routes.length; i++) {
      if (currentLocation.startsWith(routes[i])) {
        return i;
      }
    }
    return 0; // default index
  }

  @override
  Widget build(BuildContext context) {
    final location = context.location;
    final index = _getCurrentIndex(location);

    return builder(context, routes, index);
  }
}

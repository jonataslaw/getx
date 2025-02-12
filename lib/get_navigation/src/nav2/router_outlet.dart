import 'package:flutter/material.dart';

import '../../../get.dart';

class RouterOutlet<TDelegate extends RouterDelegate<T>, T extends Object>
    extends StatefulWidget {
  final TDelegate routerDelegate;
  final Widget Function(
    BuildContext context,
    TDelegate delegate,
    T? currentRoute,
  ) builder;

  //keys
  RouterOutlet.builder({
    Key? key,
    TDelegate? delegate,
    required this.builder,
  })  : routerDelegate = delegate ?? Get.delegate<TDelegate, T>()!,
        super(key: key);

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
          builder: (context, rDelegate, currentConfig) {
            var picked =
                currentConfig == null ? null : pickPages(currentConfig);
            if (picked?.isEmpty ?? false) {
              picked = null;
            }
            return pageBuilder(context, rDelegate, picked);
          },
          delegate: delegate,
          key: key,
        );
  @override
  RouterOutletState<TDelegate, T> createState() =>
      RouterOutletState<TDelegate, T>();
}

class RouterOutletState<TDelegate extends RouterDelegate<T>, T extends Object>
    extends State<RouterOutlet<TDelegate, T>> {
  TDelegate get delegate => widget.routerDelegate;
  @override
  void initState() {
    super.initState();
    _getCurrentRoute();
    delegate.addListener(onRouterDelegateChanged);
  }

  @override
  void dispose() {
    delegate.removeListener(onRouterDelegateChanged);
    super.dispose();
  }

  T? currentRoute;
  void _getCurrentRoute() {
    currentRoute = delegate.currentConfiguration;
  }

  void onRouterDelegateChanged() {
    setState(_getCurrentRoute);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, delegate, currentRoute);
  }
}

class GetRouterOutlet extends RouterOutlet<GetDelegate, GetNavConfig> {
  GetRouterOutlet({
    Key? key,
    String? anchorRoute,
    required String initialRoute,
    Iterable<GetPage> Function(Iterable<GetPage> afterAnchor)? filterPages,
    GlobalKey<NavigatorState>? navigatorKey,
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
          emptyPage: (delegate) =>
              Get.routeTree.matchRoute(initialRoute).route ??
              delegate.notFoundRoute,
          key: key,
          navigatorKey: navigatorKey,
          delegate: delegate,
        );
  GetRouterOutlet.pickPages({
    Key? key,
    Widget Function(GetDelegate delegate)? emptyWidget,
    GetPage Function(GetDelegate delegate)? emptyPage,
    required Iterable<GetPage> Function(GetNavConfig currentNavStack) pickPages,
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
          delegate: delegate ?? Get.rootDelegate,
          key: key,
        );

  GetRouterOutlet.builder({
    Key? key,
    required Widget Function(
      BuildContext context,
      GetDelegate delegate,
      GetNavConfig? currentRoute,
    ) builder,
    GetDelegate? routerDelegate,
  }) : super.builder(
          builder: builder,
          delegate: routerDelegate,
          key: key,
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

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';
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
    TDelegate? delegate,
    required this.builder,
  })  : routerDelegate = delegate ?? Get.delegate<TDelegate, T>()!,
        super();

  RouterOutlet({
    TDelegate? delegate,
    required List<T> Function(TDelegate routerDelegate) currentNavStack,
    required List<T> Function(List<T> currentNavStack) pickPages,
    required Widget Function(BuildContext context, TDelegate, T? page)
        pageBuilder,
  }) : this.builder(
          builder: (context, rDelegate, currentConfig) {
            final currentStack = currentNavStack(rDelegate);
            final picked = pickPages(currentStack);
            if (picked.length == 0)
              return pageBuilder(context, rDelegate, null);
            return pageBuilder(context, rDelegate, picked.last);
          },
          delegate: delegate,
        );
  @override
  _RouterOutletState<TDelegate, T> createState() =>
      _RouterOutletState<TDelegate, T>();
}

class _RouterOutletState<TDelegate extends RouterDelegate<T>, T extends Object>
    extends State<RouterOutlet<TDelegate, T>> {
  TDelegate get delegate => widget.routerDelegate;
  @override
  void initState() {
    super.initState();
    delegate.addListener(onRouterDelegateChanged);
  }

  @override
  void dispose() {
    delegate.removeListener(onRouterDelegateChanged);
    super.dispose();
  }

  T? currentRoute;

  void onRouterDelegateChanged() {
    setState(() {
      currentRoute = delegate.currentConfiguration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, delegate, currentRoute);
  }
}

class GetRouterOutlet extends RouterOutlet<GetDelegate, GetPage> {
  GetRouterOutlet.builder({
    required Widget Function(
      BuildContext context,
      GetDelegate delegate,
      GetPage? currentRoute,
    )
        builder,
    GetDelegate? routerDelegate,
  }) : super.builder(
          builder: builder,
          delegate: routerDelegate,
        );

  GetRouterOutlet({
    Widget Function(GetDelegate delegate)? emptyPage,
    required List<GetPage> Function(List<GetPage> currentNavStack) pickPages,
  }) : super(
          pageBuilder: (context, rDelegate, page) {
            final pageRoute = rDelegate.pageRoutes[page];
            if (pageRoute != null) {
              return pageRoute.buildPage(
                context,
                pageRoute.animation,
                pageRoute.secondaryAnimation,
              );
            }

            /// improve this logic abit
            return (emptyPage?.call(rDelegate) ??
                    rDelegate.notFoundRoute?.page()) ??
                SizedBox.shrink();
          },
          currentNavStack: (routerDelegate) => routerDelegate.routes,
          pickPages: pickPages,
          delegate: Get.getDelegate(),
        );
}

class RouterOutletContainerMiddleWare extends GetMiddleware {
  final String stayAt;

  RouterOutletContainerMiddleWare(this.stayAt);
  // @override
  // RouteSettings? redirect(String? route) {
  //   print('RouterOutletContainerMiddleWare: Redirect called ($route)');
  //   return null;
  // }
}

extension PagesListExt on List<GetPage> {
  List<GetPage> pickAtRoute(String route) {
    return skipWhile((value) => value.name != route).toList();
  }

  List<GetPage> pickAfterRoute(String route) {
    return skipWhile((value) => value.name != route).skip(1).toList();
  }
}

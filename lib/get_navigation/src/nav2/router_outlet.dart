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
    required List<GetPage> Function(T currentNavStack) pickPages,
    required Widget Function(
      BuildContext context,
      TDelegate,
      GetPage? page,
    )
        pageBuilder,
  }) : this.builder(
          builder: (context, rDelegate, currentConfig) {
            final picked =
                currentConfig == null ? <GetPage>[] : pickPages(currentConfig);
            if (picked.length == 0) {
              return pageBuilder(context, rDelegate, null);
            }
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
  GetRouterOutlet.builder({
    required Widget Function(
      BuildContext context,
      GetDelegate delegate,
      GetNavConfig? currentRoute,
    )
        builder,
    GetDelegate? routerDelegate,
  }) : super.builder(
          builder: builder,
          delegate: routerDelegate,
        );

  GetRouterOutlet({
    Widget Function(GetDelegate delegate)? emptyPage,
    required List<GetPage> Function(GetNavConfig currentNavStack) pickPages,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    required String name,
  }) : super(
          pageBuilder: (context, rDelegate, page) {
            final pageRoute = rDelegate.getPageRoute(page);

            if (page != null) {
              return GetNavigator(
                onPopPage: onPopPage ??
                    (a, c) {
                      return true;
                    },
                pages: [page],
                name: name,
              );
            }

            /// TODO: improve this logic abit
            return (emptyPage?.call(rDelegate) ??
                pageRoute.page?.call() ??
                SizedBox.shrink());
          },
          pickPages: pickPages,
          delegate: Get.getDelegate(),
        );
}

/// A marker outlet to identify which pages are visual
/// (handled by the navigator) and which are logical
/// (handled by the delegate)
class RouterOutletContainerMiddleWare extends GetMiddleware {
  final String stayAt;

  RouterOutletContainerMiddleWare(this.stayAt);
}

extension PagesListExt on List<GetPage> {
  List<GetPage> pickAtRoute(String route) {
    return skipWhile((value) => value.name != route).toList();
  }

  List<GetPage> pickAfterRoute(String route) {
    return skipWhile((value) => value.name != route).skip(1).toList();
  }
}

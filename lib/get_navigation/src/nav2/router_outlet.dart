import 'package:flutter/material.dart';

import '../../../get.dart';
import 'get_router_delegate.dart';

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
      List<GetPage>? page,
    )
        pageBuilder,
  }) : this.builder(
          builder: (context, rDelegate, currentConfig) {
            var picked =
                currentConfig == null ? null : pickPages(currentConfig);
            if (picked?.length == 0) {
              picked = null;
            }
            return pageBuilder(context, rDelegate, picked);
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
    Widget Function(GetDelegate delegate)? emptyWidget,
    GetPage Function(GetDelegate delegate)? emptyPage,
    required List<GetPage> Function(GetNavConfig currentNavStack) pickPages,
    bool Function(Route<dynamic>, dynamic)? onPopPage,
    String? name,
  })  : assert(
            (emptyPage == null && emptyWidget == null) ||
                (emptyPage != null && emptyWidget == null) ||
                (emptyPage == null && emptyWidget != null),
            'Either use emptyPage or emptyWidget'),
        super(
          pageBuilder: (context, rDelegate, pages) {
            final pageRes =
                (pages ?? <GetPage<dynamic>?>[emptyPage?.call(rDelegate)])
                    .whereType<GetPage<dynamic>>()
                    .toList();
            if (pageRes.length > 0) {
              return GetNavigator(
                onPopPage: onPopPage ??
                    (route, result) {
                      final didPop = route.didPop(result);
                      if (!didPop) {
                        return false;
                      }
                      return true;
                    },
                pages: pageRes,
                name: name,
              );
            }
            return (emptyWidget?.call(rDelegate) ?? SizedBox.shrink());
          },
          pickPages: pickPages,
          delegate: Get.rootDelegate,
        );
}

extension PagesListExt on List<GetPage> {
  List<GetPage> pickAtRoute(String route) {
    return skipWhile((value) => value.name != route).toList();
  }

  List<GetPage> pickAfterRoute(String route) {
    return skipWhile((value) => value.name != route).skip(1).toList();
  }
}

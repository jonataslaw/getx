import 'dart:js';

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
    TDelegate? delegate,
    required this.builder,
  })  : routerDelegate = delegate ?? Get.delegate<TDelegate, T>()!,
        super();

  RouterOutlet({
    TDelegate? delegate,
    required List<T> Function(TDelegate routerDelegate) currentNavStack,
    required List<T> Function(List<T> currentNavStack) pickPages,
    required Widget Function(T? page) pageBuilder,
  }) : this.builder(
          builder: (context, rDelegate, currentConfig) {
            final currentStack = currentNavStack(rDelegate);
            final picked = pickPages(currentStack);
            if (picked.length == 0) return pageBuilder(null);
            return pageBuilder(picked.last);
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

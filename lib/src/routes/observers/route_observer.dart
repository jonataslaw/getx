import 'package:flutter/widgets.dart';

import '../../get_main.dart';

class Routing {
  final current;
  final previous;
  final args;
  final previousArgs;
  final removed;
  final Route<dynamic> route;
  final bool isBack;
  final bool isSnackbar;
  final bool isBottomSheet;
  final bool isDialog;
  Routing({
    this.current,
    this.previous,
    this.args,
    this.previousArgs,
    this.removed,
    this.route,
    this.isBack,
    this.isSnackbar,
    this.isBottomSheet,
    this.isDialog,
  });
}

class GetObserver extends NavigatorObserver {
  final Function(Routing) routing;
  GetObserver([this.routing]);
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if ('${route?.settings?.name}' == 'snackbar') {
      if (Get.isLogEnable) print("[OPEN SNACKBAR] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      if (Get.isLogEnable) print("[OPEN BOTTOMSHEET] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      if (Get.isLogEnable) print("[OPEN DIALOG] ${route?.settings?.name}");
    } else {
      if (Get.isLogEnable) print("[GOING TO ROUTE] ${route?.settings?.name}");
    }

    final routeSend = Routing(
      removed: null,
      isBack: false,
      route: route,
      current: '${route?.settings?.name}',
      previous: '${previousRoute?.settings?.name}',
      args: route?.settings?.arguments,
      previousArgs: previousRoute?.settings?.arguments,
      isSnackbar: '${route?.settings?.name}' == 'snackbar',
      isDialog: '${route?.settings?.name}' == 'dialog',
      isBottomSheet: '${route?.settings?.name}' == 'bottomsheet',
    );
    if (routing != null) {
      routing(routeSend);
    }
    Get.setRouting(routeSend);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    if ('${route?.settings?.name}' == 'snackbar') {
      if (Get.isLogEnable) print("[CLOSE SNACKBAR] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      if (Get.isLogEnable)
        print("[CLOSE BOTTOMSHEET] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      if (Get.isLogEnable) print("[CLOSE DIALOG] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'snackbar') {
      if (Get.isLogEnable) print("[CLOSE SNACKBAR] ${route?.settings?.name}");
    } else {
      if (Get.isLogEnable) print("[BACK ROUTE] ${route?.settings?.name}");
    }

    final routeSend = Routing(
      removed: null,
      isBack: true,
      route: previousRoute,
      current: '${previousRoute?.settings?.name}',
      previous: '${route?.settings?.name}',
      args: previousRoute?.settings?.arguments,
      previousArgs: route?.settings?.arguments,
      isSnackbar: false, //'${route?.settings?.name}' == 'snackbar',
      isDialog: false, //'${route?.settings?.name}' == 'dialog',
      isBottomSheet: false, //'${route?.settings?.name}' == 'bottomsheet',
    );

    if (routing != null) {
      routing(routeSend);
    }
    Get.setRouting(routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (Get.isLogEnable) print("[REPLACE ROUTE] ${oldRoute?.settings?.name}");
    if (Get.isLogEnable) print("[NEW ROUTE] ${newRoute?.settings?.name}");

    final routeSend = Routing(
        removed: null, // add '${oldRoute?.settings?.name}' or remain null ???
        isBack: false,
        route: newRoute,
        current: '${newRoute?.settings?.name}',
        previous: '${oldRoute?.settings?.name}',
        args: newRoute?.settings?.arguments,
        isSnackbar: null,
        isBottomSheet: null,
        isDialog: null,
        previousArgs: null);

    if (routing != null) {
      routing(routeSend);
    }
    Get.setRouting(routeSend);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    if (Get.isLogEnable) print("[REMOVING ROUTE] ${route?.settings?.name}");

    final routeSend = Routing(
        isBack: false,
        route: previousRoute,
        current: '${previousRoute?.settings?.name}',
        removed: '${route?.settings?.name}',
        previous: null,
        isSnackbar: null,
        isBottomSheet: null,
        isDialog: null,
        args: previousRoute?.settings?.arguments,
        previousArgs: route?.settings?.arguments);

    if (routing != null) {
      routing(routeSend);
    }
    Get.setRouting(routeSend);
  }
}

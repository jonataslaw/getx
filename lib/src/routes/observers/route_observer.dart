import 'package:flutter/widgets.dart';
import 'package:get/src/root/smart_management.dart';
import '../../get_instance.dart';
import '../../get_main.dart';

class Routing {
  String current;
  String previous;
  Object args;
  String removed;
  Route<dynamic> route;
  bool isBack;
  bool isSnackbar;
  bool isBottomSheet;
  bool isDialog;
  Routing({
    this.current,
    this.previous,
    this.args,
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

  Route<dynamic> route;
  bool isBack;
  bool isSnackbar;
  bool isBottomSheet;
  bool isDialog;
  String current;
  String previous;
  Object args;
  // String previousArgs;
  String removed;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if ('${route?.settings?.name}' == 'snackbar') {
      if (GetConfig.isLogEnable)
        print("[OPEN SNACKBAR] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      if (GetConfig.isLogEnable)
        print("[OPEN BOTTOMSHEET] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      if (GetConfig.isLogEnable)
        print("[OPEN DIALOG] ${route?.settings?.name}");
    } else {
      if (GetConfig.isLogEnable)
        print("[GOING TO ROUTE] ${route?.settings?.name}");
    }

    isSnackbar = '${route?.settings?.name}' == 'snackbar';
    isDialog = '${route?.settings?.name}' == 'dialog';
    isBottomSheet = '${route?.settings?.name}' == 'bottomsheet';
    current = '${route?.settings?.name}';
    previous = '${previousRoute?.settings?.name}';
    args = route?.settings?.arguments;
    // previousArgs = previousRoute?.settings?.arguments;

    final routeSend = Routing(
      removed: null,
      isBack: false,
      route: route,
      current: '${route?.settings?.name}',
      previous: '${previousRoute?.settings?.name}',
      args: route?.settings?.arguments,
      //  previousArgs: previousRoute?.settings?.arguments,
      isSnackbar: isSnackbar,
      isDialog: isDialog,
      isBottomSheet: isBottomSheet,
    );
    if (routing != null) {
      routing(routeSend);
    }
    GetConfig.currentRoute = current;
    Get.setRouting(routeSend);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    if ('${route?.settings?.name}' == 'snackbar') {
      if (GetConfig.isLogEnable)
        print("[CLOSE SNACKBAR] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      if (GetConfig.isLogEnable)
        print("[CLOSE BOTTOMSHEET] ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      if (GetConfig.isLogEnable)
        print("[CLOSE DIALOG] ${route?.settings?.name}");
    } else {
      if (GetConfig.isLogEnable) print("[BACK ROUTE] ${route?.settings?.name}");
    }

    if (GetConfig.smartManagement != SmartManagement.onlyBuilder) {
      GetInstance().removeDependencyByRoute("${route?.settings?.name}");
    }

    isSnackbar = false;
    isDialog = false;
    isBottomSheet = false;
    current = '${previousRoute?.settings?.name}';
    previous = '${route?.settings?.name}';
    args = previousRoute?.settings?.arguments;
    // previousArgs = route?.settings?.arguments;

    final routeSend = Routing(
      removed: null,
      isBack: true,
      route: previousRoute,
      current: '${previousRoute?.settings?.name}',
      previous: '${route?.settings?.name}',
      args: previousRoute?.settings?.arguments,
      //  previousArgs: route?.settings?.arguments,
      isSnackbar: false, //'${route?.settings?.name}' == 'snackbar',
      isDialog: false, //'${route?.settings?.name}' == 'dialog',
      isBottomSheet: false, //'${route?.settings?.name}' == 'bottomsheet',
    );

    if (routing != null) {
      routing(routeSend);
    }
    GetConfig.currentRoute = current;
    Get.setRouting(routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (GetConfig.isLogEnable)
      print("[REPLACE ROUTE] ${oldRoute?.settings?.name}");
    if (GetConfig.isLogEnable) print("[NEW ROUTE] ${newRoute?.settings?.name}");

    if (GetConfig.smartManagement == SmartManagement.full) {
      GetInstance().removeDependencyByRoute("${oldRoute?.settings?.name}");
    }

    isSnackbar = false;
    isDialog = false;
    isBottomSheet = false;

    final routeSend = Routing(
      removed: null, // add '${oldRoute?.settings?.name}' or remain null ???
      isBack: false,
      route: newRoute,
      current: '${newRoute?.settings?.name}',
      previous: '${oldRoute?.settings?.name}',
      args: newRoute?.settings?.arguments,
      //  previousArgs: newRoute?.settings?.arguments,
      isSnackbar: false,
      isBottomSheet: false,
      isDialog: false,
    );

    if (routing != null) {
      routing(routeSend);
    }
    GetConfig.currentRoute = current;
    Get.setRouting(routeSend);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    if (GetConfig.isLogEnable)
      print("[REMOVING ROUTE] ${route?.settings?.name}");

    if (GetConfig.smartManagement == SmartManagement.full) {
      GetInstance().removeDependencyByRoute("${route?.settings?.name}");
    }

    final routeSend = Routing(
      isBack: false,
      route: previousRoute,
      // current: '${previousRoute?.settings?.name}',
      current: current,
      args: args,
      removed: '${route?.settings?.name}',
      // args: previousRoute?.settings?.arguments,
      isSnackbar: isSnackbar,
      isBottomSheet: isBottomSheet,
      isDialog: isDialog,
      //   previousArgs: route?.settings?.arguments,
    );

    if (routing != null) {
      routing(routeSend);
    }
    GetConfig.currentRoute = current;
    Get.setRouting(routeSend);
  }
}

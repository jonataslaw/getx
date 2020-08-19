import 'package:flutter/widgets.dart';
import 'package:get/src/instance/get_instance.dart';

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
    this.current = '',
    this.previous = '',
    this.args,
    this.removed = '',
    this.route,
    this.isBack,
    this.isSnackbar,
    this.isBottomSheet,
    this.isDialog,
  });

  void update(void fn(Routing value)) {
    fn(this);
    GetConfig.currentRoute = this.current;
  }
}

class GetObserver extends NavigatorObserver {
  final Function(Routing) routing;

  GetObserver([this.routing, this._routeSend]);
  final Routing _routeSend;

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
      GetConfig.log("[GETX] OPEN SNACKBAR ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      GetConfig.log("[GETX] OPEN BOTTOMSHEET ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      GetConfig.log("[GETX] OPEN DIALOG ${route?.settings?.name}");
    } else {
      GetConfig.log("[GETX] GOING TO ROUTE ${route?.settings?.name}");
    }

    _routeSend.update((value) {
      if (route is PageRoute) value.current = '${route?.settings?.name}';
      value.args = route?.settings?.arguments;
      value.route = route;
      value.isBack = false;
      value.removed = '';
      value.previous = '${previousRoute?.settings?.name}';
      value.isSnackbar = '${route?.settings?.name}' == 'snackbar';
      value.isBottomSheet = '${route?.settings?.name}' == 'bottomsheet';
      value.isDialog = '${route?.settings?.name}' == 'dialog';
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    if ('${route?.settings?.name}' == 'snackbar') {
      GetConfig.log("[GETX] CLOSE SNACKBAR ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'bottomsheet') {
      GetConfig.log("[GETX] CLOSE BOTTOMSHEET ${route?.settings?.name}");
    } else if ('${route?.settings?.name}' == 'dialog') {
      GetConfig.log("[GETX] CLOSE DIALOG ${route?.settings?.name}");
    } else {
      GetConfig.log("[GETX] BACK ROUTE ${route?.settings?.name}");
    }

    _routeSend.update((value) {
      if (previousRoute is PageRoute)
        value.current = '${previousRoute?.settings?.name}';
      value.args = route?.settings?.arguments;
      value.route = previousRoute;
      value.isBack = true;
      value.removed = '';
      value.previous = '${route?.settings?.name}';
      value.isSnackbar = false;
      value.isBottomSheet = false;
      value.isDialog = false;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    GetConfig.log("[GETX] REPLACE ROUTE ${oldRoute?.settings?.name}");
    GetConfig.log("[GETX] NEW ROUTE ${newRoute?.settings?.name}");

    _routeSend.update((value) {
      if (newRoute is PageRoute) value.current = '${newRoute?.settings?.name}';
      value.args = newRoute?.settings?.arguments;
      value.route = newRoute;
      value.isBack = false;
      value.removed = '';
      value.previous = '${oldRoute?.settings?.name}';
      value.isSnackbar = false;
      value.isBottomSheet = false;
      value.isDialog = false;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    GetConfig.log("[GETX] REMOVING ROUTE ${route?.settings?.name}");

    _routeSend.update((value) {
      value.route = previousRoute;
      value.isBack = false;
      value.removed = '${route?.settings?.name}';
      value.previous = '${route?.settings?.name}';
    });
    if (routing != null) routing(_routeSend);
  }
}

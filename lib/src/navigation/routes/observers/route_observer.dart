import 'package:flutter/widgets.dart';

import '../../../../route_manager.dart';
import '../../../instance/get_instance.dart';
import '../../dialog/dialog_route.dart';
import '../../snackbar/snack_route.dart';
import '../default_route.dart';

class Routing {
  String current;
  String previous;
  dynamic args;
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
  dynamic args;

  // String previousArgs;
  String removed;

  String name(Route<dynamic> route) {
    if (route?.settings?.name != null) {
      return route.settings.name;
    } else if (route is GetPageRoute) {
      return route.routeName;
    } else if (route is GetDialogRoute) {
      return route.name;
    } else if (route is GetModalBottomSheetRoute) {
      return route.name;
    } else {
      return route?.settings?.name;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    var isGetPageRoute = route is GetPageRoute;
    var isSnackbar = route is SnackRoute;
    var isDialog = route is GetDialogRoute;
    var isBottomSheet = route is GetModalBottomSheetRoute;
    var routeName = name(route);

    if (isSnackbar) {
      GetConfig.log("OPEN SNACKBAR $routeName");
    } else if (isBottomSheet || isDialog) {
      GetConfig.log("OPEN $routeName");
    } else if (isGetPageRoute) {
      GetConfig.log("GOING TO ROUTE $routeName");
    }
    GetConfig.currentRoute = routeName;

    _routeSend?.update((value) {
      if (route is PageRoute) value.current = routeName;
      value.args = route?.settings?.arguments;
      value.route = route;
      value.isBack = false;
      value.removed = '';
      value.previous = previousRoute?.settings?.name ?? '';
      value.isSnackbar = isSnackbar;
      value.isBottomSheet = isBottomSheet;
      value.isDialog = isDialog;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    var isGetPageRoute = route is GetPageRoute;
    var isSnackbar = route is SnackRoute;
    var isDialog = route is GetDialogRoute;
    var isBottomSheet = route is GetModalBottomSheetRoute;
    var routeName = name(route);

    if (isSnackbar) {
      GetConfig.log("CLOSE SNACKBAR $routeName");
    } else if (isBottomSheet || isDialog) {
      GetConfig.log("CLOSE $routeName");
    } else if (isGetPageRoute) {
      GetConfig.log("CLOSE TO ROUTE $routeName");
    }
    GetConfig.currentRoute = routeName;

    _routeSend?.update((value) {
      if (previousRoute is PageRoute) {
        value.current = previousRoute?.settings?.name ?? '';
      }
      value.args = route?.settings?.arguments;
      value.route = previousRoute;
      value.isBack = true;
      value.removed = '';
      value.previous = route?.settings?.name ?? '';
      value.isSnackbar = false;
      value.isBottomSheet = false;
      value.isDialog = false;
    });
    if (routing != null) routing(_routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    GetConfig.log("REPLACE ROUTE ${oldRoute?.settings?.name}");
    GetConfig.log("NEW ROUTE ${newRoute?.settings?.name}");

    GetConfig.currentRoute = name(newRoute);

    _routeSend?.update((value) {
      if (newRoute is PageRoute) value.current = newRoute?.settings?.name ?? '';
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
    GetConfig.log("REMOVING ROUTE ${route?.settings?.name}");

    _routeSend?.update((value) {
      value.route = previousRoute;
      value.isBack = false;
      value.removed = route?.settings?.name ?? '';
      value.previous = route?.settings?.name ?? '';
    });
    if (routing != null) routing(_routeSend);
  }
}

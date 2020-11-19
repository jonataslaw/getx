import 'package:flutter/widgets.dart';
import '../../../../get_core/get_core.dart';
import '../../../get_navigation.dart';
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

/// Extracts the name of a route based on it's instance type
/// or null if not possible.
String _extractRouteName(Route route) {
  if (route?.settings?.name != null) {
    return route.settings.name;
  }

  if (route is GetPageRoute) {
    return route.routeName;
  }

  if (route is GetDialogRoute) {
    return route.name;
  }

  if (route is GetModalBottomSheetRoute) {
    return route.name;
  }

  return null;
}

/// This is basically a util for rules about 'what a route is'
class _RouteData {
  final bool isGetPageRoute;
  final bool isSnackbar;
  final bool isBottomSheet;
  final bool isDialog;
  final String name;

  _RouteData({
    @required this.name,
    @required this.isGetPageRoute,
    @required this.isSnackbar,
    @required this.isBottomSheet,
    @required this.isDialog,
  });

  factory _RouteData.ofRoute(Route route) {
    return _RouteData(
      name: _extractRouteName(route),
      isGetPageRoute: route is GetPageRoute,
      isSnackbar: route is SnackRoute,
      isDialog: route is GetDialogRoute,
      isBottomSheet: route is GetModalBottomSheetRoute,
    );
  }
}

class GetObserver extends NavigatorObserver {
  final Function(Routing) routing;

  GetObserver([this.routing, this._routeSend]);

  final Routing _routeSend;

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    final newRoute = _RouteData.ofRoute(route);

    if (newRoute.isSnackbar) {
      Get.log("OPEN SNACKBAR ${newRoute.name}");
    } else if (newRoute.isBottomSheet || newRoute.isDialog) {
      Get.log("OPEN ${newRoute.name}");
    } else if (newRoute.isGetPageRoute) {
      Get.log("GOING TO ROUTE ${newRoute.name}");
    }

    Get.reference = newRoute.name;
    _routeSend?.update((value) {
      // Only PageRoute is allowed to change current value
      if (route is PageRoute) {
        value.current = newRoute.name ?? '';
      }

      value.args = route?.settings?.arguments;
      value.route = route;
      value.isBack = false;
      value.removed = '';
      value.previous = _extractRouteName(previousRoute) ?? '';
      value.isSnackbar = newRoute.isSnackbar ? true : value.isSnackbar ?? false;
      value.isBottomSheet = newRoute.isBottomSheet ? true : value.isBottomSheet ?? false;
      value.isDialog = newRoute.isDialog ? true : value.isDialog ?? false;
    });

    if (routing != null) {
      routing(_routeSend);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    final currentRoute = _RouteData.ofRoute(route);
    final newRoute = _RouteData.ofRoute(previousRoute);

    if (currentRoute.isSnackbar) {
      Get.log("CLOSE SNACKBAR ${currentRoute.name}");
    } else if (currentRoute.isBottomSheet || currentRoute.isDialog) {
      Get.log("CLOSE ${currentRoute.name}");
    } else if (currentRoute.isGetPageRoute) {
      Get.log("CLOSE TO ROUTE ${currentRoute.name}");
    }

    Get.reference = newRoute.name;
    // Here we use a 'inverse didPush set', meaning that we use
    // previous route instead of 'route' because this is
    // a 'inverse push'
    _routeSend?.update((value) {
      // Only PageRoute is allowed to change current value
      if (previousRoute is PageRoute) {
        value.current = _extractRouteName(previousRoute) ?? '';
      }

      value.args = route?.settings?.arguments;
      value.route = previousRoute;
      value.isBack = true;
      value.removed = '';
      value.previous = newRoute.name ?? '';
      value.isSnackbar = currentRoute.isSnackbar ? false : value.isSnackbar;
      value.isBottomSheet = currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    routing?.call(_routeSend);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final newName = _extractRouteName(newRoute);
    final oldName = _extractRouteName(oldRoute);

    final currentRoute = _RouteData.ofRoute(oldRoute);

    Get.log("REPLACE ROUTE $oldName");
    Get.log("NEW ROUTE $newName");

    Get.reference = newName;
    _routeSend?.update((value) {
      // Only PageRoute is allowed to change current value
      if (newRoute is PageRoute) {
        value.current = newName ?? '';
      }

      value.args = newRoute?.settings?.arguments;
      value.route = newRoute;
      value.isBack = false;
      value.removed = '';
      value.previous = '$oldName';
      value.isSnackbar = currentRoute.isSnackbar ? false : value.isSnackbar;
      value.isBottomSheet = currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    routing?.call(_routeSend);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    final routeName = _extractRouteName(route);
    final currentRoute = _RouteData.ofRoute(route);

    Get.log("REMOVING ROUTE $routeName");
    _routeSend?.update((value) {
      value.route = previousRoute;
      value.isBack = false;
      value.removed = routeName ?? '';
      value.previous = routeName ?? '';
      value.isSnackbar = currentRoute.isSnackbar ? false : value.isSnackbar;
      value.isBottomSheet = currentRoute.isBottomSheet ? false : value.isBottomSheet;
      value.isDialog = currentRoute.isDialog ? false : value.isDialog;
    });

    routing?.call(_routeSend);
  }
}

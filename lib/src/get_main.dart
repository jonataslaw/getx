import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/src/get_instance.dart';
import 'package:get/src/get_interface.dart';
import 'bottomsheet/bottomsheet.dart';
import 'platform/platform.dart';
import 'root/root_controller.dart';
import 'routes/bindings_interface.dart';
import 'routes/default_route.dart';
import 'routes/observers/route_observer.dart';
import 'routes/transitions_type.dart';
import 'snackbar/snack.dart';

///Use to instead of Navigator.push, off instead of Navigator.pushReplacement,
///offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
///after them. Example: toNamed, offNamed, and AllNamed.
///To return to the previous screen, use back().
///No need to pass any context to Get, just put the name of the route inside
///the parentheses and the magic will occur.
class GetImpl implements GetService {
  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;
  Transition defaultTransition =
      (GetPlatform.isIOS ? Transition.cupertino : Transition.fade);
  Duration defaultDurationTransition = Duration(milliseconds: 400);
  bool defaultGlobalState = true;
  RouteSettings settings;

  ///Use to instead of Navigator.push, off instead of Navigator.pushReplacement,
  ///offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: toNamed, offNamed, and AllNamed.
  ///To return to the previous screen, use back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.

  /// It replaces Navigator.push, but needs no context, and it doesn't have the Navigator.push
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  Future<T> to<T>(Widget page,
      {bool opaque,
      Transition transition,
      Duration duration,
      int id,
      bool fullscreenDialog = false,
      Object arguments,
      Bindings binding,
      bool popGesture}) {
    return global(id).currentState.push(GetRouteBase(
        opaque: opaque ?? true,
        page: page,
        settings: RouteSettings(
            name: '/' + page.toString().toLowerCase(), arguments: arguments),
        popGesture: popGesture ?? defaultPopGesture,
        transition: transition ?? defaultTransition,
        fullscreenDialog: fullscreenDialog,
        binding: binding,
        transitionDuration: duration ?? defaultDurationTransition));
  }

  /// It replaces Navigator.pushNamed, but needs no context, and it doesn't have the Navigator.pushNamed
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  Future<T> toNamed<T>(String page, {Object arguments, int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState.pushNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.pushReplacementNamed, but needs no context.
  Future<T> offNamed<T>(String page, {Object arguments, int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id)
        .currentState
        .pushReplacementNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.popUntil, but needs no context.
  void until(RoutePredicate predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState.popUntil(predicate);
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context.
  Future<T> offUntil<T>(Route<T> page, RoutePredicate predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState.pushAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  Future<T> offNamedUntil<T>(String page, RoutePredicate predicate,
      {int id, Object arguments}) {
    return global(id)
        .currentState
        .pushNamedAndRemoveUntil(page, predicate, arguments: arguments);
  }

  /// It replaces Navigator.popAndPushNamed, but needs no context.
  Future<T> offAndToNamed<T>(String page,
      {Object arguments, int id, dynamic result}) {
    return global(id)
        .currentState
        .popAndPushNamed(page, arguments: arguments, result: result);
  }

  /// It replaces Navigator.removeRoute, but needs no context.
  void removeRoute(Route<dynamic> route, {int id}) {
    return global(id).currentState.removeRoute(route);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  Future<T> offAllNamed<T>(String newRouteName,
      {RoutePredicate predicate, Object arguments, int id}) {
    var route = (Route<dynamic> rota) => false;

    return global(id).currentState.pushNamedAndRemoveUntil(
        newRouteName, predicate ?? route,
        arguments: arguments);
  }

  bool get isOverlaysOpen =>
      (isSnackbarOpen || isDialogOpen || isBottomSheetOpen);

  bool get isOverlaysClosed =>
      (!isSnackbarOpen && !isDialogOpen && !isBottomSheetOpen);

  /// It replaces Navigator.pop, but needs no context.
  void back({dynamic result, bool closeOverlays = false, int id}) {
    if (closeOverlays && isOverlaysOpen) {
      navigator.popUntil((route) {
        return (isOverlaysClosed);
      });
    }
    if (global(id).currentState.canPop()) {
      global(id).currentState.pop(result);
    }
  }

  /// It will close as many screens as you define. Times must be> 0;
  void close(int times, [int id]) {
    if ((times == null) || (times < 1)) {
      times = 1;
    }
    int count = 0;
    void back = global(id).currentState.popUntil((route) {
      return count++ == times;
    });
    return back;
  }

  /// It replaces Navigator.pushReplacement, but needs no context, and it doesn't have the Navigator.pushReplacement
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  Future<T> off<T>(Widget page,
      {bool opaque = false,
      Transition transition,
      bool popGesture,
      int id,
      Object arguments,
      Bindings binding,
      bool fullscreenDialog = false,
      Duration duration}) {
    return global(id).currentState.pushReplacement(GetRouteBase(
        opaque: opaque ?? true,
        page: page,
        binding: binding,
        settings: RouteSettings(
            name: '/' + page.toString().toLowerCase(), arguments: arguments),
        fullscreenDialog: fullscreenDialog,
        popGesture: popGesture ?? defaultPopGesture,
        transition: transition ?? defaultTransition,
        transitionDuration: duration ?? defaultDurationTransition));
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  Future<T> offAll<T>(Widget page,
      {RoutePredicate predicate,
      bool opaque = false,
      bool popGesture,
      int id,
      Object arguments,
      Bindings binding,
      bool fullscreenDialog = false,
      Transition transition}) {
    var route = (Route<dynamic> rota) => false;

    return global(id).currentState.pushAndRemoveUntil(
        GetRouteBase(
          opaque: opaque ?? true,
          popGesture: popGesture ?? defaultPopGesture,
          page: page,
          binding: binding,
          settings: RouteSettings(
              name: '/' + page.toString().toLowerCase(), arguments: arguments),
          fullscreenDialog: fullscreenDialog,
          transition: transition ?? defaultTransition,
        ),
        predicate ?? route);
  }

  /// Show a dialog
  Future<T> dialog<T>(
    Widget child, {
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    //  RouteSettings routeSettings
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: RouteSettings(name: 'dialog'),
      context: overlayContext,
      builder: (_) {
        return child;
      },
    );
  }

  /// Api from showGeneralDialog with no context
  Future<T> generalDialog<T>({
    @required RoutePageBuilder pageBuilder,
    String barrierLabel = "Dismiss",
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
  }) {
    return showGeneralDialog(
      pageBuilder: pageBuilder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      useRootNavigator: useRootNavigator,
      routeSettings: RouteSettings(name: 'dialog'),
      context: overlayContext,
    );
  }

  Future<T> defaultDialog<T>({
    String title = "Alert",
    Widget content,
    VoidCallback onConfirm,
    VoidCallback onCancel,
    VoidCallback onCustom,
    Color cancelTextColor,
    Color confirmTextColor,
    String textConfirm,
    String textCancel,
    String textCustom,
    Widget confirm,
    Widget cancel,
    Widget custom,
    Color backgroundColor,
    Color buttonColor,
    String middleText = "Dialog made in 3 lines of code",
    double radius = 20.0,
    List<Widget> actions,
  }) {
    bool leanCancel = onCancel != null || textCancel != null;
    bool leanConfirm = onConfirm != null || textConfirm != null;
    actions ??= [];

    if (cancel != null) {
      actions.add(cancel);
    } else {
      if (leanCancel) {
        actions.add(FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            onCancel?.call();
            back();
          },
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            textCancel ?? "Cancel",
            style: TextStyle(color: cancelTextColor ?? theme.accentColor),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: buttonColor ?? theme.accentColor,
                  width: 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(100)),
        ));
      }
    }
    if (confirm != null) {
      actions.add(confirm);
    } else {
      if (leanConfirm) {
        actions.add(FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: buttonColor ?? theme.accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: Text(
              textConfirm ?? "Ok",
              style: TextStyle(color: confirmTextColor ?? theme.primaryColor),
            ),
            onPressed: () {
              onConfirm?.call();
            }));
      }
    }
    return dialog(AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      title: Text(title, textAlign: TextAlign.center),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          content ?? Text(middleText ?? "", textAlign: TextAlign.center),
          SizedBox(height: 16),
          ButtonTheme(
            minWidth: 78.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          )
        ],
      ),
      // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
      buttonPadding: EdgeInsets.zero,
    ));
  }

  Future<T> bottomSheet<T>(
    Widget bottomsheet, {
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool ignoreSafeArea,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    assert(bottomsheet != null);
    assert(isScrollControlled != null);
    assert(useRootNavigator != null);
    assert(isDismissible != null);
    assert(enableDrag != null);

    return Navigator.of(overlayContext, rootNavigator: useRootNavigator)
        .push(GetModalBottomSheetRoute<T>(
      builder: (_) => bottomsheet,
      theme: Theme.of(key.currentContext, shadowThemeOnly: true),
      isScrollControlled: isScrollControlled,
      barrierLabel:
          MaterialLocalizations.of(key.currentContext).modalBarrierDismissLabel,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      shape: shape,
      removeTop: ignoreSafeArea ?? true,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      settings: RouteSettings(name: "bottomsheet"),
      enableDrag: enableDrag,
    ));
  }

  void rawSnackbar(
      {String title,
      String message,
      Widget titleText,
      Widget messageText,
      Widget icon,
      bool instantInit = true,
      bool shouldIconPulse = true,
      double maxWidth,
      EdgeInsets margin = const EdgeInsets.all(0.0),
      EdgeInsets padding = const EdgeInsets.all(16),
      double borderRadius = 0.0,
      Color borderColor,
      double borderWidth = 1.0,
      Color backgroundColor = const Color(0xFF303030),
      Color leftBarIndicatorColor,
      List<BoxShadow> boxShadows,
      Gradient backgroundGradient,
      FlatButton mainButton,
      OnTap onTap,
      Duration duration = const Duration(seconds: 3),
      bool isDismissible = true,
      SnackDismissDirection dismissDirection = SnackDismissDirection.VERTICAL,
      bool showProgressIndicator = false,
      AnimationController progressIndicatorController,
      Color progressIndicatorBackgroundColor,
      Animation<Color> progressIndicatorValueColor,
      SnackPosition snackPosition = SnackPosition.BOTTOM,
      SnackStyle snackStyle = SnackStyle.FLOATING,
      Curve forwardAnimationCurve = Curves.easeOutCirc,
      Curve reverseAnimationCurve = Curves.easeOutCirc,
      Duration animationDuration = const Duration(seconds: 1),
      SnackStatusCallback onStatusChanged,
      double barBlur = 0.0,
      double overlayBlur = 0.0,
      Color overlayColor = Colors.transparent,
      Form userInputForm}) {
    GetBar getBar = GetBar(
        title: title,
        message: message,
        titleText: titleText,
        messageText: messageText,
        snackPosition: snackPosition,
        borderRadius: borderRadius,
        margin: margin,
        duration: duration,
        barBlur: barBlur,
        backgroundColor: backgroundColor,
        icon: icon,
        shouldIconPulse: shouldIconPulse,
        maxWidth: maxWidth,
        padding: padding,
        borderColor: borderColor,
        borderWidth: borderWidth,
        leftBarIndicatorColor: leftBarIndicatorColor,
        boxShadows: boxShadows,
        backgroundGradient: backgroundGradient,
        mainButton: mainButton,
        onTap: onTap,
        isDismissible: isDismissible,
        dismissDirection: dismissDirection,
        showProgressIndicator: showProgressIndicator ?? false,
        progressIndicatorController: progressIndicatorController,
        progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
        progressIndicatorValueColor: progressIndicatorValueColor,
        snackStyle: snackStyle,
        forwardAnimationCurve: forwardAnimationCurve,
        reverseAnimationCurve: reverseAnimationCurve,
        animationDuration: animationDuration,
        overlayBlur: overlayBlur,
        overlayColor: overlayColor,
        userInputForm: userInputForm);

    if (instantInit) {
      getBar.show();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBar.show();
      });
    }
  }

  void snackbar(title, message,
      {Color colorText,
      Duration duration,

      /// with instantInit = false you can put snackbar on initState
      bool instantInit = true,
      SnackPosition snackPosition,
      Widget titleText,
      Widget messageText,
      Widget icon,
      bool shouldIconPulse,
      double maxWidth,
      EdgeInsets margin,
      EdgeInsets padding,
      double borderRadius,
      Color borderColor,
      double borderWidth,
      Color backgroundColor,
      Color leftBarIndicatorColor,
      List<BoxShadow> boxShadows,
      Gradient backgroundGradient,
      FlatButton mainButton,
      OnTap onTap,
      bool isDismissible,
      bool showProgressIndicator,
      SnackDismissDirection dismissDirection,
      AnimationController progressIndicatorController,
      Color progressIndicatorBackgroundColor,
      Animation<Color> progressIndicatorValueColor,
      SnackStyle snackStyle,
      Curve forwardAnimationCurve,
      Curve reverseAnimationCurve,
      Duration animationDuration,
      double barBlur,
      double overlayBlur,
      Color overlayColor,
      Form userInputForm}) {
    GetBar getBar = GetBar(
        titleText: (title == null)
            ? null
            : titleText ??
                Text(
                  title,
                  style: TextStyle(
                      color: colorText ?? theme.iconTheme.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                ),
        messageText: messageText ??
            Text(
              message,
              style: TextStyle(
                  color: colorText ?? theme.iconTheme.color,
                  fontWeight: FontWeight.w300,
                  fontSize: 14),
            ),
        snackPosition: snackPosition ?? SnackPosition.TOP,
        borderRadius: borderRadius ?? 15,
        margin: margin ?? EdgeInsets.symmetric(horizontal: 10),
        duration: duration ?? Duration(seconds: 3),
        barBlur: barBlur ?? 7.0,
        backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.2),
        icon: icon,
        shouldIconPulse: shouldIconPulse ?? true,
        maxWidth: maxWidth,
        padding: padding ?? EdgeInsets.all(16),
        borderColor: borderColor,
        borderWidth: borderWidth,
        leftBarIndicatorColor: leftBarIndicatorColor,
        boxShadows: boxShadows,
        backgroundGradient: backgroundGradient,
        mainButton: mainButton,
        onTap: onTap,
        isDismissible: isDismissible ?? true,
        dismissDirection: dismissDirection ?? SnackDismissDirection.VERTICAL,
        showProgressIndicator: showProgressIndicator ?? false,
        progressIndicatorController: progressIndicatorController,
        progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
        progressIndicatorValueColor: progressIndicatorValueColor,
        snackStyle: snackStyle ?? SnackStyle.FLOATING,
        forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
        reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
        animationDuration: animationDuration ?? Duration(seconds: 1),
        overlayBlur: overlayBlur ?? 0.0,
        overlayColor: overlayColor ?? Colors.transparent,
        userInputForm: userInputForm);

    if (instantInit) {
      getBar.show();
    } else {
      _routing.isSnackbar = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBar.show();
      });
    }
  }

  /// change default config of Get
  config(
      {bool enableLog,
      bool defaultPopGesture,
      bool defaultOpaqueRoute,
      Duration defaultDurationTransition,
      bool defaultGlobalState,
      Transition defaultTransition}) {
    if (enableLog != null) {
      GetConfig.isLogEnable = enableLog;
    }
    if (defaultPopGesture != null) {
      this.defaultPopGesture = defaultPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      this.defaultOpaqueRoute = defaultOpaqueRoute;
    }
    if (defaultTransition != null) {
      this.defaultTransition = defaultTransition;
    }

    if (defaultDurationTransition != null) {
      this.defaultDurationTransition = defaultDurationTransition;
    }

    if (defaultGlobalState != null) {
      this.defaultGlobalState = defaultGlobalState;
    }
  }

  GetMaterialController getController = GetMaterialController();

  changeTheme(ThemeData theme) {
    getController.setTheme(theme);
  }

  changeThemeMode(ThemeMode themeMode) {
    getController.setThemeMode(themeMode);
  }

  GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey) {
    key = newKey;
    return key;
  }

  GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  Map<int, GlobalKey<NavigatorState>> _keys = {};

  GlobalKey<NavigatorState> nestedKey(int key) {
    _keys.putIfAbsent(key, () => GlobalKey<NavigatorState>());
    return _keys[key];
  }

  GlobalKey<NavigatorState> global(int k) {
    if (k == null) {
      return key;
    }
    if (!_keys.containsKey(k)) {
      throw 'route id not found';
    }
    return _keys[k];
  }

  /// give access to Routing API from GetObserver
  Routing get routing => _routing;

  RouteSettings get routeSettings => settings;

  Routing _routing = Routing();

  Map<String, String> parameters = {};

  setRouting(Routing rt) {
    _routing = rt;
  }

  setSettings(RouteSettings settings) {
    settings = settings;
  }

  /// give current arguments
  Object get arguments => _routing.args;

  /// give name from current route
  get currentRoute => _routing.current;

  /// give name from previous route
  get previousRoute => _routing.previous;

  /// check if snackbar is open
  bool get isSnackbarOpen => _routing.isSnackbar;

  /// check if dialog is open
  bool get isDialogOpen => _routing.isDialog;

  /// check if bottomsheet is open
  bool get isBottomSheetOpen => _routing.isBottomSheet;

  /// check a raw current route
  Route<dynamic> get rawRoute => _routing.route;

  /// check if popGesture is enable
  bool get isPopGestureEnable => defaultPopGesture;

  /// check if default opaque route is enable
  bool get isOpaqueRouteDefault => defaultOpaqueRoute;

  /// give access to currentContext
  BuildContext get context => key.currentContext;

  /// give access to current Overlay Context
  BuildContext get overlayContext => key.currentState.overlay.context;

  /// give access to Theme.of(context)
  ThemeData get theme => Theme.of(context);

  /// give access to TextTheme.of(context)
  TextTheme get textTheme => Theme.of(context).textTheme;

  /// give access to Mediaquery.of(context)
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  /// Check if dark mode theme is enable
  get isDarkMode => (theme.brightness == Brightness.dark);

  /// Check if dark mode theme is enable on platform on android Q+
  get isPlatformDarkMode => (mediaQuery.platformBrightness == Brightness.dark);

  /// give access to Theme.of(context).iconTheme.color
  Color get iconColor => Theme.of(context).iconTheme.color;

  /// give access to FocusScope.of(context)
  FocusNode get focusScope => FocusManager.instance.primaryFocus;

  /// give access to Immutable MediaQuery.of(context).size.height
  double get height => MediaQuery.of(context).size.height;

  /// give access to Immutable MediaQuery.of(context).size.width
  double get width => MediaQuery.of(context).size.width;
}

// ignore: non_constant_identifier_names
final Get = GetImpl();

/// It replaces the Flutter Navigator, but needs no context.
/// You can to use navigator.push(YourRoute()) rather Navigator.push(context, YourRoute());
NavigatorState get navigator => Get.key.currentState;

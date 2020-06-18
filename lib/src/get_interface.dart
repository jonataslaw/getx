import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'root/root_controller.dart';
import 'routes/bindings_interface.dart';
import 'routes/transitions_type.dart';
import 'snackbar/snack.dart';

///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
///To return to the previous screen, use Get.back().
///No need to pass any context to Get, just put the name of the route inside
///the parentheses and the magic will occur.
///

abstract class GetService {
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
      bool popGesture});

  /// It replaces Navigator.pushNamed, but needs no context, and it doesn't have the Navigator.pushNamed
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  Future<T> toNamed<T>(String page, {Object arguments, int id});

  /// It replaces Navigator.pushReplacementNamed, but needs no context.
  Future<T> offNamed<T>(String page, {Object arguments, int id});

  /// It replaces Navigator.popUntil, but needs no context.
  void until(RoutePredicate predicate, {int id});

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context.
  Future<T> offUntil<T>(Route<T> page, RoutePredicate predicate, {int id});

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  Future<T> offNamedUntil<T>(String page, RoutePredicate predicate,
      {int id, Object arguments});

  /// It replaces Navigator.popAndPushNamed, but needs no context.
  Future<T> offAndToNamed<T>(String page,
      {Object arguments, int id, dynamic result});

  /// It replaces Navigator.removeRoute, but needs no context.
  void removeRoute(Route<dynamic> route, {int id});

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  Future<T> offAllNamed<T>(String newRouteName,
      {RoutePredicate predicate, Object arguments, int id});

  bool get isOverlaysOpen;

  bool get isOverlaysClosed;

  /// It replaces Navigator.pop, but needs no context.
  void back({dynamic result, bool closeOverlays = false, int id});

  /// It will close as many screens as you define. Times must be> 0;
  void close(int times, [int id]);

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
      Duration duration});

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  Future<T> offAll<T>(Widget page,
      {RoutePredicate predicate,
      bool opaque = false,
      bool popGesture,
      int id,
      Object arguments,
      Bindings binding,
      bool fullscreenDialog = false,
      Transition transition});

  /// Show a dialog
  Future<T> dialog<T>(
    Widget child, {
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    //  RouteSettings routeSettings
  });

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
  });

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
  });

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
  });

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
      Form userInputForm});

  void snackbar(title, message,
      {Color colorText,
      Duration duration,

      /// with instantInit = false you can put Get.snackbar on initState
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
      Form userInputForm});

  /// INSTANCE MANAGER

  GetMaterialController getController;

  changeTheme(ThemeData theme);

  changeThemeMode(ThemeMode themeMode);

  GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey);

  GlobalKey<NavigatorState> key;

  GlobalKey<NavigatorState> nestedKey(int key);

  GlobalKey<NavigatorState> global(int k);
  //////////// INSTANCE MANAGER

  // setParameter(Map<String, String> param);

  /// give current arguments
  Object get arguments;

  /// give current arguments
  Map<String, String> get parameters;

  /// give name from current route
  String get currentRoute;

  /// give name from previous route
  String get previousRoute;

  /// check if snackbar is open
  bool get isSnackbarOpen;

  /// check if dialog is open
  bool get isDialogOpen;

  /// check if bottomsheet is open
  bool get isBottomSheetOpen;

  /// check a raw current route
  Route<dynamic> get rawRoute;

  /// give access to currentContext
  BuildContext get context;

  /// give access to current Overlay Context
  BuildContext get overlayContext;

  /// give access to Theme.of(context)
  ThemeData get theme;

  /// give access to TextTheme.of(context)
  TextTheme get textTheme;

  /// give access to Mediaquery.of(context)
  MediaQueryData get mediaQuery;

  /// Check if dark mode theme is enable
  bool get isDarkMode;

  /// Check if dark mode theme is enable on platform on android Q+
  bool get isPlatformDarkMode;

  /// give access to Theme.of(context).iconTheme.color
  Color get iconColor;

  /// give access to Focus.of(context).iconTheme.color
  FocusNode get focusScope;

  /// give access to MediaQuery.of(context).size.height
  double get height;

  /// give access to MediaQuery.of(context).size.width
  double get width;
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/src/dialog/dialog.dart';
import 'package:get/get.dart';
import '../get.dart';
import 'platform/platform.dart';
import 'routes/blur/backdrop_blur.dart';
import 'routes/blur/transparent_route.dart';
import 'routes/default_route.dart';

class Get {
  static Get _get;
  static GlobalKey<NavigatorState> _key;

  static GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey) {
    _key = newKey;
    return _key;
  }

  static GlobalKey<NavigatorState> get key {
    if (_key == null) {
      _key = GlobalKey<NavigatorState>();
    }
    return _key;
  }

  ///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
  ///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
  ///To return to the previous screen, use Get.back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.
  factory Get() {
    if (_get == null) _get = Get._();
    return _get;
  }

  ///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
  ///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
  ///To return to the previous screen, use Get.back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.
  Get._();

  static bool _enableLog = true;
  static bool _defaultPopGesture = GetPlatform.isIOS;
  static bool _defaultOpaqueRoute = true;
  static Transition _defaultTransition =
      (GetPlatform.isIOS ? Transition.cupertino : Transition.fade);

  /// It replaces Navigator.push, but needs no context, and it doesn't have the Navigator.push
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  static Future<T> to<T>(Widget page,
      {bool opaque,
      Transition transition,
      Duration duration,
      bool popGesture}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.push(GetRoute(
        opaque: opaque ?? true,
        page: page,
        popGesture: popGesture ?? _defaultPopGesture,
        transition: transition ?? _defaultTransition,
        transitionDuration: duration ?? const Duration(milliseconds: 400)));
  }

  /// It replaces Navigator.pushNamed, but needs no context, and it doesn't have the Navigator.pushNamed
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  static Future<T> toNamed<T>(String page, {arguments}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.pushNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.pushReplacementNamed, but needs no context.
  static Future<T> offNamed<T>(String page, {arguments}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.pushReplacementNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.popUntil, but needs no context.
  static void until(String page, predicate) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.popUntil(predicate);
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context.
  static Future<T> offUntil<T>(page, predicate) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.pushAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static Future<T> offNamedUntil<T>(page, predicate) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return key.currentState.pushNamedAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.removeRoute, but needs no context.
  static void removeRoute(route) {
    return key.currentState.removeRoute(route);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static Future<T> offAllNamed<T>(
    String newRouteName, {
    RoutePredicate predicate,
    arguments,
  }) {
    var route = (Route<dynamic> rota) => false;
    return key.currentState.pushNamedAndRemoveUntil(
        newRouteName, predicate ?? route,
        arguments: arguments);
  }

  /// It replaces Navigator.pop, but needs no context.
  static back({dynamic result}) {
    return key.currentState.pop(result);
  }

  /// It will close as many screens as you define. Times must be> 0;
  static void close(int times) {
    if ((times == null) || (times < 1)) {
      times = 1;
    }
    int count = 0;
    void back = key.currentState.popUntil((route) {
      return count++ == times;
    });
    return back;
  }

  /// It replaces Navigator.pushReplacement, but needs no context, and it doesn't have the Navigator.pushReplacement
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  static Future<T> off<T>(Widget page,
      {bool opaque = false,
      Transition transition,
      bool popGesture,
      Duration duration = const Duration(milliseconds: 400)}) {
    return key.currentState.pushReplacement(GetRoute(
        opaque: opaque ?? true,
        page: page,
        popGesture: popGesture ?? _defaultPopGesture,
        transition: transition ?? _defaultTransition,
        transitionDuration: duration));
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  static Future<T> offAll<T>(Widget page,
      {RoutePredicate predicate,
      bool opaque = false,
      bool popGesture,
      Transition transition}) {
    var route = (Route<dynamic> rota) => false;
    return key.currentState.pushAndRemoveUntil(
        GetRoute(
          opaque: opaque ?? true,
          popGesture: popGesture ?? _defaultPopGesture,
          page: page,
          transition: transition ?? _defaultTransition,
        ),
        predicate ?? route);
  }

  /// Show a dialog. You can choose color and opacity of background
  static Future<T> dialog<T>(
    Widget child, {
    bool barrierDismissible = true,
    //  WidgetBuilder builder,
    bool useRootNavigator = true,
  }) {
    assert(child != null);
    assert(useRootNavigator != null);
    final ThemeData theme =
        Theme.of(Get.key.currentContext, shadowThemeOnly: true);

    return getShowGeneralDialog(
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = child; // ?? Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(Get.key.currentContext)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      // transitionBuilder: _buildMaterialDialogTransitions,
      useRootNavigator: useRootNavigator,
    );
  }

  static defaultDialog(
      {Color color,
      double opacity = 0.2,
      String title = "Alert dialog",
      Widget content,
      Widget cancel,
      Widget confirm}) {
    final child = DefaultDialogGet(
      color: color,
      opacity: opacity,
      title: title,
      content: content,
      cancel: cancel,
      confirm: confirm,
    );

    dialog(child);
  }

  static Future<T> bottomSheet<T>({
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    assert(builder != null);
    assert(isScrollControlled != null);
    assert(useRootNavigator != null);
    assert(isDismissible != null);
    assert(enableDrag != null);

    return Get.key.currentState.push<T>(GetModalBottomSheetRoute<T>(
      builder: builder,
      theme: Theme.of(Get.key.currentContext, shadowThemeOnly: true),
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(Get.key.currentContext)
          .modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      settings: RouteSettings(name: "bottomsheet"),
      enableDrag: enableDrag,
    ));
  }

  /// get arguments from current screen. You need of context
  static args(context) {
    return ModalRoute.of(context).settings.arguments;
  }

  static Future backdrop(Widget child,
      {double radius = 20.0,
      double blurRadius: 20.0,
      int duration = 300,
      Transition transition = Transition.fade,
      Widget bottomButton = const Icon(Icons.visibility),
      double bottomHeight = 60.0,
      bool bottomButtonRotate = false}) {
    final page = RippleBackdropAnimatePage(
      child: child,
      childFade: true,
      duration: duration,
      blurRadius: blurRadius,
      bottomButton: bottomButton,
      bottomHeight: bottomHeight,
      bottomButtonRotate: bottomButtonRotate,
    );

    return key.currentState
        .push(TransparentRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  static void snackbar(title, message,
      {Color colorText,
      Duration duration,
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final Color defaultColor = IconTheme.of(Get.key.currentContext).color;
      return GetBar(
          titleText: titleText ??
              Text(
                title,
                style: TextStyle(
                    color: colorText ?? defaultColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
          messageText: messageText ??
              Text(
                message,
                style: TextStyle(
                    color: colorText ?? defaultColor,
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
          userInputForm: userInputForm)
        ..show();
    });
  }

  /// change default config of Get
  static void config(
      {bool enableLog,
      bool defaultPopGesture,
      bool defaultOpaqueRoute,
      Transition defaultTransition}) {
    if (enableLog != null) {
      _enableLog = enableLog;
    }
    if (defaultPopGesture != null) {
      _defaultPopGesture = defaultPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      _defaultOpaqueRoute = defaultOpaqueRoute;
    }
    if (defaultTransition != null) {
      _defaultTransition = defaultTransition;
    }
  }

  static bool get isLogEnable => _enableLog;
  static bool get isPopGestureEnable => _defaultPopGesture;
  static bool get isOpaqueRouteDefault => _defaultOpaqueRoute;

  /// give access to currentContext
  static BuildContext get context => key.currentContext;

  static BuildContext get overlayContext => key.currentState.overlay.context;

  /// give access to Theme.of(context)
  static ThemeData get theme => Theme.of(context);

  /// give access to Theme.of(context).iconTheme.color
  static Color get iconColor => Theme.of(context).iconTheme.color;

  /// give access to MediaQuery.of(context).size.height
  static double get height => MediaQuery.of(context).size.height;

  /// give access to MediaQuery.of(context).size.width
  static double get width => MediaQuery.of(context).size.width;
}

/// It replaces the Flutter Navigator, but needs no context.
/// You can to use navigator.push(YourRoute()) rather Navigator.push(context, YourRoute());
NavigatorState get navigator => Get.key.currentState;

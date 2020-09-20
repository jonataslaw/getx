import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_core/get_core.dart';
import 'package:get_state_manager/get_state_manager.dart';
import 'package:get_utils/get_utils.dart';
import '../get_navigation.dart';
import 'dialog/dialog_route.dart';
import 'root/parse_route.dart';
import 'root/root_controller.dart';
import 'routes/transitions_type.dart';

//TODO: Split this class on "Snackbar" "Dialog" "bottomSheet"
//and "navigation" extensions
extension GetNavigation on GetInterface {
  /// **Navigation.push()** shortcut.<br><br>
  ///
  /// Pushes a new [page] to the stack
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [Bindings] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T> to<T>(
    Widget page, {
    bool opaque,
    Transition transition,
    Curve curve,
    Duration duration,
    int id,
    bool fullscreenDialog = false,
    dynamic arguments,
    Bindings binding,
    bool preventDuplicates = true,
    bool popGesture,
  }) {
    var routeName = "/${page.runtimeType.toString()}";
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return global(id).currentState.push(
          GetPageRoute(
            opaque: opaque ?? true,
            page: () => page,
            routeName: routeName,
            settings: RouteSettings(
              //  name: forceRouteName ? '${a.runtimeType}' : '',
              arguments: arguments,
            ),
            popGesture: popGesture ?? defaultPopGesture,
            transition: transition ?? defaultTransition,
            curve: curve ?? defaultTransitionCurve,
            fullscreenDialog: fullscreenDialog,
            binding: binding,
            transitionDuration: duration ?? defaultTransitionDuration,
          ),
        );
  }

  /// **Navigation.pushNamed()** shortcut.<br><br>
  ///
  /// Pushes a new named [page] to the stack.
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  Future<T> toNamed<T>(
    String page, {
    dynamic arguments,
    int id,
    bool preventDuplicates = true,
  }) {
    if (preventDuplicates && page == currentRoute) {
      return null;
    }
    return global(id).currentState.pushNamed(page, arguments: arguments);
  }

  /// **Navigation.pushReplacementNamed()** shortcut.<br><br>
  ///
  /// Pop the current named [page] in the stack and push a new one in its place
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  Future<T> offNamed<T>(
    String page, {
    dynamic arguments,
    int id,
    bool preventDuplicates = true,
  }) {
    if (preventDuplicates && page == currentRoute) {
      return null;
    }
    return global(id)
        .currentState
        .pushReplacementNamed(page, arguments: arguments);
  }

  /// **Navigation.popUntil()** shortcut.<br><br>
  ///
  /// Calls pop several times in the stack until [predicate] returns true
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  ///
  /// or also like this:
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the
  /// dialog is closed
  void until(RoutePredicate predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState.popUntil(predicate);
  }

  /// **Navigation.pushAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push the given [page], and then pop several pages in the stack until
  /// [predicate] returns true
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// Obs: unlike other get methods, this one you need to send a function
  /// that returns the widget to the page argument, like this:
  /// Get.offUntil( () => HomePage() )
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  ///
  /// or also like this:
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  Future<T> offUntil<T>(Route<T> page, RoutePredicate predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState.pushAndRemoveUntil(page, predicate);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push the given named [page], and then pop several pages in the stack
  /// until [predicate] returns true
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unnexpected errors
  Future<T> offNamedUntil<T>(
    String page,
    RoutePredicate predicate, {
    int id,
    dynamic arguments,
  }) {
    return global(id)
        .currentState
        .pushNamedAndRemoveUntil(page, predicate, arguments: arguments);
  }

  /// **Navigation.popAndPushNamed()** shortcut.<br><br>
  ///
  /// Pop the current named page and pushes a new [page] to the stack
  /// in its place
  ///
  /// You can send any type of value to the other route in the [arguments].
  /// It is very similar to `offNamed()` but use a different approach
  ///
  /// The `offNamed()` pop a page, and goes to the next. The
  /// `offAndToNamed()` goes to the next page, and removes the previous one.
  /// The route transition animation is different.
  Future<T> offAndToNamed<T>(
    String page, {
    dynamic arguments,
    int id,
    dynamic result,
  }) {
    return global(id)
        .currentState
        .popAndPushNamed(page, arguments: arguments, result: result);
  }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  ///
  /// Remove a specific [route] from the stack
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void removeRoute(Route<dynamic> route, {int id}) {
    return global(id).currentState.removeRoute(route);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push a named [page] and pop several pages in the stack
  /// until [predicate] returns true. [predicate] is optional
  ///
  /// It has the advantage of not needing context, so you can
  /// call from your business logic.
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// Note: Always put a slash on the route ('/page1'), to avoid unexpected errors
  Future<T> offAllNamed<T>(
    String newRouteName, {
    RoutePredicate predicate,
    dynamic arguments,
    int id,
  }) {
    return global(id).currentState.pushNamedAndRemoveUntil(
          newRouteName,
          predicate ?? (_) => false,
          arguments: arguments,
        );
  }

  /// Returns true if a Snackbar, Dialog or BottomSheet is currently OPEN
  bool get isOverlaysOpen =>
      (isSnackbarOpen || isDialogOpen || isBottomSheetOpen);

  /// Returns true if there is no Snackbar, Dialog or BottomSheet open
  bool get isOverlaysClosed =>
      (!isSnackbarOpen && !isDialogOpen && !isBottomSheetOpen);

  /// **Navigation.popUntil()** shortcut.<br><br>
  ///
  /// Pop the current page, snackbar, dialog or bottomsheet in the stack
  ///
  /// if your set [closeOverlays] to true, Get.back() will close the
  /// currently open snackbar/dialog/bottomsheet AND the current page
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// It has the advantage of not needing context, so you can call
  /// from your business logic.
  void back({
    dynamic result,
    bool closeOverlays = false,
    bool canPop = true,
    int id,
  }) {
    if (closeOverlays && isOverlaysOpen) {
      navigator.popUntil((route) {
        return (isOverlaysClosed);
      });
    }
    if (canPop) {
      if (global(id).currentState.canPop()) {
        global(id).currentState.pop(result);
      }
    } else {
      global(id).currentState.pop(result);
    }
  }

  /// **Navigation.popUntil()** (with predicate) shortcut .<br><br>
  ///
  /// Close as many routes as defined by [times]
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void close(int times, [int id]) {
    if ((times == null) || (times < 1)) {
      times = 1;
    }
    var count = 0;
    var back = global(id).currentState.popUntil((route) => count++ == times);

    return back;
  }

  /// **Navigation.pushReplacement()** shortcut .<br><br>
  ///
  /// Pop the current page and pushes a new [page] to the stack
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], define a Tween [curve],
  /// and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [Bindings] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T> off<T>(
    Widget page, {
    bool opaque = false,
    Transition transition,
    Curve curve,
    bool popGesture,
    int id,
    dynamic arguments,
    Bindings binding,
    bool fullscreenDialog = false,
    bool preventDuplicates = true,
    Duration duration,
  }) {
    var routeName = "/${page.runtimeType.toString()}";
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return global(id).currentState.pushReplacement(GetPageRoute(
        opaque: opaque ?? true,
        page: () => page,
        binding: binding,
        settings: RouteSettings(arguments: arguments),
        routeName: routeName,
        fullscreenDialog: fullscreenDialog,
        popGesture: popGesture ?? defaultPopGesture,
        transition: transition ?? defaultTransition,
        curve: curve ?? defaultTransitionCurve,
        transitionDuration: duration ?? defaultTransitionDuration));
  }

  /// **Navigation.pushAndRemoveUntil()** shortcut .<br><br>
  ///
  /// Push a [page] and pop several pages in the stack
  /// until [predicate] returns true. [predicate] is optional
  ///
  /// It has the advantage of not needing context,
  /// so you can call from your business logic
  ///
  /// You can set a custom [transition], a [curve] and a transition [duration].
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// Just like native routing in Flutter, you can push a route
  /// as a [fullscreenDialog],
  ///
  /// [predicate] can be used like this:
  /// `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like
  /// `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog
  /// is closed
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// If you want the same behavior of ios that pops a route when the user drag,
  /// you can set [popGesture] to true
  ///
  /// If you're using the [Bindings] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T> offAll<T>(
    Widget page, {
    RoutePredicate predicate,
    bool opaque = false,
    bool popGesture,
    int id,
    dynamic arguments,
    Bindings binding,
    bool fullscreenDialog = false,
    Transition transition,
    Curve curve,
    Duration duration,
  }) {
    var routeName = "/${page.runtimeType.toString()}";

    return global(id).currentState.pushAndRemoveUntil(
        GetPageRoute(
          opaque: opaque ?? true,
          popGesture: popGesture ?? defaultPopGesture,
          page: () => page,
          binding: binding,
          settings: RouteSettings(arguments: arguments),
          fullscreenDialog: fullscreenDialog,
          routeName: routeName,
          transition: transition ?? defaultTransition,
          curve: curve ?? defaultTransitionCurve,
          transitionDuration: duration ?? defaultTransitionDuration,
        ),
        predicate ?? (route) => false);
  }

  /// Show a dialog.
  /// You can pass a [transitionDuration] and/or [transitionCurve],
  /// overriding the defaults when the dialog shows up and closes.
  /// When the dialog closes, uses those animations in reverse.
  Future<T> dialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
    Color barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
    Duration transitionDuration,
    Curve transitionCurve,
  }) {
    assert(widget != null);
    assert(barrierDismissible != null);
    assert(useSafeArea != null);
    assert(useRootNavigator != null);
    assert(debugCheckHasMaterialLocalizations(context));

    final theme = Theme.of(context, shadowThemeOnly: true);
    return generalDialog(
      pageBuilder: (buildContext, animation, secondaryAnimation) {
        final pageChild = widget;
        Widget dialog = Builder(builder: (context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        });
        if (useSafeArea) {
          dialog = SafeArea(child: dialog);
        }
        return dialog;
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: transitionDuration ?? defaultDialogTransitionDuration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: transitionCurve ?? defaultDialogTransitionCurve,
          ),
          child: child,
        );
      },
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Api from showGeneralDialog with no context
  Future<T> generalDialog<T>({
    @required RoutePageBuilder pageBuilder,
    bool barrierDismissible = false,
    String barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
  }) {
    assert(pageBuilder != null);
    assert(useRootNavigator != null);
    assert(!barrierDismissible || barrierLabel != null);
    return Navigator.of(overlayContext, rootNavigator: useRootNavigator)
        .push<T>(GetDialogRoute<T>(
      pageBuilder: pageBuilder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      settings: routeSettings,
    ));
  }

  /// Custom UI Dialog.
  Future<T> defaultDialog<T>({
    String title = "Alert",
    TextStyle titleStyle,
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
    bool barrierDismissible = true,
    Color buttonColor,
    String middleText = "Dialog made in 3 lines of code",
    TextStyle middleTextStyle,
    double radius = 20.0,
    //   ThemeData themeData,
    List<Widget> actions,
  }) {
    var leanCancel = onCancel != null || textCancel != null;
    var leanConfirm = onConfirm != null || textConfirm != null;
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

    return dialog(
      AlertDialog(
        titlePadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.all(8),
        backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        title: Text(title, textAlign: TextAlign.center, style: titleStyle),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            content ??
                Text(middleText ?? "",
                    textAlign: TextAlign.center, style: middleTextStyle),
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
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  Future<T> bottomSheet<T>(
    Widget bottomsheet, {
    Color backgroundColor,
    double elevation,
    bool persistent = true,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool ignoreSafeArea,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings settings,
    Duration enterBottomSheetDuration,
    Duration exitBottomSheetDuration,
  }) {
    assert(bottomsheet != null);
    assert(persistent != null);
    assert(isScrollControlled != null);
    assert(useRootNavigator != null);
    assert(isDismissible != null);
    assert(enableDrag != null);

    return Navigator.of(overlayContext, rootNavigator: useRootNavigator)
        .push(GetModalBottomSheetRoute<T>(
      builder: (_) => bottomsheet,
      isPersistent: persistent,
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
      settings: settings,
      enableDrag: enableDrag,
    ));
  }

  void rawSnackbar({
    String title,
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
    SnackbarStatusCallback snackbarStatus,
    double barBlur = 0.0,
    double overlayBlur = 0.0,
    Color overlayColor,
    Form userInputForm,
  }) async {
    final getBar = GetBar(
      snackbarStatus: snackbarStatus,
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
      userInputForm: userInputForm,
    );

    if (instantInit) {
      getBar.show();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBar.show();
      });
    }
  }

  void snackbar(
    String title,
    String message, {
    Color colorText,
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
    SnackbarStatusCallback snackbarStatus,
    Color overlayColor,
    Form userInputForm,
  }) async {
    final getBar = GetBar(
        snackbarStatus: snackbarStatus,
        titleText: (title == null)
            ? null
            : titleText ??
                Text(
                  title,
                  style: TextStyle(
                    color: colorText ?? Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
        messageText: messageText ??
            Text(
              message,
              style: TextStyle(
                color: colorText ?? Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
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
      routing.isSnackbar = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBar.show();
      });
    }
  }

  void addPages(List<GetPage> getPages) {
    if (getPages != null) {
      if (routeTree == null) {
        routeTree = ParseRouteTree();
      }

      for (final element in getPages) {
        routeTree.addRoute(element);
      }
    }
  }

  void addPage(GetPage getPage) {
    if (getPage != null) {
      if (routeTree == null) routeTree = ParseRouteTree();
      routeTree.addRoute(getPage);
    }
  }

  /// change default config of Get
  void config(
      {bool enableLog,
      LogWriterCallback logWriterCallback,
      bool defaultPopGesture,
      bool defaultOpaqueRoute,
      Duration defaultDurationTransition,
      bool defaultGlobalState,
      Transition defaultTransition}) {
    if (enableLog != null) {
      Get.isLogEnable = enableLog;
    }
    if (logWriterCallback != null) {
      Get.log = logWriterCallback;
    }
    if (defaultPopGesture != null) {
      getxController.defaultPopGesture = defaultPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      getxController.defaultOpaqueRoute = defaultOpaqueRoute;
    }
    if (defaultTransition != null) {
      getxController.defaultTransition = defaultTransition;
    }

    if (defaultDurationTransition != null) {
      getxController.defaultTransitionDuration = defaultDurationTransition;
    }
  }

  void updateLocale(Locale l) {
    Get.locale = l;
    forceAppUpdate();
  }

  void forceAppUpdate() {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  void changeTheme(ThemeData theme) {
    getxController.setTheme(theme);
  }

  void changeThemeMode(ThemeMode themeMode) {
    getxController.setThemeMode(themeMode);
  }

  GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey) {
    getxController.key = newKey;
    return key;
  }

  GlobalKey<NavigatorState> nestedKey(int key) {
    keys.putIfAbsent(key, () => GlobalKey<NavigatorState>());
    return keys[key];
  }

  GlobalKey<NavigatorState> global(int k) {
    if (k == null) {
      return key;
    }
    if (!keys.containsKey(k)) {
      throw 'Route id ($k) not found';
    }
    return keys[k];
  }

  @Deprecated('''
Since version 2.8 it is possible to access the properties 
[Get.arguments] and [Get.currentRoute] directly. 
[routeSettings] is useless and should not be used.''')
  RouteSettings get routeSettings => null;

  /// give current arguments
  dynamic get arguments => routing.args;

  /// give name from current route
  String get currentRoute => routing.current;

  /// give name from previous route
  String get previousRoute => routing.previous;

  /// check if snackbar is open
  bool get isSnackbarOpen => routing.isSnackbar;

  /// check if dialog is open
  bool get isDialogOpen => routing.isDialog;

  /// check if bottomsheet is open
  bool get isBottomSheetOpen => routing.isBottomSheet;

  /// check a raw current route
  Route<dynamic> get rawRoute => routing.route;

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
  bool get isDarkMode => (theme.brightness == Brightness.dark);

  /// Check if dark mode theme is enable on platform on android Q+
  bool get isPlatformDarkMode =>
      (mediaQuery.platformBrightness == Brightness.dark);

  /// give access to Theme.of(context).iconTheme.color
  Color get iconColor => Theme.of(context).iconTheme.color;

  /// give access to FocusScope.of(context)
  FocusNode get focusScope => FocusManager.instance.primaryFocus;

  /// give access to Immutable MediaQuery.of(context).size.height
  double get height => MediaQuery.of(context).size.height;

  /// give access to Immutable MediaQuery.of(context).size.width
  double get width => MediaQuery.of(context).size.width;

  GlobalKey<NavigatorState> get key => getxController.key;

  Map<int, GlobalKey<NavigatorState>> get keys => getxController.keys;

  GetMaterialController get rootController => getxController;

  bool get defaultPopGesture => getxController.defaultPopGesture;
  bool get defaultOpaqueRoute => getxController.defaultOpaqueRoute;

  Transition get defaultTransition => getxController.defaultTransition;
  Duration get defaultTransitionDuration {
    return getxController.defaultDialogTransitionDuration;
  }

  Curve get defaultTransitionCurve => getxController.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve {
    return getxController.defaultDialogTransitionCurve;
  }

  Duration get defaultDialogTransitionDuration {
    return getxController.defaultDialogTransitionDuration;
  }

  Routing get routing => getxController.routing;

  Map<String, String> get parameters => getxController.parameters;
  set parameters(Map<String, String> newParameters) =>
      getxController.parameters = newParameters;

  ParseRouteTree get routeTree => getxController.routeTree;
  set routeTree(ParseRouteTree tree) => getxController.routeTree = tree;

  CustomTransition get customTransition => getxController.customTransition;
  set customTransition(CustomTransition newTransition) =>
      getxController.customTransition = newTransition;

  static GetMaterialController getxController = GetMaterialController();
}

/// It replaces the Flutter Navigator, but needs no context.
/// You can to use navigator.push(YourRoute()) rather
/// Navigator.push(context, YourRoute());
NavigatorState get navigator => GetNavigation(Get).key.currentState;

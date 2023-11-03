import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../get.dart';
import 'dialog/dialog_route.dart';
import 'root/get_root.dart';

/// It replaces the Flutter Navigator, but needs no context.
/// You can to use navigator.push(YourRoute()) rather
/// Navigator.push(context, YourRoute());
NavigatorState? get navigator => GetNavigationExt(Get).key.currentState;

extension ExtensionBottomSheet on GetInterface {
  Future<T?> bottomSheet<T>(
    final Widget bottomsheet, {
    final Color? backgroundColor,
    final double? elevation,
    final bool persistent = true,
    final ShapeBorder? shape,
    final Clip? clipBehavior,
    final Color? barrierColor,
    final bool? ignoreSafeArea,
    final bool isScrollControlled = false,
    final bool useRootNavigator = false,
    final bool isDismissible = true,
    final bool enableDrag = true,
    final RouteSettings? settings,
    final Duration? enterBottomSheetDuration,
    final Duration? exitBottomSheetDuration,
    final Curve? curve,
  }) {
    return Navigator.of(overlayContext!, rootNavigator: useRootNavigator)
        .push(GetModalBottomSheetRoute<T>(
      builder: (final _) => bottomsheet,
      isPersistent: persistent,
      // theme: Theme.of(key.currentContext, shadowThemeOnly: true),
      theme: Theme.of(key.currentContext!),
      isScrollControlled: isScrollControlled,

      barrierLabel: MaterialLocalizations.of(key.currentContext!)
          .modalBarrierDismissLabel,

      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      shape: shape,
      removeTop: ignoreSafeArea ?? true,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      settings: settings,
      enableDrag: enableDrag,
      enterBottomSheetDuration:
          enterBottomSheetDuration ?? const Duration(milliseconds: 250),
      exitBottomSheetDuration:
          exitBottomSheetDuration ?? const Duration(milliseconds: 200),
      curve: curve,
    ));
  }
}

extension ExtensionDialog on GetInterface {
  /// Show a dialog.
  /// You can pass a [transitionDuration] and/or [transitionCurve],
  /// overriding the defaults when the dialog shows up and closes.
  /// When the dialog closes, uses those animations in reverse.
  Future<T?> dialog<T>(
    final Widget widget, {
    final bool barrierDismissible = true,
    final Color? barrierColor,
    final bool useSafeArea = true,
    final GlobalKey<NavigatorState>? navigatorKey,
    final Object? arguments,
    final Duration? transitionDuration,
    final Curve? transitionCurve,
    final String? name,
    final RouteSettings? routeSettings,
    final String? id,
  }) {
    assert(debugCheckHasMaterialLocalizations(context!));

    //  final theme = Theme.of(context, shadowThemeOnly: true);
    final ThemeData theme = Theme.of(context!);
    return generalDialog<T>(
      pageBuilder: (
        final BuildContext buildContext,
        final Animation<double> animation,
        final Animation<double> secondaryAnimation,
      ) {
        final Widget pageChild = widget;
        Widget dialog = Builder(builder: (final BuildContext context) {
          return Theme(data: theme, child: pageChild);
        });
        if (useSafeArea) {
          dialog = SafeArea(child: dialog);
        }
        return dialog;
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context!).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: transitionDuration ?? defaultDialogTransitionDuration,
      transitionBuilder: (
        final BuildContext context,
        final Animation<double> animation,
        final Animation<double> secondaryAnimation,
        final Widget child,
      ) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: transitionCurve ?? defaultDialogTransitionCurve,
          ),
          child: child,
        );
      },
      navigatorKey: navigatorKey,
      routeSettings:
          routeSettings ?? RouteSettings(arguments: arguments, name: name),
      id: id,
    );
  }

  /// Api from showGeneralDialog with no context
  Future<T?> generalDialog<T>(
      {required final RoutePageBuilder pageBuilder,
      final bool barrierDismissible = false,
      final String? barrierLabel,
      final Color barrierColor = const Color(0x80000000),
      final Duration transitionDuration = const Duration(milliseconds: 200),
      final RouteTransitionsBuilder? transitionBuilder,
      final GlobalKey<NavigatorState>? navigatorKey,
      final RouteSettings? routeSettings,
      final String? id}) {
    assert(!barrierDismissible || barrierLabel != null);
    final GlobalKey<NavigatorState>? key =
        navigatorKey ?? Get.nestedKey(id)?.navigatorKey;
    final NavigatorState nav = key?.currentState ??
        Navigator.of(overlayContext!,
            rootNavigator:
                true); //overlay context will always return the root navigator
    return nav.push<T>(
      GetDialogRoute<T>(
        pageBuilder: pageBuilder,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        barrierColor: barrierColor,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        settings: routeSettings,
      ),
    );
  }

  /// Custom UI Dialog.
  Future<T?> defaultDialog<T>({
    final String title = 'Alert',
    final EdgeInsetsGeometry? titlePadding,
    final TextStyle? titleStyle,
    final Widget? content,
    final String? id,
    final EdgeInsetsGeometry? contentPadding,
    final VoidCallback? onConfirm,
    final VoidCallback? onCancel,
    final VoidCallback? onCustom,
    final Color? cancelTextColor,
    final Color? confirmTextColor,
    final String? textConfirm,
    final String? textCancel,
    final String? textCustom,
    final Widget? confirm,
    final Widget? cancel,
    final Widget? custom,
    final Color? backgroundColor,
    final bool barrierDismissible = true,
    final Color? buttonColor,
    final String middleText = '\n',
    final TextStyle? middleTextStyle,
    final double radius = 20.0,
    //   ThemeData themeData,
    List<Widget>? actions,

    // onWillPop Scope
    final WillPopCallback? onWillPop,

    // the navigator used to push the dialog
    final GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final bool leanCancel = onCancel != null || textCancel != null;
    final bool leanConfirm = onConfirm != null || textConfirm != null;
    actions ??= <Widget>[];

    if (cancel != null) {
      actions.add(cancel);
    } else {
      if (leanCancel) {
        actions.add(TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: buttonColor ?? theme.colorScheme.secondary,
                    width: 2),
                borderRadius: BorderRadius.circular(radius)),
          ),
          onPressed: () {
            onCancel?.call();
            back();
          },
          child: Text(
            textCancel ?? 'Cancel',
            style: TextStyle(
                color: cancelTextColor ?? theme.colorScheme.secondary),
          ),
        ));
      }
    }
    if (confirm != null) {
      actions.add(confirm);
    } else {
      if (leanConfirm) {
        actions.add(TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: buttonColor ?? theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
            child: Text(
              textConfirm ?? 'Ok',
              style: TextStyle(
                  color: confirmTextColor ?? theme.colorScheme.background),
            ),
            onPressed: () {
              onConfirm?.call();
            }));
      }
    }

    final Widget baseAlertDialog = AlertDialog(
      titlePadding: titlePadding ?? const EdgeInsets.all(8),
      contentPadding: contentPadding ?? const EdgeInsets.all(8),

      backgroundColor: backgroundColor ?? theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      title: Text(title, textAlign: TextAlign.center, style: titleStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          content ??
              Text(middleText,
                  textAlign: TextAlign.center, style: middleTextStyle),
          const SizedBox(height: 16),
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
    );

    return dialog<T>(
      onWillPop != null
          ? WillPopScope(
              onWillPop: onWillPop,
              child: baseAlertDialog,
            )
          : baseAlertDialog,
      barrierDismissible: barrierDismissible,
      navigatorKey: navigatorKey,
      id: id,
    );
  }
}

extension ExtensionSnackbar on GetInterface {
  SnackbarController rawSnackbar({
    final String? title,
    final String? message,
    final Widget? titleText,
    final Widget? messageText,
    final Widget? icon,
    final bool instantInit = true,
    final bool shouldIconPulse = true,
    final double? maxWidth,
    final EdgeInsets margin = const EdgeInsets.all(0.0),
    final EdgeInsets padding = const EdgeInsets.all(16),
    final double borderRadius = 0.0,
    final Color? borderColor,
    final double borderWidth = 1.0,
    final Color backgroundColor = const Color(0xFF303030),
    final Color? leftBarIndicatorColor,
    final List<BoxShadow>? boxShadows,
    final Gradient? backgroundGradient,
    final Widget? mainButton,
    final OnTap? onTap,
    final Duration? duration = const Duration(seconds: 3),
    final bool isDismissible = true,
    final DismissDirection? dismissDirection,
    final bool showProgressIndicator = false,
    final AnimationController? progressIndicatorController,
    final Color? progressIndicatorBackgroundColor,
    final Animation<Color>? progressIndicatorValueColor,
    final SnackPosition snackPosition = SnackPosition.bottom,
    final SnackStyle snackStyle = SnackStyle.floating,
    final Curve forwardAnimationCurve = Curves.easeOutCirc,
    final Curve reverseAnimationCurve = Curves.easeOutCirc,
    final Duration animationDuration = const Duration(seconds: 1),
    final SnackbarStatusCallback? snackbarStatus,
    final double barBlur = 0.0,
    final double overlayBlur = 0.0,
    final Color? overlayColor,
    final Form? userInputForm,
  }) {
    final GetSnackBar getSnackBar = GetSnackBar(
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
      showProgressIndicator: showProgressIndicator,
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

    final SnackbarController controller = SnackbarController(getSnackBar);

    if (instantInit) {
      controller.show();
    } else {
      ambiguate(Engine.instance)!.addPostFrameCallback((final _) {
        controller.show();
      });
    }
    return controller;
  }

  SnackbarController showSnackbar(final GetSnackBar snackbar) {
    final SnackbarController controller = SnackbarController(snackbar);
    controller.show();
    return controller;
  }

  SnackbarController snackbar(
    final String title,
    final String message, {
    final Color? colorText,
    final Duration? duration = const Duration(seconds: 3),

    /// with instantInit = false you can put snackbar on initState
    final bool instantInit = true,
    final SnackPosition? snackPosition,
    final Widget? titleText,
    final Widget? messageText,
    final Widget? icon,
    final bool? shouldIconPulse,
    final double? maxWidth,
    final EdgeInsets? margin,
    final EdgeInsets? padding,
    final double? borderRadius,
    final Color? borderColor,
    final double? borderWidth,
    final Color? backgroundColor,
    final Color? leftBarIndicatorColor,
    final List<BoxShadow>? boxShadows,
    final Gradient? backgroundGradient,
    final TextButton? mainButton,
    final OnTap? onTap,
    final OnHover? onHover,
    final bool? isDismissible,
    final bool? showProgressIndicator,
    final DismissDirection? dismissDirection,
    final AnimationController? progressIndicatorController,
    final Color? progressIndicatorBackgroundColor,
    final Animation<Color>? progressIndicatorValueColor,
    final SnackStyle? snackStyle,
    final Curve? forwardAnimationCurve,
    final Curve? reverseAnimationCurve,
    final Duration? animationDuration,
    final double? barBlur,
    final double? overlayBlur,
    final SnackbarStatusCallback? snackbarStatus,
    final Color? overlayColor,
    final Form? userInputForm,
  }) {
    final GetSnackBar getSnackBar = GetSnackBar(
        snackbarStatus: snackbarStatus,
        titleText: titleText ??
            Text(
              title,
              style: TextStyle(
                color: colorText ?? iconColor ?? Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
        messageText: messageText ??
            Text(
              message,
              style: TextStyle(
                color: colorText ?? iconColor ?? Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
        snackPosition: snackPosition ?? SnackPosition.top,
        borderRadius: borderRadius ?? 15,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 10),
        duration: duration,
        barBlur: barBlur ?? 7.0,
        backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.2),
        icon: icon,
        shouldIconPulse: shouldIconPulse ?? true,
        maxWidth: maxWidth,
        padding: padding ?? const EdgeInsets.all(16),
        borderColor: borderColor,
        borderWidth: borderWidth,
        leftBarIndicatorColor: leftBarIndicatorColor,
        boxShadows: boxShadows,
        backgroundGradient: backgroundGradient,
        mainButton: mainButton,
        onTap: onTap,
        onHover: onHover,
        isDismissible: isDismissible ?? true,
        dismissDirection: dismissDirection,
        showProgressIndicator: showProgressIndicator ?? false,
        progressIndicatorController: progressIndicatorController,
        progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
        progressIndicatorValueColor: progressIndicatorValueColor,
        snackStyle: snackStyle ?? SnackStyle.floating,
        forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
        reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
        animationDuration: animationDuration ?? const Duration(seconds: 1),
        overlayBlur: overlayBlur ?? 0.0,
        overlayColor: overlayColor ?? Colors.transparent,
        userInputForm: userInputForm);

    final SnackbarController controller = SnackbarController(getSnackBar);

    if (instantInit) {
      controller.show();
    } else {
      //routing.isSnackbar = true;
      ambiguate(Engine.instance)!.addPostFrameCallback((final _) {
        controller.show();
      });
    }
    return controller;
  }
}

extension GetNavigationExt on GetInterface {
  /// **Navigation.push()** shortcut.<br><br>
  ///
  /// Pushes a new `page` to the stack
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
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T?>? to<T extends Object?>(final Widget Function() page,
      {final bool? opaque,
      final Transition? transition,
      final Curve? curve,
      final Duration? duration,
      final String? id,
      final String? routeName,
      final bool fullscreenDialog = false,
      final dynamic arguments,
      final List<BindingsInterface> bindings = const <BindingsInterface>[],
      final bool preventDuplicates = true,
      final bool? popGesture,
      final bool showCupertinoParallax = true,
      final double Function(BuildContext context)? gestureWidth,
      final bool rebuildStack = true,
      final PreventDuplicateHandlingMode preventDuplicateHandlingMode =
          PreventDuplicateHandlingMode.reorderRoutes}) {
    return searchDelegate(id).to(
      page,
      opaque: opaque,
      transition: transition,
      curve: curve,
      duration: duration,
      id: id,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
      bindings: bindings,
      preventDuplicates: preventDuplicates,
      popGesture: popGesture,
      showCupertinoParallax: showCupertinoParallax,
      gestureWidth: gestureWidth,
      rebuildStack: rebuildStack,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode,
    );
  }

//   GetPageBuilder _resolvePage(dynamic page, String method) {
//     if (page is GetPageBuilder) {
//       return page;
//     } else if (page is Widget) {
//       Get.log(
//           '''WARNING, consider using: "Get.$method(() => Page())"
//instead of "Get.$method(Page())".
// Using a widget function instead of a widget fully guarantees that the widget
//and its controllers will be removed from memory when they are no longer used.
//       ''');
//       return () => page;
//     } else if (page is String) {
//       throw '''Unexpected String,
// use toNamed() instead''';
//     } else {
//       throw '''Unexpected format,
// you can only use widgets and widget functions here''';
//     }
//   }

  /// **Navigation.pushNamed()** shortcut.<br><br>
  ///
  /// Pushes a new named `page` to the stack.
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
  /// Note: Always put a slash on the route ('/page1'), to avoid unexpected errors
  Future<T?>? toNamed<T>(
    String page, {
    final dynamic arguments,
    final String? id,
    final bool preventDuplicates = true,
    final Map<String, String>? parameters,
  }) {
    // if (preventDuplicates && page == currentRoute) {
    //   return null;
    // }

    if (parameters != null) {
      final Uri uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return searchDelegate(id).toNamed(
      page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
  }

  /// **Navigation.pushReplacementNamed()** shortcut.<br><br>
  ///
  /// Pop the current named `page` in the stack and push a new one in its place
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
  /// Note: Always put a slash on the route ('/page1'), to avoid unexpected errors
  Future<T?>? offNamed<T>(
    String page, {
    final dynamic arguments,
    final String? id,
    final Map<String, String>? parameters,
  }) {
    // if (preventDuplicates && page == currentRoute) {
    //   return null;
    // }

    if (parameters != null) {
      final Uri uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return searchDelegate(id).offNamed(
      page,
      arguments: arguments,
      id: id,
      // preventDuplicates: preventDuplicates,
      parameters: parameters,
    );
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
  void until(final bool Function(GetPage<dynamic>) predicate,
      {final String? id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return searchDelegate(id).backUntil(predicate);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push the given named `page`, and then pop several pages in the stack
  /// until [predicate] returns true
  ///
  /// You can send any type of value to the other route in the [arguments].
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  ///
  /// [predicate] can be used like this:
  /// `Get.offNamedUntil(page, ModalRoute.withName('/home'))`
  /// to pop routes in stack until home,
  /// or like this:
  /// `Get.offNamedUntil((route) => !Get.isDialogOpen())`,
  /// to make sure the dialog is closed
  ///
  /// Note: Always put a slash on the route name ('/page1'), to avoid unexpected errors
  Future<T?>? offNamedUntil<T>(
    String page,
    final bool Function(GetPage<dynamic>)? predicate, {
    final String? id,
    final dynamic arguments,
    final Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final Uri uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return searchDelegate(id).offNamedUntil<T>(
      page,
      predicate: predicate,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  /// **Navigation.popAndPushNamed()** shortcut.<br><br>
  ///
  /// Pop the current named page and pushes a new `page` to the stack
  /// in its place
  ///
  /// You can send any type of value to the other route in the [arguments].
  /// It is very similar to `offNamed()` but use a different approach
  ///
  /// The `offNamed()` pop a page, and goes to the next. The
  /// `offAndToNamed()` goes to the next page, and removes the previous one.
  /// The route transition animation is different.
  Future<T?>? offAndToNamed<T>(
    String page, {
    final dynamic arguments,
    final String? id,
    final dynamic result,
    final Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final Uri uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return searchDelegate(id).backAndtoNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  ///
  /// Remove a specific [route] from the stack
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void removeRoute(final String name, {final String? id}) {
    return searchDelegate(id).removeRoute(name);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  ///
  /// Push a named `page` and pop several pages in the stack
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
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    // bool Function(GetPage<dynamic>)? predicate,
    final dynamic arguments,
    final String? id,
    final Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final Uri uri = Uri(path: newRouteName, queryParameters: parameters);
      newRouteName = uri.toString();
    }

    return searchDelegate(id).offAllNamed<T>(
      newRouteName,
      //predicate: predicate ?? (_) => false,
      arguments: arguments,
      id: id,
      parameters: parameters,
    );
  }

  /// Returns true if a Snackbar, Dialog or BottomSheet is currently OPEN
  bool get isOverlaysOpen =>
      isSnackbarOpen || isDialogOpen! || isBottomSheetOpen!;

  /// Returns true if there is no Snackbar, Dialog or BottomSheet open
  bool get isOverlaysClosed =>
      !isSnackbarOpen && !isDialogOpen! && !isBottomSheetOpen!;

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
  void back<T>({
    final T? result,
    final bool canPop = true,
    int times = 1,
    final String? id,
  }) {
    if (times < 1) {
      times = 1;
    }

    if (times > 1) {
      int count = 0;
      return searchDelegate(id)
          .backUntil((final GetPage route) => count++ == times);
    } else {
      if (canPop) {
        if (searchDelegate(id).canBack == true) {
          return searchDelegate(id).back<T>(result);
        }
      } else {
        return searchDelegate(id).back<T>(result);
      }
    }
  }

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
  void backLegacy<T>({
    final T? result,
    final bool closeOverlays = false,
    final bool canPop = true,
    int times = 1,
    final String? id,
  }) {
    if (closeOverlays) {
      closeAllOverlays();
    }

    if (times < 1) {
      times = 1;
    }

    if (times > 1) {
      int count = 0;
      return searchDelegate(id)
          .navigatorKey
          .currentState
          ?.popUntil((final Route route) {
        return count++ == times;
      });
    } else {
      if (canPop) {
        if (searchDelegate(id).navigatorKey.currentState?.canPop() == true) {
          return searchDelegate(id).navigatorKey.currentState?.pop<T>(result);
        }
      } else {
        return searchDelegate(id).navigatorKey.currentState?.pop<T>(result);
      }
    }
  }

  void closeAllDialogsAndBottomSheets(
    final String? id,
  ) {
    // It can not be divided, because dialogs and bottomsheets can not be consecutive
    while (isDialogOpen! && isBottomSheetOpen!) {
      closeOverlay(id: id);
    }
  }

  void closeAllDialogs({
    final String? id,
  }) {
    while (isDialogOpen!) {
      closeOverlay(id: id);
    }
  }

  void closeOverlay({final String? id}) {
    searchDelegate(id).navigatorKey.currentState?.pop();
  }

  void closeAllBottomSheets({
    final String? id,
  }) {
    while (isBottomSheetOpen!) {
      searchDelegate(id).navigatorKey.currentState?.pop();
    }
  }

  void closeAllOverlays() {
    closeAllDialogsAndBottomSheets(null);
    closeAllSnackbars();
  }

  /// **Navigation.popUntil()** (with predicate) shortcut .<br><br>
  ///
  /// Close as many routes as defined by [times]
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void close<T extends Object>({
    final bool closeAll = true,
    final bool closeSnackbar = true,
    final bool closeDialog = true,
    final bool closeBottomSheet = true,
    final String? id,
    final T? result,
  }) {
    void handleClose(final bool closeCondition, final Function closeAllFunction,
        final Function closeSingleFunction,
        [final bool? isOpenCondition]) {
      if (closeCondition) {
        if (closeAll) {
          closeAllFunction();
        } else if (isOpenCondition == true) {
          closeSingleFunction();
        }
      }
    }

    handleClose(closeSnackbar, closeAllSnackbars, closeCurrentSnackbar);
    handleClose(closeDialog, closeAllDialogs, closeOverlay, isDialogOpen);
    handleClose(closeBottomSheet, closeAllBottomSheets, closeOverlay,
        isBottomSheetOpen);
  }

  /// **Navigation.pushReplacement()** shortcut .<br><br>
  ///
  /// Pop the current page and pushes a new `page` to the stack
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
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T?>? off<T>(
    final Widget Function() page, {
    final bool? opaque,
    final Transition? transition,
    final Curve? curve,
    final bool? popGesture,
    final String? id,
    String? routeName,
    final dynamic arguments,
    final List<BindingsInterface> bindings = const <BindingsInterface>[],
    final bool fullscreenDialog = false,
    final bool preventDuplicates = true,
    final Duration? duration,
    final double Function(BuildContext context)? gestureWidth,
  }) {
    routeName ??= '/${page.runtimeType}';
    routeName = _cleanRouteName(routeName);
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return searchDelegate(id).off(
      page,
      opaque: opaque ?? true,
      transition: transition,
      curve: curve,
      popGesture: popGesture,
      id: id,
      routeName: routeName,
      arguments: arguments,
      bindings: bindings,
      fullscreenDialog: fullscreenDialog,
      preventDuplicates: preventDuplicates,
      duration: duration,
      gestureWidth: gestureWidth,
    );
  }

  Future<T?> offUntil<T>(
    final Widget Function() page,
    final bool Function(GetPage) predicate, [
    final Object? arguments,
    final String? id,
  ]) {
    return searchDelegate(id).offUntil(
      page,
      predicate,
      arguments,
    );
  }

  ///
  /// Push a `page` and pop several pages in the stack
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
  /// If you're using the [BindingsInterface] api, you must define it here
  ///
  /// By default, GetX will prevent you from push a route that you already in,
  /// if you want to push anyway, set [preventDuplicates] to false
  Future<T?>? offAll<T>(
    final Widget Function() page, {
    final bool Function(GetPage<dynamic>)? predicate,
    final bool? opaque,
    final bool? popGesture,
    final String? id,
    String? routeName,
    final dynamic arguments,
    final List<BindingsInterface> bindings = const <BindingsInterface>[],
    final bool fullscreenDialog = false,
    final Transition? transition,
    final Curve? curve,
    final Duration? duration,
    final double Function(BuildContext context)? gestureWidth,
  }) {
    routeName ??= '/${page.runtimeType}';
    routeName = _cleanRouteName(routeName);
    return searchDelegate(id).offAll<T>(
      page,
      predicate: predicate,
      opaque: opaque ?? true,
      popGesture: popGesture,
      id: id,
      //  routeName routeName,
      arguments: arguments,
      bindings: bindings,
      fullscreenDialog: fullscreenDialog,
      transition: transition,
      curve: curve,
      duration: duration,
      gestureWidth: gestureWidth,
    );
  }

  /// Takes a route [name] String generated by [to], [off], [offAll]
  /// (and similar context navigation methods), cleans the extra chars and
  /// accommodates the format.
  /// TODO: check for a more "appealing" URL naming convention.
  /// `() => MyHomeScreenView` becomes `/my-home-screen-view`.
  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncomment for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }
  //TODO: Deprecated
  // /// change default config of Get
  // void config(
  //     {bool? enableLog,
  //     LogWriterCallback? logWriterCallback,
  //     bool? defaultPopGesture,
  //     bool? defaultOpaqueRoute,
  //     Duration? defaultDurationTransition,
  //     bool? defaultGlobalState,
  //     Transition? defaultTransition}) {
  //   if (enableLog != null) {
  //     Get.isLogEnable = enableLog;
  //   }
  //   if (logWriterCallback != null) {
  //     Get.log = logWriterCallback;
  //   }
  //   if (defaultPopGesture != null) {
  //     _getxController.defaultPopGesture = defaultPopGesture;
  //   }
  //   if (defaultOpaqueRoute != null) {
  //     _getxController.defaultOpaqueRoute = defaultOpaqueRoute;
  //   }
  //   if (defaultTransition != null) {
  //     _getxController.defaultTransition = defaultTransition;
  //   }

  //   if (defaultDurationTransition != null) {
  //     _getxController.defaultTransitionDuration = defaultDurationTransition;
  //   }
  // }

  Future<void> updateLocale(final Locale l) async {
    Get.locale = l;
    await forceAppUpdate();
  }

  /// As a rule, Flutter knows which widget to update,
  /// so this command is rarely needed. We can mention situations
  /// where you use const so that widgets are not updated with setState,
  /// but you want it to be forcefully updated when an event like
  /// language change happens. using context to make the widget dirty
  /// for performRebuild() is a viable solution.
  /// However, in situations where this is not possible, or at least,
  /// is not desired by the developer, the only solution for updating
  /// widgets that Flutter does not want to update is to use reassemble
  /// to forcibly rebuild all widgets. Attention: calling this function will
  /// reconstruct the application from the sketch, use this with caution.
  /// Your entire application will be rebuilt, and touch events will not
  /// work until the end of rendering.
  Future<void> forceAppUpdate() async {
    await engine.performReassemble();
  }

  void appUpdate() => rootController.update();

  void changeTheme(final ThemeData theme) {
    rootController.setTheme(theme);
  }

  void changeThemeMode(final ThemeMode themeMode) {
    rootController.setThemeMode(themeMode);
  }

  GlobalKey<NavigatorState>? addKey(final GlobalKey<NavigatorState> newKey) {
    return rootController.addKey(newKey);
  }

  GetDelegate? nestedKey(final String? key) {
    return rootController.nestedKey(key);
  }

  GetDelegate searchDelegate(final String? k) {
    GetDelegate key;
    if (k == null) {
      key = Get.rootController.rootDelegate;
    } else {
      if (!keys.containsKey(k)) {
        throw 'Route id ($k) not found';
      }
      key = keys[k]!;
    }

    // if (_key.listenersLength == 0 && !testMode) {
    //   throw """You are trying to use contextless navigation without
    //   a GetMaterialApp or Get.key.
    //   If you are testing your app, you can use:
    //   [Get.testMode = true], or if you are running your app on
    //   a physical device or emulator, you must exchange your [MaterialApp]
    //   for a [GetMaterialApp].
    //   """;
    // }

    return key;
  }

  /// give current arguments
  //dynamic get arguments => routing.args;
  dynamic get arguments => rootController.rootDelegate.arguments();

  /// give name from current route
  String get currentRoute => routing.current;

  /// give name from previous route
  String get previousRoute => routing.previous;

  /// check if snackbar is open
  bool get isSnackbarOpen =>
      SnackbarController.isSnackbarBeingShown; //routing.isSnackbar;

  void closeAllSnackbars() {
    SnackbarController.cancelAllSnackbars();
  }

  Future<void> closeCurrentSnackbar() async {
    await SnackbarController.closeCurrentSnackbar();
  }

  /// check if dialog is open
  bool? get isDialogOpen => routing.isDialog;

  /// check if bottomsheet is open
  bool? get isBottomSheetOpen => routing.isBottomSheet;

  /// check a raw current route
  Route<dynamic>? get rawRoute => routing.route;

  /// check if popGesture is enable
  bool get isPopGestureEnable => defaultPopGesture;

  /// check if default opaque route is enable
  bool get isOpaqueRouteDefault => defaultOpaqueRoute;

  /// give access to currentContext
  BuildContext? get context => key.currentContext;

  /// give access to current Overlay Context
  BuildContext? get overlayContext {
    BuildContext? overlay;
    key.currentState?.overlay?.context
        .visitChildElements((final Element element) {
      overlay = element;
    });
    return overlay;
  }

  /// give access to Theme.of(context)
  ThemeData get theme {
    ThemeData theme = ThemeData.fallback();
    if (context != null) {
      theme = Theme.of(context!);
    }
    return theme;
  }

  /// The current null safe [WidgetsBinding]
  WidgetsBinding get engine {
    return WidgetsFlutterBinding.ensureInitialized();
  }

  /// The window to which this binding is bound.
  ui.PlatformDispatcher get window => engine.platformDispatcher;

  Locale? get deviceLocale => window.locale;

  ///The number of device pixels for each logical pixel.
  double get pixelRatio => window.implicitView!.devicePixelRatio;

  Size get size => window.implicitView!.physicalSize / pixelRatio;

  ///The horizontal extent of this size.
  double get width => size.width;

  ///The vertical extent of this size
  double get height => size.height;

  ///The distance from the top edge to the first unpadded pixel,
  ///in physical pixels.
  double get statusBarHeight => window.implicitView!.padding.top;

  ///The distance from the bottom edge to the first unpadded pixel,
  ///in physical pixels.
  double get bottomBarHeight => window.implicitView!.padding.bottom;

  ///The system-reported text scale.
  double get textScaleFactor => window.textScaleFactor;

  /// give access to TextTheme.of(context)
  TextTheme get textTheme => theme.textTheme;

  /// give access to Mediaquery.of(context)
  MediaQueryData get mediaQuery => MediaQuery.of(context!);

  /// Check if dark mode theme is enable
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if dark mode theme is enable on platform on android Q+
  bool get isPlatformDarkMode =>
      ui.window.platformBrightness == Brightness.dark;

  /// give access to Theme.of(context).iconTheme.color
  Color? get iconColor => theme.iconTheme.color;

  /// give access to FocusScope.of(context)
  FocusNode? get focusScope => FocusManager.instance.primaryFocus;

  // /// give access to Immutable MediaQuery.of(context).size.height
  // double get height => MediaQuery.of(context).size.height;

  // /// give access to Immutable MediaQuery.of(context).size.width
  // double get width => MediaQuery.of(context).size.width;

  GlobalKey<NavigatorState> get key => rootController.key;

  Map<String, GetDelegate> get keys => rootController.keys;

  GetRootState get rootController => GetRootState.controller;

  ConfigData get _getxController => GetRootState.controller.config;

  bool get defaultPopGesture => _getxController.defaultPopGesture;
  bool get defaultOpaqueRoute => _getxController.defaultOpaqueRoute;

  Transition? get defaultTransition => _getxController.defaultTransition;

  Duration get defaultTransitionDuration {
    return _getxController.defaultTransitionDuration;
  }

  Curve get defaultTransitionCurve => _getxController.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve {
    return _getxController.defaultDialogTransitionCurve;
  }

  Duration get defaultDialogTransitionDuration {
    return _getxController.defaultDialogTransitionDuration;
  }

  Routing get routing => _getxController.routing;

  set parameters(final Map<String, String?> newParameters) =>
      rootController.parameters = newParameters;

  set testMode(final bool isTest) => rootController.testMode = isTest;

  bool get testMode => _getxController.testMode;

  Map<String, String?> get parameters => rootController.rootDelegate.parameters;

  /// Casts the stored router delegate to a desired type
  TDelegate? delegate<TDelegate extends RouterDelegate<TPage>, TPage>() =>
      _getxController.routerDelegate as TDelegate?;
}

extension OverlayExt on GetInterface {
  Future<T> showOverlay<T>({
    required final Future<T> Function() asyncFunction,
    final Color opacityColor = Colors.black,
    final Widget? loadingWidget,
    final double opacity = .5,
  }) async {
    final NavigatorState navigatorState = Navigator.of(Get.overlayContext!);
    final OverlayState overlayState = navigatorState.overlay!;

    final OverlayEntry overlayEntryOpacity =
        OverlayEntry(builder: (final BuildContext context) {
      return Opacity(
          opacity: opacity,
          child: Container(
            color: opacityColor,
          ));
    });
    final OverlayEntry overlayEntryLoader =
        OverlayEntry(builder: (final BuildContext context) {
      return loadingWidget ??
          const Center(
              child: SizedBox(
            height: 90,
            width: 90,
            child: Text('Loading...'),
          ));
    });
    overlayState.insert(overlayEntryOpacity);
    overlayState.insert(overlayEntryLoader);

    T data;

    try {
      data = await asyncFunction();
    } on Exception catch (_) {
      overlayEntryLoader.remove();
      overlayEntryOpacity.remove();
      rethrow;
    }

    overlayEntryLoader.remove();
    overlayEntryOpacity.remove();
    return data;
  }
}

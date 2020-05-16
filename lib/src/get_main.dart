import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'bottomsheet/bottomsheet.dart';
import 'platform/platform.dart';
import 'root/root_controller.dart';
import 'routes/default_route.dart';
import 'routes/observers/route_observer.dart';
import 'routes/transitions_type.dart';
import 'rx/rx_interface.dart';
import 'snackbar/snack.dart';

class Get {
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

  bool _enableLog = true;
  bool _defaultPopGesture = GetPlatform.isIOS;
  bool _defaultOpaqueRoute = true;
  Transition _defaultTransition =
      (GetPlatform.isIOS ? Transition.cupertino : Transition.fade);
  Duration _defaultDurationTransition = Duration(milliseconds: 400);
  bool _defaultGlobalState = true;
  RouteSettings _settings;

  ///Use Get.to instead of Navigator.push, Get.off instead of Navigator.pushReplacement,
  ///Get.offAll instead of Navigator.pushAndRemoveUntil. For named routes just add "named"
  ///after them. Example: Get.toNamed, Get.offNamed, and Get.AllNamed.
  ///To return to the previous screen, use Get.back().
  ///No need to pass any context to Get, just put the name of the route inside
  ///the parentheses and the magic will occur.
  Get._();

  static Get _get;

  GlobalKey<NavigatorState> _key;

  /// It replaces Navigator.push, but needs no context, and it doesn't have the Navigator.push
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  static Future<T> to<T>(Widget page,
      {bool opaque,
      Transition transition,
      Duration duration,
      int id,
      bool fullscreenDialog = false,
      Object arguments,
      bool popGesture}) {
    return _get.global(id).currentState.push(GetRouteBase(
        opaque: opaque ?? true,
        page: page,
        settings: RouteSettings(
            name: '/' + page.toString().toLowerCase(), arguments: arguments),
        popGesture: popGesture ?? _get._defaultPopGesture,
        transition: transition ?? _get._defaultTransition,
        fullscreenDialog: fullscreenDialog,
        transitionDuration: duration ?? _get._defaultDurationTransition));
  }

  /// It replaces Navigator.pushNamed, but needs no context, and it doesn't have the Navigator.pushNamed
  /// routes rebuild bug present in Flutter. If for some strange reason you want the default behavior
  /// of rebuilding every app after a route, use opaque = true as the parameter.
  static Future<T> toNamed<T>(String page, {arguments, int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return _get.global(id).currentState.pushNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.pushReplacementNamed, but needs no context.
  static Future<T> offNamed<T>(String page, {arguments, int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return _get
        .global(id)
        .currentState
        .pushReplacementNamed(page, arguments: arguments);
  }

  /// It replaces Navigator.popUntil, but needs no context.
  static void until(predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return _get.global(id).currentState.popUntil(predicate);
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context.
  static Future<T> offUntil<T>(page, predicate, {int id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return _get.global(id).currentState.pushAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static Future<T> offNamedUntil<T>(page, predicate, {int id}) {
    return _get
        .global(id)
        .currentState
        .pushNamedAndRemoveUntil(page, predicate);
  }

  /// It replaces Navigator.popAndPushNamed, but needs no context.
  static Future<T> offAndToNamed<T>(String page, {arguments, int id, result}) {
    return _get
        .global(id)
        .currentState
        .popAndPushNamed(page, arguments: arguments, result: result);
  }

  /// It replaces Navigator.removeRoute, but needs no context.
  static void removeRoute(route, {int id}) {
    return _get.global(id).currentState.removeRoute(route);
  }

  /// It replaces Navigator.pushNamedAndRemoveUntil, but needs no context.
  static Future<T> offAllNamed<T>(String newRouteName,
      {RoutePredicate predicate, arguments, int id}) {
    var route = (Route<dynamic> rota) => false;

    return _get.global(id).currentState.pushNamedAndRemoveUntil(
        newRouteName, predicate ?? route,
        arguments: arguments);
  }

  static bool get isOverlaysOpen =>
      (isSnackbarOpen || isDialogOpen || isBottomSheetOpen);

  static bool get isOverlaysClosed =>
      (!Get.isSnackbarOpen && !Get.isDialogOpen && !Get.isBottomSheetOpen);

  /// It replaces Navigator.pop, but needs no context.
  static void back({dynamic result, bool closeOverlays = false, int id}) {
    if (closeOverlays && isOverlaysOpen) {
      navigator.popUntil((route) {
        return (isOverlaysClosed);
      });
    }
    _get.global(id).currentState.pop(result);
  }

  // /// Experimental API to back from overlay
  // static void backE({dynamic result}) {
  //   Navigator.pop(overlayContext);
  // }

  /// It will close as many screens as you define. Times must be> 0;
  static void close(int times, [int id]) {
    if ((times == null) || (times < 1)) {
      times = 1;
    }
    int count = 0;
    void back = _get.global(id).currentState.popUntil((route) {
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
      int id,
      Object arguments,
      bool fullscreenDialog = false,
      Duration duration}) {
    return _get.global(id).currentState.pushReplacement(GetRouteBase(
        opaque: opaque ?? true,
        page: page,
        settings: RouteSettings(
            name: '/' + page.toString().toLowerCase(), arguments: arguments),
        fullscreenDialog: fullscreenDialog,
        popGesture: popGesture ?? _get._defaultPopGesture,
        transition: transition ?? _get._defaultTransition,
        transitionDuration: duration ?? _get._defaultDurationTransition));
  }

  /// It replaces Navigator.pushAndRemoveUntil, but needs no context
  static Future<T> offAll<T>(Widget page,
      {RoutePredicate predicate,
      bool opaque = false,
      bool popGesture,
      int id,
      Object arguments,
      bool fullscreenDialog = false,
      Transition transition}) {
    var route = (Route<dynamic> rota) => false;

    return _get.global(id).currentState.pushAndRemoveUntil(
        GetRouteBase(
          opaque: opaque ?? true,
          popGesture: popGesture ?? _get._defaultPopGesture,
          page: page,
          settings: RouteSettings(
              name: '/' + page.toString().toLowerCase(), arguments: arguments),
          fullscreenDialog: fullscreenDialog,
          transition: transition ?? _get._defaultTransition,
        ),
        predicate ?? route);
  }

  /// Show a dialog
  static Future<T> dialog<T>(
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
  static Future<T> generalDialog<T>({
    @required RoutePageBuilder pageBuilder,
    bool barrierDismissible,
    String barrierLabel,
    Color barrierColor,
    Duration transitionDuration,
    RouteTransitionsBuilder transitionBuilder,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
    //  RouteSettings routeSettings
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

  static Future<T> defaultDialog<T>({
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
            Get.back();
          },
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            textCancel ?? "Cancel",
            style: TextStyle(color: cancelTextColor ?? theme.accentColor),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: buttonColor ?? Get.theme.accentColor,
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
            color: buttonColor ?? Get.theme.accentColor,
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
    return Get.dialog(AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      backgroundColor: backgroundColor ?? Get.theme.dialogBackgroundColor,
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

  static Future<T> bottomSheet<T>(
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

    return navigator.push<T>(GetModalBottomSheetRoute<T>(
      builder: (_) => bottomsheet,
      theme: Theme.of(Get.key.currentContext, shadowThemeOnly: true),
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(Get.key.currentContext)
          .modalBarrierDismissLabel,
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

  static void rawSnackbar(
      {String title,
      String message,
      Widget titleText,
      Widget messageText,
      Widget icon,
      bool instantInit = false,
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

  static void snackbar(title, message,
      {Color colorText,
      Duration duration,

      /// with instantInit = false you can put Get.snackbar on initState
      bool instantInit = false,
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBar.show();
      });
    }
  }

  /// change default config of Get
  Get.config(
      {bool enableLog,
      bool defaultPopGesture,
      bool defaultOpaqueRoute,
      Duration defaultDurationTransition,
      bool defaultGlobalState,
      Transition defaultTransition}) {
    if (enableLog != null) {
      _get._enableLog = enableLog;
    }
    if (defaultPopGesture != null) {
      _get._defaultPopGesture = defaultPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      _get._defaultOpaqueRoute = defaultOpaqueRoute;
    }
    if (defaultTransition != null) {
      _get._defaultTransition = defaultTransition;
    }

    if (defaultDurationTransition != null) {
      _get._defaultDurationTransition = defaultDurationTransition;
    }

    if (defaultGlobalState != null) {
      _get._defaultGlobalState = defaultGlobalState;
    }
  }

  GetMaterialController _getController = GetMaterialController();

  GetMaterialController get getController => _getController;

  Get.changeTheme(ThemeData theme) {
    _get._getController.setTheme(theme);
  }

  Get.restartApp() {
    _get._getController.restartApp();
  }

  static GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey) {
    Get()._key = newKey;
    return Get()._key;
  }

  static GlobalKey<NavigatorState> get key {
    // _get start empty, is mandatory key be static to prevent errors like "key was called null"
    if (Get()._key == null) {
      Get()._key = GlobalKey<NavigatorState>();
    }
    return Get()._key;
  }

  Map<int, GlobalKey<NavigatorState>> _keys = {};

  static GlobalKey<NavigatorState> nestedKey(int key) {
    _get._keys.putIfAbsent(key, () => GlobalKey<NavigatorState>());
    return _get._keys[key];
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

  //////////// INSTANCE MANAGER
  Map<dynamic, dynamic> _singl = {};

  Map<dynamic, _FcBuilderFunc> _factory = {};

  static void lazyPut<S>(_FcBuilderFunc function) {
    Get()._factory.putIfAbsent(S, () => function);
  }

  /// Inject class on Get Instance Manager
  static S put<S>(
    S dependency, {
    String name,
    bool overrideAbstract = false,
    _FcBuilderFunc<S> builder,
  }) {
    _insert(
        isSingleton: true,
        replace: overrideAbstract,
        //?? (("$S" == "${dependency.runtimeType}") == false),
        name: name,
        builder: builder ?? (() => dependency));
    return find<S>(name: name);
  }

  /// Create a new instance from builder class
  /// Example
  /// Get.create(() => Repl());
  /// Repl a = Get.find();
  /// Repl b = Get.find();
  /// print(a==b); (false)
  static void create<S>(
    _FcBuilderFunc<S> builder, {
    String name,
  }) {
    _insert(isSingleton: false, name: name, builder: builder);
  }

  static void _insert<S>({
    bool isSingleton,
    String name,
    bool replace = true,
    _FcBuilderFunc<S> builder,
  }) {
    assert(builder != null);
    String key = _getKey(S, name);
    if (replace) {
      Get()._singl[key] = _FcBuilder<S>(isSingleton, builder);
    } else {
      Get()._singl.putIfAbsent(key, () => _FcBuilder<S>(isSingleton, builder));
    }
  }

  /// Find a instance from required class
  static S find<S>({String name, _FcBuilderFunc<S> instance}) {
    if (Get.isRegistred<S>()) {
      String key = _getKey(S, name);
      _FcBuilder builder = Get()._singl[key];
      if (builder == null) {
        if (name == null) {
          throw "class ${S.toString()} is not register";
        } else {
          throw "class ${S.toString()} with name '$name' is not register";
        }
      }
      return Get()._singl[key].getSependency();
    } else {
      if (!Get()._factory.containsKey(S))
        throw " $S not found. You need call Get.put<$S>($S()) before";

      if (isLogEnable) print('[GET] $S instance was created at that time');
      S _value = Get.put<S>(Get()._factory[S].call() as S);
      Get()._factory.remove(S);
      return _value;
    }
  }

  static S findInstance<S>(_FcBuilderFunc<S> instance, {String name}) {
    if (Get()._singl.containsKey(_getKey(instance.call().runtimeType, name))) {
      String key = _getKey(instance.call().runtimeType, name);
      _FcBuilder builder = Get()._singl[key];
      if (builder == null) {
        if (name == null) {
          throw "class ${S.toString()} is not register";
        } else {
          throw "class ${S.toString()} with name '$name' is not register";
        }
      }
      return Get()._singl[key].getSependency();
    } else {
      if (!Get()._factory.containsKey(instance.call().runtimeType))
        throw " $S not found. You need call Get.put<$S>($S()) before";

      if (isLogEnable) print('[GET] $S instance was created at that time');
      S _value =
          Get.put<S>(Get()._factory[instance.call().runtimeType].call() as S);
      Get()._factory.remove(instance.call().runtimeType);
      return _value;
    }
  }

  /// Remove dependency of [S] on dependency abstraction. For concrete class use Get.delete
  static void remove<S>({String name}) {
    String key = _getKey(S, name);
    _FcBuilder builder = Get()._singl[key];
    if (builder != null) builder.dependency = null;
    if (Get()._singl.containsKey(key)) {
      print('error on remove $key');
    } else {
      if (isLogEnable) print('[GET] $key removed from memory');
    }
  }

  static String _getKey(Type type, String name) {
    return name == null ? type.toString() : type.toString() + name;
  }

  static bool reset() {
    Get()._singl.clear();
    return true;
  }

  /// Delete class instance on [S] and clean memory
  static bool delete<S>({String name}) {
    String key = _getKey(S, name);

    if (!Get()._singl.containsKey(key)) {
      print('Instance $key not found');
      return false;
    }
    Get()._singl.removeWhere((oldkey, value) => (oldkey == key));
    if (Get()._singl.containsKey(key)) {
      print('error on remove object $key');
    } else {
      if (isLogEnable) print('[GET] $key deleted from memory');
    }
    return true;
  }

  /// check if instance is registred
  static bool isRegistred<S>({String name}) =>
      Get()._singl.containsKey(_getKey(S, name));

  /// give access to Routing API from GetObserver
  static Routing get routing => _get._routing;

  static RouteSettings get routeSettings => _get._settings;

  Routing _routing;

  Map<String, String> _parameters = {};

  Get.setParameter(Map<String, String> param) {
    _parameters = param;
  }

  Get.setRouting(Routing rt) {
    _routing = rt;
  }

  Get.setSettings(RouteSettings settings) {
    _settings = settings;
  }

  /// give current arguments
  static Object get arguments => _get._routing.args;

  /// give current arguments
  static Map<String, String> get parameters => _get._parameters;

  /// interface to GetX
  RxInterface _obs;

  static RxInterface get obs => _get._obs;

  static set obs(RxInterface observer) => _get._obs = observer;

  /// give arguments from previous route
  static get previousArguments => _get._routing.previousArgs;

  /// give name from current route
  static get currentRoute => _get._routing.current;

  /// give name from previous route
  static get previousRoute => _get._routing.previous;

  /// check if snackbar is open
  static bool get isSnackbarOpen => _get._routing.isSnackbar;

  /// check if dialog is open
  static bool get isDialogOpen => _get._routing.isDialog;

  /// check if bottomsheet is open
  static bool get isBottomSheetOpen => _get._routing.isBottomSheet;

  /// check a raw current route
  static Route<dynamic> get rawRoute => _get._routing.route;

  /// check if log is enable
  static bool get isLogEnable => _get._enableLog;

  /// default duration of transition animation
  /// default duration work only API 2.0
  static Duration get defaultDurationTransition =>
      _get._defaultDurationTransition;

  /// give global state of all GetState by default
  static bool get defaultGlobalState => _get._defaultGlobalState;

  /// check if popGesture is enable
  static bool get isPopGestureEnable => _get._defaultPopGesture;

  /// check if default opaque route is enable
  static bool get isOpaqueRouteDefault => _get._defaultOpaqueRoute;

  static Transition get defaultTransition => _get._defaultTransition;

  /// give access to currentContext
  static BuildContext get context => key.currentContext;

  /// give access to current Overlay Context
  static BuildContext get overlayContext => key.currentState.overlay.context;

  /// give access to Theme.of(context)
  static ThemeData get theme => Theme.of(context);

  /// give access to TextTheme.of(context)
  static TextTheme get textTheme => Theme.of(context).textTheme;

  /// give access to Mediaquery.of(context)
  static MediaQueryData get mediaQuery => MediaQuery.of(context);

  /// Check if dark mode theme is enable
  static get isDarkMode => (theme.brightness == Brightness.dark);

  /// Check if dark mode theme is enable on platform on android Q+
  static get isPlatformDarkMode =>
      (mediaQuery.platformBrightness == Brightness.dark);

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

class _FcBuilder<S> {
  bool isSingleton;
  _FcBuilderFunc builderFunc;
  S dependency;

  _FcBuilder(this.isSingleton, this.builderFunc);

  S getSependency() {
    if (isSingleton) {
      if (dependency == null) {
        dependency = builderFunc() as S;
      }
      return dependency;
    } else {
      return builderFunc() as S;
    }
  }
}

typedef _FcBuilderFunc<S> = S Function();

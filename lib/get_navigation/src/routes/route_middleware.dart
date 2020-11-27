import 'package:flutter/cupertino.dart';
import '../../../get.dart';

/// The Page Middlewares
/// The Functions will be called in this order
/// (( [onPageCalled] -> [onBindingsStart] -> [onPageBuildStart] ->
/// [onPageBuilt] -> [onPageDispose] ))
abstract class GetPageMiddleware {
  /// The Order of the Middlewares to run.
  int priority;

  /// This function will be the first thing to call when this Page is called
  /// you can use it to redirect befor anything in this page happend.
  /// {@tool snippet}
  /// ```dart
  /// GetPage onPageCalled( ) {
  ///   final authService = Get.find<AuthService>();
  ///   return authService.isAuthed ? null : '/login';
  /// }
  /// ```
  /// {@end-tool}
  String redirect();

  ///This function will be called right before the [Bindings] are initialize.
  /// Here you can change [Bindings] for this page
  List<Bindings> onBindingsStart(List<Bindings> bindings);

  /// This function will be called right after the [Bindings] are initialize.
  GetPageBuilder onPageBuildStart(GetPageBuilder page);

  // Get the built page
  Widget onPageBuilt(Widget page);

  void onPageDispose();
}

class MiddlewareRunner {
  MiddlewareRunner(this._middlewares);

  final List<GetPageMiddleware> _middlewares;

  List<GetPageMiddleware> _getMiddlewares() {
    if (_middlewares != null) {
      _middlewares.sort((a, b) => a.priority.compareTo(b.priority));
      return _middlewares;
    }
    return <GetPageMiddleware>[];
  }

  String runOnPageCalled() {
    var to = '';
    _getMiddlewares().forEach((element) {
      to = element.redirect();
    });
    if (!to.isNullOrBlank) {
      Get.log('Redirect to $to');
    }
    return to;
  }

  List<Bindings> runOnBindingsStart(List<Bindings> bindings) {
    _getMiddlewares().forEach((element) {
      bindings = element.onBindingsStart(bindings);
    });
    return bindings;
  }

  GetPageBuilder runOnPageBuildStart(GetPageBuilder page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuildStart(page);
    });
    return page;
  }

  Widget runOnPageBuilt(Widget page) {
    _getMiddlewares().forEach((element) {
      page = element.onPageBuilt(page);
    });
    return page;
  }

  void runOnPageDispose() =>
      _getMiddlewares().forEach((element) => element.onPageDispose());
}

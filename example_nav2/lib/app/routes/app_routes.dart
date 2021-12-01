// ignore_for_file: non_constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  static const HOME = _Paths.HOME;

  static const PROFILE = _Paths.HOME + _Paths.PROFILE;
  static const SETTINGS = _Paths.SETTINGS;

  static const PRODUCTS = _Paths.HOME + _Paths.PRODUCTS;

  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.HOME + _Paths.DASHBOARD;
  Routes._();
  static String LOGIN_THEN(String afterSuccessfulLogin) =>
      '$LOGIN?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  static String PRODUCT_DETAILS(String productId) => '$PRODUCTS/$productId';
}

abstract class _Paths {
  static const HOME = '/home';
  static const PRODUCTS = '/products';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const PRODUCT_DETAILS = '/:productId';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
}

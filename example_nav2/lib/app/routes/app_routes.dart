part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const PROFILE = _Paths.PROFILE;

  static const SETTINGS = _Paths.SETTINGS;

  static const PRODUCTS = _Paths.PRODUCTS;
  static PRODUCT_DETAILS(String productId) => '${_Paths.PRODUCTS}/$productId';
}

abstract class _Paths {
  static const HOME = '/home';
  static const PRODUCTS = '/products';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const PRODUCT_DETAILS = '/:productId';
}

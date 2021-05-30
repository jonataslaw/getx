import 'package:get/get.dart';
import 'package:get/get_navigation/src/nav2/router_outlet.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      //TODO: don't group bindings in one place, and instead make each page use its own binding
      bindings: [
        HomeBinding(),
        //These must use [Get.lazyPut] or [Get.create] because their view is created long after they are declared
        ProfileBinding(),
        ProductsBinding(),
        ProductDetailsBinding(),
      ],
      title: null,
      middlewares: [
        RouterOutletContainerMiddleWare(_Paths.HOME),
      ],
      children: [
        GetPage(
          name: _Paths.PROFILE,
          page: () => ProfileView(),
          title: 'Profile',
        ),
        GetPage(
          name: _Paths.PRODUCTS,
          page: () => ProductsView(),
          title: 'Products',
          children: [
            GetPage(
              name: _Paths.PRODUCT_DETAILS,
              page: () => ProductDetailsView(),
            ),
          ],
        ),
      ],
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}

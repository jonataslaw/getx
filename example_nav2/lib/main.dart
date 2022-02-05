import 'package:example_nav2/helpers/number_formatter.dart';
import 'package:example_nav2/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'services/auth_service.dart';

void main() {
  getIt.registerSingleton<MyNumberFormatter>(MyNumberFormatter());

  runApp(
    GetMaterialApp.router(
      title: "Application",
      initialBinding: BindingsBuilder(
        () {
          Get.put(AuthService());
        },
      ),
      getPages: AppPages.routes,
      // routeInformationParser: GetInformationParser(
      //     // initialRoute: Routes.HOME,
      //     ),
      // routerDelegate: GetDelegate(
      //   backButtonPopMode: PopMode.History,
      //   preventDuplicateHandlingMode:
      //       PreventDuplicateHandlingMode.ReorderRoutes,
      // ),
    ),
  );
}

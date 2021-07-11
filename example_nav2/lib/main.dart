import 'package:example_nav2/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp.router(
      title: "Application",
      initialBinding: BindingsBuilder(
        () {
          Get.put(AuthService());
        },
      ),
      getPages: AppPages.routes,
      routeInformationParser: GetInformationParser(
          // initialRoute: Routes.HOME,
          ),
      routerDelegate: GetDelegate(
        backButtonPopMode: PopMode.History,
        preventDuplicateHandlingMode:
            PreventDuplicateHandlingMode.ReorderRoutes,
      ),
    ),
  );
}

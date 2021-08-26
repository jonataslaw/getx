import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'services/auth_service.dart';

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

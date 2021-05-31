import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp.router(
      title: "Application",
      getPages: AppPages.routes,
      routeInformationParser: GetInformationParser(),
      routerDelegate: GetDelegate(),
    ),
  );
}

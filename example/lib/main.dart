import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_state/home/views/country_view.dart';
import 'home/views/details_view.dart';
import 'home/views/home_view.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    namedRoutes: {
      '/': GetRoute(page: HomePage()),
      '/country': GetRoute(page: CountryPage()),
      '/details': GetRoute(page: DetailsPage()),
    },
  ));
}

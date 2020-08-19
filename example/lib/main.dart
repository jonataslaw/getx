import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_state/home/bindings/home_binding.dart';
import 'package:get_state/home/views/country_view.dart';
import 'home/views/details_view.dart';
import 'home/views/home_view.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      enableLog: true,
      // logWriterCallback: localLogWriter,
      getPages: [
        GetPage(name: '/', page: () => HomePage(), binding: HomeBinding()),
        GetPage(name: '/country', page: () => CountryPage()),
        GetPage(name: '/details', page: () => DetailsPage()),
      ],
    ),
  );
}

// Sample of abstract logging function
void localLogWriter(String text, {bool isError = false}) {
  print('** ' + text + ' [' + isError.toString() + ']');
}

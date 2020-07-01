import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/src/routes/get_route.dart';

void main() {
  testWidgets(
    'GetPage page null',
    (WidgetTester testr) async {
      expect(() => GetPage(page: null, name: null), throwsAssertionError);
    },
  );

  testWidgets(
    "GetRoute maintainState null",
    (WidgetTester testr) async {
      expect(
          () => GetPage(page: () => Scaffold(), maintainState: null, name: '/'),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetRoute name null",
    (WidgetTester testr) async {
      expect(
          () =>
              GetPage(page: () => Scaffold(), maintainState: null, name: null),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetRoute fullscreenDialog null",
    (WidgetTester testr) async {
      expect(
          () => GetPage(
              page: () => Scaffold(), fullscreenDialog: null, name: '/'),
          throwsAssertionError);
    },
  );
}

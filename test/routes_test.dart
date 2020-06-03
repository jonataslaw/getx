import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/src/routes/get_route.dart';

void main() {
  testWidgets(
    "GetRoute page null",
    (WidgetTester testr) async {
      expect(() => GetRoute(page: null), throwsAssertionError);
    },
  );

  testWidgets(
    "GetRoute maintainState null",
    (WidgetTester testr) async {
      expect(() => GetRoute(page: Scaffold(), maintainState: null),
          throwsAssertionError);
    },
  );

  testWidgets(
    "GetRoute fullscreenDialog null",
    (WidgetTester testr) async {
      expect(() => GetRoute(page: Scaffold(), fullscreenDialog: null),
          throwsAssertionError);
    },
  );
}

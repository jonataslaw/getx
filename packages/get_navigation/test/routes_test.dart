import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_navigation/get_navigation.dart';

void main() {
  testWidgets(
    'GetPage page null',
    (tester) async {
      expect(() => GetPage(page: null, name: null), throwsAssertionError);
    },
  );

  testWidgets(
    "GetPage maintainState null",
    (tester) async {
      expect(
        () => GetPage(page: () => Scaffold(), maintainState: null, name: '/'),
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    "GetPage name null",
    (tester) async {
      expect(
        () => GetPage(page: () => Scaffold(), maintainState: null, name: null),
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    "GetPage fullscreenDialog null",
    (tester) async {
      expect(
        () =>
            GetPage(page: () => Scaffold(), fullscreenDialog: null, name: '/'),
        throwsAssertionError,
      );
    },
  );
}

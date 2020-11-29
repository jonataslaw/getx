import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

void main() {
  test('Parse Page with children', () {
    final tree = ParseRouteTree();
    final pageTree = GetPage(name: '/city', page: () => Container(), children: [
      GetPage(name: '/home', page: () => Container(), children: [
        GetPage(name: '/bed-room', page: () => Container()),
        GetPage(name: '/living-room', page: () => Container()),
      ]),
      GetPage(name: '/work', page: () => Container(), children: [
        GetPage(name: '/office', page: () => Container(), children: [
          GetPage(name: '/pen', page: () => Container()),
          GetPage(name: '/paper', page: () => Container()),
        ]),
        GetPage(name: '/meeting-room', page: () => Container()),
      ]),
    ]);

    tree.addRoute(pageTree);
    final searchRoute = '/city/work/office/pen';
    final match = tree.matchRoute(searchRoute);
    expect(match, isNotNull);
    expect(match.route.name, searchRoute);
  });

  test('Parse Page without children', () {
    final tree = ParseRouteTree();
    final pageTree = [
      GetPage(name: '/city', page: () => Container()),
      GetPage(name: '/city/home', page: () => Container()),
      GetPage(name: '/city/home/bed-room', page: () => Container()),
      GetPage(name: '/city/home/living-room', page: () => Container()),
      GetPage(name: '/city/work', page: () => Container()),
      GetPage(name: '/city/work/office', page: () => Container()),
      GetPage(name: '/city/work/office/pen', page: () => Container()),
      GetPage(name: '/city/work/office/paper', page: () => Container()),
      GetPage(name: '/city/work/meeting-room', page: () => Container()),
    ];

    for (var p in pageTree) {
      tree.addRoute(p);
    }

    final searchRoute = '/city/work/office/pen';
    final match = tree.matchRoute(searchRoute);
    expect(match, isNotNull);
    expect(match.route.name, searchRoute);
  });
}

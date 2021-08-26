import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

void main() {
  test('Parse Page with children', () {
    final testParams = {'hi': 'value'};
    final pageTree = GetPage(
      name: '/city',
      page: () => Container(),
      children: [
        GetPage(name: '/home', page: () => Container(), children: [
          GetPage(name: '/bed-room', page: () => Container()),
          GetPage(name: '/living-room', page: () => Container()),
        ]),
        GetPage(
          name: '/work',
          page: () => Container(),
          children: [
            GetPage(
              name: '/office',
              page: () => Container(),
              children: [
                GetPage(
                  name: '/pen',
                  page: () => Container(),
                  parameters: testParams,
                ),
                GetPage(name: '/paper', page: () => Container()),
              ],
            ),
            GetPage(
              name: '/meeting-room',
              page: () => Container(),
            ),
          ],
        ),
      ],
    );

    final tree = ParseRouteTree(routes: <GetPage>[]);

    tree.addRoute(pageTree);

    // tree.addRoute(pageTree);
    final searchRoute = '/city/work/office/pen';
    final match = tree.matchRoute(searchRoute);
    expect(match, isNotNull);
    expect(match.route!.name, searchRoute);
    final testRouteParam = match.route!.parameters!;
    for (final tParam in testParams.entries) {
      expect(testRouteParam[tParam.key], tParam.value);
    }
  });

  test('Parse Page without children', () {
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

    final tree = ParseRouteTree(routes: pageTree);

    // for (var p in pageTree) {
    //   tree.addRoute(p);
    // }

    final searchRoute = '/city/work/office/pen';
    final match = tree.matchRoute(searchRoute);
    expect(match, isNotNull);
    expect(match.route!.name, searchRoute);
  });

  testWidgets(
    'test params from dynamic route',
    (tester) async {
      await tester.pumpWidget(GetMaterialApp(
        initialRoute: '/first/juan',
        getPages: [
          GetPage(page: () => Container(), name: '/first/:name'),
          GetPage(page: () => Container(), name: '/second/:id'),
          GetPage(page: () => Container(), name: '/third'),
          GetPage(page: () => Container(), name: '/last/:id/:name/profile')
        ],
      ));

      expect(Get.parameters['name'], 'juan');

      Get.toNamed('/second/1234');

      await tester.pumpAndSettle();

      expect(Get.parameters['id'], '1234');

      Get.toNamed('/third?name=jonny&job=dev');

      await tester.pumpAndSettle();

      expect(Get.parameters['name'], 'jonny');
      expect(Get.parameters['job'], 'dev');

      Get.toNamed('/last/1234/ana/profile');

      await tester.pumpAndSettle();

      expect(Get.parameters['id'], '1234');
      expect(Get.parameters['name'], 'ana');
    },
  );

  testWidgets(
    'params in url by parameters',
    (tester) async {
      print("Iniciando test");
      await tester.pumpWidget(GetMaterialApp(
        initialRoute: '/first/juan',
        getPages: [
          GetPage(page: () => Container(), name: '/first/:name'),
          GetPage(page: () => Container(), name: '/italy'),
        ],
      ));

      // Get.parameters = ({"varginias": "varginia", "vinis": "viniiss"});
      var parameters = <String, String>{
        "varginias": "varginia",
        "vinis": "viniiss"
      };
      // print("Get.parameters: ${Get.parameters}");
      parameters.addAll({"a": "b", "c": "d"});
      Get.toNamed("/italy", parameters: parameters);

      await tester.pumpAndSettle();
      expect(Get.parameters['varginias'], 'varginia');
      expect(Get.parameters['vinis'], 'viniiss');
      expect(Get.parameters['a'], 'b');
      expect(Get.parameters['c'], 'd');
    },
  );
}

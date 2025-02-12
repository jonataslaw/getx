import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

void main() {
  test('Parse Page with children', () {
    final testParams = {'hi': 'value'};
    final pageTree = GetPage(
      name: '/city',
      page: Container.new,
      children: [
        GetPage(
          name: '/home',
          page: Container.new,
          transition: Transition.rightToLeftWithFade,
          children: [
            GetPage(
              name: '/bed-room',
              transition: Transition.size,
              page: Container.new,
            ),
            GetPage(
              name: '/living-room',
              transition: Transition.topLevel,
              page: Container.new,
            ),
          ],
        ),
        GetPage(
          name: '/work',
          transition: Transition.upToDown,
          page: Container.new,
          children: [
            GetPage(
              name: '/office',
              transition: Transition.zoom,
              page: Container.new,
              children: [
                GetPage(
                  name: '/pen',
                  transition: Transition.cupertino,
                  page: Container.new,
                  parameters: testParams,
                ),
                GetPage(
                  name: '/paper',
                  page: Container.new,
                  transition: Transition.downToUp,
                ),
              ],
            ),
            GetPage(
              name: '/meeting-room',
              transition: Transition.fade,
              page: Container.new,
            ),
          ],
        ),
      ],
    );

    final tree = ParseRouteTree(routes: <GetPage>[]);

    tree.addRoute(pageTree);

    // tree.addRoute(pageTree);
    const searchRoute = '/city/work/office/pen';
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
      GetPage(
          name: '/city', page: Container.new, transition: Transition.cupertino),
      GetPage(
          name: '/city/home',
          page: Container.new,
          transition: Transition.downToUp),
      GetPage(
          name: '/city/home/bed-room',
          page: Container.new,
          transition: Transition.fade),
      GetPage(
          name: '/city/home/living-room',
          page: Container.new,
          transition: Transition.fadeIn),
      GetPage(
          name: '/city/work',
          page: Container.new,
          transition: Transition.leftToRight),
      GetPage(
          name: '/city/work/office',
          page: Container.new,
          transition: Transition.leftToRightWithFade),
      GetPage(
          name: '/city/work/office/pen',
          page: Container.new,
          transition: Transition.native),
      GetPage(
          name: '/city/work/office/paper',
          page: Container.new,
          transition: Transition.noTransition),
      GetPage(
          name: '/city/work/meeting-room',
          page: Container.new,
          transition: Transition.rightToLeft),
    ];

    final tree = ParseRouteTree(routes: pageTree);

    // for (var p in pageTree) {
    //   tree.addRoute(p);
    // }

    const searchRoute = '/city/work/office/pen';
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
          GetPage(page: Container.new, name: '/first/:name'),
          GetPage(page: Container.new, name: '/second/:id'),
          GetPage(page: Container.new, name: '/third'),
          GetPage(page: Container.new, name: '/last/:id/:name/profile')
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
      await tester.pumpWidget(GetMaterialApp(
        initialRoute: '/first/juan',
        getPages: [
          GetPage(page: Container.new, name: '/first/:name'),
          GetPage(page: Container.new, name: '/italy'),
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

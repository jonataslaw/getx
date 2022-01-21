import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'get_main_test.dart';

class RedirectMiddleware extends GetMiddleware {
  // @override
  // RouteSettings redirect(String? route) {
  //   return RouteSettings(name: '/second');
  // }

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return RouteDecoder.fromRoute('/second');
  }
}

void main() {
  testWidgets("Middleware redirect smoke test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Container()),
          GetPage(name: '/first', page: () => FirstScreen(), middlewares: [
            RedirectMiddleware(),
          ]),
          GetPage(name: '/second', page: () => SecondScreen()),
          GetPage(name: '/third', page: () => ThirdScreen()),
        ],
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();
    print(Get.rootController.rootDelegate.currentConfiguration?.route?.name);
    expect(find.byType(SecondScreen), findsOneWidget);
  });
}

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

class RedirectMiddlewareNull extends GetMiddleware {
  // @override
  // RouteSettings redirect(String? route) {
  //   return RouteSettings(name: '/second');
  // }

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return null;
  }
}

void main() {
  testWidgets("Middleware redirect smoke test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Container()),
          GetPage(
              name: '/first',
              page: () => const FirstScreen(),
              middlewares: [
                RedirectMiddleware(),
              ]),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();
    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Middleware redirect null test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Container()),
          GetPage(
              name: '/first',
              page: () => const FirstScreen(),
              middlewares: [
                RedirectMiddlewareNull(),
              ]),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    // await tester.pump();

    Get.toNamed('/first');

    await tester.pumpAndSettle();
    expect(find.byType(FirstScreen), findsOneWidget);
  });
}

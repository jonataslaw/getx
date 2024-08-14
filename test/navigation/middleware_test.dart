import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'get_main_test.dart';

class RedirectMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return RouteDecoder.fromRoute('/second');
  }
}

class RedirectMiddlewareNull extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return null;
  }
}

class RedirectBypassMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return route;
  }
}

void main() {
  testWidgets("Middleware should redirect to second screen", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [
              RedirectMiddleware(),
            ],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    // Ensure that we are redirected to the second screen
    expect(find.byType(SecondScreen), findsOneWidget);
    // Ensure that we are not seeing the first screen
    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Middleware should stop navigation", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [
              RedirectMiddlewareNull(),
            ],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    await tester.pump();

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    // Ensure that we remain on the initial route and do not navigate to the first screen
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Middleware should be bypassed", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [
              RedirectBypassMiddleware(),
            ],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    await tester.pump();

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    // Ensure that the navigation is not redirected and we land on the first screen
    expect(find.byType(FirstScreen), findsOneWidget);
    // Ensure that we do not see the second screen
    expect(find.byType(SecondScreen), findsNothing);
    // Ensure that we do not see the home screen
    expect(find.byType(Home), findsNothing);
  });
}

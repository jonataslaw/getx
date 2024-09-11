import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'get_main_test.dart';

class RedirectMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return RouteDecoder.fromRoute('/second');
  }
}

class Redirect2Middleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    return RouteDecoder.fromRoute('/first');
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
  tearDown(() {
    Get.reset();
  });

  testWidgets("Middleware should redirect to second screen", (tester) async {
    // Test setup
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [RedirectMiddleware()],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    // Act
    Get.toNamed('/first');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SecondScreen), findsOneWidget);
    expect(find.byType(FirstScreen), findsNothing);
    expect(Get.currentRoute, '/second');
  });

  testWidgets("Middleware should stop navigation", (tester) async {
    // Test setup
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [RedirectMiddlewareNull()],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    // Act
    await tester.pumpAndSettle();
    Get.toNamed('/first');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(FirstScreen), findsNothing);
    expect(Get.currentRoute, '/');
  });

  testWidgets("Middleware should be bypassed", (tester) async {
    // Test setup
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [RedirectBypassMiddleware()],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
        ],
      ),
    );

    // Act
    await tester.pumpAndSettle();
    Get.toNamed('/first');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(FirstScreen), findsOneWidget);
    expect(find.byType(SecondScreen), findsNothing);
    expect(find.byType(Home), findsNothing);
    expect(Get.currentRoute, '/first');
  });

  testWidgets("Middleware should redirect twice", (tester) async {
    // Test setup
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [RedirectMiddleware()],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
          GetPage(name: '/third', page: () => const ThirdScreen()),
          GetPage(
            name: '/fourth',
            page: () => const FourthScreen(),
            middlewares: [Redirect2Middleware()],
          ),
        ],
      ),
    );

    // Act
    Get.toNamed('/fourth');
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SecondScreen), findsOneWidget);
    expect(find.byType(FirstScreen), findsNothing);
    expect(Get.currentRoute, '/second');
  });

  testWidgets("Navigation history should be correct after redirects",
      (tester) async {
    // Test setup
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(
            name: '/first',
            page: () => const FirstScreen(),
            middlewares: [RedirectMiddleware()],
          ),
          GetPage(name: '/second', page: () => const SecondScreen()),
        ],
      ),
    );

    // Act
    Get.toNamed('/first');
    await tester.pumpAndSettle();

    // Assert
    expect(Get.currentRoute, '/second');
    expect(Get.previousRoute, '/');

    // Act: go back
    Get.back();
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Home), findsOneWidget);
    expect(Get.currentRoute, '/');
  });
}

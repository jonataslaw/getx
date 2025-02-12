import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'get_main_test.dart';

class RedirectMiddleware extends GetMiddleware {
  @override
  RouteSettings redirect(String? route) => const RouteSettings(name: '/second');
}

void main() {
  testWidgets("Middleware redirect smoke test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: Container.new),
          GetPage(
              name: '/first',
              page: FirstScreen.new,
              middlewares: [RedirectMiddleware()]),
          GetPage(name: '/second', page: SecondScreen.new),
          GetPage(name: '/third', page: ThirdScreen.new),
        ],
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });
}

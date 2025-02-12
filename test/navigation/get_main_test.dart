import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.to navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.toNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("unknowroute", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      unknownRoute: GetPage(name: '/404', page: Scaffold.new),
      getPages: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.toNamed('/secondd');

    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/404');
  });

  testWidgets("Get.off navigates to provided route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));

    Get.off(const SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.off removes current route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));

    Get.off(const SecondScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: FirstScreen.new),
        GetPage(name: '/second', page: SecondScreen.new),
        GetPage(name: '/third', page: ThirdScreen.new),
      ],
    ));

    Get.offNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offNamed removes current route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: FirstScreen.new),
        GetPage(name: '/second', page: SecondScreen.new),
        GetPage(name: '/third', page: ThirdScreen.new),
      ],
    ));

    Get.offNamed('/second');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offNamed removes only current route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: FirstScreen.new),
        GetPage(name: '/second', page: SecondScreen.new),
        GetPage(name: '/third', page: ThirdScreen.new),
      ],
    ));

    Get.toNamed('/second');
    Get.offNamed('/third');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.offAll navigates to provided route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));

    Get.offAll(const SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAll removes all previous routes", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));

    Get.to(const SecondScreen());
    Get.offAll(const ThirdScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);

    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offAllNamed navigates to provided named route",
      (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAllNamed removes all previous routes", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.toNamed('/second');
    Get.offAllNamed('/third');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);

    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offAndToNamed navigates to provided route", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.offAndToNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAndToNamed removes previous route", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.offAndToNamed('/second');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(const FirstScreen());

    Get.offUntil(GetPageRoute(page: ThirdScreen.new),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(const FirstScreen());
    Get.to(const SecondScreen());
    Get.offUntil(GetPageRoute(page: ThirdScreen.new),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(const FirstScreen());
    Get.to(const SecondScreen());
    Get.offUntil(GetPageRoute(page: ThirdScreen.new),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.offNamedUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.offNamedUntil('/second', ModalRoute.withName('/first'));

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offNamedUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third')
      ],
    ));

    Get.toNamed('/second');
    Get.offNamedUntil('/third', ModalRoute.withName('/first'));

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offNamedUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: FirstScreen.new, name: '/first'),
        GetPage(page: SecondScreen.new, name: '/second'),
        GetPage(page: ThirdScreen.new, name: '/third'),
      ],
    ));

    Get.toNamed('/second');
    Get.offNamedUntil('/third', ModalRoute.withName('/first'));
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.back navigates back", (tester) async {
    await tester.pumpWidget(
      const Wrapper(
        defaultTransition: Transition.circularReveal,
        child: FirstScreen(),
      ),
    );

    Get.to(const SecondScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets(
      "Get.back with closeOverlays pops both snackbar and current route",
      (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));

    Get.to(const SecondScreen());
    Get.snackbar('title', "message");
    Get.back(closeOverlays: true);

    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, false);
    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.defaultTransition smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.fadeIn,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.downToUp,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.fade,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.leftToRight,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.leftToRightWithFade,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.rightToLeft,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.rightToLeftWithFade,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.cupertino,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.size,
        child: Container(),
      ),
    );

    Get.to(const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('FirstScreen');
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

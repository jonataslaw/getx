import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.to navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => const FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.toNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("unknowroute", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      unknownRoute: GetPage(name: '/404', page: () => const Scaffold()),
      getPages: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    Get.toNamed('/secondd');

    await tester.pumpAndSettle();

    expect(Get.rootController.rootDelegate.currentConfiguration?.route?.name,
        '/404');
  });

  testWidgets("Get.off navigates to provided route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));
    // await tester.pump();

    Get.off(() => const SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.off removes current route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.off(() => const SecondScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: () => const FirstScreen()),
        GetPage(name: '/second', page: () => const SecondScreen()),
        GetPage(name: '/third', page: () => const ThirdScreen()),
      ],
    ));

    await tester.pump();

    Get.offNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offNamed removes current route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: () => const FirstScreen()),
        GetPage(name: '/second', page: () => const SecondScreen()),
        GetPage(name: '/third', page: () => const ThirdScreen()),
      ],
    ));

    await tester.pump();

    Get.offNamed('/second');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offNamed removes only current route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: () => const FirstScreen()),
        GetPage(name: '/second', page: () => const SecondScreen()),
        GetPage(name: '/third', page: () => const ThirdScreen()),
      ],
    ));

    // await tester.pump();

    Get.toNamed('/second');
    await tester.pumpAndSettle();
    Get.offNamed('/third');
    await tester.pumpAndSettle();
    Get.back();
    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets("Get.offAll navigates to provided route", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.offAll(() => const SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAll removes all previous routes", (tester) async {
    await tester.pumpWidget(const Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.to(() => const SecondScreen());
    await tester.pumpAndSettle();
    Get.offAll(() => const ThirdScreen());
    await tester.pumpAndSettle();
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
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    await tester.pump();

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAllNamed removes all previous routes", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    await tester.pump();

    Get.toNamed('/second');
    await tester.pumpAndSettle();
    Get.offAllNamed('/third');
    await tester.pumpAndSettle();
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
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
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
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    Get.offAndToNamed('/second');

    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => const FirstScreen());

    await tester.pumpAndSettle();

    Get.offUntil(
        () => const ThirdScreen(), (route) => route.name == '/FirstScreen');

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => const FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => const SecondScreen());
    await tester.pumpAndSettle();
    Get.offUntil(
        () => const ThirdScreen(), (route) => route.name == '/FirstScreen');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => const FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => const SecondScreen());
    await tester.pumpAndSettle();
    Get.offUntil(
        () => const ThirdScreen(), (route) => route.name == '/FirstScreen');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.offNamedUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    Get.offNamedUntil('/second', (route) => route.name == '/first');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offNamedUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third')
      ],
    ));

    Get.toNamed('/second');
    await tester.pumpAndSettle();
    Get.offNamedUntil('/third', (route) => route.name == '/first');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offNamedUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: () => const FirstScreen(), name: '/first'),
        GetPage(page: () => const SecondScreen(), name: '/second'),
        GetPage(page: () => const ThirdScreen(), name: '/third'),
      ],
    ));

    Get.toNamed('/second');
    await tester.pumpAndSettle();
    Get.offNamedUntil('/third', (route) => route.name == '/first');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.back navigates back", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.circularReveal,
        child: Container(),
      ),
    );

    // await tester.pump();

    Get.to(() => const FirstScreen());
    await tester.pumpAndSettle();

    Get.to(() => const SecondScreen());
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets(
      "Get.back with closeOverlays pops both snackbar and current route",
      (tester) async {
    await tester.pumpWidget(
      Wrapper(
        defaultTransition: Transition.circularReveal,
        child: Container(),
      ),
    );

    // await tester.pump();

    Get.to(() => const FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => const SecondScreen());
    await tester.pumpAndSettle();
    Get.snackbar('title', "message");
    await tester.pumpAndSettle();
    Get.backLegacy(closeOverlays: true);

    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, false);

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  group("Get.defaultTransition smoke test", () {
    testWidgets("fadeIn", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.fadeIn,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("downToUp", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.downToUp,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("fade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.fade,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRight", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.leftToRight,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRightWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.leftToRightWithFade,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRightWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.rightToLeft,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("defaultTransition", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.rightToLeft,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("rightToLeftWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.rightToLeftWithFade,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("cupertino", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.cupertino,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("size", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          defaultTransition: Transition.size,
          child: Container(),
        ),
      );

      Get.to(() => const FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });
  });
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(child: const Text('FirstScreen'));
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

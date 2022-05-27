import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.to navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.toNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
      ],
    ));

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("unknowroute", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      unknownRoute: GetPage(name: '/404', page: () => Scaffold()),
      getPages: [
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
      ],
    ));

    Get.toNamed('/secondd');

    await tester.pumpAndSettle();

    expect(
        GetMaterialController.to.rootDelegate.currentConfiguration?.route?.name,
        '/404');
  });

  testWidgets("Get.off navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));
    // await tester.pump();

    Get.off(() => SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.off removes current route", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.off(() => SecondScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offNamed navigates to provided named route", (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/first',
      getPages: [
        GetPage(name: '/first', page: () => FirstScreen()),
        GetPage(name: '/second', page: () => SecondScreen()),
        GetPage(name: '/third', page: () => ThirdScreen()),
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
        GetPage(name: '/first', page: () => FirstScreen()),
        GetPage(name: '/second', page: () => SecondScreen()),
        GetPage(name: '/third', page: () => ThirdScreen()),
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
        GetPage(name: '/first', page: () => FirstScreen()),
        GetPage(name: '/second', page: () => SecondScreen()),
        GetPage(name: '/third', page: () => ThirdScreen()),
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
    await tester.pumpWidget(Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.offAll(() => SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAll removes all previous routes", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));
    await tester.pump();

    Get.to(() => SecondScreen());
    await tester.pumpAndSettle();
    Get.offAll(() => ThirdScreen());
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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

    Get.to(() => FirstScreen());

    await tester.pumpAndSettle();

    Get.offUntil(() => ThirdScreen(), (route) => route.name == '/FirstScreen');

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => SecondScreen());
    await tester.pumpAndSettle();
    Get.offUntil(() => ThirdScreen(), (route) => route.name == '/FirstScreen');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(() => FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => SecondScreen());
    await tester.pumpAndSettle();
    Get.offUntil(() => ThirdScreen(), (route) => route.name == '/FirstScreen');
    await tester.pumpAndSettle();
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.offNamedUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(WrapperNamed(
      initialRoute: '/first',
      namedRoutes: [
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third'),
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
        child: Container(),
        defaultTransition: Transition.circularReveal,
      ),
    );

    // await tester.pump();

    Get.to(() => FirstScreen());
    await tester.pumpAndSettle();

    Get.to(() => SecondScreen());
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
        child: Container(),
        defaultTransition: Transition.circularReveal,
      ),
    );

    // await tester.pump();

    Get.to(() => FirstScreen());
    await tester.pumpAndSettle();
    Get.to(() => SecondScreen());
    await tester.pumpAndSettle();
    Get.snackbar('title', "message");
    await tester.pumpAndSettle();
    Get.back(closeOverlays: true);

    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, false);

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  group("Get.defaultTransition smoke test", () {
    testWidgets("fadeIn", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.fadeIn,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("downToUp", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.downToUp,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("fade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.fade,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRight", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.leftToRight,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRightWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.leftToRightWithFade,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("leftToRightWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.rightToLeft,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("defaultTransition", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.rightToLeft,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("rightToLeftWithFade", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.rightToLeftWithFade,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("cupertino", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.cupertino,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });

    testWidgets("size", (tester) async {
      await tester.pumpWidget(
        Wrapper(
          child: Container(),
          defaultTransition: Transition.size,
        ),
      );

      Get.to(() => FirstScreen());

      await tester.pumpAndSettle();

      expect(find.byType(FirstScreen), findsOneWidget);
    });
  });
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('FirstScreen'));
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

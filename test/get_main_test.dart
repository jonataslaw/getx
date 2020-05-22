import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'util/wrapper.dart';

void main() {
  testWidgets("Get.to smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.to(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });
  testWidgets("Get.toNamed smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        initialRoute: '/',
        namedRoutes: {
          '/': GetRoute(page: FirstScreen()),
          '/second': GetRoute(page: SecondScreen()),
          '/third': GetRoute(page: ThirdScreen())
        },
        child: Container(),
      ),
    );

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.off smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.off(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offNamed smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        initialRoute: '/',
        namedRoutes: {
          '/': GetRoute(page: Container()),
          '/first': GetRoute(page: FirstScreen()),
          '/second': GetRoute(page: SecondScreen()),
          '/third': GetRoute(page: ThirdScreen())
        },
        child: Container(),
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.offNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAll smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.to(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);

    Get.offAll(ThirdScreen());

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets("Get.offAllNamed smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        initialRoute: '/',
        namedRoutes: {
          '/': GetRoute(page: Container()),
          '/first': GetRoute(page: FirstScreen()),
          '/second': GetRoute(page: SecondScreen()),
          '/third': GetRoute(page: ThirdScreen())
        },
        child: Container(),
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.toNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);

    Get.offAllNamed('/third');

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets("Get.offAndToNamed smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        initialRoute: '/',
        namedRoutes: {
          '/': GetRoute(page: Container()),
          '/first': GetRoute(page: FirstScreen()),
          '/second': GetRoute(page: SecondScreen()),
          '/third': GetRoute(page: ThirdScreen())
        },
        child: Container(),
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.offAndToNamed('/second');

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offUntil smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        child: Container(),
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.offUntil(
        MaterialPageRoute(builder: (BuildContext context) => SecondScreen()),
        ModalRoute.withName('/'));

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offNamedUntil smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        initialRoute: '/',
        namedRoutes: {
          '/': GetRoute(page: Container()),
          '/first': GetRoute(page: FirstScreen()),
          '/second': GetRoute(page: SecondScreen()),
          '/third': GetRoute(page: ThirdScreen())
        },
        child: Container(),
      ),
    );

    Get.toNamed('/first');

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.offNamedUntil('/first', ModalRoute.withName('/'));

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.back smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(child: Container()),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    Get.to(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);

    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.defaultTransition smoke test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.cupertino,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.downToUp,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.fade,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.leftToRight,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.leftToRightWithFade,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.rightToLeft,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);

    await tester.pumpWidget(
      Wrapper(
        child: Container(),
        defaultTransition: Transition.rightToLeftWithFade,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

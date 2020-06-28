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
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(page: () => FirstScreen(), name: '/'),
          GetPage(page: () => SecondScreen(), name: '/second'),
          GetPage(page: () => ThirdScreen(), name: '/third'),
        ],
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
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Container()),
          GetPage(name: '/first', page: () => FirstScreen()),
          GetPage(name: '/second', page: () => SecondScreen()),
          GetPage(name: '/third', page: () => ThirdScreen()),
        ],
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
      WrapperNamed(
        initialRoute: '/',
        namedRoutes: [
          GetPage(page: () => Container(), name: '/'),
          GetPage(page: () => FirstScreen(), name: '/first'),
          GetPage(page: () => SecondScreen(), name: '/second'),
          GetPage(page: () => ThirdScreen(), name: '/third'),
        ],
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
      WrapperNamed(
        initialRoute: '/',
        namedRoutes: [
          GetPage(page: () => Container(), name: '/'),
          GetPage(page: () => FirstScreen(), name: '/first'),
          GetPage(page: () => SecondScreen(), name: '/second'),
          GetPage(page: () => ThirdScreen(), name: '/third'),
        ],
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
      WrapperNamed(
        initialRoute: '/',
        namedRoutes: [
          GetPage(page: () => Container(), name: '/'),
          GetPage(page: () => FirstScreen(), name: '/first'),
          GetPage(page: () => SecondScreen(), name: '/second'),
          GetPage(page: () => ThirdScreen(), name: '/third'),
        ],
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
        defaultTransition: Transition.fadeIn,
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

  testWidgets("Get.snackbar test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        child: RaisedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.snackbar('title', "message",
                duration: Duration(seconds: 1), instantInit: true);
          },
        ),
      ),
    );

    expect(Get.isSnackbarOpen, false);
    await tester.tap(find.text('Open Snackbar'));

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets("Get.rawSnackbar test", (tester) async {
    await tester.pumpWidget(
      Wrapper(
        child: RaisedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.rawSnackbar(
                title: 'title',
                message: "message",
                duration: Duration(seconds: 1),
                instantInit: true);
          },
        ),
      ),
    );

    expect(Get.isSnackbarOpen, false);
    await tester.tap(find.text('Open Snackbar'));

    expect(Get.isSnackbarOpen, true);
    await tester.pump(const Duration(seconds: 1));
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

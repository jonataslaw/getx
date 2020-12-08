import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'utils/wrapper.dart';

void main() {
  testWidgets("Get.to navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(FirstScreen());

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

  testWidgets("Get.off navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));

    Get.off(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.off removes current route", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));

    Get.off(SecondScreen());
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

    Get.offNamed('/second');
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

    Get.toNamed('/second');
    Get.offNamed('/third');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.offAll navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));

    Get.offAll(SecondScreen());

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsOneWidget);
  });

  testWidgets("Get.offAll removes all previous routes", (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));

    Get.to(SecondScreen());
    Get.offAll(ThirdScreen());
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
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsNothing);
  });

  testWidgets("Get.offUntil navigates to provided route", (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(FirstScreen());

    Get.offUntil(GetPageRoute(page: () => ThirdScreen()),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');

    await tester.pumpAndSettle();

    expect(find.byType(ThirdScreen), findsOneWidget);
  });

  testWidgets(
      "Get.offUntil removes previous routes if they don't match predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(FirstScreen());
    Get.to(SecondScreen());
    Get.offUntil(GetPageRoute(page: () => ThirdScreen()),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(SecondScreen), findsNothing);
  });

  testWidgets(
      "Get.offUntil leaves previous routes that match provided predicate",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: Container()));

    Get.to(FirstScreen());
    Get.to(SecondScreen());
    Get.offUntil(GetPageRoute(page: () => ThirdScreen()),
        (route) => (route as GetPageRoute).routeName == '/FirstScreen');
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third')
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
        GetPage(page: () => FirstScreen(), name: '/first'),
        GetPage(page: () => SecondScreen(), name: '/second'),
        GetPage(page: () => ThirdScreen(), name: '/third'),
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
      Wrapper(child: FirstScreen()),
    );

    Get.to(SecondScreen());
    Get.back();

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets(
      "Get.back with closeOverlays pops both snackbar and current route",
      (tester) async {
    await tester.pumpWidget(Wrapper(child: FirstScreen()));

    Get.to(SecondScreen());
    Get.snackbar('title', "message");
    Get.back(closeOverlays: true);

    await tester.pumpAndSettle();

    expect(Get.isSnackbarOpen, false);
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
        defaultTransition: Transition.size,
      ),
    );

    Get.to(FirstScreen());

    await tester.pumpAndSettle();

    expect(find.byType(FirstScreen), findsOneWidget);
  });

  testWidgets("Get.snackbar test", (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: true,
        home: RaisedButton(
          child: Text('Open Snackbar'),
          onPressed: () {
            Get.snackbar('title', "message", duration: Duration(seconds: 1));
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
              onTap: (_) {
                print('snackbar tapped');
              },
              duration: Duration(seconds: 1),
              shouldIconPulse: true,
              icon: Icon(Icons.alarm),
              showProgressIndicator: true,
              barBlur: null,
              isDismissible: true,
              leftBarIndicatorColor: Colors.amber,
              overlayBlur: 1.0,
            );
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
    return Container(child: Text('FirstScreen'));
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

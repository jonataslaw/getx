import 'package:flutter/material.dart';
import 'package:get_navigation/get_navigation.dart';

class Wrapper extends StatelessWidget {
  final Widget child;
  final List<GetPage> namedRoutes;
  final String initialRoute;
  final Transition defaultTransition;

  const Wrapper({
    Key key,
    this.child,
    this.namedRoutes,
    this.initialRoute,
    this.defaultTransition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: defaultTransition,
      initialRoute: initialRoute,
      getPages: namedRoutes,
      home: Scaffold(
        body: child,
      ),
    );
  }
}

class WrapperNamed extends StatelessWidget {
  final Widget child;
  final List<GetPage> namedRoutes;
  final String initialRoute;
  final Transition defaultTransition;

  const WrapperNamed({
    Key key,
    this.child,
    this.namedRoutes,
    this.initialRoute,
    this.defaultTransition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: defaultTransition,
      initialRoute: initialRoute,
      getPages: namedRoutes,
    );
  }
}

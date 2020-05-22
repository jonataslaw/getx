import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatelessWidget {
  final Widget child;
  final Map<String, GetRoute> namedRoutes;
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
      namedRoutes: namedRoutes,
      home: Scaffold(
        body: child,
      ),
    );
  }
}

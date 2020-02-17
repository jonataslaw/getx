import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    navigatorKey: Get.key,
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.to(SecondRoute());
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return GetRoute(
          page: SplashScreen(),
          settings: settings,
        );
      case '/Home':
        return GetRoute(settings: settings, page: Home(), transition: Transition.fade);
      case '/Chat':
        return GetRoute(settings: settings, page: Chat(), transition: Transition.rightToLeft);
      default:
        return GetRoute(
            settings: settings,
            transition: Transition.fade,
            page: Scaffold(
              body: Center(child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Splash Screen"));
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Home Page"));
  }
}

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Chat"));
  }
}

# Get

A consistent Flutter route navigation library that does not rebuild materialApp with each navigation.

## Getting Started

Flutter's conventional navigation method has a route reconstruction bug that makes it inconsistent 
for large applications with undefined routes.
Get came to solve this problem.

Plus, get makes navigation much clearer and more concise for beginners. The nomenclatures u
sed by Flutter routes often confuse those who start with the framework.
Get is friendly to those who came from Web programming, and those who never programmed, 
with a clearer navigation system.

## How to use?

To navigate to a new screen:

```dart
Get.to(context, NextScreen());
```

To return to previous screen

```dart
Get.back(context);
```

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens and etc.)

```dart
Get.off(context, NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(context, NextScreen());
```

Is possible used default namedRoutes from flutter?
Yes, and with no navigation bug
Example:

```dart
void main() {
  runApp(MaterialApp(
    onGenerateRoute: Router.generateRoute,
    initialRoute: "/",
    title: 'Navigation',
  ));
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return GetRoute(builder: (_) => FirstRoute());
      case '/second':
        return GetRoute(builder: (_) => SecondRoute());
      default:
        return GetRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
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
            Navigator.pushNamed(context, "/second");
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
            Get.back(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```
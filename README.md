# Get

A consistent Flutter route navigation library that navigate with no context and not rebuild materialApp with each navigation.

## Getting Started

Flutter's conventional navigation method has a route reconstruction bug that makes it inconsistent 
for large applications with undefined routes.
Get came to solve this problem.
In addition, Get needs no context, also solving Flutter's biggest problem with patterns like BLoC. 
Get also makes navigation much clearer and more concise for beginners and friendly to those who came from Web programming.

## How to use?

Add this to your package's pubspec.yaml file:

```
dependencies:
  get: ^1.3.2
```
  
And import it:
```dart
import 'package:get/get.dart';
```
Add GetKey to your MaterialApp and enjoy:
```dart
MaterialApp(
    navigatorKey: Get.key,
    home: MyHome(),
  )
```
To navigate to a new screen:

```dart
Get.to(NextScreen());
```

To return to previous screen

```dart
Get.back();
```

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens and etc.)

```dart
Get.off(NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(NextScreen(), (route) => false));
```

### That's it, you've learned how to navigate between routes the default way.

However, for people who like more organized code who want to navigate with named routes, or for Flutter_web Developers who want the url to show exactly which route is being shown, and want the page refresh not to affect the state of the routes. On your site, we give you a much more elegant and functional solution. Yeah, the default navigation doesn't fully support Flutter_web, but Get does !!!!

## So... Is possible used default namedRoutes from flutter?
- Yes, and with no navigation bug, add "named" to Get. HOWEVER, TO MAKE THIS TYPE OF NAVIGATION, USE THE ROUTE MODEL FROM REPOSITORY. 
Example of navigation with named routes:

To navigate to nextScreen
```dart
Get.toNamed("/NextScreen");
```
To navigate and remove the previous screen from the tree.
```dart
Get.offNamed("/NextScreen");
```
To navigate and remove all previous screens from the tree.
```dart
Get.offAllNamed("/NextScreen", (route) => false));
```

## Using with Named Routes and And offering full flutter_web support (REQUIRED FOR NAMED ROUTES):

### Add " navigatorKey: Get.key," to MaterialApp

```dart
void main() {
  runApp(MaterialApp(
    onGenerateRoute: Router.generateRoute,
    initialRoute: "/",
    navigatorKey: Get.key,
    title: 'Navigation',
  ));
}
```

### Important!!! COPY THE ROUTER CLASS BELOW:
Copy this Router class below and put it in your app, rename routes and classes for your own, add more classes to it if necessary.

We suggest that you copy this class for 3 reasons:
1- You must define an escape route if you accidentally set a wrong route. This example already contains this.

2- Flutter_Web does not provide friendly urls(no matter how you set the route, it will always return to the main page after the page is reloaded and the route is not displayed in the url with default navigation), but Get supports it! So, when a user enters yourflutterwebsite.com/support and exactly the support route is displayed, you need to pass the settings parameter to GetRoute, and this example already contemplates it!

3- These routes are designed to work with GetRoute, not CupertinoPageRoute or MaterialPageRoute. Never put them here.

```dart
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return GetRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      case '/Home':
        return GetRoute(settings: settings, builder: (_) => Home());
      case '/Chat':
        return GetRoute(settings: settings, builder: (_) => Chat());
      default:
        return GetRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
```
And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (BLoC will love it), and when your app is compiled to the web, your routes will appear in the url beautifully <3

```dart
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
            Get.toNamed("/second");
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
```

That is all.

# Get

A consistent navigation library that lets you navigate between screens, open dialogs/bottomSheets, and display snackbars from anywhere in your code without context.
## Getting Started

Flutter's conventional navigation has a lot of unnecessary boilerplate, requires context to navigate between screens, open dialogs, and snacking is really painful.
In addition, with each route navigation, all of your screens below MaterialApp are rebuilt, often causing RAM and CPU bottlenecks. 
I worked on a pull to fix it in the framework, and seeing how things work I realized that a lot of cliche code could be avoided to get clean and concise code. 
With that in mind, I created this library that will change the way you work with the Framework and save your life from cliche code, 
increasing your productivity, and eliminating all the bugs present in Flutter's default navigation altogether.

## How to use?

Add this to your package's pubspec.yaml file:

```
dependencies:
  get: ^1.7.4
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
### Navigating without named routes
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
Get.offAll(NextScreen(), (route) => false);
```

To navigate to the next route, and receive or update data as soon as you return from it:
```dart
var data = await Get.to(Payment());
```
on other screen, send a data for previous route:

```dart
Get.back(result: 'sucess');
```
And use it:

ex:
```dart
if(data == 'sucess') madeAnything();
```
### Others methods (docs will be added soon):
Get.removeRoute // remove one route. 
Get.until // back repeatedly until the predicate returns true.
Get.offUntil // go to next route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil // go to next named route and remove all the previous routes until the predicate returns true.

### SnackBars
To show a modern snackbar:
```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```
To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold, 
but with Get, all you have to do is call your Get.snackbar from anywhere in your code or customize it however you want with GetBar!

```dart
  GetBar(
              title: "Hey i'm a Get SnackBar!",
              message:
                  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!",
              icon: Icon(Icons.alarm),
              shouldIconPulse: true,
              onTap:(){},
              barBlur: 20,
              isDismissible: true,
              duration: Duration(seconds: 3),
            )..show();
```
### Dialogs

To open dialog:

```dart
Get.dialog(YourDialogWidget());
```

To open default dialog:

```dart
 Get.defaultDialog(
                title: "My Title",
                content: Text("Hi, it's my dialog"),
                confirm: FlatButton(
                  child: Text("Ok"),
                  onPressed: () => print("OK pressed"),
                ),
                cancel: FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Get.back(),
                ));
```

### BottomSheets
Get.bottomSheet is like showModalBottomSheet, but don't need of context.

```dart
Get.bottomSheet(
      builder: (_){
          return Container(
            child: Wrap(
            children: <Widget>[
            ListTile(
            leading: Icon(Icons.music_note),
            title: Text('Music'),
            onTap: () => {}          
          ),
            ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Video'),
            onTap: () => {},          
          ),
            ],
          ),
       );
      }
    );
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
Get.offAllNamed("/NextScreen", (route) => false);
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
        return GetRoute(settings: settings, builder: (_) => Home(), transition: Transition.fade);
      case '/Chat':
        return GetRoute(settings: settings, builder: (_) => Chat(),transition: Transition.rightToLeft);
      default:
        return GetRoute(
            settings: settings,
            transition: Transition.rotate
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
        leading: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    GetBar(
                      title: "Hey i'm a Get SnackBar!",
                      message:
                          "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!",
                      duration: Duration(seconds: 3),
                    )..show();
                  },
                ),
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

# Get

A consistent navigation library that lets you navigate between screens, open dialogs/bottomSheets, and display snackbars from anywhere in your code without context.
## Getting Started

Flutter's conventional navigation has a lot of unnecessary boilerplate, requires context to navigate between screens, open dialogs, and use snackbars on framework is really painful.
In addition, with each route navigation, all of your screens below MaterialApp are rebuilt, often causing RAM and CPU bottlenecks. 
I worked on a pull to fix it in the framework, and seeing how things work I realized that a lot of cliche code could be avoided to get clean and concise code. 
With that in mind, I created this library that will change the way you work with the Framework and save your life from cliche code, 
increasing your productivity, and eliminating all the bugs present in Flutter's default navigation altogether.

## How to use?

Add this to your package's pubspec.yaml file:

```
dependencies:
  get: ^1.9.2
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


### SnackBars
To show a modern snackbar:
```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```
To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold, 
but with Get, all you have to do is call your Get.snackbar from anywhere in your code or customize it however you want!

```dart
  Get.snackbar(
               "Hey i'm a Get SnackBar!", // title
               "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
              icon: Icon(Icons.alarm), 
              shouldIconPulse: true,
              onTap:(){},
              barBlur: 20,
              isDismissible: true,
              duration: Duration(seconds: 3),
            );

  ////////// ALL FEATURES //////////
  //     Color colorText,
  //     Duration duration,
  //     SnackPosition snackPosition,
  //     Widget titleText,
  //     Widget messageText,
  //     Widget icon,
  //     bool shouldIconPulse,
  //     double maxWidth,
  //     EdgeInsets margin,
  //     EdgeInsets padding,
  //     double borderRadius,
  //     Color borderColor,
  //     double borderWidth,
  //     Color backgroundColor,
  //     Color leftBarIndicatorColor,
  //     List<BoxShadow> boxShadows,
  //     Gradient backgroundGradient,
  //     FlatButton mainButton,
  //     OnTap onTap,
  //     bool isDismissible,
  //     bool showProgressIndicator,
  //     AnimationController progressIndicatorController,
  //     Color progressIndicatorBackgroundColor,
  //     Animation<Color> progressIndicatorValueColor,
  //     SnackStyle snackStyle,
  //     Curve forwardAnimationCurve,
  //     Curve reverseAnimationCurve,
  //     Duration animationDuration,
  //     double barBlur,
  //     double overlayBlur,
  //     Color overlayColor,
  //     Form userInputForm
  ///////////////////////////////////
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
#### Middleware 
If you want to hear Get events to trigger actions, you can add a GetObserver to your materialApp. This is extremely useful for triggering events whenever a specific Screen is displayed on the screen. Currently on Flutter you would have to put the event on initState and wait for a possible response in a navigator.pop (context); to get that. But with Get, this is extremely simple!

##### add GetObserver();
```dart
void main() {
  runApp(MaterialApp(
    onGenerateRoute: Router.generateRoute,
    initialRoute: "/",
    navigatorKey: Get.key,
    navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
    ],
  ));
}
```
Create a MiddleWare class

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen. 
    ///If you need to enter any of these 3 events directly here, 
    ///you must specify that the event is != Than you are trying to do.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```



### COPY THE ROUTER CLASS BELOW:
Copy this Router class below and put it in your app, rename routes and classes for your own, add more classes to it if necessary.
#### Important!!! 
GetRoute has great performance optimizations that MaterialPageRoute and CupertinoPageRoute do not. It solves the main problems with memory leaks and unexpected reconstructions of the Flutter, so please do not insert MaterialPageRoute or CupertinoPageRoute here, or you will lose one of the main benefits of this lib, in addition to experiencing inconsistencies in the transitions. We recommend always using GetRoute, and if you need custom transitions, use PageRouteBuilder by adding the parameter 'opaque = false' to maintain compatibility with the library.

```dart
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return GetRoute(
          page: First(),
          settings: settings,
        );
      case '/second':
        return GetRoute(
            settings: settings, page: Second(), transition: Transition.fade);
      case '/third':
        return GetRoute(
            settings: settings,
            page: Third(),
            transition: Transition.rightToLeft);
      default:
        return GetRoute(
            settings: settings,
            transition: Transition.fade,
            page: Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}
```
And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (BLoC will love it), and when your app is compiled to the web, your routes will appear in the url beautifully <3

```dart
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
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

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('second Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/third");
          },
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
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

### Others methods (docs will be added soon):

```dart
Get.removeRoute() // remove one route.

Get.until() // back repeatedly until the predicate returns true.

Get.offUntil() // go to next route and remove all the previous routes until the predicate returns true.

Get.offNamedUntil() // go to next named route and remove all the previous routes until the predicate returns true.
```

That is all.

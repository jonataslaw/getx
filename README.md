# Get

A consistent navigation library that lets you navigate between screens, open dialogs/bottomSheets, and display snackbars from anywhere in your code without context.
## Getting Started

Flutter's conventional navigation has a lot of unnecessary boilerplate, requires context to navigate between screens, open dialogs, and use snackbars on framework is really painful.
In addition, when a route is pushed, the entire MaterialApp can be rebuilt causing freezes, this does not happen with Get.
This library that will change the way you work with the Framework and save your life from cliche code, increasing your productivity, and eliminating the rebuild bugs of your application.

```dart
// Default Flutter navigator
Navigator.of(context).push(
        context,
        MaterialPageRoute(
           builder: (BuildContext context) { 
            return HomePage();
          },
        ),
      );

// Get sintax 
Get.to(Home());
```

##### If you use master/dev/beta branch of Flutter, use the version 1.20.0-dev.
* If you use MODULAR, add on your MaterialApp this: navigatorKey: Get.addKey(Modular.navigatorKey)

## How to use?

Add this to your package's pubspec.yaml file:

```
dependencies:
  get: ^1.17.0 // ^1.20.0-dev on beta/dev/master
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
Get.offAll(NextScreen());
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

Don't you want to learn our syntax?
Just change the Navigator (uppercase) to navigator (lowercase), and you will have all the functions of the standard navigation, without having to use context
Example:

```dart

// Default Flutter navigator
Navigator.of(context).push(
        context,
        MaterialPageRoute(
           builder: (BuildContext context) { 
            return HomePage();
          },
        ),
      );

// Get using Flutter syntax without needing context
navigator.push(
        MaterialPageRoute(
           builder: (_) { 
            return HomePage();
          },
        ),
      );

// Get sintax (It is much better, but you have the right to disagree)
Get.to(HomePage());


```

### SnackBars

To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold, 
```dart
final snackBar = SnackBar(
      content: Text('Hi!'),
      action: SnackBarAction(
              label: 'I am a old and ugly snackbar :(',
              onPressed: (){}
            ),
          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
```

With Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

With Get, all you have to do is call your Get.snackbar from anywhere in your code or customize it however you want!

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
If you prefer the traditional snackbar, or want to customize it from scratch, including adding just one line (Get.snackbar makes use of a mandatory title and message), you can use 
`GetBar().show();` which provides the RAW API on which Get.snackbar was built.

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
### Global configurations
You can create Global settings for Get. Just add Get.config to your code before pushing any route

```dart
Get.config(
      enableLog = true,
      defaultPopGesture = true,
      defaultTransition = Transitions.cupertino}
```

## Simple Instance Manager
Are you already using Get and want to make your project as lean as possible? Now Get has a simple manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code.


```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

```dart
controller.fetchApi();// Rather Controller controller = Controller();
```

Imagine that you have navigated through numerous routes, and you need a data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "search" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find(Controller());
```
And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

## Navigate with named routes:
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
Get.offAllNamed("/NextScreen");
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
If you want listen Get events to trigger actions, you can add a GetObserver to your materialApp. This is extremely useful for triggering events whenever a specific Screen is displayed on the screen. Currently on Flutter you would have to put the event on initState and wait for a possible response in a navigator.pop (context); to get that. But with Get, this is extremely simple!

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
            popGesture: true,
            transition: Transition.cupertino);
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

And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (you can call your routes directly from your BLoC or Controller class), and when your app is compiled to the web, your routes will appear in the url beautifully <3

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


### Advanced APIs
Each day Get gets further away from the standard Framework, and provides a wider range of features that are unthinkable to be executed using the standard Flutter.
With Get 1.17.0 a range of new APIs was launched, which allow access from arguments of a named route to whether there is a snackbar or dialog open at that moment, or which screen is being displayed.
This is a big step towards completely detaching the Flutter navigation from InheritedWidgets. Using context to access an InheritedWidget to access a simple navigation feature is one of the only boring things to do in this incredible framework, and now Get has solved this problem, it has become omniscient, and you will have access to basically any tool Flutter which is only available within the widget tree using it.

All APIs available here are in beta stage, so if you find any errors here, open an issue or offer a PR.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()], // ADD THIS !!!!
    );
```

You will also be able to use your own Middleware within GetObserver, this will not influence anything.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver(MiddleWare.observer)], // Here
    );
```

```dart
Get.arguments // give the current args from currentScreen

Get.previousArguments // give arguments of previous route

Get.previousRoute // give name of previous route

Get.rawRoute // give the raw route to access for example, rawRoute.isFirst()

Get.routing // give access to Rounting API from GetObserver

Get.isSnackbarOpen // check if snackbar is open

Get.isDialogOpen // check if dialog is open

Get.isBottomSheetOpen // check if bottomsheet is open


```
### Nested Navigators

Get made Flutter's nested navigation even easier.
You don't need the context, and you will find your navigation stack by Id.

See how simple it is:
```dart
             Navigator(
                key: nestedKey(1), // create a key by index
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  if (settings.name == '/') {
                    return GetRoute(
                      page: Scaffold(
                        appBar: AppBar(
                          title: Text("Main"),
                        ),
                        body: Center(
                          child: FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                Get.toNamed('/second', 1); // navigate by your nested route by index
                              },
                              child: Text("Go to second")),
                        ),
                      ),
                    );
                  } else if (settings.name == '/second') {
                    return GetRoute(
                      page: Center(
                        child: Scaffold(
                          appBar: AppBar(
                            title: Text("Main"),
                          ),
                          body: Center(
                            child:  Text("second")
                          ),
                        ),
                      ),
                    );
                  }
                }),
```


### Others methods (docs will be added soon):

```dart
Get.removeRoute() // remove one route.

Get.until() // back repeatedly until the predicate returns true.

Get.offUntil() // go to next route and remove all the previous routes until the predicate returns true.

Get.offNamedUntil() // go to next named route and remove all the previous routes until the predicate returns true.

GetPlatform.isAndroid/isIOS/isWeb... //(This method is completely compatible with FlutterWeb, unlike the framework. "Platform.isAndroid")

Get.height / Get.width // Equivalent to the method: MediaQuery.of(context).size.height

Get.context // Gives the context of the screen in the foreground anywhere in your code.


```

This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

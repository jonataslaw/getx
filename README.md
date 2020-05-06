# Get

Get is an extra-light and powerful library for Flutter that will give you superpowers and increase your productivity. Navigate without context, open dialogs, snackbars or bottomsheets from anywhere in your code, Manage states and inject dependencies in an easy and practical way! Get is secure, stable, up-to-date, and offers a huge range of APIs that are not present on default framework.
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

// Get syntax 
Get.to(Home());
```
*Languages: [English](README.md), [Brazilian Portuguese](README.pt-br.md).*
## Getting Started

Flutter's conventional navigation has a lot of unnecessary boilerplate, requires context to navigate between screens, open dialogs, and use snackbars on framework is really boring.
In addition, when a route is pushed, the entire MaterialApp can be rebuilt causing freezes, this does not happen with Get.
This library that will change the way you work with the Framework and save your life from cliche code, increasing your productivity, and eliminating the rebuild bugs of your application.

## How to use?

<!-- - Flutter Master/Dev/Beta: version 2.0.x-dev 
- Flutter Stable branch: version 2.0.x
(look for latest version on pub.dev) -->

Add Get to your pubspec.yaml file 
<!-- according to the version of Flutter you are using. -->
 
Exchange your MaterialApp for GetMaterialApp and enjoy!
```dart
import 'package:get/get.dart';
GetMaterialApp( // Before: MaterialApp(
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

// Get syntax (It is much better, but you have the right to disagree)
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
You can also use Get.generalDialog instead of showGeneralDialog.

For all other Flutter dialog widgets, including cupertinos, you can use Get.overlayContext instead of context, and open it anywhere in your code.
For widgets that don't use Overlay, you can use Get.context.
These two contexts will work in 99% of cases to replace the context of your UI, except for cases where inheritedWidget is used without a navigation context.

### BottomSheets
Get.bottomSheet is like showModalBottomSheet, but don't need of context.

```dart
Get.bottomSheet(
     Container(
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

## Simple State Manager
There are currently several state managers for Flutter. However, most of them involve using ChangeNotifier to update widgets (such as the Provider) and this is a bad and very bad approach to performance of medium or large applications. You can check in the official Flutter documentation that ChangeNotifier should be used with 1 or a maximum of 2 listeners (https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), making it practically unusable for any application medium or large. Other state managers are very good, but they have some weakness. BLoC is very safe and efficient, but it is very complex for beginners, which has kept people from developing with Flutter. MobX is easier than BLoC and reactive, almost perfect, I would say, but you need to use a code generator that for large applications, reduces productivity, you will need to drink a lot of coffees until your code is ready again after a Flutter clean.
Get was created to solve all problems with current state managers in just 95 lines of code. This easy and lightweight state manager, which does not use ChangeNotifier, will meet the need especially for those new to Flutter, and will not cause problems for large applications.

What performance improvements does Get bring?

1- Update only the required widget.

2- Does not use changeNotifier, it is the state manager that uses less memory (close to 0mb).

3- Forget StatefulWidget! With Get you will never need it again (if you need to use it, you are using Get incorrectly). With the other state managers, you will probably have to use a StatefulWidget to get the instance of your Provider, BLoC, MobX Controller, etc. But have you ever stopped to think that your appBar, your scaffold, and most of the widgets that are in your class are stateless? So why save the state of an entire class, if you can only save the state of the Widget that is stateful? Get solves that, too. Create a Stateless class, make everything stateless. If you need to update a single component, wrap it with GetBuilder, and its state will be maintained.

4- Organize your project for real! Controllers must not be in your UI, place your TextEditController, or any controller you use within your Controller class.

5- Do you need to trigger an event to update a widget as soon as it is rendered? GetBuilder has the property "initState", just like StatefulWidget, and you can call events from your controller, directly from it, no more events being placed in your initState.
6- Do you need to trigger an action like closing streams, timers and etc? GetBuilder also has the dispose property, where you can call events as soon as that widget is destroyed.

7- Use streams only if necessary. You can use your StreamControllers inside your controller normally, and use StreamBuilder also normally, but remember, a stream reasonably consumes memory, reactive programming is beautiful, but you shouldn't abuse it. 30 streams open simultaneously can be worse than changeNotifier (and changeNotifier is very bad).

8- Update widgets without spending ram for that. Get stores only the GetBuilder creator ID, and updates that GetBuilder when necessary. The memory consumption of the get ID storage in memory is close to 0 even for thousands of GetBuilders. When you create a new GetBuilder, you are actually sharing the state of GetBuilder that has a creator ID. A new state is not created for each GetBuilder, which saves A LOT OF ram for large applications. Basically your application will be entirely Stateless, and the few Widgets that will be Stateful (within GetBuilder) will have a single state, and therefore updating one will update them all. The state is just one.

9- Get is omniscient and in most cases it knows exactly the time to take a controller out of memory. You should not worry about when to dispose of a controller, Get knows the best time to do this. Example:

- Class a => Class B (has controller X) => Class C (has controller X)

In class A the controller is not yet in memory, because you have not used it yet (Get is lazyLoad). In class B you used the controller, and it entered memory. In class C you used the same controller as in class B, Get will share the state of controller B with controller C, and the same controller is still in memory. If you close screen C and screen B, Get will automatically take controller X out of memory and free up resources, because Class a is not using the controller. If you navigate to B again, controller X will enter memory again, if instead of going to class C, you return to class A again, Get will take the controller out of memory in the same way. If class C didn't use the controller, and you took class B out of memory, no class would be using controller X and likewise it would be disposed of. The only exception that can mess with Get, is if you remove B from the route unexpectedly, and try to use the controller in C. In this case, the creator ID of the controller that was in B was deleted, and Get was programmed to remove it from memory every controller that has no creator ID. If you intend to do this, add the "autoRemove: false" flag to class B's GetBuilder and use adoptID = true; in class C's GetBuilder.

### State manager usage

```dart
// Create controller class and extends GetController
class Controller extends GetController {
  int counter = 0;
  void increment() {
    counter++;
    update(this); // use update(this) to update counter variable on UI when increment be called
  }
}
// On your Stateless/Stateful class, use GetBuilder to update Text when increment be called 
GetBuilder<Controller>(
    init: Controller(), // INIT IT ONLY THE FIRST TIME
    builder: (_) => Text(
              '${_.counter}',
              )),
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```
**Done!**
- You have already learned how to manage states with Get.

### Global State manager

If you navigate many routes and need data that was in your previously used controller, you just need to use GetBuilder Again (with no init):

```dart
class OtherClasse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<Controller>(
          builder: (s) => Text('${s.counter}'),
        ),
      ),
    );
  }

```
If you need to use your controller in many other places, and outside of ReBuilder, just create a get in your controller and have it easily. You can copy this code and just change the name of your controller.

```dart
class Controller extends GetController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.counter();
  /// with no static method: Get.find<Controller>().counter();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other does.
  static Controller get to => Get.find(); // add this line 

  int counter = 0;
  void increment() {
    counter++;
    update(this); 
  }
}
```
And then you can access your controller directly, that way:
```dart
FloatingActionButton(
        onPressed:(){
         Controller.to.increment(), 
        } // This is incredibly simple!
        child: Text("${Controller.to.counter}"),
      ),
```
When you press FloatingActionButton, all widgets that are listening to the 'counter' variable will be updated automatically.

##### Forms of use:

- Recommended usage:

You can use Controller instance directly on GetBuilder value:

```dart
GetBuilder<Controller>(  
    init: Controller(),
    builder: (value) => Text(
              '${value.counter}', //here
              )),
```
You may also need an instance of your controller outside of your GetBuilder, and you can use these approaches to achieve this:

```dart
class Controller extends GetController {
  static Controller get to => Get.find(); 
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
    init: Controller(), // use it only first time on each controller
    builder: (_) => Text(
              '${Controller.to.counter}', //here
              )),
or 

class Controller extends GetController {
 // static Controller get to => Get.find(); // with no static get
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
    init: Controller(), // use it only first time on each controller
    builder: (_) => Text(
              '${Get.find<Controller>().counter}', //here
              )),
```

- Not recommended (because you will need to use StatefulWidget to instantiate your controller), but functional:

```dart

Controller controller = Controller();
[...]
GetBuilder( // you dont need to type on this way
    init: controller, //here
    builder: (_) => Text(
              '${controller.counter}', // here
              )),

```

## Simple Instance Manager
Are you already using Get and want to make your project as lean as possible? Now Get has a simple instance manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code.

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

```dart
controller.fetchApi();// Rather Controller controller = Controller();
```

Imagine that you have navigated through numerous routes, and you need a data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "find" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```
And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

To remove a instance of Get:
```dart
Get.delete(Controller());
```


## Navigate with named routes:
- If you prefer to navigate by namedRoutes, Get also supports this.

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

To define routes, use GetMaterialApp:

```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    namedRoutes: {
      '/': GetRoute(page: MyHomePage()),
      '/second': GetRoute(page: Second()),
      '/third': GetRoute(page: Third(),transition: Transition.cupertino);
    },
  ));
}
```

### Send data to named Routes:

Just send what you want for arguments. Get accepts anything here, whether it is a String, a Map, a List, or even a class instance.
```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```
on your class or controller:

```dart
print(Get.arguments);
//print out: Get is the best
```

#### Dynamic urls links
Get is the first and only package to offer advanced dynamic urls just like on the Web. Web developers have probably already wanted this feature on Flutter, and most likely have seen a package promise this feature and deliver a totally different syntax than a URL would have on web, but Get also solves that.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```
on your controller/bloc/stateful/stateless class:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

You can also receive NamedParameters with Get easily:

```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    namedRoutes: {
      '/': GetRoute(page: MyHomePage()),
      /// Important!  :user is not a new route, it is just a parameter
      /// specification. Do not use '/second/:user' and '/second'
      /// if you need new route to user, use '/second/user/:user' 
      /// if '/second' is a route.
      '/second/:user': GetRoute(page: Second()), // receive ID
      '/third': GetRoute(page: Third(),transition: Transition.cupertino);
    },
  ));
}
```
Send data on route name
```dart
Get.toNamed("/second/34954");
```

On second screen take the data by parameter

```dart
print(Get.parameters['user']);
// out: 34954
```

And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (you can call your routes directly from your BLoC or Controller class), and when your app is compiled to the web, your routes will appear in the url <3


#### Middleware 
If you want listen Get events to trigger actions, you can to use routingCallback to it
```dart
GetMaterialApp(
  routingCallback: (route){
    if(routing.current == '/second'){
      openAds();
    }
  }
  ```
If you are not using GetMaterialApp, you can use the manual API to attach Middleware observer.


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

Now, use Get on your code:

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

### Optional Global Settings
You can create Global settings for Get. Just add Get.config to your code before pushing any route or do it directly in your GetMaterialApp

```dart

GetMaterialApp(
      enableLog: true,
      defaultTransition: Transitions.fade,
      defaultOpaqueRoute: Get.isOpaqueRouteDefault,
      defaultPopGesture: Get.isPopGestureEnable,
      defaultDurationTransition: Get.defaultDurationTransition,
      defaultGlobalState: Get.defaultGlobalState,
    );

Get.config(
      enableLog = true,
      defaultPopGesture = true,
      defaultTransition = Transitions.cupertino}
```


### Other Advanced APIs and Manual configurations
GetMaterialApp configures everything for you, but if you are using any package like Modular, you may want to configure Get Manually using advanced APIs.

```dart
MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
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

Get.removeRoute() // remove one route.

Get.until() // back repeatedly until the predicate returns true.

Get.offUntil() // go to next route and remove all the previous routes until the predicate returns true.

Get.offNamedUntil() // go to next named route and remove all the previous routes until the predicate returns true.

GetPlatform.isAndroid/isIOS/isWeb... //(This method is completely compatible with FlutterWeb, unlike the framework. "Platform.isAndroid")

Get.height / Get.width // Equivalent to the method: MediaQuery.of(context).size.height

Get.context // Gives the context of the screen in the foreground anywhere in your code.

Get.contextOverlay // Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.

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


This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

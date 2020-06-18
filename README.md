![](get.png)

*Languages: English (this file), [Brazilian Portuguese](README.pt-br.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get) 
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->


- Get is an extra-light and powerful solution for Flutter. It combines high performance state management, intelligent dependency injection, and route management in a quick and practical way.
- Get is not for everyone, its focus is (performance) on the minimum consumption of resources ([look the benchmarks](https://github.com/jonataslaw/benchmarks)), (productivity) using an easy and pleasant syntax and (organization) allowing the total decoupling of the View from the business logic.
- Get will save hours of development, and will extract the maximum performance that your application can deliver, being easy for beginners, and accurate for experts. Navigate without context, open dialogs, snackbars or bottomsheets from anywhere in your code, Manage states and inject dependencies in an easy and practical way. Get is secure, stable, up-to-date, and offers a huge range of APIs that are not present on default framework.

**Get makes your development productive, but want to make it even more productive? Add the extension [Get extension to VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) to your VSCode**


The "counter" project created by default on new project on Flutter has over 100 lines (with comments). To show the power of Get, I will demonstrate how to make a "counter" changing the state with each click, switching between pages and sharing the state between screens, all in an organized way, separating the business logic from the view, in ONLY 26 LINES CODE INCLUDING COMMENTS.

- Step 1: 
Add "Get" before your materialApp, turning it into GetMaterialApp
```dart
void main() => runApp(GetMaterialApp(home: Home()));
```
- Step 2:
Create your business logic class and place all variables, methods and controllers inside it.
You can make any variable observable using a simple ".obs".

```dart
class Controller extends RxController{
  var count = 0.obs; 
  increment() => count.value++;
}
```
- Step 3:
Create your View, use StatelessWidget and save some RAM, with Get you may no longer need to use StatefulWidget.
```dart
class Home extends StatelessWidget {

  // Instantiate your class using Get.put() to make it available for all "child" routes there.
  final Controller c = Get.put(Controller());

  @override
  Widget build(context) => Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: " + c.count.string))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: RaisedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text(c.count.string)));
}

```

This is a simple project but it already makes clear how powerful Get is. As your project grows, this difference will become more significant. Get was designed to work with teams, but it makes the job of an individual developer simple. Improve your deadlines, deliver everything on time without losing performance. Get is not for everyone, but if you identified with that phrase, Get is for you!

- [Route Management](#route-management)
  - [How to use?](#how-to-use)
  - [Navigation without named routes](#navigation-without-named-routes)
  - [Navigation with named routes](#navigation-with-named-routes)
    - [Send data to named Routes:](#send-data-to-named-routes)
    - [Dynamic urls links](#dynamic-urls-links)
    - [Middleware](#middleware)
  - [Navigation without context](#navigation-without-context)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [Nested Navigation](#nested-navigation)
- [State Management](#state-management)
  - [Simple State Manager](#simple-state-manager)
    - [Advantages](#advantages)
    - [Usage](#usage)
    - [How it handles controllers](#how-it-handles-controllers)
    - [You won't need StatefulWidgets anymore](#you-wont-need-statefulwidgets-anymore)
    - [Why it exists](#why-it-exists)
    - [Other ways of using it](#other-ways-of-using-it)
    - [Unique IDs](#unique-ids)
  - [Reactive State Manager](#reactive-state-manager)
    - [Advantages](#advantages-1)
    - [Usage](#usage-1)
    - [Where .obs can be used](#where-obs-can-be-used)
    - [Note about Lists](#note-about-lists)
    - [Why i have to use .value?](#why-i-have-to-use-value)
    - [Obx()](#obx)
    - [Workers:](#workers)
  - [Mixing the two state managers](#mixing-the-two-state-managers)
  - [GetBuilder vs GetX && Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)
- [Dependency Management](#dependency-management)
  - [Simple Instance Manager](#simple-instance-manager)
  - [Bindings](#bindings)
    - [How to use](#how-to-use-1)
  - [SmartManagement](#smartmanagement)
- [Utils](#utils)
  - [Change Theme](#change-theme)
  - [Other Advanced APIs and Manual configurations](#other-advanced-apis-and-manual-configurations)
    - [Optional Global Settings](#optional-global-settings)

*Want to contribute to the project? We will be proud to highlight you as one of our collaborators. Here are some points where you can contribute and make Get (and Flutter) even better.*

- Helping to translate the readme into other languages.
- Adding documentation to the readme (not even half of Get's functions have been documented yet).
- Write articles or make videos teaching how to use Get (they will be inserted in the Readme and in the future in our Wiki).
- Offering PRs for code/tests.
- Including new functions.

# Route Management

Any contribution is welcome!

## How to use?

Add this to your pubspec.yaml file:

```
dependencies:
  get: 
```
If you are going to use routes/snackbars/dialogs/bottomsheets without context, or use the high-level Get APIs, you need to simply add "Get" before your MaterialApp, turning it into GetMaterialApp and enjoy!

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Navigation without named routes
To navigate to a new screen:

```dart
Get.to(NextScreen());
```

To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);

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
Get.back(result: 'success');
```
And use it:

ex:
```dart
if(data == 'success') madeAnything();
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

## Navigation with named routes
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
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
      GetPage(
        name: '/',
        page: () => MyHomePage(),
      ),
      GetPage(
        name: '/second',
        page: () => Second(),
      ),
      GetPage(
        name: '/third',
        page: () => Third(),
        transition: Transition.cupertino  
      ),
     ],
    )
  );
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

### Dynamic urls links
Get offer advanced dynamic urls just like on the Web. Web developers have probably already wanted this feature on Flutter, and most likely have seen a package promise this feature and deliver a totally different syntax than a URL would have on web, but Get also solves that.

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
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
      GetPage(
        name: '/',
        page: () => MyHomePage(),
      ),
      GetPage(
        /// Important!  :user is not a new route, it is just a parameter
        /// specification. Do not use '/second/:user' and '/second'
        /// if you need new route to user, use '/second/user/:user' 
        /// if '/second' is a route.
        name: '/second/:user',
        page: () => Second(),
      ),
      GetPage(
        name: '/third',
        page: () => Third(),
        transition: Transition.cupertino  
      ),
     ],
    )
  );
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


### Middleware 
If you want listen Get events to trigger actions, you can to use routingCallback to it
```dart
GetMaterialApp(
  routingCallback: (route) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```
If you are not using GetMaterialApp, you can use the manual API to attach Middleware observer.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
      ],
    ),
  );
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
## Navigation without context

### SnackBars

To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold, 
```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
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
  //     bool instantInit,
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
`Get.rawSnackbar();` which provides the RAW API on which Get.snackbar was built.

### Dialogs

To open dialog:

```dart
Get.dialog(YourDialogWidget());
```

To open default dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
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
);
```


## Nested Navigation

Get made Flutter's nested navigation even easier.
You don't need the context, and you will find your navigation stack by Id.

- NOTE: Creating parallel navigation stacks can be dangerous. The ideal is not to use NestedNavigators, or to use sparingly. If your project requires it, go ahead, but keep in mind that keeping multiple navigation stacks in memory may not be a good idea for RAM consumption.

See how simple it is:
```dart
Navigator(
  key: Get.nestedKey(1), // create a key by index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetRouteBase(
        page: Scaffold(
          appBar: AppBar(
            title: Text("Main"),
          ),
          body: Center(
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Get.toNamed('/second', id:1); // navigate by your nested route by index
              },
              child: Text("Go to second"),
            ),
          ),
        ),
      );
    } else if (settings.name == '/second') {
      return GetRouteBase(
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
  }
),
```


# State Management

There are currently several state managers for Flutter. However, most of them involve using ChangeNotifier to update widgets and this is a bad and very bad approach to performance of medium or large applications. You can check in the official Flutter documentation that [ChangeNotifier should be used with 1 or a maximum of 2 listeners](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), making it practically unusable for any application medium or large.

Other state managers are good, but have their nuances:
- BLoC is very safe and efficient, but it is very complex for beginners, which has kept people from developing with Flutter.
- MobX is easier than BLoC and reactive, almost perfect, I would say, but you need to use a code generator, that for large applications, reduces productivity, since you will need to drink a lot of coffees until your code is ready again after a `flutter clean` (And this is not MobX's fault, but the codegen which is really slow!).
- Provider uses InheritedWidget to deliver the same listener, as a way of solving the problem reported above with ChangeNotifier, which implies that any access to its ChangeNotifier class must be within the widget tree because of the context to access o Inherited.


Get isn't better or worse than any other state manager, but that you should analyze these points as well as the points below to choose between using Get in pure form (Vanilla), or using it in conjunction with another state manager. Definitely, Get is not the enemy of any other state manager, because Get is a microframework, not just a state manager, and can be used either alone or in conjunction with them.

## Simple State Manager

Get has a state manager that is extremely light and easy, which does not use ChangeNotifier, will meet the need especially for those new to Flutter, and will not cause problems for large applications.

### Advantages

1. Update only the required widgets.

2. Does not use changeNotifier, it is the state manager that uses less memory (close to 0mb).

3. Forget StatefulWidget! With Get you will never need it. With the other state managers, you will probably have to use a StatefulWidget to get the instance of your Provider, BLoC, MobX Controller, etc. But have you ever stopped to think that your appBar, your scaffold, and most of the widgets that are in your class are stateless? So why save the state of an entire class, if you can only save the state of the Widget that is stateful? Get solves that, too. Create a Stateless class, make everything stateless. If you need to update a single component, wrap it with GetBuilder, and its state will be maintained.

4. Organize your project for real! Controllers must not be in your UI, place your TextEditController, or any controller you use within your Controller class.

5. Do you need to trigger an event to update a widget as soon as it is rendered? GetBuilder has the property "initState", just like StatefulWidget, and you can call events from your controller, directly from it, no more events being placed in your initState.

6. Do you need to trigger an action like closing streams, timers and etc? GetBuilder also has the dispose property, where you can call events as soon as that widget is destroyed.

7. Use streams only if necessary. You can use your StreamControllers inside your controller normally, and use StreamBuilder also normally, but remember, a stream reasonably consumes memory, reactive programming is beautiful, but you shouldn't abuse it. 30 streams open simultaneously can be worse than changeNotifier (and changeNotifier is very bad).

8. Update widgets without spending ram for that. Get stores only the GetBuilder creator ID, and updates that GetBuilder when necessary. The memory consumption of the get ID storage in memory is very low even for thousands of GetBuilders. When you create a new GetBuilder, you are actually sharing the state of GetBuilder that has a creator ID. A new state is not created for each GetBuilder, which saves A LOT OF ram for large applications. Basically your application will be entirely Stateless, and the few Widgets that will be Stateful (within GetBuilder) will have a single state, and therefore updating one will update them all. The state is just one.

9. Get is omniscient and in most cases it knows exactly the time to take a controller out of memory. You should not worry about when to dispose of a controller, Get knows the best time to do this.

### Usage

```dart
// Create controller class and extends GetController
class Controller extends GetController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // use update() to update counter variable on UI when increment be called
  }
}
// On your Stateless/Stateful class, use GetBuilder to update Text when increment be called 
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```
**Done!**
- You have already learned how to manage states with Get.

- Note: You may want a larger organization, and not use the init property. For that, you can create a class and extends Bindings class, and within it mention the controllers that will be created within that route. Controllers will not be created at that time, on the contrary, this is just a statement, so that the first time you use a Controller, Get will know where to look. Get will remain lazyLoad, and will continue to dispose Controllers when they are no longer needed. See the pub.dev example to see how it works.


If you navigate many routes and need data that was in your previously used controller, you just need to use GetBuilder Again (with no init):

```dart
class OtherClass extends StatelessWidget {
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
If you need to use your controller in many other places, and outside of GetBuilder, just create a get in your controller and have it easily. (or use `Get.find<Controller>()`)

```dart
class Controller extends GetController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.counter();
  /// with no static method: Get.find<Controller>().counter();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other the IDE will autocomplete it.
  static Controller get to => Get.find(); // add this line 

  int counter = 0;
  void increment() {
    counter++;
    update(); 
  }
}
```
And then you can access your controller directly, that way:
```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(), 
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```
When you press FloatingActionButton, all widgets that are listening to the 'counter' variable will be updated automatically.

### How it handles controllers
Let's say we have this:

`Class a => Class B (has controller X) => Class C (has controller X)`

In class A the controller is not yet in memory, because you have not used it yet (Get is lazyLoad). In class B you used the controller, and it entered memory. In class C you used the same controller as in class B, Get will share the state of controller B with controller C, and the same controller is still in memory. If you close screen C and screen B, Get will automatically take controller X out of memory and free up resources, because Class a is not using the controller. If you navigate to B again, controller X will enter memory again, if instead of going to class C, you return to class A again, Get will take the controller out of memory in the same way. If class C didn't use the controller, and you took class B out of memory, no class would be using controller X and likewise it would be disposed of. The only exception that can mess with Get, is if you remove B from the route unexpectedly, and try to use the controller in C. In this case, the creator ID of the controller that was in B was deleted, and Get was programmed to remove it from memory every controller that has no creator ID. If you intend to do this, add the "autoRemove: false" flag to class B's GetBuilder and use adoptID = true; in class C's GetBuilder.

### You won't need StatefulWidgets anymore
Using StatefulWidgets means storing the state of entire screens unnecessarily, even because if you need to minimally rebuild a widget, you will embed it in a Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, which will be another StatefulWidget.
The StatefulWidget class is a class larger than StatelessWidget, which will allocate more RAM, and this may not make a significant difference between one or two classes, but it will most certainly do when you have 100 of them!
Unless you need to use a mixin, like TickerProviderStateMixin, it will be totally unnecessary to use a StatefulWidget with Get. 

You can call all methods of a StatefulWidget directly from a GetBuilder.
If you need to call initState() or dispose() method for example, you can call them directly;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

A much better approach than this is to use the onInit() and onClose() method directly from your controller.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- NOTE: If you want to start a method at the moment the controller is called for the first time, you DON'T NEED to use constructors for this, in fact, using a performance-oriented package like Get, this borders on bad practice, because it deviates from the logic in which the controllers are created or allocated (if you create an instance of this controller, the constructor will be called immediately, you will be populating a controller before it is even used, you are allocating memory without it being in use, this definitely hurts the principles of this library). The onInit() methods; and onClose(); were created for this, they will be called when the Controller is created, or used for the first time, depending on whether you are using Get.lazyPut or not. If you want, for example, to make a call to your API to populate data, you can forget about the old-fashioned method of initState/dispose, just start your call to the api in onInit, and if you need to execute any command like closing streams, use the onClose() for that.

### Why it exists
The purpose of this package is precisely to give you a complete solution for navigation of routes, management of dependencies and states, using the least possible dependencies, with a high degree of decoupling. Get engages all high and low level Flutter APIs within itself, to ensure that you work with the least possible coupling. We centralize everything in a single package, to ensure that you don't have any kind of coupling in your project. That way, you can put only widgets in your view, and leave the part of your team that works with the business logic free, to work with the business logic without depending on any element of the View. This provides a much cleaner working environment, so that part of your team works only with widgets, without worrying about sending data to your controller, and part of your team works only with the business logic in its breadth, without depending on no element of the view.

So to simplify this:
You don't need to call methods in initState and send them by parameter to your controller, nor use your controller constructor for that, you have the onInit() method that is called at the right time for you to start your services.
You do not need to call the device, you have the onClose() method that will be called at the exact moment when your controller is no longer needed and will be removed from memory. That way, leave views for widgets only, refrain from any kind of business logic from it.

Do not call a dispose method inside GetController, it will not do anything, remember that the controller is not a Widget, you should not "dispose" it, and it will be automatically and intelligently removed from memory by Get. If you used any stream on it and want to close it, just insert it into the close method. Example:

```dart
class Controller extends GetController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// close stream = onClose method, not dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```
Controller life cycle:
- onInit() where it is created.
- onClose() where it is closed to make any changes in preparation for the delete method
- deleted: you do not have access to this API because it is literally removing the controller from memory. It is literally deleted, without leaving any trace.

### Other ways of using it

You can use Controller instance directly on GetBuilder value:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```
You may also need an instance of your controller outside of your GetBuilder, and you can use these approaches to achieve this:

```dart
class Controller extends GetController {
  static Controller get to => Get.find(); 
[...]
}
// on you view:
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Controller.to.counter}', //here
  )
),
```
or 
```dart
class Controller extends GetController {
 // static Controller get to => Get.find(); // with no static get
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

- You can use "non-canonical" approaches to do this. If you are using some other dependency manager, like get_it, modular, etc., and just want to deliver the controller instance, you can do this:

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>( 
  init: controller, //here
  builder: (_) => Text(
    '${controller.counter}', // here
  ),
),

```

### Unique IDs
If you want to refine a widget's update control with GetBuilder, you can assign them unique IDs:
```dart
GetBuilder<Controller>( 
  id: 'text' 
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```
And update it this form:
```dart
update(['text']);
```
You can also impose conditions for the update:

```dart
update(['text'], counter < 10);
```

GetX does this automatically and only reconstructs the widget that uses the exact variable that was changed, if you change a variable to the same as the previous one and that does not imply a change of state , GetX will not rebuild the widget to save memory and CPU cycles (3 is being displayed on the screen, and you change the variable to 3 again. In most state managers, this will cause a new rebuild, but with GetX the widget will only is rebuilt again, if in fact his state has changed).

## Reactive State Manager

### Advantages
GetBuilder is aimed precisely at multiple state control. Imagine that you added 30 products to a cart, you click delete one, at the same time that the list is updated, the price is updated and the badge in the shopping cart is updated to a smaller number. This type of approach makes GetBuilder killer, because it groups states and changes them all at once without any "computational logic" for that. GetBuilder was created with this type of situation in mind, since for ephemeral change of state, you can use setState and you would not need a state manager for this. However, there are situations where you want only the widget where a certain variable has been changed to be rebuilt, and this is what GetX does with a mastery never seen before.

That way, if you want an individual controller, you can assign IDs for that, or use GetX. This is up to you, remembering that the more "individual" widgets you have, the more the performance of GetX will stand out, while the performance of GetBuilder should be superior, when there is multiple change of state.

You can use both in any situation, but if you want to tune their application to the maximum possible performance, I would say that: if your variables are changed at different times, use GetX, because there is no competition for it when the subject is to rebuild only what is necessary, if you do not need unique IDs, because all your variables will be changed when you perform an action, use GetBuilder, because it is a simple state updater in blocks, made in a few lines of code, to make just what he promises to do: update state in blocks. There is no way to compare RAM, CPU, or anything else from a giant state manager to a simple StatefulWidget (like GetBuilder) that is updated when you call update(). It was done in a simple way, to have the least computational logic involved, just to fulfill a single purpose and spend the minimum resources possible for that purpose.
If you want a powerful state manager, you can go without fear to GetX. It does not work with variables, but flows, everything in it is streams under the hood. You can use rxDart in conjunction with it, because everything is stream, you can hear the event of each "variable", because everything in it is stream, it is literally BLoC, easier than MobX, and without code generator or decorations .

If you want power, Get gives you the most advanced state manager you could ever have.
GetX was built 100% based on Streams, and give you all the firepower that BLoC gave you, with an easier facility than using MobX.
Without decorations, you can turn anything into Observable with just a ".obs".

Maximum performance: In addition to having a smart algorithm for minimal reconstruction, Get uses comparators to make sure the state has changed. If you experience any errors in your application, and send a duplicate change of state, Get will ensure that your application does not collapse.
The state only changes if the values ​​change. That's the main difference between Get, and using Computed from MobX. When joining two observables, when one is changed, the hearing of that observable will change. With Get, if you join two variables (which is unnecessary computed for that), GetX (similar to Observer) will only change if it implies a real change of state. 

### Usage

```dart
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
GetX<Controller>(
  builder: (_) {
    print("count 1 rebuild");
    return Text('${_.count1.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("count 2 rebuild");
    return Text('${_.count2.value}');
  },
),
GetX<Controller>(
  builder: (_) {
    print("count 3 rebuild");
    return Text('${_.sum}');
  },
),
```

If we increment the number of count 1, only count 1 and count 3 are reconstructed, because count 1 now has a value of 1, and 1 + 0 = 1, changing the sum value.

If we change count 2, only count2 and 3 are reconstructed, because the value of 2 has changed, and the result of the sum is now 2.

If we add the number 1 to count 1, which already contains 1, no widget is reconstructed. If we add a value of 1 for count 1 and a value of 2 for count 2, only 2 and 3 will be reconstructed, simply because GetX not only changes what is necessary, it avoids duplicating events.

- NOTE: By default, the first event will allow rebuild even if it is the same. We created this behavior due to dualistic variables, such as Boolean.
Imagine you did this:

```dart
var isLogged = false.obs;
```

and then you check if a user is logged in to trigger an event in "ever".

```dart
onInit(){
  ever(isLogged, fireRoute);
  isLogged.value = await Preferences.hasToken();
}

fireRoute(logged) {
  if (logged) {
   Get.off(Home());
  } else {
   Get.off(Login());
  }
}
```

if hasToken was false, there would be no change to isLogged, so ever would never be called. To avoid this type of behavior, the first change to an observable will always trigger an event, even if it is the same.
You can remove this behavior if you want, using:
`isLogged.firstRebuild = false;`

In addition, Get provides refined state control. You can condition an event (such as adding an object to a list), on a certain condition.

```dart
list.addIf(item<limit, item);
```

Without decorations, without a code generator, without complications, GetX will change the way you manage your states in Flutter, and that is not a promise, it is a certainty!

Do you know Flutter's counter app? Your Controller class might look like this:

```dart
class CountCtl extends RxController {
  final count = 0.obs;
}
```
With a simple:
```dart
ctl.count.value++
```

You could update the counter variable in your UI, regardless of where it is stored.

### Where .obs can be used
You can transform anything on obs:

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}

class User {
  User({String name, int age});
  final rx = RxUser();

  String get name => rx.name.value;
  set name(String value) => rx.name.value = value;

  int get age => rx.age.value;
  set age(int value) => rx.age.value = value;
}
```

```dart

void main() {
  final user = User();
  print(user.name);
  user.age = 23;
  user.rx.age.listen((int age) => print(age));
  user.age = 24;
  user.age = 25;
}
___________
out:
Camila
23
24
25

```


### Note about Lists
Working with Lists using Get is the best and most enjoyable thing in the world. They are completely observable as are the objects within it. That way, if you add a value to a list, it will automatically rebuild the widgets that use it.
You also don't need to use ".value" with lists, the amazing dart api allowed us to remove that, unfortunate primitive types like String and int cannot be extended, making the use of .value mandatory, but that won't be a problem if you work with gets and setters for these.

```dart
final list = List<User>().obs;
```

```dart
ListView.builder (
  itemCount: list.lenght
)
```

You don't have to work with sets if you don't want to. you can use the "assign 'and" assignAll "api.
The "assign" api will clear your list, and add a single object that you want to start there.
The "assignAll" api will clear the existing list and add any iterable objects that you inject into it.

### Why i have to use .value?
We could remove the obligation to use 'value' to String and int with a simple decoration and code generator, but the purpose of this lib is precisely not to need any external dependency. It is to offer an environment ready for programming, involving the essentials (management of routes, dependencies and states), in a simple, light and performance way without needing any external package. You can literally add 3 letters to your pubspec (get) and start programming. All solutions included by default, from route management to state management, aim at ease, productivity and performance. The total weight of this library is less than that of a single state manager, even though it is a complete solution, and that is what you must understand. If you are bothered by value, and like a code generator, MobX is a great alternative, and you can use it in conjunction with Get. For those who want to add a single dependency in pubspec and start programming without worrying about the version of a package being incompatible with another, or if the error of a state update is coming from the state manager or dependency, or still, do not want to worrying about the availability of controllers, whether literally "just programming", get is just perfect.

If you have no problem with the MobX code generator, or have no problem with the BLoC boilerplate, you can simply use Get for routes, and forget that it has state manager. Get SEM and RSM were born out of necessity, my company had a project with more than 90 controllers, and the code generator simply took more than 30 minutes to complete its tasks after a Flutter Clean on a reasonably good machine, if your project it has 5, 10, 15 controllers, any state manager will supply you well. If you have an absurdly large project, and code generator is a problem for you, you have been awarded this solution.

Obviously, if someone wants to contribute to the project and create a code generator, or something similar, I will link in this readme as an alternative, my need is not the need for all devs, but for now I say, there are good solutions that already do that, like MobX.

### Obx()

Typing in Get using Bindings is unnecessary. you can use the Obx widget instead of GetX which only receives the anonymous function that creates a widget.
Obviously, if you don't use a type, you will need to have an instance of your controller to use the variables, or use `Get.find<Controller>()` .value or Controller.to.value to retrieve the value.

### Workers:
Workers will assist you, triggering specific callbacks when an event occurs.


```dart
/// Called every time the variable $_ is changed
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example. 
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```
- ever
'ever' is called every time its variable is changed. That's it.

- ever
'once' is called only the first time the variable has been changed.

- debounce
'debounce' is very useful in search functions, where you only want the API to be called when the user finishes typing. If the user types "Jonny", you will have 5 searches in the APIs, by the letter J, o, n, n, and y. With Get this does not happen, because you will have a "debounce" Worker that will only be triggered at the end of typing.

- interval
'interval' is different from the debouce. debouce if the user makes 1000 changes to a variable within 1 second, he will send only the last one after the stipulated timer (the default is 800 milliseconds). Interval will instead ignore all user actions for the stipulated period. If you send events for 1 minute, 1000 per second, debounce will only send you the last one, when the user stops strafing events. interval will deliver events every second, and if set to 3 seconds, it will deliver 20 events that minute. This is recommended to avoid abuse, in functions where the user can quickly click on something and get some advantage (imagine that the user can earn coins by clicking on something, if he clicked 300 times in the same minute, he would have 300 coins, using interval, you you can set a time frame for 3 seconds, and even then clicking 300 or a thousand times, the maximum he would get in 1 minute would be 20 coins, clicking 300 or 1 million times). The debounce is suitable for anti-DDos, for functions like search where each change to onChange would cause a query to your api. Debounce will wait for the user to stop typing the name, to make the request. If it were used in the coin scenario mentioned above, the user would only win 1 coin, because it is only executed, when the user "pauses" for the established time.


## Mixing the two state managers
Some people opened a feature request, as they wanted to use only one type of reactive variable, and the other mechanics, and needed to insert an Obx into a GetBuilder for this. Thinking about it MixinBuilder was created. It allows both reactive changes by changing ".obs" variables, and mechanical updates via update(). However, of the 4 widgets he is the one that consumes the most resources, since in addition to having a Subscription to receive change events from his children, he subscribes to the update method of his controller.

- Note: To use GetBuilder and MixinBuilder you must use GetController. To use GetX and Obx you must use RxController.
Probably using a GetController using GetX and Obx will work, but it will not be possible to use an RxController on a GetBuilder.
Extending these controllers is important, as they have life cycles, and can "start" and "end" events in their onInit() and onClose() methods.

## GetBuilder vs GetX vs Obx vs MixinBuilder
In a decade working with programming I was able to learn some valuable lessons.

My first contact with reactive programming was so "wow, this is incredible" and in fact reactive programming is incredible.
However, it is not suitable for all situations. Often all you need is to change the state of 2 or 3 widgets at the same time, or an ephemeral change of state, in which case reactive programming is not bad, but it is not appropriate.

Reactive programming has a higher consumption of RAM consumption that can be compensated for by the individual workflow, which will ensure that only one widget is rebuilt and when necessary, but creating a list with 80 objects, each with several streams is not a good one idea. Open the dart inspect and check how much a StreamBuilder consumes, and you'll understand what I'm trying to tell you.

With that in mind, I created the simple state manager. It is simple, and that is exactly what you should demand from it: updating state in blocks in a simple way, and in the most economical way.

GetBuilder is very economical in RAM, and there is hardly a more economical approach than him (at least I can't imagine one, if it exists, please let us know).

However, GetBuilder is still a mechanical state manager, you need to call update() just like you would need to call Provider's notifyListeners().

There are other situations where reactive programming is really interesting, and not working with it is the same as reinventing the wheel. With that in mind, GetX was created to provide everything that is most modern and advanced in a state manager. It updates only what is necessary and when necessary, if you have an error and send 300 state changes simultaneously, GetX will filter and update the screen only if the state actually changes.

GetX is still more economical than any other reactive state manager, but it consumes a little more RAM than GetBuilder. Thinking about it and aiming to maximize the consumption of resources that Obx was created. Unlike GetX and GetBuilder, you will not be able to initialize a controller inside an Obx, it is just a Widget with a StreamSubscription that receives change events from your children, that's all. It is more economical than GetX, but loses to GetBuilder, which was to be expected, since it is reactive, and GetBuilder has the most simplistic approach that exists, of storing a widget's hashcode and its StateSetter. With Obx you don't need to write your controller type, and you can hear the change from multiple different controllers, but it needs to be initialized before, either using the example approach at the beginning of this readme, or using the Bindings class.




# Dependency Management


## Simple Instance Manager
- Note: If you are using Get's State Manager, you don't have to worry about that, just read for information, but pay more attention to the bindings api, which will do all of this automatically for you.

Are you already using Get and want to make your project as lean as possible? Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

```dart
controller.fetchApi();
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

Looking for lazy loading? You can declare all your controllers, and it will be called only when someone needs it. You can do this with:
```dart
Get.lazyPut<Service>(()=> ApiMock());
/// ApiMock will only be called when someone uses Get.find<Service> for the first time
```

If you want to register an asynchronous instance, you can use Get.putAsync.
```dart
Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 12345);
    return prefs;
});
```
usage:

```dart
  int count = Get.find<SharedPreferences>().getInt('counter');
  print(count);
  // out: 12345
}
```

To remove a instance of Get:
```dart
Get.delete<Controller>();
```


## Bindings 
One of the great differentials of this package, perhaps, is the possibility of full integration of the routes, state manager and dependency manager.
When a route is removed from the Stack, all controllers, variables, and instances of objects related to it are removed from memory. If you are using streams or timers, they will be closed automatically, and you don't have to worry about any of that.
In version 2.10 Get completely implemented the Bindings API.
Now you no longer need to use the init method. You don't even have to type your controllers if you don't want to. You can start your controllers and services in the appropriate place for that.
The Binding class is a class that will decouple dependency injection, while "binding" routes to the state manager and dependency manager.
This allows Get to know which screen is being displayed when a particular controller is used and to know where and how to dispose of it.
In addition, the Binding class will allow you to have SmartManager configuration control. You can configure the dependencies to be arranged when removing a route from the stack, or when the widget that used it is laid out, or neither. You will have intelligent dependency management working for you, but even so, you can configure it as you wish.

### How to use
- Create a class and implements Binding

```dart
class HomeBinding implements Bindings{
```

Your IDE will automatically ask you to override the "dependencies" method, and you just need to click on the lamp, override the method, and insert all the classes you are going to use on that route:

```dart
class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
    Get.lazyPut<Service>(()=> Api());
  }
}
```
Now you just need to inform your route, that you will use that binding to make the connection between route manager, dependencies and states.

- Using named routes:
```dart
namedRoutes: {
  '/': GetRoute(Home(), binding: HomeBinding())
}
```

- Using normal routes:
```dart
Get.to(Home(), binding: HomeBinding());
```

There, you don't have to worry about memory management of your application anymore, Get will do it for you.

The Binding class is called when a route is called, you can create an "initialBinding in your GetMaterialApp to insert all the dependencies that will be created.
```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```
## SmartManagement
Always prefer to use standard SmartManagement (full), you do not need to configure anything for that, Get already gives it to you by default. It will surely eliminate all your disused controllers from memory, as its refined control removes the dependency, even if a failure occurs and a widget that uses it is not properly disposed.
The "full" mode is also safe enough to be used with StatelessWidget, as it has numerous security callbacks that will prevent a controller from remaining in memory if it is not being used by any widget, and disposition is not important here. However, if you are bothered by the default behavior, or just don't want it to happen, Get offers other, more lenient options for intelligent memory management, such as SmartManagement.onlyBuilders, which will depend on the effective removal of widgets using the controller. tree to remove it, and you can prevent a controller from being deployed using "autoRemove: false" in your GetBuilder/GetX.
With this option, only controllers started in "init:" or loaded into a Binding with "Get.lazyPut" will be disposed, if you use Get.put or any other approach, SmartManagement will not have permissions to exclude this dependency.
With the default behavior, even widgets instantiated with "Get.put" will be removed, unlike SmartManagement.onlyBuilders.
SmartManagement.keepFactory is like SmartManagement.full, with one difference. SmartManagement.full purges the factories from the premises, so that Get.lazyPut() will only be able to be called once and your factory and references will be self-destructing. SmartManagement.keepFactory will remove its dependencies when necessary, however, it will keep the "shape" of these, to make an equal one if you need an instance of that again.
Instead of using SmartManagement.keepFactory you can use Bindings.
Bindings creates transitory factories, which are created the moment you click to go to another screen, and will be destroyed as soon as the screen-changing animation happens. It is so little time that the analyzer will not even be able to register it. When you navigate to this screen again, a new temporary factory will be called, so this is preferable to using SmartManagement.keepFactory, but if you don't want to create Bindings, or want to keep all your dependencies on the same Binding, it will certainly help you . Factories take up little memory, they don't hold instances, but a function with the "shape" of that class you want. This is very little, but since the purpose of this lib is to get the maximum performance possible using the minimum resources, Get removes even the factories by default. Use whichever is most convenient for you.

- NOTE: DO NOT USE SmartManagement.keepFactory if you are using multiple Bindings. It was designed to be used without Bindings, or with a single Binding linked in the GetMaterialApp's initialBinding.

- NOTE2: Using Bindings is completely optional, you can use Get.put() and Get.find() on classes that use a given controller without any problem.
However, if you work with Services or any other abstraction, I recommend using Bindings for a larger organization.


# Utils

## Change Theme
Please do not use any higher level widget than GetMaterialApp in order to update it. This can trigger duplicate keys. A lot of people are used to the prehistoric approach of creating a "ThemeProvider" widget just to change the theme of your app, and this is definitely NOT necessary with Get.

You can create your custom theme and simply add it within Get.changeTheme without any boilerplate for that:


```dart
Get.changeTheme(ThemeData.light());
```

If you want to create something like a button that changes the theme with onTap, you can combine two Get APIs for that, the api that checks if the dark theme is being used, and the theme change API, you can just put this within an onPressed:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

When darkmode is activated, it will switch to the light theme, and when the light theme is activated, it will change to dark.


If you want to know in depth how to change the theme, you can follow this tutorial on Medium that even teaches the persistence of the theme using Get:

- [Dynamic Themes in 3 lines using Get](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).



## Other Advanced APIs and Manual configurations
GetMaterialApp configures everything for you, but if you want to configure Get Manually using advanced APIs.

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

Get.height / Get.width // Equivalent to the method: MediaQuery.of(context).size.height, but they are immutable. If you need a changeable height/width (like browser windows that can be scaled) you will need to use context.height and context.width

Get.context // Gives the context of the screen in the foreground anywhere in your code.

Get.contextOverlay // Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.

```


### Optional Global Settings
You can create Global settings for Get. Just add Get.config to your code before pushing any route or do it directly in your GetMaterialApp

```dart
GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  opaqueRoute: Get.isOpaqueRouteDefault,
  popGesture: Get.isPopGestureEnable,
  transitionDuration: Get.defaultDurationTransition,
  defaultGlobalState: Get.defaultGlobalState,
);

Get.config(
  enableLog = true,
  defaultPopGesture = true,
  defaultTransition = Transitions.cupertino
)
```



This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

![](get.png)

*Languages: English (this file), [Brazilian Portuguese](README.pt-br.md), [Spanish](README-es.md).*

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![Gitter](https://badges.gitter.im/flutter_get/community.svg)](https://gitter.im/flutter_get/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](getx.png)


- [About Get](#about-get)
- [Installing](#installing)
- [The Three pillars](#the-three-pillars)
  - [State management](#state-management)
    - [In-depth explanation](#in-depth-explanation)
  - [Route management](#route-management)
    - [In-Depth Explanation](#in-depth-explanation-1)
  - [Dependency management](#dependency-management)
    - [In-depth explanation](#in-depth-explanation-2)
- [How to contribute](#how-to-contribute)
- [Utils](#utils)
  - [Change Theme](#change-theme)
  - [Other Advanced APIs](#other-advanced-apis)
    - [Optional Global Settings and Manual configurations](#optional-global-settings-and-manual-configurations)
- [Breaking changes from 2.0](#breaking-changes-from-20)
- [Why I made this package](#why-i-made-this-package)

# About Get

- GetX is an extra-light and powerful solution for Flutter. It combines high performance state management, intelligent dependency injection, and route management in a quick and practical way.
- GetX is not for everyone, its focus is (performance) on the minimum consumption of resources ([look the benchmarks](https://github.com/jonataslaw/benchmarks)), (productivity) using an easy and pleasant syntax and (organization) allowing the total decoupling of the View from the business logic.
- GetX will save hours of development, and will extract the maximum performance that your application can deliver, being easy for beginners, and accurate for experts.
- Navigate without `context`, open `dialogs`, `snackbars` or `bottomsheets` from anywhere in your code, Manage states and inject dependencies in an easy and practical way.
- Get is secure, stable, up-to-date, and offers a huge range of APIs that are not present on default framework.
- GetX is not `bloated`. It has a multitude of features that allow you to start programming without worrying about anything, but each of these features are in separate containers, and are only started after use. If you only use State Management, only State Management will be compiled. If you only use routes, nothing from the state management will be compiled. You can compile the benchmark repository, and you will see that using only Get state management, the application compiled with Get has become smaller than all other applications that have only the state management of other packages, because nothing that is not used will be compiled into your code, and each GetX solution was designed to be extra lightweight. The merit here also comes from Flutter's AOT which is incredible, and manages to eliminate unused resources like no other framework does.

**GetX makes your development productive, but want to make it even more productive? Add the extension [GetX extension](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) to your VSCode**. Not available in other IDEs for now.

# Installing

Add Get to your pubspec.yaml file:

```yaml
dependencies:
  get:
```

Import get in files that it will be used:

```dart
import 'package:get/get.dart';
```

# The Three pillars

## State management

**See an more in-depth explanation of state management [here](./docs/en_US/state_management.md). There you will see more examples and also the differente between the simple stage manager and the reactive state manager**

The "counter" project created by default on new project on Flutter has over 100 lines (with comments). To show the power of Get, I will demonstrate how to make a "counter" changing the state with each click, switching between pages and sharing the state between screens, all in an organized way, separating the business logic from the view, in ONLY 26 LINES CODE INCLUDING COMMENTS.

- Step 1:
Add "Get" before your materialApp, turning it into GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Note: this does not modify the MaterialApp of the Flutter, GetMaterialApp is not a modified MaterialApp, it is just a pre-configured Widget, which has the default MaterialApp as a child. You can configure this manually, but it is definitely not necessary. GetMaterialApp will create routes, inject them, inject translations, inject everything you need for route navigation. If you use Get only for state management or dependency management, it is not necessary to use GetMaterialApp. GetMaterialApp is necessary for routes, snackbars, internationalization, bottomSheets, dialogs, and high-level apis related to routes and absence of context.

- Step 2:
Create your business logic class and place all variables, methods and controllers inside it.
You can make any variable observable using a simple ".obs".

```dart
class Controller extends GetxController{
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

### In-depth explanation

**See an more in-depth explanation of state management [here](./docs/en_US/state_management.md). There you will see more examples and also the difference between the simple stage manager and the reactive state manager**

## Route management

See a more in-depth explanation of route management [here](./docs/en_US/route_management.md)

If you are going to use routes/snackbars/dialogs/bottomsheets without context, GetX is excellent for you too, just see it:

Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

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

Noticed that you didn't had to use context to do any of these things? That's one of the biggest advantages of using Get route management. With this, you can execute all these methods from within your controller class, without worries.

### In-Depth Explanation

**Note: Get work with named routes too! As said in the beggining, there is a in-depth documentation [here](./docs/en_US/route_management.md)**

## Dependency management

See a more in-depth explanation of dependency management [here](./docs/en_US/dependency_management.md)

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

### In-depth explanation

**See a more in-depth explanation of dependency management [here](./docs/en_US/dependency_management.md)**

# How to contribute

*Want to contribute to the project? We will be proud to highlight you as one of our collaborators. Here are some points where you can contribute and make Get (and Flutter) even better.*

- Helping to translate the readme into other languages.
- Adding documentation to the readme (not even half of Get's functions have been documented yet).
- Write articles or make videos teaching how to use Get (they will be inserted in the Readme and in the future in our Wiki).
- Offering PRs for code/tests.
- Including new functions.

Any contribution is welcome!

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

## Other Advanced APIs

```dart
// give the current args from currentScreen
Get.arguments

// give arguments of previous route
Get.previousArguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Rounting API from GetObserver
Get.routing

// check if snackbar is open
Get.isSnackbarOpen

// check if dialog is open
Get.isDialogOpen

// check if bottomsheet is open
Get.isBottomSheetOpen

// remove one route.
Get.removeRoute()

// back repeatedly until the predicate returns true.
Get.until()

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil()

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil()

//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isWeb

// Equivalent to the method: MediaQuery.of(context).size.height, but they are immutable.
Get.height
Get.width

// If you need a changeable height/width (like browser windows that can be scaled) you will need to use context.
Get.context.width
Get.context.height


// Gives the context of the screen in the foreground anywhere in your code.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground anywhere in your code.
Get.contextOverlay

// gives you the power to define half the screen now, a third of it and so on.
//Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
Get.context.heightTransformer()
Get.context.widthTransformer()

/// similar to MediaQuery.of(context).size
Get.context.mediaQuerySize()

/// similar to MediaQuery.of(context).padding
Get.context.mediaQueryPadding()

/// similar to MediaQuery.of(context).viewPadding
Get.context.mediaQueryViewPadding()

/// similar to MediaQuery.of(context).viewInsets;
Get.context.mediaQueryViewInsets()

/// similar to MediaQuery.of(context).orientation;
Get.context.orientation()

/// check if device is on landscape mode
Get.context.isLandscape()

/// check if device is on portrait mode
Get.context.isPortrait()

/// similar to MediaQuery.of(context).devicePixelRatio;
Get.context.devicePixelRatio()

/// similar to MediaQuery.of(context).textScaleFactor;
Get.context.textScaleFactor()

/// get the shortestSide from screen
Get.context.mediaQueryShortestSide()

/// True if width be larger than 800
Get.context.showNavbar()

/// True if the shortestSide is smaller than 600p
Get.context.isPhone()

/// True if the shortestSide is largest than 600p
Get.context.isSmallTablet()

/// True if the shortestSide is largest than 720p
Get.context.isLargeTablet()

/// True if the current device is Tablet
Get.context.isTablet()
```

### Optional Global Settings and Manual configurations

GetMaterialApp configures everything for you, but if you want to configure Get manually.

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
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

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

# Breaking changes from 2.0

1- Rx types:

| Before   | After      |
| -------- | ---------- |
| StringX  | `RxString` |
| IntX     | `RxInt`    |
| MapX     | `RxMax`    |
| ListX    | `RxList`   |
| NumX     | `RxNum`    |
| RxDouble | `RxDouble` |

RxController and GetBuilder now have merged, you no longer need to memorize which controller you want to use, just use GetxController, it will work for simple state management and for reactive as well.

2- NamedRoutes
Before:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Now:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page:()=> Home()),
  ]
)
```

Why this change?
Often, it may be necessary to decide which page will be displayed from a parameter, or a login token, the previous approach was inflexible, as it did not allow this.
Inserting the page into a function has significantly reduced the RAM consumption, since the routes will not be allocated in memory since the app was started, and it also allowed to do this type of approach:

```dart

GetStorage box = GetStorage();

GetMaterialApp(
  getPages: [
    GetPage(name: '/', page:(){  
      return box.hasData('token') ? Home() : Login();
    })
  ]
)
```

# Why I made this package

The problem that this package tries to solve is to have most of what you need in only one package. One day, when i update some of my apps to work with Flutter 1.9, something bad happened: Everything broke.

All of my libraries broke down, the libraries started to be prevented from using hyphen "-". Some updated the package, others did not. The others I had to look for because the project did not compile. Other libs just became incompatible with the current version, such as the image_extended that I offered a PR there to be able to solve, and all because of a simple update.

I lost 2 days of work just looking for errors to know where they came from and what lib they came from.

I confess that it was one of the most stressful situations I have ever gone through in my life. It was exactly on that day that I decided to do everything in one package.

I know this looks a lot like the package being based on my personal experiences, but I am a programmer, and I try to solve problems always from the programmer's perspective. I don't care about anything other than making my life and other devs easier with this library.

Every time I go through a frustrating experience, I write it down in my schedule, and try to resolve it after completing the project.

And then I decided to make a package that have the three things that you will always use: State management, route management, Dependency injection/management. Eventually i made internationalization, and storage (the last two are still being made)

This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

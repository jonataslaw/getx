---
sidebar_position: 1
---

# Get Started

### Installing

Add Get to your pubspec.yaml file:

```yml
dependencies:
  get:
```

Import get in files that it will be used:

```dart
import 'package:get/get.dart';
```

### Counter App with GetX

The "counter" project created by default on new project on Flutter has over 100 lines (with comments). To show the power of Get, I will demonstrate how to make a "counter" changing the state with each click, switching between pages and sharing the state between screens, all in an organized way, separating the business logic from the view, in ONLY 26 LINES CODE INCLUDING COMMENTS.

- Step 1:
  Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Note: this does not modify the MaterialApp of the Flutter, GetMaterialApp is not a modified MaterialApp, it is just a pre-configured Widget, which has the default MaterialApp as a child. You can configure this manually, but it is definitely not necessary. GetMaterialApp will create routes, inject them, inject translations, inject everything you need for route navigation. If you use Get only for state management or dependency management, it is not necessary to use GetMaterialApp. GetMaterialApp is necessary for routes, snackbars, internationalization, bottomSheets, dialogs, and high-level apis related to routes and absence of context.
- Note²: This step is only necessary if you gonna use route management (`Get.to()`, `Get.back()` and so on). If you not gonna use it then it is not necessary to do step 1

- Step 2:
  Create your business logic class and place all variables, methods and controllers inside it.
  You can make any variable observable using a simple ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Step 3:
  Create your View, use StatelessWidget and save some RAM, with Get you may no longer need to use StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Result:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

This is a simple project but it already makes clear how powerful Get is. As your project grows, this difference will become more significant.

Get was designed to work with teams, but it makes the job of an individual developer simple.

Improve your deadlines, deliver everything on time without losing performance. Get is not for everyone, but if you identified with that phrase, Get is for you!
# GetX codelab

In this example you will learn the basics of GetX. You will see how much easier it is to code with this framework, and you will know what problems GetX proposes to solve.

If the default Flutter application were rewritten with Getx, it would have only a few lines of code. The Getx state manager is easier than using setState. You just need to add a ".obs" at the end of your variable, and wrap the widget you want to change within a Obx().

```dart
void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  var count = 0.obs;
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Obx(() => Text("$count")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => count ++,
      ));
}
```
However, this simple example deals with ephemeral state management. If you need to access this data in several places in your application, you will need global state management.
The most common way to do this is to separate the business logic from its visualization. I know, you've heard this concept before, and it might have been scary for you, but with Getx, it's stupidly simple.
Getx provides you with a class capable of initializing data, and removing it when it is no longer needed, and its use is very simple:
Just create a class by extending GetxController and insert ALL your variables and functions there.

```dart
class Controller extends GetxController {
  var count = 0;
  void increment() {
    count++;
    update();
  }
}
```
Here you can choose between simple state management, or reactive state management.
The simple one will update its variable on the screen whenever update() is called. It is used with a widget called "GetBuilder".

```dart
class Home extends StatelessWidget {
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<Controller>(
                builder: (_) => Text(
                      'clicks: ${controller.count}',
                    )),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.to(Second());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.increment(),  
          ),
    );
  }
}
class Second extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(context){
     return Scaffold(body: Center(child: Text("${ctrl.count}")));
  }
}
```
When instantiating your controller, you may have noticed that we use `Get.put(Controller())`. This is enough to make your controller available to other pages as long as it is in memory.
You may have noticed that you have a new button using `Get.to(Second())`. This is enough to navigate to another page. You don't need a 

```dart
Navigator.of(context).push(context, 
 MaterialPageRoute(context, builder: (context){
    return Second();
 },
);
``` 
all that huge code, it's reduced to a simple `Get.to(Second())`. Isn't that incredible?

You may also have noticed that on the other page you simply used Get.find (), and the framework knows which controller you registered previously, and returns it effortlessly, you don't need to type the find with `Get.find<Controller>()` so that he knows what you need.

However, this is simple state management. You may want to control the output of each change of state, you may want to use and manipulate streams, you may want a variable to only be changed on the screen, when it definitely changes, you may need a debounce on changing the state, and to these and other needs, Getx has powerful, intelligent, and lightweight state management that can address any need, regardless of the size of your project. And its use is even easier than the previous one.

In your controller, you can remove the update method, Getx is reactive, so when a variable changes, it will automatically change on the screen.
You just need to add a ".obs" in front of your variable, and that's it, it's already reactive.

```dart
class Controller extends GetxController {
  var count = 0.obs;
  void increment() {
    count++;
  }
}
```
Now you just need to change GetBuilder for GetX and that's it
```dart
class Home extends StatelessWidget {
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<Controller>(
                builder: (_) => Text(
                      'clicks: ${controller.count}',
                    )),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.to(Second());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.increment(),  
          ),
    );
  }
}
class Second extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(context){
     return Scaffold(body: Center(child: Text("${ctrl.count}")));
  }
}
```

GetX is a useful widget when you want to inject the controller into the init property, or when you want to retrieve an instance of the controller within the widget itself. In other cases, you can insert your widget into an Obx, which receives a widget function. This looks much easier and clearer, just like the first example

```dart
class Home extends StatelessWidget {
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                      'clicks: ${controller.count}',
                    )),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.to(Second());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.increment(),  
          ),
    );
  }
}
class Second extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(context){
     return Scaffold(body: Center(child: Text("${ctrl.count}")));
  }
}
```
If you are a more demanding user, you must have said: BLoC separates the View from the business logic. But what about the presentation logic? Will I be obliged to attach it to the visualization? Will I be totally dependent on the context for everything I want to do? Will I have to insert a bunch of variables, TextEditingControllers in my view? If I need to hear the Scroll on my screen, do I need to insert an initState and a function into my view? If I need to trigger an action when this scroll reaches the end, do I insert it into the view, or in the bloc/changeNotifier class? Well, these are common architectural questions, and most of the time the solution to them is ugly.
With Getx you have no doubts when your architecture, if you need a function, it must be on your Controller, if you need to trigger an event, it needs to be on your controller, your view is generally a StatelessWidget free from any dirt.
This means that if someone has already done something you’re looking for, you can copy the controller entirely from someone else, and it will work for you, this level of standardization is what Flutter lacked, and it’s because of this that Getx has become so popular in the last few days. Flutter is amazing, and has minor one-off problems. Getx came to solve these specific problems. Flutter provides powerful APIs, and we turn them into an easy, clean, clear, and concise API for you to build applications in a fast, performance and highly scalable way.
If you have already asked yourself some of these questions above, you have certainly found the solution to your problems. Getx is able to completely separate any logic, be it presentation or business, and you will only have pure widgets in your visualization layer. No variables, no functions, just widgets. This will facilitate the work of your team working with the UI, as well as your team working with your logic. They won't depend on initState to do anything, their controller has onInit. Your code can be tested in isolation, the way it is.
But what about dependency injection? Will I have it attached to my visualization?
If you've used any state manager, you've probably heard of "multiAnything", or something like that.
You have probably already inserted dozens of ChangeNotifier or Blocs classes in a widget, just to have it all over the tree.
This level of coupling is yet another problem that Getx came to solve. For this, in this ecosystem we use BINDINGS.
Bindings are dependency injection classes. They are completely outside your widget tree, making your code cleaner, more organized, and allowing you to access it anywhere without context.
You can initialize dozens of controllers in your Bindings, when you need to know what is being injected into your view, just open the Bindings file on your page and that's it, you can clearly see what has been prepared to be initialized in your View.
Bindings is the first step towards having a scalable application, you can visualize what will be injected into your page, and decouple the dependency injection from your visualization layer.

To create a Binding, simply create a class and implement Bindings

```dart
class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Controller>(() => Controller());
    Get.lazyPut<Controller2>(() => Controller2());
    Get.lazyPut<Controller3>(() => Controller3());
  }
}
```
You can use with named routes (preferred)
```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [
      GetPage(name: '/home', page: () => First(), binding: SampleBind()),
    ],
  ));
}
```

Or unnamed
```dart
Get.to(Second(), binding: SampleBind());
```

There is a trick that can clear your View even more.
Instead of extending StatelessWidget, you can extend GetView, which is a StatelessWidget with a "controller" property.

See the example and see how clean your code can be using this approach.
The standard Flutter counter has almost 100 lines, it would be summarized to:

on main.dart
```dart
void main() {
  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [
      GetPage(name: '/home', page: () => HomeView(), binding: HomeBinding()),
    ],
  ));
}
```
on home_bindings.dart
```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
```

on home_controller.dart
```dart
class HomeController extends GetxController {
  var count = 0.obs;
  void increment() => count++;
}
```
on home_view.dart
```dart
class Home extends GetView<Controller> {
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Obx(() => Text("${controller.counter}")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: controller.increment,
      ));
}
```
What did you do:
He built an example of the counter, (with less code than the original), decoupling its visualization, its business logic, its dependency injection, in a clean, scalable way, facilitating code maintenance and reusability. If you need an accountant on another project, or your developer friend does, you can just share the content of the controller file with him, and everything will work perfectly.
As the view has only widgets, you can use a view for android, and another for iOS, taking advantage of 100% of your business logic, your view has only widgets! you can change them however you want, without affecting your application in any way.

However, some examples like internationalization, Snackbars without context, validators, responsiveness and other Getx resources, were not explored (and it would not even be possible to explore all resources in such a simple example), so below is an example not very complete, but trying demonstrate how to use internationalization, reactive custom classes, reactive lists, snackbars contextless, workers etc.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    // It is not mandatory to use named routes, but dynamic urls are interesting.
    initialRoute: '/home',
    defaultTransition: Transition.native,
    translations: MyTranslations(),
    locale: Locale('pt', 'BR'),
    getPages: [
      //Simple GetPage
      GetPage(name: '/home', page: () => First()),
      // GetPage with custom transitions and bindings
      GetPage(
        name: '/second',
        page: () => Second(),
        customTransition: SizeTransitions(),
        binding: SampleBind(),
      ),
      // GetPage with default transitions
      GetPage(
        name: '/third',
        transition: Transition.cupertino,
        page: () => Third(),
      ),
    ],
  ));
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello World %s',
        },
        'en_US': {
          'title': 'Hello World from US',
        },
        'pt': {
          'title': 'Olá de Portugal',
        },
        'pt_BR': {
          'title': 'Olá do Brasil',
        },
      };
}

class Controller extends GetxController {
  int count = 0;
  void increment() {
    count++;
    // use update method to update all count variables
    update();
  }
}

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("Hi", "I'm modern snackbar");
          },
        ),
        title: Text("title".trArgs(['John'])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<Controller>(
                init: Controller(),
                // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
                builder: (_) => Text(
                      'clicks: ${_.count}',
                    )),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.toNamed('/second');
              },
            ),
            RaisedButton(
              child: Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.find<Controller>().increment();
          }),
    );
  }
}

class Second extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<ControllerX>(
              // Using bindings you don't need of init: method
              // Using Getx you can take controller instance of "builder: (_)"
              builder: (_) {
                print("count1 rebuild");
                return Text('${_.count1}');
              },
            ),
            GetX<ControllerX>(
              builder: (_) {
                print("count2 rebuild");
                return Text('${controller.count2}');
              },
            ),
            GetX<ControllerX>(builder: (_) {
              print("sum rebuild");
              return Text('${_.sum}');
            }),
            GetX<ControllerX>(
              builder: (_) => Text('Name: ${controller.user.value.name}'),
            ),
            GetX<ControllerX>(
              builder: (_) => Text('Age: ${_.user.value.age}'),
            ),
            RaisedButton(
              child: Text("Go to last page"),
              onPressed: () {
                Get.toNamed('/third', arguments: 'arguments of second');
              },
            ),
            RaisedButton(
              child: Text("Back page and open snackbar"),
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'User 123',
                  'Successfully created',
                );
              },
            ),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () {
                Get.find<ControllerX>().increment();
              },
            ),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () {
                Get.find<ControllerX>().increment2();
              },
            ),
            RaisedButton(
              child: Text("Update name"),
              onPressed: () {
                Get.find<ControllerX>().updateUser();
              },
            ),
            RaisedButton(
              child: Text("Dispose worker"),
              onPressed: () {
                Get.find<ControllerX>().disposeWorker();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Third extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        controller.incrementList();
      }),
      appBar: AppBar(
        title: Text("Third ${Get.arguments}"),
      ),
      body: Center(
          child: Obx(() => ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return Text("${controller.list[index]}");
              }))),
    );
  }
}

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}

class User {
  User({this.name = 'Name', this.age = 0});
  String name;
  int age;
}

class ControllerX extends GetxController {
  final count1 = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final user = User().obs;

  updateUser() {
    user.update((value) {
      value.name = 'Jose';
      value.age = 30;
    });
  }

  /// Once the controller has entered memory, onInit will be called.
  /// It is preferable to use onInit instead of class constructors or initState method.
  /// Use onInit to trigger initial events like API searches, listeners registration
  /// or Workers registration.
  /// Workers are event handlers, they do not modify the final result,
  /// but it allows you to listen to an event and trigger customized actions.
  /// Here is an outline of how you can use them:

  /// made this if you need cancel you worker
  Worker _ever;

  @override
  onInit() {
    /// Called every time the variable $_ is changed
    _ever = ever(count1, (_) => print("$_ has been changed (ever)"));

    everAll([count1, count2], (_) => print("$_ has been changed (everAll)"));

    /// Called first time the variable $_ is changed
    once(count1, (_) => print("$_ was changed once (once)"));

    /// Anti DDos - Called every time the user stops typing for 1 second, for example.
    debounce(count1, (_) => print("debouce$_ (debounce)"),
        time: Duration(seconds: 1));

    /// Ignore all changes within 1 second.
    interval(count1, (_) => print("interval $_ (interval)"),
        time: Duration(seconds: 1));
  }

  int get sum => count1.value + count2.value;

  increment() => count1.value++;

  increment2() => count2.value++;

  disposeWorker() {
    _ever.dispose();
    // or _ever();
  }

  incrementList() => list.add(75);
}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
        child: child,
      ),
    );
  }
}
```
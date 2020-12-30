- [State Management](#state-management)
  - [Reactive State Manager](#reactive-state-manager)
    - [Advantages](#advantages)
    - [Maximum performance:](#maximum-performance)
    - [Declaring a reactive variable](#declaring-a-reactive-variable)
        - [Having a reactive state, is easy.](#having-a-reactive-state-is-easy)
    - [Using the values in the view](#using-the-values-in-the-view)
    - [Conditions to rebuild](#conditions-to-rebuild)
    - [Where .obs can be used](#where-obs-can-be-used)
    - [Note about Lists](#note-about-lists)
    - [Why i have to use .value](#why-i-have-to-use-value)
    - [Obx()](#obx)
    - [Workers](#workers)
  - [Simple State Manager](#simple-state-manager)
    - [Advantages](#advantages-1)
    - [Usage](#usage)
    - [How it handles controllers](#how-it-handles-controllers)
    - [You won't need StatefulWidgets anymore](#you-wont-need-statefulwidgets-anymore)
    - [Why it exists](#why-it-exists)
    - [Other ways of using it](#other-ways-of-using-it)
    - [Unique IDs](#unique-ids)
  - [Mixing the two state managers](#mixing-the-two-state-managers)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# State Management

GetX does not use Streams or ChangeNotifier like other state managers. Why? In addition to building applications for android, iOS, web, linux, macos and linux, with GetX you can build server applications with the same syntax as Flutter/GetX. In order to improve response time and reduce RAM consumption, we created GetValue and GetStream, which are low latency solutions that deliver a lot of performance, at a low operating cost. We use this base to build all of our resources, including state management.

- _Complexity_: Some state managers are complex and have a lot of boilerplate. With GetX you don't have to define a class for each event, the code is highly clean and clear, and you do a lot more by writing less. Many people have given up on Flutter because of this topic, and they now finally have a stupidly simple solution for managing states.
- _No code generators_: You spend half your development time writing your application logic. Some state managers rely on code generators to have minimally readable code. Changing a variable and having to run build_runner can be unproductive, and often the waiting time after a flutter clean will be long, and you will have to drink a lot of coffee.
With GetX everything is reactive, and nothing depends on code generators, increasing your productivity in all aspects of your development.
- _It does not depend on context_: You probably already needed to send the context of your view to a controller, making the View's coupling with your business logic high. You have probably had to use a dependency for a place that has no context, and had to pass the context through various classes and functions. This just doesn't exist with GetX. You have access to your controllers from within your controllers without any context. You don't need to send the context by parameter for literally nothing.
- _Granular control_: most state managers are based on ChangeNotifier. ChangeNotifier will notify all widgets that depend on it when notifyListeners is called. If you have 40 widgets on one screen, which have a variable of your ChangeNotifier class, when you update one, all of them will be rebuilt.
With GetX, even nested widgets are respected. If you have Obx watching your ListView, and another watching a checkbox inside the ListView, when changing the CheckBox value, only it will be updated, when changing the List value, only the ListView will be updated.
- _It only reconstructs if its variable REALLY changes_: GetX has flow control, that means if you display a Text with 'Paola', if you change the observable variable to 'Paola' again, the widget will not be reconstructed. That's because GetX knows that 'Paola' is already being displayed in Text, and will not do unnecessary reconstructions.
Most (if not all) current state managers will rebuild on the screen.

## Reactive State Manager

Reactive programming can alienate many people because it is said to be complicated. GetX turns reactive programming into something quite simple:

- You won't need to create StreamControllers.
- You won't need to create a StreamBuilder for each variable
- You will not need to create a class for each state.
- You will not need to create a get for an initial value.

Reactive programming with Get is as easy as using setState.

Let's imagine that you have a name variable and want that every time you change it, all widgets that use it are automatically changed.

This is your count variable:

```dart
var name = 'Jonatas Borges';
```

To make it observable, you just need to add ".obs" to the end of it:

```dart
var name = 'Jonatas Borges'.obs;
```

That's all. It's *that* simple.

From now on, we might refer to this reactive-".obs"(ervables) variables as _Rx_.   

What did we do under the hood? We created a `Stream` of `String`s, assigned the initial value `"Jonatas Borges"`, we notified all widgets that use `"Jonatas Borges"` that they now "belong" to this variable, and when the _Rx_ value changes, they will have to change as well. 

This is the **magic of GetX**, thanks to Dart's capabilities.

But, as we know, a `Widget` can only be changed if it is inside a function, because static classes do not have the power to "auto-change". 

You will need to create a `StreamBuilder`, subscribe to this variable to listen for changes, and create a "cascade" of nested `StreamBuilder` if you want to change several variables in the same scope, right?

No, you don't need a `StreamBuilder`, but you are right about static classes.

Well, in the view, we usually have a lot of boilerplate when we want to change a specific Widget, that's the Flutter way. 
With **GetX** you can also forget about this boilerplate code. 

`StreamBuilder( … )`? `initialValue: …`? `builder: …`? Nope, you just need to place this variable inside an `Obx()` Widget.

```dart
Obx (() => Text (controller.name));
```

_What do you need to memorize?_  Only `Obx(() =>`. 

You are just passing that Widget through an arrow-function into an `Obx()` (the "Observer" of the _Rx_). 

`Obx` is pretty smart, and will only change if the value of `controller.name` changes. 

If `name` is `"John"`, and you change it to `"John"` (`name.value = "John"`), as it's the same `value` as before, nothing will change on the screen, and `Obx`, to save resources, will simply ignore the new value and not rebuild the Widget. **Isn't that amazing?**

> So, what if I have 5 _Rx_ (observable) variables within an `Obx`?

It will just update when **any** of them changes. 

> And if I have 30 variables in a class, when I update one, will it update **all** the variables that are in that class?

Nope, just the **specific Widget** that uses that _Rx_ variable.

So, **GetX** only updates the screen, when the _Rx_ variable changes it's value.

```
final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```
### Advantages

**GetX()** helps you when you need **granular** control over what's being updated.

If you do not need `unique IDs`, because all your variables will be modified when you perform an action, then use `GetBuilder`, 
because it's a Simple State Updater (in blocks, like `setState()`), made in just a few lines of code.
It was made simple, to have the least CPU impact, and just to fulfill a single purpose (a _State_ rebuild) and spend the minimum resources possible.

If you need a **powerful** State Manager, you can't go wrong with **GetX**.

It doesn't work with variables, but __flows__, everything in it are `Streams` under the hood. 
You can use _rxDart_ in conjunction with it, because everything are `Streams`, 
you can listen the `event` of each "_Rx_ variable", 
because everything in it are `Streams`. 

It is literally a _BLoC_ approach, easier than _MobX_, and without code generators or decorations.
You can turn **anything** into an _"Observable"_ with just a `.obs`.

### Maximum performance:

In addition to having a smart algorithm for minimal rebuilds, **GetX** uses comparators 
to make sure the State has changed. 

If you experience any errors in your app, and send a duplicate change of State, 
**GetX** will ensure it will not crash.

With **GetX** the State only changes if the `value` change. 
That's the main difference between **GetX**, and using _`computed` from MobX_. 
When joining two __observables__, and one changes; the listener of that _observable_ will change as well.

With **GetX**, if you join two variables, `GetX()` (similar to `Observer()`) will only rebuild if it implies a real change of State.

### Declaring a reactive variable

You have 3 ways to turn a variable into an "observable".


1 - The first is using **`Rx{Type}`**.

```dart
// initial value is recommended, but not mandatory
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - The second is to use **`Rx`** and use Darts Generics, `Rx<Type>`

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0)
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Custom classes - it can be any class, literally
final user = Rx<User>();
```

3 - The third, more practical, easier and preferred approach, just add **`.obs`** as a property of your `value`:

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - it can be any class, literally
final user = User().obs;
```

##### Having a reactive state, is easy.

As we know, _Dart_ is now heading towards _null safety_.
To be prepared, from now on, you should always start your _Rx_ variables with an **initial value**.

> Transforming a variable into an _observable_ + _initial value_ with **GetX** is the simplest, and most practical approach.

You will literally add a "`.obs`" to the end of your variable, and **that’s it**, you’ve made it observable,
and its `.value`, well, will be the _initial value_).


### Using the values in the view

```dart
// controller file
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// view file
GetX<Controller>(
  builder: (controller) {
    print("count 1 rebuild");
    return Text('${controller.count1.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 2 rebuild");
    return Text('${controller.count2.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 3 rebuild");
    return Text('${controller.sum}');
  },
),
```

If we increment `count1.value++`, it will print:
- `count 1 rebuild` 
- `count 3 rebuild`

because `count1` has a value of `1`, and `1 + 0 = 1`, changing the `sum` getter value.

If we change `count2.value++`, it will print:
- `count 2 rebuild` 
- `count 3 rebuild`

because `count2.value` changed, and the result of the `sum` is now `2`.

- NOTE: By default, the very first event will rebuild the widget, even if it is the same `value`.
 This behavior exists due to Boolean variables.

Imagine you did this:

```dart
var isLogged = false.obs;
```

And then, you checked if a user is "logged in" to trigger an event in `ever`.

```dart
@override
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

if `hasToken` was `false`, there would be no change to `isLogged`, so `ever()` would never be called.
To avoid this type of behavior, the first change to an _observable_ will always trigger an event, 
even if it contains the same `.value`.

You can remove this behavior if you want, using:
`isLogged.firstRebuild = false;`

### Conditions to rebuild

In addition, Get provides refined state control. You can condition an event (such as adding an object to a list), on a certain condition.

```dart
// First parameter: condition, must return true or false.
// Second parameter: the new value to apply if the condition is true.
list.addIf(item < limit, item);
```

Without decorations, without a code generator, without complications :smile:

Do you know Flutter's counter app? Your Controller class might look like this:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

With a simple:

```dart
controller.count.value++
```

You could update the counter variable in your UI, regardless of where it is stored.

### Where .obs can be used

You can transform anything on obs. Here are two ways of doing it:

* You can convert your class values to obs
```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* or you can convert the entire class to be an observable
```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

### Note about Lists

Lists are completely observable as are the objects within it. That way, if you add a value to a list, it will automatically rebuild the widgets that use it.

You also don't need to use ".value" with lists, the amazing dart api allowed us to remove that.
Unfortunaly primitive types like String and int cannot be extended, making the use of .value mandatory, but that won't be a problem if you work with gets and setters for these.

```dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // String need to have .value in front of it
ListView.builder (
  itemCount: controller.list.length // lists don't need it
)
```

When you are making your own classes observable, there is a different way to update them:

```dart
// on the model file
// we are going to make the entire class observable instead of each attribute
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}


// on the controller file
final user = User().obs;
// when you need to update the user variable:
user.update( (user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});
// an alternative way of update the user variable:
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// you can also access the model values without the .value:
user().name; // notice that is the user variable, not the class (variable has lowercase u)
```

You don't have to work with sets if you don't want to. you can use the "assign 'and" assignAll "api.
The "assign" api will clear your list, and add a single object that you want to start there.
The "assignAll" api will clear the existing list and add any iterable objects that you inject into it.

### Why i have to use .value

We could remove the obligation to use 'value' to `String` and `int` with a simple decoration and code generator, but the purpose of this library is precisely avoid external dependencies. We want to offer an environment ready for programming, involving the essentials (management of routes, dependencies and states), in a simple, lightweight and performant way, without a need of an external package.

You can literally add 3 letters to your pubspec (get) and a colon and start programming. All solutions included by default, from route management to state management, aim at ease, productivity and performance.

The total weight of this library is less than that of a single state manager, even though it is a complete solution, and that is what you must understand.

If you are bothered by `.value`, and like a code generator, MobX is a great alternative, and you can use it in conjunction with Get. For those who want to add a single dependency in pubspec and start programming without worrying about the version of a package being incompatible with another, or if the error of a state update is coming from the state manager or dependency, or still, do not want to worrying about the availability of controllers, whether literally "just programming", get is just perfect.

If you have no problem with the MobX code generator, or have no problem with the BLoC boilerplate, you can simply use Get for routes, and forget that it has state manager. Get SEM and RSM were born out of necessity, my company had a project with more than 90 controllers, and the code generator simply took more than 30 minutes to complete its tasks after a Flutter Clean on a reasonably good machine, if your project it has 5, 10, 15 controllers, any state manager will supply you well. If you have an absurdly large project, and code generator is a problem for you, you have been awarded this solution.

Obviously, if someone wants to contribute to the project and create a code generator, or something similar, I will link in this readme as an alternative, my need is not the need for all devs, but for now I say, there are good solutions that already do that, like MobX.

### Obx()

Typing in Get using Bindings is unnecessary. you can use the Obx widget instead of GetX which only receives the anonymous function that creates a widget.
Obviously, if you don't use a type, you will need to have an instance of your controller to use the variables, or use `Get.find<Controller>()` .value or Controller.to.value to retrieve the value.

### Workers

Workers will assist you, triggering specific callbacks when an event occurs.

```dart
/// Called every time `count1` changes.
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```
All workers (except `debounce`) have a `condition` named parameter, which can be a `bool` or a callback that returns a `bool`.
This `condition` defines when the `callback` function executes.

All workers returns a `Worker` instance, that you can use to cancel ( via `dispose()` ) the worker.
 
- **`ever`**
 is called every time the _Rx_ variable emits a new value.

- **`everAll`**
 Much like `ever`, but it takes a `List` of _Rx_ values Called every time its variable is changed. That's it.


- **`once`**
'once' is called only the first time the variable has been changed.

- **`debounce`**
'debounce' is very useful in search functions, where you only want the API to be called when the user finishes typing. If the user types "Jonny", you will have 5 searches in the APIs, by the letter J, o, n, n, and y. With Get this does not happen, because you will have a "debounce" Worker that will only be triggered at the end of typing.

- **`interval`**
'interval' is different from the debouce. debouce if the user makes 1000 changes to a variable within 1 second, he will send only the last one after the stipulated timer (the default is 800 milliseconds). Interval will instead ignore all user actions for the stipulated period. If you send events for 1 minute, 1000 per second, debounce will only send you the last one, when the user stops strafing events. interval will deliver events every second, and if set to 3 seconds, it will deliver 20 events that minute. This is recommended to avoid abuse, in functions where the user can quickly click on something and get some advantage (imagine that the user can earn coins by clicking on something, if he clicked 300 times in the same minute, he would have 300 coins, using interval, you you can set a time frame for 3 seconds, and even then clicking 300 or a thousand times, the maximum he would get in 1 minute would be 20 coins, clicking 300 or 1 million times). The debounce is suitable for anti-DDos, for functions like search where each change to onChange would cause a query to your api. Debounce will wait for the user to stop typing the name, to make the request. If it were used in the coin scenario mentioned above, the user would only win 1 coin, because it is only executed, when the user "pauses" for the established time.

- NOTE: Workers should always be used when starting a Controller or Class, so it should always be on onInit (recommended), Class constructor, or the initState of a StatefulWidget (this practice is not recommended in most cases, but it shouldn't have any side effects).

## Simple State Manager

Get has a state manager that is extremely light and easy, which does not use ChangeNotifier, will meet the need especially for those new to Flutter, and will not cause problems for large applications.

GetBuilder is aimed precisely at multiple state control. Imagine that you added 30 products to a cart, you click delete one, at the same time that the list is updated, the price is updated and the badge in the shopping cart is updated to a smaller number. This type of approach makes GetBuilder killer, because it groups states and changes them all at once without any "computational logic" for that. GetBuilder was created with this type of situation in mind, since for ephemeral change of state, you can use setState and you would not need a state manager for this.

That way, if you want an individual controller, you can assign IDs for that, or use GetX. This is up to you, remembering that the more "individual" widgets you have, the more the performance of GetX will stand out, while the performance of GetBuilder should be superior, when there is multiple change of state.

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
// Create controller class and extends GetxController
class Controller extends GetxController {
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
class Controller extends GetxController {

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

Do not call a dispose method inside GetxController, it will not do anything, remember that the controller is not a Widget, you should not "dispose" it, and it will be automatically and intelligently removed from memory by Get. If you used any stream on it and want to close it, just insert it into the close method. Example:

```dart
class Controller extends GetxController {
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
class Controller extends GetxController {
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
class Controller extends GetxController {
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

## Mixing the two state managers

Some people opened a feature request, as they wanted to use only one type of reactive variable, and the other mechanics, and needed to insert an Obx into a GetBuilder for this. Thinking about it MixinBuilder was created. It allows both reactive changes by changing ".obs" variables, and mechanical updates via update(). However, of the 4 widgets he is the one that consumes the most resources, since in addition to having a Subscription to receive change events from his children, he subscribes to the update method of his controller.

Extending GetxController is important, as they have life cycles, and can "start" and "end" events in their onInit() and onClose() methods. You can use any class for this, but I strongly recommend you use the GetxController class to place your variables, whether they are observable or not.


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

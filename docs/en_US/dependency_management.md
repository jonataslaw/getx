
# Dependency Management

## Simple Instance Manager

Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Note: If you are using Get's State Manager, pay more attention to the bindings api, which will make easier to connect your view to your controller.

Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or Bloc class) normally

**Tip:** Get dependency management is decloupled from other parts of the package, so if for example your app is already using a state manager (any one, it doesn't matter), you don't need to rewrite it all, you can use this dependency injection with no problems at all

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
print(count); // out: 12345
```

To remove a instance of Get:

```dart
Get.delete<Controller>();
```

## Options

When you use Get.put, lazyPut and putAsync you will have some options that you can change if you want

- On Get.put():

```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: that "S" means that it can be anything
  S dependency

  // optional: this is for when you want multiple classess that are of the same type
  // since you normally get a class by using Get.find<Controller>(),
  // you need to use tag to tell which instance you need
  // must be unique string
  String tag,

  // optional: by default, get will dispose instances after they are not used anymore (example,
  // the controller of a view that is closed), but you might need that the instance
  // to be kept there throughout the entire app, like an instance of sharedPreferences or something
  // so you use this
  // defaults to false
  bool permanent = false,

  // optional: allows you after using an abstract class in a test, replace it with another one and follow the test.
  // defaults to false
  bool overrideAbstract = false,

  // optional: allows you to create the dependency using function instead of the dependency itself.
  FcBuilderFunc<S> builder,
)
```

- On Get.lazyPut:

```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  // Example: Get.lazyPut<Controller>( () => Controller() )
  FcBuilderFunc builder,
  
  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: It is similar to "permanent", the difference is that the instance is discarded when
  // is not being used, but when it's use is needed again, Get will recreate the instance
  // just the same as "SmartManagement.keepFactory" in the bindings api
  // defaults to false
  bool fenix = false
  
)
```

- On Get.putAsync:

```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  // Example: Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
  FcBuilderFuncAsync<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
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
class HomeBinding implements Bindings {

}
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

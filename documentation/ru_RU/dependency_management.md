# Управление зависимостями
- [Управление зависимостями](#управление-зависимостями)
  - [Методы создания экземпляров](#методы-создания-экземпляров)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Применение методов/классов создания экземпляров](#применение-методовклассов-создания-экземпляров)
  - [Различия между методами](#различия-между-методами)
  - [Подвязки](#подвязки)
    - [Применение](#применение)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Как подвязки работают под капотом](#как-подвязки-работают-под-капотом)
  - [Примечания](#примечания)

Get имеет простой и мощный менеджер зависимостей, позволяющий вам получить тот же класс, что и ваш Bloc или Controller, с помощью 1 строки кода, без Provider и inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

Вместо того, чтобы создавать экземпляр вашего класса в классе, который вы используете, вы создаёте его в экземпляре Get, что сделает его доступным во всем приложении.
Таким образом Вы можете использовать свой контроллер (или Bloc)

- Примечание: Если вы применяете менеджер состояний Get, обратите внимание на [Bindings](#bindings) api, упрощающего подключение вашего предсталения к контроллеру.
- Примечаие²: Управление зависимостями Get отделено от других частей пакета, поэтому, если, например, ваше приложение уже использует другой менеджер состояний, вам не нужно его менять, вы можете использовать этот менеджер внедрения зависимостей без каких-либо проблем.

## Методы создания экземпляров
Методы и настраиваемые параметры:

### Get.put()

Самый распространенный способ внедрения зависимости. Например, хорош для контроллеров ваших представлений.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Это все параметры, которые вы можете установить при использовании put:
```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: "S" means that it can be a class of any type
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
  // this one is not commonly used
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
Можно отложить загрузку зависимости, чтобы она создавалась только тогда, когда она используется. Очень полезно для вычислительных ресурсоёмких классов или если вы хотите создать экземпляры нескольких классов в одном месте (например, в классе Bindings), и вы знаете, что не собираетесь использовать этот класс в то время.

```dart
/// ApiMock will only be called when someone uses Get.find<ApiMock> for the first time
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () => {
  // ... some logic if needed
    return FirebaseAuth()
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

Это все параметры, которые вы можете установить при использовании lazyPut:
```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  InstanceBuilderCallback builder,
  
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

### Get.putAsync
Если вы хотите зарегистрировать асинхронный экземпляр, вы можете использовать `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

Это все параметры, которые вы можете установить при использовании putAsync:
```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  AsyncInstanceBuilderCallback<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
)
```

### Get.create

Это хитрый метод. Подробное объяснение того, что это такое, и различий между ними можно найти в разделе [Различия между методами](#различия-между-методами):

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Это все параметры, которые вы можете установить при использовании create:

```dart
Get.create<S>(
  // required: a function that returns a class that will be "fabricated" every
  // time `Get.find()` is called
  // Example: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // optional: just like Get.put(), but it is used when you need multiple instances
  // of a of a same class
  // Useful in case you have a list that each item need it's own controller
  // needs to be a unique string. Just change from tag to name
  String name,

  // optional: just like int`Get.put()`, it is for when you need to keep the
  // instance alive thoughout the entire app. The difference is in Get.create
  // permanent is true by default
  bool permanent = true
```

## Применение методов/классов создания экземпляров

Представьте, что вы прошли через множество маршрутов и вам нужны данные, которые остались в вашем контроллере. Вам понадобится менеджер состояний в сочетании с Provider или Get_it, верно? Только не с Get. Вам просто нужно попросить Get «найти» ваш контроллер, никаких дополнительных зависимостей вам не потребуется:

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// Yes, it looks like Magic, Get will find your controller, and will deliver it to you.
// You can have 1 million controllers instantiated, Get will always give you the right controller.
```

И тогда вы сможете восстановить данные вашего контроллера, которые были там получены:

```dart
Text(controller.textFromApi);
```

Поскольку возвращаемое значение является обычным классом, вы можете делать все, что захотите:
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Чтобы удалить экземпляр Get:

```dart
Get.delete<Controller>(); //usually you don't need to do this because GetX already delete unused controllers
```

## Различия между методами

Сперва давайте рассмотрим параметр `fenix` метода Get.lazyPut и `permanent` других методов.

Фундаментальное различие между `permanent` и `fenix` заключается в том, как вы хотите хранить свои экземпляры.

Закрепляя это: по умолчанию GetX удаляет экземпляры, когда они не используются.
Это означает, что: если на экране 1 есть контроллер 1, а на экране 2 есть контроллер 2, и вы удаляете первый маршрут из стека (например, если вы используете `Get.off()` или `Get.offNamed()`), контроллер 1 теперь не используется, поэтому он будет стёрт.

Но если вы используете `permanent: true`, тогда контроллер не будет потерян при этом переходе - что очень полезно для служб, которые вы хотите поддерживать на протяжении всего приложения.

`fenix` предназначен для сервисов, о потере которых вы не беспокоитесь между сменами экрана, но когда вам нужен этот сервис, вы ожидаете, что он будет активен. По сути, он избавится от неиспользуемого контроллера/службы/класса, но когда он вам понадобится, он «воссоздает из пепла» новый экземпляр.

Исходя из различий между методами:

- Get.put и Get.putAsync следует одному и тому же порядку создания, с той разницей, что второй использует асинхронный метод: эти два метода создают и инициализируют экземпляр. Они вставляются непосредственно в память с использованием внутреннего метода `insert` с параметрами `permanent: false` и `isSingleton: true` (параметр isSingleton предназначен только для того, чтобы указать, следует ли использовать зависимость от `dependency` или она должна использовать зависимость от `FcBuilderFunc`). После этого вызывается `Get.find()`, который немедленно инициализирует экземпляры, находящиеся в памяти.

- Get.create: Как следует из названия, он «создаст» вашу зависимость! Подобно `Get.put()`, он также вызывает внутренний метод `insert` для создания экземпляра. Но `permanent` становится true и `isSingleton` становится false (поскольку мы «создаем» нашу зависимость, она не может быть синглтоном, поэтому false). И поскольку `permanent: true`, мы по умолчанию не теряем его между экранами! Также, `Get.find()` не вызывается немедленно, он ожидает использования на экране для вызова. Он создан таким образом, чтобы использовать параметр `permanent`, `Get.create()` был создан с целью создания не общих экземпляров, но не удаляемых, как, например, кнопка в listView, где вам нужен уникальный экземпляр для этого списка - по этой причине Get.create необходимо использовать вместе с GetWidget.

- Get.lazyPut: Как следует из названия, это ленивый процесс. Экземпляр создается, но он не вызывается для немедленного использования, он остается в ожидании вызова. В отличие от других методов, `insert` не вызывается здесь. Вместо этого экземпляр вставляется в другую часть памяти, часть, отвечающую за определение возможности воссоздания экземпляра, назовем это «фабрикой». Если мы хотим создать что-то, что будет использоваться позже, это не будет смешиваться с вещами, которые использовались сейчас. И здесь вступает в силу магия `fenix`: если вы решаете оставить `fenix: false`, и ваш `smartManagement` не является `keepFactory`, то, при использовании `Get.find`, экземпляр изменит место в памяти с «фабрики» на область памяти общего экземпляра. Сразу после этого по умолчанию удаляется с «фабрики». Теперь, если вы выберете `fenix: true`, экземпляр продолжит существовать в этой выделенной части, даже перейдя в общую область, для повторного вызова в будущем.

## Bindings

One of the great differentials of this package, perhaps, is the possibility of full integration of the routes, state manager and dependency manager.
When a route is removed from the Stack, all controllers, variables, and instances of objects related to it are removed from memory. If you are using streams or timers, they will be closed automatically, and you don't have to worry about any of that.
In version 2.10 Get completely implemented the Bindings API.
Now you no longer need to use the init method. You don't even have to type your controllers if you don't want to. You can start your controllers and services in the appropriate place for that.
The Binding class is a class that will decouple dependency injection, while "binding" routes to the state manager and dependency manager.
This allows Get to know which screen is being displayed when a particular controller is used and to know where and how to dispose of it.
In addition, the Binding class will allow you to have SmartManager configuration control. You can configure the dependencies to be arranged when removing a route from the stack, or when the widget that used it is laid out, or neither. You will have intelligent dependency management working for you, but even so, you can configure it as you wish.

### Bindings class

- Create a class and implements Binding

```dart
class HomeBinding implements Bindings {}
```

Your IDE will automatically ask you to override the "dependencies" method, and you just need to click on the lamp, override the method, and insert all the classes you are going to use on that route:

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<Service>(()=> Api());
  }
}

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
```

Now you just need to inform your route, that you will use that binding to make the connection between route manager, dependencies and states.

- Using named routes:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: DetailsBinding(),
  ),
];
```

- Using normal routes:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

There, you don't have to worry about memory management of your application anymore, Get will do it for you.

The Binding class is called when a route is called, you can create an "initialBinding in your GetMaterialApp to insert all the dependencies that will be created.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

The default way of creating a binding is by creating a class that implements Bindings.
But alternatively, you can use `BindingsBuilder` callback so that you can simply use a function to instantiate whatever you desire.

Example:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

That way you can avoid to create one Binding class for each route making this even simpler.

Both ways of doing work perfectly fine and we want you to use what most suit your tastes.

### SmartManagement

GetX by default disposes unused controllers from memory, even if a failure occurs and a widget that uses it is not properly disposed.
This is what is called the `full` mode of dependency management.
But if you want to change the way GetX controls the disposal of classes, you have `SmartManagement` class that you can set different behaviors.

#### How to change

If you want to change this config (which you usually don't need) this is the way:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //here
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

It is the default one. Dispose classes that are not being used and were not set to be permanent. In the majority of the cases you will want to keep this config untouched. If you new to GetX then don't change this.

#### SmartManagement.onlyBuilders
With this option, only controllers started in `init:` or loaded into a Binding with `Get.lazyPut()` will be disposed.

If you use `Get.put()` or `Get.putAsync()` or any other approach, SmartManagement will not have permissions to exclude this dependency.

With the default behavior, even widgets instantiated with "Get.put" will be removed, unlike SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Just like SmartManagement.full, it will remove it's dependencies when it's not being used anymore. However, it will keep their factory, which means it will recreate the dependency if you need that instance again.

### How bindings work under the hood
Bindings creates transitory factories, which are created the moment you click to go to another screen, and will be destroyed as soon as the screen-changing animation happens.
This happens so fast that the analyzer will not even be able to register it.
When you navigate to this screen again, a new temporary factory will be called, so this is preferable to using SmartManagement.keepFactory, but if you don't want to create Bindings, or want to keep all your dependencies on the same Binding, it will certainly help you.
Factories take up little memory, they don't hold instances, but a function with the "shape" of that class you want.
This has a very low cost in memory, but since the purpose of this lib is to get the maximum performance possible using the minimum resources, Get removes even the factories by default.
Use whichever is most convenient for you.

## Notes

- DO NOT USE SmartManagement.keepFactory if you are using multiple Bindings. It was designed to be used without Bindings, or with a single Binding linked in the GetMaterialApp's initialBinding.

- Using Bindings is completely optional, if you want you can use `Get.put()` and `Get.find()` on classes that use a given controller without any problem.
However, if you work with Services or any other abstraction, I recommend using Bindings for a better organization.

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
    - [Класс Bindings](#класс-bindings)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Как поменять](#как-поменять)
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

## Подвязки

Возможно, одной из главных особенностей этого пакета является возможность полной интеграции маршрутов, менеджера состояний и менеджера зависимостей.
Когда маршрут удаляется из стека, все контроллеры, переменные и экземпляры связанных с ним объектов удаляются из памяти. Если вы используете потоки или таймеры, они закроются автоматически, и вам не о чем беспокоиться.
В версии 2.10 полностью реализован API привязок.
Теперь вам больше не нужно использовать метод инициализации. Вам даже не нужно вводить контроллеры, если вы этого не хотите. Вы можете запустить свои контроллеры и серисы в соответствующем для этого месте.
Класс Binding - это класс, который будет разделять внедрение зависимостей, при этом «привязывая» маршруты к диспетчеру состояний и диспетчеру зависимостей.
Этот класс позволяет Get узнать, какой экран отображается при использовании конкретного контроллера, а также узнать, где и как его удалить.
Кроме того, класс Binding позволит вам контролировать конфигурацию SmartManager. Вы можете настроить зависимости, которые будут упорядочены при удалении маршрута из стека, или когда виджет, который его использовал, выкладывается, или ни то, ни другое. На вас будет работать интеллектуальное управление зависимостями, но даже в этом случае вы можете настроить его по своему усмотрению.

### Класс Bindings

- Создайте класс и реализуйте Binding

```dart
class HomeBinding implements Bindings {}
```

Ваша IDE автоматически попросит вас переопределить метод «зависимостей», и вам просто нужно последовать этой просьбе, переопределить метод и вставить все классы, которые вы собираетесь использовать на этом маршруте:

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

Теперь вам просто нужно сообщить своему маршруту, что вы будете использовать эту привязку для установления связи между диспетчером маршрутов, зависимостями и состояниями.

- Используя именованные маршруты:

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

- Используя обычные маршруты:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Вам больше не нужно беспокоиться об управлении памятью вашего приложения, Get сделает это за вас.

Класс Binding вызывается при вызове маршрута, вы можете создать "initialBinding" в GetMaterialApp, чтобы вставить все зависимости, которые будут созданы.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

По умолчанию привязка создается путем создания класса, реализующего привязки.
Но в качестве альтернативы вы можете использовать обратный вызов `BindingsBuilder`, чтобы просто использовать функцию для создания всего, что вы хотите.

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

Таким образом, вы можете избежать создания одного класса привязки для каждого маршрута, что сделает это еще проще.

Оба способа работают идеально, и мы хотим, чтобы вы использовали то, что больше всего соответствует вашим вкусам.

### SmartManagement

GetX по умолчанию удаляет неиспользуемые контроллеры из памяти, даже если происходит сбой и виджет, который их использует, не удаляется должным образом.
Это то, что называется `полным` режимом управления зависимостями.
Но если вы хотите поменять способ, которым GetX управляет удалением классов, у вас есть класс `SmartManagement`, в котором вы можете задавать другое поведение.

#### Как поменять

Если вы хотите поменять эту конфигурацию (что обычно не требуется), вот способ:

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

Это значение по умолчанию. Удаляет классы, которые не используются и не были постоянными. В большинстве случаев вы захотите оставить эту конфигурацию нетронутой. Если вы новичок в GetX, не меняйте это.

#### SmartManagement.onlyBuilders
С этой опцией будут удалены только контроллеры, запущенные в `init:` или загруженные в Binding с помощью `Get.lazyPut()`.

Если вы используете `Get.put()` или `Get.putAsync()` или любой другой подход, SmartManagement не будет иметь разрешений на исключение этой зависимости.

При поведении по умолчанию даже виджеты, созданные с помощью Get.put, будут удалены, в отличие от SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Как и SmartManagement.full, он удаляет зависимости, когда он больше не используется. Однако он сохранит свою фабрику, что означает, что он воссоздает зависимость, если вам снова понадобится этот экземпляр.

### Как подвязки работают под капотом
Привязки создают временные фабрики, которые создаются в тот момент, когда вы кликаете для перехода на другой экран, и будут уничтожены, как только произойдет анимация смены экрана.
Это происходит так быстро, что анализатор даже не сможет это зарегистрировать.
Когда вы снова перейдете на этот экран, будет вызвана новая временная фабрика, поэтому это предпочтительнее, чем использование SmartManagement.keepFactory, но если вы не хотите создавать привязки или хотите сохранить все свои зависимости в одной привязке, это вам поможет.
Фабрики занимают мало памяти, они содержат не экземпляры, а функцию с «формой» того класса, который вам нужен.
Это имеет очень низкую стоимость памяти, но поскольку цель этой библиотеки - получить максимально возможную производительность с использованием минимальных ресурсов, Get по умолчанию удаляет даже фабрики. Используйте то, что вам удобнее.

## Примечания

- НЕ ИСПОЛЬЗУЙТЕ SmartManagement.keepFactory, если вы используете несколько привязок. Он был разработан для использования без привязок или с одной привязкой, связанной в initialBinding GetMaterialApp.

- Использование привязок совершенно необязательно, если вы хотите, вы можете без проблем использовать `Get.put()` и `Get.find()` для классов, которые используют данный контроллер.
Однако, если вы работаете со службами или любой другой абстракцией, я рекомендую использовать привязки для лучшей организации.

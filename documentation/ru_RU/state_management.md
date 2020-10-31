- [Управление состоянием](#управление-состоянием)
  - [Реактивное управление состоянием](#реактивное-управление-состоянием)
    - [Преимущества](#преимущества)
    - [Объявление реактивной переменной](#объявление-реактивной-переменной)
    - [Использование значений в представлении](#использование-значений-в-представлении)
    - [Условия для перестраивания](#условия-для-перестраивания)
    - [Где .obs может быть использован](#где-obs-может-быть-использован)
    - [Примечание о списках](#примечание-о-списках)
    - [Почему мне нужно использовать .value](#почему-мне-нужно-использовать-value)
    - [Obx()](#obx)
    - [Workers](#workers)
  - [Обычное управление состоянием](#обычное-управление-состоянием)
    - [Преимущества](#преимущества-1)
    - [Использование](#использование)
    - [Как обрабатываются контроллеры](#как-обрабатываются-контроллеры)
    - [Вам больше не понадобятся StatefulWidgets](#вам-больше-не-понадобятся-statefulwidgets)
    - [Почему это существует](#почему-это-существует)
    - [Другие способы использования](#другие-способы-использования)
    - [Уникальные идентификаторы](#уникальные-идентификаторы)
  - [Смешивание двух менеджеров состояний](#смешивание-двух-менеджеров-состояний)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# Управление состоянием

В настоящее время для Flutter есть несколько менеджеров состояний. Однако большинство из них связано с использованием ChangeNotifier для обновления виджетов, и это плохой и очень плохой подход к производительности средних или больших приложений. Вы можете проверить в официальной документации Flutter, что [ChangeNotifier следует использовать с 1 или максимум 2 слушателями](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), что делает его практически непригодным для любого приложения среднего или большого размера.

Остальные менеджеры состояний хороши, но есть свои нюансы:

- BLoC безопасен и эффективен, но сложен для новичков, что удерживает людей от разработки с Flutter.
- MobX проще, чем BLoC, реактивен, и я бы сказал, почти идеален, но вам нужно использовать генератор кода, который для больших приложений снижает производительность, таким образом вам нужно будет пить много кофе, прежде чем ваш код снова не будет готов после flutter clean (И это не вина MobX, а вина кодогенерации, которая очень медленная!).
- Provider использует InheritedWidget для доставки слушателя в качестве способа решения проблемы, описанной выше, с помощью ChangeNotifier, что подразумевает, что любой доступ к классу ChangeNotifier должен находиться в дереве виджетов из-за контекста для доступа к Inherited.

Get не лучше и не хуже, чем любой другой менеджер состояний, но вам следует проанализировать эти моменты, а также приведенные ниже пункты, чтобы выбрать между использованием Get в чистом виде (Vanilla) или его вместе с другим менеджером состояний. Определенно, Get - не враг любого другого менеджера состояний, потому что Get - это микрофреймворк, а не просто менеджер состояний, и его можно использовать отдельно или вместе с ними.

## Реактивное управление состоянием

Реактивное программирование может оттолкнуть многих людей, потому что считается сложным. GetX превращает реактивное программирование в нечто довольно простое:

- Вам не нужно создавать StreamControllers.
- Вам не нужно создавать StreamBuilder для каждой переменной.
- Вам не нужно создавать класс для каждого состояния.
- Вам не нужно создавать получение начального значения.

Реактивное программирование с помощью Get так же просто, как использование setState.

Представим, что у вас есть переменная `name` и вы хотите, чтобы каждый раз, когда вы её изменяете, все виджеты, которые её используют, менялись автоматически.

Это ваша переменная:

```dart
var name = 'Jonatas Borges';
```

Чтобы сделать его наблюдаемым, вам просто нужно добавить в конец «.obs»:

```dart
var name = 'Jonatas Borges'.obs;
```

Вот и всё. Это *так* просто.

С этого момента мы могли бы называть эти - ".obs" (ervables) переменные как _Rx_.

Что мы делали под капотом? Мы создали `Stream` из `String`ов, которому было присвоено начальное значение `"Jonatas Borges"`, мы уведомили все виджеты, которые используют `"Jonatas Borges"`, что они теперь «принадлежат» этой переменной, и когда значение _Rx_ изменится, они также должны будут измениться.

Это **волшебство GetX** возможно, благодаря возможностям Dart.

Но, как мы знаем, виджет можно изменить только в том случае, если он находится внутри функции, потому что статические классы не имеют права «автоматически изменяться».

Вам нужно будет создать `StreamBuilder`, подписаться на эту переменную, чтобы отслеживать изменения, и создать «каскад» вложенных `StreamBuilder`, если вы хотите изменить несколько переменных в одной области, верно?

Нет, вам не нужен `StreamBuilder`, но насчёт статических классов вы правы.

Что ж, в представлении во Flutter, когда мы хотим изменить конкретный виджет, приходится писать много шаблоного кода.
C **GetX** вы можете забыть о шаблонном коде. 

`StreamBuilder( … )`? `initialValue: …`? `builder: …`? Nope, you just need to place this variable inside an `Obx()` Widget.

```dart
Obx (() => Text (controller.name));
```

_Что нужно запомнить?_  Только `Obx(() =>`. 

Вы просто передаёте этот виджет через стрелочную функцию в `Obx()` ("Observer" в _Rx_). 

`Obx` довольно умён и изменится только при изменении значения `controller.name`. 

Если `name` == `"John"`, и вы измените его на `"John"` (`name.value = "John"`), на экране ничего не изменится, так как это то же значение, что и раньше. `Obx` для экономии ресурсов просто проигнорирует новое значение, а не будет перестраивать виджет. **Разве это не потрясающе?**

> Итак, что, если у меня есть 5 переменных _Rx_ (observable) в `Obx`?

Он просто обновится, когда **любой** из них изменится. 

> И если у меня есть 30 переменных в классе, когда я обновлю одну, обновятся ли **все** переменные этого класса?

Нет, только **конкретный виджет**, который использует эту переменную _Rx_.

Итак, **GetX** обновляет экран только тогда, когда переменная _Rx_ меняет свое значение.

```
final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```
### Преимущества

**GetX()** поможет вам, когда вам нужен **детальный** контроль над тем, что обновляется.

Если вам не нужны уникальные идентификаторы, из-за того что все ваши переменные будут изменены при выполнении, используйте GetBuilder, потому что это простой модуль обновления состояния (как `setState()`), написанный всего в несколько строк кода.
Он был сделан простым, чтобы иметь наименьшее влияние на CPU и просто выполнять единственную цель (восстановление состояния), тратя минимально возможные ресурсы.

Если вам нужен **мощный** менеджер состояний, то вашим выбором будет **GetX**.

Он не работает с переменными, а работает с потоками, все в нем - это `Streams` под капотом.
Вы можете использовать _rxDart_ вместе с ним, потому что все это `Streams`,
вы можете прослушивать событие каждой «переменной _Rx_», потому что всё в нём - это `Streams`.

Это буквально подход _BLoC_, который проще, чем _MobX_, и без генераторов кода и тд.
Вы можете превратить что угодно в _"Observable"_ с помощью `.obs`.

### Максимальная производительность:

В дополнение к интеллектуальному алгоритму минимальных перестроек, **GetX** использует компараторы, чтобы убедиться, что состояние изменилось.

Если вы столкнетесь с ошибками в своем приложении и отправите дублирующее изменение состояния,
**GetX** гарантирует, что оно не выйдет из строя.

С **GetX** состояние изменяется только при изменении значения.
В этом основное отличие между **GetX** и применением _`computed` из MobX_.
При объединении двух __observables__, когда один из них изменяется; слушатель этого _observable_ также изменится.

В **GetX**, iесли вы объедините две переменные, `GetX()` (аналогично `Observer()`) будет перестраиваться только в том случае, если это подразумевает реальное изменение состояния.

### Объявление реактивной переменной

У вас есть 3 способа превратить переменную в "observable".


1 - Первый использует **`Rx{Type}`**.

```dart
// initial value is recommended, but not mandatory
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - Второй - использовать **`Rx`** и дженерики `Rx<Type>`

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

3 - Третий, более практичный, простой и предпочтительный подход, просто добавьте **`.obs`** в качестве свойства вашего значения:

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

##### Реактивные состояния - это просто.

Как мы знаем,, _Dart_ сейчас движется в сторону _null safety_.
Чтобы быть готовым, с этого момента вы всегда должны начинать свои переменные _Rx_ с **начальным значением**.

> Преобразование переменной в _observable_ + _начальное значение_ c **GetX** - самый простой и практичный подход.

Вы буквально добавите "`.obs`" в конец своей переменной и **всё**, вы сделали её observable,
и её `.value`, будет начальным значением.


### Использование значений в представлении

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

Если мы увеличим `count1.value++`, он выведет:
- `count 1 rebuild` 
- `count 3 rebuild`

поскольку `count1` имеет значение `1`, а `1 + 0 = 1`, изменяет геттер `sum`.

Если мы изменим `count2.value++`, он выведет:
- `count 2 rebuild` 
- `count 3 rebuild`

так как `count2.value` изменился, и теперь `sum` равен `2`.

- Примечание: По умолчанию самое первое событие перестраивает виджет, даже если это то же значение.
 Такое поведение существует из-за Boolean переменных.

Представьте, что вы сделали это:

```dart
var isLogged = false.obs;
```

А затем вы проверили, вошел ли пользователь в систему, чтобы вызвать событие в `ever`.

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

Если `hasToken` был `false`, `isLogged` не изменится, поэтому `ever()` никогде не будет вызван.
Чтобы избежать такого поведения, первое изменение _observable_ всегда будет запускать событие, даже если оно содержит то же самое `.value`.

Вы можете убран данное поведение, если хотите, используя:
`isLogged.firstRebuild = false;`

### Условия для перестраивания

Кроме того, Get обеспечивает усовершенствованный контроль состояния. Вы можете обусловить событие (например, добавление объекта в список) определенным условием.

```dart
// First parameter: condition, must return true of false
// Second parameter: the new value to aplly if the condition is true
list.addIf(item < limit, item);
```

Без украшений, без генератора кода, без сложностей :smile:

Вы ведь знаете счётчик Flutter? Ваш класс контроллера может выглядеть так:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

С простым:

```dart
controller.count.value++
```

Вы можете обновить переменную счетчика в своем пользовательском интерфейсе, независимо от того, где она хранится.

### Где .obs может быть использован

Вы можете преобразовать что угодно в obs. Вот два способа сделать это:

* Вы можете преобразовать значения вашего класса в obs
```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* или вы можете преобразовать весь класс в observable
```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

### Примечание о списках

Списки полностью наблюдаемы, как и объекты внутри них. Таким образом, если вы добавите значение в список, он автоматически перестроит виджеты, которые его используют.

Вам также не нужно использовать ".value" со списками, замечательный API-интерфейс Dart позволяет нам избежать этого.
К сожалению, примитивные типы, такие как String и int, не могут быть расширены, что делает использование .value обязательным, но это не будет проблемой, если вы работаете с геттерами и сеттерами для них.

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

Когда вы делаете свои собственные классы наблюдаемыми, есть другой способ их обновить:

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

Вам не нужно работать с наборами, если вы этого не хотите, вы можете использовать API "assign" и "assignAll".
API "assign" очистит ваш список и добавит один объект, который вы хотите начать там.
API "assignAll" очистит существующий список и добавит любые повторяемые объекты, которые вы в него вставляете.

### Почему мне нужно использовать .value

Мы могли бы убрать обязательство использовать 'value' для `String` и `int` с помощью простого оформления и генератора кода, но цель этой библиотеки как раз и состоит в том, чтобы избежать внешних зависимостей. Мы хотим предложить среду, готовую для программирования, включающую в себя самое необходимое (управление маршрутами, зависимостями и состояниями) простым, легким и производительным способом без необходимости во внешнем пакете.

Вы можете буквально добавить 3 буквы в свой pubspec (get), двоеточие и начать программировать. Все решения, включенные по умолчанию, от управления маршрутами до управления состоянием, нацелены на простоту, продуктивность и производительность.

Общий вес этой библиотеки меньше, чем у одного менеджера состояний, хотя это полное решение, и это то, что вы должны понимать.

Если вас беспокоит `.value`, и вам нравится генератор кода, MobX - отличная альтернатива, и вы можете использовать его вместе с Get. Для тех, кто хочет добавить одну зависимость в pubspec и начать программировать, не беспокоясь ни о совместимости версий пакетов, ни об ошибках обновления состояния исходящих от менеджеров состояний или зависимостей и не хочет беспокоиться о доступности контроллеров, а «просто программирование», Get идеален.

Если у вас нет проблем с MobX или BLoC, вы можете просто использовать Get для маршрутов и забыть о том, что у него есть менеджер состояний. Простой и реактивный менеджеры состояний Get появились из-за то, что в моей компании был проект с более чем 90 контроллерами, а генератору кода после flutter clean требовалось более 30 минут для выполнения своих задач на достаточно хорошей машине. Если у вас 5, 10, 15 контроллеров, то вам подойдёт любой менеджер состояний. Если у вас абсурдно большой проект и генератор кода является для вас проблемой, то решение прямо перед вами.

Очевидно, что если кто-то хочет внести свой вклад в проект и создать генератор кода или что-то подобное, я укажу об этом в readme в качестве альтернативы. Моя потребность не в востребованности для всех разработчиков, я лишь говорю, что есть хорошие решения, которые уже делают это, например, MobX.

### Obx()

Bindings в Get необязательны. Вы можете использовать виджет Obx вместо GetX, который получает только анонимную функцию, создающую виджет.
Очевидно, что если вы не используете тип, вам потребуется экземпляр вашего контроллера для использования переменных или использовать `Get.find<Controller>()`.value или Controller.to.value для получения значения.

### Workers

Workers помогут вам, инициируя определенные обратные вызовы при возникновении события.

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
У всех workers (кроме `debounce`) есть именованный параметр `condition`, которое может быть `bool` или обратным вызовом возвращающим `bool`.
Этот `condition` определяет, когда выполняется функция обратного вызова.

Все workers возвращают экземпляр `Worker`, который можно использовать для отмены (с помощью метода `dispose()`) worker.
 
- **`ever`**
 вызывается каждый раз, когда переменная _Rx_ выдает новое значение.

- **`everAll`**
 как `ever`, но он принимает `List` значений _Rx_ вызываемый каждый раз, когда его переменная изменяется. Вот и всё.


- **`once`**
'once' вызывается только при первом изменении переменной.

- **`debounce`**
'debounce' очень полезен в функциях поиска, где вы хотите, чтобы API вызывался только тогда, когда пользователь заканчивает ввод. Если пользователь вводит "Jonny", у вас будет 5 поисковых запросов в API по буквам J, o, n, n и y. С Get этого не происходит, потому что у вас будет "debounce" Worker, который будет запускаться только в конце набора.

- **`interval`**
'interval' отличается от `debouce`. В `debouce`, если пользователь внесёт 1000 изменений в переменную в течение 1 секунды, он отправит только последнее после установленного таймера (по умолчанию 800 миллисекунд). Вместо этого Interval будет игнорировать все действия пользователя в течение указанного периода. Если вы отправляете события в течение 1 минуты, 1000 в секунду, debounce отправит вам только последнее, когда пользователь прекратит стрелять событиями. Interval будет доставлять события каждую секунду, а если установлен на 3 секунды, то он будет доставлять 20 событий в эту минуту. Это рекомендуется во избежание злоупотреблений в функциях, где пользователь может быстро щелкнуть что-либо и получить некоторое преимущество (представьте, что пользователь может зарабатывать монеты, щелкая что-либо, если он щелкнет 300 раз за ту же минуту, у него будет 300 монет, используя интервал, вы можете установить временной интервал на 3 секунды, и даже если щелкнуть 300 или тысячу раз, максимум, который он получит за 1 минуту, составит 20 монет, щелкнув 300 или 1 миллион раз). Debounce подходит для защиты от DDos, для таких функций, как поиск, где каждое изменение onChange будет вызывать запрос к вашему API. Debounce будет ждать, пока пользователь перестанет вводить имя, чтобы сделать запрос. Если бы он использовался в вышеупомянутом сценарии с монетами, пользователь накликал бы только 1 монету, потому что он выполняется только тогда, когда пользователь "делает паузу" на установленное время.

- ПРИМЕЧАНИЕ: должны всегда использоваться при запуске контроллера или класса, поэтому он всегда должен быть в onInit (рекомендуется), в конструкторе класса или в initState StatefulWidget (в большинстве случаев эта практика не рекомендуется, но не должна иметь побочных эффектов).

## Обычное управление состоянием

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
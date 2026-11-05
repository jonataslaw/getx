> GetX 5 RC: Этот кандидат ещё не опубликован. Проверенная основа — Flutter 3.47.9 и Dart 3.13.7 со встроенными UI-библиотеками Flutter.

[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

_Языки: Русский (этот файл), [вьетнамский](README-vi.md), [индонезийский](README.id-ID.md), [урду](README.ur-PK.md), [Английский](README.md), [Китайский](README.zh-cn.md), [Бразильский Португальский](README.pt-br.md), [Испанский](README-es.md), [Польский](README.pl.md), [Kорейский](README.ko-kr.md), [French](README-fr.md)._

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![popularity](https://badges.bar/get/popularity)](https://pub.dev/packages/sentry/score)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
[![pub points](https://badges.bar/get/pub%20points)](https://pub.dev/packages/get/score)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)
[![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)
<a href="https://github.com/Solido/awesome-flutter">
<img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)

## Содержание

  - [Изменения GetX 5 в этой ветке](#getx5-current)
- [Про Get](#readme-section-2)
- [Установка](#readme-section-3)
- [Приложение "Счётчик" с GetX](#readme-section-4)
- [Три столпа](#readme-section-5)
  - [Управление состоянием](#readme-section-6)
    - [Реактивное управление состоянием](#readme-section-7)
    - [Подробнее об управлении состоянием](#readme-section-8)
  - [Управление маршрутами](#readme-section-9)
    - [Подробнее об управлении маршрутами](#readme-section-10)
  - [Внедрение зависимостей](#readme-section-11)
    - [Подробнее о внедрении зависимостей](#readme-section-12)
- [Утилиты](#readme-section-13)
  - [Интернационализация](#readme-section-14)
    - [Переводы](#readme-section-15)
    - [Использование переводов](#readme-section-16)
    - [Локализация](#readme-section-17)
    - [Изменение локализации](#readme-section-18)
    - [Системная локализация](#readme-section-19)
  - [Изменение темы](#readme-section-20)
  - [Другие API](#readme-section-21)
    - [Дополнительные глобальные настройки и ручные настройки](#readme-section-22)
    - [Локальные виджеты состояния](#readme-section-23)
    - [ValueBuilder](#readme-section-24)
    - [ObxValue](#readme-section-25)
  - [Полезные советы](#readme-section-26)
    - [GetView](#readme-section-27)
    - [GetWidget](#readme-section-28)
    - [GetxService](#readme-section-29)
- [Критические изменения по сравнению с версией 2.0](#readme-section-30)
- [Почему Getx?](#readme-section-31)
- [Сообщества](#readme-section-32)
  - [Каналы сообщества](#readme-section-33)
  - [Как внести свой вклад](#readme-section-34)
  - [Статьи и видео](#readme-section-35)

<a id="getx5-current"></a>

## Изменения GetX 5 в этой ветке

Этот кандидат ещё не опубликован. Проверенная основа — Flutter 3.47.9 и Dart 3.13.7 со встроенными UI-библиотеками Flutter.

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

Binding возвращает `List<Bind>`. Используйте binds для приложения и bindings для маршрута. Get.spawn заменяет Get.create; дождитесь асинхронной инициализации, затем зарегистрируйте значение через Get.put.

```dart
class RcNamesController extends GetxController with StateMixin<List<String>> {
  final labels = RxSet<String>();

  void showNames(List<String> names) =>
      change(GetStatus<List<String>>.success(names));

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
}

class RcNamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<RcNamesController>(() => RcNamesController()),
  ];
}

Widget rcNamesApplication() => GetMaterialApp(
  restorationScopeId: 'names-app',
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      restorationId: 'names',
      bindings: [RcNamesBinding()],
      page: () => Scaffold(
        body: Get.find<RcNamesController>().obx(
          (names) => Text(names.join(', ')),
          onEmpty: const Text('No data'),
          onError: (error) => Text(error ?? 'Unknown error'),
        ),
      ),
    ),
  ],
);
```

`GetStatus<T>.success(data)` содержит данные. futurize принимает функцию создания Future и возвращает void; результаты применяются по порядку завершения. Пустые Rx-коллекции имеют независимое изменяемое хранилище.

Навигация использует Navigator 2. Get.back возвращает страницы; диалоги, sheets и snackbar закрывайте специальными helper. Get.context и Get.overlayContext могут быть null вне времени жизни приложения.

Задайте restorationScopeId и стабильные restorationId для истории именованных маршрутов. Аргументы совместимы с JSON, ограничены по размеру и проверяются middleware; после гибели процесса создаются новые контроллеры и Future.

Исправлены удаление response modifiers и ошибки авторизации, timeout, отмены и декодирования. HTTP/WebSocket проверяются в IO, браузере и JS/WASM с освобождением ресурсов.

Ограничение percent-encoding истории браузера во Flutter 3.47.9 остаётся; обычные web-тесты не означают его исправление. Проверяйте refresh, back и восстановление на реальном хосте и устройстве.

Задавайте параметры GetMaterialApp или GetCupertinoApp вместо старого Get.config. Собственному router нужна согласованная конфигурация Navigator 2.

В redirectDelegate верните route для продолжения, другой RouteDecoder для перенаправления или null для отмены. Зарегистрируйте login и избегайте циклов.

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# Про Get

- GetX  - это сверхлегкое и мощное решение для Flutter. Оно совмещает в себе высокопроизводительное управление состоянием, интеллектуальное внедрение зависимостей, управление маршрутами быстрым и практичным способом.

- GetX имеет 3 базовых принципа, являющихся приоритетом для всех ресурсов в библиотеке

  - **Производительность:** GetX сфокусирован на производительности и минимальном потреблении ресурсов. Бенчмарки почти всегда не имеют значения в реальном мире, но, если Вам угодно, здесь ([бенчмарки](https://github.com/jonataslaw/benchmarks)) есть индикаторы потребления, где GetX работает лучше, чем другие подходы к управлению состоянием. Разница небольшая, но демонстрирует нашу заботу о ресурсах.
  - **Продуктивность:** GetX использует простой и приятный синтаксис. Не имеет значения, что вы хотите сделать, всегда есть более легкий способ с GetX. Это сэкономит часы разработки и обеспечит максимальную производительность, которую может обеспечить ваше приложение.
  - **Организация:** GetX позволяет полностью разделить представление, логику представления, бизнес-логику, внедрение зависимостей и навигацию. Вам не нужен контекст для навигации между маршрутами, поэтому вы не зависите от дерева виджетов. Вам не нужен контекст для доступа к вашим контроллерам / блокам через наследуемый виджет, поэтому вы полностью отделяете логику представления и бизнес-логику от уровня визуализации. Вам не нужно внедрять классы Controllers / Models / Blocs в дерево виджетов через мультипровайдеры, поскольку GetX использует собственную функцию внедрения зависимостей, полностью отделяя DI от его представления.
    С GetX вы знаете, где найти каждую функцию вашего приложения, имея чистый код по умолчанию. Это, помимо упрощения обслуживания, делает возможным совместное использование модулей, что до того момента во Flutter было немыслимо.
    BLoC был отправной точкой для организации кода во Flutter, он отделяет бизнес-логику от визуализации. Getx является естественным развитием этого, разделяя не только бизнес-логику, но и логику представления. Дополнительное внедрение зависимостей и маршрутов также разделено, и уровень данных не учитывается. Вы знаете, где все находится, и это проще, чем написать "Hello World".
    GetX - это самый простой, практичный и масштабируемый способ создания высокопроизводительных приложений с помощью Flutter SDK с большой экосистемой вокруг него, которая отлично работает, прост для новичков и точен для экспертов. Он безопасен, стабилен, актуален и предлагает огромный набор встроенных API, которых нет в Flutter SDK по умолчанию.

- GetX не раздут. Он имеет множество функций, которые позволяют вам начать программировать, ни о чем не беспокоясь, но каждая из этих функций находится в отдельных контейнерах и запускается только после использования. Если вы используете только управление состоянием, то будет скомпилировано только управление состоянием. Если вы используете маршрутизацию, то ничего из управления состоянием не будет скомпилировано. Вы можете воспользоваться репозиторием бенчмарка, и вы увидите, что используя только управление состоянием Get, приложение, которое скомпилировано с помощью Get, имеет меньший размер, чем приложения использующие другие пакеты для управления состоянием, потому что всё, что не используется, не будет скомпилировано в Ваш код. Таким образом каждое решение GetX было спроектировано, чтобы быть сверхлёгким. Также в этом есть и заслуга Flutter, который умеет устранять неиспользуемые ресурсы, как ни один другой фреймворк.

- Getx имеет огромную экосистему, способную работать с одним и тем же кодом на Android, iOS, в Интернете, Mac, Linux, Windows и на вашем сервере.
**С помощью [Get Server](https://github.com/jonataslaw/get_server) ваш код, созданный на веб-интерфейсе, можно повторно использовать на вашем сервере.**

**Кроме того, весь процесс разработки может быть полностью автоматизирован как на сервере, так и во внешнем интерфейсе с помощью [Get CLI](https://github.com/jonataslaw/get_cli)**.

**Кроме того, для дальнейшего повышения вашей продуктивности у нас есть [расширение для VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) и [расширение для Android Studio / Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets).**

<a id="readme-section-3"></a>

# Установка

Добавьте Get в файл pubspec.yaml:

```yaml
dependencies:
  get:
```

Импортируйте Get в файлы, в которых планируете его использовать:

```dart
import 'package:get/get.dart';
```

<a id="readme-section-4"></a>

# Приложение "Счётчик" с GetX

Проект "Счётчик", созданный по умолчанию для нового проекта на Flutter, имеет более 100 строк (с комментариями). Чтобы показать возможности Get, я продемонстрирую, как сделать "Счётчик", изменяющий состояние при каждом клике, переключении между страницами и передаче состояния между экранами. Всё это вместе с разделением бизнес логики от представления занимает ВСЕГО ЛИШЬ 26 СТРОК КОДА, ВКЛЮЧАЯ КОММЕНТАРИИ.

- Шаг 1:
  Добавьте "Get" перед вашим MaterialApp, превращая его в GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Примечание: это не изменяет MaterialApp, GetMaterialApp не является модифицированным MaterialApp, это просто предварительно настроенный виджет, у которого в качестве дочернего по умолчанию используется MaterialApp. Вы можете настроить это вручную, но это не обязательно. GetMaterialApp будет создавать маршруты, вводить их, вводить переводы, вводить всё, что вам нужно для навигации. Если вы используете Get только для управления состоянием или зависимостями, нет необходимости использовать GetMaterialApp. GetMaterialApp необходим для навигации, снекбаров, интернационализации, bottomSheets, диалогов и API, связанных с маршрутами и отсутствием контекста.
- Примечание²: Этот шаг необходим только в том случае, если вы собираетесь использовать управление маршрутами (`Get.to()`, `Get.back()` и так далее). Если вы не собираетесь его использовать, то шаг 1 выполнять необязательно.

- Шаг 2:
  Создайте свой класс бизнес-логики и поместите в него все переменные, методы и контроллеры.
  Вы можете сделать любую переменную наблюдаемой, используя простой ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Шаг 3:
  Создайте свой View, используйте StatelessWidget и сэкономьте немного оперативной памяти, с Get вам больше не нужно использовать StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {
    
    // Создайте экземпляр вашего класса с помощью Get.put(), чтобы сделать его доступным для всех "дочерних" маршрутов.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Используйте Obx(()=> чтобы обновить Text() как только count изменится.
      appBar: AppBar(title: Obx(() => Text("Кликов: ${c.count}"))),

      // Замените 8 строк Navigator.push простым Get.to(). Вам не нужен context!
      body: Center(child: ElevatedButton(
              child: Text("Перейти к Other"), onPressed: () => Get.to(() => Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // "Попросите" Get найти и предоставить вам ваш Controller, используемый на другой странице.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Получите доступ к обновленной переменной count
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Результат:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Это простой проект, но он уже дает понять, насколько мощным является Get. По мере роста вашего проекта эта разница будет становиться все более значительной.

Get был разработан для работы с командами, но он упрощает работу отдельного разработчика.

Оптимизируйте ваши сроки, доставляйте всё вовремя без потери производительности. Get не для всех, но, если вы идентифицировали себя с предыщим предложением, Get для вас!

<a id="readme-section-5"></a>

# Три столпа

<a id="readme-section-6"></a>

## Управление состоянием

В настоящее время для Flutter есть несколько менеджеров состояний. Однако большинство из них связано с использованием ChangeNotifier для обновления виджетов, и это плохой и очень плохой подход к производительности для средних или больших приложений. Вы можете проверить в официальной документации Flutter, что [ChangeNotifier следует использовать с 1 или максимум 2 слушателями](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), что делает его практически непригодным для любого приложения среднего или большого размера.

Get не лучше и не хуже, чем любой другой менеджер состояний, но вам следует проанализировать его, а также пункты ниже, чтобы выбрать между использованием Get в чистой форме (Vanilla), либо совместно с другим менеджером состояний.

Определенно, Get не враг любого другого менеджера состояний, потому что Get - это микрофреймворк, а не просто менеджер состояний, и его можно использовать отдельно или вместе с ними.

Get имеет два разных менеджера состояний: простой менеджер состояний (мы назовем его GetBuilder) и реактивный менеджер состояний (который называется GetX).

<a id="readme-section-7"></a>

### Реактивное управление состоянием

Реактивное программирование может оттолкнуть многих людей, потому что считается сложным. GetX превращает реактивное программирование в нечто довольно простое:

- Вам не нужно создавать StreamControllers.
- Вам не нужно создавать StreamBuilder для каждой переменной.
- Вам не нужно создавать класс для каждого состояния.
- Вам не нужно создавать геттер начального значения.

Реактивное программирование с Get так же просто, как использование setState.

Представим, что у вас есть переменная name и вы хотите, чтобы каждый раз, когда вы её изменяете, все виджеты, которые её используют, менялись автоматически.

Это ваша переменная:

```dart
var name = 'Джонатас Борхес';
```

Чтобы сделать его наблюдаемым, вам просто нужно добавить в конец ".obs":

```dart
var name = 'Джонатас Борхес'.obs;
```

А в пользовательском интерфейсе, если вы хотите отображать это значение и обновлять экран при изменении значений, просто сделайте следующее:

```dart
Obx(() => Text("${controller.name}"));
```

Вот и всё. Это _так_ просто.

<a id="readme-section-8"></a>

### Подробнее об управлении состоянием

**Более подробное объяснение управления состоянием [здесь](./documentation/ru_RU/state_management.md). Там вы увидите больше примеров, а также разницу между простым менеджером состояния и реактивным менеджером состояния.**

Вы получите хорошее представление о мощности GetX.

<a id="readme-section-9"></a>

## Управление маршрутами

Если вы собираетесь использовать маршруты / снекбары / диалоги / bottomsheets без контекста, GetX отлично подойдёт вам, просто посмотрите:

Добавьте "Get" перед MaterialApp, превратив его в GetMaterialApp.

```dart
GetMaterialApp( // Ранее: MaterialApp(
  home: MyHome(),
)
```

Перейдите на новый экран:

```dart

Get.to(() => NextScreen());
```

Перейдите на новый экран с именем. Более подробную информацию об именованных маршрутах смотрите [здесь](./documentation/ru_RU/route_management.md)

```dart

Get.toNamed('/details');
```

Закрыть снекбар, диалог, bottomsheets, или что-то иное, что вы обычно закрывали с помощью Navigator.pop(context);

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

Для перехода к следующему экрану без возможности вернуться к предыдущему экрану (для использования в SplashScreens, экранах входа и т. д.)

```dart
Get.off(() => NextScreen());
```

Для перехода к следующему экрану и отмены всех предыдущих маршрутов (полезно в корзинах для покупок, опросах и тестах)

```dart
Get.offAll(() => NextScreen());
```

Заметили, что вам не нужно было использовать контекст, чтобы делать что-либо из этого? Это одно из самых больших преимуществ использования Get. Благодаря этому вы можете без проблем выполнять все эти методы из класса контроллера.

<a id="readme-section-10"></a>

### Подробнее об управлении маршрутами

**Get работает с именованными маршрутами, а также предлагает более низкий уровень контроля над вашими маршрутами! [Здесь](./documentation/ru_RU/route_management.md) есть подробная документация.**

<a id="readme-section-11"></a>

## Внедрение зависимостей

Get имеет простой и мощный менеджер зависимостей, который позволяет вам получить тот же класс, что и ваш BLoC или контроллер, всего одной строкой кода, без Provider context, без InheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Вместо Controller controller = Controller();
```

- Примечание: Если вы используете Get State Manager, обратите больше внимания на API привязок, который упростит подключение вашего представления к контроллеру.

Вместо того, чтобы создавать экземпляр вашего класса внутри класса, который вы используете, вы создаете его в экземпляре Get, что сделает его доступным во всем приложении. Таким образом, вы можете использовать свой контроллер (или BLoC) в обычном режиме.

**Совет:** Управление зависимостями Get не связано с другими частями пакета, поэтому, если, например, ваше приложение уже использует менеджер состояний (любой, не имеет значения), вам не нужно все это переписывать, вы можете использовать это внедрение зависимостей без проблем.

```dart
controller.fetchApi();
```

Представьте, что вы прошли через множество маршрутов и вам нужны данные, которые остались в вашем контроллере, вам понадобится менеджер состояний в сочетании с Provider или Get_it, верно? Только не с Get. Вам просто нужно попросить Get «найти» ваш контроллер, никаких дополнительных зависимостей вам не потребуется:

```dart
Controller controller = Get.find();
// Да, это выглядит как Магия! Get найдет ваш controller и доставит его вам. У вас может быть миллион созданных контроллеров, и Get всегда найдет нужный.
```

И тогда вы сможете восстановить данные вашего контроллера, которые были там получены:

```dart
Text(controller.textFromApi);
```

<a id="readme-section-12"></a>

### Подробнее о внедрении зависимостей

**Более подробное объяснение управления зависимостями [здесь](./documentation/ru_RU/dependency_management.md)**

<a id="readme-section-13"></a>

# Утилиты

<a id="readme-section-14"></a>

## Интернационализация

<a id="readme-section-15"></a>

### Переводы

Переводы хранятся в виде карты пар "ключ-значение". Чтобы добавить собственные переводы, создайте класс и расширьте `Translations`.

```dart
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
```

<a id="readme-section-16"></a>

#### Использование переводов

Просто добавьте `.tr` к указанному ключу, и он будет переведен с использованием текущего значения `Get.locale` и `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

<a id="readme-section-17"></a>

### Локализация

Передайте параметры в `GetMaterialApp`, чтобы определить языковой стандарт и переводы.

```dart
return GetMaterialApp(
    translations: Messages(), // ваши переводы
    locale: Locale('en', 'US'), // перевод будет осуществлен в этой локализации
    fallbackLocale: Locale('en', 'UK'), // установите резервную локализацию на случай если будет выбрана невалидный локализация.
);
```

<a id="readme-section-18"></a>

#### Изменение локализации

Вызовите `Get.updateLocale(locale)`, чтобы обновить локализацию. Затем переводы автоматически используют новый языковой стандарт.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-19"></a>

#### Системная локализация

Чтобы узнать системную локализацию, вам следует использовать `window.locale`.

```dart
import 'dart:ui' as ui;

return GetMaterialApp(
    locale: ui.window.locale,
);
```

<a id="readme-section-20"></a>

## Изменение темы

Пожалуйста, не используйте виджет более высокого уровня, чем `GetMaterialApp`, для его обновления. Это может вызвать повторяющиеся ключи. Многие люди привыкли к старому подходу к созданию виджета «ThemeProvider» только для того, чтобы изменить тему вашего приложения, а это НЕ требуется с GetX ™.

Вы можете создать свою собственную тему и просто добавить ее в `Get.changeTheme` без повторяющегося кода:

```dart
Get.changeTheme(ThemeData.light());
```

Если вы хотите создать что-то вроде кнопки, которая изменяет тему, вы можете объединить для этого два API **GetX ™**:

- API, который проверяет, используется ли темная тема.
- И API смены темы.

Вы можете просто поместить это в `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Когда `.darkmode` активен, он переключится на _light theme_, и когда _light theme_ станет активной, он изменится на _dark theme_.

<a id="readme-section-21"></a>

## Другие API

```dart
// получить текущие аргументы текущего экрана
Get.arguments

// получить имя предыдущего маршрута
Get.previousRoute

// получить чистый маршрут, например, чтобы узнать: rawRoute.isFirst()
Get.rawRoute

// получить доступ к Rounting API из GetObserver
Get.routing

// проверить, открыт ли снекбар
Get.isSnackbarOpen

// открыт ли диалог
Get.isDialogOpen

// открыт ли bottomsheets
Get.isBottomSheetOpen

// удалить один маршрут
Get.removeRoute('/details')

// возвращаться назад, пока данный предикат не выполнится
Get.until((page) => page.name == '/home')

// идти вперед, удалив предыдущие маршруты, пока данный предикат не выполнится
Get.offUntil(() => const Scaffold(), (page) => page.name == '/home')

// перейти к следующему именованному маршруту, удалив предыдущие маршруты, пока данный предикат не выполнится
Get.offNamedUntil('/details', (page) => page.name == '/home')

// проверить на какой платформе работает приложение
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// проверить тип устройства
GetPlatform.isMobile
GetPlatform.isDesktop
// В вебе все платформы поддерживаются независимо!
// Можно узнать, работает ли приложение сейчас в браузере
// и на Windows, и на iOS, и на OSX, и на Android и так далее
GetPlatform.isWeb


// Эквивалент : MediaQuery.of(context).size.height,
// но неизменяемый.
Get.height
Get.width

// Текущий контекст навигации
Get.context

// Получить контекст показанного снекбара/диалога/bottomsheets в любом месте вызова.
Get.overlayContext

// Внимание: методы ниже являются расширениями класса BuildContext.
// Поскольку доступ к контексту есть в любом месте из вашего UI,
// вы можете использовать расширения в любом месте UI кода

// Если вам нужна изменяемая высота/ширина (например, настольное или браузерное окно, размер которого можно изменить), вам нужно использовать context
context.width
context.height

// Дает возможность определить половину экрана, треть и так далее.
// Полезно для отзывчивых приложений.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Схоже с MediaQuery.of(context).size
context.mediaQuerySize

/// Схоже с MediaQuery.of(context).padding
context.mediaQueryPadding

/// Схоже с MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding

/// Схоже с MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets

/// Схоже с MediaQuery.of(context).orientation;
context.orientation

/// Проверить, в горизонтальном ли режиме устройство
context.isLandscape

/// Проверить, в вертикальном ли режиме устройство
context.isPortrait

/// Схоже с to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio

/// Схоже с MediaQuery.of(context).textScaleFactor;
context.textScaleFactor

/// Получить shortestSide экрана
context.mediaQueryShortestSide

/// Вернет True, если ширина больше 800
context.showNavbar

/// Вернет True, если меньшая сторона меньше 600p
context.isPhone

/// Вернет True, если меньшая сторона больше 600p
context.isSmallTablet

/// Вернет True, если меньшая сторона больше 720p
context.isLargeTablet

/// Вернет True, если текущее устройство — Планшет
context.isTablet

/// Возвращает value<T> в зависимости от размера экрана
/// Можно устанавливать значения для:
/// watch: Если меньшая сторона меньше 300
/// mobile: Если меньшая сторона меньше 600
/// tablet: Если меньшая сторона меньше 1200
/// desktop: Если ширина больше 1200
context.responsiveValue<T>()
```

<a id="readme-section-22"></a>

### Дополнительные глобальные настройки и ручные настройки

GetMaterialApp настраивает все за вас, но если вы хотите настроить Get вручную.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

Вы также сможете использовать собственное промежуточное ПО в `GetObserver`, это ни на что не повлияет.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

Задавайте параметры GetMaterialApp или GetCupertinoApp вместо старого Get.config. Собственному router нужна согласованная конфигурация Navigator 2.

```dart
Widget configuredApplication() => GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 250),
  popGesture: true,
  logWriterCallback: localLogWriter,
  routingCallback: (routing) {
    if (routing != null) {
      debugPrint('Route: ${routing.current}');
    }
  },
  home: const Scaffold(body: Text('Configuration')),
);

void localLogWriter(String text, {bool isError = false}) {
  debugPrint('${isError ? "ERROR" : "GETX"}: $text');
}
```

При желании, вы сможете перенаправить все сообщения из `Get`.
Если вы хотите использовать свой любимый пакет для логирования и собирать логи там:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // передайте сообщение вашей любимой log-библиотеке
  // но учитывайте, что даже если enableLog: false, сообщения все равно будут передаваться сюда
  // узнать значение этого флага можно с помощью GetConfig.isLogEnable
}
```

<a id="readme-section-23"></a>

### Локальные виджеты состояния

Эти виджеты позволяют управлять одним значением, сохраняя состояние эфемерным и локальным.
У нас есть варианты для Reactive и Simple.
Например, вы можете использовать их для переключения obscureText в `TextField`, возможно, для создания кастомного ExpandablePanel или, возможно, для изменения текущего индекса в `BottomNavigationBar` при изменении содержимого body в `Scaffold`.

<a id="readme-section-24"></a>

#### ValueBuilder

Упрощение `StatefulWidget` который работает с вызовом `.setState` принимающим обновленное значение.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // такая же сигнатура! Вы можете использовать ( newValue ) => updateFn( newValue )
  ),
  // Если нужно вызвать что-то вне метода builder
  onUpdate: (value) => print("Значение обновлено: $value"),
  onDispose: () => print("Виджет удален"),
),
```

<a id="readme-section-25"></a>

#### ObxValue

Похож на [`ValueBuilder`](#valuebuilder), но это реактивная версия, вы передаёте Rx экземпляр (помните волшебный .obs?) и
автоматически обновляетесь... разве это не великолепно?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // У Rx есть _callable_ функция! Вы можете использовать (flag) => data.value = flag,
    ),
    false.obs,
),
```

<a id="readme-section-26"></a>

## Полезные советы

`.obs`ervables (наблюдатели) (также известные как Rx-типы) имеют широкий спектр внутренних методов и операторов

> Очень распространено _мнение_, что свойство с `.obs` **ЯВЛЯЕТСЯ** действительным значением... но не ошибайтесь!
> Мы избегаем объявления типа переменной, потому что компилятор Dart достаточно умен, и
> код выглядит чище, но:

```dart
var message = 'Привет, мир'.obs;
print( 'Тип "$message" — ${message.runtimeType}');
```

Даже если `message` _выводит_ значение String, его тип - **RxString**!

Итак, вы не сможете сделать `message.substring( 0, 4 )`.
Вы должны получить доступ к реальному `value` внутри _observable_:
Самый "используемый способ" это `.value`, но, знаете ли вы, что вы также можете использовать ...

```dart
class Person {
  Person({required this.name});
  String name;
}

void reactiveExamples() {
  final name = 'GetX'.obs;
  name.value = 'Hello';
  final enabled = false.obs;
  enabled.toggle();

  final items = RxList<int>()..add(1);
  final counters = RxMap<String, int>()..['visits'] = 1;
  final labels = RxSet<String>()..add('new');
  items.assignAll(items.where((value) => value > 0));

  final person = Person(name: 'Sara').obs;
  person.update((previous) => Person(name: '${previous!.name}!'));

  name.close();
  enabled.close();
  items.close();
  counters.close();
  labels.close();
  person.close();
}
```

<a id="readme-section-27"></a>

#### GetView

Я люблю этот виджет, он такой простой, но такой полезный!

Это `const Stateless` виджет, который имеет геттер `controller` для зарегистрированного `Controller`, вот и всё.

```dart
 class AwesomeController extends GetxController {
   final String title = 'Моя Удивительная View';
 }

  // ВСЕГДА передавайте `Тип` вашего контроллера!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text( controller.title ), // просто вызовите `controller.что-то`
     );
   }
 }
```

<a id="readme-section-28"></a>

#### GetWidget

GetWidget кеширует контроллер этого экземпляра виджета и поддерживает const. Контроллер Get.spawn закрывается при удалении владельца. GetView выполняет поиск без такого кеша.

```dart
class ItemController extends GetxController {
  final label = 'Item'.obs;
}

void registerItemFactory() => Get.spawn<ItemController>(() => ItemController());

class ItemView extends GetWidget<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Text(controller.label.value));
}
```

<a id="readme-section-29"></a>

#### GetxService

GetxService предоставляет onInit/onReady/onClose для сервисов приложения. Обычное удаление защищает их; force или Get.reset позволяют явную очистку. Это не хранение после гибели процесса. Дождитесь init и используйте Get.put.

```dart
class DbService extends GetxService {
  Future<DbService> init() async => this;
}

class SettingsService extends GetxService {
  Future<SettingsService> init() async => this;
}

Future<void> initServices() async {
  final database = await DbService().init();
  Get.put<DbService>(database, permanent: true);
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
}

Future<void> startApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(home: const Scaffold(body: Text('Ready'))));
}
```

<a id="readme-section-30"></a>

# Критические изменения по сравнению с версией 2.0

1- Rx типы:

| До      | После      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController и GetBuilder теперь объединены, вам больше не нужно запоминать, какой контроллер вы хотите использовать, просто используйте GetxController, он будет работать как для простого управления состоянием, так и для реактивного.

2- NamedRoutes
До:

```text
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Сейчас:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

Для чего это изменение?
Часто может потребоваться решить, какая страница будет отображаться с помощью параметра или токена входа, предыдущий подход был негибким, так как он не позволял этого.
Вставка страницы в функцию значительно снизила потребление оперативной памяти, поскольку маршруты не будут выделяться в памяти с момента запуска приложения, а также позволил использовать такой подход:

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

<a id="readme-section-31"></a>

# Почему Getx?

1- Много раз после обновления Flutter многие из ваших пакетов ломались. Иногда случаются ошибки компиляции, часто возникают ошибки, на которые до сих пор нет ответов, и разработчику необходимо знать, откуда возникла ошибка, отслеживать ошибку, только затем попытаться открыть проблему в соответствующем репозитории и увидеть, как проблема решена. Get централизует основные ресурсы для разработки (управление состоянием, зависимостями и маршрутами), позволяя вам добавить один пакет в свой pubspec и начать работу. После обновления Flutter единственное, что вам нужно сделать, это обновить зависимость Get и приступить к работе. Get также решает проблемы совместимости. Как часто бывало, что одна версия пакета несовместима с другой, потому что одна использует зависимость в одной версии, а другая - в другой? Это не проблема при использовании Get, поскольку все находится в одном пакете и полностью совместимо.

2- Flutter - это просто, Flutter - это невероятно, но у Flutter все еще некоторый шаблонный код, который может быть нежелательным для большинства разработчиков, например `Navigator.of(context).push (context, builder [...]`. Get упрощает разработку. Вместо того, чтобы писать 8 строк кода для вызова маршрута, вы можете просто сделать это: `Get.to(() => Home())` и всё готово, вы перейдёте на следующую страницу. Динамические URL-адреса - это действительно болезненная вещь, которую нужно решать во Flutter в настоящее время, а с GetX это элементарно. Управление состояниями во Flutter и управление зависимостями также вызывает много споров, поскольку в pub есть сотни паттернов. Но нет ничего проще, чем добавить «.obs» в конец вашей переменной и поместить ваш виджет внутри Obx, и всё, все обновления этой переменной будут автоматически обновляться на экране.

3- Лёгкость, не беспокоясь о производительности. Производительность Flutter уже потрясающая, но представьте, что вы используете диспетчер состояний и локатор для распределения классов блоков / хранилищ / контроллеров / и других классов. Вам придётся вручную вызывать исключение этой зависимости, когда она вам не нужна. Но вы когда-нибудь думали о том, чтобы просто использовать свой контроллер, и когда он больше никем не использовался, он просто был бы удален из памяти? Это то, что делает GetX. Благодаря SmartManagement всё, что не используется, удаляется из памяти, и вам не нужно беспокоиться ни о чем, кроме программирования. Вы будете уверены, что потребляете минимум необходимых ресурсов, даже не создав для этого логики.

4- Действительное разделение. Вы могли слышать о концепции разделения представления от бизнес логики. Это не исключительная особенность BLoC, MVC, MVVM и тд, любой стандарт реализует эту концепцию. Однако во Flutter возможно ослабление этой концепции из-за необходимости использования контекста.
Если вам нужен контекст для поиска InheritedWidget, он вам нужен в представлении, либо нужно передать контекст как параметр. Мы считаем это решение очень уродливым, и для работы в команде мы всегда будем зависеть от логики представления (View). Getx - необычный подход со стандартным доступом, который хоть и не запрещает использование StatefulWidgets, InitState, и т.д., всегда имеет более чистый аналог. У контроллеров есть жизненные циклы, и когда вам нужно сделать, например, запрос APIREST, вы не зависите ни от чего в представлении. Вы можете использовать onInit для инициирования http-вызова, и когда данные поступят, переменные будут заполнены. Поскольку GetX полностью реактивен (действительно реактивен и работает с потоками), после заполнения элементов все виджеты, использующие эту переменную, будут автоматически обновлены в представлении. Это позволяет людям с опытом работы с пользовательским интерфейсом работать только с виджетами и не отправлять в бизнес-логику ничего, кроме пользовательских событий (например, нажатия кнопки), в то время как люди, работающие с бизнес-логикой, смогут создавать и тестировать бизнес-логику отдельно.

Эта библиотека всегда будет обновляться и реализовывать новые функции. Не стесняйтесь предлагать PR.

<a id="readme-section-32"></a>

# Сообщества

<a id="readme-section-33"></a>

## Каналы сообщества

У GetX очень активное и готовое к взаимовыручке сообщество. Если у вас есть вопросы или вы хотите получить какую-либо помощь относительно использования этого фреймворка, присоединяйтесь к нашим каналам сообщества, на ваш вопрос ответят быстро. Этот репозиторий предназначен исключительно для открытия проблем и запроса ресурсов, но не стесняйтесь быть частью сообщества GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="readme-section-34"></a>

## Как внести свой вклад

_Хотите внести свой вклад в проект? Вы будем рады отметить вас как одного из наших соавторов. Вот несколько направлений, где вы можете сделать Get (и Flutter) лучше._

- Помощь в переводе readme на другие языки.
- Добавление документации в readme (многие функции Get еще не задокументированы).
- Напишите статью или сделайте видео, обучающие использованию Get (они будут вставлены в Readme и в будущем в нашу Wiki).
- Предложите PRs для кода/тестов.
- Новые фичи.

Приветствуется любой вклад!

<a id="readme-section-35"></a>

## Статьи и видео

- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.

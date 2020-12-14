![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

_Языки: Русский (этот файл), [индонезийский](README.id-ID.md), [урду](README.ur-PK.md), [Английский](README.md), [Китайский](README.zh-cn.md), [Бразильский Португальский](README.pt-br.md), [Испанский](README-es.md), [Польский](README.pl.md), [Kорейский](README.ko-kr.md)._

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
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

- [Про Get](#про-get)
- [Установка](#установка)
- [Приложение "Счётчик" с GetX](#приложение-счётчик-с-getx)
- [Три столпа](#три-столпа)
  - [Управление состоянием](#управление-состоянием)
    - [Реактивное управление состоянием](#реактивное-управление-состоянием)
    - [Подробнее об управлении состоянием](#подробнее-об-управлении-состоянием)
  - [Управление маршрутами](#управление-маршрутами)
    - [Подробнее об управлении маршрутами](#подробнее-об-управлении-маршрутами)
  - [Внедрение зависимостей](#внедрение-зависимостей)
    - [Подробнее о внедрении зависимостей](#подробнее-о-внедрении-зависимостей)
- [Утилиты](#утилиты)
  - [Интернационализация](#интернационализация)
    - [Переводы](#переводы)
      - [Применение переводов](#применение-переводов)
    - [Локализация](#локализация)
      - [Изменение локализации](#изменение-локализации)
      - [Системная локализация](#системная-локализации)
  - [Изменение темы](#изменение-темы)
  - [Другие API](#другие-api)
    - [Дополнительные глобальные настройки и ручные настройки](#дополнительные-глобальные-настройки-и-ручные-настройки)
    - [Локальные виджеты состояния](#локальные-виджеты-состояний)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [Полезные советы](#полезные-советы)
      - [GetView](#getview)
      - [GetWidget](#getwidget)
      - [GetxService](#getxservice)
- [Критические изменения по сравнению с версией 2.0](#критические-изменения-по-сравнению-с-версией-20)
- [Почему Getx?](#почему-getx)
- [Сообщество](#сообщество)
  - [Каналы сообщества](#каналы-сообщества)
  - [Как внести свой вклад](#как-внести-свой-вклад)
  - [Статьи и видео](#статьи-и-видео)

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
    
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: RaisedButton(
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

Результат:

![](counter-app-gif.gif)

Это простой проект, но он уже дает понять, насколько мощным является Get. По мере роста вашего проекта эта разница будет становиться все более значительной.

Get был разработан для работы с командами, но он упрощает работу отдельного разработчика.

Оптимизируйте ваши сроки, доставляйте всё вовремя без потери производительности. Get не для всех, но, если вы идентифицировали себя с предыщим предложением, Get для вас!

# Три столпа

## Управление состоянием

В настоящее время для Flutter есть несколько менеджеров состояний. Однако большинство из них связано с использованием ChangeNotifier для обновления виджетов, и это плохой и очень плохой подход к производительности для средних или больших приложений. Вы можете проверить в официальной документации Flutter, что [ChangeNotifier следует использовать с 1 или максимум 2 слушателями](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), что делает его практически непригодным для любого приложения среднего или большого размера.

Get не лучше и не хуже, чем любой другой менеджер состояний, но вам следует проанализировать его, а также пункты ниже, чтобы выбрать между использованием Get в чистой форме (Vanilla), либо совместно с другим менеджером состояний.

Определенно, Get не враг любого другого менеджера состояний, потому что Get - это микрофреймворк, а не просто менеджер состояний, и его можно использовать отдельно или вместе с ними.

Get имеет два разных менеджера состояний: простой менеджер состояний (мы назовем его GetBuilder) и реактивный менеджер состояний (который называется GetX).

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
var name = 'Jonatas Borges';
```

Чтобы сделать его наблюдаемым, вам просто нужно добавить в конец ".obs":

```dart
var name = 'Jonatas Borges'.obs;
```

А в пользовательском интерфейсе, если вы хотите отображать это значение и обновлять экран при изменении значений, просто сделайте следующее:

```dart
Obx(() => Text("${controller.name}"));
```

Вот и всё. Это _так_ просто.

### Подробнее об управлении состоянием

**Более подробное объяснение управления состоянием [здесь](./documentation/ru_RU/state_management.md). Там вы увидите больше примеров, а также разницу между простым менеджером состояния и реактивным менеджером состояния.**

Вы получите хорошее представление о мощности GetX.

## Управление маршрутами

Если вы собираетесь использовать маршруты / снекбары / диалоги / bottomsheets без контекста, GetX отлично подойдёт вам, просто посмотрите:

Добавьте "Get" перед MaterialApp, превратив его в GetMaterialApp.

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Перейдите на новый экран:

```dart

Get.to(NextScreen());
```

Перейдите на новый экран с именем. Более подробную информацию об именованных маршрутах смотрите [здесь](./documentation/ru_RU/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

Закрыть снекбар, диалог, bottomsheets, или что-то иное, что вы обычно закрывали с помощью Navigator.pop(context);

```dart
Get.back();
```

Для перехода к следующему экрану без возможности вернуться к предыдущему экрану (для использования в SplashScreens, экранах входа и т. д.)

```dart
Get.off(NextScreen());
```

Для перехода к следующему экрану и отмены всех предыдущих маршрутов (полезно в корзинах для покупок, опросах и тестах)

```dart
Get.offAll(NextScreen());
```

Заметили, что вам не нужно было использовать контекст, чтобы делать что-либо из этого? Это одно из самых больших преимуществ использования Get. Благодаря этому вы можете без проблем выполнять все эти методы из класса контроллера.

### Подробнее об управлении маршрутами

**Get работает с именованными маршрутами, а также предлагает более низкий уровень контроля над вашими маршрутами! [Здесь](./documentation/ru_RU/route_management.md) есть подробная документация.**

## Внедрение зависимостей

Get имеет простой и мощный менеджер зависимостей, который позволяет вам получить тот же класс, что и ваш BLoC или контроллер, всего одной строкой кода, без Provider context, без InheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
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
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

И тогда вы сможете восстановить данные вашего контроллера, которые были там получены:

```dart
Text(controller.textFromApi);
```

### Подробнее о внедрении зависимостей

**Более подробное объяснение управления зависимостями [здесь](./documentation/ru_RU/dependency_management.md)**

# Утилиты

## Интернационализация

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

#### Использование переводов

Просто добавьте `.tr` к указанному ключу, и он будет переведен с использованием текущего значения `Get.locale` и `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

### Локализация

Передайте параметры в `GetMaterialApp`, чтобы определить языковой стандарт и переводы.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### Изменение локализации

Вызовите `Get.updateLocale(locale)`, чтобы обновить локализацию. Затем переводы автоматически используют новый языковой стандарт.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Системная локализация

Чтобы узнать системную локализацию, вам следует использовать `window.locale`.

```dart
import 'dart:ui' as ui;

return GetMaterialApp(
    locale: ui.window.locale,
);
```

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

## Другие API

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
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Check the device type
GetPlatform.isMobile
GetPlatform.isDesktop
//All platforms are supported independently in web!
//You can tell if you are running inside a browser
//on Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

// Gives you the power to define half the screen, a third of it and so on.
// Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similar to MediaQuery.of(context).orientation;
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Get the shortestSide from screen
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// True if the shortestSide is smaller than 600p
context.isPhone()

/// True if the shortestSide is largest than 600p
context.isSmallTablet()

/// True if the shortestSide is largest than 720p
context.isLargeTablet()

/// True if the current device is Tablet
context.isTablet()

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

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

Вы можете создать _Глобальные Настройки_ Для `Get`. Просто добавьте `Get.config` в ваш код прежде чем нажимать на любой из маршрутов.
Или сделайте это прямо в `GetMaterialApp`

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

При желании, вы сможете перенаправить все сообщения из `Get`.
Если вы хотите использовать свой любимый пакет для логирования и собирать логи там:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // pass the message to your favourite logging package here
  // please note that even if enableLog: false log messages will be pushed in this callback
  // you get check the flag if you want through GetConfig.isLogEnable
}

```

### Локальные виджеты состояния

Эти виджеты позволяют управлять одним значением, сохраняя состояние эфемерным и локальным.
У нас есть варианты для Reactive и Simple.
Например, вы можете использовать их для переключения obscureText в `TextField`, возможно, для создания кастомного ExpandablePanel или, возможно, для изменения текущего индекса в `BottomNavigationBar` при изменении содержимого body в `Scaffold`.

#### ValueBuilder

Упрощение `StatefulWidget` который работает с вызовом `.setState` принимающим обновленное значение.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // same signature! you could use ( newValue ) => updateFn( newValue )
  ),
  // if you need to call something outside the builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

Похож на [`ValueBuilder`](#valuebuilder), но это реактивная версия, вы передаёте Rx экземпляр (помните волшебный .obs?) и
автоматически обновляетесь... разве это не великолепно?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Полезные советы

`.obs`ervables (наблюдатели) (также известные как Rx-типы) имеют широкий спектр внутренних методов и операторов

> Очень распространено _мнение_, что свойство с `.obs` **ЯВЛЯЕТСЯ** действительным значением... но не ошибайтесь!
> Мы избегаем объявления типа переменной, потому что компилятор Dart достаточно умен, и
> код выглядит чище, но:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Даже если `message` _выводит_ значение String, его тип - **RxString**!

Итак, вы не сможете сделать `message.substring( 0, 4 )`.
Вы должны получить доступ к реальному `value` внутри _observable_:
Самый "используемый способ" это `.value`, но, знаете ли вы, что вы также можете использовать ...

```dart
final name = 'GetX'.obs;
// only "updates" the stream, if the value is different from the current one.
name.value = 'Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name('Hello');

// is like a getter, prints 'Hello'.
name() ;

/// numbers:

final count = 0.obs;

// You can use all non mutable operations from num primitives!
count + 1;

// Watch out! this is only valid if `count` is not final, but var
count += 1;

// You can also compare against values:
count > 2;

/// booleans:

final flag = false.obs;

// switches the value between true/false
flag.toggle();


/// all types:

// Sets the `value` to null.
flag.nil();

// All toString(), toJson() operations are passed down to the `value`
print( count ); // calls `toString()` inside  for RxInt

final abc = [0,1,2].obs;
// Converts the value to a json Array, prints RxList
// Json is supported by all Rx types!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList and RxSet are special Rx types, that extends their native types.
// but you can work with a List as a regular list, although is reactive!
abc.add(12); // pushes 12 to the list, and UPDATES the stream.
abc[3]; // like Lists, reads the index 3.


// equality works with the Rx and the value, but hashCode is always taken from the value
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() are deferred to the child, so you can implement override on them, and print() the observable directly.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Roi';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```

#### GetView

Я люблю этот виджет, он такой простой, но такой полезный!

Это`const Stateless` виджет, который имеет геттер `controller` для зарегистрированного `Controller`, вот и всё.

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // ALWAYS remember to pass the `Type` you used to register your controller!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text( controller.title ), // just call `controller.something`
     );
   }
 }
```

#### GetWidget

Большинство людей понятия не имеют об этом виджете или путаются при его применении.
Вариант его использования редок, но конкретен: он кэширует Controller.
Поэтому из-за _cache_, он не может быть `const Stateless`.

> Итак, когда вам нужно «кэшировать» контроллер?

В случаях использования другой "не распространённой" фичи **GetX**: `Get.create()`.

`Get.create(()=>Controller())` будет создавать новый `Controller` каждый раз при вызове
`Get.find<Controller>()`,

Это тот самый случай, когда `GetWidget` блистает... поскольку вы можете использовать его, например, для хранения списка элементов Todo. Итак, если виджет будет «перестроен», он сохранит тот же экземпляр контроллера.

#### GetxService

Этот класс похож на `GetxController`, у него такой же жизненный цикл ( `onInit()`, `onReady()`, `onClose()`).
Но внутри нет никакой «логики». Он просто уведомляет систему **GetX** Dependency Injection о том, что этот подкласс **нельзя** удалить из памяти.

Так что очень полезно держать ваши «Сервисы» всегда доступными и активными с помощью `Get.find()`. Например:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Is a smart move to make your Services intiialize before you run the Flutter app.
/// as you can control the execution flow (maybe you need to load some Theme configuration,
/// apiKey, language defined by the User... so load SettingService before running ApiService.
/// so GetMaterialApp() doesnt have to rebuild, and takes the values directly.
void initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(SettingsService()).init();
  print('All services started...');
}

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType delays 2 sec');
    await 2.delay();
    print('$runtimeType ready!');
    return this;
  }
}

class SettingsService extends GetxService {
  void init() async {
    print('$runtimeType delays 1 sec');
    await 1.delay();
    print('$runtimeType ready!');
  }
}

```

Единственный способ удалить `GetxService` - использовать `Get.reset()`,  который похож на «горячую перезагрузку» вашего приложения. Так что помните, если вам нужен постоянный экземпляр класса в течение всего жизненного цикла вашего приложения, используйте `GetxService`.

# Критические изменения по сравнению с версией 2.0

1- Rx типы:

| До  | После      |
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

```dart
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

# Почему Getx?

1- Много раз после обновления Flutter многие из ваших пакетов ломались. Иногда случаются ошибки компиляции, часто возникают ошибки, на которые до сих пор нет ответов, и разработчику необходимо знать, откуда возникла ошибка, отслеживать ошибку, только затем попытаться открыть проблему в соответствующем репозитории и увидеть, как проблема решена. Get централизует основные ресурсы для разработки (управление состоянием, зависимостями и маршрутами), позволяя вам добавить один пакет в свой pubspec и начать работу. После обновления Flutter единственное, что вам нужно сделать, это обновить зависимость Get и приступить к работе. Get также решает проблемы совместимости. Как часто бывало, что одна версия пакета несовместима с другой, потому что одна использует зависимость в одной версии, а другая - в другой? Это не проблема при использовании Get, поскольку все находится в одном пакете и полностью совместимо.

2- Flutter - это просто, Flutter - это невероятно, но у Flutter все еще некоторый шаблонный код, который может быть нежелательным для большинства разработчиков, например `Navigator.of(context).push (context, builder [...]`. Get упрощает разработку. Вместо того, чтобы писать 8 строк кода для вызова маршрута, вы можете просто сделать это: `Get.to(Home())` и всё готово, вы перейдёте на следующую страницу. Динамические URL-адреса - это действительно болезненная вещь, которую нужно решать во Flutter в настоящее время, а с GetX это элементарно. Управление состояниями во Flutter и управление зависимостями также вызывает много споров, поскольку в pub есть сотни паттернов. Но нет ничего проще, чем добавить «.obs» в конец вашей переменной и поместить ваш виджет внутри Obx, и всё, все обновления этой переменной будут автоматически обновляться на экране.

3- Лёгкость, не беспокоясь о производительности. Производительность Flutter уже потрясающая, но представьте, что вы используете диспетчер состояний и локатор для распределения классов блоков / хранилищ / контроллеров / и других классов. Вам придётся вручную вызывать исключение этой зависимости, когда она вам не нужна. Но вы когда-нибудь думали о том, чтобы просто использовать свой контроллер, и когда он больше никем не использовался, он просто был бы удален из памяти? Это то, что делает GetX. Благодаря SmartManagement всё, что не используется, удаляется из памяти, и вам не нужно беспокоиться ни о чем, кроме программирования. Вы будете уверены, что потребляете минимум необходимых ресурсов, даже не создав для этого логики.

4- Действительное разделение. Вы могли слышать о концепции разделения представления от бизнес логики. Это не исключительная особенность BLoC, MVC, MVVM и тд, любой стандарт реализует эту концепцию. Однако во Flutter возможно ослабление этой концепции из-за необходимости использования контекста.
Если вам нужен контекст для поиска InheritedWidget, он вам нужен в представлении, либо нужно передать контекст как параметр. Мы считаем это решение очень уродливым, и для работы в команде мы всегда будем зависеть от логики представления (View). Getx - необычный подход со стандартным доступом, который хоть и не запрещает использование StatefulWidgets, InitState, и т.д., всегда имеет более чистый аналог. У контроллеров есть жизненные циклы, и когда вам нужно сделать, например, запрос APIREST, вы не зависите ни от чего в представлении. Вы можете использовать onInit для инициирования http-вызова, и когда данные поступят, переменные будут заполнены. Поскольку GetX полностью реактивен (действительно реактивен и работает с потоками), после заполнения элементов все виджеты, использующие эту переменную, будут автоматически обновлены в представлении. Это позволяет людям с опытом работы с пользовательским интерфейсом работать только с виджетами и не отправлять в бизнес-логику ничего, кроме пользовательских событий (например, нажатия кнопки), в то время как люди, работающие с бизнес-логикой, смогут создавать и тестировать бизнес-логику отдельно.

Эта библиотека всегда будет обновляться и реализовывать новые функции. Не стесняйтесь предлагать PR.

# Сообщества

## Каналы сообщества

У GetX очень активное и готовое к взаимовыручке сообщество. Если у вас есть вопросы или вы хотите получить какую-либо помощь относительно использования этого фреймворка, присоединяйтесь к нашим каналам сообщества, на ваш вопрос ответят быстро. Этот репозиторий предназначен исключительно для открытия проблем и запроса ресурсов, но не стесняйтесь быть частью сообщества GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Как внести свой вклад

_Хотите внести свой вклад в проект? Вы будем рады отметить вас как одного из наших соавторов. Вот несколько направлений, где вы можете сделать Get (и Flutter) лучше._

- Помощь в переводе readme на другие языки.
- Добавление документации в readme (многие функции Get еще не задокументированы).
- Напишите статью или сделайте видео, обучающие использованию Get (они будут вставлены в Readme и в будущем в нашу Wiki).
- Предложите PRs для кода/тестов.
- Новые фичи.

Приветствуется любой вклад!

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

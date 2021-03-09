- [Управление маршрутами](#управление-маршрутами)
  - [Как использовать](#как-использовать)
  - [Навигация без именованных маршрутов](#навигация-без-именованных-маршрутов)
  - [Навигация по именованным маршрутам](#навигация-по-именованным-маршрутам)
    - [Отправить данные по именованному маршруту](#отправить-данные-по-именованному-маршруту)
    - [Динамические url-ссылки](#динамические-url-ссылки)
    - [Middleware](#middleware)
  - [Навигация без контекста](#навигация-без-контекста)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [Вложенная навигация](#вложенная-навигация)

# Управление маршрутами

Это полное объяснение всего, что нужно Getx, когда речь идет об управлении маршрутами.

## Как использовать

Добавьте к вашему pubspec.yaml следующее:

```yaml
dependencies:
  get:
```

Если вы собираетесь использовать маршруты/snackbars/dialogs/bottomSheets без контекста или использовать высокоуровневые API Get, вам нужно просто добавить «Get» перед вашим MaterialApp, превратив его в GetMaterialApp!

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Навигация без именованных маршрутов

Для навигации на новый экран:

```dart
Get.to(NextScreen());
```

Чтобы закрыть snackbars, диалог, bottomsheets, или все, что вы обычно закрывали с помощью Navigator.pop(context);

```dart
Get.back();
```

Для перехода к следующему экрану и отсутствия возможности вернуться к предыдущему экрану (для использования в SplashScreens, экранах входа и т.д.)

```dart
Get.off(NextScreen());
```

Для перехода к следующему экрану и отмены всех предыдущих маршрутов (полезно в корзинах для покупок, опросах и тестах)

```dart
Get.offAll(NextScreen());
```

Чтобы перейти к следующему маршруту и ​​получить или обновить данные, как только вы вернетесь с него:

```dart
var data = await Get.to(Payment());
```

отправить данные на предыдущий экран:

```dart
Get.back(result: 'success');
```

И использовать их:

пример:

```dart
if(data == 'success') madeAnything();
```

Нет желания учить наш синтаксис?
Просто измените Navigator(верхний регистр) на navigator (нижний регистр), и вы получите все функции стандартной навигации без использования контекста.
Пример:

```dart

// Default Flutter navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Get using Flutter syntax without needing context
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Get syntax (It is much better, but you have the right to disagree)
Get.to(HomePage());


```

## Навигация по именованным маршрутам

- Если вы предпочитаете перемещаться по именованным маршрутам, Get также поддерживает это.

Для навигации на следующий экран

```dart
Get.toNamed("/NextScreen");
```

Для навигации и удаления предыдущего экрана из дерева.

```dart
Get.offNamed("/NextScreen");
```

Для навигации и удаления всех предыдущих экранов из дерева.

```dart
Get.offAllNamed("/NextScreen");
```

Для определения маршрутов используйте GetMaterialApp:

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
        GetPage(
          name: '/third',
          page: () => Third(),
          transition: Transition.zoom  
        ),
      ],
    )
  );
}
```

Для обработки навигации по неопределенным маршрутам (ошибка 404) вы можете определить страницу unknownRoute в GetMaterialApp.

```dart
void main() {
  runApp(
    GetMaterialApp(
      unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
      ],
    )
  );
}
```

### Отправить данные по именованному маршруту

Просто отправьте то, что хотите в качестве аргументов. Get принимает здесь всё, что угодно, будь то String, Map, List или даже экземпляр класса.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

в вашем классе или контроллере:

```dart
print(Get.arguments);
//print out: Get is the best
```

### Динамические url-ссылки

Получите расширенные динамические url-адреса, как в Интернете. Веб-разработчики, вероятно, уже хотели эту функцию на Flutter, и, скорее всего, видели, что пакет обещает эту функцию и предоставляет совершенно другой синтаксис, чем url-адрес в Интернете, но Get также решает эту проблему.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

в вашем controller/bloc/stateful/stateless классе:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

Вы также можете легко получить именованные параметры с помощью Get:

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
      GetPage(
        name: '/',
        page: () => MyHomePage(),
      ),
      GetPage(
        name: '/profile/',
        page: () => MyProfile(),
      ),
       //You can define a different page for routes with arguments, and another without arguments, but for that you must use the slash '/' on the route that will not receive arguments as above.
       GetPage(
        name: '/profile/:user',
        page: () => UserProfile(),
      ),
      GetPage(
        name: '/third',
        page: () => Third(),
        transition: Transition.cupertino  
      ),
     ],
    )
  );
}
```

Отправьте данные по именованному маршруту

```dart
Get.toNamed("/profile/34954");
```

На втором экране возьмите данные по параметрам

```dart
print(Get.parameters['user']);
// out: 34954
```

или отправьте несколько таких параметров

```dart
Get.toNamed("/profile/34954?flag=true");
```

На втором экране взять данные по параметрам как обычно.

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
// out: 34954 true
```



И теперь все, что вам нужно сделать, это использовать Get.toNamed() для навигации по именованным маршрутам без какого-либо контекста (вы можете вызывать свои маршруты непосредственно из класса BLoC или контроллера), а когда ваше приложение будет скомпилировано в Интернете, ваше маршруты появятся в url <3

### Middleware

Если вы хотите прослушивать события Get для запуска действий, вы можете использовать для этого routingCallback

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Если вы не используете GetMaterialApp, вы можете использовать ручной API для подключения наблюдателя.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
      ],
    ),
  );
}
```

Создайте класс MiddleWare

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen.
    ///If you need to enter any of these 3 events directly here,
    ///you must specify that the event is != Than you are trying to do.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

Теперь используйте Get в своем коде:

```dart
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/second");
          },
        ),
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/third");
          },
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

## Навигация без контекста

### SnackBars

Чтобы получить простой SnackBar с Flutter, вы должны получить контекст Scaffold, или вы должны использовать GlobalKey, прикрепленный к вашему Scaffold

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// Find the Scaffold in the widget tree and use
// it to show a SnackBar.
Scaffold.of(context).showSnackBar(snackBar);
```

Реализация в Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

С Get всё, что вам нужно сделать, это вызвать Get.snackbar из любого места кода или настроить его так, как вы хотите!

```dart
Get.snackbar(
  "Hey i'm a Get SnackBar!", // title
  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// ALL FEATURES //////////
  //     Color colorText,
  //     Duration duration,
  //     SnackPosition snackPosition,
  //     Widget titleText,
  //     Widget messageText,
  //     bool instantInit,
  //     Widget icon,
  //     bool shouldIconPulse,
  //     double maxWidth,
  //     EdgeInsets margin,
  //     EdgeInsets padding,
  //     double borderRadius,
  //     Color borderColor,
  //     double borderWidth,
  //     Color backgroundColor,
  //     Color leftBarIndicatorColor,
  //     List<BoxShadow> boxShadows,
  //     Gradient backgroundGradient,
  //     TextButton mainButton,
  //     OnTap onTap,
  //     bool isDismissible,
  //     bool showProgressIndicator,
  //     AnimationController progressIndicatorController,
  //     Color progressIndicatorBackgroundColor,
  //     Animation<Color> progressIndicatorValueColor,
  //     SnackStyle snackStyle,
  //     Curve forwardAnimationCurve,
  //     Curve reverseAnimationCurve,
  //     Duration animationDuration,
  //     double barBlur,
  //     double overlayBlur,
  //     Color overlayColor,
  //     Form userInputForm
  ///////////////////////////////////
```

Если вы предпочитаете традиционный snackbar, или хотите настроить его с нуля, вы можете использовать
`Get.rawSnackbar();` который предоставляет RAW API, на котором был построен Get.snackbar.

### Dialogs

Чтобы открыть:

```dart
Get.dialog(YourDialogWidget());
```

Чтобы открыть диалог по умолчанию:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

Вы также можете использовать Get.generalDialog вместо showGeneralDialog.

Для всех других виджетов диалога Flutter, включая cupertino, вы можете использовать Get.overlayContext вместо контекста и открывать его в любом месте вашего кода.
Для виджетов, которые не используют Overlay, вы можете использовать Get.context.
Эти два контекста будут работать в 99% случаев для замены контекста вашего пользовательского интерфейса, за исключением случаев, когда наследуемый виджет используется без контекста навигации.

### BottomSheets

Get.bottomSheet похож на showModalBottomSheet, но не требует контекста.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Music'),
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () {},
        ),
      ],
    ),
  )
);
```

## Вложенная навигация

Get сделал вложенную навигацию Flutter еще проще.
Вам не нужен контекст, и вы найдёте свой стек навигации по Id.

- ПРИМЕЧАНИЕ: Создание параллельных стеков навигации может быть опасным. В идеале не используйте NestedNavigators или используйте их редко. Если этого требует ваш проект, продолжайте, но имейте в виду, что хранение нескольких стеков навигации в памяти может быть не лучшим решением для потребления оперативной памяти.

Смотрите как это просто:

```dart
Navigator(
  key: Get.nestedKey(1), // create a key by index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetPageRoute(
        page: () => Scaffold(
          appBar: AppBar(
            title: Text("Main"),
          ),
          body: Center(
            child: TextButton(
              color: Colors.blue,
              onPressed: () {
                Get.toNamed('/second', id:1); // navigate by your nested route by index
              },
              child: Text("Go to second"),
            ),
          ),
        ),
      );
    } else if (settings.name == '/second') {
      return GetPageRoute(
        page: () => Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Main"),
            ),
            body: Center(
              child:  Text("second")
            ),
          ),
        ),
      );
    }
  }
),
```

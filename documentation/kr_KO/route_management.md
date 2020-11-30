- [라우트 관리](#라우트-관리)
  - [사용하는 방법](#사용하는-방법)
  - [이름없는 라우트 탐색](#이름없는-라우트-탐색)
  - [이름있는 라우트 탐색](#이름있는-라우트-탐색)
    - [이름있는 라우트에 데이터 보내기](#이름있는-라우트에-데이터-보내기)
    - [동적 url 링크](#동적-url-링크)
    - [미들웨어](#미들웨어)
  - [context 없이 탐색](#context-없이-탐색)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [중첩된 탐색](#중첩된-탐색)

# 라우트 관리

라우트 관리가 문제 있는 경우 GetX가 모든 것을 완벽히 설명해줍니다.

## 사용하는 방법

pubspec.yaml 파일에 추가:

```yaml
dependencies:
  get:
```

context 없이 routes/snackbars/dialogs/bottomsheets을 사용하거나 고급 GetX API를 사용하려면 MaterialApp 앞에 "Get"만 추가하여 GetMaterialApp으로 바꿔서 이용하세요!

```dart
GetMaterialApp( // 이전: MaterialApp(
  home: MyHome(),
)
```

## 이름없는 라우트 탐색

새 화면으로 이동:

```dart
Get.to(NextScreen());
```

snackbars, dialogs, bottomsheets 또는 Navigator.pop(context);로 보통 닫았던 것들을 닫기

```dart
Get.back();
```

다음 화면으로 이동하고 이전 화면에서 돌아오지 않는 경우 (스플래시나 로그인 화면 등을 사용하는 경우)

```dart
Get.off(NextScreen());
```

다음 화면으로 이동하고 이전 화면이 모두 닫히는 경우 (장바구니, 투표, 테스트에 유용함)

```dart
Get.offAll(NextScreen());
```

다음 화면으로 이동하고 돌아올때 바로 데이터를 받거나 업데이트할 경우:

```dart
var data = await Get.to(Payment());
```

다른 화면에서 이전화면으로 데이터를 전달할때:

```dart
Get.back(result: 'success');
```

그리고 사용방법:

예시:

```dart
if(data == 'success') madeAnything();
```

우리의 문법을 배우고 싶지 않습니까?
Navigator를 navigator로 바꾸시면 됩니다. 그리고 context를 사용하지 않아도 표준 navigator의 모든 기능이 가능합니다.
예시:

```dart

// 기본 Flutter navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// GetX는 context 필요 없이 Flutter 문법을 사용
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// GetX 문법 (이것은 동의하지 않겠지만 더 좋습니다)
Get.to(HomePage());


```

## 이름있는 라우트 탐색

- namedRoutes로 탐색하기를 선호하면 GetX도 지원합니다.

nextScreen으로 이동

```dart
Get.toNamed("/NextScreen");
```

다음으로 이동하고 트리에서 이전 화면을 지웁니다.

```dart
Get.offNamed("/NextScreen");
```

다음으로 이동하고 트리에서 이전 화면 전체를 지웁니다.

```dart
Get.offAllNamed("/NextScreen");
```

GetMaterialApp를 사용하여 라우트들을 정의:

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

정의 안된 라우트로 이동시 제어 (404 에러), GetMaterialApp에 unknownRoute를 정의할 수 있습니다.

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

### 이름있는 라우트에 데이터 보내기

무엇이든 인수를 통해 전달합니다. GetX는 String, Map, List, 클래스 인스턴스등 모든 것을 허용합니다.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

클래스 또는 컨트롤러에서:

```dart
print(Get.arguments);
// 출력: Get is the best
```

### 동적 url 링크

GetX는 웹과 같이 향상된 동적 url을 제공합니다. 웹 개발자들은 아마 Flutter에서 이미 이 기능을 원하고 있을 것 입니다. 대부분의 경우 패키지가 이 기능을 약속하고 URL이 웹에서 제공하는 것과 완전히 다른 구문을 제공하는 것을 보았을 것입니다. 하지만 GetX는 이 기능을 해결합니다.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

controller/bloc/stateful/stateless 클래스에서:

```dart
print(Get.parameters['id']);
// 출력: 354
print(Get.parameters['name']);
// 출력: Enzo
```

GetX는 쉽게 NamedParameters 전달을 할 수 있습니다:

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

경로 명으로 데이터 보냄

```dart
Get.toNamed("/profile/34954");
```

다음 화면에서 파라미터로 데이터를 가져옴

```dart
print(Get.parameters['user']);
// out: 34954
```

And now, all you need to do is use Get.toNamed() to navigate your named routes, without any context (you can call your routes directly from your BLoC or Controller class), and when your app is compiled to the web, your routes will appear in the url <3

### 미들웨어

If you want listen Get events to trigger actions, you can to use routingCallback to it

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

If you are not using GetMaterialApp, you can use the manual API to attach Middleware observer.

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

Create a MiddleWare class

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

Now, use Get on your code:

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
        child: RaisedButton(
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
        child: RaisedButton(
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
        child: RaisedButton(
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

## context 없이 탐색

### SnackBars

To have a simple SnackBar with Flutter, you must get the context of Scaffold, or you must use a GlobalKey attached to your Scaffold

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

With Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

With Get, all you have to do is call your Get.snackbar from anywhere in your code or customize it however you want!

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
  //     FlatButton mainButton,
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

If you prefer the traditional snackbar, or want to customize it from scratch, including adding just one line (Get.snackbar makes use of a mandatory title and message), you can use
`Get.rawSnackbar();` which provides the RAW API on which Get.snackbar was built.

### Dialogs

To open dialog:

```dart
Get.dialog(YourDialogWidget());
```

To open default dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

You can also use Get.generalDialog instead of showGeneralDialog.

For all other Flutter dialog widgets, including cupertinos, you can use Get.overlayContext instead of context, and open it anywhere in your code.
For widgets that don't use Overlay, you can use Get.context.
These two contexts will work in 99% of cases to replace the context of your UI, except for cases where inheritedWidget is used without a navigation context.

### BottomSheets

Get.bottomSheet is like showModalBottomSheet, but don't need of context.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Music'),
          onTap: () => {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () => {},
        ),
      ],
    ),
  )
);
```

## 중첩된 탐색

Get made Flutter's nested navigation even easier.
You don't need the context, and you will find your navigation stack by Id.

- NOTE: Creating parallel navigation stacks can be dangerous. The ideal is not to use NestedNavigators, or to use sparingly. If your project requires it, go ahead, but keep in mind that keeping multiple navigation stacks in memory may not be a good idea for RAM consumption.

See how simple it is:

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
            child: FlatButton(
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

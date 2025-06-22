- [路由管理](#路由管理)
  - [如何使用](#如何使用)
  - [普通路由导航](#普通路由导航)
  - [别名路由导航](#别名路由导航)
    - [发送数据到别名路由](#发送数据到别名路由)
    - [动态网页链接](#动态网页链接)
    - [中间件](#中间件)
  - [免 context 导航](#免-context-导航)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [嵌套导航](#嵌套导航)

# 路由管理

这是关于 GetX 在路由管理方面的完整解释。

## 如何使用

将此添加到你的 pubspec.yaml 文件中。

```yaml
dependencies:
  get:
```

如果你要在没有 context 的情况下使用路由/SnackBars/Dialogs/BottomSheets，或者使用高级的 Get API，你只需要在你的 MaterialApp 前面加上 “Get”，就可以把它变成 GetMaterialApp，享受吧！

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## 普通路由导航

导航到新的页面。

```dart
Get.to(NextScreen());
```

关闭 SnackBars、Dialogs、BottomSheets 或任何你通常会用 Navigator.pop(context) 关闭的东西。

```dart
Get.back();
```

进入下一个页面，但没有返回上一个页面的选项 (用于 SplashScreens，登录页面等)。

```dart
Get.off(NextScreen());
```

进入下一个界面并取消之前的所有路由 (在购物车、投票和测试中很有用)。

```dart
Get.offAll(NextScreen());
```

要导航到下一条路由，并在返回后立即接收或更新数据。

```dart
var data = await Get.to(Payment());
```

在另一个页面上，发送前一个路由的数据。

```dart
Get.back(result: 'success');
```

并使用它，例：

```dart
if(data == 'success') madeAnything();
```

你不想学习我们的语法吗？
只要把 Navigator (大写) 改成 navigator (小写)，你就可以拥有标准导航的所有功能，而不需要使用 context，例如：

```dart

// 默认的 Flutter 导航
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// 使用 Flutter 语法获得，而不需要 context。
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// get 语法 (这要好得多)
Get.to(HomePage());


```

## 别名路由导航

- 如果你喜欢用别名路由导航，Get 也支持。

导航到下一个页面

```dart
Get.toNamed("/NextScreen");
```

浏览并删除前一个页面。

```dart
Get.offNamed("/NextScreen");
```

浏览并删除所有以前的页面。

```dart
Get.offAllNamed("/NextScreen");
```

要定义路由，使用 GetMaterialApp。

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

要处理到未定义路线的导航 (404 错误)，可以在 GetMaterialApp 中定义 unknownRoute 页面。

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

### 发送数据到别名路由

只要发送你想要的参数即可。Get 在这里接受任何东西，无论是一个字符串，一个 Map，一个 List，甚至一个类的实例。

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

在你的类或控制器上：

```dart
print(Get.arguments);
// print out: Get is the best
```

### 动态网页链接

Get 提供高级动态 URL，就像在 Web 上一样。Web 开发者可能已经在 Flutter 上想要这个功能了，Get 也解决了这个问题。

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

在你的 controller/bloc/stateful/stateless 类上：

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

你也可以用 Get 轻松接收 NamedParameters。

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
       // 你可以为有参数的路由定义一个不同的页面，也可以为没有参数的路由定义一个不同的页面，但是你必须在不接收参数的路由上使用斜杠"/"，就像上面说的那样。
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

发送别名路由数据

```dart
Get.toNamed("/second/34954");
```

在第二个页面上，通过参数获取数据

```dart
print(Get.parameters['user']);
// out: 34954
```

或像这样发送多个参数

```dart
Get.toNamed("/profile/34954?flag=true");
```

在第二个屏幕上，通常按参数获取数据

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
// out: 34954 true
```


现在，你需要做的就是使用 Get.toNamed() 来导航你的别名路由，不需要任何 context (你可以直接从你的 BLoC 或 Controller 类中调用你的路由)，当你的应用程序被编译到 web 时，你的路由将出现在 URL 中。

### 中间件

如果你想通过监听 Get 事件来触发动作，你可以使用 routingCallback 来实现。

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

如果你没有使用 GetMaterialApp，你可以使用手动 API 来附加 Middleware 观察器。

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

创建一个 MiddleWare 类

```dart
class MiddleWare {
  static observer(Routing routing) {
    // 你除了可以监听路由外，还可以监听每个页面上的SnackBars、Dialogs和Bottomsheets。
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

现在，在你的代码上使用 Get：

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

## 免 context 导航

### SnackBars

用 Flutter 创建一个简单的 SnackBar，你必须获得 Scaffold 的 context，或者你必须使用一个 GlobalKey 附加到你的 Scaffold 上。

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// 在小组件树中找到脚手架并使用它显示一个SnackBars。
Scaffold.of(context).showSnackBar(snackBar);
```

用 Get：

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

有了 Get，你所要做的就是在你代码的任何地方调用你的 Get.snackbar，或者按照你的意愿定制它。

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

如果您喜欢传统的 SnackBars，或者想从头开始定制，包括只添加一行 (Get.snackbar 使用了一个强制性的标题和信息)，您可以使用
`Get.rawSnackbar();` 它提供了建立 Get.snackbar 的 RAW API。

### Dialogs

打开 Dialogs：

```dart
Get.dialog(YourDialogWidget());
```

打开默认 Dialogs：

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

你也可以用 Get.generalDialog 代替 showGeneralDialog。

对于所有其他的 FlutterDialogs 小部件，包括 cupertinos，你可以使用 Get.overlayContext 来代替 context，并在你的代码中任何地方打开它。
对于不使用 Overlay 的小组件，你可以使用 Get.context。
这两个 context 在 99%的情况下都可以代替你的 UIcontext，除了在没有导航 context 的情况下使用 inheritedWidget 的情况。

### BottomSheets

Get.bottomSheet 类似于 showModalBottomSheet，但不需要 context：

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

## 嵌套导航

Get 让 Flutter 的嵌套导航更加简单。
你不需要 context，而是通过 Id 找到你的导航栈。

- 注意：创建平行导航堆栈可能是危险的。理想的情况是不要使用 NestedNavigators，或者尽量少用。如果你的项目需要它，请继续，但请记住，在内存中保持多个导航堆栈可能不是一个好主意 (消耗 RAM)。

看看它有多简单：

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

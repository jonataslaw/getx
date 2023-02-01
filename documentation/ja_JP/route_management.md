- [Route管理](#Route管理)
  - [使い方](#使い方)
  - [通常Routeによるナビゲーション](#通常Routeによるナビゲーション)
  - [名前付きRouteによるナビゲーション](#名前付きRouteによるナビゲーション)
    - [名前付きRouteにデータを送る](#名前付きRouteにデータを送る)
    - [動的URLの生成](#動的URLの生成)
    - [ミドルウェアの使用](#ミドルウェアの使用)
  - [contextを使わないナビゲーション](#contextを使わないナビゲーション)
    - [SnackBar](#snackbar)
    - [Dialog](#dialog)
    - [BottomSheet](#bottomsheet)
  - [ネスト構造のナビゲーション](#ネスト構造のナビゲーション)

# Route管理

このドキュメントではGetXにおけるRoute管理のすべてをご説明します。

## How to use

次の3文字を pubspec.yaml ファイルに追加してください。

```yaml
dependencies:
  get:
```

Route / SnackBar / Dialog / BottomSheet をcontextなしで、あるいは高レベルのGet APIを使用するには MaterialApp の前に「Get」を追加してください。それだけで GetMaterialApp の機能が使用できます。

```dart
GetMaterialApp( // 変更前: MaterialApp(
  home: MyHome(),
)
```

## 名前付きRouteによる画面遷移

次の画面に遷移するには Get.to を使ってください。

```dart
Get.to(NextScreen());
```

SnackBar / Dialog / BottomSheet など Navigator.pop(context) で閉じるものと同じものを閉じるには Get.back を使います。

```dart
Get.back();
```

次の画面に遷移しつつ、前の画面に戻れないようにするには Get.off を使います（スプラッシュスクリーンやログイン画面などで使用)。

```dart
Get.off(NextScreen());
```

次の画面に遷移して、それ以前のRouteはすべて破棄するには Get.offAll を使います（ショッピングカート、投票、テストなどで使用)

```dart
Get.offAll(NextScreen());
```

次の画面に遷移して、戻ったらデータを受け取る方法はこちら。

```dart
var data = await Get.to(Payment());
```

次の画面では、このようにデータを前の画面に送る必要があります。

```dart
Get.back(result: 'success');
```

そして使いましょう。

ex:

```dart
if(data == 'success') madeAnything();
```

どのようなシンタックスがあるかもっと知りたいですか？
いつもの Navigator ではなく navigator と入れてみてください。通常のNavigatorで使えるプロパティがcontextなしで使えるようになっているかと思います。

```dart

// 通常のFlutterによるNavigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// GetではFlutterのシンタックスをcontextなしで使えます
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Getのシンタックス（上記よりかなり短いですね）
Get.to(HomePage());


```

## 名前付きRouteによる画面遷移

- Getは名前付きRouteによる遷移もサポートしています。

次の画面への遷移はこう。

```dart
Get.toNamed("/NextScreen");
```

Get.off の名前付きRoute版。

```dart
Get.offNamed("/NextScreen");
```

Get.offAll の名前付きRoute版。

```dart
Get.offAllNamed("/NextScreen");
```

Routeを定義するにはGetMaterialAppを使ってください。

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

未定義Route（404エラー）に遷移させるには、GetMaterialAppで unknownRoute を設定してください。

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

### 名前付きRouteにデータを送る

次の画面に渡すデータは arguments で引数を設定します。Getでは引数にどんなものでも指定できます。StringでもMapでもListでも、クラスのインスタンスでも大丈夫です。

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

ビュー側のクラスやControllerで値を使うにはこうしてください。

```dart
print(Get.arguments);
// Get is the best が表示される
```

### 動的URLの生成

Getはウェブのような高度な動的URLを提供します。ウェブ開発者はFlutterにこの機能が提供されることを待ち望んでいたことでしょう。この機能の提供を謳うパッケージは存在しますが、ウェブ上のURLとは全く異なるシンタックスが表示されているのを見たことがあるかもしれません。Getはこの点も解決します。

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

ビュー側のクラスやControllerで値を使う方法。

```dart
print(Get.parameters['id']);
// 出力: 354
print(Get.parameters['name']);
// 出力: Enzo
```

この名前付きパラメーターはこのように簡単に受け取ることもできます。

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
       // 引数userを使う場合と使わない場合で別ページを定義することが可能です。
       // ただ、そのためにはスラッシュ '/' をベースのRoute名の後に入れる必要があります。
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

Route名を使ってデータを送る方法。

```dart
Get.toNamed("/profile/34954");
```

次の画面でデータを受け取る方法。

```dart
print(Get.parameters['user']);
// out: 34954
```

複数のパラメーターを送信するにはこちら。

```dart
Get.toNamed("/profile/34954?flag=true&country=italy");
```
もしくは
```dart
var parameters = <String, String>{"flag": "true","country": "italy",};
Get.toNamed("/profile/34954", parameters: parameters);
```

次の画面でデータを受け取る方法。

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
print(Get.parameters['country']);
// 出力: 34954 true italy
```



あとは Get.toNamed() を使い、名前付きRouteを指定するだけです（contextを使わないので BLoC や Controller から直接Routeを呼び出すことができます）。ウェブアプリとしてコンパイルされると、Routeが正しくURLに表示されます。

### ミドルウェアの使用

何かのアクションのトリガーとなるイベントを取得したい場合は、routingCallbackを使用してください。

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

GetMaterialAppを使用しない場合は、手動のAPIを使ってミドルウェアオブザーバーを設定してください。

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // ここ
      ],
    ),
  );
}
```

ミドルウェアクラスを作成する

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Routeの他に SnackBar / Dialog / BottomSheet のイベントも監視することができます。
    /// また、ここで直接この3つのいずれかを表示したい場合は、
    /// イベント自身が「それではない」ことを事前にチェックする必要があります。
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

それではGetをコードで使ってみましょう。

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

## contextを使わないナビゲーション

### SnackBar

FlutterでシンプルなSnackBarを表示したいとき、Scaffoldのcontextか、GlobalKeyを取得する必要があります。

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// WidgetツリーでScaffoldを探し、それをSnackBar表示に使用します。
Scaffold.of(context).showSnackBar(snackBar);
```

Getならこうなります。

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

コードのどこにいようと、Get.snackbar を呼ぶだけでいいのです。カスタマイズも自由自在です。

```dart
Get.snackbar(
  "Hey i'm a Get SnackBar!", // タイトル
  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // 本文
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// すべてのプロパティ //////////
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

従来の SnackBar がお好みの場合や、ゼロからカスタマイズしたい場合 (たとえば Get.snackbar ではタイトルと本文が必須項目となっています)は `Get.rawSnackbar();` を使ってください。SnackBarの元々のAPIを取得できます。

### Dialog

ダイアログを表示する方法。

```dart
Get.dialog(YourDialogWidget());
```

デフォルトのダイアログを表示する方法。

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

また showGeneralDialog の代わりに Get.generalDialog が使えます。

Overlayを使用するCupertino含むその他のFlutterのダイアログについては、contextの代わりに Get.overlayContext を使うことでコードのどこでもダイアログを表示することができます。
Overlayを使わないWidgetについては、Get.context が使えます。
これら2つのcontextはほとんどのケースでUIのcontextを代替することができるでしょう。ただし、ナビゲーションのcontextを使用せずInheritedWidgetが使われているケースは例外です。

### BottomSheet

Get.bottomSheet は showModalBottomSheet に似ていますが、contextが不要です。

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

## ネスト構造のナビゲーション

GetはFlutterのネスト構造のナビゲーションの扱いも簡単にしてくれます。
contextを必要とせず、IDによりナビゲーションのスタックを見つけることができます。

- 注: 並列のナビゲーションスタックを作成することは危険です。ネスト構造のNavigatorを使用しないか、使用を控えめにするのが理想です。必要なら使っていただいても問題ありませんが、複数のナビゲーションのスタックを保持することはRAM消費の面で好ましくないということは覚えておいてください。

こんなに簡単にできます。

```dart
Navigator(
  key: Get.nestedKey(1), // インデックス指定でkey作成
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
                Get.toNamed('/second', id:1); // インデックス指定でネスト型Routeに遷移
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

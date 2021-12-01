![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

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


<div align="center">

**言語**


[![英語](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![ベトナム語](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
[![インドネシア語](https://img.shields.io/badge/Language-Indonesian-blueviolet?style=for-the-badge)](README.id-ID.md)
[![ウルドゥー語](https://img.shields.io/badge/Language-Urdu-blueviolet?style=for-the-badge)](README.ur-PK.md)
[![中国語](https://img.shields.io/badge/Language-Chinese-blueviolet?style=for-the-badge)](README.zh-cn.md)
[![ポルトガル語](https://img.shields.io/badge/Language-Portuguese-blueviolet?style=for-the-badge)](README.pt-br.md)
[![スペイン語](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README-es.md)
[![ロシア語](https://img.shields.io/badge/Language-Russian-blueviolet?style=for-the-badge)](README.ru.md)
[![ポーランド語](https://img.shields.io/badge/Language-Polish-blueviolet?style=for-the-badge)](README.pl.md)
[![韓国語](https://img.shields.io/badge/Language-Korean-blueviolet?style=for-the-badge)](README.ko-kr.md)
[![フランス語](https://img.shields.io/badge/Language-French-blueviolet?style=for-the-badge)](README-fr.md)
[![日本語](https://img.shields.io/badge/Language-Japanese-blueviolet?style=for-the-badge)](README-ja.md)

</div>

- [Getとは](#Getとは)
- [インストール方法](#インストール方法)
- [GetXによるカウンターアプリ](#GetXによるカウンターアプリ)
- [三本柱](#三本柱)
  - [状態管理](#状態管理)
    - [リアクティブな状態管理](#リアクティブな状態管理)
    - [状態管理に関する詳細ドキュメント](#状態管理に関する詳細ドキュメント)
  - [Route管理](#Route管理)
    - [Route管理に関する詳細ドキュメント](#Route管理に関する詳細ドキュメント)
  - [依存オブジェクト管理](#依存オブジェクト管理)
    - [依存オブジェクト管理に関する詳細ドキュメント](#依存オブジェクト管理に関する詳細ドキュメント)
- [ユーティリティ](#ユーティリティ)
  - [多言語対応](#多言語対応)
    - [翻訳ファイル](#翻訳ファイル)
      - [翻訳ファイルの利用](#翻訳ファイルの利用)
    - [ロケール](#ロケール)
      - [ロケールの変更](#ロケールの変更)
      - [システムのロケールを読み込む](#システムのロケールを読み込む)
  - [Themeの変更](#Themeの変更)
  - [GetConnect](#getconnect)
    - [デフォルト設定](#デフォルト設定)
    - [カスタム設定](#カスタム設定)
  - [GetPageにミドルウェアを設定](#GetPageにミドルウェアを設定)
    - [実行優先度](#実行優先度)
    - [redirect](#redirect)
    - [onPageCalled](#onpagecalled)
    - [onBindingsStart](#onbindingsstart)
    - [onPageBuildStart](#onpagebuildstart)
    - [onPageBuilt](#onpagebuilt)
    - [onPageDispose](#onpagedispose)
  - [その他API](#その他API)
    - [オプションのグローバル設定と手動設定](#オプションのグローバル設定と手動設定)
    - [ローカルステートWidget](#ローカルステートWidget)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [お役立ちTIPS](#お役立ちTIPS)
    - [StateMixin](#statemixin)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [使い方](#使い方])
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
  - [テストの実行](#テストの実行)
    - [mockitoやmocktailを使う場合](#mockitoやmocktailを使う場合)
    - [Get.reset()](#Get.reset())
    - [Get.testMode](#Get.testMode)
- [バージョン2.0からの破壊的変更](#バージョン2.0からの破壊的変更)
- [なぜGetXなのか](#なぜGetXなのか)
- [コミュニティ](#コミュニティ)
  - [コミュニティチャンネル](#コミュニティチャンネル)
  - [コントリビュート方法](#コントリビュート方法)
  - [GetXに関する記事と動画](#GetXに関する記事と動画)

# Getとは

- GetXはFlutterのための超軽量でパワフルなソリューションです。高パフォーマンスな状態管理機能、インテリジェントな依存オブジェクト管理機能、そしてRoute管理機能の三本柱を軽量かつ実用的な形で組み合わせています。

- GetXは3つの基本原則を念頭に開発されています。 **【生産性、パフォーマンス、コードの分離性】** これらはライブラリ内のすべてのリソースに優先適用されている原則です。

  - **パフォーマンス:** GetXは高いパフォーマンスと最小限のリソース消費を目標にしています。GetXはでは Stream および ChangeNotifier を利用しなくて済みます。

  - **生産性:** GetXはシンプルで使い心地のいいシンタックスを採用しています。あなたの実現したい機能がどんなものであれ、GetXを使えばより簡単に実現できる方法が見つかるでしょう。開発にかかる時間を短縮し、あなたのアプリケーションのパフォーマンスを最大限引き出してくれます。

    開発者はメモリリソースの管理に気を配るのが常です。しかしGetXでは、リソースが使用されていないときはメモリから削除されるのがデフォルト動作のため、過度に気にかける必要はありません。（逆にメモリに残しておきたい場合は、依存オブジェクトをインスタンス化するメソッドを使う際に「permanent: true」と宣言してください）これにより時間が節約できますし、不要な依存オブジェクトがメモリ上に残るリスクも少なくなります。メモリへの読み込みについてもデフォルトは遅延読み込みであり、使用するときに初めてメモリ上に読み込まれます。

  - **コードの分離性:** GetXを使うと、ビュー、プレゼンテーションロジック、ビジネスロジック、依存オブジェクトの注入、およびナビゲーション周りのコードを書き分けやすくなります。Routeのナビゲーションにはcontextを必要としないため、Widgetツリーに依存することはありません。ロジックについてもInheritedWidget経由でController/BLoCにアクセスする際のcontextは必要ありません。プレゼンテーションロジックとビジネスロジックをUIクラスから完全に切り離すことができます。また、Controller/モデル/BLoCのクラスを、`MultiProvider`を使ってWidgetツリーに注入する必要もありません。GetXでは独自の依存オブジェクト注入機能を使用し、ビュークラスからビューとは無関係なコードをなくすことができるのです。

    GetXを使うことでアプリケーションの各機能がどこにあるのかがわかりやすくなり、自然と見やすいコードになります。メンテナンスが容易になるだけでなく、それまでのFlutterでは考えられなかったモジュール共有が簡単に実現できるようになりました。
    BLoCはこの分野におけるFlutterの出発点と言えるものでしたが、GetXはこれを正統進化させており、ビジネスロジックのみならずプレゼンテーションロジックも分離することができます。そのほかデータレイヤーはもちろん、依存オブジェクトやRouteの注入に関するコードも。どこに何が配置されているのか全体の見通しがしやすくなり、Hello Worldを表示させるかのように簡単にアプリの機能を利用できるようになるでしょう。
    Flutterアプリを作るならGetXは最も簡単で実用的、かつスケーラブルなソリューションです。強力なエコシステムも存在があるため、初心者にはわかりやすさ、プロには正確性を提供することができます。そしてFlutter SDKにはない幅広い種類のAPIを提供し、セキュアで安定的な環境を構築します。

- GetXは肥大化したライブラリではありません。何も気にせずすぐに開発を始められるよう多数の機能を標準で備えていますが、それぞれの機能は個別にコンテナに入っており、使用してはじめて起動します。状態管理機能しか利用していない場合はその機能だけがコンパイルされます。Route管理機能だけを利用していれば、状態管理機能がコンパイルされることはありません。

- GetXには巨大なエコシステム、コミュニティ、コラボレーターの存在があるため、Flutterが存在する限りメンテナンスされ続けます。またGetXもFlutterと同様にAndroid、iOS、Web、Mac、Linux、Windows、そしてあなたのサーバー上で、単一のコードから実行することができます。

**[Get Server](https://github.com/jonataslaw/get_server)を使うことで、フロントエンドで作成したコードをバックエンドで再利用することが可能です。**

**さらに、[Get CLI](https://github.com/jonataslaw/get_cli)を使えば、サーバー側でもフロントエンド側でも開発プロセス全体を自動化することができます。**

**また、生産性をさらに高めるためのツールとして、[VSCode用の拡張機能](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) と [Android Studio/Intellij用の拡張機能](https://plugins.jetbrains.com/plugin/14975-getx-snippets)があります。**

# インストール方法

Getパッケージを pubspec.yaml に追加します:

```yaml
dependencies:
  get:
```

使用するときはこのようにインポートしてください:

```dart
import 'package:get/get.dart';
```

# GetXによるカウンターアプリ

Flutterで新規プロジェクトを作成する際に表示されるカウンターアプリは、コメントを含めると100行以上あります。Getの実力を示すため、このカウンターアプリを可読性を重視した形で、コメントを含めてわずか26行のコードで作成する方法を紹介します。

- ステップ1:
  MaterialAppの前に「Get」を足して、GetMaterialAppにします。

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- 注1: GetMaterialAppはFlutterのMaterialAppに手を加えたものではありません。MaterialAppをchildに持ち、諸々の追加設定をしてくれるWidgetに過ぎません。この設定は手動でも可能ですが、その必要はありません。GetMaterialAppは、Routeの作成・注入、言語翻訳の注入など、ナビゲーションに必要なものをすべて注入してくれます。Getを状態管理や依存オブジェクト管理に限定して使用する場合は、GetMaterialAppを使用する必要はありません。GetMaterialAppは、Route、SnackBar、多言語対応、BottomSheet、Dialog、contextなしの高レベルAPIを利用する場合に必要です。
- 注2: このステップは、Route管理機能（`Get.to()`や`Get.back()`など）を使用しない場合は、必要ありません。

- ステップ2:
  ビジネスロジッククラスを作成し、そこに必要な変数、メソッド、コントローラをすべて配置します。
  変数に ".obs" を付け足すことで、その変数の値の変化を監視することが可能になります。

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- ステップ3:
  ビューを作成します。StatelessWidgetを使用することでRAMが節約できます。GetではStatefulWidgetを使用する必要がなくなるかもしれません。

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Get.put()を使ってクラスをインスタンス化することですべての子Routeで利用できるようになります。
    final Controller c = Get.put(Controller());

    return Scaffold(
      // countが変わるたびにTextを更新するにはObx(()=>)を使ってください。
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // 8行使っていたNavigator.pushの代わりに短い Get.to()を使ってください。context不要です。
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // 他のページで使われているコントローラーを見つけてきてくれます。
  final Controller c = Get.find();

  @override
  Widget build(context){
     // 最新のcount変数の値にアクセス
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Result:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

これはシンプルな例ですが、すでにGetがいかに強力であるかがわかると思います。プロジェクトが大きければ大きいほど、この差はもっと開くでしょう。

Getはチームでの作業を想定して設計されていますが、個人開発者の仕事もシンプルにしてくれます。

パフォーマンスを落とさず納期までにすべて納品。Getはすべての人に向いているわけではありませんが、このフレーズにぴんと来た人には確実に向いています！

# 三本柱

## 状態管理

Getの状態管理には、非リアクティブ（GetBuilder）と、リアクティブ（GetX/Obx）の2つのアプローチがあります。

### リアクティブな状態管理

リアクティブプログラミングは複雑であると言われ、多くの人に敬遠されています。GetXは、リアクティブプログラミングをシンプルなものに変えます:

* StreamControllerを作る必要はありません。
* 変数ごとにStreamBuilderをセットする必要はありません。
* 状態ごとにクラスを作る必要はありません。
* 初期値のためにgetを準備する必要はありません。
- コードの自動生成をする必要がありません。

GetにおけるリアクティブプログラミングはsetStateと同じように簡単です。

例えば、名前の変数があって、それを変更するたびに、その名前を使っているすべてのWidgetを自動で更新したい場合。

```dart
var name = 'Jonatas Borges';
```

このnameをObservable(監視可能)にするには, ".obs"を値の末尾に付けるだけです。

```dart
var name = 'Jonatas Borges'.obs;
```

UIでその値を表示し、値が変わるたびに内容を更新したい場合は次のようにします。

```dart
Obx(() => Text("${controller.name}"));
```

以上です。こんなに簡単なんですよ。

### 状態管理に関する詳細ドキュメント

**状態管理に関するより詳細な説明を知りたい方は[こちらの日本語ドキュメント](./documentation/ja_JP/state_management.md)をご覧ください。多くの事例や、非リアクティブな状態管理とリアクティブな状態管理の違いについても説明されています。**

GetXパワーがもたらす利点をより理解していただけると思います。

## Route管理

GetXはcontextなしでRoute/SnackBar/Dialog/BottomSheetを使用することができます。具体的に見ていきましょう。

いつものMaterialAppの前に「Get」を付け足して、GetMaterialAppにしましょう。

```dart
GetMaterialApp( // MaterialApp の前に Get
  home: MyHome(),
)
```

新しいRouteに画面遷移するにはこのシンタックス。

```dart
Get.to(NextScreen());
```

名前付きRouteに画面遷移するにはこのシンタックス。名前付きRouteの詳細は[こちらの日本語ドキュメント](./documentation/ja_JP/route_management.md#navigation-with-named-routes)

```dart
Get.toNamed('/details');
```

SnackBar、Dialog、BottomSheetなど、Navigator.pop(context)で閉じられるRouteはこれで閉じます。

```dart
Get.back();
```

次の画面に移動した後、前の画面に戻れないようにする場合（スプラッシュスクリーンやログイン画面など）はこちら。

```dart
Get.off(NextScreen());
```

次の画面に進み、前のRouteをすべてキャンセルする場合（ショッピングカート、アンケート、テストなど）はこちら。

```dart
Get.offAll(NextScreen());
```

以上、contextを一度も使わなかったことに気付きましたか？これがGetでRoute管理を行う最大のメリットのひとつです。contextを使わないので、たとえばcontrollerクラスの中でも、これらのメソッドを実行することができます。

### Route管理に関する詳細ドキュメント

**Getは名前付きRouteでも動作し、Routeの下位レベルの制御も可能です。詳細なドキュメントは[こちらの日本語ドキュメント](./documentation/ja_JP/route_management.md)にあります。**

## 依存オブジェクト管理

Getにはシンプルで強力な依存オブジェクト注入機能があります。わずか1行のコードで、Provider contextやinheritedWidgetも使わず、BLoCやControllerのようなクラスのインスタンスを取得することができます。

```dart
Controller controller = Get.put(Controller()); // controller = Controller() とする代わりに
```

- 注: Getの状態管理機能を使用している場合は、Bindings APIにもご注目を。BindingsはビューとControllerを結びつけるのをより便利にしてくれます。

一つのクラスの中でControllerクラスをインスタンス化するのではなく、Getインスタンスの中でインスタンス化することで、アプリ全体でControllerが利用できるようになります。

**ヒント:** Getの依存オブジェクト注入機能の部分は、パッケージ全体の中でも他の部分と切り離されているので、たとえば、あなたのアプリがすでに状態管理機能を一部で使用していたとしても、それらを書き直す必要はなく、この依存オブジェクト注入機能をそのまま使用することができます。

```dart
controller.fetchApi();
```

色々なRouteを行き来した後に、あるControllerクラスのデータにアクセスする必要が生じたとしましょう。ProviderやGet_itなら再びそのクラスに依存オブジェクトを注入する必要がありますよね？Getの場合は違います。Getでは「find」と依頼するだけで、追加の依存オブジェクトの注入は必要ありません。

```dart
Controller controller = Get.find();
//マジックみたいですね。Getは正しいcontrollerをきちんと探してきてくれますよ。100万のcontrollerのインスタンスがあっても、Getは必ず正しいcontrollerを探し当てます。
```

そして、findで取得したコントローラーのデータをこのように呼び出すことができます。

```dart
Text(controller.textFromApi);
```

### 依存オブジェクト管理に関する詳細ドキュメント

**依存オブジェクト管理に関するより詳細な説明は[こちらの日本語ドキュメント](./documentation/ja_JP/dependency_management.md)をご覧ください。**

# ユーティリティ

## 多言語対応

### 翻訳ファイル

翻訳ファイルはシンプルなキーと値のMapとして保持されます。
翻訳を追加するには、クラスを作成して `Translations` を継承します。

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

#### 翻訳ファイルの利用

指定されたキーに `.tr` （translateのtr）を追加するだけで、`Get.locale` と `Get.fallbackLocale` の現在の値をに沿って適切な言語に翻訳されます。

```dart
Text('title'.tr);
```

#### 単数系と複数形に対応

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### パラメーターに対応

```dart
import 'package:get/get.dart';


Map<String, Map<String, String>> get keys => {
    'en_US': {
        'logged_in': 'logged in as @name with email @email',
    },
    'es_ES': {
       'logged_in': 'iniciado sesión como @name con e-mail @email',
    }
};

Text('logged_in'.trParams({
  'name': 'Jhon',
  'email': 'jhon@example.com'
  }));
```

### ロケール

ロケールと翻訳を定義するため、`GetMaterialApp`にパラメータを渡します。

```dart
return GetMaterialApp(
    translations: Messages(), // Translationsを継承したクラスのインスタンス
    locale: Locale('en', 'US'), // このロケール設定に沿って翻訳が表示される
    fallbackLocale: Locale('en', 'UK'), // 無効なロケールだったときのフォールバックを指定
);
```

#### ロケールの変更

ロケールを変更するには、`Get.updateLocale(locale)`を呼び出します。翻訳は新しいロケールに沿ってなされます。

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### システムのロケールを読み込む

システムのロケールを読み込むには、`Get.deviceLocale`を使用します。

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Themeの変更

`GetMaterialApp`より上位のWidgetを使ってThemeを変更しないでください。Keyの重複を引き起こす可能性があります。アプリのThemeを変更するためには「ThemeProvider」Widgetを作成するという前時代的なアプローチが採られることが多いですが、**GetX™**ではこのようなことは必要ありません。

カスタムのThemeDataを作成したら、それを`Get.changeTheme`内に追加するだけです。

```dart
Get.changeTheme(ThemeData.light());
```

もし、`onTap`でThemeを変更するボタンを作りたいのであれば、以下の2つの**GetX™** APIを組み合わせることができます。

- Dark Theme が使われているかどうかをチェックするAPI
- Theme を変えるAPI（ボタンの`onPressed`の中に設置できます）

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Darkモードが有効であれば、_light theme_に切り替わり、Lightモードが有効なら、_dark theme_に切り替わります。

## GetConnect

GetConnect は、http または websocket を使用してバックエンドとフロントエンド間の通信を行う機能です。

### デフォルト設定

GetConnectを拡張することで、GET/POST/PUT/DELETE/SOCKETメソッドを使用して、Rest APIやウェブソケットと通信することができます。

```dart
class UserProvider extends GetConnect {
  // Get リクエスト
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post リクエスト
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // File付き Post リクエスト
  Future<Response<CasesModel>> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
```

### カスタム設定

GetConnect は高度なカスタマイズが可能です。ベースUrlの定義はもちろん、リクエストヘッダーを足したり、レスポンスボディに変更を加えたり、認証情報を追加したり、認証回数の制限を設けたりすることができるほか、リクエストをModelに変換するデコーダを定義することもできます。

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // デフォルトデコーダーをセット
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrlをセット

    // リクエストヘッダーに 'apikey' プロパティを付け足しています。
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // サーバーが"Brazil"を含むデータを送ってきてもユーザーに表示されることはありません。
    // レスポンスがUIレイヤーに届けられる前にデータが取り除かれているからです。
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // ヘッダーをセット
      request.headers['Authorization'] = "$token";
      return request;
    });

    // HttpStatus が HttpStatus.unauthorized である限り、
    // 3回まで認証が試みられます。
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPageにミドルウェアを設定

GetPageに新しいプロパティが追加され、GetMiddleWareのListを設定することができるようになりました。GetMiddleWareは設定した任意の順序で実行されます。

**注**: GetPageにミドルウェアを設定すると、そのページの子ページはすべて同じミドルウェアを自動的に持つことになります。

### 実行優先度

GetMiddlewareに設定したpriority(優先度)の若い順にミドルウェアが実行されます。

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

この場合の実行順序は **-8 => 2 => 4 => 5**

### redirect

redirect関数は、Routeを呼び出してページが検索されると実行されます。リダイレクト先のRouteSettingsが戻り値となります。もしくはnullを与えれば、リダイレクトは行われません。

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

onPageCalled関数は、ページが呼び出された直後に実行されます。
この関数を使ってページの内容を変更したり、新しいページを作成したりすることができます。

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### onBindingsStart

onBindingsStart関数は、Bindingsが初期化される直前に実行されます。
たとえば、ページのBindingsを変更することもできます。

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### onPageBuildStart

onPageBuildStart関数は、Bindingsが初期化された直後、ページWidgetが作成される前に実行されます。

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### onPageBuilt

onPageBuilt関数は、GetPage.page(ページのビルダー)が呼び出された直後に実行され、表示されるWidgetを結果として受け取ることができます。

### onPageDispose

onPageDispose関数は、ページに関するすべてのオブジェクト（Controller、ビューなど）が破棄された直後に実行されます。

## その他API

```dart
// 現在の画面に渡されているargs(引数)を取得
Get.arguments

// 直前のRouteの名前("/" など)を取得
Get.previousRoute

// 現在のRouteオブジェクトを取得
Get.rawRoute

// GetObserverからRoutingを取得
Get.routing

// SnackBarが開いているかチェック
Get.isSnackbarOpen

// Dialogが開いているかチェック
Get.isDialogOpen

// BottomSheetが開いているかチェック
Get.isBottomSheetOpen

// Routeを削除
Get.removeRoute()

// 引数のRoutePredicateがtrueを返すまで画面を戻る
Get.until()

// 引数で指定したRouteに進み、RoutePredicateがtrueを返すまで画面を戻る
Get.offUntil()

// 引数で指定した名前付きRouteに進み、RoutePredicateがtrueを返すまで画面を戻る
Get.offNamedUntil()

// アプリがどのプラットフォームで実行されているかのチェック
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// アプリがどのデバイスで実行されているかのチェック
GetPlatform.isMobile
GetPlatform.isDesktop
// プラットフォームとデバイスのチェックは独立
// 同じOSでもウェブで実行されているのか、ネイティブで実行されているのか区別
GetPlatform.isWeb


// MediaQuery.of(context).size.height と同じ
// ただしimmutable
Get.height
Get.width

// Navigatorの現在のcontextを取得
Get.context

// SnackBar/Dialog/BottomSheet などフォアグラウンドのcontextを取得
Get.overlayContext

// 注: 以降のメソッドはcontextの拡張メソッドです。
// contextと同じくUIのどこからでもアクセスできます。

// ウィンドウサイズの変更などに合わせて変わる height/width を取得
context.width
context.height

// 画面の半分のサイズ,1/3のサイズなどを取得
// レスポンシブなデザインの場合に便利
// オプションのパラメーター dividedBy で割る数を指定
// オプションのパラメーター reducedBy でパーセンテージを指定
context.heightTransformer()
context.widthTransformer()

/// MediaQuery.of(context).size とほぼ同じ
context.mediaQuerySize()

/// MediaQuery.of(context).padding とほぼ同じ
context.mediaQueryPadding()

/// MediaQuery.of(context).viewPadding とほぼ同じ
context.mediaQueryViewPadding()

/// MediaQuery.of(context).viewInsets とほぼ同じ
context.mediaQueryViewInsets()

/// MediaQuery.of(context).orientation とほぼ同じ
context.orientation()

/// デバイスがランドスケープ(横長)モードかどうかチェック
context.isLandscape()

/// デバイスがポートレート(縦長)モードかどうかチェック
context.isPortrait()

/// MediaQuery.of(context).devicePixelRatio とほぼ同じ
context.devicePixelRatio()

/// MediaQuery.of(context).textScaleFactor とほぼ同じ
context.textScaleFactor()

/// 画面の短辺の長さを取得
context.mediaQueryShortestSide()

/// 画面の横幅が800より大きい場合にtrueを返す
context.showNavbar()

/// 画面の短辺が600より小さい場合にtrueを返す
context.isPhone()

/// 画面の短辺が600より小さい場合にtrueを返す
context.isSmallTablet()

/// 画面の短辺が720より大きい場合にtrueを返す
context.isLargeTablet()

/// デバイスがタブレットの場合にtrueを返す
context.isTablet()

/// 画面サイズに合わせて value<T> を返す
/// たとえば:
/// 短辺が300より小さい → watchパラメーターの値を返す
/// 短辺が600より小さい → mobileパラメーターの値を返す
/// 短辺が1200より小さい → tabletパラメーターの値を返す
/// 横幅が1200より大きい → desktopパラメーターの値を返す
context.responsiveValue<T>()
```

### オプションのグローバル設定と手動設定

GetMaterialApp はすべてあなたの代わりに設定してくれますが、手動で設定を施したい場合は MaterialApp の navigatorKey と navigatorObservers の値を指定してください。

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

`GetObserver`内で独自のミドルウェアを使用することもできます。これは他に影響を及ぼすことはありません。

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // ここ
  ],
);
```

`Get` クラスに_グローバル設定_を施すことができます。Routeをプッシュする前のコードに `Get.config` を追加するだけです。もしくは、`GetMaterialApp` 内で直接設定することもできます。

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

オプションで、すべてのログメッセージを `Get` からリダイレクトさせることができます。
お好みのロギングパッケージを使ってログを取得したい場合はこのようにしてください。

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // ここでお好みのロギングパッケージにメッセージを渡してください
  // enableLog: false にしても、ログメッセージはこのコールバックでプッシュされる点ご注意を
  // ログが有効かどうかのチェックは Get.isLogEnable で可能
}

```

### ローカルステートWidget

ローカルステートWidgetは、1つの変数の状態を一時的かつローカルに管理したい場合に便利です。
シンプルなValueBuilderとリアクティブなObxValueの2種類があります。
たとえば、`TextField` Widgetの obscureText プロパティを切り替えたり、折りたたみ可能なパネルをカスタムで作成したり、`BottomNavigation` の現在のインデックス値を変更して内容を変更したりといった用途に最適です。

#### ValueBuilder

setStateでお馴染みの `StatefulWidget` をシンプルにしたビルダーWidgetです。

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // ( newValue ) => updateFn( newValue ) も可
  ),
  // builderメソッドの外で何か実行する場合
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

[`ValueBuilder`](#valuebuilder)に似ていますが、これはそのリアクティブバージョンです。Rxインスタンス(.obsを付けたときに戻る値です)を渡すと自動で更新されます。すごいでしょ？

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data,
        // Rxには_呼び出し可能な_関数が備わっているのでこれだけでOK
        // (flag) => data.value = flag も可能
    ),
    false.obs,
),
```

## お役立ちTIPS

`.obs`が付いた型(_Rx_型とも呼ばれる)には、さまざまな内部メソッドや演算子が用意されています。

> `.obs`が付いたプロパティが **実際の値** だと信じてしまいがちですが...間違えないように！
> 我々がcontrollerにおける変数の型宣言を省略してvarとしているのはDartのコンパイラが賢い上に、
> そのほうがコードがすっきる見えるからですが…

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

`message`を _print_ することで実際の文字列が取り出されはしますが、型は **RxString** です！

そのため `message.substring( 0, 4 )` などといったことはできません。
Stringのメソッドにアクセスするには _observable_ の中にある実際の値 `value` にアクセスします。
アクセスには `.value`を使うのが通常ですが、他の方法もあるのでご紹介します。

```dart
final name = 'GetX'.obs;
// 新しい値が現在のものと異なる場合のみ Stream が更新されます。
name.value = 'Hey';

// すべてのRxプロパティは「呼び出し可能」で、valueを返してくれます。
// ただし `null` は受付不可。nullの場合はUIが更新されない。
name('Hello');

// これはgetterみたいなものです。'Hello' を返します。
name() ;

/// num型の場合

final count = 0.obs;

// num型の非破壊的な演算子はすべて使えます。
count + 1;

// 注意！ この場合は`count`がfinalなら有効ではないです。varなら有効。
count += 1;

// 比較演算子も使用可能
count > 2;

/// bool型の場合

final flag = false.obs;

// true/false を入れ替えることができます。
flag.toggle();


/// すべての型

// `value` を null にセット。
flag.nil();

// toString(), toJson() などの操作はすべて `value` が対象になります。
print( count ); // RxIntの `toString()` が呼び出されて数字がprintされる。

final abc = [0,1,2].obs;
// json配列に変換した値と、'RxList' がprintされます。
// JsonはすべてのRx型でサポートされています！
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap、RxList、RxSetはそれぞれの元の型を拡張した特別なRx型です。
// たとえばRxListは通常のListとして扱うことができる上にリアクティブです。
abc.add(12); // 12をListにプッシュし、Streamを更新してくれます。
abc[3]; // Listと同様にインデックス番号3の値を取得してくれます。


// 等価演算子はRx型と元の型でも動作しますが、.hashCode は常にvalueから取得します。
final number = 12.obs;
print( number == 12 ); // true

/// カスタムのRxモデル

// toJson()やtoString()をモデルクラスに設定すれば、.obsからでもprintされるように実装可能。

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` 自体はリアクティブですが、その中のプロパティはリアクティブではありません。
// そのため、このようにプロパティの値を変更してもWidgetは更新されません。
user.value.name = 'Roi';
// `Rx` には自ら変更を検知する手段がないからです。
// そのため、カスタムクラスの場合はこのようにWidgetに変更を知らせる必要があります。
user.refresh();

// もしくは `update()` メソッドを使用してください。
user.update((value){
  value.name='Roi';
});

print( user );
```
#### StateMixin

`UI`の状態を管理するもう一つの手法として、`StateMixin<T>`を利用する方法があります。
controllerクラスに`with`を使って`StateMixin<T>`を追加することで実装可能です。

``` dart
class Controller extends GetController with StateMixin<User>{}
```

`change()`メソッドにより好きなタイミングで状態を変更することができます。
このようにデータと状態を渡すだけです。

```dart
change(data, status: RxStatus.success());
```

RxStatus には以下のステータスが存在します。

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

ステータスごとにUIを設定するにはこのようにします。

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),

        // ローディング中はカスタムのインジケーターの設定も可能ですが、
        // デフォルトで Center(child:CircularProgressIndicator()) となります。
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // 同様にエラーWidgetはカスタム可能ですが、
        // デフォルトは Center(child:Text(error)) です。
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

このWidgetは私のお気に入りです。とてもシンプルで扱いやすいですよ！

このWidgetを一言で表現すると、「controllerをgetterに持つ `const` な StatelessWidget」です。

```dart
 class AwesomeController extends GetController {
   final String title = 'My Awesome View';
 }

  // controllerの `型` を渡すのを忘れずに！
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // `controller.なんとか` でアクセス
     );
   }
 }
```

#### GetResponsiveView

GetViewをレスポンシブデザインに対応させたい場合はこのWidgetを継承してください。
画面サイズやデバイスタイプなどの情報を持つ `screen` プロパティを保持しています。

##### 使い方

Widgetをビルドする方法は2つあります。

- `builder` メソッドを使う。
- `desktop`, `tablet`, `phone`, `watch` メソッドを使う。
  画面サイズ、デバイスタイプに応じたWidgetがビルドされます。
  たとえば画面が [ScreenType.Tablet] なら `tablet` メソッドが実行されます。
  **注:** `alwaysUseBuilder` プロパティをfalseにする必要があります。

`settings` プロパティでブレイクポイントを設定することもできます。

![例](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
この画面のコード
[コード](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

このWidgetはあまり知られておらず、使用するケースは稀です。
GetViewとの違いは、Controllerを`キャッシュ`してくれる点です。
このキャッシュがあるため `const` にはできません。

> それでは一体いつControllerをキャッシュする必要があるのかって？

それは **GetX** のこれまた使う機会の少ない `Get.create()` を使うときです。

`Get.create(()=>Controller())` は `Get.find<Controller>()` を実行するたびに
新しいControllerインスタンスを生成します。

そこで `GetWidget` の出番です。たとえば、Todoアイテムのリスト内容を保持したいとき。
Widgetが更新されてもアイテムはControllerのキャッシュを参照してくれます。

#### GetxService

このクラスは `GetxController` に似ており、同様のライフサイクル（`onInit()`, `onReady()`, `onClose()`）を共有しますが、そこに「ロジック」はありません。**GetX**の依存オブジェクト注入システムに、このサブクラスがメモリから **削除できない** ということを知らせるだけです。

そのため `Get.find()` で `ApiService`, `StorageService`, `CacheService` のようなサービス系クラスにいつでもアクセスできるようにしておくと非常に便利です。

```dart
Future<void> main() async {
  await initServices(); /// サービスクラスの初期化をawait
  runApp(SomeApp());
}

/// Flutterアプリ実行前にサービスクラスを初期化してフローをコントロールするのは賢いやり方です。
/// たとえば GetMaterialAppを更新する必要がないようにUser別の
/// Theme、apiKey、言語設定などをApiサービス実行前にロードしたり。
void initServices() async {
  print('starting services ...');
  /// get_storage, hive, shared_pref の初期化はここで行います。
  /// あるいは moor の connection など非同期のメソッドならなんでも。
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

`GetxService` を破棄する唯一の方法は `Get.reset()` メソッドを使うことです。
これはアプリにおける「ホットリブート」のようなものです。あるクラスのインスタンスを
ライフサイクルの間ずっと残しておきたい場合は `GetxService` を使うというのを覚えておいてください。


## テストの実行

Controllerのライフサイクル含め、他のクラスと同様にテストを実行することができます。

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // 値を name2 に変更
    name.value = 'name2';
  }

  @override
  void onClose() {
    name.value = '';
    super.onClose();
  }

  final name = 'name1'.obs;

  void changeName() => name.value = 'name3';
}

void main() {
  test('''
Test the state of the reactive variable "name" across all of its lifecycles''',
      () {
    /// ライフサイクルごとのテストは必ずしも行う必要はありませんが、
    /// GetXの依存オブジェクト注入機能を使用しているのであれば実行をおすすめします。
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// このようにライフサイクル経過ごとの状態をテスト可能です。
    Get.put(controller); // onInit が実行される
    expect(controller.name.value, 'name2');

    /// 関数もテストしましょう
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose が実行される
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### mockitoやmocktailを使う場合
GetxController/GetxService をモックする場合 Mock をミックスインしてください。

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

#### Get.reset()
WidgetやGroupのテスト時に、テストの最後かtearDownの中で Get.reset() を実行することで設定をリセットすることができます。

#### Get.testMode
Controllerの中でナビゲーションを使用している場合は、`Get.testMode = true`をmainの開始で実行してください。


# バージョン2.0からの破壊的変更

1- Rx型の名称

| 変更前  | 変更後     |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxControllerとGetBuilderが統合され、Controllerにどれを使うか覚えておく必要がなくなりました。GetxControllerを使うだけで、リアクティブと非リアクティブな状態管理の両方に対応できるようになりました。

2- 名前付きRoute
変更前:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

変更後:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

変更の効果:
ページ表示にはパラメータやログイントークンを起点にする方法もありますが、以前のアプローチではこれができず、柔軟性に欠けていました。
ページを関数から取得するよう変更したことで、このようなアプローチを可能にし、アプリ起動直後にRouteがメモリに割り当てられることもないため、RAMの消費量を大幅に削減することもできました。

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

# なぜGetXなのか

1- Flutterのアップデートが重なると、依存パッケージがうまく動かなくなることがあります。コンパイルエラーを起こしたり、その時点で解決方法がないようなエラーが発生したり。開発者はそのエラーを追跡し、該当リポジトリにissueを提起し、問題が解決されるのを待つ必要があります。Getは開発に必要な主要リソース（状態管理、依存オブジェクト管理、Route管理）を一元化し、Pubspecにパッケージを1つ追加するだけでコーディングを開始することができます。Flutterがアップデートしたときに必要なことは、Getも併せてアップデートすることだけです。それですぐに作業を再開できます。またGetはパッケージ間の互換性の問題も解消します。互いに依存するパッケージAの最新バージョンとBの最新バージョンの間に互換性がない、ということが何度あったでしょうか。Getを使えばすべてが同じパッケージ内にあるため、互換性の心配はありません。

2- Flutterは手軽で素晴らしいフレームワークですが、`Navigator.of(context).push (context, builder [...]`のように、ほとんどの開発者にとって不要な定型文が一部にあります。Getを使えばそのような定型文を簡素化できます。Routeを呼ぶためだけに8行のコードを書く代わりに、`Get.to(Home())`を実行すれば、次の画面に遷移することができるのです。またウェブURLを動的なものにすることは現在Flutterでは本当に骨の折れる作業ですが、GetXを使えば非常に簡単です。そしてFlutterにおける状態管理と依存オブジェクト管理については、たくさんのパターンやパッケージがあるので多くの議論を生んでいます。しかしGetXのアプローチは大変シンプルです。これは一例ですが、変数の最後に「.obs」を追加して「Obx()」の中にWidgetを配置するだけで、その変数の状態変化が自動でWidgetに反映されます。

3- GetXではパフォーマンスのことをあまり気にせず開発ができます。Flutterのパフォーマンスはそれだけで素晴らしいものですが、状態管理と併せて BLoC / データストア / Controller などを届けるためのサービスロケーターを使用することを想像してみてください。そのインスタンスが必要ないときはリソースを解放するイベントを明示的に呼び出さなければなりません。そんなとき、使用されなくなったら自動でメモリから削除してくれればいいのに、と考えたことはありませんか？それを実現してくれるのがGetXです。SmartManagement機能により未使用のリソースはすべて自動でメモリから破棄されるので、本来の開発作業に集中することができます。メモリ管理のためのロジックを作らなくても、常に必要最小限のリソースを使っていることが保証されるのです。

4- コードのデカップリング（分離）がしやすい。「ビューをビジネスロジックから分離する」というコンセプトを聞いたことがあるかもしれません。これはなにもBLoC、MVC、MVVMに限ったことではなく、どのアーキテクチャパターンもこのコンセプトが考え方の基本にあると言っていいでしょう。しかし、Flutterではcontextの使用によりこのコンセプトが薄まってしまいがちです。
InheritedWidgetを参照するためにcontextが必要なとき、ビューの中でそれを使用するか、引数としてcontextを渡しますよね？私はこの方法は美しくないと感じます。常にビュー内のビジネスロジックに依存しなければならないのは、特にチームで仕事をする場面においては不便だと感じます。GetXによるアプローチでは、StatefulWidgetやinitStateなどの使用を禁止しているわけではありませんが、それらよりもずっとスッキリ書けるようになっています。Controller自体にライフサイクルがあるため、たとえばREST APIのリクエストを行うときも、ビューの中の何かに依存するということがありません。Controllerのライフサイクルの一つである onInit を使用してhttpを呼び出し、データが到着すると変数にセットされます。GetXはリアクティブな変数を扱うことができるので、インスタンス変数が変わりし次第、その変数に依存するWidgetがすべて自動更新されます。これによりUIの担当者はWidgetの見た目に注力することができ、ボタンクリックなどのユーザーイベント以外のものをビジネスロジックに渡す必要がなくなります。その一方でビジネスロジックの担当者はビジネスロジックだけに集中し、個別のテストを簡単に行うことができます。

GetXライブラリは今後も更新され続け、新しい機能を実装していきます。気軽にプルリクエストを出していただき、ライブラリの成長に貢献していただけるとうれしいです。

# コミュニティ

## コミュニティチャンネル

GetXコミュニティは非常に活発で有益な情報であふれています。ご質問がある場合や、このフレームワークの使用に関して支援が必要な場合は、ぜひコミュニティチャンネルにご参加ください。このリポジトリは、issueの提起およびリクエスト専用ですが、気軽にコミュニティにご参加いただければ幸いです。

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## コントリビュート方法

_GetXプロジェクトに貢献してみませんか？あなたをコントリビューターの一人としてご紹介できるのを楽しみにしています。GetおよびFlutterをより良いものにするためのコントリビュート例をご紹介します。_

- Readmeの多言語対応。
- Readmeの追加ドキュメント執筆 (ドキュメントで触れられていない機能がまだまだたくさんあります)。
- Getの使い方を紹介する記事やビデオの作成（Readmeに掲載させていただきます。将来的にWikiができればそこにも掲載予定）。
- コードやテストのプルリクエスト。
- 新機能の提案。

どのような形の貢献であれ歓迎しますので、ぜひコミュニティにご参加ください！

## GetXに関する記事と動画

- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - Tutorial by [Pesa Coder](https://github.com/UsamaElgendy).
- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman).
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Dependency Injection by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter.
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - by [Roi Peker](https://github.com/roipeker)

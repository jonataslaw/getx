# 依存オブジェクト管理
- [依存オブジェクト管理](#依存オブジェクト管理)
  - [インスタンス化に使用するメソッド](#インスタンス化に使用するメソッド)
    - [Get.put()](#getput)
    - [Get.lazyPut()](#getlazyput)
    - [Get.putAsync()](#getputasync)
    - [Get.create()](#getcreate)
  - [インスタンス化したクラスを使う](#インスタンス化したクラスを使う)
  - [依存オブジェクトの置換](#依存オブジェクトの置換)
  - [各メソッドの違い](#各メソッドの違い)
  - [Bindings（Routeと依存オブジェクトの結束）](#Bindings（Routeと依存オブジェクトの結束）)
    - [Bindingsクラス](#bindingsクラス)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [設定の変更方法](#設定の変更方法)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Bindingsの仕組み](#Bindingsの仕組み)
  - [補足](#補足)

Getにはシンプルで強力な依存オブジェクト管理機能があります。たった1行のコードで、Provider contextやinheritedWidgetを使うことなく、BlocもしくはControllerのインスタンスを取得することができます。

```dart
Controller controller = Get.put(Controller()); // Controller controller = Controller() の代わりに
```

UIクラスの中でControllerクラスをインスタンス化する代わりに、Getインスタンスの中でインスタンス化することで、アプリ全体でControllerを利用できるようになります。

- 注: Getの状態管理機能を使用する場合は、[Bindings](#bindings)の使用も検討してください。Bindingsを使うことでビューにControllerを結合させることができます。
- 注²: Getの依存オブジェクト管理機能は、パッケージの他の部分から独立しています。そのため、たとえばあなたのアプリが既に他の状態管理ライブラリを使用している場合（どんなものでも）、何の問題もなく2つを組み合わせることができます。

## インスタンス化に使用するメソッド
Controllerを初期化するのに使用するメソッドとその設定パラメーターについてご説明します。

### Get.put()

依存オブジェクトを注入するための最も基本のメソッド。たとえば、ビューで使用するControllerに使います。

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

以下が put() を使用する際に設定できるパラメーターです。
```dart
Get.put<S>(
  // 必須。インスタンスを保存しておきたいControllerなどを設定
  // 注: "S" 型はジェネリクスで、どんな型でもOK
  S dependency

  // オプション。これは同じ型のControllerインスタンスが複数存在する場合に、
  // タグIDにより識別したい場合に使用します。
  // Get.find<Controller>(tag: ) でこのputで設定したインスタンスを探します。
  // tag はユニークなStringである必要があります。
  String tag,

  // オプション。デフォルトでは使用されなくなったインスタンスは破棄されますが、
  // （たとえばビューが閉じられた場合など） SharedPreferencesのインスタンスなど、
  // アプリ全体を通して生かしておきたい場合があるかと思います。
  // その場合はこれをtrueにしてください。デフォルトはfalseです。
  bool permanent = false,

  // オプション。テストで抽象クラスを使用した後、別クラスに置換してテストを追うことができます。
  // デフォルトはfalseです。
  bool overrideAbstract = false,

  // オプション: 依存オブジェクトを関数を使って作ることができます。
  // 使用頻度は低いと思います。
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut()
依存オブジェクトをすぐにロードする代わりに、lazy（遅延、消極的）ロードすることができます。実際に使用されるときに初めてインスタンス化されます。計算量の多いクラスや、Bindingsを使って複数のControllerをまとめてインスタンス化したいが、その時点ではすぐにそれらを使用しないことがわかっている場合などに非常に便利です。

```dart
/// この場合のApiMockは Get.find<ApiMock> を使用した時点でインスタンス化されます。
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // 必要ならここに何かのロジック
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

これが .lazyPut で設定できるパラメーターです。
```dart
Get.lazyPut<S>(
  // 必須。クラスSが初めてfindの対象になったときに実行されるメソッド
  InstanceBuilderCallback builder,

  // オプション。Get.put()のtagと同様に同じクラスの異なるインスタンスが必要なときに使用
  // ユニークな値を指定
  String tag,

  // オプション。"permanent" に似ていますが、使用されていないときはインスタンスが
  // 破棄され、再び使用するときにGetがインスタンスを再び作成する点が異なります。
  // Bindings APIの "SmartManagement.keepFactory " と同じです。
  // デフォルトはfalse
  bool fenix = false

)
```

### Get.putAsync()
SharedPreferencesなど、非同期のインスタンスを登録したいときに使います。

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

これが .putAsync で設定できるパラメーターです。
```dart
Get.putAsync<S>(

  // 必須。クラスをインスタンス化するための非同期メソッドを指定
  AsyncInstanceBuilderCallback<S> builder,

  // オプション。Get.put() と同じです。同じクラスの異なるインスタンスを作りたいときに使用
  // ユニークな値を指定
  String tag,

  // オプション。Get.put() と同じです。アプリ全体を通して生かしておきたい場合に使用
  // デフォルトはfalse
  bool permanent = false
)
```

### Get.create()

これは使いどころに迷うかもしれません。他のものとの違いなど詳細な説明は「[各メソッドの違い](#各メソッドの違い)」のセクションをご一読ください。

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

これが .create で設定できるパラメーターです。

```dart
Get.create<S>(
  // 必須。Get.find() が呼ばれるたびにインスタンスがこの関数で新たに組み立てられる。
  // 例: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // オプション。Get.put() のtagと同様で、同じクラスによる
  // 複数インスタンスを扱うときに使用します。
  // リストのアイテムにそれぞれコントローラが必要な場合に便利です。
  // 文字列はユニークである必要があります。
  String name,

  // オプション。Get.put() と同様アプリ全体でインスタンスを維持するときに使用。
  // 唯一の違いは Get.create() のpermanentはデフォルトでtrueということだけです。
  bool permanent = true
```

## インスタンス化したクラスを使う

いくつかのRouteを渡り歩いた後、以前のControllerに残してきたデータが必要になったとしたら、Provider や Get_it と組み合わせる必要がありますよね？Getの場合は違います。GetにControllerの「検索」を依頼するだけで追加の依存オブジェクトの注入は必要ありません。

```dart
final controller = Get.find<Controller>();
// もしくは
Controller controller = Get.find();

// マジックみたいですよね。でも実際にGetはControllerのインスタンスを探して届けてくれます。
// 100万ものControllerをインスタンス化していても、Getは常に正しいControllerを探してくれます。
```

そしてそのControllerが以前取得したデータをあなたは復元することができます。

```dart
Text(controller.textFromApi);
```

戻り値は通常のクラスなので、そのクラスで可能なことは何でもできます。
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // 出力: 12345
```

インスタンスを明示的に削除したい場合はこのようにしてください。

```dart
Get.delete<Controller>(); // 通常であれば、GetXは未使用Controllerを自動削除するので、この作業は必要ありません。
```

## 依存オブジェクトの置換

注入されている依存オブジェクトは `replace` または `lazyReplace` メソッドを使って、子クラスなど関連クラスのインスタンスに置き換えることができます。これは元の抽象クラスを型指定することで取得することができます。

```dart
abstract class BaseClass {}
class ParentClass extends BaseClass {}

class ChildClass extends ParentClass {
  bool isChild = true;
}


Get.put<BaseClass>(ParentClass());

Get.replace<BaseClass>(ChildClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); //true


class OtherClass extends BaseClass {}
Get.lazyReplace<BaseClass>(() => OtherClass());

final instance = Get.find<BaseClass>();
print(instance is ChildClass); // false
print(instance is OtherClass); //true
```

## Differences between methods

まずは Get.lazyPut の `fenix` プロパティと、他メソッドの `permanent` プロパティの違いについてご説明します。

`permanent` と `fenix` の根本的な違いは、インスタンスをどのように保持したいかという点に尽きます。

しつこいようですが、GetXでは使われていないインスタンスは削除されるのがデフォルトの動作です。
これはもし画面AがController A、画面BがController Bを持っている場合において、画面Bに遷移するときに画面Aをスタックから削除した場合（`Get.off()` や `Get.offNamed()` を使うなどして）、Controller Aは消えてなくなるということです。

しかし Get.put() する際に `permanent:true` としていれば、Controller Aはこの画面削除により失われることはありません。これはアプリケーション全体を通してControllerを残しておきたい場合に大変便利です。

一方の `fenix` は、画面削除に伴っていったんはControllerが消去されますが、再び使いたいと思ったときに復活させることができます。つまり基本的には未使用の Controller / サービス / その他クラス は消去されますが、必要なときは新しいインスタンスを「燃えカス」から作り直すことができるのです。

各メソッドを使用する際のプロセスの違いをご説明します。

- Get.put と Get.putAsync はインスタンスを作成して初期化するプロセスは同じですが、後者は非同期メソッドを使用するという違いがあります。この2つのメソッドは内部に保有するメソッド `insert` に `permanent: false` と `isSingleton: true` という引数を渡して、メモリに直接インスタンスを挿入します (この isSingleton が行っていることは、依存オブジェクトを `dependency` と `builder` プロパティのどちらから拝借するかを判断することだけです)。その後に `Get.find()` が呼ばれると、メモリ上にあるインスタンスを即座に初期化するというプロセスをたどります。

- Get.create はその名の通り、依存オブジェクトを「クリエイト」します。Get.put() と同様に内部メソッドである `insert` を呼び出してインスタンス化します。違いは `permanent: true` で `isSingleton: false` である点です (依存オブジェクトを「クリエイト」しているため、シングルトンにはなりません。それが false になっている理由です)。また `permanent: true` となっているので、デフォルトでは画面の破棄などでインスタンスを失わないというメリットがあります。また `Get.find()` はすぐに呼ばれず、画面内で実際に使用されてから呼ばれます。これは `permanent` の特性を活かすための設計ですが、それゆえ `Get.create()` は共有しないけど破棄もされないインスタンスを作成する目的で作られたと言えます。たとえば、ListViewの中のボタンアイテムに使うControllerインスタンスのように、そのリスト内でしか使わないけどリストアイテムごとに固有のインスタンスが必要なケースなどが考えられます。そのため、Get.create は GetWidget との併用がマストです。

- Get.lazyPut は初期化をlazy（遅延、消極的）に行います。実行されるとインスタンスは作成されますが、すぐに使用できるように初期化はされず、待機状態になります。また他のメソッドと異なり `insert` メソッドは呼び出されません。その代わり、インスタンスはメモリの別の部分に挿入されます。この部分を「ファクトリー」と呼ぶことにしましょう。「ファクトリー」は、そのインスタンスが再生成できるかどうかを決める役割を持っています。これは後で使う予定のものを、現在進行形で使われているものと混ざらないようにするための工夫です。ここで `fenix` によるマジックが登場します。デフォルトの `fenix: false` のままにしており、かつ `SmartManagement` が `keepFactory` ではない場合において `Get.find` を使用すると、インスタンスは「ファクトリー」から共有メモリ領域に移動します。その直後にインスタンスは「ファクトリー」から削除されます。しかし `fenix: true` としていた場合、インスタンスは「ファクトリー」に残るため、共有メモリ領域から削除されても再び呼び出すことができるのです。

## Bindings（Routeと依存オブジェクトの結束）

このパッケージの一番の差別化要素は、Route管理 / 状態管理 / 依存オブジェクト管理 を統合したことにあると思っています。
スタックからRouteが削除されれば、関係するController、変数、オブジェクトのインスタンスがすべてメモリから削除されます。たとえばStreamやTimerを使用している場合も同様ですので、開発者は何も心配する必要はありません。
Getはバージョン2.10からBindings APIをフル実装しました。
Bindingsを使用すれば init でControllerを起動する必要はありません。またControllerの型を指定する必要もありません。Controllerやサービスは各々適切な場所で起動することができるようになりました。
Bindingsは依存オブジェクトの注入をビューから切り離すことができるクラスです。それに加え、状態と依存オブジェクトの管理機能をRouteに「結束（bind）」してくれます。
これによりGetは、あるControllerが使用されたときにどの画面UIが表示されているかを知ることができます。つまり、そのControllerをどのタイミングでどう処分するかを判断することができるということです。
さらにBindingsでは SmartManager の制御により、依存オブジェクトをどのタイミング（スタックからRouteを削除したときか、それに依存するWidgetを表示したときか、いずれでもないか）で整理するかを設定することができます。インテリジェントな依存オブジェクトの自動管理機能を持ちつつ、自分の好きなように設定できるのです。

### Bindingsクラス

- Bindings機能を実装したクラスを作成することができます。

```dart
class HomeBinding implements Bindings {}
```

"dependencies" メソッドをオーバーライドするようIDEに自動で指摘されます。表示をクリックしてメソッドを override し、そのRoute内で使用するすべてのクラスを挿入してください。

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

Bindingsを設定したら、このクラスが Route管理 / 依存オブジェクト管理 / 状態管理 を互いに接続する目的で使用されるものだということをRouteに知らせてあげます。

- 名前付きRouteを使う場合

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

- 通常のRouteを使う場合

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

これでアプリケーションのメモリ管理を気にする必要がなくなります。Getがすべてやってくれます。

BindingsクラスはRouteの呼び出しと同時に呼び出されます。また、すべてに共通の依存オブジェクトを挿入するためには GetMaterialApp の initialBinding プロパティを使用してください。

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

Bindingsを作成する一般的な方法は Bindings を実装したクラスを作成することですが、`BindingsBuilder` コールバックを使う方法もあります。

Example:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

この方法ならRouteごとにBindingsクラスを作る必要はありません。

どちらの方法でも効果は変わりませんのでお好みの方法を使ってください。

### SmartManagement

エラーが発生してControllerを使用するWidgetが正しく破棄されなかった場合でも、Controllerが未使用になればGetXはデフォルトの動作通りそれをメモリから削除します。
これがいわゆる依存オブジェクト管理機能の `full` モードと呼ばれるものです。
しかしもしGetXによるオブジェクト破棄の方法をコントロールしたい場合は、`SmartManagement`クラスを使って設定してください。

#### 設定の変更方法

この設定は通常変更する必要はありませんが、変更されたい場合はこのようにしてください。

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders // ここで設定
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

これがデフォルトのモードです。使用されていない、かつ `permanent: true` が設定されていないオブジェクトを自動で破棄してくれます。特殊な事情がない限り、この設定は触らない方がいいでしょう。GetXを使って間がない場合は特に。

#### SmartManagement.onlyBuilders
`init:` もしくはBindings内で `Get.lazyPut()` により設定したビルダー製のオブジェクトだけを破棄するモードです。

もしそれが `Get.put()` や `Get.putAsync()` などのアプローチで生成したオブジェクトだとしたら、SmartManagement は勝手にメモリから除外することはできません。

それに対してデフォルトのモードでは `Get.put()` で生成したオブジェクトも破棄します。

#### SmartManagement.keepFactory

SmartManagement.full と同じように、オブジェクトが使用されていない状態になれば破棄します。ただし、前述の「ファクトリー」に存在するものだけは残します。つまりそのインスタンスが再び必要になった際は依存オブジェクトを再度生成するということです。

### Bindingsの仕組み
Bindingsは「一過性のファクトリー」のようなものを作成します。これはそのRouteに画面遷移した瞬間に作成され、そこから画面移動するアニメーションが発生した瞬間に破棄されます。
この動作は非常に高速で行われるので、アナライザーでは捕捉できないほどです。
再び元の画面に戻ると新しい「一過性のファクトリー」が呼び出されます。そのためこれは SmartManagement.keepFactory を使用するよりも多くの場合好ましいですが、Bindingsを作成したくない場合やすべての依存オブジェクトを同じBindingsに持っておきたい場合は SmartManagement.keepFactory を使うといいでしょう。
ファクトリーのメモリ使用量は少なく、インスタンスを保持することはありません。その代わりにそのクラスのインスタンスを形作る関数を保持します。
メモリコストは非常に低いのですが、最小リソースで最大パフォーマンスを得ることが目的のGetではデフォルトでファクトリーを削除します。
どちらか都合に合う方ををお使いいただければと思います。

## 補足

- 複数のBindingsを使う場合は SmartManagement.keepFactory は**使わない**でください。これは Bindings を使わないケースや、GetMaterialAppのinitialBindingに設定された単独のBindingと一緒に使うケースを想定されて作られました。

- Bindingsを使うことは必須ではありません。`Get.put()` と `Get.find()` だけでも全く問題ありません。
ただし、サービスやその他抽象度の高いクラスをアプリに取り入れる場合はコード整理のために使うことをおすすめします。

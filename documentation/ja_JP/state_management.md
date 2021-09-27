* [状態管理](#状態管理)
  + [リアクティブな状態管理](#リアクティブな状態管理)
    - [利点](#利点)
    - [パフォーマンスの最大化](#パフォーマンスの最大化)
    - [リアクティブな変数の宣言](#リアクティブな変数の宣言)
        - [初期値の設定](#初期値の設定)
    - [Observableの値をビュー内で使う](#Observableの値をビュー内で使う)
    - [更新条件を設定](#更新条件を設定)
    - [.obsの使いどころ](#.obsの使いどころ)
    - [List(Rx)に関する補足](#List(Rx)に関する補足)
    - [なぜ「.value」を使う必要があるのか](#なぜ「.value」を使う必要があるのか)
    - [Obx()](#obx)
    - [Worker](#worker)
  + [非リアクティブな状態管理](#非リアクティブな状態管理)
    - [利点](#利点)
    - [使用例](#使用例)
    - [Controllerインスタンスの扱い](#Controllerインスタンスの扱い)
    - [StatefulWidgetsはもういらない](#StatefulWidgetsはもういらない)
    - [Getの目的](#Getの目的)
    - [Controllerの様々な使用方法](#Controllerの様々な使用方法)
    - [ユニークIDの設定](#ユニークIDの設定)
  + [状態管理ソリューションを混在させる](#状態管理ソリューションを混在させる)
  + [StateMixin](#StateMixin)
  + [GetBuilder VS GetX VS Obx VS MixinBuilder](#GetBuilder-VS-GetX-VS-Obx-VS-MixinBuilder)

# 状態管理

GetXは他の状態管理ライブラリのように Stream や ChangeNotifier を使用する必要がありません。なぜか？私たちは応答時間とRAM消費量を改善するために GetValueとGetStream という低遅延のソリューションを開発しましたが、状態管理機能を含むGetXのリソースはすべてこれをベースに作られているためです。このソリューションはより低い運用コストと高いパフォーマンスを実現します。GetXを使えばAndroid、iOS、Web、Linux、macOS用のアプリケーションを作成するだけでなく、Flutter/GetXと同じシンタックスでサーバーアプリケーションを作ることができます。

* _バカみたいにシンプル_: 他の状態管理アプローチの中には、複雑で多くのボイラープレートコードを書かなければいけないものもあります。この問題により少なくない人たちがFlutterを見限りましたが、今ようやく、バカみたいにシンプルなソリューションを手に入れることができました。GetXを使えば、非常にすっきりとした、記述量の少ないコードでより多くのことができるようになります。イベントごとにクラスを定義する必要もありません。
* _コード生成にサヨナラ_: 開発時間の半分はアプリケーションロジックの作成に費やします。それにも関わらず、状態管理ライブラリの中には、ミニマルなコードを作るためにコード生成ツールに依存しているものがあります。変数を変更して build_runner を実行するのは非生産的ですし、flutter clean 後の待ち時間もコーヒーをたくさん飲まなければならないほど長くなることもあります。

GetXはすべてがリアクティブであり、コード生成ツールに依存しないため、開発のあらゆる面において生産性が向上します。

* _context依存にサヨナラ_: ビューとビジネスロジックを連携させるため、ビューのcontextをControllerに送る必要に迫られた。contextがないところで依存オブジェクトの注入をする必要があり、contextを方々のクラスや関数からなんとか渡した。これらの経験、誰もが通ってきた道かと思います。しかし、GetXではこのような経験をすることはありません。contextなしで、Controllerの中から別のControllerにアクセスすることができます。パラメーターを通じて無駄にcontextを送る必要はもうありません。
* _細かいコントロール_: 多くの状態管理ソリューションは、ChangeNotifierをベースにしています。ChangeNotifierは、notifyListenerが呼ばれたときに、依存するすべてのWidgetに通知します。画面に40個のWidgetがあるとしましょう。それらがすべてChangeNotifierの変数に依存している場合、変数を1つでも更新すれば、すべてのWidgetが更新されます。

GetXを使えばネストされたWidgetさえも的確にビルドを処理することができます。ListViewを担当するObxと、ListViewの中のチェックボックスを担当するObxがあれば、チェックボックスの値を変更した場合はチェックボックスWidgetだけが更新され、Listの値を変更した場合はListViewだけが更新されます。

* _変数が本当に変わったときだけ更新する_: GetXはデータの流れをコントロールします。つまり、Textに紐づいたObservable(監視可能)変数の値 'Paola' を、同じ 'Paola' に変更してもWidgetは更新されません。これは、GetXがTextに'Paola'がすでに表示されていることをわかっているためです。

多くの状態管理ソリューションは、この場合更新を行います。

## リアクティブな状態管理

リアクティブプログラミングは複雑であると言われがちなためか、多くの人に敬遠されています。しかし、GetXはリアクティブプログラミングを非常にシンプルなものにしてくれます。

* StreamControllerを作る必要はありません。
* 変数ごとにStreamBuilderをセットする必要はありません。
* 状態ごとにクラスを作る必要はありません。
* 初期値のためにgetを準備する必要はありません。

Getによるリアクティブプログラミングは、setState並に簡単です。

たとえば name という変数があり、それを変更するたびに変数に依存するすべてのWidgetを自動更新したいとします。

これがその name 変数です。

``` dart
var name = 'Jonatas Borges';
```

これをObservable(監視可能)にするには、値の末尾に ".obs" を付け足すだけです。

``` dart
var name = 'Jonatas Borges'.obs;
```

これで終わりです。*こんなに* 簡単なんですよ。

(以後、このリアクティブな ".obs" 変数、Observable(監視可能)を _Rx_ と呼ぶことがあります。)

内部ではこのような処理を行っています: `String`の`Stream`を作成し、初期値`"Jonatas Borges"`を割り当て、`"Jonatas Borges"`に依存するすべてのWidgetに、あなたは今この変数の影響下にあるから、_Rx_の値が変更されたときには、あなたも同様に変更する必要がある旨を通知。

これがDartの機能のおかげで実現できた **GetX マジック** です。

しかし皆さんご存知の通り、`Widget` は関数の中にいなければ自らを更新できません。静的クラスには「自動更新」の機能がないからです。

それなら、同じスコープ内で複数の変数に依存してWidgetをビルドする場合は、複数の `StreamBuilder` をネストして変数の変化を監視する必要がありますね。

いいえ、**GetX** なら `StreamBuilder` すら不要です。

またWidgetを更新する際のボイラープレートコードについても、**GetX**では忘れてください。

`StreamBuilder( ... )` ? `initialValue: ...` ? `builder: ...` ? これらはすべて不要で、対象のWidgetを `Obx()` の中に入れるだけです。

``` dart
Obx (() => Text (controller.name));
```

_覚えること？_  それは `Obx(() =>` だけです。

そのWidgetをアロー関数を通じて `Obx()`（_Rx_のObserver(監視者)）に渡すだけです。

`Obx` は非常に賢く、`controller.name` の値が本当に変わったときにのみ、Widgetの更新をかけます。

`name` が `"John"` だとして、それを `"John"` ( `name.value = "John"` ) に変更しても、以前と同じ `value` のため画面上では何も変化しません。`Obx` はリソースを節約するために値を無視し、Widgetを更新しません。**すごいでしょ？**

> では、もしも `Obx` の中に_Rx_（Observable）変数が5つあったらどうでしょう？

5つの**いずれかに**値の変化があればWidgetは更新されます。

> また、1つのControllerクラスに30もの変数がある場合、1つの変数を更新したら変数に関わるWidgetが**すべて**更新されてしまうのでしょうか？

いいえ、_Rx_ 変数を使う特定のWidgetだけが更新されます。

言い換えるなら、**GetX**は _Rx_ 変数の値が変化したときだけ画面更新をしてくれるということです。

```dart

final isOpen = false.obs;

// 同じ値なので何も起きません。
void onButtonTap() => isOpen.value=false;
```

### 利点

**GetX()**は何を更新して何をしないのか、の**細かい**コントロールが可能です。

すべての更新するのでそのようなコントロールが不要な場合は、`GetBuilder` を検討してください。
これはわずか数行のコードで作られた、状態更新のためのシンプルなビルダーです。（`setState()`のようにブロックで）
CPUへの影響を最小限にするために作られており、単一の目的(_状態_ の再構築)を果たすため、可能な限りリソース消費を抑えました。

**強力な** 状態管理のソリューションを求めているなら、**GetX**で間違いはありません。

変数をそのまま扱うことはできませんが、内部では `Stream` としてデータが扱われています。

すべてが `Stream` なので、_RxDart_ を組み合わせることも可能ですし、
"_Rx_ 変数" のイベントや状態を監視することも可能です。

GetXは _MobX_ より簡単で、コード自動生成や記述量を減らした_BLoC_ 型アプローチと言えるかもしれません。
値の末尾に `.obs` を付けるだけで**なんでも** _"Observable(監視可能)"_ にできるのです。

### パフォーマンスの最大化

ビルドを最小限に抑えるための賢いアルゴリズムに加えて、
**GetX**はコンパレーターを使用して状態が変更されたことを確認します。

アプリでなにかしらのエラーが発生し、状態が変更された情報を
二重に送信してしまったとしても**GetX**はクラッシュを防いでくれます。

**GetX**では値が変化したときにはじめて「状態」が変化するためです。
これが **GetX** と _MobX の `computed`_ を使う際の主な違いです。
2つの __Observable__ を組み合わせて一つが変化したとき、それを監視しているオブジェクトも変化します。

これは `GetX()` (`Observer()`のようなもの) において2つの変数を組み合わせた場合においても、
それが本当に状態の変化を意味するときだけWidgetの更新が行われるということでもあります。

### リアクティブな変数の宣言

変数を "Observable" にする方法は3つあります。

1 - **`Rx{Type}`** を使用する

``` dart
// 初期値を入れることを推奨しますが、必須ではありません
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - **`Rx`** とジェネリクスによる型指定の組み合わせ

``` dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// 任意の型を指定可能 - どんなクラスでもOK
final user = Rx<User>();
```

3 - 最も実用的で簡単な方法として、**`.obs`** を値に付ける

``` dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// カスタムクラスのインスタンスにも付けられます
final user = User().obs;
```

##### 初期値の設定

ご存知の通り、_Dart_ は現在 _null safety_ へ移行しているところです。
それに備えるために今後は _Rx_ 変数は常に**初期値**を設定してください。

> **GetX** で変数を _Observable_ にしつつ _初期値_ を設定するのはとても簡単です。

変数の末尾に `.obs` を付ける。**それだけ。**
めでたく Observable とそのプロパティ `.value` (つまり _初期値_)ができました。

### Observableの値をビュー内で使う

``` dart
// Controllerクラス
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

``` dart
// ビュークラス
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

`count1.value++` を実行すると、以下の通りprintされます。

* `count 1 rebuild`

* `count 3 rebuild`

なぜなら `count1` の値が `1` に変わり、それに伴ってgetter `sum` の値にも `1 + 0 = 1` と変化が起こるからです。

今度は `count2.value++` を実行してみましょう。

* `count 2 rebuild`

* `count 3 rebuild`

もうおわかりですね。これは `count2.value` が変わり、その結果 `sum` が `2` になったからです。

* 注: デフォルト仕様では、`value` に変化がなかったとしても、それが最初のイベントであればWidgetを更新します。

 この仕様はbool変数の性質から来るものです。

たとえばこの場合を想像してみてください。

``` dart
var isLogged = false.obs;
```

そして、isLogged(ユーザーがログインしたかどうか)の変化をトリガーにever関数内のコールバックfireRouteを呼び出したいとします。

``` dart
@override
onInit() async {
  // everは引数1が変化するたびに引数2を実行するリスナー
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

もし `hasToken` が `false` なら `isLogged` に変化はありません。すると `ever()` のコールバックは永遠に呼び出されないことになります。
このような挙動を防ぐために _Observable_ への最初の更新は、それがたとえ同じ `.value` だったとしても
常にイベントを引き起こすようにしています。

ご参考までに、この仕様は以下の設定で解除することができます。
 `isLogged.firstRebuild = false;`

### 更新条件を設定

Getにはさらに洗練された「状態」のコントロール方法があります。イベント(Listへのオブジェクト追加など)に対して条件を付けることが可能です。

``` dart
// 引数1: Listにオブジェクトを加える条件。trueかfalseを返すこと
// 引数2: 条件がtrueの場合に加える新しいオブジェクト
list.addIf(item < limit, item);
```

最低限のコードで、コード生成ツールも使わず、とても簡単ですね :smile:

カウンターアプリもこのようにシンプルに実現できます。

``` dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Controllerを設定して、下記を実行するだけ。

``` dart
controller.count.value++
```

UIの数字が置き換わりましたね。このようにアプリのどこであっても更新をかけることができます。

### .obsの使いどころ

.obs を使うことでどんなものもObservableにすることができます。方法は2つ。

* クラスのインスタンス変数をobsに変換する

``` dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* クラスのインスタンスを丸々obsに変換する

``` dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// インスタンス化の際
final user = User(name: "Camila", age: 18).obs;
```

### List(Rx)に関する補足

List(Rx)はその中のオブジェクトと同様、監視可能(Observable)です。そのためオブジェクトを追加すると、List(Rx)に依存するWidgetは自動更新されます。

またList(Rx)をListとするために ".value" を使う必要はありません。DartのAPIがこれを可能にしてくれました。ただ、残念ながら他のStringやintのようなプリミティブ型は拡張ができないため、.value を使う必要があります。getterやsetterを活用するのであればあまり問題になりませんが。

``` dart
// Controllerクラス
final String title = 'User Info:'.obs
final list = List<User>().obs;

// ビュークラス
Text(controller.title.value), // Stringの場合は .value が必要
ListView.builder (
  itemCount: controller.list.length // Listの場合は不要
)
```

カスタムのクラスをObservableにした場合は、様々な方法で値を更新することができます。

``` dart
// モデルクラス
// 属性をobsにするやり方ではなく、クラス全体をobsにする方法を採ります
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}

// Controllerクラス
final user = User().obs;
// user変数を更新するときはこのようなメソッドを作ります
user.update( (user) { // このパラメーターは更新するオブジェクトそのもの
user.name = 'Jonny';
user.age = 18;
});
// あるいは、この方法でも。変数名は呼び出し可能です。
user(User(name: 'João', age: 35));

// ビュークラス
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// .value を使わずにモデルのプロパティにアクセスすることも可能です
user().name; // userがUserではないことに注目。user()でUserを受け取れます。
```

ListのsetAllやsetRangeメソッドの代わりに、"assign" "assignAll" APIを使っていただくことも可能です。
"assign" APIはListの内容をクリアした後に、指定した単独のオブジェクトを追加してくれます。
"assignAll" APIはそのIterable版です。

### なぜ「.value」を使う必要があるのか

ちょっとしたアノテーションとコード生成ツールを使って`String`や`int`で `.value` を使わなくて済むようにもすることはできますが、このライブラリの目的は「外部依存パッケージを減らす」ことです。私たちは、外部パッケージを必要としない、必須ツール（Route、依存オブジェクト、状態の管理）が揃った開発環境を軽量かつシンプルな方法で提供したいと考えています。

まさに pubspecに3文字（get）とコロンを加えて、プログラミングを始めることができるのです。Route管理から状態管理まで、必要なソリューションが標準装備されています。GetXはシンプルさ、生産性、高いパフォーマンスを目指します。

これほど多機能であるにも関わらず、このライブラリの総容量は他の多くの状態管理ライブラリよりも少ないです。その点をご理解いただけるとうれしいです。

`.value` が嫌でコード生成ツールを使いたいという方には、MobXは素晴らしいライブラリだと思いますし、Getと併用することもできます。逆に多くの外部パッケージに依存したくない方、パッケージ間の互換性を気にしたくない方、状態管理ツールや依存オブジェクトから状態更新エラーが出ているかどうかを気にせずプログラミングをしたい方、依存するControllerクラスのインスタンスがあるかどうかを都度都度心配したくない方にとってはGetはまさに最適です。

MobXのコード生成や、BLoCのボイラープレートコードが気にならないのであれば、Route管理にだけでもGetをお使いいただけるとうれしいです。GetのSEMとRSMは必要に迫られて生まれたものです。私の会社で以前、90以上のControllerを持つプロジェクトがあり、それなりの性能のマシンでflutter cleanを行った後でさえ、コード生成ツールがタスクを完了するのに30分以上かかりました。もしあなたが大きなプロジェクトに関わっており、コード生成ツールが問題になっているのであれば、Getを検討してみてください。

もちろん、コード生成ツールをGetXに導入したい方が実際にツールを作成してプロジェクトに貢献した場合は、このReadMeに代替ソリューションとして掲載させていただきます。私はすべての開発者のニーズをかなえたいわけではありませんが、今はこの質問に対しては、「すでにMobXのように同様のことを実現してくれる良いソリューションがある」とだけ言わせてください。

### Obx()

GetX()の代わりにObx()を使用することもできます。ObxはWidgetを生成する匿名関数をパラメーターに持ちます。複数のControllerに対応することができますが、自身はControllerのインスタンスを持たず、型指定もできません。そのため別途Controllerのインスタンスを作るか、`Get.find<Controller>()` でインスタンスを探しておく必要があります。

### Worker

Worker はイベント発生に伴って指定したコールバックを呼び出すことができます。

``` dart
/// `count1` が更新されるたびに第2引数のコールバックが実行される
ever(count1, (_) => print("$_ has been changed"));

/// `count1` の最初の更新時のみ実行される
once(count1, (_) => print("$_ was changed once"));

/// DDoS攻撃対策に最適。たとえば、ユーザーが打鍵やクリックを止めて1秒後に実行など
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// 1秒以内の連続更新はすべて無視して実行しない
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

すべてのWorker(`debounce` 以外) は `condition` パラメーターを持ちます。`condition` は `bool` でも `bool` を返すコールバックでも構いません。
この `condition` が Worker のコールバックを実行するかどうかを決めています。

また Worker は `Worker` インスタンスを返します。これは `dispose()` などを通じて Worker を破棄するときに使用します。


* **`ever`**

 は _Rx_ 変数が新しい値になるたびに呼ばれます。

* **`everAll`**

 `ever` とほぼ同じですが、_Rx_ 変数の `List` を受け取ります。いずれかの値が更新されれば、その更新後の値を受け取ってコールバックが実行されます。

* **`once`**

変数が最初に更新されたときのみに呼ばれます。

* **`debounce`**

'debounce' は検索機能などで導入するととても有益です。たとえば、ユーザーがタイピングを止めたときにのみAPIを呼び出したいときに使います。ユーザーが "Jonny" と入れたときに 5回も APIに問い合わせを行うのは避けたいですよね。Getなら "debounce" があるので大丈夫です。

* **`interval`**

`interval` は debounce とは異なります。ユーザーが1秒間に1000回変数に変更を加えた場合、debounceが一定期間経過後（デフォルトは800ミリ秒）に最後の変更イベントだけ送信するのに対して、intervalは代わりに一定期間の間のユーザーによるアクションをすべて無視します。intervalは1秒ごとにイベントを送信しており、3秒に設定した場合は1分間に20個のイベントを送信します。これはユーザーがキーやマウスを連打することで何かしらの報酬を得られる場合に、その悪用を避けるために使用できます(ユーザーが何かをクリックしてコインを獲得できるとします。たとえ何秒かかったとしても300回クリックすれば300枚のコインを得ることができてしまいます。intervalを使用してインターバルを3秒に設定した場合は、何回クリックしようが1分間で得られるコインの上限は20枚になります)。一方のdebounceはアンチDDosや、検索のように変更を加えるたびにonChangeからAPI問い合わせが発生するような機能に適しています。ユーザーが入力し終わるのを待ってリクエストを送信するのです。debounceを前述のコイン獲得のケースで使用した場合、ユーザーはコインを1枚しか獲得できません。これは指定した期間、ユーザーが動作を「一時停止」したときにのみ実行されるからです。

* 注: Workerを使用する場合は、Controllerなどを起動するときに次のいずれかの方法で登録する必要があります。onInit（推奨）内、クラスのコンストラクタ、またはStatefulWidgetのinitState内（この方法は推奨しませんが、副作用はないはずです）。

## 非リアクティブな状態管理

GetはChangeNotifierを使わない軽量かつシンプルな状態管理機能を有しています。特にFlutterに慣れていない方のニーズを満たし、大規模なアプリケーションでも問題を起こすことがないと信じています。

GetBuilderは複数の状態を扱う場面で使われることを想定して作られました。たとえばショッピングカートに30個の商品があるとします。そしてあなたが商品を一つ削除すると同時に、カートのリストが更新され、合計金額が更新され、アイテム数を示すバッジが更新されます。GetBuilderはこのようなユースケースに最適です。というのも、GetBuilderは状態をControllerで束ねてそのControllerに依存するすべてのWidgetを一度に更新させることができるからです。

それらとは独立したControllerが必要な場合は、GetBuilderのidプロパティに専用IDを割り当てるか、GetXを使ってください。ケースバイケースですが、そのような「独立した」Widetが多いほど GetX() のパフォーマンスが際立ち、複数の状態変化がありそれに伴うWidgetの更新が多いほど GetBuilder() のパフォーマンスが勝ることを覚えておいてください。

### 利点

1. 必要なWidgetのみ更新される。

2. ChangeNotifierを使わず、メモリ使用量が少ない。

3. StatefulWidgetのことはもう忘れましょう。Getでは必要ありません。他の状態管理ライブラリではStatefulWidgetを使用することがあるでしょう。しかしAppBarやScaffoldなどクラス内のほとんどのWidgetがStatelessであるにも関わらず、StatefulなWidgetの状態だけを保持する代わりに、クラス全体の状態を保持しているのはなぜでしょうか？Getならクラス全体をStatelessにすることができます。更新が必要なコンポーネントは GetBuilder などで囲むことで「状態」が保持されます。

4. プロジェクトを整理しましょう！ControllerはUIの中にあってはいけません。TextEditControllerなどの類はすべてControllerクラスに配置してしまいましょう。

5. Widgetのレンダリングが開始されると同時にイベントを実行してWidgetを更新させる必要がありますか？GetBuilderにはStatefulWidgetと同様の「initState」プロパティがあり、そこからControllerのイベントを直接呼び出すことができます。initStateを使用する必要はもうありません。

6. StreamやTimerのインスタンスを破棄したい場合はGetBuilderのdisposeプロパティを利用してください。Widgetが破棄されると同時にイベントを呼び出すことができます。

7. GetXとStreamController / StreamBuilderを組み合わせるなどしてStreamを普通に使っていただいても問題ありませんが、必要なときに限って使うことをおすすめします。Streamのメモリ消費は適度であり、リアクティブプログラミングは美しいですが、たとえば30ものStreamを同時に立ち上げることを考えてみてください。これはChangeNotifierを使うよりもよくないことのように思います。

8. 必要以上にRAMを使わずWidgetを更新します。GetはGetBuilderのクリエーターIDのみを保存し、必要に応じてGetBuilderを更新します。何千ものGetBuilderを作成したとしても、ID保存のためのメモリ消費量は非常に少ないです。GetBuilderを新規に作成するということは、実際にはクリエーターIDを持つ GetBuilder の状態を共有しているに過ぎないためです。GetBuilderごとに状態が新たに作成されるわけではないため、特に大規模なアプリケーションでは多くのRAMを節約できます。基本的にGetXで作成するアプリケーションは全体的にStatelessであり、いくつかのStatefulなWidget(GetBuilder内のWidget)は単一の状態を持っているため、一つを更新すればすべてが更新されます。

9. Getはアプリ全体の流れをよく把握しており、Controllerをメモリから破棄するタイミングを正確に知っています。実際の破棄はGetがやってくれるため、開発者が心配する必要はありません。

### 使用例

``` dart
// Controllerクラスを作成してGetxControllerを継承しましょう
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update();
    // increment 実行時にcounter変数に依存するUIを更新。
    // GetBuilderを使うWidgetの場合はupdate()が必要。
  }
}
// ビュー側のクラスでGetBuilderを使ってcounter変数を組み込む
GetBuilder<Controller>(
  init: Controller(), // 最初に使用するときのみ初期化
  builder: (_) => Text(
    '${_.counter}',
  ),
)
// Controllerの初期化は最初の1回だけ行ってください。同じControllerを再度 GetBuilder / GetX で使用する場合は初期化する必要はありません。コントローラは、それを「init」とマークしたウィジェットがデプロイされると同時に、自動的にメモリから削除されます。Getがすべて自動で行ってくれるので、何も心配することはありません。同じControllerを2つ立ち上げることがないよう、それだけご注意ください。
```

**最後に**

* 以上、Getを使った状態管理の手法をご説明させていただきました。

* 注: もっと柔軟に管理する手法として、initプロパティを使わない方法もあります。Bindingsを継承したクラスを作成し、dependenciesメソッドをoverrideしてその中でGet.put()でControllerを注入してください(複数可)。このクラスとUI側のクラスを紐づけることでControllerをそのRoute内で使用できます。そしてそのControllerを初めて使用するとき、Getはdependencies内を見て初期化を実行してくれます。このlazy(遅延、消極的)ロードを維持しつつ、不要になったControllerは破棄し続けます。具体的な仕組みについてはpub.devの例をご参照ください。

Routeを移動して以前使用したControllerのデータが必要になった場合は、再度GetBuilderを使用してください。initする必要はありません。

``` dart
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

GetBuilderの外でControllerを使用する場合は、Controller内にgetterを作成しておくと便利です。Controller.to で呼び出しましょう。(もしくは `Get.find<Controller>()` を使うのもありです)

``` dart
class Controller extends GetxController {

  /// 記述量を省くためにstaticメソッドにすることをおすすめします。
  /// staticメソッド使う場合 → Controller.to.increment();
  /// 使わない場合 → Get.find<Controller>().increment();
  /// どちらを使ってもパフォーマンスに影響があったり副作用が出たりはしません。前者は型の指定が不要という違いがあるだけです
  static Controller get to => Get.find(); // これを追加

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

これで以下のようにControllerに直接アクセスできます。

``` dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // とっても簡単ですね！
  child: Text("${Controller.to.counter}"),
),
```

FloatingActionButton を押すと counter変数 に依存するWidgetがすべて自動的に更新されます。

### Controllerインスタンスの扱い

次のような画面の流れがあるとします。

 `画面A => 画面B (Controller X を使用) => 画面C (Controller X を使用)`

画面Aの段階ではまだ未使用なので、Controllerはメモリにありません(Getは基本lazyロードなので)。画面Bに遷移すると、Controllerがメモリ内に保存されます。画面Cでは画面Bと同じControllerを使用しているため、GetはBとCでControllerの状態を共有し、同じControllerがメモリ内に引き続きいることになります。画面Cを閉じてさらに画面Bを閉じ、画面Aに戻ったとしましょう。そこではControllerが使われていないため、GetはControllerをメモリから出してリソースを解放します。そこで再度画面Bに遷移すると、Controllerは再度メモリに保存されます。そして今度は画面Cに行かずに画面Aに戻ります。Getは同様にControllerをメモリから破棄してくれます。また、仮に画面CがControllerを使っておらず画面Cにいたとして、画面BをRouteスタックから削除したとしましょう。するとControllerを使用している画面(クラス)はなくなりますので、同様にメモリから破棄されます。Getが正常動作しないと考えられる唯一の例外は、画面Cにいるときに画面Bを誤ってRouteスタックから削除してしまい、Controllerの使用を試みたときです。この場合は、画面Bで作成されたControllerのクリエーターIDが削除されてしまったことが原因です(GetはクリエーターIDのないControllerはメモリから破棄するようプログラムされています)。もし意図があってこの事例に対応したい場合は、画面BのGetBuilderに "autoRemove: false" フラグを追加した上で、CクラスのGetBuilderに "adoptID: true" を追加してください。

### StatefulWidgetsはもういらない

StatefulWidgetsを使用すると、画面全体の状態を不必要に保存することになります。ウィジェットを最小限に再構築する必要がある場合は、Consumer/Observer/BlocProvider/GetBuilder/GetX/Obxの中に埋め込むことになりますが、それは別のStatefulWidgetになります。
StatefulWidgetはStatelessWidgetよりも多くのRAMが割り当てられます。これは1つや2つのStatefulWidgetでは大きな違いは産まないかもしれませんが、それが100もあった場合は確実に違いが出ます。
TickerProviderStateMixinのようなMixinを使用する必要がない限り、GetでStatefulWidgetを使用する必要はありません。

たとえばinitState()やdispose()メソッドなど、StatefulWidgetのメソッドをGetBuilderから直接呼び出すことも可能です。

``` dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

しかし、これよりもベターなアプローチはControllerの中で直接 onInit() や onClose() メソッドを呼び出すことです。

``` dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

* 注: コンストラクタを通じてControllerを立ち上げる必要はありません。このようなプラクティスは、パフォーマンス重視であるGetのControllerの作成や割り当ての原理、考え方から外れてしまいます（コンストラクタ経由でインスタンスを作成すれば、実際に使用される前の段階でControllerを生成し、メモリを割り当てることになります）。onInit() と onClose() メソッドはこのために作られたもので、Controllerのインスタンスが作成されたとき、または初めて使用されたときに呼び出されます（Get.lazyPutを使用しているか否か次第）。たとえば、データを取得するためにAPIを呼び出したい場合は initState/dispose の代わりに onInit() を使用し、Streamを閉じるなどのコマンドを実行する必要がある場合は onClose() を使用してください。

### Getの目的

このパッケージの目的は、Routeのナビゲーション、依存オブジェクトと状態の管理のための完全なソリューションを、開発者が外部パッケージに極力依存せずに済むような形で提供し、高度なコード分離性（デカップリング）を実現することです。それを確実なものとするため、Getはあらゆる高レベルおよび低レベルのFlutter APIを取り込んでいます。これによりビューとロジックを切り分けることが容易になり、UIチームにはWidgetの構築に集中してもらい、ビジネスロジック担当チームにはロジックに集中してもらうことができます。Getを使うことでよりクリーンな作業環境を構築することができるのです。

要するに、initState内でメソッドを呼び出してパラメーターを通じてControllerにデータを送信する必要も、そのためにControllerのコンストラクタを使用する必要もありません。Getには必要なタイミングでサービスを呼び出してくれう onInit() メソッドがあります。
Controllerが不要になれば、onClose() メソッドがジャストなタイミングでメモリから破棄してくれます。これにより、ビューとビジネスロジックを分離することができるのです。

GetxController 内に dispose() メソッドがあっても何も起こらないので記述しないでください。ControllerはWidgetではないので「dispose」できません。たとえばController内でStreamを使用していてそれを閉じたい場合は、以下のように onClose() メソッドにコードを記述してください。

``` dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// Streamを閉じる場合は dispose() ではなく onClose()
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Controllerのライフサイクルについて。

* onInit() はControllerが作成されたタイミングで実行されます。
* onClose() は onDelete() メソッドが実行される直前のタイミングで実行されます。
* Controllerが削除されるとそのAPIにアクセスすることはできません。文字通りメモリからの削除だからです。削除のトレースログも残りません。

### Controllerの様々な使用方法

ControllerインスタンスはGetBuilderのvalueを通じて使用することができます。

``` dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', // ここ
  ),
),
```

GetBuilderの外でControllerインスタンスを使う場合は、このアプローチをおすすめします。

``` dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// ビュー側で
GetBuilder<Controller>(
  init: Controller(), // 最初に使うときだけ必要
  builder: (_) => Text(
    '${Controller.to.counter}', // ここ
  )
),
```

もしくは

``` dart
class Controller extends GetxController {
 // static get を省き、
[...]
}
// ビュー側で
GetBuilder<Controller>(
  init: Controller(), // 最初に使うときだけ必要
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // ここ
  ),
),
```

* get_it や modular など他の依存オブジェクト管理ライブラリを使用しているため、単にControllerのインスタンスを渡したいだけの場合は、このような「非正規」な方法もあります。

``` dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, // ここ
  builder: (_) => Text(
    '${controller.counter}', // ここ
  ),
),

```

### ユニークIDの設定

GetBuilderを使ってWidgetの更新をコントロールしたい場合は、このようにユニークIDを振ってください。

``` dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // 最初に使うときだけ必要
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // ここ
  ),
),
```

そして以下のようにWidgetを更新します。

``` dart
update(['text']);
```

さらに更新に条件を設けることができます。

``` dart
update(['text'], counter < 10);
```

GetXはこの更新を自動で行ってくれます。指定したIDを持ち、その変数に依存するWidgetのみを更新します。また変数を前の値と同じ値に変更しても、それが状態の変化を意味しない場合はメモリとCPUサイクルを節約するためにWidgetを更新しません (画面に 3 が表示されているときに、変数を再び 3 に変更したとします。このような場合にWidgetを更新する状態管理ソリューションも存在しますが、GetXでは実際に状態が変更された場合にのみ更新されます）。

## 状態管理ソリューションを混在させる

MixinBuilderはObxとGetBuilderを併用したいというリクエストから発想して作られました。これは ".obs" 変数の変更によるリアクティブな更新と、update() メソッドによるメカニカルな更新の両方を混在可能にします。ただし、GetBuiler / GetX / Obx / MixinBuilder の4つの中で最もリソースを消費するWidgetです。というのも、Widgetからのイベントを検知するためのSubscriptionに加えて、Controller自身のupdateメソッドも購読する必要があるからです。

MixinBuilderに使用するControllerクラスには、変数を `.obs`（Observable）とするかどうかに関わらず、GetxControllerを継承したものを使用してください。GetxControllerにはライフサイクルがあり、onInit() および onClose() メソッドでイベントを「開始」したり「終了」したりすることができます。

## StateMixin

`StateMixin<T>` を使うことでさらに `UI` の「状態」を便利に扱うことができます。
`with` を使って `StateMixin<T>` をControllerにミックスインしてください。Tにはモデルのクラス名が入ります。

``` dart
class Controller extends GetController with StateMixin<User>{}
```

状態を変更するには `change()` メソッドを使ってください。
パラメーターにはビューに渡すデータと「状態」をセットします。

```dart
change(data, status: RxStatus.success());
```

RxStatus の「状態」は以下の4つです。

``` dart
RxStatus.loading(); // ロード中
RxStatus.success(); // ロード成功
RxStatus.empty(); // データが空
RxStatus.error('message'); // エラー
```

それぞれの「状態」をUIで表すには以下のようにします。

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),

        // ここはカスタムのロードインジケーターでも可能ですが、
        // デフォルトは Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // ここもカスタムのエラーWidgetでも構いませんが、
        // デフォルトは Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

## GetBuilder VS GetX VS Obx VS MixinBuilder

私は10年間プログラミングに携わってきて、いくつか貴重な教訓を得ることができました。

リアクティブプログラミングに初めて触れたとき、「おお、これはすごい」と感嘆せずにはいられませんでしたし、実際にすごいものでした。
しかし、リアクティブプログラミングはすべての状況に適しているわけではありません。多くの場合、必要なのは2,3のWidgetの状態を同時に更新すること、またはローカルでの一時的な状態の変更であり、これらの場合はリアクティブである必要はありません。

リアクティブプログラミングのRAM消費量の多さは、必要なときだけ、かつ1つのWidgetだけ同時に更新するようすることである程度補うことができます。ただ、たとえば80ものオブジェクトを持つリストがあったとして、それぞれが複数のStreamを持つのは得策ではありません。Dartのインスペクターを開いて、StreamBuilderがどれだけRAMを消費しているか見てみてください。私が伝えたいことを理解してもらえると思います。

そのことを念頭に私はシンプルな状態管理ソリューションを作りました。このシンプルさに期待することは、リソース面で経済的である点、Widget単位ではなくブロック単位で状態を更新できる点であるべきです。

GetBuilderはRAM消費の面で最も経済的なソリューションだと信じています（もしあれば、ぜひ教えてください）。

しかし、GetBuilderは依然として update() により更新がかかるスタイルのメカニカルな状態管理ソリューションであり、notifyListeners() と呼び出し回数は変わりありません。

一方で、ここでリアクティブプログラミングを使わないのは車輪の再発明なんじゃないかと思えるような状況もあります。この点を考慮して、GetX() は先進的な状態管理の手法を提供するために作られました。必要なものを必要なときだけ更新し、エラーが発生してユーザーが300ものイベントを同時に送信したとしても、GetX() は状態の変化をフィルタリングして画面を更新してくれます。

GetX() は他のリアクティブな状態管理ソリューションに比べて経済的であることに変わりはありませんが、GetBuilder() よりは少しだけ多くのRAMを消費します。その点を考慮し、リソース消費を最大限活かすことを目指して Obx() は開発されました。GetX() や GetBuilder() と異なり、Obx() の中でControllerを初期化することはできません。Obx() は、子Widgetからの更新イベントを受け取る Stream購読Widgetでしかありません。GetX() よりは経済的ですが、GetBuilder() には負けます。GetBuilder() はWidgetのハッシュ値と状態のsetterを保持しているだけなので、これはある意味当然です。Obx() はControllerの型を指定する必要がなく、複数の異なるコントローラからの変更を聞くことができます。ただし、Obx() の外かBindingsで事前にControllerを初期化しておく必要があります。

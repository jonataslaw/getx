* [State Management(Durum Yönetimi)](#state-management)
  + [Reactive State Manager](#reactive-state-manager)
    - [Advantages](#advantages)
    - [Maximum performance:](#maximum-performance)
    - [Declaring a reactive variable](#declaring-a-reactive-variable)
        - [Having a reactive state, is easy.](#having-a-reactive-state-is-easy)
    - [Using the values in the view](#using-the-values-in-the-view)
    - [Conditions to rebuild](#conditions-to-rebuild)
    - [Where .obs can be used](#where-obs-can-be-used)
    - [Note about Lists](#note-about-lists)
    - [Why i have to use .value](#why-i-have-to-use-value)
    - [Obx()](#obx)
    - [Workers](#workers)
  + [Simple State Manager](#simple-state-manager)
    - [Advantages](#advantages-1)
    - [Usage](#usage)
    - [How it handles controllers](#how-it-handles-controllers)
    - [You won't need StatefulWidgets anymore](#you-wont-need-statefulwidgets-anymore)
    - [Why it exists](#why-it-exists)
    - [Other ways of using it](#other-ways-of-using-it)
    - [Unique IDs](#unique-ids)
  + [Mixing the two state managers](#mixing-the-two-state-managers)
  + [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# State Management (Durum Yönetimi)

GetX, diğer State Management'ler (Durum Yöneticileri) gibi Streams veya ChangeNotifier kullanmaz. Niye? GetX ile android, iOS, web, linux, macos ve linux için uygulamalar oluşturmaya ek olarak, Flutter/GetX ile aynı syntax(sözdizimine) sahip server(sunucu) uygulamaları oluşturabilirsiniz. Yanıt süresini iyileştirmek ve RAM tüketimini azaltmak için düşük işletim maliyetiyle çok fazla performans sunan düşük gecikmeli çözümler olan GetValue ve GetStream'i oluşturduk. State Management (Durum Yönetimi) de dahil olmak üzere tüm kaynaklarımızı oluşturmak için bu temeli kullanıyoruz.

* _Complexity_ (Karmaşıklık):  Bazı state management'ler karmaşıktır ve çok fazla ortak özelliği vardır. GetX ile her olay için bir sınıf tanımlamanız gerekmez, kod son derece temiz ve nettir ve daha az yazarak çok daha fazlasını yaparsınız. Pek çok insan bu konu yüzünden Flutter'dan vazgeçti ve şimdi nihayet durumları yönetmek için basit bir çözüme sahipler.
* _No code generators_ (Kod Oluşturucu Yok): Geliştirme zamanınızın yarısını uygulama mantığınızı yazmaya harcarsınız. Bazı state management'ler, minimum düzeyde okunabilir koda sahip olmak için kod oluşturuculara güvenir. Bir değişkeni değiştirmek ve build_runner'ı çalıştırmak verimsiz olabilir ve genellikle flutter clean'den sonraki bekleme süresi uzun olur ve çok fazla kahve içmeniz gerekir.

GetX ile her şey reaktiftir ve hiçbir şey kod oluşturuculara bağlı değildir, bu da geliştirmenizin tüm yönlerinde üretkenliğinizi artırır.

* _It does not depend on context(Context'e bağlı değil)_: Muhtemelen görünümünüzün context'ini (bağlam) bir denetleyiciye göndermeniz gerekiyordu, bu da görünümün iş mantığınızla bağlantısını yüksek hale getirdi. Muhtemelen context'i (bağlamı) olmayan bir yer için bir bağımlılık kullanmak zorunda kaldınız ve context'i(bağlamı) çeşitli sınıflar ve fonksiyonlardan geçirmek zorunda kaldınız.Bu sadece GetX ile mevcut değil. Controller'larınıza (Denetleyicilerinize) , controller'larınızın(denetleyicilerinizin) içinden herhangi bir context (bağlam) olmadan erişebilirsiniz. Kelimenin tam anlamıyla hiçbir şey için context'i(bağlamı) parametreye göre göndermeniz gerekmez.
* _Granular control(Parçacıklı Kontrol)_: Çoğu state management(durum yöneticisi) ChangeNotifier'ı temel alır. ChangeNotifier, notifyListeners çağrıldığında kendisine bağlı olan tüm widget'ları bilgilendirecektir. Bir ekranda ChangeNotifier sınıfınızın bir değişkenine sahip 40 widget'ınız varsa, birini güncellediğinizde hepsi yeniden oluşturulacaktır.

GetX ile iç içe geçmiş widget'lara bile saygı duyulur. Obx listview'inizi izliyorsa ve diğeri ListView içinde bir onay kutusu izliyorsa, CheckBox değerini değiştirirken yalnızca o onay kutusu güncellenir, Liste değerini değiştirirken yalnızca ListView güncellenir.

* _It only reconstructs if its variable REALLY changes (Değişken değişirse GERÇEKTEN yeniden yapılandırır)_: GetX akış kontrolüne sahiptir, yani 'Paola' ile bir text(metin) görüntülerseniz, (observable)gözlemlenebilir değişkeni tekrar 'Paola' olarak değiştirirseniz, widget yeniden yapılandırılmayacaktır. Çünkü GetX, 'Paola'nın' zaten text'de(metinde) görüntülendiğini ve gereksiz rekonstrüksiyonlar yapmayacağını biliyor.

Mevcut state management'lerin(durum yöneticilerin) çoğu (hepsi değilse de) ekranda yeniden oluşturulur.

## Reactive State Manager

Reaktif programlama birçok insanı yabancılaştırabilir çünkü karmaşık olduğu söylenir. GetX reaktif programlamayı oldukça basit bir şeye dönüştürür:

* Stream Controller oluşturmanıza gerek yoktur.
* Her değişken için bir StreamBuilder oluşturmanız gerekmez.
* Her state(durum) için bir sınıf oluşturmanız gerekmeyecektir.
* Bir initial value(başlangıç değeri) için bir get oluşturmanız gerekmeyecektir.

Get ile reaktif programlama, Setstate'i kullanmak kadar kolaydır.

Bir ad değişkeniniz olduğunu ve her değiştirdiğinizde onu kullanan tüm widget'ların otomatik olarak değiştirilmesini istediğinizi düşünelim.

Bu sizin count(sayım) değişkeninizdir:

``` dart
var name = 'Jonatas Borges';
```

Observable hale getirmek için, sonuna ".obs" eklemeniz gerekir:

``` dart
var name = 'Jonatas Borges'.obs;
```

Hepsi bu. *Bu kadar basit* bir şey.

Şu andan itibaren, bu reaktif-".obs"(ervables) değişkenlerine _Rx_ adını verebiliriz.

Kaputun altında ne yaptık? `String` lerin bir `Stream` oluşturduk, `"Jonatas Borges"` initial value'sunu(başlangıç değerini) atadık, `"Jonatas Borges"` kullanan tüm widget'lara artık bu değişkene "ait olduklarını" bildirdik ve _Rx_ değeri değiştiğinde de değişmeleri gerekecek. 

Bu, Dart'ın yetenekleri sayesinde **GetX'in büyüsüdür**.

Ancak, bildiğimiz gibi, bir `Widget` yalnızca bir işlevin içindeyse değiştirilebilir, çünkü statik sınıflar "otomatik değiştirme" gücüne sahip değildir.

Bir `StreamBuilder` oluşturmanız, değişiklikleri dinlemek için bu değişkene abone olmanız ve aynı kapsamdaki birkaç değişkeni değiştirmek istiyorsanız, iç içe geçmiş `StreamBuilder` bir "kaskad" oluşturmanız gerekir, değil mi?

Hayır, bir `StreamBuilder`a ihtiyacınız yok, ancak statik sınıflar konusunda haklısınız.

Pekala, görünüşe göre, belirli bir Widget'ı değiştirmek istediğimizde genellikle çok fazla ortak bilgimiz olur, bu Flutter yoludur.
**GetX** ile bu ortak kod kodunu da unutabilirsiniz.

`StreamBuilder( … )` ? `initialValue: …` ? `builder: …` ? Hayır, bu değişkeni bir `Obx()` Widget'ına yerleştirmeniz yeterlidir.

``` dart
Obx (() => Text (controller.name));
```

_Ezberlemek için neye ihtiyacın var?_Sadece `Obx(() =>` . 

You are just passing that Widget through an arrow-function into an `Obx()` (the "Observer" of the _Rx_). 
Bu Widget'ı bir ok işlevinden bir 'Obx()' (_Rx_'in "Observable") içine geçiriyorsunuz.

`Obx` oldukça akıllıdır ve yalnızca `controller.name`nin değeri değiştiğinde değişecektir.

`name`, `"John"` ise ve onu `"John"` ( `name.value = "John"` ) olarak değiştirirseniz, öncekiyle aynı `değer` olduğundan, ekranda hiçbir şey değişmeyecektir, ve 'Obx' , kaynakları kurtarmak için yeni değeri yok sayar ve Widget'ı yeniden oluşturmaz. **Harika değil mi?**

> Peki ya bir `Obx` içinde 5 _Rx_ (observable) değişkenim varsa?

Yalnızca **herhangi biri** değiştiğinde güncellenecektir.

> Ve bir sınıfta 30 değişkenim varsa, birini güncellediğimde, o sınıftaki değişkenlerin **tümünü** günceller mi?

Hayır, sadece bu _Rx_ değişkenini kullanan **belirli Widget**.

Bu nedenle, **GetX** yalnızca _Rx_ değişkeni değerini değiştirdiğinde ekranı günceller.

``` 

final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```

### Advantages(Avantajlar)

**GetX()**, güncellenenler üzerinde **ayrıntılı** kontrole ihtiyacınız olduğunda size yardımcı olur.
 
Bir eylem gerçekleştirdiğinizde tüm değişkenleriniz değiştirileceğinden `unique IDs(benzersiz kimliklere)` ihtiyacınız yoksa, `GetBuilder`ı kullanın,
çünkü Simple State Updater(Basit Durum Güncelleyicisi)'dir (`setState ()` gibi bloklar halinde), sadece birkaç kod satırında yapılır.
En az CPU etkisine sahip olmak ve sadece tek bir amacı (_State_ rebuild) yerine getirmek ve mümkün olan en az kaynağı harcamak için basitleştirildi.

**Güçlü** bir State Management (Durum Yöneticisi)'e ihtiyacınız varsa, **GetX** ile yanlış yapmış olamazsınız.

Değişkenlerle çalışmaz, ancak __flows__, içindeki her şey başlık altındaki `Streams`dır.


_rxDart_ ile birlikte kullanabilirsiniz, çünkü her şey `Streams`,
her "_Rx_variable"ın 'event(olayını)' dinleyebilirsiniz,
çünkü içindeki her şey `Streams`'dir.

Kelimenin tam anlamıyla bir _BLoC_ yaklaşımıdır, _MobX_'den daha kolaydır ve kod oluşturucuları veya süslemeleri yoktur.
**Herhangi bir şeyi** yalnızca bir `.obs` ile _"Observable"_ hale getirebilirsiniz.

### Maksimum Performans:

State Management (Durum Yöneticisinin)'in değiştiğinden emin olmak için akıllı bir algoritmaya sahip olmanın yanı sıra **GetX** comparators kullanır.

Uygulamanızda herhangi bir hatayla karşılaşırsanız ve yinelenen bir State(durum) değişikliği gönderirseniz,
**GetX** çökmemesini sağlayacaktır.

**GetX** ile State(Durum) yalnızca `value(değer)` değişirse değişir.
Bu, **GetX** ile mobx_'den _ `computed` kullanımı arasındaki temel farktır.
İki defa __observable__ 'da bir değişiklik yapıldığında; o _observable_ dinleyicisi de değişecektir.


With **GetX**, if you join two variables, `GetX()` (similar to `Observer()` ) will only rebuild if it implies a real change of State.
**GetX** ile, iki değişkeni birleştirirseniz, `GetX()` (`Observer()`a benzer) yalnızca gerçek bir State(Durum) değişikliği gerektiriyorsa yeniden oluşturacaktır.

### Reaktif bir değişken bildirmek

Bir değişkeni "observable" hale getirmenin 3 yolu vardır.

1 - Birincisi **`Rx{Type}`** kullanmak.

``` dart
// initial value önerilir, zorunlu değildir.
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - İkincisi, **`Rx`** kullanmak ve Darts Generics, `Rx<Type>` kullanmaktır.

``` dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Custom classes - herhangi bir sınıf olabilir
final user = Rx<User>();
```

3 - Üçüncü, daha pratik, daha kolay ve tercih edilen yaklaşım,`value`'ya bir **`.obs`** ekleyin:

``` dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - herhangi bir sınıf olabilir
final user = User().obs;
```

##### Reaktif bir duruma sahip olmak kolaydır.

Bildiğimiz gibi, _Dart_ şimdi _null safety_ doğru gidiyor.
Şu andan itibaren hazırlıklı olmak için, _Rx_ değişkenlerinizi her zaman bir **initial value** ile başlatmalısınız.

> Bir değişkeni **GetX** ile _observable_ + _initial value_ değerine dönüştürmek en basit ve pratik yaklaşımdır.

Kelimenin tam anlamıyla bir değişkeninizin sonuna bir " `.obs` " ekleyeceksiniz, ve **bu kadar**, şimdi onu gözlemlenebilir hale getirdiniz,
ve onun `.value(değer)`'i,  _initial value_ olacaktır).

### Görünümdeki değerleri kullanma

``` dart
// controller dosyası
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

``` dart
// view dosyası
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

`count1.value++` değerini artırırsak, şunu yazdırır:

* `count 1 rebuild`

* `count 3 rebuild`

`count1`,  `1` değerine sahip olduğundan ve `1 + 0 = 1` olduğundan, `toplam` değeri değiştirilir.

`count2.value++` değerini değiştirirsek, şunu yazdırır:

* `count 2 rebuild`

* `count 3 rebuild`

çünkü `count2.value`  değişti ve `sum`un sonucu şimdi `2` oldu.

* NOT: Varsayılan olarak, ilk etkinlik aynı `value` olsa bile widget'ı yeniden oluşturacaktır.

Bu durum boolean değişkenlerinde de mevcuttur.

Bunu yaptığınızı hayal edin:

``` dart
var isLogged = false.obs;
```

Ardından, bir kullanıcının `ever` içinde bir olayı tetiklemek için `isLogged` olup olmadığını kontrol ettiniz.

``` dart
@override
onInit() async {
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


`hasToken` `false` olsaydı, `isLogged`da herhangi bir değişiklik olmazdı, bu nedenle `ever()` asla çağrılmazdı.
Bu tür davranışlardan kaçınmak için, bir _observable_ öğesindeki ilk değişiklik her zaman bir olayı tetikleyecektir,
aynı `.value` değerini içerse bile.

İsterseniz bu davranışı kullanarak kaldırabilirsiniz:
 `isLogged.firstRebuild = false;`

### Yeniden oluşturulacak koşullar

Ek olarak, Get gelişmiş durum kontrolü sağlar. Bir olayı (listeye nesne ekleme gibi) belirli bir koşulda koşullandırabilirsiniz.

``` dart
// İlk parametre: koşul, true veya false döndürmelidir.
// İkinci parametre: koşul doğruysa yeni değer uygulanacaktır.
list.addIf(item < limit, item);
```

Süslemesiz, kod oluşturucusuz, komplikasyonsuz :smile:

Flutter'ın sayaç uygulamasını biliyor musunuz? Controller sınıfınız şöyle görünebilir:

``` dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Basit bir şekilde:

``` dart
controller.count.value++
```

Kullanıcı arabiriminizdeki sayaç değişkenini nerede depolandığına bakılmaksızın güncelleştirebilirsiniz.

### Nerede .obs kullanılabilir

Obs üzerindeki her şeyi dönüştürebilirsiniz. İşte bunu yapmanın iki yolu:

* Sınıf değerlerinizi obs'ye dönüştürebilirsiniz

``` dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* veya tüm sınıfı observable hale getirebilirsiniz.

``` dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// örnek verirken:
final user = User(name: "Camila", age: 18).obs;
```

### Listeler hakkında not

Listeler, içindeki nesneler gibi tamamen gözlemlenebilir. Bu şekilde, bir listeye bir değer eklerseniz, onu kullanan widget'ları otomatik olarak yeniden oluşturur.

Ayrıca listelerde ".value" kullanmanıza gerek yok, harika dart api'ları bunu kaldırmamıza izin verdi.
Ne yazık ki, String ve int gibi ilkel türler genişletilemez, bu da kullanımını sağlar.Değer zorunludur, ancak bunlar için get ve setter'larla çalışıyorsanız bu bir sorun olmayacaktır.

``` dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // .value olması gerekir
ListView.builder (
  itemCount: controller.list.length // listelerin buna ihtiyacı yok
)
```

Kendi sınıflarınızı observable hale getirirken, bunları güncellemenin farklı bir yolu vardır:

``` dart
// model dosyasında
// her bir öznitelik yerine tüm sınıfı observable hale getireceğiz
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}

// Controller dosyası
final user = User().obs;
// User değişkenini güncellemeniz gerektiğinde:
user.update( (user) { // bu parametre, güncellemek istediğiniz sınıfın kendisidir.
user.name = 'Jonny';
user.age = 18;
});
// user değişkenini güncellemenin alternatif bir yolu:
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// model değerlerine .value olmadan da erişebilirsiniz:
user().name; 
```

İstemiyorsanız setlerle çalışmak zorunda değilsiniz. "assign" ve "assignAll" api'sini kullanabilirsiniz.
"assign" api'si listenizi temizler ve oradan başlatmak istediğiniz tek bir nesneyi ekler.
"assignAll" api, mevcut listeyi temizleyecek ve ona enjekte ettiğiniz yinelenebilir nesneleri ekleyecektir.

### Neden .value kullanmak zorundayım?

Basit bir decoration ve code generator ile `String` ve `int` için 'value' kullanma zorunluluğunu kaldırabiliriz, ancak bu kütüphanenin amacı kesinlikle dış bağımlılıklardan kaçınmaktır. Temelleri (route, dependencies ve state management) içeren, harici bir pakete ihtiyaç duymadan basit, hafif ve performanslı bir şekilde programlamaya hazır bir ortam sunmak istiyoruz.

Pubspec'inize (get) tam anlamıyla 3 harf ve iki nokta üst üste ekleyebilir ve programlamaya başlayabilirsiniz. Rota yönetiminden durum yönetimine kadar varsayılan olarak dahil edilen tüm çözümler kolaylık, üretkenlik ve performansı hedefler.

Bu kitaplığın toplam ağırlığı, eksiksiz bir çözüm olmasına rağmen tek bir state manager'den daha azdır.


Eğer `.value` dan rahatsızsanız MobX harika bir alternatiftir ve Get ile birlikte kullanabilirsiniz.

If you have no problem with the MobX code generator, or have no problem with the BLoC boilerplate, you can simply use Get for routes, and forget that it has state manager. Get SEM and RSM were born out of necessity, my company had a project with more than 90 controllers, and the code generator simply took more than 30 minutes to complete its tasks after a Flutter Clean on a reasonably good machine, if your project it has 5, 10, 15 controllers, any state manager will supply you well. If you have an absurdly large project, and code generator is a problem for you, you have been awarded this solution.

MobX code generator ile bir sorununuz yoksa veya BLoC ilgili bir sorununuz yoksa Get ile route'u kullanabilirsiniz. Get SEM ve RSM ile doğdu, şirketimin 90'dan fazla controller'a sahip bir projesi var.Büyük bir projeniz varsa, oldukça iyi bir makinede bir Flutter Clean'den sonra görevlerini tamamlaması 30 dakikadan fazla sürdü. 5, 10, 15 controller, herhangi bir state manager size yardımcı olacaktır. Büyük bir projeniz varsa ve code generator sizin için bir sorunsa, bu çözüm size verildi.

Açıkçası, birisi projeye katkıda bulunmak ve bir code generator veya benzeri bir şey oluşturmak istiyorsa, bunu readme'de alternatif olarak bağlantı ekleyeceğim, şimdilik diyorum ki, bunu zaten yapan iyi çözümler var, MobX gibi.

### Obx()

Bindings kullanarak Get yazmak gereksizdir. Yalnızca bir pencere öğesi oluşturan anonim işlevi alan GetX yerine Obx pencere aracını kullanabilirsiniz.
Açıkçası, bir tür kullanmıyorsanız, değişkenleri kullanmak için denetleyicinizin bir örneğine sahip olmanız veya değeri almak için `Get.find<Controller>()` .value veya Controller.to.value öğesini kullanmanız gerekir. .

### Çalışanlar

Bir olay meydana geldiğinde belirli geri aramaları tetikleyerek size yardımcı olacaktır.

``` dart
/// 'Count1' her değiştiğinde çağrılır.
ever(count1, (_) => print("$_ has been changed"));

/// $_ değişkeni yalnızca ilk kez değiştirildiğinde çağrılır.
once(count1, (_) => print("$_ was changed once"));

/// Anti DDoS - Örneğin, kullanıcı 1 saniye boyunca yazmayı her durdurduğunda çağrılır.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// 1 saniye içinde tüm değişiklikleri yok sayın.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

Tüm çalışanlar (`debounce` dışında), "bool" veya "bool" döndüren bir callback olabilen bir "Koşul" adlı parametreye sahiptir.
Bu "koşul", "callback" işlevinin ne zaman yürütüleceğini tanımlar.

Tüm çalışanlar, çalışanı iptal etmek için ( `dispose()` aracılığıyla) kullanabileceğiniz bir 'Worker' örneği döndürür.
 

* **`ever`**

_Rx_ değişkeni her yeni bir değer yaydığında çağrılır.

* **`everAll`**

`ever` gibi, ancak değişkeni her değiştirildiğinde çağrılan _Rx_ değerlerinin bir `List`'ini alır. Bu kadar.

* **`once`**

'once', yalnızca değişken ilk değiştirildiğinde çağrılır.

* **`debounce`**

'debounce', yalnızca kullanıcı yazmayı bitirdiğinde API'nin çağrılmasını istediğiniz arama işlevlerinde çok kullanışlıdır. Kullanıcı "Jonny" yazarsa, apı'lerde J, o, n, n ve y harfleriyle 5 aramanız olur. Get ile bu olmaz, çünkü yalnızca yazmanın sonunda tetiklenecek bir "debounce" çalışanınız olur.

* **`interval`**

'interval' debouce'dan farklıdır. debouce kullanıcı 1 saniye içinde bir değişkene 1000 değişiklik yaparsa, öngörülen zamanlayıcıdan sonra yalnızca sonuncusunu gönderir (varsayılan değer 800 milisaniyedir). Interval bunun yerine, öngörülen süre boyunca tüm kullanıcı eylemlerini yoksayar. Olayları saniyede 1000 olmak üzere 1 dakika boyunca gönderirseniz, debounce yalnızca kullanıcı olayları engellemeyi bıraktığında size sonuncusunu gönderir. aralık, her saniye olayları teslim eder ve 3 saniyeye ayarlanırsa, o dakika 20 olay teslim eder. Bu, kullanıcının bir şeye hızlı bir şekilde tıklayabileceği ve bir avantaj elde edebileceği işlevlerde kötüye kullanımı önlemek için önerilir (kullanıcının bir şeye tıklayarak para kazanabileceğini düşünün, aynı dakikada 300 kez tıklarsa, 300 jetona sahip olur, aralığı kullanarak, bir zaman dilimi ayarlayabilirsiniz 3 saniye boyunca ve hatta 300 veya bin kez tıklandığında, 1 dakika içinde alacağı maksimum 20 jeton, 300 veya 1 milyon kez tıklanır). Debounce, anti-DDoS için, Onchange'deki her değişikliğin apı'nizde bir sorguya neden olacağı arama gibi işlevler için uygundur. Debounce, kullanıcının isteği yapmak için adı yazmayı bırakmasını bekleyecektir. Yukarıda belirtilen jeton senaryosunda kullanılmış olsaydı, kullanıcı yalnızca belirlenen süre boyunca "durakladığında" çalıştırıldığı için kullanıcı yalnızca 1 jeton kazanırdı.

* NOT: Çalışanlar her zaman bir Controller veya Class başlatırken kullanılmalıdır, bu nedenle her zaman onInit (önerilen), Class oluşturucu veya statefulwidget'in initState üzerinde olmalıdır (bu uygulama çoğu durumda önerilmez, ancak herhangi bir yan etkisi olmamalıdır).

## Simple State Manager (Basit Durum Yöneticisi)

Get'in son derece hafif ve kolay, ChangeNotifier kullanmayan, özellikle Flutter'a yeni başlayanların ihtiyacını karşılayacak ve büyük uygulamalar için sorun yaratmayacak bir state manager'i var.

GetBuilder tam olarak çoklu state controller'a yöneliktir. Bir sepete 30 ürün eklediğinizi, birini sil'i tıklattığınızı, aynı zamanda listenin güncellendiğini, fiyatın güncellendiğini ve alışveriş sepetindeki rozetin daha küçük bir sayıya güncellendiğini düşünün. Bunu GetBuilder yapar, çünkü durumları gruplandırır ve bunun için herhangi bir "hesaplama mantığı" olmadan hepsini bir kerede değiştirir. GetBuilder, bu tür bir durum göz önünde bulundurularak oluşturuldu, çünkü geçici durum değişikliği için Setstate'i kullanabilirsiniz ve bunun için bir state manager'e ihtiyacınız olmaz.

Bu şekilde, tek bir controller'a ihtiyacınız varsa, bunun için ID'ler atayabilir veya getx'i kullanabilirsiniz. Bu size kalmış, sahip olduğunuz daha fazla "individual" widget'ın, getx'in performansının o kadar fazla öne çıkacağını, Getbuilder'ın performansının ise birden fazla durum değişikliği olduğunda üstün olması gerektiğini unutmayın.

### Avantajlar

1. Yalnızca gerekli widget'ları günceller.

2. ChangeNotifier kullanmaz, daha az bellek kullanan (0mb'ye yakın) durum yöneticisidir.

3. StatefulWidget'ı unutun! Get ile buna asla ihtiyacınız olmayacak. Diğer state manager'lar ile (BLoC, MobX Controller vb.) muhtemelen bir StatefulWidget kullanmanız gerekecek. Stateless Widget mı? Öyleyse, yalnızca state bilgisi olan Widget'ın durumunu kaydedebiliyorsanız, neden tüm sınıfın durumunu kurtarın? Get bunu da çözer. Stateless bir sınıf oluşturun, her şeyi Stateless yapın. Tek bir bileşeni güncellemeniz gerekiyorsa, onu GetBuilder ile sarın.

4. Projenizi gerçek anlamda düzenleyin! Denetleyiciler UI'nizde bulunmamalı, TextEditController'ınızı veya kullandığınız herhangi bir denetleyiciyi Controller sınıfınıza yerleştirmemelidir.

5.Bir widget'ı oluşturulduğu anda güncellemek için bir olayı tetiklemeniz mi gerekiyor? GetBuilder, StatefulWidget gibi "initState" özelliğine sahiptir ve initState'inize daha fazla event yerleştirilmeden, doğrudan denetleyicinizden event'leri çağırabilirsiniz.

6. Stream, timer vb. kapatmak gibi bir eylemi tetiklemeniz gerekiyor mu? Get Builder ayrıca, widget yok edilir edilmez olayları çağırabileceğiniz dispose özelliğine de sahiptir.

7. Stream'leri yalnızca gerektiğinde kullanın. Stream Controller controller içinde normal olarak kullanabilir ve Streambuilder'ı da normal olarak kullanabilirsiniz, ancak unutmayın, bir stream makul bir şekilde bellek tüketir, reaktif programlama güzeldir, ancak kötüye kullanmamalısınız. aynı anda açılan 30 stream, Changenotifier'den daha kötü olabilir (ve changeNotifier çok kötüdür).

8. Ram harcamadan widget'ları güncelleyin. Get yalnızca Get Builderlder içerik oluşturucu kimliğini ve gerektiğinde GetBuilder güncelleştirmelerini depolar. Bellekte get ID depolama bellek tüketimi bile GetBuilders binlerce çok düşüktür. Yeni bir GetBuilder oluşturduğunuzda, aslında bir içerik oluşturucu kimliği olan GetBuilder durumunu paylaşıyorsunuz demektir. Her GetBuilder için büyük uygulamalar için çok fazla ram tasarrufu sağlayan yeni bir durum oluşturulmaz. Temel olarak uygulamanız tamamen Stateless olacak ve State Bilgisi olan birkaç Widget (GetBuilder içinde) tek bir duruma sahip olacak ve bu nedenle birini güncellemek hepsini güncelleyecektir. State sadece bir tanesidir.

9. Get her şeyi bilir ve çoğu durumda bir denetleyiciyi bellekten çıkarma zamanını tam olarak bilir. Bir denetleyiciyi ne zaman elden çıkaracağınız konusunda endişelenmemelisiniz, Bunu yapmak için en iyi zamanı öğrenin.

### Usage

``` dart
// Controller sınıfı oluşturun ve GetxController'ı extends edin
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // artış çağrıldığında kullanıcı arayüzünde sayaç değişkenini güncellemek için update() işlevini kullanın
  }
}
// Stateless/Stateful sınıfınızda, artış çağrıldığında Metni güncellemek için Get Builder'ı kullanın
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```

**Done!**

* You have already learned how to manage states with Get.

* Note: You may want a larger organization, and not use the init property. For that, you can create a class and extends Bindings class, and within it mention the controllers that will be created within that route. Controllers will not be created at that time, on the contrary, this is just a statement, so that the first time you use a Controller, Get will know where to look. Get will remain lazyLoad, and will continue to dispose Controllers when they are no longer needed. See the pub.dev example to see how it works.

If you navigate many routes and need data that was in your previously used controller, you just need to use GetBuilder Again (with no init):

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

If you need to use your controller in many other places, and outside of GetBuilder, just create a get in your controller and have it easily. (or use `Get.find<Controller>()` )

``` dart
class Controller extends GetxController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.increment();
  /// with no static method: Get.find<Controller>().increment();
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

``` dart
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

``` dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

A much better approach than this is to use the onInit() and onClose() method directly from your controller.

``` dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

* NOTE: If you want to start a method at the moment the controller is called for the first time, you DON'T NEED to use constructors for this, in fact, using a performance-oriented package like Get, this borders on bad practice, because it deviates from the logic in which the controllers are created or allocated (if you create an instance of this controller, the constructor will be called immediately, you will be populating a controller before it is even used, you are allocating memory without it being in use, this definitely hurts the principles of this library). The onInit() methods; and onClose(); were created for this, they will be called when the Controller is created, or used for the first time, depending on whether you are using Get.lazyPut or not. If you want, for example, to make a call to your API to populate data, you can forget about the old-fashioned method of initState/dispose, just start your call to the api in onInit, and if you need to execute any command like closing streams, use the onClose() for that.

### Why it exists

The purpose of this package is precisely to give you a complete solution for navigation of routes, management of dependencies and states, using the least possible dependencies, with a high degree of decoupling. Get engages all high and low level Flutter APIs within itself, to ensure that you work with the least possible coupling. We centralize everything in a single package, to ensure that you don't have any kind of coupling in your project. That way, you can put only widgets in your view, and leave the part of your team that works with the business logic free, to work with the business logic without depending on any element of the View. This provides a much cleaner working environment, so that part of your team works only with widgets, without worrying about sending data to your controller, and part of your team works only with the business logic in its breadth, without depending on no element of the view.

So to simplify this:
You don't need to call methods in initState and send them by parameter to your controller, nor use your controller constructor for that, you have the onInit() method that is called at the right time for you to start your services.
You do not need to call the device, you have the onClose() method that will be called at the exact moment when your controller is no longer needed and will be removed from memory. That way, leave views for widgets only, refrain from any kind of business logic from it.

Do not call a dispose method inside GetxController, it will not do anything, remember that the controller is not a Widget, you should not "dispose" it, and it will be automatically and intelligently removed from memory by Get. If you used any stream on it and want to close it, just insert it into the close method. Example:

``` dart
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

* onInit() where it is created.
* onClose() where it is closed to make any changes in preparation for the delete method
* deleted: you do not have access to this API because it is literally removing the controller from memory. It is literally deleted, without leaving any trace.

### Other ways of using it

You can use Controller instance directly on GetBuilder value:

``` dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

You may also need an instance of your controller outside of your GetBuilder, and you can use these approaches to achieve this:

``` dart
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

``` dart
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

* You can use "non-canonical" approaches to do this. If you are using some other dependency manager, like get_it, modular, etc., and just want to deliver the controller instance, you can do this:

``` dart
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

``` dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

And update it this form:

``` dart
update(['text']);
```

You can also impose conditions for the update:

``` dart
update(['text'], counter < 10);
```

GetX does this automatically and only reconstructs the widget that uses the exact variable that was changed, if you change a variable to the same as the previous one and that does not imply a change of state , GetX will not rebuild the widget to save memory and CPU cycles (3 is being displayed on the screen, and you change the variable to 3 again. In most state managers, this will cause a new rebuild, but with GetX the widget will only is rebuilt again, if in fact his state has changed).

## Mixing the two state managers

Some people opened a feature request, as they wanted to use only one type of reactive variable, and the other mechanics, and needed to insert an Obx into a GetBuilder for this. Thinking about it MixinBuilder was created. It allows both reactive changes by changing ".obs" variables, and mechanical updates via update(). However, of the 4 widgets he is the one that consumes the most resources, since in addition to having a Subscription to receive change events from his children, he subscribes to the update method of his controller.

Extending GetxController is important, as they have life cycles, and can "start" and "end" events in their onInit() and onClose() methods. You can use any class for this, but I strongly recommend you use the GetxController class to place your variables, whether they are observable or not.

## StateMixin

Another way to handle your `UI` state is use the `StateMixin<T>` .
To implement it, use the `with` to add the `StateMixin<T>`
to your controller which allows a T model.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(data, status: RxStatus.success());
```

RxStatus allow these status:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

To represent it in the UI, use:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

## GetBuilder vs GetX vs Obx vs MixinBuilder

In a decade working with programming I was able to learn some valuable lessons.

My first contact with reactive programming was so "wow, this is incredible" and in fact reactive programming is incredible.
However, it is not suitable for all situations. Often all you need is to change the state of 2 or 3 widgets at the same time, or an ephemeral change of state, in which case reactive programming is not bad, but it is not appropriate.

Reactive programming has a higher RAM consumption that can be compensated for by the individual workflow, which will ensure that only one widget is rebuilt and when necessary, but creating a list with 80 objects, each with several streams is not a good one idea. Open the dart inspect and check how much a StreamBuilder consumes, and you'll understand what I'm trying to tell you.

With that in mind, I created the simple state manager. It is simple, and that is exactly what you should demand from it: updating state in blocks in a simple way, and in the most economical way.

GetBuilder is very economical in RAM, and there is hardly a more economical approach than him (at least I can't imagine one, if it exists, please let us know).

However, GetBuilder is still a mechanical state manager, you need to call update() just like you would need to call Provider's notifyListeners().

There are other situations where reactive programming is really interesting, and not working with it is the same as reinventing the wheel. With that in mind, GetX was created to provide everything that is most modern and advanced in a state manager. It updates only what is necessary and when necessary, if you have an error and send 300 state changes simultaneously, GetX will filter and update the screen only if the state actually changes.

GetX is still more economical than any other reactive state manager, but it consumes a little more RAM than GetBuilder. Thinking about it and aiming to maximize the consumption of resources that Obx was created. Unlike GetX and GetBuilder, you will not be able to initialize a controller inside an Obx, it is just a Widget with a StreamSubscription that receives change events from your children, that's all. It is more economical than GetX, but loses to GetBuilder, which was to be expected, since it is reactive, and GetBuilder has the most simplistic approach that exists, of storing a widget's hashcode and its StateSetter. With Obx you don't need to write your controller type, and you can hear the change from multiple different controllers, but it needs to be initialized before, either using the example approach at the beginning of this readme, or using the Bindings class.

* [State Management(Durum Yönetimi)](#State-Management-(durum-yönetimi))
  + [Reactive State Manager(Reaktif Durum Yöneticisi)](#Reactive-state-manager(Reaktif-durum-yöneticisi))
    - [Advantages(Avantajlar)](#advantages(avantajlar))
    - [Maksimum Performans:](#maksimum-performans)
    - [Reaktif bir değişken bildirmek](#reaktif-bir-değişken-bildirmek)
        - [Reaktif bir state'e(duruma) sahip olmak kolaydır.](#reaktif-bir-state'e-(duruma)-sahip-olmak-kolaydır)
    - [Görünümdeki değerleri kullanmak](#using-the-values-in-the-view)
    - [Yeniden oluşturulacak koşullar](#conditions-to-rebuild)
    - [Nerede .obs kullanılabilir](#where-obs-can-be-used)
    - [Listeler hakkında not](#note-about-lists)
    - [Neden .value kullanmak zorundayım?](#why-i-have-to-use-value)
    - [Obx()](#obx)
    - [Çalışanlar](#Çalışanlar)
  + [Simple State Manager (Basit Durum Yöneticisi)](#simple-state-manager)
    - [Avantajlar](#advantages-1)
    - [Kullanımı](#usage)
    - [Controller'lar nasıl çalışır](#how-it-handles-controllers)
    - [Artık StatefulWidget'lara ihtiyacınız olmayacak](#you-wont-need-statefulwidgets-anymore)
    - [Neden var](#why-it-exists)
    - [Kullanmanın diğer yolları](#other-ways-of-using-it)
    - [Unique IDs (Benzersiz Kimlikler)](#unique-ids)
  + [İki state managers ile Mixing](#mixing-the-two-state-managers)
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

## Reactive State Manager(Reaktif Durum Yöneticisi)

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

Başlık altında ne yaptık? `String` lerin bir `Stream` oluşturduk, `"Jonatas Borges"` initial value'sunu(başlangıç değerini) atadık, `"Jonatas Borges"` kullanan tüm widget'lara artık bu değişkene "ait olduklarını" bildirdik ve _Rx_ değeri değiştiğinde de değişmeleri gerekecek. 

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

// Hiçbir şey olmadı. Işte aynı değer.
void onButtonTap() => isOpen.value=false;
```

### Advantages(Avantajlar)

**GetX()**, güncellenen değişkenler üzerinde **ayrıntılı** kontrole ihtiyacınız olduğunda size yardımcı olur.
 
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

### Görünümdeki değerleri kullanmak

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
// controller içinde
final String title = 'User Info:'.obs
final list = List<User>().obs;

// view içinde
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

// view içinde:
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

### Kullanımı

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
  init: Controller(), // SADECE ILK SEFERINDE "INIT" YAPIN
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Controller'ı sadece ilk seferinde "initialize" edin. Aynı controller için ikinci defa ReBuilder kullandıysanız, bunu bir daha yapmayın. Controller, widget içinde "init" işlemi gerçekleştikten sonra otomatik olarak hafızadan kaldırılacaktır. Bunun için endişelenmenize gerek yoktur, Get bunu otomatik olarak yapacaktır. Sadece aynı controller'ı birden fazla kez başlatmadığınıza emin olun yeter. 
```

**Tamamlandı!**

* Get ile durumları nasıl yöneteceğinizi öğrendiniz.

* Not: Daha büyük bir organizasyon isteyebilirsiniz ve init özelliğini kullanmayabilirsiniz. Bunun için bir sınıf oluşturup Bindings sınıfını extends edebilir ve bunun içinde o rotada oluşturulacak controller'dan bahsedebilirsiniz. Controller'lar o anda oluşturulmaz, tam tersine, bu sadece bir ifadedir, böylece bir Controller'ı ilk kullandığınızda, nereye bakacağınızı bilecek. Get lazyLoad olarak kalacak ve artık ihtiyaç duyulmadığında Controller'ları elden çıkarmaya devam edecek. Nasıl çalıştığını görmek için pub.dev örneğine bakın.

Birçok rotada gezinirseniz ve daha önce kullandığınız controller'ınızda bulunan verilere ihtiyacınız varsa, GetBuilder tekrar (init olmadan) kullanmanız yeterlidir:

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

Controller'ınızı GetBuilder dışında birçok başka yerde kullanmanız gerekiyorsa, controller'ınıza bir get oluşturun ve kolayca elde edin. (veya `Get.find<Controller>()` kullanın)

``` dart
class Controller extends GetxController {

   /// Buna ihtiyacın yok. Sadece syntax kolaylığı için kullanmanızı öneririm.
   /// statik yöntemle: Controller.to.increment();
   /// statik yöntem olmadan: Get.find<Controller>().increment();
   /// Her iki syntax kullanmanın herhangi bir yan etkisi veya performans farkı yoktur. Yalnızca birinin türe ihtiyacı yoktur ve diğeri IDE tarafından otomatik olarak tamamlanır.
  static Controller get to => Get.find(); // bu satırı ekleyin

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

Ve sonra controller'a doğrudan bu şekilde erişebilirsiniz:

``` dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // Bu inanılmaz derecede basit!
  child: Text("${Controller.to.counter}"),
),
```

FloatingActionButton tuşuna bastığınızda, 'counter' değişkenini dinleyen tüm widget'lar otomatik olarak güncellenir.

### Controller'lar nasıl çalışır

Diyelim ki elimizde bu var:

 `Class a => Class B (has controller X) => Class C (has controller X)`

A sınıfında controller henüz bellekte değil çünkü henüz kullanmadınız (Get is lazyLoad). B sınıfında controller kullandınız ve belleğe girdi. C sınıfında, B sınıfındakiyle aynı controller'ı kullandınız, Get, controller B'nin durumunu C controller'ı ile paylaşacak ve aynı controller hala bellekte kalacaktır. C ekranını ve B ekranını kapatırsanız, Get, A Sınıfı controller'ı kullanmadığından otomatik olarak X controller'ını bellekten alır ve kaynakları boşaltır. Tekrar B'ye giderseniz, X controller'ı tekrar belleğe girer, C sınıfına gitmek yerine tekrar A sınıfına dönerseniz Get, controller aynı şekilde bellekten çıkarır. C sınıfı controller'ı kullanmadıysa ve B sınıfını bellekten çıkardıysanız, hiçbir sınıf controller'ı X kullanmayacak ve aynı şekilde imha edilecektir. Get ile bulaşabilecek tek istisna, B'yi rotadan beklenmedik bir şekilde kaldırırsanız ve controller'ı C'de kullanmaya çalışırsanız. Bu durumda, controller'ın B'deki ID silindi ve Get şu şekilde programlandı: ID olmayan her controller'ı bellekten kaldırın. Bunu yapmayı düşünüyorsanız, "autoRemove: false" işaretini B sınıfının GetBuilder'ına ekleyin ve adoptID = true; yapın C sınıfında GetBuilder kullanın.

### Artık StatefulWidget'lara ihtiyacınız olmayacak

Stateful Widget kullanmak, tüm ekranların durumunu gereksiz yere depolamak anlamına gelir, çünkü bir widget'ı minimum düzeyde yeniden oluşturmanız gerekse bile, onu başka bir Stateful Widget olacak olan bir Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx içine gömeceksiniz. StatefulWidget sınıfı, daha fazla RAM tahsis edecek olan StatelessWidget'ten daha büyük bir sınıftır ve bu, bir veya iki sınıf arasında önemli bir fark yaratmayabilir, ancak 100 tanesine sahip olduğunuzda kesinlikle yapacaktır! TickerProviderStateMixin gibi bir mixin kullanmanız gerekmiyorsa, Get ile bir StatefulWidget kullanmak tamamen gereksiz olacaktır.

StatefulWidget'ın tüm yöntemlerini doğrudan bir GetBuilder'dan çağırabilirsiniz.
Örneğin, initState() veya Dispose() yöntemini çağırmanız gerekiyorsa, bunları doğrudan çağırabilirsiniz;

``` dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Bundan çok daha iyi bir yaklaşım, doğrudan controller'dan onInit() ve onClose() yöntemini kullanmaktır.

``` dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

* NOT: Controller ilk kez çağrıldığı anda bir metot başlatmak istiyorsanız, bunun için constructors kullanmanıza GEREK YOKTUR, aslında Get gibi performans odaklı bir paket kullanarak bu sorunu çözebilirsiniz.  Controller'ların oluşturulduğu veya tahsis edildiği mantıktan saptığı için (bu controller'ın bir örneğini oluşturursanız, constructor hemen çağrılır, bir controller kullanılmadan önce bellek ayırırsınız ve belleği doldurursunuz. Bu kesinlikle bu kütüphanenin ilkelerine zarar verir. onInit() yöntemleri; ve onClose(); için oluşturulduysa, Get.lazyPut kullanıp kullanmadığınıza bağlı olarak Controller oluşturulduğunda veya ilk kez kullanıldığında çağrılırlar. Örneğin, verileri doldurmak için API'nize bir çağrı yapmak istiyorsanız, eski moda initState/dispose yöntemini unutabilirsiniz, sadece onInit'te api'ye çağrınızı başlatın ve herhangi bir komutu çalıştırmanız gerekirse akışları kapatmak gibi, bunun için onClose()'u kullanın.

### Neden var

Bu paketin amacı, mümkün olan en az bağımlılıkları kullanarak, yüksek derecede ayrıştırma ile rotaların gezinmesi, bağımlılıkların ve durumların yönetimi için eksiksiz bir çözüm sunmaktır. Get, mümkün olan en az bağlantıyla çalıştığınızdan emin olmak için tüm yüksek ve düşük seviyeli Flutter API'lerini kendi içinde çalıştırır. Projenizde herhangi bir bağlantı olmadığından emin olmak için her şeyi tek bir pakette merkezileştiriyoruz. Bu şekilde, görünümünüze yalnızca widget'lar koyabilir ve ekibinizin iş mantığıyla çalışan bölümünü, Görünümün herhangi bir öğesine bağlı kalmadan iş mantığıyla çalışmak üzere serbest bırakabilirsiniz. Bu, çok daha temiz bir çalışma ortamı sağlar, böylece ekibinizin bir kısmı controller'a veri göndermekten endişe etmeden yalnızca widget'larla çalışır ve ekibinizin bir kısmı, görünümün hiçbir öğesine bağlı kalmadan yalnızca genişliğindeki iş mantığıyla çalışır.

Yani bunu basitleştirirsek:
Initstate'deki yöntemleri çağırmanız ve bunları controller'ınıza parametre ile göndermeniz veya bunun için controller içerisinde constructor kullanmanız gerekmez, doğru zamanda çağrılan onInit () yöntemine sahip olursunuz.
Cihaz aramak zorunda değilsiniz, gerektiğinde tam zamanında close() yöntemi ile hafızasından silinecektir. Bu şekilde, yalnızca widget'lar için görünümler bırakın, her türlü iş mantığından kaçının.

GetxController içinde bir dispose yöntemi çağırmayın, hiçbir şey yapmaz, controller'ın bir Widget olmadığını, "dispose" gerektiğini ve Get tarafından bellekten otomatik ve akıllıca kaldırılacağını unutmayın. Üzerinde herhangi bir akış kullandıysanız ve kapatmak istiyorsanız, onu close yöntemine eklemeniz yeterlidir. Örnek:


``` dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// close stream = onClose yöntemi, dispose değil.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Controller life cycle(yaşam döngüsü):

* onInit() oluşturulduğu yer.
* onClose() close yöntemine hazırlanırken herhangi bir değişiklik yapmak için kapatıldığı yer.
* deleted: Controller bellekten tam anlamıyla kaldırdığı için bu API'ye erişiminiz olmaz. Herhangi bir iz bırakmadan kelimenin tam anlamıyla silinir.

### Kullanmanın diğer yolları


Controller'ı doğrudan GetBuilder ile kullanabilirsiniz:

``` dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

Controller'ınızı GetBuilder dışında bir örneğine de ihtiyacınız olabilir ve bunu başarmak için bu yaklaşımları kullanabilirsiniz:

``` dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// görünümde:
GetBuilder<Controller>(  
  init: Controller(), // Her controller'ı bir kez kullanın
  builder: (_) => Text(
    '${Controller.to.counter}', //burada
  )
),
```

or

``` dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // static olmadan
[...]
}
// stateful/stateless class içinde
GetBuilder<Controller>(  
  init: Controller(), // Her controller'ı bir kez kullanın
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //burada
  ),
),
```

* Bunu yapmak için "non-canonical" yaklaşımları kullanabilirsiniz. Get_it, modular vb. Gibi başka bir dependency manager kullanıyorsanız ve sadece controller instance etmek istiyorsanız, bunu yapabilirsiniz:

``` dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, //burada
  builder: (_) => Text(
    '${controller.counter}', // burada
  ),
),

```

### Unique IDs (Benzersiz Kimlikler)

Bir widget'ın controller'ını güncellemek istiyorsanız GetBuilder onlara benzersiz kimlikler atayabilirsiniz:

``` dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // Her controller'ı bir kez kullanın
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //burada
  ),
),
```

Ve bu formu güncelleyin:

``` dart
update(['text']);
```

Güncelleme için koşullar da uygulayabilirsiniz:

``` dart
update(['text'], counter < 10);
```

GetX bunu otomatik olarak yapar ve yalnızca değiştirilen değişkeni tam olarak kullanan widget'ı yeniden yapılandırır, bir değişkeni öncekiyle aynı olacak şekilde değiştirirseniz ve bu state değişikliği anlamına gelmezse GetX widget'ı bellek ve CPU döngülerinden tasarruf etmek için yeniden oluşturmaz (ekranda 3 görüntüleniyor ve değişkeni tekrar 3 olarak değiştirirsiniz. Çoğu state manager, bu yeni bir yeniden yapılanmaya neden olur, ancak Get ile widget yalnızca state değiştiyse yeniden oluşturulur).

## İki state managers ile Mixing

Bazı insanlar, yalnızca bir tür reaktif değişken ve diğer mekanikleri kullanmak istediklerinden ve bunun için bir GetBuilder'a bir Obx eklemeleri gerektiğinden bir özellik request'i açtı. Bunu düşünerek MixinBuilder oluşturuldu. Hem ".obs" değişkenlerini değiştirerek reaktif değişikliklere hem de update() aracılığıyla mekanik güncellemelere izin verildi. Bununla birlikte, 4 widget'tan en çok kaynak tüketendir, çünkü children'larda değişiklik olaylarını anlaması için sahip olmasının yanı sıra, controller'ın güncelleme yöntemine sahip olur.

GetxController'ı extends etmek önemlidir, çünkü yaşam döngüleri vardır ve olayları onInit() ve onClose() yöntemlerinde "başlatabilir" ve "bitebilir". Bunun için herhangi bir sınıfı kullanabilirsiniz, ancak değişkenlerinizi observable olsun ya da olmasın yerleştirmek için GetxController sınıfını kullanmanızı şiddetle tavsiye ederim.

## StateMixin

`UI` state'ini ele almanın başka bir yolu da `StateMixin<T>` kullanmaktır.
Bunu uygulamak için, `StateMixin<T>` ile `with`i kullanın.
bir controller'a T modelinizi ekleyin.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

`change()` yöntemi istediğimiz zaman State'i değiştirir.
Sadece verileri ve state'i bu şekilde iletin:

```dart
change(data, status: RxStatus.success());
```

RxStatus şu duruma izin verir:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

UI'da bu şekilde kullanın:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // burada özel yükleme göstergenizi koyabilirsiniz, ancak
       // varsayılan olarak Center(child:CircularProgressIndicator()) olacaktır.
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // burada ayrıca kendi hata widget'ınızı ayarlayabilirsiniz, ancak
        // default birCenter(child:Text(error)) olacaktır.
        onError: (error)=>Text(error),
      ),
    );
}
```

## GetBuilder vs GetX vs Obx vs MixinBuilder

Programlamayla geçen on yılda bazı değerli dersler öğrenebildim.

Reaktif programlama ile ilk temasım çok "vay be, bu inanılmaz" oldu ve aslında reaktif programlama inanılmaz.
Ancak, tüm durumlar için uygun değildir. Çoğu zaman tek ihtiyacınız olan, aynı anda 2 veya 3 parçacığın durumunu değiştirmek veya geçici bir durum değişikliğidir, bu durumda reaktif programlama kötü değildir, ancak uygun değildir.

Reaktif programlama, bireysel iş akışıyla telafi edilebilecek daha yüksek bir RAM tüketimine sahiptir; bu, yalnızca bir widget'ın yeniden oluşturulmasını ve gerektiğinde yapılmasını sağlar, ancak her biri birkaç akışa sahip 80 nesneden oluşan bir liste oluşturmak iyi bir fikir değildir. Dartı açın ve bir StreamBuilder'ın ne kadar tükettiğini kontrol edin ve size ne söylemeye çalıştığımı anlayacaksınız.

Bunu akılda tutarak, basit bir state manager yarattım. Bu basittir ve ondan tam olarak talep etmeniz gereken şey budur: State'i bloklar halinde basit bir şekilde ve en ekonomik şekilde güncellemek.

GetBuilder RAM'de çok ekonomiktir ve ondan daha ekonomik bir yaklaşım yoktur (en azından ben bir tane hayal edemiyorum, varsa lütfen bize bildirin).

Ancak GetBuilder hala mekanik bir state manager'dir, tıpkı Provider'ın notifyListeners() işlevini çağırmanız gerektiği gibi update() öğesini çağırmanız gerekir.

Reaktif programlamanın gerçekten ilginç olduğu başka durumlar da vardır ve onunla çalışmamak, tekerleği yeniden icat etmekle aynı şeydir. Bunu akılda tutarak GetX, bir State Manager'de en modern ve gelişmiş olan her şeyi sağlamak için oluşturuldu. Sadece gerekli olanı günceller ve gerektiğinde, bir hatanız varsa ve aynı anda 300 durum değişikliği gönderirseniz GetX, yalnızca durum gerçekten değiştiğinde ekranı filtreler ve günceller.

GetX, diğer herhangi bir reaktif durum yöneticisinden hala daha ekonomiktir, ancak GetBuilder'dan biraz daha fazla RAM tüketir. Bunu düşünerek ve Obx'in yarattığı kaynakların tüketimini en üst düzeye çıkarmayı hedefleyerek. GetX ve GetBuilder'dan farklı olarak, bir Obx içinde bir controller başlatamayacaksınız, bu sadece children'larda değişiklik olaylarını alan bir StreamSubscription'a sahip bir Widget'tır, hepsi bu. GetX'ten daha ekonomiktir, ancak reaktif olduğu için beklendiği gibi GetBuilder'a kaydeder ve GetBuilder, bir parçacığın hashcode'unu ve StateSetter'ını depolamak için var olan en basit yaklaşıma sahiptir. Obx ile controller türünüzü yazmanız gerekmez ve değişikliği birden çok farklı controller'dan ulaşabilir ve dinleyebilirsiniz, ancak bu readme dosyasının başındaki örnek yaklaşım kullanılarak veya Bindings classı kullanılarak daha önce başlatılması gerekir.

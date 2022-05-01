# Dependency Management
- [Dependency Management](#dependency-management)
  - [Örnek Metodlar](#örnek-metodlar)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Metodların/Sınıfların örneklerinin kullanılması](#metodların/sınıfların-örneklerinin-kullanılması)
  - [Alternatif bir instance tanımlama](#alternatif-bir-instance-tanımlama)
  - [Metodlar arasındaki farklılıklar](#metodlar-arasındaki-farklılıklar)
  - [Bindings](#bindings)
    - [Bindings class](#bindings-class)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Nasıl değiştirilir?](#nasıl-değiştirilir)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilder](#smartmanagementonlybuilder)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Nasıl bindings yapılır?](#nasıl-bindings-yapılır)
  - [Notlar](#notlar)

Get, yalnızca 1 satır kodla, Provider context'i olmadan, inheritedWidget olmadan Bloc veya Controller ile aynı sınıfı almanızı sağlayan basit ve güçlü bir dependency manager'a (bağımlılık yöneticisine) sahiptir:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

Sınıfınızı kullandığınız sınıf içinde somutlaştırmak yerine, onu uygulamanız genelinde kullanılabilir hale getirecek olan Get örneğinde somutlaştırıyorsunuz.
Böylece denetleyicinizi (veya Bloc sınıfını) normal şekilde kullanabilirsiniz.

- Not: Get's State Manager kullanıyorsanız, view'e controller'ı bağlamayı kolaylaştıracak olan [Bindings](#bindings) API'sine daha fazla dikkat edin.
- Not²: Get dependency management (bağımlılık yönetimi) paketin diğer bölümlerinden ayrılmıştır, bu nedenle örneğin uygulamanız zaten bir state manager (durum yöneticisi) kullanıyorsa (herhangi biri, önemli değil), bunu değiştirmeniz gerekmez,  dependency injection (bağımlılık enjeksiyonunu) kullanabilirsiniz.

## Örnek metodlar
Metodlar ve configurable parameters (yapılandırılabilir parametreleri) şunlardır:

### Get.put()

Dependency (bağımlılık) eklemenin en yaygın yolu. Örneğin;

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Put kullanırken ayarlayabileceğiniz tüm seçenekler şunlardır:
```dart
Get.put<S>(
  // Zorunlu: Controller veya herhangi bir şey gibi kaydetmek istediğiniz sınıf
  // not: "S", herhangi bir türde bir sınıf olabileceği anlamına gelir
  S dependency

  // isteğe bağlı: bu, aynı türden birden çok sınıf içindir
  // normalde Get.find<Controller>() kullanarak bir sınıf aldığınız için,
  // hangi örneğe ihtiyacınız olduğunu söylemek için "tag" kullanmanız gerekir
  // benzersiz dize olmalıdır
  String tag,

  // isteğe bağlı: varsayılan olarak, get artık kullanılmadıktan sonra örnekleri elden çıkarır (örneğin,
  // gizli bir view'in controller'ı), ancak instance'a ihtiyacınız olabilir
  // tüm uygulama boyunca orada tutulacak, Shared Preferences örneği veya başka bir şey gibi
  // yani bunu kullanıyorsun
  // varsayılan olarak false
  bool permanent = false,

  // isteğe bağlı: bir testte abstract(soyut) bir sınıf kullandıktan sonra, onu başka bir sınıfla değiştirmenize ve testi takip etmenize olanak tanır.
  // varsayılan olarak false
  bool overrideAbstract = false,

  // optional: allows you to create the dependency using function instead of the dependency itself.
  //isteğe bağlı: dependency'nin(bağımlılığın) kendisi yerine fonksiyonu kullanarak dependency(bağımlılık) oluşturmanıza olanak tanır.
  //bu yaygın olarak kullanılmaz
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
Bir bağımlılığı lazyLoad ile yalnızca kullanıldığında somutlaştırılacak şekilde yüklemek mümkündür. Hesaplamalı expensive sınıflar için veya birkaç sınıfı tek bir yerde başlatmak istiyorsanız (Bindings sınıfında olduğu gibi) çok kullanışlıdır ve o zaman o sınıfı kullanmayacağınızı bilirsiniz.

```dart
/// ApiMock yalnızca Get.find<ApiMock>'u ilk kez kullandığında çağrılacak
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... gerekirse biraz mantık
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

lazyPut'u kullanırken ayarlayabileceğiniz tüm seçenekler şunlardır:
```dart
Get.lazyPut<S>(
  // zorunlu: sınıfınız ilk kez çağrıldığında yürütülecek bir yöntem
  InstanceBuilderCallback builder,
  
  // isteğe bağlı: Get.put() ile aynı, aynı sınıfın birden çok farklı örneğini istediğinizde kullanılır
  // unique olmalı
  String tag,

  // isteğe bağlı: "Kalıcı" ile benzerdir, aradaki fark, instance şu durumlarda atılmasıdır.
  // kullanılmıyor, ancak tekrar kullanılması gerektiğinde Get, instance yeniden oluşturacak
  //bindings api'sindeki "SmartManagement.keepFactory" ile aynı
  // varsayılan olarak false
  bool fenix = false
  
)
```

### Get.putAsync
Eşzamansız bir instance kaydetmek istiyorsanız, `Get.putAsync` kullanabilirsiniz:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

putAsync kullanırken ayarlayabileceğiniz tüm seçenekler şunlardır:
```dart
Get.putAsync<S>(

  // zorunlu: sınıfınızın instance'ını oluşturmak için yürütülecek bir asenkron metod
  AsyncInstanceBuilderCallback<S> builder,

  //isteğe bağlı: Get.put() ile aynı, aynı sınıfın birden çok farklı örneğini istediğinizde kullanılır
  // unique olmalı
  String tag,

  // isteğe bağlı: Get.put() ile aynı, bu instance tüm uygulamada canlı tutmanız gerektiğinde kullanılır
  // varsayılan olarak false
  bool permanent = false
)
```

### Get.create

Bu zor. Bunun ne olduğuna ve diğeri arasındaki farklara ilişkin ayrıntılı bir açıklama, [Differences between methods:](#differences-between-methods) bölümünde bulunabilir.

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Oluştururken ayarlayabileceğiniz tüm seçenekler şunlardır:

```dart
Get.create<S>(
  // gerekli: her seferinde "fabrikasyon" olacak bir sınıf döndüren bir işlev
  // `Get.find()` çağrılır
  // Örnek: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // isteğe bağlı: tıpkı Get.put() gibi, ancak birden çok örneğe ihtiyacınız olduğunda kullanılır
  // aynı sınıftan bir
  // Her öğenin kendi denetleyicisine ihtiyaç duyduğu bir listeniz varsa kullanışlıdır
  // benzersiz bir dize olması gerekir.
  String name,

  // isteğe bağlı: tıpkı int`Get.put()` gibi,
  // tüm uygulama boyunca canlı örnek. Fark Get.create'de
  // kalıcı, varsayılan olarak doğrudur
  bool permanent = true
```

## Metodların/Sınıfların örneklerinin kullanılması

Çok sayıda rotada gezindiğinizi ve kontrol cihazınızda geride bırakılan bir veriye ihtiyacınız olduğunu hayal edin, Sağlayıcı veya Get_it ile birleştirilmiş bir durum yöneticisine ihtiyacınız olacak, değil mi? Get ile değil. Controller için "find" seçeneğini sormanız yeterlidir, herhangi bir ek bağımlılığa ihtiyacınız yoktur:

```dart
final controller = Get.find<Controller>();
// veya
Controller controller = Get.find();

// Evet, sihir gibi görünüyor, Controller'ı(Denetleyicinizi) bulacak ve size teslim edecek.
// Instance edilmiş 1 milyon controller'a sahip olabilirsiniz, Get size her zaman doğru controller'ı verecektir.
```

Ve sonra orada elde edilen controller ile verilerinizi kurtarabileceksiniz:

```dart
Text(controller.textFromApi);
```

Döndürülen değer normal bir sınıf olduğundan, istediğiniz her şeyi yapabilirsiniz:
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Get örneğini kaldırmak için:

```dart
Get.delete<Controller>(); //genellikle bunu yapmanız gerekmez çünkü GetX kullanılmayan controller'ları(denetleyicileri) zaten siler
```

## Alternatif bir instance tanımlama

Şu anda eklenen bir örnek, `replace` veya `lazyReplace` yöntemi kullanılarak benzer veya genişletilmiş bir sınıf örneğiyle değiştirilebilir. Bu daha sonra özgün sınıf kullanılarak alınabilir.

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

## Metodlar arasındaki farklılıklar 

İlk olarak Get.lazyPut'un `fenix`i ve diğer yöntemlerin `permanent`'larından bahsedelim.

`permanent` ve `fenix` arasındaki temel fark, örneklerinizi nasıl depolamak istediğinizdir.

Güçlendirme: Varsayılan olarak GetX, kullanımda değilken örnekleri siler.
Bunun anlamı: Ekran 1'de controller 1 varsa ve ekran 2'de controller 2 varsa ve ilk rotayı stackten kaldırırsanız (`Get.off()` veya `Get.offNamed()` kullanıyorsanız) controller(denetleyici) 1 kaybolur kullanımı silinecektir.

Ancak `permanent:true` kullanmayı tercih etmek istiyorsanız, bu geçişte controller kaybolmaz - bu, tüm uygulama boyunca canlı tutmak istediğiniz hizmetler için çok yararlıdır.

`fenix`ise ekran değişiklikleri arasında kaybetme endişesi duymadığınız ancak o hizmete ihtiyaç duyduğunuzda canlı olmasını beklediğiniz hizmetler içindir. Temel olarak, kullanılmayan controller/service/class elden çıkaracak, ancak ihtiyacınız olduğunda yeni bir örneği "küllerden yeniden yaratacaktır".

Metodlar arasındaki farklarla devam edelim:

- Get.put ve Get.putAsync, ikincisinin eşzamansız bir yöntem kullanması farkıyla aynı oluşturma sırasını takip eder: bu iki yöntem, örneği oluşturur ve başlatır. Bu, `permanent: false` ve `isSingleton: true` parametreleriyle `insert` dahili yöntemi kullanılarak doğrudan belleğe eklenir (bu isSingleton parametresinin tek amacı, "bağımlılık" bağımlılığını kullanıp kullanmayacağını söylemektir. veya `FcBuilderFunc` bağımlılığını kullanacaksa). Bundan sonra, bellekteki örnekleri hemen başlatan `Get.find()` çağrılır.


- Get.create: Adından da anlaşılacağı gibi, dependency'i (bağımlılığı) "create(oluşturacak)"! `Get.put()`a benzer şekilde, örneklemeye `insert` dahili yöntemini de çağırır. Ancak `permanent` doğru oldu ve`isSingleton` yanlış oldu (bağımlılığımızı "creating", bunun tek bir örnek olmasının bir yolu yok, bu yüzden yanlış). Ve `permanent: true` olduğu için, varsayılan olarak ekranlar arasında kaybetmeme avantajına sahibiz! Ayrıca `Get.find()` hemen çağrılmaz, çağrılacak ekranda kullanılmayı bekler. `permanent` parametresini kullanmak için bu şekilde yaratılmıştır, o zamandan beri, fark edilmeye değer `Get.create()`, örneğin bir bu liste için benzersiz bir örnek istiyorsanız - bu nedenle Get.create GetWidget ile birlikte kullanılmalıdır.

- Get.lazyPut: Adından da anlaşılacağı gibi tembel bir işlemdir. Örnek yaratılır, ancak hemen kullanılmak üzere çağrılmaz, çağrılmayı bekler. Diğer yöntemlerin aksine burada `insert` denilmez. Bunun yerine, instance hafızanın başka bir bölümüne, örneğin yeniden oluşturulup oluşturulamayacağını söylemekle sorumlu bir kısma eklenir, buna "factory" diyelim. Daha sonra kullanılmak üzere bir şey yaratmak istersek, şu anda kullanılanlarla karıştırılmayacak. Ve işte burada `fenix` sihirleri devreye giriyor: `fenix: false` bırakmayı seçerseniz ve `smartManagement`ınız `keepFactory` değilse, o zaman `Get.find` kullanılırken örnek bellekteki yeri değiştirecektir. "factory"den ortak örnek bellek alanına. Bundan hemen sonra, varsayılan olarak "factory"den kaldırılır. Şimdi, `fenix: true` seçeneğini seçerseniz, örnek bu özel bölümde var olmaya devam eder, hatta gelecekte tekrar çağrılmak üzere ortak alana gider.

## Bindings

Bu paketin en büyük farklılıklarından biri, belki de route'ların, state manager'in(durum yöneticisinin) ve dependency manager(bağımlılık yöneticisinin) tam entegrasyonu olasılığıdır.
Stackten bir rota kaldırıldığında, onunla ilgili tüm controller'lar, değişkenler ve nesne örnekleri bellekten kaldırılır. Streams(Akışlar) veya timers(zamanlayıcılar) kullanıyorsanız, bunlar otomatik olarak kapatılır ve bunların hiçbiri için endişelenmenize gerek yoktur.
2.10 sürümünde Bindings API'sini tamamen uygulayın.
Artık init metodunu kullanmanıza gerek yok. İstemiyorsanız controller yazmanız bile gerekmez. Bunun için uygun yerde controller ve servislerinizi başlatabilirsiniz.
Binding sınıfı, state manager(durum yöneticisine) ve dependency manager(bağımlılık yöneticisine) giden rotaları "binding" ederken, dependency injection(bağımlılık enjeksiyonunu) ayıracak bir sınıftır.
Bu, belirli bir controller(denetleyici) kullanıldığında hangi ekranın görüntülenmekte olduğunu ve bunun nerede ve nasıl imha edileceğini bilmenizi sağlar.
Ayrıca Binding sınıfı, SmartManager yapılandırma kontrolüne sahip olmanızı sağlar. Stackten bir rota kaldırılırken veya onu kullanan pencere öğesi düzenlendiğinde veya hiçbirini yapmadığında düzenlenecek bağımlılıkları yapılandırabilirsiniz. Sizin için çalışan intelligent dependency management(akıllı bağımlılık yönetimine) sahip olacaksınız, ancak buna rağmen istediğiniz gibi yapılandırabilirsiniz.

### Bindings class

- Bir sınıf oluşturun ve Binding'i uygulayın

```dart
class HomeBinding implements Bindings {}
```

IDE'niz otomatik olarak sizden "dependencies(bağımlılıklar)" metodunu geçersiz kılmanızı isteyecektir ve sadece lambaya tıklamanız, metodu geçersiz kılmanız ve o rotada kullanacağınız tüm sınıfları eklemeniz yeterlidir:

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

Şimdi sadece rotanızı, route manager(rota yöneticisi), dependencies(bağımlılıklar) ve states(durumlar) arasında bağlantı kurmak için bu binding'i kullanacağınızı bildirmeniz gerekiyor.

- Adlandırılmış yolları kullanma:

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

- Normal yolları kullanma:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Orada, artık uygulamanızın bellek yönetimi konusunda endişelenmenize gerek yok, Get bunu sizin için yapacak.

Bir rota çağrıldığında Binding sınıfı çağrılır, oluşturulacak tüm bağımlılıkları eklemek için GetMaterialApp'ınızda bir "initialBinding" oluşturabilirsiniz.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

Binding oluşturmanın varsayılan yolu, Binding'leri uygulayan bir sınıf oluşturmaktır.
Ancak alternatif olarak, istediğiniz her şeyi somutlaştırmak için bir işlevi kullanabilmeniz için `BindingsBuilder` callback kullanabilirsiniz.

Örnek:

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

Bu şekilde, her rota için bir Binding sınıfı oluşturmaktan kaçınarak bunu daha da basitleştirebilirsiniz.

Her iki şekilde de gayet iyi çalışıyor ve zevkinize en uygun olanı kullanmanızı istiyoruz.

### SmartManagement

GetX, bir hata oluşsa ve onu kullanan bir pencere öğesi düzgün şekilde atılmamış olsa bile, varsayılan olarak kullanılmayan controller(denetleyicileri) bellekten atar.
Bu, `full` dependency management(bağımlılık yönetimi) modu olarak adlandırılan şeydir.
Ancak GetX'in sınıfların imhasını kontrol etme şeklini değiştirmek istiyorsanız, farklı davranışlar ayarlayabileceğiniz `SmartManagement` sınıfınız var.

#### Nasıl değiştirilir?

Bu yapılandırmayı (genellikle ihtiyacınız olmayan) şekilde değiştirmek istiyorsanız:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilder //burada
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

Varsayılan olanıdır. Kullanılmayan ve kalıcı olarak ayarlanmamış sınıfları dispose edin. Çoğu durumda, bu yapılandırmayı el değmeden tutmak isteyeceksiniz. Eğer Get için yeniyseniz, bunu değiştirmeyin.

#### SmartManagement.onlyBuilder
Bu seçenekle, yalnızca `init:` ile başlatılan veya `Get.lazyPut()` ile bir Binding'e yüklenen controller(denetleyiciler) dispose edilecektir.

`Get.put()` veya `Get.putAsync()` veya başka bir yaklaşım kullanırsanız, SmartManagement bu bağımlılığı dışlamak için izinlere sahip olmayacaktır.

Varsayılan davranışla, SmartManagement.onlyBuilder'ın aksine "Get.put" ile örneklenen widget'lar bile kaldırılacaktır.

#### SmartManagement.keepFactory

SmartManagement.full gibi, artık kullanılmadığında bağımlılıklarını kaldıracaktır. Ancak, factory'leri koruyacak, yani bu örneğe tekrar ihtiyacınız olursa dependency(bağımlılığı) yeniden yaratacaktır.

### Nasıl bindings yapılır?
Bindings, başka bir ekrana gitmek için tıkladığınız anda oluşturulan geçici factory'ler oluşturur ve ekran değişirken animasyon gerçekleşir gerçekleşmez yok edilir.
Bu o kadar hızlı gerçekleşir ki analyzer onu kaydedemez bile.
Bu ekrana tekrar gittiğinizde, yeni bir geçici factory çağrılır, bu nedenle SmartManagement.keepFactory kullanmak yerine bu tercih edilir, ancak Bindings oluşturmak istemiyorsanız veya tüm bağımlılıklarınızı aynı Binding üzerinde tutmak istiyorsanız, mutlaka size yardımcı olacaktır.
Factory'ler çok az bellek kaplarlar, örnekleri tutmazlar, ancak istediğiniz sınıfın "shape" olan bir fonksiyona sahiptirler.
Bunun bellekte maliyeti çok düşüktür, ancak bu kitaplığın amacı, minimum kaynakları kullanarak mümkün olan maksimum performansı elde etmek olduğundan, Get factory bile varsayılan olarak kaldırır.
Hangisi sizin için daha uygunsa onu kullanın.

## Notlar

- Birden çok Bindings kullanıyorsanız SmartManagement.keepFactory KULLANMAYIN. Bindings olmadan veya GetMaterialApp'in initialBinding'inde bağlantılı tek bir Binding ile kullanılmak üzere tasarlanmıştır.

- Bindings kullanmak tamamen isteğe bağlıdır, isterseniz belirli bir controller(denetleyiciyi) kullanan sınıflarda `Get.put()` ve `Get.find()` kullanabilirsiniz.
Ancak, Services veya başka bir abstract class ile çalışıyorsanız, daha iyi bir organizasyon için Bindings'i kullanmanızı öneririm.

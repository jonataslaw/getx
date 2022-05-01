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

**Languages:**

  
[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![Vietnamese](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
[![Indonesian](https://img.shields.io/badge/Language-Indonesian-blueviolet?style=for-the-badge)](README.id-ID.md)
[![Urdu](https://img.shields.io/badge/Language-Urdu-blueviolet?style=for-the-badge)](README.ur-PK.md)
[![Chinese](https://img.shields.io/badge/Language-Chinese-blueviolet?style=for-the-badge)](README.zh-cn.md)
[![Portuguese](https://img.shields.io/badge/Language-Portuguese-blueviolet?style=for-the-badge)](README.pt-br.md)
[![Spanish](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README-es.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blueviolet?style=for-the-badge)](README.ru.md)
[![Polish](https://img.shields.io/badge/Language-Polish-blueviolet?style=for-the-badge)](README.pl.md)
[![Korean](https://img.shields.io/badge/Language-Korean-blueviolet?style=for-the-badge)](README.ko-kr.md)
[![French](https://img.shields.io/badge/Language-French-blueviolet?style=for-the-badge)](README-fr.md)
[![Japanese](https://img.shields.io/badge/Language-Japanese-blueviolet?style=for-the-badge)](README.ja-JP.md)
[![Turkish](https://img.shields.io/badge/Language-Turkish-blueviolet?style=for-the-badge)](README.tr-TR.md)

</div>

- [Get Hakkında](#get-hakkında)
- [Kurulum](#kurulum)
- [GetX ile Sayaç Uygulaması](#getx-ile-sayaç-uygulaması)
- [Üç Temel Kavram](#üç-temel-kavram)
  - [State Management (Durum Yönetimi)](#state-management-durum-yönetimi)
    - [Reactive State Manager (Reaktif Durum Yönetimi)](#reactive-state-manager-reaktif-durum-yönetimi)
    - [State Management Hakkında Daha Fazla Bilgi](#state-management-hakkında-daha-fazla-bilgi)
  - [Route Management (Rota Yönetimi)](#route-management-rota-yönetimi)
    - [Route Management Hakkında Daha Fazla Bilgi](#route-management-hakkında-daha-fazla-bilgi)
  - [Dependency Management (Bağımlılık Yönetimi)](#dependency-management-bağımlılık-yönetimi)
    - [Dependency Management Hakkında Daha Fazla Bilgi](#dependency-management-hakkında-daha-fazla-bilgi)
- [Utils](#utils)
  - [Internationalization (Uluslararasılaştırma)](#internationalization-uluslararasılaştırma)
    - [Translations (Çeviriler)](#translations-çeviriler)
      - [Translations Kullanımı](#translations-kullanımı)
    - [Locales (Yerel Ayarlar)](#locales-yerel-ayarlar)
      - [Locale Değiştirme](#locale-değiştirme)
      - [System locale (Yerel Sistem Ayarları)](#system-locale-yerel-sistem-ayarları)
  - [Tema Değiştirme](#tema-değiştirme)
  - [GetConnect](#getconnect)
    - [Varsayılan Ayarlar](#varsayılan-ayarlar)
    - [Özel Ayarlarlamalar](#özel-ayarlamalar)
  - [GetPage Middleware](#getpage-middleware)
    - [Priority (Öncelik)](#priority-öncelik)
    - [Redirect (Yönlendirme)](#redirect-yönlendirme)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [Advanced APIs (Gelişmiş API'ler)](#advanced-apis-gelişmiş-apiler)
    - [Opsiyonel Genel Ayarlar ve Manuel Ayarlamalar](#opsiyonel-genel-ayarlar-ve-manuel-ayarlamalar)
    - [Local State Widgets (Yerel Durum Widgetları)](#local-state-widgets-yerel-durum-widgetları)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [Faydalı İpuçları](#faydalı-ipuçları)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [Nasıl Kullanılır?](#nasıl-kullanılır)
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
- [2.0 İle Gelen Büyük Değişiklikler](#20-ile-gelen-büyük-değişiklikler)
- [Neden Getx?](#neden-getx)
- [Topluluk](#topluluk)
  - [Topluluk Kanalları](#topluluk-kanalları)
  - [Nasıl katkıda bulunulur?](#nasıl-katkıda-bulunulur)
  - [Makaleler ve Videolar](#makaleler-ve-videolar)

# Get Hakkında

- GetX, Flutter için oldukça basit ve güçlü bir çözüm yoludur. Yüksek performanslı state managment (durum yönetimi), yetenekli dependency injection (bağımlılık enjeksiyonu) ve route management'ı (rota yönetimi) hızlı ve pratik şekilde bir araya getirir.

- GetX'in 3 temel ilkesi vardır. Bu ilkeler kütüphanedeki tüm kaynaklar için önemlidir: **ÜRETKENLİK, PERFORMANS VE ORGANİZASYON.**

  - **PERFORMANS:** GetX, performansa ve kaynakların minimum düzeyde tüketimine odaklanmıştır. GetX, Streams ya da ChangeNotifier kullanmaz.

  - **ÜRETKENLİK:** GetX kolay ve keyifli bir syntax (yazım kuralları) kullanır. Ne yapmak istersen iste GetX'de her zaman kolay bir çözüm yolu vardır. Saatlerce süren geliştirmeden tasarruf etmeyi ve uygulanın size sağladığı  performansı maksimum seviyede kullanmayı mümkün kılar.

    Normalde geliştirici, controller'ları hafızadan kaldırmakla ilgilenmelidir. GetX ile bunu yapmaya gerek kalmaz çünkü varsayılan olarak kaynaklar kullanılmadığı zaman hafızadan kendiliğinden kaldırılır. Eğer hafızada tutmak istiyorsanız, dependency içinde "permanent: true" olarak tanımlanmanız gerekmektedir. Bu şekilde hem zaman tasarrufu hem de hafızadaki gereksiz dependency'lerin oluşturabileceği riskler azaltmış olur. Dependency yüklemesi varsayılan olarak lazy'dir (tembeldir).

  - **ORGANİZASYON:**  GetX, presentation logic'i (sunum mantığını, business logic'i (iş mantığını), dependency injection'ı, navigasyonu View'dan tamamen ayırmayı sağlar. Route'lar arasında navigasyon için context'e gerek duyulmaz bu sayede widget tree'ye (widget ağacına) bağımlı kalmazsınız. Controllers ya da blocs'daki inheritedWidget'a erişmek için context'e ihtiyaç duyulmaz böylelikle presentation logic ve business logic, view katmanından tamamen ayrılır. Controllers/Models/Blocs sınıflarını widget tree'ye inject (aktarırken) ederken `MultiProvider`'lar kullanılmasına ihtiyaç yoktur. GetX'in kendine ait dependency injection özelliği sayesinde DI'yi de view'dan tamamen ayrır.

    GetX ile varsayılan olarak temiz kod kullanılarak uygulamadaki her bir özelliğin nerede bulunduğuna ulaşabilirsiniz. Bakım kolaylığının yanı sıra Flutter'da düşünüleyemeyen bir şey olan modülleri paylaşmayı tamamen mümkün kılar.
    BLoC, Flutter'daki kodları organize etmenin başlangıç noktasıdır. Business logic'i, view'dan ayırır. Bunun gelişmiş hali olarak ortaya çıkan GetX sadece business logic'i ayırmakla kalmayıp aynı zamanda dependency injection'ları, route'ları ve presentation logic'i de view'dan ayırır. Data layer (Veri katmanı) bu sayede bütün katmanların dışında bırakılır. Her şeyin nerde olduğunu bilmek "hello word" oluşturmaktan çok daha kolay bir yoldur.
    GetX, Flutter SDK'sı ile çok kolay, pratik ve ölçeklenebilir yüksek performanslı uygulamalar yapmanızı sağlar. Birlikte çalışılabilen büyük bir ekosistem içerir. Yeni başlayanlar için oldukça kolay ve uzmanlar için de doğru olandır. Güvenli, stabil, güncel ve Flutter SDK'da varsayılan olarak olmayan büyük kapsamlı APIs kullanabilmeyi sağlar.

- GetX şişkin değildir. Çoklu davranış içeren özellikleri kullanarak, herhangi bir endişe olmaksızın programlamaya başlamanızı sağlar. Ancak bu özellikler farklı taraflarda olup sadece kullanıldıktan sonra başlatılır. Sadece state management kullanıyorsanız, sadece bu derlenir. Sadece routes kullanırsanız, state management'dan hiçbir şey derlenmez.

- GetX büyük bir ekosistemdir. Geniş bir topluluk, çok sayıda destekçi içerir ve Flutter var olduğu sürece bu korunacaktır. GetX, tek bir kod ile Android, iOS, Web, Mac, Linux, Windows veya kendi server'ınız (sunucunuz) üzerinde çalışmaya elverişlidir.
  **[Get Server](https://github.com/jonataslaw/get_server) ile frontend üzerinde yaptığınız kodu backend üzerinde tamamen yeniden kullanmanız mümkün**.

**Ek olarak, tüm geliştirme süreci hem server'da hem de frontend'de [Get CLI](https://github.com/jonataslaw/get_cli) ile tamamen otomatikleştirilebilir**.

**Ayrıca üretkenliğinizi arttırmak için 
[VSCode eklentileri](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) ve the [Android Studio/Intellij eklentileri](https://plugins.jetbrains.com/plugin/14975-getx-snippets) vardır.**

# Kurulum

pubspec.yaml dosyasına Get’i ekleyin:

```yaml
dependencies:
  get:
```

Get’i kullanılacak sayfaya import ediyoruz:

```dart
import 'package:get/get.dart';
```

# GetX ile Sayaç Uygulaması

“Sayaç” projesi yeni bir Flutter projesi oluştururken varsayılan olarak gelir. Yorum satırları ile birlikte toplam 100 satır içerir. Get’in gücünü göstermek gerekirse, size bir “sayaç” uygulamasının her bir tıklamada durumunu değiştirip, sayfalar arasında hareket edip ve bunu yaparken state'leri (durumları) aktarıp aynı zamanda organize bir yol izleyerek business logic'i view'dan ayıracağız ve bu YORUM SATIRLARI DAHİL SADECE 26 SATIR İÇERECEK.

- 1.Adım:
  “Get”’i MaterialApp’den önce  GetMaterialApp'e dönüştürerek ekliyoruz.

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Not: Bu kullanım Flutter’ın sağladığı MaterialApp’i modifiye etmez. Sadece child'ı (çocuğu) MaterialApp olan ve bir öncesinde konfigüre edilmiş bir widget’tır. Kendiniz de manuel olarak konfigüre edebilirsiniz fakat buna gerek yoktur. GetMaterialApp, route’ları oluşturacak ve içine bunları, translation’ları ve route navigation için ihtiyacınız olabilecek olan her şeyi inject edecektir. Eğer Get’i sadece state management ya da dependency management olarak kullanmak isterseniz, GetMaterialApp kullanmanıza gerek yoktur. Bu yapı routes, snackbars, internationalization, bottomSheets, dialogs, ve route'lara bağlı high-level apis kullanımlarında ek olarak da context'in yokluğundaki durumlarda kullanılmalıdır.
- Not²: Bu adım sadece route management kullanıldığında gereklidir (`Get.to()`, `Get.back()` ve bunlar gibi). Kullanmayacaksanız 1. adımı yapmanıza gerek yoktur.

- 2.Adım:
  İş mantıklarını içeren sınıfı oluşturup içine tüm değişkenleri metodları ve controller'ları ekleyin.İstediğiniz herhangi bir değişkeni ".obs" ile gözlemlenebilir yapabilirsiniz.

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- 3.Adım:
  View'ı oluşturun ve içine StatelessWidget (bu RAM'den tasarruf sağlar) yerleştirin. Get sayesinde StatefulWidget kullanmanıza gerek yoktur.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Sınıfınızın nesnesini getirmek için Get.put() kullanılır. Bu içindeki tüm "child" route'ları görüntülenebilir yapar.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Sayaç her değiştiğinde Text() içindeki değerin güncellenmesi için Obx(()=> kullanılır
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Navigator.push içeren 8 satırı basit bir şekilde Get.to() ile değiştirin. Bunda context'e ihtiyacınız kalmamaktadır.
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // Önceki sayfada zaten kulllandığımız  Controller'ı, Get'de "find" diyerek getirmesinini istiyoruz.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Güncellenen sayaç değişkenine erişiyoruz.
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Sonuç:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Bu basit bir proje ama Get'in ne kadar güçlü olduğunu zaten açıkça ortaya koyuyor. Projeniz büyüdükçe bu gücü daha iyi anlacaksınız.

Get, ekiplerle çalışmak üzere tasarlanmıştır. Ayrıca bireysel geliştiricinin de işini oldukça kolaylaştırır.

Performanstan ödün vermeden her şeyi zamanında teslim etmenize yardımcı olur. Get tam olarak sana layık!

# Üç Temel Kavram

## State management (Durum Yönetimi)

Get iki farklı state manager içerir: simple state manager (GetBuilder da denilir) ve reactive state manager (GetX/Obx)

### Reactive State Manager (Reaktif Durum Yönetimi)

Reaktif programlama, birçok kişi tarafından karmaşık olduğu söylendiği için kafa karışıklığına yol açabilir. Ancak GetX, reaktif programlamayı oldukça basit bir hale dönüştürür:

- StreamController'ları oluşturmanıza ihtiyacınız yoktur.
- Her bir değişken için StreamBuilder oluşturmanıza gerekmez.
-  Her state için sınıf oluşturmanıza gerek yoktur.
- Başlangıç değerleri için get metodu oluşturmaya ihtiyaç olmaz.
- Code generators kullanmanız gerekmez.

Get, reaktif programlamayı setState kullanmak kadar kolay yapmaktadır.

Bir isim değişkeniniz olduğunu ve onu her değiştirdiğinizde, onu kullanan tüm widget'ların otomatik olarak güncellendiğini düşünün.

Bu sizin sayaç değişkeniniz:

```dart
var name = 'Jonatas Borges';
```

Gözlemlenebilir yapmak için ".obs" ekliyorsunuz ve bu şekli alıyor:

```dart
var name = 'Jonatas Borges'.obs;
```

UI'da (kullanıcı arayüzünde) bu değeri göstermek ve değerler değiştiğinde ekranı güncellemek istediğinizde, hemen şunu yapın:

```dart
Obx(() => Text("${controller.name}"));
```

Hepsi bu. İşte _bu kadar_ basit.

### State Management Hakkında Daha Fazla Bilgi

**State Management'ın daha ayrıntılı bir açıklamasına [buradan](./documentation/en_US/state_management.md) erişebilirsiniz. Orada daha fazla örnek ile simple state manager ve reactive state manager arasındaki farkı görebilirsiniz**

GetX'in gücü hakkında daha iyi bir fikir edineceksiniz.

## Route Management (Rota Yönetimi)

Eğer routes/snackbars/dialogs/bottomsheets yapılarını context'e ihtiyaç duymadan kullanmak istedğinizde, GetX bunun için biçilmiş kaftan.

MaterialApp'i GetMaterialApp ile değiştiriyoruz.

```dart
GetMaterialApp( // Önceki hal: MaterialApp(
  home: MyHome(),
)
```

Yeni ekrana geçmek için:

```dart

Get.to(NextScreen());
```

Name (isim) ile yeni sayfaya geçiş yapılabilir. Named routes (İsimli rotalar) hakkında daha çok bilgiye [buradan](./documentation/tr_TR/route_management.md#navigation-with-named-routes) ulaşabilirsiniz.

```dart

Get.toNamed('/details');
```

Snackbars, dialogs, bottomsheets ve normalde Navigator.pop(context) ile kapatacağınız herhangi bir şeyi kapatmak için;

```dart
Get.back();
```

Önceki ekrana geri dönme seçeneğinin olmadan bir sonraki ekrana gitmek için (örnek olarak SplashScreens, login screens, vs.)

```dart
Get.off(NextScreen());
```

Sonraki ekrana gitmek ve önceki tüm route'ları kapatmak için shopping carts, polls, ve test'lerde kullanılır)

```dart
Get.offAll(NextScreen());
```

Bunlardan herhangi birini yapmak için context kullanmanız gerekmediğini fark ettiniz mi? Get route management'ı kullanmanın en büyük avantajlarından biri de budur. Böylelikle controller sınıfınızda olan tüm metodları endişe olmadan çalıştırabilirsiniz.

### Route Management Hakkında Daha Fazla Bilgi

**Get, named routes ile çalışırken route'lar arası geçişleri kolayca kontrol etmenizi sağlar. Daha ayrıntılı doküman için [buraya](./documentation/tr_TR/route_management.md) tıklayabilirsiniz.**

## Dependency Management (Bağımlılık Yönetimi)

Get basit ve güçlü bir dependency manager içerir. Sadece tek satır kod ile Bloc ya da Controller'ınızın aynı sınıf nesnesini getirmenizi sağlar. Ayrıca Provider context, ya da inheritedWidget kullanmanıza gerek kalmaz:

```dart
Controller controller = Get.put(Controller()); // Controller controller = Controller(); yazmak yerine
```

- Not: Get'in State Manager'ını kullanıyorsanız, API bağlamaya daha çok dikkat edin ki onlar view'ı controller'a kolayca bağlamanızı sağlayacaktır.

Kullanacağınız sınıfın içinde başka bir sınıfın nesnesini oluşturmak yerine, Get instance sayesinde uygulamanızın her yerinde aynı sınıf nesnesini kullanabilir hale getirebilirsiniz.
Böylelikle controller (ya da Bloc sınıfını) normal bir şekilde kullanabilirsiniz.

**İpucu:** Get dependency management, kütüphanenin diğer parçalarından ayrıdır. Örnek olarak eğer uygulamanızda hali hazırda state manager kullanıyorsanız (hangisi olduğu fark etmez), en baştan yazmaya gerek yoktur. Bu dependency injection'ı problem olmadan kullanabilirsiniz.

```dart
controller.fetchApi();
```

Farzedin ki çok fazla sayıda route'larınız ve controller'larınızda erişmeniz gereken data'lar olsun, state manager'ı Provider ya da Get_it gibi kütüphaneler ile bağlamanız gerekmekedir. Get kullanarak bunları bağlamaya ihtiyacınız kalmaz. Get'e sadece "find" diyerek controller'ınızı bulmasını istemeniz yeterlidir. Fazladan dependency'lere ihtiyacınız yoktur:

```dart
Controller controller = Get.find();
// Evet, inanılmaz değil mi? Get, controller'ınızı bulup getirecek. Get, milyonlarca controller tanımlanmış da olsa size her zaman doğrusunu getirecektir.
```

Sonrasında üstte alınan controller'daki verilerinizi kullanabileceksiniz:

```dart
Text(controller.textFromApi);
```

### Dependency Management Hakkında Daha Fazla Bilgi

**Dependency management'a daha derinden bakmak için [buraya](./documentation/tr_TR/dependency_management.md) tıklayabilirsiniz**

# Utils

## Internationalization (Uluslararasılaştırma)

### Translations (Çeviriler)

Translations, map halinde basit key-value değerleri tutar.
Özel translation'larınızı eklemek için bir sınıf oluşturup `Translations`sınıfını extend edebilirsiniz.

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

#### Translations kullanımı

Önecen belirlenmiş key'e sadece `.tr` eklenince `Get.locale` ve `Get.fallbackLocale` şimdiki değerleri kullanarak otomatik çeviriyi yapacaktır.


```dart
Text('title'.tr);
```

#### Tekil ve çoğul çevirisi yapımı

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Parametreler ile çeviri yapımı

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

### Locales (Yerel Ayarlar)

Locale ve translation'lar`GetMaterialApp`'in parametreleri içinde atanabilir.

```dart
return GetMaterialApp(
    translations: Messages(), //Çevirileriniz
    locale: Locale('en', 'US'), //Çeviriler bu locale dilinde gösterilecek
    fallbackLocale: Locale('en', 'UK'), // Eğer yanlış bir locale olması durumunda gösterilecek fallback locale
);
```

#### Locale değiştirme

`Get.updateLocale(locale)` çağrılarak locale güncellenebilir. Çeviriler otomatik olarak yeni locale dilinde olacaktır.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### System locale (Yerel Sistem Ayarları)

Sistem locale'i okumak için `Get.deviceLocale` kullanılır.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Tema Değiştirme

Güncellemek için`GetMaterialApp`'in üstüne bir widget koymayın. Bu, kopya key'ler oluşmasını tetikler. Birçok kişi tema değiştirmek için tarih öncesi bir yöntem olan "ThemeProvider" widget'ı oluşturmayı tercih eder. **GetX™** ile buna HİÇ gerek duyulmaz.

`Get.changeTheme`ile kendi oluşturduğunuz temanızı hızlı bir şekilde ekleyebilirsiniz:

```dart
Get.changeTheme(ThemeData.light());
```

`onTap`'de Temayı değiştiren bir buton oluşturmak istiyorsanız, bunun için iki **GetX™** API'sini birleştirebilirsiniz:

- API, karanlık `Theme`'in kullanıp kullanılmadığını kontrol eder.
- `Theme` Change API'yi `onPressed`içine koyabilirsiniz:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

`.darkmode` aktif hale geldiğinde, tıklandığında _light theme_ 'e döner, _light theme_ aktif olduğunda,  _dark theme_'e geçer.

## GetConnect

GetConnect backend ile frontend'in http ya da websockets ile kolayca iletişime geçmesini sağlar.

### Varsayılan Ayarlar

Sadece GetConnect'den extend ederek gelen GET/POST/PUT/DELETE/SOCKET metodlarını kullanarak Rest API ya da websockets ile kolayca iletişim kurabilirsiniz.

```dart
class UserProvider extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // File  ile Post request
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

### Özel Ayarlamalar

GetConnect oldukça düzenlenebilir. Kendi base Url'nizi tanımlayabilir, cevapları ve Request'leri düzenleyebilirsiniz. Authenticator oluşturup kendiliğinden authenticate olmasını sağlayabilirsiniz. Size verilen standart decoder ile tüm request'leri ek bir ayar olmadan modellerinize aktarabilirsiniz.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // Tüm request'ler jsonEncode'a gider: CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; //baseUrl'yi bu şekilde tanımlar
    // Http ve websockets kullanılmış ise [httpClient] instance'ına ihtiyaç yoktur.


    // Gelen tüm request'ler "apikey"'in header özelliğine gier.
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Eğer sunucu "Brazilya"'dan bir veri gönderse bile
    // response'dan veriyi kaldırdığın için kullanıcılar göremez.
    // response önceden getirişmiş olsa bile 
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // header veriliyor
      request.headers['Authorization'] = "$token";
      return request;
    });

    // HttpStatus, HttpStatus.unauthorized ise 
    // Autenticator 3 defa çağırılır.
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

GetPage'in GetMiddleWare listesi oluşturan ve bunları özel bir sırada çalıştıran bir özelliği vardır.

**Not**: GetPage, Middlewares içeriyor ise bu sayfanın tüm çocukları da aynı middlewares'i otomatik olarak içerir.

### Priority (Öncelik)

Middlewares'in sıralı çalışması için GetMiddleware'lerin priority'leri (öncelikleri) düzenlenmelidir.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

Middleware'ler bu sırada çalışacaktır:   **-8 => 2 => 4 => 5**

### Redirect (Yönlendirme)

 Çağrılan route'un sayfası arandığında, fonsyon çağırılmış olacaktır. Redirect için RouteSettings kullanılır. Name değeri null verilebilir ve bu olduğu zaman herhangi bir redirect olmayacaktır.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

Bu fonsyon, herhangi bir şey oluşmadan önce sayfa çağırılmak istenildiğinde kullanılır. Sayfada bir şey değiştirmek için ya da yeni bir sayfa vermek için kullanabilirsiniz.

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Bu fonsyon Bindings başlatılmadan hemen önce çalışır.
Bu sayfa için Bindings'i şu şekilde değiştirebilirsiniz.

```dart
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}
```

### OnPageBuildStart

Bu fonsyon Bindings başlatıldıktan hemen sonra çalışır.
Bindings oluşturulduktan hemen sonra ve widget sayfası oluşturulmadan önce kullanabilirsiniz.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Bu fonskyon GetPage.page fonskyonu çağrıldıktan hemen sonra çalışır ve fonksyonun sonucunu verir. Sonrasında gösterilecek widget'ı alır.

### OnPageDispose

Bu fonsyon sayfadaki ilgili tüm objelerin (Controllers, views, ...) dispose olmasından hemen sonra çalışır.

## Advanced APIs (Gelişmiş API'ler)

```dart
// currentScreen'deki arg'ı verir
Get.arguments

// Önceki route'un name'ini verir.
Get.previousRoute

// Erişmek için raw route'u verir. Örnek olarak: rawRoute.isFirst()
Get.rawRoute

// GetObserver'dan Routing API'ye erişim verir.
Get.routing

// Snackbar açık mı kontrolü yaplır.
Get.isSnackbarOpen

// Dialog açık mı kontrolü yaplır.
Get.isDialogOpen

// Bottomsheet açık mı kontrolü yaplır.
Get.isBottomSheetOpen

// Tek route kaldırılır.
Get.removeRoute()

// predicate, true döndürene kadar terarlanarak geri gelir.
Get.until()

// Yeni route a gider ve eski tüm route'ları, predicate, true döndürene kadar kaldırır.
Get.offUntil()

// named route'a gider ve eski tüm route'ları, predicate, true döndürene kadar kaldırır.
Get.offNamedUntil()

//Hangi platformda çalıştığı kontrol edilir.
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Cihaz türü kontrol edilir.
GetPlatform.isMobile
GetPlatform.isDesktop
//Web'de tüm platformlar bağımsız olarak desteklenir!
//Bir tarayıcının içinde çalışıp çalışmadığınızı anlayabilirsiniz
//Windows, iOS, OSX, Android, vs. gibi
GetPlatform.isWeb


// Aşağıdakine eşittir : MediaQuery.of(context).size.height,
// fakat immutable'dır (sabittir).
Get.height
Get.width

// Navigator'e şimdiki context'i verir.
Get.context

// Önde olan snackbar/dialog/bottomsheet'a nerede olursanız olun context'i verir. 
Get.contextOverlay

// Not: aşağıdaki metodlar context üzerine olan extension'lardır.
// UI'ın herhangi bir yerinde context'e erişebilirsiniz ve istediğiniz yerde kullanabilirsiniz.

// Eğer değişken bir height/width verileri varsa (örnek olarak Masaüstü ya da tarayıcı gibi ölçeği değişebilen pencereler) context'i kullanmaya ihtiyacınız vardır.
context.width
context.height

// Size ekranın yarısını, üçte birini vb. tanımlamayı sağlar.
// Responsive uygulamalar için kullanışlıdır.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// MediaQuery.of(context).size'a benzer
context.mediaQuerySize()

/// MediaQuery.of(context).padding'e benzer
context.mediaQueryPadding()

/// MediaQuery.of(context).viewPadding'e benzer
context.mediaQueryViewPadding()

/// MediaQuery.of(context).viewInsets;'e benzer
context.mediaQueryViewInsets()

/// MediaQuery.of(context).orientation;'a benzer
context.orientation()

/// Cihazın yatay modda olup olmadığını kontrol eder.
context.isLandscape()

/// Cihazın dikey modda olup olmadığını kontrol eder.
context.isPortrait()

/// MediaQuery.of(context).devicePixelRatio;'ya benzer
context.devicePixelRatio()

/// MediaQuery.of(context).textScaleFactor;'e benzer
context.textScaleFactor()

/// Ekranın en kısa kenarını getirir
context.mediaQueryShortestSide()

/// width 800'den büyük ise true döndürür.
context.showNavbar()

/// Kısa kenar 600p'den küçük ise true döndürür.
context.isPhone()

/// Kısa kenar 600p'den büyük ise true döndürür.
context.isSmallTablet()

/// Kısa kenar 720p'den büyük ise true döndürür.
context.isLargeTablet()

/// Cihaz tablet ise true döndürür.
context.isTablet()

/// Ekran boyutuna göre <T> değerini döndürür
/// için değer verebilir:
/// watch: Kısa kenar 300'den küçük ise
/// mobile: Kısa kenar 600'den küçük ise
/// tablet: Kısa kenar 1200'den küçük ise
/// desktop: width 1200'den büyük ise

context.responsiveValue<T>()
```

### Opsiyonel Genel Ayarlar ve Manuel Ayarlamalar

GetMaterialApp çoğu şeyi sizin için otomatik olarak ayarlar, ayrıca kendiniz de isterseniz Get'i manuel olarak ayarlayabilirsiniz.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

`GetObserver` içinde kendi Middleware'ınızı kullanabilirsiniz ve bu hiçbir şeyi etkilemez.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Burası
  ],
);
```

`Get` için _Global Settings_ oluşturabilirsiniz. Herhangi bir route'a push yapmadan önce kodunuza `Get.config` eklemeniz yeterli. 
Ya da doğrudan  `GetMaterialApp` içinde tanımlayabilirsiniz.

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

İsteğe bağlı olarak tüm logging mesajlarını `Get` üzerinden yönlendirebilirsiniz. 
Kendi istediğiniz logging paketinizi kullanmak 
ve oradaki log'ları yakalamak istiyorsanız:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // istediğiniz logging paketine mesajı aktarır
  // eğer, enableLog: false ise log mesajları bu callback içine gönderilir
  // GetConfig.isLogEnable aracılığıyla isterseniz kontrol edebilirsiniz
}

```

### Local State Widgets (Yerel Durum Widgetları)

Bu widget'lar tek bir değeri kontrol etmenize ve durumu geçici ya da yerel olarak tutmanızı sağlar.
Reactive ve simple olan yapılar içerir.
Örneğin bunları `TextField` içindeki obscureText parametresine bağlayabilirsiniz. İsterseniz kendinizinkini (Expandable Panel vs.) de oluşturabilirsiniz ya da `Scaffold`'daki body'nin içeriği değişirken `BottomNavigationBar` içindeki current index'i değiştirebilirsiniz.

#### ValueBuilder

Veri güncellemenin bir yolu olan  `StatefulWidget`'daki  `.setState` yapısının basitleştirilmiş halidir.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // tamamen aynısı! ( newValue ) => updateFn( newValue ) yapısını da kullanabilirsiniz
  ),
  // eğer builder metodu dışından bir çağırma işlemi yapılacak ise
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

[`ValueBuilder`](#valuebuilder)'a oldukça benzer olmasının yanında bu Reactive halidir. Rx nesnesine aktarabilir ( .obs yapısını hatıladınız mı?) ve otomatik olarak güncellenmensini sağlayabilirsiniz, resmen muhteşem değil mi ?  

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx, çağrılabilen fonsyon içerir. (flag) => data.value = flag şeklinde kullanılablir.
    ),
    false.obs,
),
```

## Faydalı Ipuçları

`.obs` yapıları olan gözlemlenebilirler ( _Rx_ tipleri olarak da bilinirler) oldukça çeşitli internal metodlara ve operatörlere sahiptirler.

>  `.obs` yapısının gerçek değer olduğunu düşünenler oldukça yaygındır fakat bu yanlış bir düşüncedir.
> Değişkenleri, Type declaration yapmaktan kaçınmalıyız. Çünkü Dart'ın derleyicisi zaten bunu anlayacak kadar zekidir.
> Kodunuzu daha temiz gösterir fakat:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

`message`, gerçek String Type değerini yazdırsa bile aslında bu bir **RxString** Type değeridir!

Yani `message.substring( 0, 4 )` şeklinde kullanmazsınız.
 _observable_ içindeki gerçek `value`'ya (değere) erişmelisiniz.
En çok "kullanılan yol"  `.value` yapısı ile erişmektir fakat şu şekilde kullanabileceğiniz bir yol daha var...


```dart
final name = 'GetX'.obs;
// eğer değer şimdikinden farklı ise, sadece stream'i "günceller"
name.value = 'Hey';

// Tüm Rx özellikleri "çağrılabilir" ve geriye yeni bir değer döndürür.
// Fakat bu yaklaşım `null` değerleri kabul etmez, sonucunda UI rebuild (tekrardan oluşturulmaz) edilmez.
name('Hello');

// getter yapmak gibi, 'Hello'yazdırır.

name() ;

/// numbers:

final count = 0.obs;

// Tüm non mutable (değişken olmayan) işlemleri num primitives üzerinden yapabilirsiniz.
count + 1;

// Dikkat edin! Bu sadece `count` değerinin 'final' olmayıp 'var' olduğu değerlerde mümkündür.
count += 1;

// Ayrıca değerleri kıyaslayabilirsiniz:
count > 2;

/// booleans:

final flag = false.obs;

// değer true/false arasında değişir.
flag.toggle();


/// tüm tipler için:

// "value"'ları null'a çevirir.
flag.nil();

// Tüm toString(), toJson() işlemleri `value`'ya aktarılır.
print( count ); // RxInt içinden `toString()` çağrılır.

final abc = [0,1,2].obs;
// Değeri bir json Array (dizi) yapısına çevirir ve RxList şeklinde yazdırır.
// Json tüm Rx tipleri tarafından desteklenir.
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList ve RxSet kendi native tiplerinden extend edilen özel Rx tipleridir.
// Fakat List ile çalışmak normal listelerle çalışmak gibidir. Reaktiv olmasına rağmen.
abc.add(12); // '12' listeye eklenir ve stream GÜNCELLENİR.
abc[3]; // List'deki gibi 3. index okunur.


// Rx ve value ile çalışmak aynıdır fakat hashCode her zaman value'dan alınır.
final number = 12.obs;
print( number == 12 ); // çıktı: true

/// Özel Rx Modelleri:


// toJson(), toString() child'a gönderilir. Böylelikle override'ları onlara implement edebilirsiniz ve doğrudan gözlemlenebiliri print() edebilirsiniz.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user`,"reactive" yapıdadır. Fakat içinde özellikleri DEĞİLDİR.
// Yani eğer içindeki bazı değerleri değiştirirsek
user.value.name = 'Roi';
//widget, rebuild olmayacaktır!,
//`Rx`, user içindeki bir şeyi değiştirdiğinizde, bundan haberi olmayacaktır.
// Özel sınıflar oluşturmak için, manuel olarak değişiklikleri "notify" etmeliyiz.
user.refresh();

// Ya da `update()` metodunu kullanabiliriz
user.update((value){
  value.name='Roi';
});

print( user );
```
## StateMixin

`UI` state ile başa çıkmanın başka bir yolu da `StateMixin<T>`  kullanmaktır.
Bunu implement yapmak için, controller'ınıza  `with` kullanarak yanına `StateMixin<T>` eklemekle olur.
Bu sizin T modelini kullanmanızı sağlar.


``` dart
class Controller extends GetController with StateMixin<User>{}
```

`change()` metodu istediğiniz yerde State'i değiştirmemizi sağlar.
Veri(data) ve durum(status) aktarmak için kullanılan yol:

```dart
change(data, status: RxStatus.success());
```

RxStatus şu durumları kullanmanızı sağlar:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

UI'ın içinde temsil edilmesi için şu şekilde kullanılır:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // Kendi yüklenme göstergenizi (loading indicator) buraya eklebilirsiniz
        // hali hazırda gelen yapı şudur: Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // Keni hata widget'ınızı buraya yazabilirsiniz
        // hali hazırda gelen yapı şudur: Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

Bu widget'ı çok seviyorum, oldukça basit ve çok kullanışlı!

`const Stateless` Widget, `Controller`'ı tanımlamak için `controller` özelliği içerir. 

```dart
 class AwesomeController extends GetController {
   final String title = 'My Awesome View';
 }

  // controller'ınızı register etmek için bunu kullandığınız `Type`'a geçirmeyi asla unutmayın.
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // sadece `controller.something` deyin
     );
   }
 }
```

#### GetResponsiveView

Responsive view oluşturmak için bu widget'tan extend edilir.
Bu widget ekran size ve type hakkında bilgiler içeren  
`screen` özelliğini taşır.

##### Nasıl kullanılır?

build yapmanız için 2 yönteminiz vardır.

- build yapmak için `builder` metodu ile widget döndürmek
- `desktop`, `tablet`,`phone`, `watch`  metodları ile 
  bu özel metodlar ekran türü bu metodlarla eşitlendiiği zaman build metodunu tetikler.
  Mesela ekran [ScreenType.Tablet] ise `tablet` metodu çalışrıtılacaktır.
  **Not:** Eğer bu metodu kullanırsanız, lütfen  `alwaysUseBuilder` özelliğini `false` olarak işaretleyin.

`settings` özelliği sayesinde ekranın türüne göre genişlik limiti koyabilirsiniz.

![örnek](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Bu ekranın kodları
[burada](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Çoğu kişinin widget'lar hakkında hiçbir fikri yok ya da kullanırken inanılmaz kafası karışıyor.
Bu kullanım oldukça nadir fakat özel: Controller `caches`'leme işlemi _cache_ yüzünden asla bir  `const Stateless` oluşamaz.

> Peki ne zaman Controller'ı "cache"'yemeye ihtiyacınız olacak?

"Çok da yaygın olmayan" bir **GetX** özelliğini kullanıyorsanız: `Get.create()`.

`Get.create(()=>Controller())` yapısı siz her `Get.find<Controller>()` dediğinizde size yeni bir `Controller` oluşturacak.

`GetWidget`'ın ışığı burada parlıyor. Örnek olarak bir listede 

Todo ögelerini tutmak istiyorsanız kullanılır. Eğer widget'ın "rebuilt" olursa, yapı yine aynı controller nesnesini tutmaya devam edecektir.

#### GetxService

Bu sınıf `GetxController`' bezer. Uygulamanın lifecycle'larını (hayat döngüsü metodlarını) içerir ( `onInit()`, `onReady()`, `onClose()`).
Fakat içinde hiçbir mantıksal yapı bulunmaz. Sadece **GetX**'in Dependency Injection sistemini bilgilendirir. 

Bunun alt sınıfları, memory (bellekten) hiçbir şekilde **kaldırılamaz**. 


Bu yöntem "Servislerinizi" tutmak için oldukça kullanışlıdır. Servisleriniz bu şekilde her zaman ulaşılabilir ve aktif olur.  `Get.find()` metodu buna yeter. Örnek olarak:`ApiService`, `StorageService`, `CacheService`.


```dart
Future<void> main() async {
  await initServices(); /// SERVİSLERİN BAŞLATILMASI BEKLENİR
  runApp(SomeApp());
}

/// Servislerinizi Flutter uygulaması çalışmadan önce başlatılması oldukça mantıklı bir harekettir.
/// Uygulama akışını kontrol edebilirsiniz. (belki de birkaç tane Tema düzenlemesi ya da
/// apiKey, kulllanıcıdan gelen  dil tanımlaması gibi düzenlemeler yapmanız lazımdır...Bu durumna SettingService'i ApiService'den önce çalışması gerekmektedir.
/// GetMaterialApp() 'in rebuild yapmasına gerek yoktur. Çünkü değerleri doğrudan alır.
void initServices() async {
  print('starting services ...');
  /// Burası sizin get_storage, hive, shared_pref gibi yükelemeleri yaptığınız yer.
  /// ya da daha fazla özellik bağlamak ve ya async yapıları kullanmak için
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

`GetxService`'lerini silmenin tek bir yolu vardır o da `Get.reset()`. 
Bu yöntem uygulamanıza "Hot Reboot" yapmak gibidir. Eğer uygulamanızın hayat süresi boyunca mutlaka kalıcılığı olmasını istediğiniz bir sınıfın nesnesini oluşturmak istediğiniz zaman  `GetxService`'i kullanın.


### Testler

Controller'larınızı lifecycle'ları (hayat döngüleri) dahil olmak üzere diğer sınıflar gibi test edebilirsiniz:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Değeri name2 ile değiştirme

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
    /// Controller'ınızı lifecycle dışında test edebilirsiniz.
    /// Fakat bunu GetX dependency injection kullanmadığınız taktirde 
    /// kullanmanız önerilmiyor.
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// Eğer kullanıyorsanı istediğiniz her şeyi test edebilirsiniz.
    /// Her lifecycle sonrası uygulamanızın durumu dahil olmak üzere.
    Get.put(controller); // onInit çağrıldıktan sonra
    expect(controller.name.value, 'name2');

    /// Bu fonksoynu test edin
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose çağrıldıktan sonra
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### Ipuçları

##### Mockito or mocktail
Eğer GetxController/GetxService'inizi mock yapmaya ihtiyacınız varsa GetxController'dan extend etmeniz ve Mock ile mixin'lemelisiniz.

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Using Get.reset()
Eğer widget'ları ya da widget grupllarını test etmek istiyorsanız, testinizin sonunda Get.reset'i kullanın ya da önceki testinizden kalma tüm ayarları sıfırlayın.

##### Get.testMode 
Eğer controller'larınızın içinden navigation kullanmak istiyorsanız. Main'den önce  `Get.testMode = true` şeklinde kullanın.


# 2.0 Ile Gelen Büyük Değişiklikler

1- Rx Types :

| Önce    |    Sonra   |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController ve GetBuilder şimdi birleştiler. Artık hangi controller'ı kullanmak istediğinizi hatırlamak zorunda değilsiniz. SAdece GetxController diyerek halledin. Bu simple state management ve reactive ile düzgün çalışacaktır.

2- NamedRoutes

Önce:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Şimdiki:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```
Neden bu değişiklik?

Genellikle, hangi sayfanın bir parametreden görüntüleneceğine veya bir giriş belirteciden görüntüleneceğine karar vermek gerekebilir, önceki yaklaşım buna izin vermediği için esnek değildi.
Sayfayı bir fonksiyona sokmak, RAM tüketimini önemli ölçüde azaltır, çünkü rotalar uygulama başlatılmasından bu yana belleğe tahsis edilmeyecek ve aynı zamanda bu tür bir yaklaşım yapmasına izin verilmeyecek:

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

# Neden Getx?

1- Birçok kez Flutter güncellendikten sonra, birçok paket çalışmaz hale gelecek. Genelde derleme hataları gerçekleşir. Bu hataların hala cevabı olmayabilir. Geliştiricinin bu hatanın nerden geldiğini bilmesi gereklidir. Sonrasında bu hatayı izleyip bunun hakkında repository'de issue açması ve sorunun çözülmesini beklemelidir. Get, geliştirme için gereken ana kaynaklarını  (State, dependency ve route management) merkezde toplar, pubspec'e tek bir paket eklemeye izin verir ve çalışmaya başlar. Flutter güncellendikten sonra tek yapmanız gereken Get dependency'yi güncellemek ve çalışmaya başlamaktır. Get uyumluluk problemlerini de çözer. Paketler arasında genelde güncellemeler sonrası uyumsuzluklar olabilir. Get'in kendi içinde her şey birbiri ile uyumlu olduğundan bunun için endişelenmenize gerek yoktur.

2- Flutter oldukça kolay kullanımı olan inanılmaz olmasının yanı sıra birçok geliştirici tarafından istenmeyen `Navigator.of(context).push (context, builder [...]` gibi ezber yapılar içerir. Get geliştirmeyi basitleştirir. Route çağırmak için 8 kod yazmak yerine sadece `Get.to(Home())` diyerek bir sonraki sayfaya geçebilirsin. Dynamic web urls ile çalışmak mevcut Flutter ile çalışırken zorlayıcı olabilir. Get ile durum tam tersi hal alır ve işleri çok kolay bir hale getirir. Flutter'da State'leri yönetmek için dependency'leri pub içerindeki yüzlerce kütüphane arasından seçmek birçok tartışmayı da beraberinde getiren bir konudur. Get sayesinde ekranda değişkeni otomatik olarak güncellemesini sağlamak için değişkeninizin sonuna ".obs" eklemek ve widget'ınızı Obx ile sarmalamak yeterlidir.

3- Performansı kafaya takmayın. Flutter'ın performansı zaten çok iyi. Bir de state manager kullanırken ve blocs/stores/controllers gibi sınıflarınızı locator ile yönetirken de aynı performansı aldığınızı düşünün. İhtiyacınız olmadığında  dependency'lerinizi dışarıdan çağırmak zorunda kalacaksınız. Hiç düşündünüz mü, basitçe kullandığınız controller'ınızın artık kimse tarafından kullanılmadığında kolayca bellekten silindiğini? İşte  GetX bunu yapar. SmartManagement sayesinde kullanılmayan her şey endişelenmenize gerek kalmadan otomatik olarak hafızadan silinir. Bunun için bir logic yaratmaya gerek bile kalmadan, kaynakları minimum ölçüde tükettiğinize emin olabilirsiniz. 

4- Gerçek ayrıştırma: "View ile the business logic (iş mantığını) birbirlerinden ayırmak" kavramını duymuş olabilirsiniz. Bu sadece BLoC, MVC, MVVM'ye özgü bir özellik değildir, piyasadaki diğer standart tasarım desenlerinde de mevcuttur. Ancak bu kavram Flutter'da context kullanımına bağlı olarak kolaylaştırılabilir.
Bir InheritedWidget bulabilmek için context'e ihtiyaç duyduğunuzda, bunu view'da yapmalı ya da parametre ile aktarmalıyız. Ben bu yöntemi oldukça çirkin buluyorum. Ayrıca bir ekip ile çalışırken  View'daki iş mantığına hep bağımlı olacağız. GetX standart yaklaşımı benimsemez ve StatefulWidgets, InitState, vb. yapılarını tamamen ortadan kaldırmaz. Daha temiz bir yaklaşım sunar. Controller'ların yaşam döngüleri vardır. Mesela APIREST talebi yaptığında view'a bağlı olmak zorunda değilsin. Http çağrısı başlatmak için "onInit" kullanabilirsiniz. Veriler geldiğinde yerleştirilecektir. GEtX tamamen reaktif  (cidden,stream'lerin altında çalışır) olduğu için tüm item'lar doldurulduğunda o değişkeni kullanan tüm widget'lar view'da otomatik olarak güncellenecektir. Bu UI uzmanlığına sahip kişilerin sadece widget'larla çalışmasını sağlar ve kullanıcı etkinlikleri dışında iş mantığına hiçbir şey göndermek zorunda değildir (bir düğmeye tıklamak gibi). İş mantığı ile çalışan insanlar, bunu ayrı olarak oluşturmak ve test etmek konusunda serbest olacaktır.

Bu kütüphane her zaman güncellenebilir ve yeni özellikler eklenebilir olacaktır. PR ve contribute yapmakta tamamen özgürsünüz.

# Topluluk

## Topluluk Kanalları

GetX oldukça aktif ve yardımsever bir topluluğa sahiptir. Bu framework kullanımıyla ilgili sorularınız varsa veya herhangi bir yardım istiyorsanız, lütfen topluluk kanallarımıza katılın, sorunuz daha hızlı yanıtlanacak ki bunun için en uygun yer burasıdır. Repository'de issues açabilir ve kaynak talep edebilirsiniz.  GetX topluluğunun bir parçası olmaktan çekinmeyin.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Nasıl katkıda bulunulur?

_Projeye katkıda bulunmak ister misiniz? Sizi destekçilerimizden biri olarak öne çıkarmaktan gurur duyacağız. İşte katkıda bulunabileceğiniz ve Get'i (ve Flutter'ı) daha da iyi hale getirebileceğiniz bazı noktalar._

- Readme dosyasının diğer dillere çevrilmesine yardımcı olmak.
- Readme'ye dokümanlar eklemek (birçok Get fonsyonu henüz belgelenmedi).
- Get'in kullanımını öğretmek için makaleler yazabilir ya da videolar çekebilirsiniz (Bunlar Readme ve gelecekte Wiki'ye eklenecek).
- Kod ve test PR'ları önermek.
- Yeni fonksiyonlar eklemek.

Her türlü yardım için teşekkürler.


## Makaleler ve videolar

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

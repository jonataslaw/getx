- [Rota Yönetimi (Route Management)](#route-management)
  - [Nasıl kullanılır?](#how-to-use)
  - [Adlandırılmış rotalar olmadan navigasyon](#navigation-without-named-routes)
  - [Adlandırılmış rotalarla navigasyon](#adlandırılmış-rotalarla-navigasyon)
    - [Verileri adlandırılmış Rotalara gönder](#send-data-to-named-routes)
    - [Dinamik URL bağlantıları](#dynamic-urls-links)
    - [Middleware](#middleware)
  - [Bağlamsız(Context) Navigasyon](#navigation-without-context)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [İç İçe Navigasyon (Nested Navigation)](#nested-navigation)

# Rota Yönetimi (Route Management)

Konu rota yönetimi olduğunda Getx için gereken her şeyin tam açıklaması budur.

## Nasıl kullanılır?

Bunu pubspec.yaml dosyanıza ekleyin:

```yaml
dependencies:
  get:
```

Context olmadan routes/snackbars/dialogs/bottomsheets kullanacaksanız veya üst düzey Get API'lerini kullanacaksanız, `MaterialApp`'ınızdan önce `Get` eklemeniz, `GetMaterialApp`'a dönüştürmeniz ve keyfini çıkarmanız yeterlidir!

```dart
GetMaterialApp( // Öncesi: MaterialApp(
  home: MyHome(),
)
```

## Adlandırılmış rotalar olmadan navigasyon

Yeni bir ekrana gitmek için:

```dart
Get.to(NextScreen());
```

Snackbar'ları, Dialog'ları, Bottomsheet'leri veya normalde kapatacağınız herhangi bir şeyi kapatmak için `Navigator.pop(context);`

```dart
Get.back();
```

Bir sonraki ekrana gittikten sonra önceki ekrana geri dönme seçeneğinin olmaması için (SplashScreens, Login ekranlarında vb. kullanım için)

```dart
Get.off(NextScreen());
```

Bir sonraki ekrana gittikten sonra önceki tüm rotaları iptal etmek için (Alışveriş sepetlerinde, Anketlerde ve Testlerde kullanışlıdır)

```dart
Get.offAll(NextScreen());
```

Bir sonraki rotaya gitmek ve geri döner dönmez verileri almak veya güncellemek için:

```dart
var data = await Get.to(Payment());
```

diğer ekrandan önceki rota için bir veri gönderin:

```dart
Get.back(result: 'success');
```

Ve kullanın:

Örn:

```dart
if(data == 'success') madeAnything();
```

Sözdizimimizi öğrenmek istemiyor musun? Navigator'ı (büyük harf) navigator (küçük harf) olarak değiştirin ve bağlam(context) kullanmak zorunda kalmadan standart navigasyonun tüm işlevlerine sahip olacaksınız.
Örnek:

```dart

// Varsayılan Flutter Navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Bağlama(context) ihtiyaç duymadan Flutter sözdizimini(syntax) kullanın
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Get syntax (Bu kullanım çok daha iyidir. Tabiki siz karşı çıkma hakkına sahipsiniz.)
Get.to(HomePage());


```

### Adlandırılmış Rotalarla Navigasyon

- NamedRoutes ile gezinmeyi tercih ederseniz, Get de bunu destekler.

nextScreen'e gitmek için

```dart
Get.toNamed("/NextScreen");
```

Ağaçta ve önceki ekranda gezinmek için.

```dart
Get.offNamed("/NextScreen");
```

Ağaçta gezinmek ve önceki tüm ekranları kaldırmak için

```dart
Get.offAllNamed("/NextScreen");
```

Rotaları tanımlamak için `GetMaterialApp`'i kullanın:

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

Tanımsız rotalara navigasyonu yönetmek için (404 hatası), `GetMaterialApp`'de bir `unknownRoute` sayfası tanımlayabilirsiniz.

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

### Verileri adlandırılmış Rotalara gönder


Sadece argümanlar için istediğinizi gönderin. Get, burada bir String, Map, List veya hatta bir Class örneği olsun, her şeyi kabul eder.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

sınıfınızda(class) veya denetleyicinizde(controller):

```dart
print(Get.arguments);
//print out: Get is the best
```

### Dinamik URL bağlantıları

Web'deki gibi gelişmiş dinamik url'ler sunun. Web geliştiricileri muhtemelen bu özelliği Flutter'da istemişlerdir ve büyük olasılıkla bir paketin bu özelliği vaat ettiğini ve bir URL'nin web'de bulunacağından tamamen farklı bir sözdizimi sunduğunu görmüşlerdir, ancak Get bunu da çözmektedir.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

controller/bloc/stateful/stateless Sınıfınıza:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

Ayrıca Get ile Adlandırılmış Parametreleri kolayca alabilirsiniz:

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
       //Argümanlı rotalar için farklı bir sayfa ve argümansız başka bir sayfa tanımlayabilirsiniz, ancak bunun için yukarıdaki gibi argüman almayacak olan rotada '/' eğik çizgisini kullanmanız gerekir.
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

Rota adına veri gönder

```dart
Get.toNamed("/profile/34954");
```

İkinci ekranda verileri parametreye göre alın

```dart
print(Get.parameters['user']);
// out: 34954
```

veya bunun gibi birden çok parametre gönderin

```dart
Get.toNamed("/profile/34954?flag=true&country=italy");
```
veya
```dart
var parameters = <String, String>{"flag": "true","country": "italy",};
Get.toNamed("/profile/34954", parameters: parameters);
```

İkinci ekranda, verileri genellikle olduğu gibi parametrelere göre alın

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
print(Get.parameters['country']);
// out: 34954 true italy
```



Ve şimdi tek yapmanız gereken, herhangi bir bağlam(context) olmaksızın adlandırılmış rotalarınızda gezinmek için Get.toNamed()'i kullanmaktır (rotalarınızı doğrudan BLoC veya Controller sınıfınızdan çağırabilirsiniz) ve uygulamanız web'de derlendiğinde, rotalar url'de görünecek <3

### Middleware

Eylemleri tetiklemek için olayları almak dinlemek istiyorsanız routingCallback'i kullanabilirsiniz.

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

GetMaterialApp kullanmıyorsanız, Middleware gözlemcisini(observer) eklemek için manuel API'yi kullanabilirsiniz.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // Burası !!!
      ],
    ),
  );
}
```

Bir MiddleWare sınıfı oluşturun

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Her ekranda rotalar, snackbarlar, diyaloglar ve bottomsheetleri ek olarak dinleyebilirsiniz.
    ///Bu 3 olaydan herhangi birini doğrudan buraya girmeniz gerekiyorsa,
    ///Yapmaya çalıştığınızdan daha fazla olayın olduğunu != kullanarak belirtmelisiniz.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

Şimdi, Get on kodunu kullanın:

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

## Bağlamsız(Context) Navigasyon

### SnackBars

Flutter ile basit bir SnackBar'a sahip olmak için Scaffold bağlamını(context) almalısınız veya Scaffold'unuza bağlı bir GlobalKey kullanmalısınız.

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// Widget ağacında Scaffold'u bulun ve kullanın
// bir SnackBar göstermek için.
Scaffold.of(context).showSnackBar(snackBar);
```

Get ile:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Get ile, Yapmanız gereken tek şey kodunuzun herhangi bir yerinden Get.snackbar'ınızı aramak veya onu istediğiniz gibi özelleştirmek!

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

Geleneksel snackbar'ı tercih ediyorsanız veya yalnızca bir satır eklemek de dahil olmak üzere sıfırdan özelleştirmek istiyorsanız (Get.snackbar zorunlu bir başlık ve mesaj kullanır), 
Get.snackbar'ın üzerine inşa edildiği RAW API'sini sağlayan `Get.rawSnackbar();` kullanabilirsiniz. 

### Dialogs

Dialog'u açmak için:

```dart
Get.dialog(YourDialogWidget());
```

Varsayılan dialog açmak için:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

showGeneralDialog yerine Get.generalDialog'u da kullanabilirsiniz.

Cupertinos dahil olmak üzere tüm diğer Flutter Dialog widget'ları için bağlam(context) yerine Get.overlayContext'i kullanabilir ve kodunuzun herhangi bir yerinde açabilirsiniz.
Overlay kullanmayan widget'lar için Get.context'i kullanabilirsiniz.
Bu iki bağlam(context), inheritedWidget'ın bir gezinme bağlamı(context) olmadan kullanıldığı durumlar dışında, kullanıcı arayüzünüzün bağlamını(context) değiştirmek için vakaların %99'unda çalışacaktır.

### BottomSheets

Get.bottomSheet, showModalBottomSheet gibidir, ancak bağlama(context) ihtiyaç duymaz.

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

## İç İçe Navigasyon (Nested Navigation)

Flutter'ın iç içe gezinmesini daha da kolaylaştırın.
İçeriğe ihtiyacınız yoktur ve navigasyon yığınınızı kimliğe(ID) göre bulacaksınız.

- NOT: Paralel gezinme yığınları oluşturmak tehlikeli olabilir. İdeal olan, NestedNavigators'ı kullanmamak veya idareli kullanmaktır. Projeniz gerektiriyorsa, devam edin, ancak bellekte birden çok gezinme yığınını tutmanın RAM tüketimi için iyi bir fikir olmayabileceğini unutmayın.

Bakın ne kadar basit:

```dart
Navigator(
  key: Get.nestedKey(1), // index göre anahtar oluşturma
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
                Get.toNamed('/second', id:1); // indexe göre iç içe geçmiş rotanıza göre gezinin
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

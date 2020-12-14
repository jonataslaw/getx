- [Route Management](#route-management)
  - [Cara pakai](#cara-pakai)
  - [Navigasi tanpa named route](#navigasi-tanpa-named-route)
  - [Navigasi menggunakan named route](#navigasi-menggunakan-named-route)
    - [Mengirim data ke named route](#mengirim-data-ke-named-route)
    - [Tautan URL dinamis](#tautan-url-dinamis)
    - [Middleware](#middleware)
  - [Navigasi tanpa konteks](#navigasi-tanpa-konteks)
    - [SnackBar](#snackbar)
    - [Dialog](#dialog)
    - [BottomSheet](#bottomsheet)
  - [Navigasi Bersarang](#navigasi-bersarang)

# Route Management

Ini adalah penjelasan lengkap mengenai route management di GetX.

## Cara pakai

Tambahkan ini kedalam pubspec.yaml anda:

```yaml
dependencies:
  get:
```

Jika anda akan menggunakan route/snackbar/dialog/bottomsheet tanpa konteks, atau menggunakan high-level API dari Get, cukup tambahkan "Get" sebelum MaterialApp, mengubahnya menjadi GetMaterialApp, dan selamat menikmati!

```dart
GetMaterialApp( // Sebelumnya: MaterialApp(
  home: MyHome(),
)
```

## Navigasi tanpa named route

Untuk pindah ke halaman baru:

```dart
Get.to(NextScreen());
```

Untuk menutup snackbar, dialog, bottomsheet, atau apapun yang normalnya anda tutup menggunakan Navigator.pop(context);

```dart
Get.back();
```

Untuk pergi ke halaman baru dan mencegah user kembali ke halaman sebelumnya (biasanya digunakan untuk SplashScreen, LoginScreen, dsb).

```dart
Get.off(NextScreen());
```

Untuk pergi ke halaman baru dan batalkan navigasi sebelumnya (berguna untuk shopping cart, polls, dan test).

```dart
Get.offAll(NextScreen());
```

Untuk pergi ke halaman baru dan menerima atau memperbarui data segera setelah anda kembali dari halaman tersebut:

```dart
var data = await Get.to(Payment());
```

pada halaman lain, kirim data ke halaman sebelumnya:

```dart
Get.back(result: 'success');
```

Lalu gunakan:

contoh:

```dart
if(data == 'success') madeAnything();
```

Bukankah anda ingin mempelajari sintaks kami?
Cukup ubah Navigator (uppercase) ke navigator (lowercase), dan anda akan mendapatkan semua fungsi standar navigasi, tanpa harus menggunakan konteks.
Contoh:

```dart

// Navigator bawaan Flutter
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Get menggunakan sintaks Flutter tanpa membutuhkan konteks.
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Sintaks Get (Lebih baik, tapi anda juga berhak untuk tidak setuju)
Get.to(HomePage());


```

## Navigasi menggunakan named route

- Jika anda lebih suka bernavigasi menggunakan namedRoutes, Get juga bisa melakukannya.

Untuk pindah ke halaman nextScreen

```dart
Get.toNamed("/NextScreen");
```

Untuk pindah dan hapus halaman sebelumnya dari widget tree.

```dart
Get.offNamed("/NextScreen");
```

Untuk pindah dan hapus semua halaman sebelumnya dari widget tree.

```dart
Get.offAllNamed("/NextScreen");
```

Untuk mendifinisikan route, gunakan GetMaterialApp:

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

Untuk menangani navigasi ke route yang tidak terdefinisi (404), anda bisa mendefinisikan sebuah halaman unknownRoute didalam GetMaterialApp.

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

### Mengirim data ke named route

Cukup kirim apa yang anda mau sebagai arguments. Get menerima apapun disitu, baik dalam bentuk String, Map, List atau bahkan instance dari sebuah Kelas.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

di dalam kelas atau controller anda:

```dart
print(Get.arguments);
// keluaran: Get is the best
```

### Tautan URL dinamis

Get menawarkan tautan URL dinamis lebih lanjut sama seperti di Web. Para Web developer mungkin sudah menginginkan fitur ini di Flutter, dan mungkin juga sering melihat sebuah package menjanjikan fitur ini dan mengantarkan sintaks yang benar benar berbeda dari sebuah URL yang kita miliki di web, Get juga menyelesaikan masalah ini.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

didalam controller/bloc/stateful/stateless class anda:

```dart
print(Get.parameters['id']);
// keluaran: 354
print(Get.parameters['name']);
// keluaran: Enzo
```

Anda juga bisa menerima NamedParameters dengan Get dengan mudah:

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
       // Anda bisa mendefinisikan halaman berbeda untuk routes dengan arguments,
       // dan yang lainnya tanpa arguments, namun untuk itu anda perlu slash '/'
       // pada route yang tidak menerima arguments seperti diatas.
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

Kirim data ke named route

```dart
Get.toNamed("/profile/34954");
```

Pada halaman kedua, ambil data menggunakan parameter

```dart
print(Get.parameters['user']);
// keluaran: 34954
```

Dan sekarang, yang anda perlu lakukan adalah menggunakan Get.toNamed() untuk bernavigasi ke named route anda, tanpa konteks (anda bisa memanggil route secara langsung dari kelas BLoC atau Controller), dan ketika aplikasi anda di-compile di web, route anda akan muncul di url <3

### Middleware

Jika anda ingin me-listen sebuah Get event untuk melakukan sebuah action, anda bisa menggunakan routingCallback didalamnya.

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Jika anda tidak menggunakan GetMaterialApp, anda bisa menggunakan API untuk mengaitkan Middleware observer secara manual.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // Disini
      ],
    ),
  );
}
```

Membuat sebuah kelas Middleware

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// Anda bisa me-listen sebuah route, snackbar, dialog, dan bottomsheet disetiap halaman.
    /// Jika anda harus memasukkan salah satu dari 3 event tersebut secara langsung disini,
    /// anda perlu menyebutkan bahwa event tersebut != (tidak sama dengan) apa yang mau anda lakukan.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Halo", "Anda sedang berada di route kedua");
    } else if (routing.current =='/third'){
      print('route terakhir dipanggil');
    }
  }
}
```

Sekarang, gunakan Get dalam kode anda:

```dart
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("halo", "saya adalah snackbar modern");
          },
        ),
        title: Text('Halaman Pertama'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Pindah halaman'),
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
            Get.snackbar("halo", "saya adalah snackbar modern");
          },
        ),
        title: Text('Halaman kedua'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Pindah halaman'),
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
        title: Text("Halaman ketiga"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Kembali!'),
        ),
      ),
    );
  }
}
```

## Navigasi tanpa konteks

### SnackBar

Untuk mendapatkan SnackBar sederhana dengan Flutter, anda harus mendapatkan konteks dari sebuah Scaffold, atau anda harus menggunakan GlobalKey yang dikaitkan pada Scaffold anda

```dart
final snackBar = SnackBar(
  content: Text('Halo!'),
  action: SnackBarAction(
    label: 'Saya adalah snackbar tua yang jelek :(',
    onPressed: () {}
  ),
);
// Temukan Scaffold didalam widget tree dan gunakan itu
// untuk menampilkan snackbar
Scaffold.of(context).showSnackBar(snackBar);
```

Dengan Get:

```dart
Get.snackbar('Halo', 'Saya adalah snackbar modern');
```

Dengan Get, yang anda butuhkan hanya memanggil Get.snackbar darimanapun di kode anda atau menyesuaikannya sesuka hati anda!

```dart
Get.snackbar(
  "Halo, saya snackbar milik Get!", // judul
  "Sulit dipercaya! Saya menggunakan SnackBar tanpa konteks, tanpa boilerplate, tanpa Scaffold, ini benar benar keren!", // pesan
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap: () {},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// SEMUA FITUR //////////
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
  //     FlatButton mainButton,
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

Jika anda lebih menyukai snackbar tradisional, atau ingin menyesuaikannya sendiri dari awal, termasuk menambahkan hanya satu baris (Get.snackbar memanfaatkan title dan message yang diperlukan), anda bisa gunakan
`Get.rawSnackbar();` yang akan menyediakan RAW API untuk Get.snackbar yang dibuat.

### Dialog

Untuk membuka dialog:

```dart
Get.dialog(YourDialogWidget());
```

Untuk membuka default dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

Anda juga bisa menggunakan Get.generalDialog daripada showGeneralDialog.

Untuk semua widget dialog di Flutter, termasuk cupertino, anda bisa menggunakan Get.overlayContext daripada context, dan membukanya darimanapun di kode anda.
Untuk widget yang tidak menggunakan Overlay, anda bisa menggunakan Get.context.
Kedua konteks akan bekerja dalam 99% kasus untuk me-replace konteks dari UI anda, kecuali untuk kasus dimana inheritedWidget digunakan tanpa konteks navigasi.

### BottomSheet

Get.bottomSheet sama seperti showModalBottomSheet, tapi tidak membutuhkan konteks.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Music'),
          onTap: () => {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () => {},
        ),
      ],
    ),
  )
);
```

## Navigasi Bersarang

Get membuat navigasi bersarang milik Flutter menjadi lebih mudah.
Anda tidak perlu konteks, dan anda akan menemukan stack navigasi melalui Id.

- CATATAN: Membuat stack navigasi parallel bisa jadi berbahaya. Sebaiknya hindari penggunaan Navigasi Bersarang, atau gunakan dengan bijak. Jika proyek anda membutuhkannya, silahkan, tapi mohon di ingat bahwa menyimpan lebih dari satu navigation stack didalam memori mungkin bukan ide yang bagus untuk konsumsi RAM.

Lihat betapa sederhananya ini:

```dart
Navigator(
  key: Get.nestedKey(1), // buat sebuah key menggunakan index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetPageRoute(
        page: () => Scaffold(
          appBar: AppBar(
            title: Text("Main"),
          ),
          body: Center(
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Get.toNamed('/second', id:1); // pindah ke halaman bersarang anda menggunakan index
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

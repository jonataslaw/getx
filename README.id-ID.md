![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Bahasa: Indonesia (file ini), [Inggris](README.md), [Urdu](README.ur-PK.md), [China](README.zh-cn.md), [Portugis (Brazil)](README.pt-br.md), [Spanyol](README-es.md), [Russia](README.ru.md), [Polandia](README.pl.md), [Korea](README.ko-kr.md), [French](README-fr.md)**

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
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

- [Tentang Get](#tentang-get)
- [Instalasi](#instalasi)
- [Aplikasi Counter menggunakan GetX](#aplikasi-counter-menggunakan-getx)
- [Tiga Pilar](#tiga-pilar)
  - [State management](#state-management)
    - [Reactive State Manager](#reactive-state-manager)
    - [Detail lebih lanjut mengenai state management](#detail-lebih-lanjut-mengenai-state-management)
  - [Route management](#route-management)
    - [Detail lebih lanjut mengenai route management](#detail-lebih-lanjut-mengenai-route-management)
  - [Dependency management](#dependency-management)
    - [Detail lebih lanjut mengenai dependency management](#detail-lebih-lanjut-mengenai-dependency-management)
- [Utilitas](#utilitas)
  - [Internasionalisasi](#internasionalisasi)
    - [Translasi](#translasi)
      - [Menggunakan Translasi](#menggunakan-translasi)
    - [Lokalisasi](#lokalisasi)
      - [Mengubah Lokal](#mengubah-lokal)
      - [Lokal Sistem](#lokal-sistem)
  - [Mengubah Tema](#mengubah-tema)
  - [GetConnect](#getconnect)
    - [Konfigurasi Default](#konfigurasi-default)
    - [Konfigurasi Kustom](#konfigurasi-kustom)
  - [GetPage Middleware](#getpage-middleware)
    - [Prioritas](#prioritas)
    - [Redirect](#redirect)
    - [OnPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [API Lanjutan Lainnya](#api-lanjutan-lainnya)
    - [Pengaturan Global Opsional dan Konfigurasi Manual](#pengaturan-global-opsional-dan-konfigurasi-manual)
    - [Local State Widgets](#local-state-widgets)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [Tips berguna](#tips-berguna)
      - [GetView](#getview)
      - [GetResponsiveView](#getresponsiveview)
        - [Cara pakai](#cara-pakai)
      - [GetWidget](#getwidget)
      - [GetxService](#getxservice)
- [Breaking change dari 2.0](#breaking-change-dari-20)
- [Mengapa Getx?](#mengapa-getx)
- [Komunitas](#komunitas)
  - [Channel Komunitas](#kanal-komunitas)
  - [Cara berkontribusi](#cara-berkontribusi)
  - [Artikel dan Video](#artikel-dan-video)

# Tentang Get

- GetX adalah solusi ekstra-ringan dan powerful untuk Flutter. Ini mengkombinasikan state management dengan performa tinggi, injeksi dependensi yang cerdas, dan route management secara singkat dan praktis.

- GetX memiliki 3 prinsip dasar, yang menjadi prioritas untuk semua resource yang ada di dalamnya: **PRODUKTIFITAS, PERFORMA DAN ORGANISASI**

  - **PERFORMA:** GetX fokus pada performa dan konsumsi resource minimum. GetX tidak menggunakan Stream atau ChangeNotifier.

  - **PRODUKTIFITAS:** GetX menggunakan sintaks yang mudah dan nyaman. Tidak peduli apa yang akan anda lakukan, akan selalu ada cara yang lebih mudah dengan GetX. Ini akan menghemat waktu development, dan meng-ekstrak performa maksimum pada aplikasi anda.
  Umumnya, developer akan selalu berhubungan dengan penghapusan controller dari memori. Dengan GetX, ini tidak diperlukan, karena resource akan dihapus dari memori secara default ketika tidak digunakan. Jika anda ingin menyimpannnya kedalam memori, anda harus secara eksplisit mendeklarasikan "permanent: true" pada dependensi anda. Dengan begitu, selain menghemat waktu, anda juga mengurangi resiko memiliki dependensi yang tidak diperlukan dalam memori. Pemuatan dependensi juga bersifat "lazy" secara default.

  - **ORGANISASI:** GetX memungkinkan pemisahan View, Presentation Logic, Business Logic, Dependency Injection, dan Navigasi.
  Anda tidak perlu konteks untuk berpindah antar halaman. Jadi, anda tidak lagi bergantung pada widget tree (visualisasi) untuk hal ini. Anda tidak perlu konteks untuk mengakses controller/bloc melalui InheritedWidget. Dengan ini, anda benar benar memisahkan presentation logic dan business logic dari lapisan visual. Anda tidak perlu menginjeksi kelas Controller/Model/Bloc kedalam widget tree melalui multiprovider, untuk hal ini GetX menggunakan fitur dependency injection nya sendiri, memisahkan DI dari View secara total.
  Dengan GetX, anda tahu dimana harus mencari setiap fitur dalam aplikasi anda, memiliki kode yang bersih secara default. Ini selain untuk memfasilitasi maintenance, membuat pembagian modul, sesuatu yang hingga saat itu di Flutter tidak terpikirkan, sesuatu yang sangat mungkin.
  BLoC adalah permulaan awal dalam meng-organisir kode di Flutter, ini memisahkan business logic dari visualisasi. GetX adalah evolusi natural dari ini, tidak hanya memisahkan business logic, tapi juga presentation logic. Injeksi dependensi dan route juga dipisahkan sebagai bonus, dan lapisan data benar-benar terpisah secara menyeluruh. Anda tahu dimana semuanya berada, dan segalanya dengan cara yang lebih mudah daripada membuat sebuah hello world.
  GetX adalah cara termudah, praktis, dan scalable untuk membangun aplikasi dengan performa tinggi menggunakan Flutter SDK, dengan ekosistem besar di sekelilingnya yang bekerjasama secara sempurna, mudah dipahami untuk pemula, dan akurat untuk ahli. Aman, stabil, up-to-date, dan menawarkan banyak cakupan build-in API yang tidak tersedia di dalam default Flutter SDK.

- GetX tidak "bloated". Dirinya memiliki banyak fitur yang memungkinkan anda memulai programming tanpa mengkhawatirkan apapun, namun setiap fiturnya terletak didalam kontainer terpisah, dan hanya dimulai setelah digunakan. Jika anda hanya menggunakan State Management, hanya State Management yang akan di-compile. Jika anda hanya menggunakan routes, state management tidak akan di-compile.

- GetX memiliki ekosistem yang besar, komunitas yang juga besar, banyak kolaborator, dan akan di maintenance selama Flutter ada. GetX juga mampu berjalan dengan kode yang sama di Android, iOS, Web, Mac, Linux, Windows, dan server anda.
**Juga memungkinkan untuk me-reuse kode yang dibuat di frontend ke backend dengan [Get Server](https://github.com/jonataslaw/get_server)**.

**Selain itu, seluruh proses development bisa di automasi secara menyeluruh, untuk keduanya (server dan frontend) menggunakan [Get CLI](https://github.com/jonataslaw/get_cli)**.

**Selain itu, untuk lebih meningkatkan produktifitas anda, kami memiliki [ekstensi untuk VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) dan [ekstensi untuk Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# Instalasi

Tambahkan Get kedalam file `pubspec.yaml` anda:

```yaml
dependencies:
  get:
```

Import get didalam file dimana get akan digunakan:

```dart
import 'package:get/get.dart';
```

# Aplikasi Counter menggunakan GetX

Proyek "counter" yang dibuat secara default ketika membuat proyek Flutter memiliki lebih dari 100 baris (termasuk comment). Untuk menunjukkan kekuatan Get, kami akan mendemonstrasikan bagaimana cara membuat "counter" yang mengubah state setiap klik, berpindah, dan berbagi state antar halaman, semua dalam cara yang terorganisir, memisahkan business logic dari view, dalam HANYA 26 BARIS KODE TERMASUK COMMENT.

- Langkah 1:
  Tambahkan "Get" sebelum MaterialApp, mengubahnya menjadi GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Catatan: ini tidak mengubah MaterialApp bawaan Flutter, GetMaterialApp bukan sebuah MaterialApp yang dimodifikasi, itu hanyalah sebuah Widget yang telah dikonfigurasi sebelumnya, yang mana memiliki default MaterialApp sebagai child. Anda bisa mengkonfigurasinya secara manual, namun hal itu benar-benar tidak diperlukan. GetMaterialApp akan membuat route, menginjeksinya, menginjeksi translasi/terjemahan, dan semua yang anda butuhkan untuk navigasi route. Jika anda hanya menggunakan Get untuk manajemen state atau manajemen dependensi, tidak perlu menggunakan GetMaterialApp. GetMaterialApp diperlukan untuk route, snackbar, internasionalisasi/terjemahan, bottomSheet, dialog, dan high-level API yang berhubungan dengan route dan ketiadaan konteks.

- Catatan²: Langkah ini hanya diperlukan jika anda akan menggunakan manajemen route (`Get.to()`, `Get.back()` dan seterusnya). Jika anda tidak menggunakannya, langkah 1 tidak diperlukan.

- Langkah 2:
  Buat file baru untuk business logic dan taruh semua variabel, metode, dan kontroler didalamnya.
  Anda bisa membuat variabel apapun menjadi "observable" menggunakan notasi tambahan ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Langkah 3:
  Buat file baru untuk View, gunakan StatelessWidget dan hemat penggunaan RAM, dengan Get, anda mungkin tidak perlu lagi menggunakan StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instansiasi kelas anda menggunakan Get.put() untuk membuatnya tersedia untuk seluruh "child" route dibawahnya.    
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Gunakan Obx(() => ...) untuk mengupdate Text() ketika `count` berubah.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Ganti 8 baris Navigator.push menggunan Get.to() agar lebih sederhana. Anda tidak perlu `context`.
      body: Center(child: RaisedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // Anda bisa meminta Get untuk menemukan kontroler yang digunakan di halaman lain dan redirect ke halaman itu.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Akses variabel `count` yang telah di update.
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Hasil:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Ini adalah proyek sederhana, namun sudah membuatnya terlihat jelas betapa powerful kemampuan yang dimiliki Get. Sepanjang proyek anda berkembang, perbedaan ini akan menjadi lebih signifikan.

Get di desain untuk bekerja dalam tim, namun juga memudahkan pekerjaan untuk developer perseorangan dan membuatnya menjadi lebih sederhana.

Tingkatkan deadline anda, antarkan semuanya tanpa kehilangan performa. Get bukan untuk semua orang, namun jika anda tersinggung dengan frasa tersebut, Get cocok untukmu!

# Tiga Pilar

## State management

Get memiliki dua state manager berbeda: Simple state manager (kami menyebutnya GetBuilder) dan Reactive state manager (GetX/Obx)

### Reactive State Manager

Reactive programming bisa meng-alienasi banya orang karena katanya, sulit dimengerti. GetX mengubah reactive programming menjadi sesuatu yang cukup sederhana:

- Anda tidak perlu membuat StreamController.
- Anda tidak perlu membuat StreamBuilder untuk setiap variabel.
- Anda tidak perlu membuat kelas untuk setiap state.
- Anda tidak perlu membuat get untuk sebuah value awal (initial value).
- Anda tidak perlu menggunakan generator kode.

Reactive programming dengan Get semudah menggunakan setState.

Bayangkan anda memiliki variabel nama, dan setiap kali anda mengubahnya, semua widget yang menggunakannya akan berubah secara otomatis.

Ini variabel count anda:

```dart
var name = 'Jonatas Borges';
```

Untuk membuatnya "observable", anda hanya perlu menambahkan ".obs" di belakangnya:

```dart
var name = 'Jonatas Borges'.obs;
```

Dan didalam UI, ketika anda ingin menampilkan value dan update tampilan ketika value itu berubah, cukup lakukan ini:

```dart
Obx(() => Text("${controller.name}"));
```

Selesai! _Sesederhana_ itu.

### Detail lebih lanjut mengenai state management

**Baca penjelasan lebih lanjut tentang state management [disini](./documentation/id_ID/state_management.md). Disana anda akan melihat contoh lebih banyak dan juga perbedaan diantara simple state manager dengan reactive state manager**

Anda akan mendapatkan pemahaman yang baik tentang kekuatan dari GetX.

## Route management

Jika anda ingin menggunakan routes/snackbars/dialogs/bottomsheets tanpa context, GetX luar biasa cocok untuk anda, lihat ini:

Tambahkan "Get" sebelum MaterialApp, mengubahnya menjadi GetMaterialApp

```dart
GetMaterialApp( // Sebelumnya: MaterialApp(
  home: MyHome(),
)
```

Pindah ke halaman baru:

```dart

Get.to(NextScreen());
```

Pindah ke halaman baru menggunakan nama. Baca detail lebih lanjut tentang penamaan route [disini](./documentation/id_ID/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
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

Sadarkah bahwa anda tidak menggunakan context sama sekali untuk hal tersebut? Itu adalah keuntungan terbesar dalam menggunakan Get route management. Dengan ini, anda bisa mengeksekusi semua metode dari controller, tanpa ragu.

### Detail lebih lanjut mengenai route management

**Get bekerja dengan named route dan juga menawarkan kontrol dengan level yang lebih rendah untuk navigasimu! Dokumentasinya ada [disini](./documentation/id_ID/route_management.md)**

## Dependency management

Get memiliki dependency manager sederhana dan powerful yang memungkinkan anda mendapatkan kelas yang setara dengan Bloc atau Controller hanya dengan 1 baris kode, tanpa Provider context, tanpa inheritedWidget:

```dart
Controller controller = Get.put(Controller());
```

- Catatan: Jika anda menggunakan State Manager milik Get, harap untuk lebih memperhatikan [Bindings](./documentation/id_ID/dependency_management.md#bindings) api, yang mana akan membuat pengkoneksian View terhadap Controller jadi lebih mudah.

Daripada menginstansiasi kelas anda didalam kelas yang anda gunakan, cukup lakukan hal itu di dalam Get instance, ini akan membuatnya tersedia di semua tempat di Aplikasimu. Jadi anda bisa menggunakan controller (atau class Bloc) secara normal.

**Tips:** Dependency Management Get terpisah dari bagian lain dari package, jadi jika sebagai contoh aplikasi anda sudah menggunakan state manager (tidak peduli apapun itu), anda tidak perlu menulis ulang sama sekali, anda bisa menggunakan dependency injection tanpa masalah.

```dart
controller.fetchApi();
```

Bayangkan anda bernavigasi melewati route yang sangat banyak, dan anda membutuhkan data yang tertinggal didalam controller jauh di belakang route sebelumnya, anda akan butuh state manager dikombinasikan dengan Provider atau Get_it, benar kan? Tidak dengan Get. Anda hanya perlu meminta Get untuk "menemukan" controllernya, anda tidak perlu dependensi tambahan:

```dart
Controller controller = Get.find();
// Ya, terlihat seperti Sulap, Get akan menemukan controller anda, dan akan mengantarkannya ke lokasi anda.
// Anda bisa memiliki 1 juta controller terinisialisasi, Get akan selalu memberimu controller yang tepat.
```

Dan setelahnya anda bisa memperoleh data yang tertinggal sebelumnya:

```dart
Text(controller.textFromApi);
```

### Detail lebih lanjut mengenai dependency management

**Baca penjelasan lebih lanjut tentang dependency management [disini](./documentation/id_ID/dependency_management.md)**

# Utilitas

## Internasionalisasi

### Translasi

Translasi disimpan sebagai key-value map sederhana.
Untuk menambahkan translasi kustom, buat sebuah kelas dan extend `Translations`.

```dart
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
        },
        'id_ID': {
          'hello': 'Halo Dunia',
        }
      };
}
```

#### Menggunakan Translasi

Cukup tambahkan `.tr` setelah key yang disebutkan dan value nya akan diterjemahkan, menggunakan value awal dari `Get.locale` dan `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

### Lokalisasi

Berikan parameter ke `GetMaterialApp` untuk mendefinisikan lokal dan translasi.

```dart
return GetMaterialApp(
    translations: Messages(), // gunakan translasi yang anda buat
    locale: Locale('id', 'ID'), // translasi akan ditampilkan di lokal ini
    fallbackLocale: Locale('en', 'US'), // berikan lokal penumpu untuk berjaga-jaga jika lokal yang tidak valid dipilih
);
```

#### Mengubah Lokal

Panggil `Get.updateLocale(locale)` untuk memperbarui lokal. Setelahnya, translasi akan menggunakan lokal baru.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Lokal Sistem

Untuk membaca lokal sistem, anda bisa menggunakan `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Mengubah Tema

Harap untuk tidak menggunakan widget dengan level lebih tinggi daripada `GetMaterialApp` untuk memperbaruinya. Ini akan menyebabkan "duplicate keys". Banyak orang terbiasa menggunakan cara lama untuk membuat sebuah "ThemeProvider" widget hanya untuk mengubah tema aplikasi anda, dan ini tentu saja TIDAK diperlukan dengan **GetX™**.

Anda bisa membuat tema kustom anda sendiri dan cukup menambahkannya kedalam `Get.changeTheme` tanpa boilerplate:

```dart
Get.changeTheme(ThemeData.light());
```

Jika anda ingin membuat sesuatu seperti tombol yang mengubah Tema ketika `onPressed`, anda bisa mengkombinasikan dua **GetX™** API:

- API yang melakukan pengecekan terhadap tema gelap `Get.isDarkMode`.
- Dan API pengubah tema `Get.changeTheme`, anda cukup meletakannya didalam `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Ketika `.darkmode` aktif, ini akan mengubah aplikasi anda ke _light theme_, dan sebaliknya, jika _light theme_ sedang aktif, ini akan mengubah aplikasi anda ke _dark theme_.

## GetConnect

GetConnect adalah cara mudah untuk berkomunikasi dari backend ke frontend menggunakan http atau websocket.

### Konfigurasi Default

Anda bisa secara sederhana meng-extend GetConnect dan menggunakan GET/POST/PUT/DELETE/SOCKET untuk berkomunikasi dengan REST API atau Websocket anda.

```dart
class UserProvider extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // Post request dengan File
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

### Konfigurasi Kustom

GetConnect sangat bisa di disesuaikan, anda bisa mendefinisikan base URL, Response Modifier, Request Modifier, Authenticator, dan bahkan jumlah percobaan akses ulang (retry) yang mana akan mencoba meng-autentikasi dirinya sendiri, sebagai tambahan, anda juga bisa mendefinisikan dekoder standar yang akan mengubah seluruh request kedalam Model anda tanpa konfigurasi tambahan.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // Semua request akan melewati jsonEncode, jadi, CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // Ini akan men-setting baseUrl ke
    // Http dan websocket jika digunakan tanpa [httpClient]

    // Ini akan mengaitkan properti 'apikey' kedalam header dari semua request.
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Bahkan jika server mengirim data dari negara "Brazil"
    // itu tidak akan pernah ditampilkan ke user, karena anda menghapus
    // data tersebut sebelum response, bahkan sebelum response diantarkan.
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Sesuaikan header
      request.headers['Authorization'] = "$token";
      return request;
    });

    // Authenticator akan dipanggil 3 kali jika
    // HttpStatus == HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

GetPage sekarang memiliki properti baru yang menerima list GetMiddleware dan menjalankannya dalam urutan spesifik.

**Catatan**: Ketika GetPage memiliki middleware, seluruh child dari halaman tersebut akan secara otomatis memiliki middleware yang sama.

### Prioritas

Urutan dari Middleware yang akan dijalankan bisa diatur berdasarkan prioritas didalam GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

middleware diatas akan dijalankan dengan urutan sebagai berikut **-8 => 2 => 4 => 5**

### Redirect

Fungsi ini akan terpanggil ketika halaman dari route yang dipanggil sedang dicari. RouteSettings diperlukan untuk mengatur tujuan dari fungsi redirect. Atau berikan null jika tidak ingin ada redirect.

```dart
GetPage redirect( ) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### OnPageCalled

Fungsi ini akan terpanggil ketika halaman yang dituju dipanggil sebelum apapun dibuat,
anda bisa menggunakannya untuk mengubah sesuatu tentang halaman tersebut atau
berikan halaman baru.

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Fungsi ini akan terpanggil tepat sebelum Binding ter-inisialisasi.
Disini anda bisa mengubah Binding untuk halaman yang dituju.

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

Fungsi ini akan terpanggil tepat setelah Binding ter-inisialisasi.
Disini anda bisa melakukan sesuatu sebelum halaman yang dituju dibuat.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Fungsi ini akan terpanggil tepat setelah fungsi `GetPage.page` terpanggil dan akan memberikan anda hasil dari fungsinya. Dan mengambil widget yang akan ditampilkan.

### OnPageDispose

Fungsi ini akan terpanggil tepat setelah semua objek yang berhubungan (Controller, Views, ...) ter-dispose dari halaman.

## API Lanjutan Lainnya

```dart
// memberikan argument dari halaman yang sedang ditampilkan
Get.arguments

// memberikan nama dari route sebelumnya
Get.previousRoute

// memberikan akses raw route, contoh: rawRoute.isFirst()
Get.rawRoute

// memberikan akses terhadap Routing API dari GetObserver
Get.routing

// cek apakah snackbar sedang tampil
Get.isSnackbarOpen

// cek apakah dialog sedang tampil
Get.isDialogOpen

// cek apakah bottomsheet sedang tampil
Get.isBottomSheetOpen

// hapus satu route
Get.removeRoute()

// kembali berturut-turut hingga predikat mereturn nilai true.
Get.until()

// pergi ke halaman selanjutnya dan hapus semua route sebelumnya hingga predikat mereturn nilai true.
Get.offUntil()

// pergi ke halaman selanjutnya menggunakan nama dan hapus semua route sebelumnya hingga predikat mereturn nilai true.
Get.offNamedUntil()

// Cek di platform apa aplikasi sedang berjalan
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// Cek tipe perangkat
GetPlatform.isMobile
GetPlatform.isDesktop
// Semua platform didukung secara independen di web!
// Anda bisa mengetahui apakah anda menjalankannya didalam browser
// di Windows, iOS, OSX, Android, dsb.
GetPlatform.isWeb


// Sama dengan : MediaQuery.of(context).size.height,
// tapi immutable.
Get.height
Get.width

// Memberikan konteks saat ini dari sebuah Navigator
Get.context

// Memberikan konteks dari snackbar/dialog/bottomsheet di Gives the latar depan, dimanapun di kode anda
Get.contextOverlay

// Catatan: metode berikut adalah sebuah perluasan konteks. Berhubung anda
// memiliki akses terhadap konteks dimanapun di UI anda, anda bisa menggunakannya dimanapun di kode UI

// Jika anda memerlukan height/width yang bisa dirubah (seperti Desktop atau browser yang bisa di sesuaikan) anda akan memerlukan konteks
context.width
context.height

// Memberikan anda kemampuan untuk mendefinisikan separuh layar, sepertiga, dan seterusnya.
// Berguna untuk aplikasi responsive.
// param dibagi dengan (double) optional - default: 1
// param dikurangi dengan (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Mirip seperti MediaQuery.of(context).size
context.mediaQuerySize()

/// Mirip seperti MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Mirip seperti MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Mirip seperti MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Mirip seperti MediaQuery.of(context).orientation;
context.orientation()

/// Cek apakah perangkat sedang dalam mode lansekap
context.isLandscape()

/// Cek apakah perangkat sedang dalam mode portrait
context.isPortrait()

/// Mirip seperti MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Mirip seperti MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Dapatkan shortestSide dari layar
context.mediaQueryShortestSide()

/// True jika layar lebih besar dari 800
context.showNavbar()

/// True jika shortestSide kurang dari 600p
context.isPhone()

/// True jika shortestSide lebih besar dari 600p
context.isSmallTablet()

/// True jika shortestSide lebih besar dari 720p
context.isLargeTablet()

/// True jika perangkat adalah sebuah Tablet
context.isTablet()

/// Memberikan sebuah value<T> berdasarkan ukuran layar
/// dapat memberi value untuk:
/// watch: jika shortestSide lebih kecil dari 300
/// mobile: jika shortestSide lebih kecil dari 600
/// tablet: jika shortestSide lebih kecil dari 1200
/// desktop: jika lebar lebih besar dari 1200
context.responsiveValue<T>()
```

### Pengaturan Global Opsional dan Konfigurasi Manual

GetMaterialApp mengkonfigurasi semuanya untuk anda, namun jika anda ingin mengkonfigurasi Get secara manual.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

Anda juga bisa menggunakan Middleware anda sendiri melalui `GetObserver`, ini tidak akan mempengaruhi apapun.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Disini
  ],
);
```

Anda bisa membuat _Pengaturan Global_ untuk `Get`. Cukup tambahkan `Get.config` kedalam kode anda sebelum berpindah ke route manapun.
Atau lakukan secara langsung di `GetMaterialApp`

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

Anda bisa secara opsional me-redirect seluruh pesan logging dari `Get`.
Jika anda ingin menggunakan logging buatan anda sendiri, logging package favorit,
dan ingin meng-capture lognya:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // oper message ke logging package favorit anda disini
  // harap dicatat bahwa meskipun enableLog: false, pesan log akan di-push dalam callback ini,
  // anda dapat memeriksa flag-nya jika anda mau melalui GetConfig.isLogEnable
}

```

### Local State Widgets

Widget ini memungkinkan anda untuk mengelola satu nilai, dan menjaga state emphemeral dan lokal.
Kita memiliki rasa untuk Reactive dan Simple.
Contohnya, anda mungkin menggunakannya untuk men-toggle obscureText di sebuah `TextField`, mungkin membuat
Expandable Panel kustom, atau mungkin memodifikasi index saat ini dalam `BottomNavigationBar` sembari mengganti konten
dari body didalam `Scaffold`

#### ValueBuilder

Sebuah simplifikasi dari `StatefulWidget` yang berfungsi dengan sebuah callback `.setState` yang menerima value yang telah diperbarui.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // signaturenya sama! anda bisa menggunakan ( newValue ) => updateFn( newValue )
  ),
  // jika anda perlu memanggil sesuatu diluar builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

Mirip seperti [`ValueBuilder`](#valuebuilder), tapi ini versi Reactive nya, anda bisa menaruh Rx instance (ingat .obs?) dan
akan ter-update secara otomatis... keren kan?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx memiliki sebuah _callable_ function! Anda bisa menggunakan (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Tips berguna

`.obs`ervables (juga dikenal sebagai _Rx_ Types) memiliki beragam metode dan operator internal.

> Sangat umum untuk _percaya_ bahwa sebuah properti dengan `.obs` **ADALAH** nilai aktual... jangan salah!
> Kami menghindari Type declaration dari sebuah variabel, karena compiler Dart cukup pintar, dan kode nya
> terlihat lebih bersih, tapi:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Meskipun `message` _mengeluarkan output_ nilai String aktual, tipenya adalah **RxString**!

Jadi, anda tidak bisa melakukan `message.substring( 0, 4 )`.
Anda perlu mengakses `value` aslinya didalam _observable_:
Cara yang paling "sering digunakan" adalah `.value`, tapi, tahukah anda bahwa anda juga bisa menggunakan...

```dart
final name = 'GetX'.obs;
// hanya "memperbarui" stream, jika nilainya berbeda dari sebelumnya.
name.value = 'Hey';

// Seluruh properti Rx "bisa dipanggil" dan akan mereturn nilai baru.
// tapi cara ini tidak menerima `null`, UI-nya tidak akan rebuild.
name('Hello');

// ini seperti getter, mengeluarkan output 'Hello'.
name();

/// angka:

final count = 0.obs;

// Anda bisa menggunakan semua operasi non-mutable dari primitif num!
count + 1;

// Hati hati! ini hanya valid jika `count` tidak final, melainkan var
count += 1;

// Anda juga bisa melakukan komparasi antar nilai:
count > 2;

/// boolean:

final flag = false.obs;

// bertukar nilai antara true/false
flag.toggle();


/// semua tipe:

// Atur `value` menjadi null.
flag.nil();

// Semua operasi toString(), toJson() dikirimkan ke `value`
print( count ); // memanggil `toString()` didalamnya untuk RxInt

final abc = [0,1,2].obs;
// Mengkonversi nilai dari Array json, mengeluarkan output RxList
// Json didukung oleh semua tipe Rx!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList dan RxSet adalah tipe Rx spesial, mereka meng-extends native type masing-masing.
// tapi anda bisa bekerja menggunakan List sebagai list biasa, meskipun reactive!
abc.add(12); // memasukkan 12 kedalam list, dan MEMPERBARUI stream.
abc[3]; // seperti List, membaca index ke 3.


// persamaan berfungsi dengan Rx dan value nya, namun hashCode nya selalu diambil dari value
final number = 12.obs;
print( number == 12 ); // mengeluarkan output: true

/// Model Rx Kustom:

// toJson(), toString() ditangguhkan ke child, jadi anda bisa mengimplementasi override pada mereka dan print() observable nya secara langsung

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` memang "reaktif", tapi properti didalamnya TIDAK REAKTIF!
// Jadi, jika kita mengubah variabel didalamnya...
user.value.name = 'Roi';
// Widget tidak akan rebuild!,
// `Rx` tidak mengetahui apapun ketika anda mengubah sesuatu didalam user.
// Jadi, untuk kelas kustom, kita perlu secara manual "memberi tahu" perubahannya.
user.refresh();

// atau kita bisa menggunakan `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```

#### GetView

Saya menyukai Widget ini, sangat simpel dan berguna!

Adalah sebuah `const Stateless` Widget yang memiliki getter `controller` untuk `Controller` yang terdaftar, itu saja.

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // SELALU ingat untuk memberikan `Type` yang anda gunakan untuk mendaftarkan controller anda!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // cukup panggil `controller.something`
     );
   }
 }
```

#### GetResponsiveView

Extend widget ini untuk membuat responsive view.
widget ini mengandung properti `screen` yang memiliki semua
informasi tentang ukuran layar dan tipenya.

##### Cara pakai

Anda memiliki dua opsi untuk mem-buildnya.

- dengan `builder` method yang anda return ke widget yang akan di-build.
- dengan metode `desktop`, `tablet`,`phone`, `watch`. method
spesifik akan dibuat ketika tipe layar cocok dengan method.
ketika layarnya adalah [ScreenType.Tablet] maka method `tablet`
akan di eksekusi dan seterusnya.
**Catatan:** Jika anda menggunakan metode ini, mohon atur properti `alwaysUseBuilder` ke `false`

Dengan properti `settings` anda bisa mengatur batasan lebar untuk tipe layar.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Kebanyakan orang tidak tahu untuk apa Widget ini, atau benar benar membingungkan penggunaannya.
Kasus penggunaannya sangat langka, namun sangat spesifik: Melakukan `cache` terhadap Controller.
Karena _cache_, tidak bisa dijadikan `const Stateless`.

> Lalu, kapan anda harus men-"cache" sebuah Controller?

Jika anda menggunakan, fitur "tidak terlalu umum" dari **GetX**: `Get.create()`.

`Get.create(()=>Controller())` akan men-generate `Controller` baru setiap kali anda memanggil
`Get.find<Controller>()`,

Itulah dimana `GetWidget` bercahaya... karena anda bisa menggunakannya, sebagai contoh,
untuk menyimpan list dari sebuah Todo item. Jadi, jika widget ter-"rebuild", dia akan meyimpan controller yang sama.

#### GetxService

Kelas ini mirip seperti `GetxController`, dia berbagi lifecycle ( `onInit()`, `onReady()`, `onClose()`).
Tetapi tidak memiliki "logic" didalamnya. Dia hanya memberi tahu Sistem Dependency Injection **GetX**, bahwa subclass
ini **TIDAK BISA** dihapus dari memori.

Jadi ini sangat berguna untuk memastikan "Service" anda selalu dapat dijangkau dan aktif dengan `Get.find()`. Seperti:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Adalah gerakan yang cerdas untuk membuat Service anda menginisialisasi sebelum anda menjalankan aplikasi Flutter
/// seperti anda bisa mengontrol flow eksekusi (mungkin anda perlu memuat beberapa konfigurasi tema,
/// apiKey, bahasa yang ditentukan oleh user...) jadi, load SettingSerice sebelum menjalankan ApiService.
/// supaya GetMaterialApp() tidak perlu rebuild, dan mengambil nilainya secara langsung.
void initServices() async {
  print('starting services ...');
  /// Disini adalah dimana anda meletakkan get_storage, hive, inisialisasi shared_pref.
  /// atau koneksi moor, atau apapun yang sifatnya async.
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

The only way to actually delete a `GetxService`, is with `Get.reset()` which is like a
"Hot Reboot" of your app. So remember, if you need absolute persistence of a class instance during the
lifetime of your app, use `GetxService`.

Satu-satunya cara untuk benar benar menghapus sebuah `GetxService`, adalah dengan `Get.reset()` dimana ini seperti
"Hot Reboot" dari aplikasi anda. Jadi ingat, jika anda butuh persistensi absolut dari sebuah instance kelas selama
masa hidup aplikasi anda, gunakan `GetxService`.

# Breaking change dari 2.0

1- Tipe Rx:

| Sebelum | Sesudah    |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController dan GetBuilder sekarang digabungkan, anda tidak lagi perlu mengingat kontroler mana yang ingin anda gunakan, cukup gunakan GetxController, ini akan bekerja untuk simple state management dan reactive juga.

2- NamedRoutes
Sebelumnya:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Sekarang:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

Mengapa berubah?
Seringkali, mungkin diperlukan untuk memutuskan halaman mana yang akan ditampilkan melalui sebuah parameter, atau login token, cara sebelumnya sangat tidak fleksibel dan tidak memungkinkan untuk melakukan hal ini.
Memasukkan data kedalam fungsi mengurangi konsumsi RAM secara signifikan, mengingat route tidak akan di alokasikan ke memori sejak aplikasi dimulai, dan ini memungkinkan kita melakukan ini:

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

# Mengapa Getx?

1- Seringkali setelah Flutter update, banyak package anda yang akan berhenti bekerja. Terkadang compilation error terjadi, error yang sering muncul dan belum ada jawabannya, dan developer perlu mengetahui dimana errornya berasal, mencari errornya, lalu kemudian mencoba membuka sebuah isu di repository yang bersangkutan, dan melihat apakah problemnya terselesaikan. Get memusatkan resource utama untuk development (State, dependency dan route management), memungkinkan anda untuk menambahkan satu package kedalam pubspec, dan mulai bekerja. Setelah Flutter update, satu-satunya hal yang anda perlu lakukan adalah memperbarui dependensi Get, dan kembali bekerja. Get juga menyelesaikan isu kompatibilitas. Berapa kali sebuah versi dari sebuah package tidak kompatibel dengan versi lainnya, karena yang satu menggunakan sebuah dependensi dalam satu versi, dan yang lain menggunakan versi lainnya? Ini juga bukan sebuah masalah menggunakan Get, yang mana semua berada di package yang sama dan kompatibel secara penuh.

2- Flutter mudah digunakan, Flutter luar biasa, tetapi Flutter masih memiliki beberapa boilerplate yang mungkin tidak diinginkan untuk kebanyakan developer, seperti `Navigator.of(context).push(context builder [...]`. Get menyederhanakan proses development. Daripada menulis 8 baris kode hanya untuk memanggil route, anda bisa menggunakan: `Get.to(Home())` dan selesai, anda akan pergi ke halaman selanjutnya. URL web dinamis adalah hal yang sangat menyakitkan untuk dilakukan dengan Flutter saat ini, dan dengan GetX sangat sederhana. Mengelola state di Flutter, dan megelola dependensi juga suatu hal yang menghasilkan banyak diskusi, dengan ratusan jenis pattern di pub. Tetapi tidak ada yang semudah menambahkan ".obs" di akhir variabel anda, dan meletakkan widget didalam Obx, dan selesai, semua update terhadap variabel tersebut akan secara otomatis terupdate di layar.

3- Meringankan tanpa mengkhawatirkan performa. Performa Flutter sudah luar biasa, tetapi bayangkan anda menggunakan state manager, dan sebuah locator untuk mendistribusikan bloc/store/controller dsb, kelas. Anda perlu secara manual memanggil pengecualian terhadap dependensi ketika anda tidak membutuhkannya. Namun apakah anda pernah terfikirkan ketika simpelnya, anda menggunakan controller, dan tidak lagi digunakan oleh siapapun, akan dihapus dari memori? Itu yang GetX lakukan. Dengan SmartManagement, semua yang tidak digunakan akan dihapus dari memori, dan anda tidak perlu khawatir tentang apapun selain programming. Anda akan terjamin bahwa anda mengkonsumsi resource minimum yang diperlukan, bahkan tanpa harus membuat logic untuk hal ini.

4- Actual decoupling. Anda mungkin pernah mendengar konsep "pisahkan view dari business logic". Ini bukanlah sebuah keanehan dari BLoC, MVC, MVVM, dan standard lainnya dalam market yang memiliki konsep ini. Namun, konsep ini terkadang termitigasi di Flutter karena penggunaan konteks.
Jika anda memerlukan konteks untuk menemukan InheritedWidget, anda membutuhkannya di view, atau mengirim konteks melalui parameter. Saya menemukan bahwa solusi ini sangat jelek, dan untuk bekerja dalam tim kami harus selalu memiliki sebuah ketergantungan pada business logic di dalam view. GetX adalah cara yang tidak lazim dengan metode standard, dan sementara itu tidak benar-benar secara penuh melarang penggunaan StatefulWidgets, InitState, dsb., ini selalu memiliki metode yang mirip dan bisa lebih bersih. Controller memiliki life cycle, dan ketika anda perlu membuat APIREST request sebagai contoh, anda tidak bergantung pada apapun didalam view. Anda bisa menggunakan onInit untuk menginisiasi pemanggilan http dan ketika datanya sampai, variabel akan dipopulasikan. GetX juga secara penuh reaktif (serius, dan bekerja dibawah stream), sekali items terisi, semua widget yang menggunakan variabel itu akan secara otomatis diperbarui didalam view. Ini memungkinkan orang orang dengan keahlian di bagian UI untuk bekerja hanya dengan widget, dan tidak perlu mengirim apapun ke business logic selain user event (seperti meng-klik sebuah tombol), sementara orang yang bekerja dengan business logic akan bebas membuat dan melakukan test terhadap business logic secara terpisah.

Library ini akan terus diperbarui dan mengimplementasikan fitur baru. Jangan ragu untuk menawarkan PR dan berkontribusi ke mereka.

# Komunitas

## Channel Komunitas

GetX memiliki komunitas yang sangat aktif dan membantu. Jika anda memiliki pertanyaan, atau membutuhkan bantuan mengenai penggunaan framework ini, bergabunglah dengan kanal komunitas kami, pertanyaan anda akan dijawab lebih cepat, dan akan menjadi tempat yang paling cocok. Repositori ini eksklusif untuk pembukaan isu dan permintaan resource, tapi jangan ragu untuk menjadi bagian dari Komunitas GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Cara berkontribusi

_Ingin berkontribusi kedalam proyek? Kami akan sangat bangga untuk menyorot anda sebagai salah satu dari kolaborator kami. Ini adalah beberapa point dimana anda bisa berkontribusi dan membuat Get (dan Flutter) jadi lebih baik_

- Membantu menerjemahkan readme ke dalam bahasa lain.
- Menambahkan dokumentasi ke dalam readme (banyak fungsi dari Get yang masih belum terdokumentasi).
- Menulis artikel atau membuat video mengajarkan tentang penggunaan Get (akan dimasukkan kedalam readme dan Wiki kami di masa yang akan datang).
- Menawarkan PR untuk kode/test.
- Menambahkan fungsi baru.

Kontribusi dalam bentuk apapun dipersilahkan!

## Artikel dan Video

- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial oleh [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video oleh Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video oleh Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video oleh Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video oleh Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video oleh Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management oleh [Aachman Garg](https://github.com/imaachman).
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Dependency Injection oleh [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation oleh Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video oleh Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article oleh Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - oleh App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - oleh App With Flutter.

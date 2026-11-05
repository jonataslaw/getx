> GetX 5 RC: Kandidat ini belum diterbitkan. Baseline yang divalidasi adalah Flutter 3.47.9 dan Dart 3.13.7 dengan pustaka UI bawaan Flutter.

[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Bahasa: Indonesia (file ini), [Inggris](README.md), [Orang Vietnam](README-vi.md), [Urdu](README.ur-PK.md), [China](README.zh-cn.md), [Portugis (Brazil)](README.pt-br.md), [Spanyol](README-es.md), [Russia](README.ru.md), [Polandia](README.pl.md), [Korea](README.ko-kr.md), [French](README-fr.md)**

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

## Daftar isi

  - [Perubahan GetX 5 pada cabang ini](#getx5-current)
- [Tentang Get](#readme-section-2)
- [Instalasi](#readme-section-3)
- [Aplikasi Counter menggunakan GetX](#readme-section-4)
- [Tiga Pilar](#readme-section-5)
  - [State management](#readme-section-6)
    - [Reactive State Manager](#readme-section-7)
    - [Detail lebih lanjut mengenai state management](#readme-section-8)
  - [Route management](#readme-section-9)
    - [Detail lebih lanjut mengenai route management](#readme-section-10)
  - [Dependency management](#readme-section-11)
    - [Detail lebih lanjut mengenai dependency management](#readme-section-12)
- [Utilitas](#readme-section-13)
  - [Internasionalisasi](#readme-section-14)
    - [Translasi](#readme-section-15)
    - [Menggunakan Translasi](#readme-section-16)
    - [Lokalisasi](#readme-section-17)
    - [Mengubah Lokal](#readme-section-18)
    - [Lokal Sistem](#readme-section-19)
  - [Mengubah Tema](#readme-section-20)
  - [GetConnect](#readme-section-21)
    - [Konfigurasi Default](#readme-section-22)
    - [Konfigurasi Kustom](#readme-section-23)
  - [GetPage Middleware](#readme-section-24)
    - [Prioritas](#readme-section-25)
    - [Redirect](#readme-section-26)
    - [OnPageCalled](#readme-section-27)
    - [OnBindingsStart](#readme-section-28)
    - [OnPageBuildStart](#readme-section-29)
    - [OnPageBuilt](#readme-section-30)
    - [OnPageDispose](#readme-section-31)
  - [API Lanjutan Lainnya](#readme-section-32)
    - [Pengaturan Global Opsional dan Konfigurasi Manual](#readme-section-33)
    - [Local State Widgets](#readme-section-34)
    - [ValueBuilder](#readme-section-35)
    - [ObxValue](#readme-section-36)
  - [Tips berguna](#readme-section-37)
    - [GetView](#readme-section-38)
    - [GetResponsiveView](#readme-section-39)
    - [Cara pakai](#readme-section-40)
    - [GetWidget](#readme-section-41)
    - [GetxService](#readme-section-42)
- [Breaking change dari 2.0](#readme-section-43)
- [Mengapa Getx?](#readme-section-44)
- [Komunitas](#readme-section-45)
  - [Channel Komunitas](#readme-section-46)
  - [Cara berkontribusi](#readme-section-47)
  - [Artikel dan Video](#readme-section-48)

<a id="getx5-current"></a>

## Perubahan GetX 5 pada cabang ini

Kandidat ini belum diterbitkan. Baseline yang divalidasi adalah Flutter 3.47.9 dan Dart 3.13.7 dengan pustaka UI bawaan Flutter.

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

Binding mengembalikan `List<Bind>`. Gunakan binds pada aplikasi dan bindings pada route. Get.spawn menggantikan Get.create; tunggu inisialisasi async lalu daftarkan nilainya dengan Get.put.

```dart
class RcNamesController extends GetxController with StateMixin<List<String>> {
  final labels = RxSet<String>();

  void showNames(List<String> names) =>
      change(GetStatus<List<String>>.success(names));

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
}

class RcNamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<RcNamesController>(() => RcNamesController()),
  ];
}

Widget rcNamesApplication() => GetMaterialApp(
  restorationScopeId: 'names-app',
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      restorationId: 'names',
      bindings: [RcNamesBinding()],
      page: () => Scaffold(
        body: Get.find<RcNamesController>().obx(
          (names) => Text(names.join(', ')),
          onEmpty: const Text('No data'),
          onError: (error) => Text(error ?? 'Unknown error'),
        ),
      ),
    ),
  ],
);
```

`GetStatus<T>.success(data)` membawa data sukses. futurize menerima fungsi pembuat Future dan mengembalikan void; hasil diterapkan menurut urutan selesai. Koleksi Rx kosong memiliki penyimpanan mutable terpisah.

Navigasi memakai Navigator 2. Get.back kembali antarhalaman; gunakan helper khusus untuk dialog, sheet, dan snackbar. Get.context serta Get.overlayContext dapat null di luar masa hidup aplikasi.

Aktifkan restorationScopeId dan restorationId stabil untuk memulihkan riwayat route bernama. Argumen harus sesuai JSON, dengan batas ukuran dan middleware; proses baru membuat controller dan Future baru.

Penghapusan response modifier serta error autentikasi, timeout, pembatalan, dan decoding diperbaiki. HTTP/WebSocket diuji pada IO, browser, dan JS/WASM dengan pembersihan sumber daya.

Batasan percent-encoding browser history pada Flutter 3.47.9 tetap didokumentasikan; web test biasa tidak membuktikannya selesai. Uji refresh, back, dan restoration pada host/perangkat sebenarnya.

Atur GetMaterialApp atau GetCupertinoApp, bukan Get.config lama. Router khusus membutuhkan konfigurasi Navigator 2 yang lengkap.

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# Tentang Get

- GetX adalah solusi ekstra-ringan dan powerful untuk Flutter. Ini mengkombinasikan state management dengan performa tinggi, injeksi dependensi yang cerdas, dan route management secara singkat dan praktis.

- GetX memiliki 3 prinsip dasar, yang menjadi prioritas untuk semua resource yang ada di dalamnya: **PRODUKTIFITAS, PERFORMA DAN ORGANISASI**

  - **Performa:** GetX menyediakan API reaktif dan stream tanpa membuat StreamController/StreamBuilder manual untuk setiap nilai. Pilih Obx atau GetBuilder sesuai pembaruan dan ukur rebuild serta sumber daya aplikasi.

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

<a id="readme-section-3"></a>

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

<a id="readme-section-4"></a>

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
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(() => Other()))),
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

<a id="readme-section-5"></a>

# Tiga Pilar

<a id="readme-section-6"></a>

## State management

Get memiliki dua state manager berbeda: Simple state manager (kami menyebutnya GetBuilder) dan Reactive state manager (GetX/Obx)

<a id="readme-section-7"></a>

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

<a id="readme-section-8"></a>

### Detail lebih lanjut mengenai state management

**Baca penjelasan lebih lanjut tentang state management [disini](./documentation/id_ID/state_management.md). Disana anda akan melihat contoh lebih banyak dan juga perbedaan diantara simple state manager dengan reactive state manager**

Anda akan mendapatkan pemahaman yang baik tentang kekuatan dari GetX.

<a id="readme-section-9"></a>

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

Get.to(() => NextScreen());
```

Pindah ke halaman baru menggunakan nama. Baca detail lebih lanjut tentang penamaan route [disini](./documentation/id_ID/route_management.md)

```dart

Get.toNamed('/details');
```

Untuk menutup snackbar, dialog, bottomsheet, atau apapun yang normalnya anda tutup menggunakan Navigator.pop(context);

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

Untuk pergi ke halaman baru dan mencegah user kembali ke halaman sebelumnya (biasanya digunakan untuk SplashScreen, LoginScreen, dsb).

```dart
Get.off(() => NextScreen());
```

Untuk pergi ke halaman baru dan batalkan navigasi sebelumnya (berguna untuk shopping cart, polls, dan test).

```dart
Get.offAll(() => NextScreen());
```

Sadarkah bahwa anda tidak menggunakan context sama sekali untuk hal tersebut? Itu adalah keuntungan terbesar dalam menggunakan Get route management. Dengan ini, anda bisa mengeksekusi semua metode dari controller, tanpa ragu.

<a id="readme-section-10"></a>

### Detail lebih lanjut mengenai route management

**Get bekerja dengan named route dan juga menawarkan kontrol dengan level yang lebih rendah untuk navigasimu! Dokumentasinya ada [disini](./documentation/id_ID/route_management.md)**

<a id="readme-section-11"></a>

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

<a id="readme-section-12"></a>

### Detail lebih lanjut mengenai dependency management

**Baca penjelasan lebih lanjut tentang dependency management [disini](./documentation/id_ID/dependency_management.md)**

<a id="readme-section-13"></a>

# Utilitas

<a id="readme-section-14"></a>

## Internasionalisasi

<a id="readme-section-15"></a>

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

<a id="readme-section-16"></a>

#### Menggunakan Translasi

Cukup tambahkan `.tr` setelah key yang disebutkan dan value nya akan diterjemahkan, menggunakan value awal dari `Get.locale` dan `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

<a id="readme-section-17"></a>

### Lokalisasi

Berikan parameter ke `GetMaterialApp` untuk mendefinisikan lokal dan translasi.

```dart
return GetMaterialApp(
    translations: Messages(), // gunakan translasi yang anda buat
    locale: Locale('id', 'ID'), // translasi akan ditampilkan di lokal ini
    fallbackLocale: Locale('en', 'US'), // berikan lokal penumpu untuk berjaga-jaga jika lokal yang tidak valid dipilih
);
```

<a id="readme-section-18"></a>

#### Mengubah Lokal

Panggil `Get.updateLocale(locale)` untuk memperbarui lokal. Setelahnya, translasi akan menggunakan lokal baru.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-19"></a>

#### Lokal Sistem

Untuk membaca lokal sistem, anda bisa menggunakan `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

<a id="readme-section-20"></a>

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

<a id="readme-section-21"></a>

## GetConnect

GetConnect adalah cara mudah untuk berkomunikasi dari backend ke frontend menggunakan http atau websocket.

<a id="readme-section-22"></a>

### Konfigurasi Default

Anda bisa secara sederhana meng-extend GetConnect dan menggunakan GET/POST/PUT/DELETE/SOCKET untuk berkomunikasi dengan REST API atau Websocket anda.

```dart
class ApiUser {
  ApiUser(this.name);
  final String name;

  static ApiUser fromJson(dynamic data) =>
      ApiUser((data as Map<String, dynamic>)['name'] as String);
}

class UserProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response<ApiUser>> getUser(int id) =>
      get<ApiUser>('/users/$id', decoder: ApiUser.fromJson);

  Future<Response<dynamic>> createUser(String name) =>
      post<dynamic>('/users', {'name': name});

  Future<Response<dynamic>> uploadAvatar(List<int> bytes) =>
      post<dynamic>('/upload', FormData({
        'file': MultipartFile(bytes, filename: 'avatar.png'),
      }));
}
```

<a id="readme-section-23"></a>

### Konfigurasi Kustom

GetConnect sangat bisa di disesuaikan, anda bisa mendefinisikan base URL, Response Modifier, Request Modifier, Authenticator, dan bahkan jumlah percobaan akses ulang (retry) yang mana akan mencoba meng-autentikasi dirinya sendiri, sebagai tambahan, anda juga bisa mendefinisikan dekoder standar yang akan mengubah seluruh request kedalam Model anda tanpa konfigurasi tambahan.

```dart
class HomeProvider extends GetConnect {
  HomeProvider(this.token);
  final String Function() token;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
    httpClient.addResponseModifier<dynamic>((request, response) {
      Get.log('HTTP status: ${response.statusCode}');
      return response;
    });
    httpClient.addAuthenticator<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token()}';
      return request;
    });
    httpClient.maxAuthRetries = 2;
  }

  Future<Response<Map<String, dynamic>>> getCases(String path) =>
      get<Map<String, dynamic>>(path);
}
```

<a id="readme-section-24"></a>

## GetPage Middleware

GetPage sekarang memiliki properti baru yang menerima list GetMiddleware dan menjalankannya dalam urutan spesifik.

**Catatan**: Ketika GetPage memiliki middleware, seluruh child dari halaman tersebut akan secara otomatis memiliki middleware yang sama.

<a id="readme-section-25"></a>

### Prioritas

Urutan dari Middleware yang akan dijalankan bisa diatur berdasarkan prioritas didalam GetMiddleware.

```dart
class PriorityMiddleware extends GetMiddleware {
  PriorityMiddleware({super.priority});
}

final middlewares = [
  PriorityMiddleware(priority: 2),
  PriorityMiddleware(priority: 5),
  PriorityMiddleware(priority: 4),
  PriorityMiddleware(priority: -8),
];
```

middleware diatas akan dijalankan dengan urutan sebagai berikut **-8 => 2 => 4 => 5**

<a id="readme-section-26"></a>

### Redirect

Pada redirectDelegate, kembalikan route untuk lanjut, RouteDecoder lain untuk redirect, atau null untuk batal. Daftarkan login dan hindari loop.

```dart
class AuthService extends GetxService {
  final authed = false.obs;
}

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({super.priority});

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final auth = Get.find<AuthService>();
    return auth.authed.value ? route : RouteDecoder.fromRoute('/login');
  }
}
```

<a id="readme-section-27"></a>

### OnPageCalled

Fungsi ini akan terpanggil ketika halaman yang dituju dipanggil sebelum apapun dibuat,
anda bisa menggunakannya untuk mengubah sesuatu tentang halaman tersebut atau
berikan halaman baru.

```dart
class PageTitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Welcome');
}
```

<a id="readme-section-28"></a>

### OnBindingsStart

Fungsi ini akan terpanggil tepat sebelum Binding ter-inisialisasi.
Disini anda bisa mengubah Binding untuk halaman yang dituju.

```dart
class BindingMiddleware extends GetMiddleware {
  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);
}
```

<a id="readme-section-29"></a>

### OnPageBuildStart

Fungsi ini akan terpanggil tepat setelah Binding ter-inisialisasi.
Disini anda bisa melakukan sesuatu sebelum halaman yang dituju dibuat.

```dart
class BuildMiddleware extends GetMiddleware {
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;
}
```

<a id="readme-section-30"></a>

### OnPageBuilt

Fungsi ini akan terpanggil tepat setelah fungsi `GetPage.page` terpanggil dan akan memberikan anda hasil dari fungsinya. Dan mengambil widget yang akan ditampilkan.

<a id="readme-section-31"></a>

### OnPageDispose

Fungsi ini akan terpanggil tepat setelah semua objek yang berhubungan (Controller, Views, ...) ter-dispose dari halaman.

<a id="readme-section-32"></a>

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
Get.removeRoute('/details')

// kembali berturut-turut hingga predikat mereturn nilai true.
Get.until((page) => page.name == '/home')

// pergi ke halaman selanjutnya dan hapus semua route sebelumnya hingga predikat mereturn nilai true.
Get.offUntil(() => const Scaffold(), (page) => page.name == '/home')

// pergi ke halaman selanjutnya menggunakan nama dan hapus semua route sebelumnya hingga predikat mereturn nilai true.
Get.offNamedUntil('/details', (page) => page.name == '/home')

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
Get.overlayContext

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
context.mediaQuerySize

/// Mirip seperti MediaQuery.of(context).padding
context.mediaQueryPadding

/// Mirip seperti MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding

/// Mirip seperti MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets

/// Mirip seperti MediaQuery.of(context).orientation;
context.orientation

/// Cek apakah perangkat sedang dalam mode lansekap
context.isLandscape

/// Cek apakah perangkat sedang dalam mode portrait
context.isPortrait

/// Mirip seperti MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio

/// Mirip seperti MediaQuery.of(context).textScaleFactor;
context.textScaleFactor

/// Dapatkan shortestSide dari layar
context.mediaQueryShortestSide

/// True jika layar lebih besar dari 800
context.showNavbar

/// True jika shortestSide kurang dari 600p
context.isPhone

/// True jika shortestSide lebih besar dari 600p
context.isSmallTablet

/// True jika shortestSide lebih besar dari 720p
context.isLargeTablet

/// True jika perangkat adalah sebuah Tablet
context.isTablet

/// Memberikan sebuah value<T> berdasarkan ukuran layar
/// dapat memberi value untuk:
/// watch: jika shortestSide lebih kecil dari 300
/// mobile: jika shortestSide lebih kecil dari 600
/// tablet: jika shortestSide lebih kecil dari 1200
/// desktop: jika lebar lebih besar dari 1200
context.responsiveValue<T>()
```

<a id="readme-section-33"></a>

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

Atur GetMaterialApp atau GetCupertinoApp, bukan Get.config lama. Router khusus membutuhkan konfigurasi Navigator 2 yang lengkap.

```dart
Widget configuredApplication() => GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 250),
  popGesture: true,
  logWriterCallback: localLogWriter,
  routingCallback: (routing) {
    if (routing != null) {
      debugPrint('Route: ${routing.current}');
    }
  },
  home: const Scaffold(body: Text('Configuration')),
);

void localLogWriter(String text, {bool isError = false}) {
  debugPrint('${isError ? "ERROR" : "GETX"}: $text');
}
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

<a id="readme-section-34"></a>

### Local State Widgets

Widget ini memungkinkan anda untuk mengelola satu nilai, dan menjaga state emphemeral dan lokal.
Kita memiliki rasa untuk Reactive dan Simple.
Contohnya, anda mungkin menggunakannya untuk men-toggle obscureText di sebuah `TextField`, mungkin membuat
Expandable Panel kustom, atau mungkin memodifikasi index saat ini dalam `BottomNavigationBar` sembari mengganti konten
dari body didalam `Scaffold`

<a id="readme-section-35"></a>

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

<a id="readme-section-36"></a>

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

<a id="readme-section-37"></a>

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
class Person {
  Person({required this.name});
  String name;
}

void reactiveExamples() {
  final name = 'GetX'.obs;
  name.value = 'Hello';
  final enabled = false.obs;
  enabled.toggle();

  final items = RxList<int>()..add(1);
  final counters = RxMap<String, int>()..['visits'] = 1;
  final labels = RxSet<String>()..add('new');
  items.assignAll(items.where((value) => value > 0));

  final person = Person(name: 'Sara').obs;
  person.update((previous) => Person(name: '${previous!.name}!'));

  name.close();
  enabled.close();
  items.close();
  counters.close();
  labels.close();
  person.close();
}
```

<a id="readme-section-38"></a>

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

<a id="readme-section-39"></a>

#### GetResponsiveView

Extend widget ini untuk membuat responsive view.
widget ini mengandung properti `screen` yang memiliki semua
informasi tentang ukuran layar dan tipenya.

<a id="readme-section-40"></a>

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

<a id="readme-section-41"></a>

#### GetWidget

GetWidget menyimpan controller untuk instance widget tersebut dan mendukung const. Dengan Get.spawn, controller ditutup saat widget pemilik dihapus. GetView melakukan lookup tanpa cache tersebut.

```dart
class ItemController extends GetxController {
  final label = 'Item'.obs;
}

void registerItemFactory() => Get.spawn<ItemController>(() => ItemController());

class ItemView extends GetWidget<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Text(controller.label.value));
}
```

<a id="readme-section-42"></a>

#### GetxService

GetxService menyediakan onInit/onReady/onClose untuk layanan sepanjang umur aplikasi. Penghapusan biasa melindunginya; force atau Get.reset dapat membersihkannya secara sengaja. Ini bukan penyimpanan setelah proses mati. Tunggu init lalu Get.put.

```dart
class DbService extends GetxService {
  Future<DbService> init() async => this;
}

class SettingsService extends GetxService {
  Future<SettingsService> init() async => this;
}

Future<void> initServices() async {
  final database = await DbService().init();
  Get.put<DbService>(database, permanent: true);
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
}

Future<void> startApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(home: const Scaffold(body: Text('Ready'))));
}
```

<a id="readme-section-43"></a>

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

```text
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

<a id="readme-section-44"></a>

# Mengapa Getx?

1- Seringkali setelah Flutter update, banyak package anda yang akan berhenti bekerja. Terkadang compilation error terjadi, error yang sering muncul dan belum ada jawabannya, dan developer perlu mengetahui dimana errornya berasal, mencari errornya, lalu kemudian mencoba membuka sebuah isu di repository yang bersangkutan, dan melihat apakah problemnya terselesaikan. Get memusatkan resource utama untuk development (State, dependency dan route management), memungkinkan anda untuk menambahkan satu package kedalam pubspec, dan mulai bekerja. Setelah Flutter update, satu-satunya hal yang anda perlu lakukan adalah memperbarui dependensi Get, dan kembali bekerja. Get juga menyelesaikan isu kompatibilitas. Berapa kali sebuah versi dari sebuah package tidak kompatibel dengan versi lainnya, karena yang satu menggunakan sebuah dependensi dalam satu versi, dan yang lain menggunakan versi lainnya? Ini juga bukan sebuah masalah menggunakan Get, yang mana semua berada di package yang sama dan kompatibel secara penuh.

2- Flutter mudah digunakan, Flutter luar biasa, tetapi Flutter masih memiliki beberapa boilerplate yang mungkin tidak diinginkan untuk kebanyakan developer, seperti `Navigator.of(context).push(context builder [...]`. Get menyederhanakan proses development. Daripada menulis 8 baris kode hanya untuk memanggil route, anda bisa menggunakan: `Get.to(() => Home())` dan selesai, anda akan pergi ke halaman selanjutnya. URL web dinamis adalah hal yang sangat menyakitkan untuk dilakukan dengan Flutter saat ini, dan dengan GetX sangat sederhana. Mengelola state di Flutter, dan megelola dependensi juga suatu hal yang menghasilkan banyak diskusi, dengan ratusan jenis pattern di pub. Tetapi tidak ada yang semudah menambahkan ".obs" di akhir variabel anda, dan meletakkan widget didalam Obx, dan selesai, semua update terhadap variabel tersebut akan secara otomatis terupdate di layar.

3- Meringankan tanpa mengkhawatirkan performa. Performa Flutter sudah luar biasa, tetapi bayangkan anda menggunakan state manager, dan sebuah locator untuk mendistribusikan bloc/store/controller dsb, kelas. Anda perlu secara manual memanggil pengecualian terhadap dependensi ketika anda tidak membutuhkannya. Namun apakah anda pernah terfikirkan ketika simpelnya, anda menggunakan controller, dan tidak lagi digunakan oleh siapapun, akan dihapus dari memori? Itu yang GetX lakukan. Dengan SmartManagement, semua yang tidak digunakan akan dihapus dari memori, dan anda tidak perlu khawatir tentang apapun selain programming. Anda akan terjamin bahwa anda mengkonsumsi resource minimum yang diperlukan, bahkan tanpa harus membuat logic untuk hal ini.

4- Actual decoupling. Anda mungkin pernah mendengar konsep "pisahkan view dari business logic". Ini bukanlah sebuah keanehan dari BLoC, MVC, MVVM, dan standard lainnya dalam market yang memiliki konsep ini. Namun, konsep ini terkadang termitigasi di Flutter karena penggunaan konteks.
Jika anda memerlukan konteks untuk menemukan InheritedWidget, anda membutuhkannya di view, atau mengirim konteks melalui parameter. Saya menemukan bahwa solusi ini sangat jelek, dan untuk bekerja dalam tim kami harus selalu memiliki sebuah ketergantungan pada business logic di dalam view. GetX adalah cara yang tidak lazim dengan metode standard, dan sementara itu tidak benar-benar secara penuh melarang penggunaan StatefulWidgets, InitState, dsb., ini selalu memiliki metode yang mirip dan bisa lebih bersih. Controller memiliki life cycle, dan ketika anda perlu membuat APIREST request sebagai contoh, anda tidak bergantung pada apapun didalam view. Anda bisa menggunakan onInit untuk menginisiasi pemanggilan http dan ketika datanya sampai, variabel akan dipopulasikan. GetX juga secara penuh reaktif (serius, dan bekerja dibawah stream), sekali items terisi, semua widget yang menggunakan variabel itu akan secara otomatis diperbarui didalam view. Ini memungkinkan orang orang dengan keahlian di bagian UI untuk bekerja hanya dengan widget, dan tidak perlu mengirim apapun ke business logic selain user event (seperti meng-klik sebuah tombol), sementara orang yang bekerja dengan business logic akan bebas membuat dan melakukan test terhadap business logic secara terpisah.

Library ini akan terus diperbarui dan mengimplementasikan fitur baru. Jangan ragu untuk menawarkan PR dan berkontribusi ke mereka.

<a id="readme-section-45"></a>

# Komunitas

<a id="readme-section-46"></a>

## Channel Komunitas

GetX memiliki komunitas yang sangat aktif dan membantu. Jika anda memiliki pertanyaan, atau membutuhkan bantuan mengenai penggunaan framework ini, bergabunglah dengan kanal komunitas kami, pertanyaan anda akan dijawab lebih cepat, dan akan menjadi tempat yang paling cocok. Repositori ini eksklusif untuk pembukaan isu dan permintaan resource, tapi jangan ragu untuk menjadi bagian dari Komunitas GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="readme-section-47"></a>

## Cara berkontribusi

_Ingin berkontribusi kedalam proyek? Kami akan sangat bangga untuk menyorot anda sebagai salah satu dari kolaborator kami. Ini adalah beberapa point dimana anda bisa berkontribusi dan membuat Get (dan Flutter) jadi lebih baik_

- Membantu menerjemahkan readme ke dalam bahasa lain.
- Menambahkan dokumentasi ke dalam readme (banyak fungsi dari Get yang masih belum terdokumentasi).
- Menulis artikel atau membuat video mengajarkan tentang penggunaan Get (akan dimasukkan kedalam readme dan Wiki kami di masa yang akan datang).
- Menawarkan PR untuk kode/test.
- Menambahkan fungsi baru.

Kontribusi dalam bentuk apapun dipersilahkan!

<a id="readme-section-48"></a>

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

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Bahasa**


[![Bahasa Inggris](https://img.shields.io/badge/Bahasa-Inggris-blueviolet?style=for-the-badge)](README.md)
[![Bahasa Vietnam](https://img.shields.io/badge/Bahasa-Vietnam-blueviolet?style=for-the-badge)](README-vi.md)
[![Bahasa Indonesia](https://img.shields.io/badge/Bahasa-Indonesia-blueviolet?style=for-the-badge)](README.id-ID.md)
[![Bahasa Urdu](https://img.shields.io/badge/Bahasa-Urdu-blueviolet?style=for-the-badge)](README.ur-PK.md)
[![Bahasa Cina](https://img.shields.io/badge/Bahasa-China-blueviolet?style=for-the-badge)](README.zh-cn.md)
[![Bahasa Portugal](https://img.shields.io/badge/Bahasa-Portugal-blueviolet?style=for-the-badge)](README.pt-br.md)
[![Bahasa Spanyol](https://img.shields.io/badge/Bahasa-Spanyol-blueviolet?style=for-the-badge)](README-es.md)
[![Bahasa Rusia](https://img.shields.io/badge/Bahasa-Rusia-blueviolet?style=for-the-badge)](README.ru.md)
[![Bahasa Polandia](https://img.shields.io/badge/Bahasa-Polandia-blueviolet?style=for-the-badge)](README.pl.md)
[![Bahasa Korea](https://img.shields.io/badge/Bahasa-Korea-blueviolet?style=for-the-badge)](README.ko-kr.md)
[![Bahasa Prancis](https://img.shields.io/badge/Bahasa-Prancis-blueviolet?style=for-the-badge)](README-fr.md)
[![Bahasa Jepang](https://img.shields.io/badge/Bahasa-Jepang-blueviolet?style=for-the-badge)](README.ja-JP.md)
[![Bahasa Hindi](https://img.shields.io/badge/Bahasa-Hindi-blueviolet?style=for-the-badge)](README-hi.md)
[![Bahasa Bangladesh](https://img.shields.io/badge/Bahasa-Bangladesh-blueviolet?style=for-the-badge)](README-bn.md)

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![popularitas](https://img.shields.io/pub/popularity/get?logo=dart)](https://pub.dev/packages/get/score)
[![jumlah suka](https://img.shields.io/pub/likes/get?logo=dart)](https://pub.dev/packages/get/score)
[![poin pub](https://img.shields.io/pub/points/sentry?logo=dart)](https://pub.dev/packages/get/score)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)
[![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)
<a href="https://github.com/Solido/awesome-flutter">
<img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>


<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)

- [Tentang GetX](#tentang-get)
- [Instalasi](#instalasi)
- [Membuat Aplikasi Counter menggunakan GetX](#aplikasi-counter-menggunakan-getx)
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
  - [Lainnya mengenai API Tingkat Lanjut](#api-lanjutan-lainnya)
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
- [Perubahan Besar dari 2.0](#breaking-change-dari-20)
- [Mengapa Getx?](#mengapa-getx)
- [Komunitas](#komunitas)
  - [Channel Komunitas](#kanal-komunitas)
  - [Cara berkontribusi](#cara-berkontribusi)
  - [Artikel dan Video](#artikel-dan-video)

# Tentang Get

- GetX adalah solusi ekstra-ringan dan powerful untuk Flutter. Mengkombinasikan state management dengan performa tinggi, injeksi dependensi yang cerdas, dan route management secara singkat dan praktis.

- GetX memiliki 3 prinsip dasar, yang menjadi prioritas untuk semua resource yang ada di dalamnya: **PRODUKTIFITAS, PERFORMA DAN ORGANISASI**

  - **PERFORMA:** GetX fokus pada performa dan minim konsumsi resource. GetX tidak menggunakan Stream atau ChangeNotifier.

  - **PRODUKTIFITAS:** GetX menggunakan sintaks yang mudah dan sederhana. Tidak peduli apa yang kita lakukan, akan selalu ada cara yang lebih mudah dengan GetX. Ini akan menghemat waktu development, dan meningkatkan performa pada aplikasimu.
  Umumnya, developer akan selalu berhubungan dengan penghapusan controller dari memori. Dengan GetX, ini tidak diperlukan, karena resource akan dihapus dari memori secara default ketika tidak digunakan. Jika kita ingin menyimpannya kedalam memori, kita harus secara eksplisit mendeklarasikan "permanent: true" pada dependensi. Dengan begitu, selain menghemat waktu, kita juga mengurangi resiko memiliki dependensi yang tidak diperlukan dalam memori. Pemuatan dependensi juga bersifat "lazy" secara default.

  - **ORGANISASI:** GetX memungkinkan kita memisahkan View, Presentation Logic, Business Logic, Dependency Injection, dan Navigasi.
  Kita tidak perlu lagi konteks untuk berpindah antar halaman. Jadi tidak lagi bergantung pada widget tree (visualisasi). Kita tidak perlu konteks untuk mengakses controller/bloc melalui InheritedWidget. Dengan ini, kita benar benar memisahkan presentation logic dan business logic dari lapisan visual. Kita tidak perlu menginjeksi kelas Controller/Model/Bloc kedalam widget tree melalui multiprovider, untuk hal ini GetX menggunakan fitur dependency injection nya sendiri, memisahkan Dependency Injection dari View secara total.
  Dengan GetX, kita tahu dimana harus mencari setiap fitur dalam aplikasimu, memiliki kode yang _clean_ secara default. Selain untuk memfasilitasi _maintenance_, membuat pembagian modul, sesuatu yang hingga saat itu di Flutter tidak terpikirkan, ternyata sesuatu yang sangat mungkin.
  BLoC adalah permulaan awal dalam meng-organisir kode di Flutter, ini memisahkan business logic dari visualisasi. GetX adalah evolusi dari ini, tidak hanya memisahkan business logic, tapi juga presentation logic, injeksi dependensi dan route juga dipisahkan sebagai bonus, dan lapisan data benar-benar terpisah secara menyeluruh. Kita tahu dimana semuanya berada, dan segalanya dengan cara yang lebih mudah daripada membuat sebuah hello world.
  GetX adalah cara termudah, praktis, dan scalable untuk membangun aplikasi dengan performa tinggi menggunakan Flutter SDK, dengan ekosistem besar di sekelilingnya yang bekerjasama secara sempurna, _beginner friendly_, dan akurat untuk profesional. Aman, stabil, _up-to-date_, dan menawarkan banyak cakupan build-in API yang tidak tersedia di dalam default Flutter SDK.

- GetX tidak boros. GetX memiliki banyak fitur yang memungkinkan Anda memulai pemrograman tanpa perlu mengkhawatirkan apa pun, tetapi setiap fitur ini berada dalam wadah terpisah dan hanya dimulai setelah digunakan. Jika Anda hanya menggunakan State Management, hanya State Management yang akan dikompilasi. Jika Anda hanya menggunakan rute, tidak ada yang akan dikompilasi dari state management.

- GetX memiliki ekosistem yang besar, komunitas yang juga besar, banyak kolaborator, dan akan di maintenance selama Flutter ada. GetX juga mampu berjalan dengan kode yang sama di Android, iOS, Web, Mac, Linux, Windows, dan server kita.
**Juga memungkinkan untuk me-reuse kode yang dibuat di frontend ke backend dengan [Get Server](https://github.com/jonataslaw/get_server)**.

**Selain itu, seluruh proses pengembangan dapat sepenuhnya diotomatisasi, baik di server maupun di front end dengan [Get CLI](https://github.com/jonataslaw/get_cli)**.

**Selain itu, untuk lebih meningkatkan produktifitas, kami memiliki [ekstensi untuk VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) dan [ekstensi untuk Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# Instalasi

Tambahkan Get kedalam file `pubspec.yaml`:

```yaml
dependencies:
  get:
```

Import get didalam file dimana get akan digunakan:

```dart
import 'package:get/get.dart';
```

# Aplikasi Counter menggunakan GetX

Proyek “ counter ” yang dibuat secara default pada proyek baru di Flutter memiliki lebih dari 100 baris (dengan komentar). Untuk menunjukkan kekuatan Get, saya akan mendemonstrasikan cara membuat “penghitung” yang akan mengubah status pada saat diklik, berpindah antar halaman dan berbagi status antar layar, semuanya dengan cara yang terorganisir, memisahkan logika bisnis dari view, HANYA dengan 26 BARIS KODE TERMASUK KOMENTAR.

- Langkah 1:
  Tambahkan "Get" sebelum MaterialApp, mengubahnya menjadi GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Catatan: ini tidak mengubah MaterialApp dari Flutter, GetMaterialApp bukanlah MaterialApp yang dimodifikasi, ini hanyalah Widget yang sudah dikonfigurasi sebelumnya, yang memiliki MaterialApp default sebagai child. Kita dapat mengkonfigurasi ini secara manual, tetapi tidak diperlukan. GetMaterialApp akan membuat rute, menginjeksi mereka, menginjeksi terjemahan, menginjeksi semua yang Anda butuhkan untuk navigasi route. Jika Anda menggunakan Get hanya untuk manajemen state atau manajemen dependency, Anda tidak perlu menggunakan GetMaterialApp. GetMaterialApp diperlukan untuk rute, snackbar, internasionalisasi, bottomSheets, dialog, dan API tingkat tinggi yang terkait dengan rute dan ketiadaan konteks.

- Catatan²: Langkah ini hanya diperlukan jika kita akan menggunakan manajemen route (`Get.to()`, `Get.back()` dan seterusnya). Jika kita tidak menggunakannya, langkah 1 tidak diperlukan.

- Langkah 2:
  Buat file baru untuk business logic dan taruh semua variabel, metode, dan kontroler didalamnya.
  kita bisa membuat variabel apapun menjadi "observable" menggunakan notasi tambahan ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Langkah 3:
  Buat View Anda, gunakan StatelessWidget untuk menghemat RAM, dengan Get Anda mungkin tidak lagi perlu menggunakan StatefulWidget.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instansiasi kelas kita menggunakan Get.put() untuk membuatnya tersedia untuk seluruh "child" route dibawahnya.    
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Gunakan Obx(() => ...) untuk mengupdate Text() ketika `count` berubah.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Ganti 8 baris Navigator.push menggunan Get.to() agar lebih sederhana. kita tidak perlu `context`.
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // kita bisa meminta Get untuk menemukan kontroler yang digunakan di halaman lain dan redirect ke halaman itu.
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

Ini adalah proyek sederhana tetapi sudah menjelaskan betapa hebatnya Get. Seiring dengan berkembangnya proyek, perbedaaan ini akan semakin signifikan.

Get dirancang untuk bisa digunakan bersama tim, sehingga membuat pekerjaan seorang developer menjadi lebih mudah.

Tingkatkan ketepatan targetmu, selesaikan semuanya tepat waktu tanpa kehilangan performa. Get bukan untuk semua orang, tetapi jika Anda merasa cocok dengan ungkapan tersebut, Get cocok untuk Anda!

# Tiga Pilar

## State management

Get memiliki dua state manager berbeda: Simple state manager (kami menyebutnya GetBuilder) dan Reactive state manager (GetX/Obx)

### Reactive State Manager

Reactive programming dapat membuat banyak orang merasa kesulitan karena dianggap rumit. GetX mengubah reactive programming menjadi sesuatu yang cukup sederhana

Tidak Perlu Lagi:
- membuat StreamController.
- membuat StreamBuilder untuk setiap variabel.
- membuat kelas untuk setiap state.
- membuat get untuk sebuah value awal (initial value).
- menggunakan generator kode.

Reactive programming dengan Get semudah menggunakan setState.

Bayangkan kita memiliki variabel nama, dan setiap kali mengubahnya, semua widget yang menggunakannya akan berubah secara otomatis.

Ini variabel count kita:

```dart
var name = 'Jonatas Borges';
```

Untuk membuatnya "observable", kita hanya perlu menambahkan ".obs" di belakangnya:

```dart
var name = 'Jonatas Borges'.obs;
```

Dan didalam UI, ketika kita ingin menampilkan value dan update tampilan ketika value itu berubah, cukup lakukan ini:

```dart
Obx(() => Text("${controller.name}"));
```

Selesai! _Sesederhana_ itu.

### Detail lebih lanjut mengenai state management

**Lihat penjelasan yang lebih mendalam tentang manajemen state [di sini](./documentation/id_ID/state_management.md) untuk melihat lebih banyak contoh dan juga perbedaan antara state manager sederhana dan reactive state manager**

Kita akan mendapatkan gambaran yang lebih baik tentang kemampuan GetX.

## Route management

Jika kita ingin menggunakan routes/snackbars/dialogs/bottomsheets tanpa context, GetX sangat cocok untuk itu, lihat ini:

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

Pindah ke halaman baru menggunakan nama route. Baca detail lebih lanjut tentang penamaan route [disini](./documentation/id_ID/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

Untuk menutup snackbar, dialog, bottomsheet, atau apapun yang normalnya kita tutup menggunakan Navigator.pop(context);

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

Perhatikan bahwa kita tidak perlu menggunakan context untuk melakukan semua hal ini? Itulah salah satu keunggulan terbesar menggunakan route management Get. Dengan ini, Anda dapat mengeksekusi semua method ini dari dalam kelas controller Anda, tanpa perlu khawatir.

### Detail lebih lanjut mengenai route management

**Get bekerja dengan named route dan juga menawarkan kontrol lebih mudah untuk navigasimu! Dokumentasinya ada [disini](./documentation/id_ID/route_management.md)**

## Dependency management

Get memiliki dependency manager yang sederhana dan powerful yang memungkinkan kita untuk memperoleh kelas yang sama dengan Bloc atau Controller hanya dengan 1 baris kode, tanpa konteks Provider, dan tanpa inheritedWidget:

```dart
Controller controller = Get.put(Controller());
```

- Catatan: Jika kita menggunakan State Manager milik Get, harap untuk lebih memperhatikan [Bindings](./documentation/id_ID/dependency_management.md#bindings) api, yang mana akan membuat pengkoneksian View terhadap Controller jadi lebih mudah.

Daripada menginstansiasi kelas Anda di dalam kelas yang Anda gunakan, Anda menginstansiasi kelas tersebut di dalam instance Get, yang akan membuatnya dapat digunakan di seluruh Aplikasi Anda. Jadi Anda dapat menggunakan kontroler Anda (atau class Bloc) secara normal

**Tips:** Dependency Management Get terpisah dari bagian lain dari package, jadi jika sebagai contoh aplikasi kita sudah menggunakan state manager (tidak peduli apapun itu), kita tidak perlu menulis ulang sama sekali, kita bisa menggunakan dependency injection tanpa masalah.

```dart
controller.fetchApi();
```

Bayangkan kita bernavigasi melewati route yang sangat banyak, dan kita membutuhkan data yang tertinggal didalam controller jauh di belakang route sebelumnya, kita akan butuh state manager dikombinasikan dengan Provider atau Get_it, benar kan? Tidak dengan Get. kita hanya perlu meminta Get untuk "menemukan" controllernya, kita tidak perlu dependensi tambahan:

```dart
Controller controller = Get.find();
// Ya, terlihat seperti Sulap, Get akan menemukan controller kita, dan akan mengantarkannya ke lokasi kita.
// kita bisa memiliki 1 juta controller terinisialisasi, Get akan selalu memberimu controller yang tepat.
```

Dan setelahnya kita bisa memperoleh data yang tertinggal sebelumnya:

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

Berikan parameter ke `GetMaterialApp` untuk mendefinisikan lokaliasi dan translasi.

```dart
return GetMaterialApp(
    translations: Messages(), // gunakan translasi yang kita buat
    locale: Locale('id', 'ID'), // translasi akan ditampilkan di lokal ini
    fallbackLocale: Locale('en', 'US'), // berikan lokal penumpu untuk berjaga-jaga jika lokal yang tidak valid dipilih
);
```

#### Mengubah Lokalisasi

Panggil `Get.updateLocale(locale)` untuk memperbarui lokalisasi. Setelahnya, translasi akan menggunakan lokalisasi baru.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### Lokalisasi Sistem

Untuk membaca lokalisasi sistem, kita bisa menggunakan `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Mengubah Tema

Harap untuk tidak menggunakan widget dengan level lebih tinggi daripada `GetMaterialApp` untuk memperbaruinya. Ini akan menyebabkan "duplicate keys". Banyak orang terbiasa menggunakan cara lama untuk membuat sebuah "ThemeProvider" widget hanya untuk mengubah tema aplikasi kita, dan ini tentu saja TIDAK diperlukan dengan **GetX™**.

kita bisa membuat tema kustom kita sendiri dan cukup menambahkannya kedalam `Get.changeTheme` tanpa boilerplate:

```dart
Get.changeTheme(ThemeData.light());
```

Jika kita ingin membuat sesuatu seperti tombol yang mengubah Tema ketika `onPressed`, kita bisa mengkombinasikan dua **GetX™** API:

- API yang melakukan pengecekan terhadap tema gelap `Get.isDarkMode`.
- Dan API pengubah tema `Get.changeTheme`, kita cukup meletakannya didalam `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Ketika `.darkmode` aktif, ini akan mengubah aplikasi kita ke _light theme_, dan sebaliknya, jika _light theme_ sedang aktif, ini akan mengubah aplikasi kita ke _dark theme_.

## GetConnect

GetConnect adalah cara mudah untuk berkomunikasi dari backend ke frontend menggunakan http atau websocket.

### Konfigurasi Default

kita bisa secara sederhana meng-extend GetConnect dan menggunakan GET/POST/PUT/DELETE/SOCKET untuk berkomunikasi dengan REST API atau Websocket kita.

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

GetConnect sangat bisa di disesuaikan, kita bisa mendefinisikan base URL, Response Modifier, Request Modifier, Authenticator, dan bahkan jumlah percobaan akses ulang (retry) yang mana akan mencoba meng-autentikasi dirinya sendiri, sebagai tambahan, kita juga bisa mendefinisikan dekoder standar yang akan mengubah seluruh request kedalam Model kita tanpa konfigurasi tambahan.

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
    // itu tidak akan pernah ditampilkan ke user, karena kita menghapus
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
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### OnPageCalled

Fungsi ini akan terpanggil ketika halaman yang dituju dipanggil sebelum apapun dibuat,
kita bisa menggunakannya untuk mengubah sesuatu tentang halaman tersebut atau
berikan halaman baru.

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Fungsi ini akan terpanggil tepat sebelum Binding ter-inisialisasi.
Disini kita bisa mengubah Binding untuk halaman yang dituju.

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
Disini kita bisa melakukan sesuatu sebelum halaman yang dituju dibuat.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Fungsi ini akan terpanggil tepat setelah fungsi `GetPage.page` terpanggil dan akan memberikan kita hasil dari fungsinya. Dan mengambil widget yang akan ditampilkan.

### OnPageDispose

Fungsi ini akan terpanggil tepat setelah semua objek yang berhubungan (Controller, Views, ...) ter-dispose dari halaman.

## API Tingkat Lanjut Lainnya

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
// kita bisa mengetahui apakah kita menjalankannya didalam browser
// di Windows, iOS, OSX, Android, dsb.
GetPlatform.isWeb


// Sama dengan : MediaQuery.of(context).size.height,
// tapi immutable.
Get.height
Get.width

// Memberikan konteks saat ini dari sebuah Navigator
Get.context

// Memberikan konteks dari snackbar/dialog/bottomsheet di Gives the latar depan, dimanapun di kode kita
Get.contextOverlay

// Catatan: metode berikut adalah sebuah perluasan konteks. Berhubung kita
// memiliki akses terhadap konteks dimanapun di UI kita, kita bisa menggunakannya dimanapun di kode UI

// Jika kita memerlukan height/width yang bisa dirubah (seperti Desktop atau browser yang bisa di sesuaikan) kita akan memerlukan konteks
context.width
context.height

// Memberikan kita kemampuan untuk mendefinisikan separuh layar, sepertiga, dan seterusnya.
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

GetMaterialApp mengkonfigurasi semuanya untuk kita, namun jika kita ingin mengkonfigurasi Get secara manual.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

kita juga bisa menggunakan Middleware kita sendiri melalui `GetObserver`, ini tidak akan mempengaruhi apapun.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Disini
  ],
);
```

kita bisa membuat _Pengaturan Global_ untuk `Get`. Cukup tambahkan `Get.config` kedalam kode kita sebelum berpindah ke route manapun.
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

kita bisa secara opsional me-redirect seluruh pesan logging dari `Get`.
Jika kita ingin menggunakan logging buatan kita sendiri, logging package favorit,
dan ingin meng-capture lognya:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // oper message ke logging package favorit kita disini
  // harap dicatat bahwa meskipun enableLog: false, pesan log akan di-push dalam callback ini,
  // kita dapat memeriksa flag-nya jika kita mau melalui GetConfig.isLogEnable
}

```

### Local State Widgets

Widget ini memungkinkan kita untuk mengelola satu nilai, dan menjaga state emphemeral dan lokal.
Kita memiliki rasa untuk Reactive dan Simple.
Contohnya, kita mungkin ingin menggunakannya untuk men-toggle obscureText di sebuah `TextField`, mungkin membuat
Expandable Panel kustom, atau mungkin memodifikasi index saat ini dalam `BottomNavigationBar` sembari mengganti konten
dari body didalam `Scaffold`

#### ValueBuilder

Sebuah simplifikasi dari `StatefulWidget` yang berfungsi dengan sebuah callback `.setState` yang menerima value yang telah diperbarui.

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // signaturenya sama! kita bisa menggunakan ( newValue ) => updateFn( newValue )
  ),
  // jika kita perlu memanggil sesuatu diluar builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

Mirip seperti [`ValueBuilder`](#valuebuilder), tapi ini versi Reactive nya, kita bisa menaruh Rx instance (ingat .obs?) dan
akan ter-update secara otomatis... keren kan?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx memiliki sebuah _callable_ function! kita bisa menggunakan (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Tips berguna

`.obs`ervables (juga dikenal sebagai _Rx_ Types) memiliki beragam metode dan operator internal.

> Sangat umum untuk meyakini bahwa sebuah properti dengan .obs adalah nilai sebenarnya... tapi jangan salah!
> Kita sebaiknya menghindari deklarasi Type dari variabel, karena kompiler Dart cukup pintar, dan kodenya akan
> terlihat lebih bersih, tapi:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Meskipun `message` mencetak nilai String yang sebenarnya, jenisnya tetaplah **RxString**!

Jadi, kita tidak bisa melakukan `message.substring( 0, 4 )`.
kita perlu mengakses `value` aslinya didalam _observable_:
Cara yang paling "sering digunakan" adalah `.value`, tapi, tahukah kita bahwa kita juga bisa menggunakan...

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

// kita bisa menggunakan semua operasi non-mutable dari primitif num!
count + 1;

// Hati hati! ini hanya valid jika `count` tidak final, melainkan var
count += 1;

// kita juga bisa melakukan komparasi antar nilai:
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
// tapi kita bisa bekerja menggunakan List sebagai list biasa, meskipun reactive!
abc.add(12); // memasukkan 12 kedalam list, dan MEMPERBARUI stream.
abc[3]; // seperti List, membaca index ke 3.


// persamaan berfungsi dengan Rx dan value nya, namun hashCode nya selalu diambil dari value
final number = 12.obs;
print( number == 12 ); // mengeluarkan output: true

/// Model Rx Kustom:

// toJson(), toString() ditangguhkan ke child, jadi kita bisa mengimplementasi override pada mereka dan print() observable nya secara langsung

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
// `Rx` tidak mengetahui apapun ketika kita mengubah sesuatu didalam user.
// Jadi, untuk kelas kustom, kita perlu secara manual "memberi tahu" perubahannya.
user.refresh();

// atau kita bisa menggunakan `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```

## StateMixin

Cara lain untuk menangani state `UI` Anda adalah dengan menggunakan `StateMixin&lt;T&gt;`.
Untuk mengimplementasikannya, gunakan `with` untuk menambahkan `StateMixin&lt;T&gt;`
ke kontroler Anda yang mengizinkan model T.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

Metode `change()` mengubah status kapanpun kita inginkan.
Cukup berikan data dan statusnya dengan cara ini:

```dart
change(data, status: RxStatus.success());
```

RxStatus membolehkan status-status berikut:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Untuk memakainya di UI, gunakan:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // di sini kita bisa menaruh custom loading indicator kita, tetapi
        // secara default akan menjadi Center(child: CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // di sini kita juga dapat mengatur error widget kita sendiri, tetapi
        // secara default akan menjadi Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

Saya suka Widget ini, sangat sederhana, namun sangat berguna!

Adalah sebuah `const Stateless` Widget yang memiliki getter `controller` untuk `Controller` yang terdaftar, itu saja.

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // SELALU ingat untuk memberikan `Type` yang kita gunakan untuk mendaftarkan controller kita!
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

kita memiliki dua opsi untuk mem-buildnya.

- dengan `builder` method yang kita return ke widget yang akan di-build.
- dengan metode `desktop`, `tablet`,`phone`, `watch`. method
spesifik akan dibuat ketika tipe layar cocok dengan method.
ketika layarnya adalah [ScreenType.Tablet] maka method `tablet`
akan di eksekusi dan seterusnya.
**Catatan:** Jika kita menggunakan metode ini, atur properti `alwaysUseBuilder` ke `false`

Dengan properti `settings` kita bisa mengatur batasan lebar untuk tipe layar.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Kebanyakan orang tidak tahu untuk apa Widget ini, atau benar benar membingungkan penggunaannya.
Kasus penggunaannya sangat langka, namun sangat spesifik: Melakukan `cache` terhadap Controller.
Karena _cache_, tidak bisa dijadikan `const Stateless`.

> Lalu, kapan kita harus men-"cache" sebuah Controller?

Jika kita menggunakan, fitur "tidak terlalu umum" dari **GetX**: `Get.create()`.

`Get.create(()=>Controller())` akan men-generate `Controller` baru setiap kali kita memanggil
`Get.find<Controller>()`,

Itulah dimana `GetWidget` tampil bersinar... karena kita bisa menggunakannya, sebagai contoh,
untuk menyimpan list dari sebuah Todo item. Jadi, jika widget di-"rebuild", dia akan meyimpan controller yang sama.

#### GetxService

Kelas ini mirip seperti `GetxController`, dia berbagi lifecycle ( `onInit()`, `onReady()`, `onClose()`).
Tetapi tidak memiliki "logic" didalamnya. Dia hanya memberi tahu Sistem Dependency Injection **GetX**, bahwa subclass
ini **TIDAK BISA** dihapus dari memori.

Jadi ini sangat berguna untuk memastikan "Service" kita selalu dapat dijangkau dan aktif dengan `Get.find()`. Seperti:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Adalah gerakan yang bagus untuk membuat Service kita menginisialisasi sebelum kita menjalankan aplikasi Flutter
/// seperti kita bisa mengontrol flow eksekusi (mungkin kita perlu memuat beberapa konfigurasi tema,
/// apiKey, bahasa yang ditentukan oleh user...) jadi, load SettingService sebelum menjalankan ApiService.
/// supaya GetMaterialApp() tidak perlu rebuild, dan mengambil nilainya secara langsung.
void initServices() async {
  print('starting services ...');
  /// Disini adalah dimana kita meletakkan get_storage, hive, inisialisasi shared_pref.
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

Satu-satunya cara untuk benar benar menghapus sebuah `GetxService`, adalah dengan `Get.reset()` dimana ini seperti
"Hot Reboot" dari aplikasi kita. Jadi ingat, jika kita butuh persistensi absolut dari sebuah instance kelas selama
masa hidup aplikasi kita, gunakan `GetxService`.

### Tests

Anda dapat menguji kontroler Anda seperti kelas lainnya, termasuk _lifecycle_nya:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Ganti value ke name2
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
    /// Anda dapat mengetes kontroler tanpa lifecycle,
    /// namun tidak disarankan kecuali Anda tidak menggunakan
    /// dependency injection GetX
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// Jika Anda menggunakannya, Anda dapat mengetes semuanya,
    /// termasuk keadaan aplikasi setelah setiap lifecycle.
    Get.put(controller); // onInit was called
    expect(controller.name.value, 'name2');

    /// Tes methodnya
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose dipanggil
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### Tips

##### Mockito atau mocktail
Jika Anda perlu meniru GetxController/GetxService Anda, Anda harus memperpanjang GetxController, dan mencampurnya dengan Mock, dengan cara itu

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Menggunakan Get.reset ()
Jika Anda mengetes widget, atau grup tes, gunakan Get.reset di akhir tes atau di tearDown untuk mengatur ulang semua pengaturan dari tes sebelumnya.

##### Get.testMode 
jika Anda menggunakan navigasi di kontroler Anda, gunakan `Get.testMode = true` di awal main Anda.

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

RxController dan GetBuilder sekarang digabungkan, tidak lagi perlu mengingat kontroler mana yang ingin digunakan, cukup gunakan GetxController, ini akan bekerja untuk simple state management juga reactive.

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

1- Sering kali setelah update Flutter, banyak package yang akan rusak. Terkadang terjadi kesalahan kompilasi, sering muncul kesalahan yang masih belum terjawab, dan developer perlu mengetahui dari mana kesalahan itu berasal, melacak kesalahan tersebut, baru kemudian mencoba membuat isu di repositori yang bersangkutan, dan melihat permasalahannya terpecahkan. Get memusatkan sumber daya utama untuk pengembangan (State, ketergantungan, dan manajemen rute), memungkinkan kita untuk menambahkan satu paket ke pubspec, dan mulai bekerja. Setelah update Flutter, satu-satunya hal yang perlu dilakukan adalah memperbarui dependencyGet, dan mulai bekerja. Get juga menyelesaikan masalah kompatibilitas. Berapa kali sebuah versi package tidak kompatibel dengan versi yang lain, karena yang satu menggunakan dependency di satu versi, dan yang lain di versi yang lain? Hal ini juga tidak menjadi masalah dengan menggunakan Get, karena semuanya berada dalam package yang sama dan sepenuhnya kompatibel.

2- Flutter itu mudah, Flutter itu luar biasa, tetapi Flutter masih memiliki sejumlah boilerplate yang mungkin tidak diinginkan oleh sebagian besar pengembang, seperti `Navigator.of(context).push(context, builder [...]`. Get menyederhanakan pengembangan. Daripada menulis 8 baris kode untuk memanggil sebuah route, Anda bisa melakukannya: `Get.to(Home())` dan selesai, pergi ke halaman berikutnya. URL web dinamis adalah hal yang sangat menyulitkan untuk dilakukan dengan Flutter saat ini, namun dengan GetX sangatlah mudah. Mengelola status di Flutter, dan mengelola dependensi juga merupakan sesuatu yang menimbulkan banyak diskusi, karena ada ratusan pattern di pub. Tetapi tidak ada yang semudah menambahkan “.obs” di akhir variabel Anda, dan letakkan widget Anda di dalam Obx, dan hanya itu, semua pembaruan pada variabel tersebut akan diperbarui secara otomatis di layar.

3- Kemudahan tanpa khawatir tentang performa. Performa Flutter sudah luar biasa, tetapi bayangkan Anda menggunakan state manager, dan locator untuk mendistribusikan class blocs/stores/controllers/dll. Anda harus secara manual memanggil pengecualian dependensi tersebut ketika Anda tidak membutuhkannya. Tetapi pernahkah Anda berpikir untuk hanya menggunakan kontroler Anda, dan ketika kontroler tersebut tidak lagi digunakan oleh siapa pun, kontroler tersebut akan dihapus dari memori? Itulah yang dilakukan GetX. Dengan SmartManagement, semua yang tidak digunakan akan dihapus dari memori, dan Anda tidak perlu khawatir tentang hal lain kecuali pemrograman. Kita bisa yakin bahwa kita menggunakan resource seminimal mungkin, bahkan tanpa harus membuat sebuah logika untuk itu.

4- Decoupling yang sebenarnya. Anda mungkin pernah mendengar konsep “memisahkan tampilan dari logika bisnis”. Ini bukan keunikan BLoC, MVC, MVVM, dan standar lainnya di pasaran yang memiliki konsep ini. Namun, konsep ini sering kali dapat diatasi dalam Flutter karena penggunaan konteks.
Jika Anda membutuhkan konteks untuk menemukan InheritedWidget, Anda memerlukannya di dalam tampilan, atau meneruskan konteks dengan parameter. Saya secara khusus merasa solusi ini sangat jelek, dan untuk bekerja dalam tim kita akan selalu memiliki dependensi pada logika bisnis View. Getx berbeda dengan pendekatan standar, dan meskipun tidak sepenuhnya membuang penggunaan StatefulWidgets, InitState, dll, Getx selalu memiliki pendekatan sejenis yang dapat lebih bersih. Controller memiliki lifecycle, dan ketika kita perlu membuat permintaan REST API misalnya, kita bisa tidak bergantung pada apa pun yang ada di dalam tampilan. Kita dapat menggunakan onInit untuk menginisiasi pemanggilan http, dan ketika datanya masuk, variabel akan terisi. Karena GetX sepenuhnya reaktif (benar-benar, dan bekerja di bawah stream), setelah item diisi, semua widget yang menggunakan variabel tersebut akan secara otomatis diperbarui dalam tampilan. Hal ini memungkinkan orang yang memiliki keahlian UI untuk bekerja hanya dengan widget, dan tidak perlu mengirimkan apa pun ke logika bisnis selain event pengguna (seperti mengklik tombol), sementara orang yang bekerja dengan logika bisnis akan bebas membuat dan menguji logika bisnis secara terpisah.

Library ini akan selalu diperbarui dan mengimplementasikan fitur-fitur baru. Jangan ragu untuk mengajukan PR dan berkontribusi di dalamnya.

Library ini akan terus diperbarui dan mengimplementasikan fitur baru. Jangan ragu untuk menawarkan PR dan berkontribusi ke mereka.

# Komunitas

## Channel Komunitas

GetX memiliki komunitas yang sangat aktif dan membantu. Jika memiliki pertanyaan, atau membutuhkan bantuan mengenai penggunaan framework ini, bergabunglah dengan kanal komunitas kami, pertanyaan akan dijawab lebih cepat, dan akan menjadi tempat yang paling cocok. Repositori ini eksklusif untuk pembukaan isu dan permintaan resource, tapi jangan ragu untuk menjadi bagian dari Komunitas GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Cara berkontribusi

_Ingin berkontribusi kedalam proyek? Kami akan sangat bangga untuk menyorotimu sebagai salah satu dari kolaborator kami. Ini adalah beberapa point dimana kamu bisa berkontribusi dan membuat Get (dan Flutter) jadi lebih baik_

- Membantu menerjemahkan readme ke dalam bahasa lain.
- Menambahkan dokumentasi ke dalam readme (banyak fungsi dari Get yang masih belum terdokumentasi).
- Menulis artikel atau membuat video tutorial tentang penggunaan Get (akan dimasukkan kedalam readme dan Wiki kami di masa yang akan datang).
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

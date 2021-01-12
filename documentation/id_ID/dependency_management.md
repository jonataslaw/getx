- [Dependency Management](#dependency-management)
  - [Menginstansiasi method](#menginstansiasi-method)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Menggunakan method/kelas yang terinstansiasi](#menggunakan-methodkelas-yang-terinstansiasi)
  - [Perbedaan antar method](#perbedaan-antar-method)
  - [Bindings](#bindings)
    - [Bindings class](#bindings-class)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Cara mengubahnya](#cara-mengubahnya)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Cara kerja bindings dibalik layar](#cara-kerja-bindings-dibalik-layar)
  - [Catatan](#catatan)

# Dependency Management

Get memiliki dependency manager sederhana dan powerful yang memungkinkan anda mendapatkan kelas yang setara dengan Bloc atau Controller hanya dengan 1 baris kode, tanpa Provider context, tanpa inheritedWidget:

```dart
Controller controller = Get.put(Controller());
```

Daripada menginstansiasi kelas anda didalam kelas yang anda gunakan, cukup lakukan hal itu di dalam Get instance, ini akan membuatnya tersedia di semua tempat di Aplikasimu. Jadi anda bisa menggunakan controller (atau class Bloc) secara normal.

- Catatan: Jika anda menggunakan State Manager milik Get, harap untuk lebih memperhatikan [Bindings](#bindings) api, yang mana akan membuat pengkoneksian View terhadap Controller jadi lebih mudah.
- Note²: Dependency Management Get terpisah dari bagian lain dari package, jadi jika sebagai contoh aplikasi anda sudah menggunakan state manager (tidak peduli apapun itu), anda tidak perlu menulis ulang sama sekali, anda bisa menggunakan dependency injection tanpa masalah.

## Menginstansiasi method

Berikut adalah metode dan parameternya yang dapat dikonfigurasi:

### Get.put()

Cara paling umum untuk memasukkan dependensi, untuk kontroler dari view anda contohnya.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Berikut adalah semua opsi yang bisa anda atur ketika menggunakan put:

```dart
Get.put<S>(
  // wajib: kelas yang ingin anda simpan, seperti controller, atau apapun
  // catatan: "S" menandakan bahwa tipenya bisa jadi sebuah kelas dari tipe apapun.
  S dependency

  // opsional: ini digunakan ketika anda ingin memasukkan banyak kelas yang memiliki tipe yang sama.
  // berhubung normalnya anda memanggil kelas menggunakan Get.find<Controller>(),
  // anda perlu menggunakan tag untuk menandai instance mana yang anda butuhkan
  // tag harus unik, dan bertipe String.
  String tag,

  // opsional: secara default, get akan men-dispose instance setelah tidak digunakan lagi (contoh,
  // sebuah controller dari view yang ditutup), tapi mungkin anda membutuhkannya untuk digunakan
  // ditempat lain di aplikasi anda, contohnya seperti sebuah instance dari SharedPreference, atau yang lain.
  // Maka anda perlu ini
  // nilai defaultnya adalah false
  bool permanent = false,

  // opsional: memungkinkan anda setelah menggunakan kelas abstrak didalam test, menggantinya dengan yang lain dan mengikuti testnya.
  // nilai defaultnya adalah false
  bool overrideAbstract = false,

  // opsional: memungkinkan anda untuk memasukkan dependensi menggunakan fungsi daripada dependensi itu sendiri.
  // ini jarang dipakai.
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut

Anda bisa melakukan lazyload terhadap sebuah dependensi supaya dependensi tersebut terinstansiasi hanya ketika digunakan saja. Sangat berguna untuk kelas komputasional yang "mahal" atau jika anda ingin menginstansiasi beberapa kelas hanya dalam satu lokasi (seperti pada kelas Bindings) dan anda tahu anda tidak akan menggunakannya secara langsung.

```dart
/// ApiMock hanya akan dipanggil ketika seseorang menggunakan Get.find<ApiMock> pertama kali.
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... beberapa logic jika diperlukan..
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

Berikut adalah semua opsi yang bisa anda atur ketika menggunakan lazyPut:

```dart
Get.lazyPut<S>(
  // wajib: sebuah method yang akan di eksekusi ketika kelas anda dipanggil untuk pertama kali
  InstanceBuilderCallback builder,
  
  // opsional: sama seperti Get.put(), ini digunakan ketika anda menginginkan banyak instance berbeda dengan kelas yang sama
  // harus unik dan harus String.
  String tag,

  // opsional: Mirip seperti "permanent", bedanya adalah instance akan dihapus ketika tidak
  // digunakan, tetapi ketika diperlukan lagi, Get akan membuat ulang instance yang sama,
  // seperti "SmartManagement.keepFactory" pada bindings api.
  bool fenix = false
  
)
```

### Get.putAsync

Jika anda ingin mendaftarkan instance yang asynchronous, anda bisa menggunakan `Get.putAsync()`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

Berikut adalah semua opsi yang anda bisa atur ketika menggunakan putAsync:

```dart
Get.putAsync<S>(

  // wajib: sebuah async method yang akan di eksekusi untuk menginstansiasi kelas anda
  AsyncInstanceBuilderCallback<S> builder,

  // opsional: sama seperti Get.put(), ini digunakan ketika anda menginginkan banyak instance berbeda dengan kelas yang sama
  // harus unik dan harus String.
  String tag,

  // opsional: sama seperti Get.put(), digunakan ketika anda ingin mempertahankan
  // instance tersebut (keep-alive) untuk digunakan diseluruh aplikasi anda.
  // nilai defaultnya adalah false
  bool permanent = false
)
```

### Get.create

Yang satu ini agak rumit. Penjelasan lebih detail tentang ini dan perbedaannya dengan yang lain bisa ditemukan di sesi [Perbedaan antar method](#perbedaan-antar-method).

```dart
Get.create<SomeClass>(() => SomeClass());
Get.create<LoginController>(() => LoginController());
```

Berikut adalah semua opsi yang bisa anda atur ketika menggunakan create:

```dart
Get.create<S>(
  // diperlukan: sebuah fungsi yang mereturn sebuah kelas yang akan "terfabrikasi" setiap
  // kali `Get.find()` dipanggil
  // Contoh: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // opsional: sama seperti Get.put(), ini digunakan ketika anda menginginkan
  // banyak instance berbeda dengan kelas yang sama.
  // Berguna dalam kasus ketika anda memiliki sebuah list yang setiap isinya membutuhkan
  // controllernya masing-masing.
  // Harus unik dan harus String. Cukup ganti `tag` menjadi `name`.
  String name,

  // opsional: sama seperti Get.put(), digunakan ketika anda ingin mempertahankan
  // instance tersebut (keep-alive) untuk digunakan diseluruh aplikasi anda.
  // Untuk Get.create, `permanent` nilainya `true` secara default.
  bool permanent = true
```

## Menggunakan method/kelas yang terinstansiasi

Bayangkan anda bernavigasi melewati route yang sangat banyak, dan anda membutuhkan data yang tertinggal didalam controller jauh di belakang route sebelumnya, anda akan butuh state manager dikombinasikan dengan Provider atau Get_it, benar kan? Tidak dengan Get. Anda hanya perlu meminta Get untuk "menemukan" controllernya, anda tidak perlu dependensi tambahan:

```dart
final controller = Get.find<Controller>();
// ATAU
Controller controller = Get.find();

// Ya, terlihat seperti Sulap, Get akan menemukan controller anda, dan akan mengantarkannya ke lokasi anda.
// Anda bisa memiliki 1 juta controller terinisialisasi, Get akan selalu memberimu controller yang tepat.
```

Dan setelahnya anda bisa memperoleh data yang tertinggal sebelumnya:

```dart
Text(controller.textFromApi);
```

Berhubung value yang direturn adalah sebuah kelas normal, anda bisa melakukan apapun yang anda mau:

```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // keluaran: 12345
```

Untuk menghapus sebuah instance dari Get:

```dart
Get.delete<Controller>(); // biasanya anda tidak perlu melakukan ini karena GetX sudah melakukannya untuk anda
```

## Perbedaan antar method

Sebelum kita mulai, mari kita bahas tentang `fenix` dari Get.lazyPut dan `permanent` dari method lainnya.

Perbedaan mendasar diantara `permanent` dan `fenix` adalah bagaimana anda ingin menyimpannya (kelas anda).

Menguatkan: secara default, GetX menghapus instance ketika tidak digunakan.

Artinya: Jika screen 1 memiliki controller 1, dan screen 2 memiliki controller 2, dan anda menghapus route pertama dari stack, (seperti pada halnya anda menggunakan `Get.off()` atau `Get.offNamed()`), controller 1 akan kehilangan status kegunaannya dan akan dihapus.

Tapi jika anda menggunakan `permanent:true`, maka controller tidak akan dihapus pada saat berpindah halaman - yang mana sangat berguna untuk service yang ingin anda pertahankan supaya tetap ada (keep-alive) diseluruh aplikasi anda.

`fenix` di sisi lain adalah sebuah service yang anda tidak perlu khawatir kehilangan ketika berpindah antar halaman, tetapi ketika anda membutuhkan service tersebut, anda berekspektasi bahwa service tersebut masih ada. Walaupun sebenarnya, controller/service/class tetap ter-dispose, dan ketika anda membutuhkannya, dia akan membuat ulang (dari abu-nya) sebuah instance baru.

Lanjut dengan perbedaan antar method:

- Get.put dan Get.putAsync mengikuti urutan pembuatan yang sama, bedanya, yang kedua menggunakan asynchronous method: kedua method tersebut membuat dan menginisialisasi sebuah instance. Dimasukkan secara langsung kedalam memori, menggunakan method internal `insert` dengan parameter `permanent:false` dan `isSingleton:true` (isSingleton parameter ini hanya hanya bertujuan untuk membedakan apakah harus menggunakannya pada `dependency` atau menggunakannya pada `FcBuilderFunc`). Setelah itu, `Get.find()` dipanggil dan segera menginisialisasi instance yang ada didalam memori.

- Get.create: seperti namanya, dia akan "membuat" dependensi anda! Mirip seperti `Get.put()`, dia juga memanggil metode internal `insert` untuk menginstansiasi. Namun mengubah `permanent` menjadi true dan `isSingleton` menjadi false (karena kita "membuat" dependensi, tidak ada cara untuk menjadikannya sebagai singleton, inilah kenapa nilainya false). Dan karena dia memiliki `permanent:true`, kita secara default memiliki keuntungan untuk tidak kehilangannya pada saat berpindah halaman! Dan juga, `Get.find()` tidak dipanggil secara langsung, dia menunggu untuk digunakan disuatu halaman untuk dipanggil. Ini dibuat dengan cara tersebut supaya bisa menggunakan parameter `permanent`, sementara itu, perlu diketahui, `Get.create()` dibuat dengan tujuan untuk membuat instance yang tidak dapat di-share, tetapi juga tidak ter-dispose, seperti contohnya sebuah button didalam ListView, dan anda menginginkan sebuah instance unik untuk list tersebut - karena itu, Get.create harus digunakan bersamaan dengan GetWidget.

- Get.lazyPut: seperti namanya, ini membuat "lazy process". Instance nya dibuat, namun tidak digunakan secara langsung, dia menunggu untuk dipanggil. Bertentangan dengan metode lain, `insert` tidak dipanggil disini. Sebaliknya, instance dimasukkan ke bagian lain didalam memori, bagian yang bertanggung jawab untuk memberi tahu apakah instance bisa dibuat ulang atau tidak, mari kita sebut itu sebagai "factory". Jika kita ingin membuat sesuatu untuk digunakan nanti, ini tidak akan tercampur dengan yang digunakan sekarang. Dan disini adalah dimana "sihir" `fenix` terjadi: jika anda memilih untuk membiarkan `fenix: false`, dan `smartManagement` bukan `keepFactory`, maka ketika menggunakan `Get.find`, instance akan mengubah posisinya didalam memori supaya tersedia di bagian terpisah ini, bahkan menuju ke area umum, untuk dipanggil lagi di masa yang akan datang.

## Bindings

Salah satu dari perbedaan besar dari package ini, mungkin, adalah suatu kemungkinan untuk mengintegrasikan route, state manager, dan dependency manager secara penuh.

Ketika route dihapus dari Stack, semua kontroler, variabel, dan instance yang berhubungan dengan itu akan dihapus dari memori. Jika anda menggunakan stream atau timer, mereka akan ditutup secara otomatis, dan anda tidak perlu khawatir tentang hal itu.

Di versi 2.10, Get benar-benar mengimplementasi Bindings API. Sekarang anda tidak perlu menggunakan init method. Bahkan anda tidak perlu mengetik controller yang ingin anda tuju jika anda mau. Anda bisa memulai controller dan service di tempat yang tepat untuk itu.

Binding class adalah sebuah kelas yang memisahkan dependency injection, sembari "mengaitkan" route ke state manager dan dependency manager.

Ini memungkinkan Get untuk mengetahui tampilan mana yang sedang ditampilkan ketika controller yang bersangkutan digunakan dan untuk mengetahui bagaimana cara men-dispose nya.

Sebagai tambahan, Binding class memungkinkan anda untuk memiliki kontrol terhadap konfigurasi SmartManager. Anda bisa mengkonfigurasi dependensi anda untuk diurutkan ketika penghapusan route dari stack, atau ketika widget yang digunakan diletakkan, atau tidak keduanya. Anda akan memiliki dependensi management pintar yang bekerja untuk anda, tapi meski begitu, anda bisa mengkonfigurasinya sesuka hati anda.

### Bindings class

- Buat sebuah kelas yang meng-implements Bindings

```dart
class HomeBinding implements Bindings {}
```

IDE anda akan secara otomatis meminta anda untuk meng-override "dependencies method", dan anda hanya perlu klik ikon lampu, override method nya, dan masukkan semua kelas yang akan anda gunakan dalam route tersebut:

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

Sekarang anda hanya perlu memberi tahu route anda, bahwa anda akan menggunakan binding tersebut untuk membuat koneksi diantara route manager, dependency manager dan state.

- Menggunakan named route:

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

- Menggunakan normal route:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Disana, anda tidak perlu lagi khawatir tentang manajemen memori aplikasi anda, Get akan melakukannya untuk anda.

Binding akan dipanggil ketika route dipanggil, anda juga bisa membuat sebuah "initialBinding" di GetMaterialApp dan memasukkan semua dependensi yang diperlukan.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

Secara default, untuk membuat sebuah binding adalah dengan membuat kelas baru yang meng-implements Bindings.
Secara alternatif, anda bisa menggunakan `BindingsBuilder` untuk menginstansiasi apapun yang anda mau melalui sebuah fungsi callback.

Example:

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

Dengan cara ini, anda bisa menghindari membuat satu kelas Binding untuk setiap route yang anda buat, membuatnya jadi semakin simpel.

Kedua cara tersebut bekerja secara sempurna dan kami ingin anda menggunakan yang manapun yang anda rasa cocok untuk anda.

### SmartManagement

GetX secara default men-dispose controller yang tidak digunakan dari memori, bahkan jika kegagalan terjadi dan widget yang menggunakannya tidak ter-dispose dengan benar.
Ini adalah apa yang disebut dengan `full` mode dari sebuah dependency management.
Tetapi jika anda ingin mengubah cara kerja GetX dalam mengontrol "disposal" terhadap kelas, anda memiliki kelas `SmartManagement` yang anda bisa atur perilakunya.

#### Cara mengubahnya

Jika anda ingin mengubah konfigurasi ini (yang biasanya tidak diperlukan), ini caranya:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders // Disini
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

Ini adalah pengaturan default. Dispose semua kelas yang tidak digunakan dan tidak ditandai sebagai permanent. Di kebanyakan kasus anda ingin konfigurasi ini tidak disentuh. Jika anda baru di GetX, jangan mengubahnya.

#### SmartManagement.onlyBuilders

Dengan opsi ini, hanya controller yang dimulai didalam `init:` atau yang ter-load kedalam sebuah Binding dengan `Get.lazyPut()`, yang akan di dispose.

Jika anda menggunakan `Get.put()` atau `Get.putAsync()` atau cara lain, SmartManagement tidak akan memiliki izin untuk meng-exclude dependensi ini.

Dengan perilaku default, bahkan widget yang terinstansiasi dengan "Get.put" akan dihapus, tidak seperti SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Sama seperti SmartManagement.full, ini akan menghapus semua dependensi ketika tidak digunakan lagi. Meski begitu, ini akan menyimpan factory mereka, yang artinya dia akan membuat ulang dependensi jika anda membutuhkannya lagi.

### Cara kerja bindings dibalik layar

Bindings membuat factory sementara, yang mana dibuat ketika anda meng-klik untuk pindah ke halaman lain, dan akan dihapus segera setelah animasi perpindahan halaman terjadi.
Ini terjadi begitu cepat bahkan analyzer sekalipun tidak bisa meregistrasikannya.
Ketika anda kembali ke halaman itu lagi, factory baru akan dipanggil, jadi ini lebih disarankan daripada menggunakan SmartManagement.keepFactory, tapi jika anda tidak ingin membuat Bindings, atau ingin menyimpan semua dependensi didalam Binding yang sama, itu akan sangat membantu.
Konsumsi memori terhadap Factory sangatlah kecil, mereka tidak memegang instance, hanya sebuah fungsi dengan "bentukan" dari kelas yang anda inginkan.
Ini sangat menghemat penggunaan memori, tetapi karena tujuan dari lib ini adalah untuk mendapatkan performa maksimum dan menggunakan resource seminimum mungkin, Get menghapus bahkan si factory itu sendiri secara default.
Gunakan mana yang anda rasa mudah untuk anda.

## Catatan

- JANGAN GUNAKAN SmartManagement.keepFactory jika anda menggunakan lebih dari satu Bindings. Ini dedesain untuk digunakan tanpa Bindings, atau dengan satu Binding terhubung dengan initialBinding milik GetMaterialApp.

- Menggunakan Binding sifatnya opsional, jika anda mau, anda bisa menggunakan `Get.put()` dan `Get.find()` untuk kelas yang menggunakan controller tanpa masalah.
  Meski begitu, jika anda bekerja dengan Service atau segala jenis abstraksi lain, Saya merekomendasikan menggunakan Bindings supaya pengorganisiran menjadi lebih baik.

- [State Management](#state-management)
  - [Reactive State Manager](#reactive-state-manager)
    - [Keuntungan](#keuntungan)
    - [Performa Maksimum](#performa-maksimum)
    - [Mendeklarasikan reactive variable](#mendeklarasikan-reactive-variable)
      - [Memiliki sebuah reactive state itu, mudah](#memiliki-sebuah-reactive-state-itu-mudah)
    - [Menggunakan value didalam view](#menggunakan-value-didalam-view)
    - [Kondisi untuk rebuild](#kondisi-untuk-rebuild)
    - [Dimana .obs bisa digunakan](#dimana-obs-bisa-digunakan)
    - [Catatan mengenai List](#catatan-mengenai-list)
    - [Mengapa harus menggunakan .value](#mengapa-harus-menggunakan-value)
    - [Obx()](#obx)
    - [Worker](#worker)
  - [Simple State Manager](#simple-state-manager)
    - [Keuntungan](#keuntungan-1)
    - [Penggunaan](#penggunaan)
    - [Bagaimana Get meng-handle controller](#bagaimana-get-meng-handle-controller)
    - [Anda tidak membutuhkan StatefulWidget lagi](#anda-tidak-membutuhkan-statefulwidget-lagi)
    - [Mengapa GetX ada](#mengapa-getx-ada)
    - [Cara lain dalam menggunakannya](#cara-lain-dalam-menggunakannya)
    - [Unique ID](#unique-id)
  - [Mencampur 2 state manager](#mencampur-2-state-manager)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# State Management

GetX tidak menggunakan Stream atau ChangeNotifier seperti state manager lainnya. Mengapa? Selain membangun aplikasi untuk Android, iOS, Web, Linux, MacOS, dan Linux, dengan GEtX anda bisa membangun aplikasi server dengan sintaks yang sama seperti Flutter/GetX. Untuk meningkatkan waktu response dan mengurangi konsumsi RAM, kami menciptakan GetValue dan GetStream, yang memiliki solusi latensi rendah yang dapat memberikan performa yang banyak dengan biaya operasi yang rendah. Kami menggunakan ini sebagai dasar untuk membangun semua resource kami, termasuk state management.

- _Kompleksitas_: Beberapa state manager yang ada bisa dibilang kompleks dan memiliki banyak boilerplate. Dengan GetX anda tidak perlu mendefinisikan sebuah kelas untuk setiap event, kode yang dibuat pun bersih dan jelas, dan anda bisa melakukan banyak hal dengan menulis lebih sedikit kode. Banyak orang menyerah menggunakan Flutter karena hal ini, dan pada akhirnya mereka mendapatkan solusi yang sangat sederhana untuk me-manage state.

- _Tidak ada code generator_: Anda menghabiskan separuh waktu development anda menuliskan logic dari aplikasi yang anda buat. Beberapa state manager bergantung pada code generator yang menghasilkan kode dengan keterbacaan yang rendah. Mengubah sebuah variabel dan perlu menjalankan run build_runner bisa jadi tidak produktif, dan terkadang waktu menunggu setelah sebuah flutter clean akan lama, dan anda harus meminum banyak kopi untuk itu.

Dengan GetX semuanya reactive, dan tidak bergantung pada code generator, meningkatkan produktifitas di segala aspek development anda.

- _Tidak bergantung pada konteks_: Anda mungkin pernah diharuskan untuk mengirim konteks dari view ke sebuah controller, membuat keterkaitan yang tinggi terhadap View yang anda buat dengan Business Logic. Anda mungkin pernah diharuskan untuk menggunakan dependensi untuk suatu tempat yang tidak memiliki konteks, dan harus mengirim koteks tersebut melalui berbagai macam kelas dan fungsi. Hal ini tidak ada di GetX. Anda memiliki akses terhadap controller anda dari controller yang anda buat tanpa konteks apapun. Anda tidak perlu mengirim konteks melalui parameter untuk hal yang secara harfiah tidak diperlukan.

- _Kontrol granular_: Kebanyakan state manager didasari oleh ChangeNotifier. ChangeNotifier akan memberi tahu semua widget yang bergantung padanya ketika notifyListener dipanggil. Jika anda memiliki 40 widget didalam satu halaman, yang mana memiliki variabel dari kelas ChangeNotifier anda, ketika anda memperbarui satu dari mereka, semuanya akan me-rebuild.
Dengan GetX, bahkan nested widget pun dihargai. Jika anda memiliki Obx membungkus ListView anda, dan yang lain membungkus sebuah checkbox didalam ListView tersebut, ketika nilai dari CheckBox berubah, hanya CheckBox tersebut yang akan diperbarui, ketika nilai dari List yang berubah, hanya ListView yang akan diperbarui.

- _Hanya merekonstruksi jika variabelnya BENAR-BENAR berubah_: GetX memiliki kontrol flow, yang artinya jika anda menampilkan Text dengan 'Paola', jika anda mengubah variabel observabel menjadi 'Paola' lagi, widget tidak akan direkonstruksi. Ini karena GetX tahu bahwa 'Paola' sudah ditampilkan di Text, dan tidak akan melakukan rekonstruksi yang tidak diperlukan.
Kebanyakan state manager (jika tidak semuanya) saat ini akan merebuild tampilan.

## Reactive State Manager

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

Selesai! _Sesederhana_ itu.

Mulai saat ini, kami akan mereferensikan variabel reactive-".obs"(ervables) sebagai _Rx_.

Apa yang kami lakukan dibalik layar? Kami membuat sebuah `Stream` dari `String`, mengajukan value awal `"Jonatas Borges"`, kami memberi tahu semua widget yang menggunakan `"Jonatas Borges"` bahwa mereka sekarang "milik" variabel tersebut, dan ketika nilai _Rx_ berubah, mereka harus mengubahnya juga.

Ini adalah **keajaiban dari GetX**, terima kasih untuk kemampuan Dart.

Tapi, seperti yang kita ketahui, sebuah `Widget` hanya bisa dirubah jika lokasinya berada didalam sebuah fungsi, karena kelas static tidak memiliki kemampuan untuk "otomatis berubah"

Anda akan harus untuk membuat `StreamBuilder`, berlangganan ke variabel tersebut untuk "mendengar" perubahan, dan membuat sebuah "cascade" dari nested `StreamBuilder` jika anda ingin mengubah beberapa variabel didalam scope, benar kan?

Tidak, anda tidak perlu `StreamBuilder`, tapi anda benar tentang kelas static.

Yah, didalam view, kita biasanya memiliki banyak boilerplate ketika kita ingin mengubah sebuah Widget secara spesifik, itu adalah cara Flutter.
Dengan **GetX** anda juga bisa melupakan tentang boilerplate code ini.

`StreamBuilder( … )`? `initialValue: …`? `builder: …`? Tidak, anda hanya perlu meletakkan variabel kedalam Widget `Obx()`.

```dart
Obx (() => Text (controller.name));
```

_Apa yang perlu anda ingat?_  Hanya `Obx(() =>`.

Anda hanya mengirim Widget itu melalui sebuah arrow-function kedalam sebuah `Obx()` (sebuah "Pengamat" daripada _Rx_).

`Obx` cukup pintar, dan akan selalu berubah jika value dari `controller.name` berubah.

Jika `name` nilainya `"John"`, dan anda mengubahnya ke `"John"` (`name.value = "John"`), karena `value` nya sama seperti sebelumnya, tidak akan ada perubahan apapun di layar, dan `Obex`, untuk menghemat resource, akan secara sederhana mengabaikan value baru yang diberikan dan tidak akan merebuild Widget. **Keren kan?**

> Lalu, bagaimana jika Saya memiliki 5 variabel _Rx_ (observable) didalam `Obx`?

Dia hanya akan memperbarui ketika **semuanya** berubah.

> Dan jika Saya memiliki 30 variabel didalam sebuah kelas, ketika Saya memperbarui salah satu dari mereka, apakah akan memperbarui **semua** variabel didalam kelas tersebut?

Tidak, hanya **Widget tertentu* yang menggunakan variabel _Rx_ tersebut.

Jadi, **GetX** hanya memperbarui tampilan, ketika nilai dari variabel _Rx_ berubah.

```dart
final isOpen = false.obs;

// TIDAK AKAN terjadi apa apa... nilainya sama.
void onButtonTap() => isOpen.value=false;
```

### Keuntungan

**GetX()** membantu anda ketika anda membutuhkan kontrol **granular** atas apa yang sedang diperbarui.

Jika anda tidak membutuhkan `unique ID`, karena semua variabel anda akan di modifikasi ketika anda melakukan sebuah aksi, maka gunakanlah `GetBuilder`,
karena dia adalah Simple State Updater (didalam block, seperti `setState()`), dibuat hanya dengan beberapa baris kode.
Ini dibuat sederhana, untuk mendapatkan pengaruh CPU yang sedikit, dan hanya untuk memenuhi satu kebutuhan (sebuah _State_ rebuild) dan menggunakan resource se-minimal mungkin.

Jika anda perlu sebuah State Manager yang **powerful**, anda tidak akan salah dengan **GetX**.

Ini tidak bekerja dengan variabel, melainkan __aliran (flows)__, semuanya adalah `Streams` dibalik layar.
Anda bisa menggunakan _rxDart_ bersamaan dengannya, karena semuanya adalah `Streams`,
anda bisa me-listen sebuah `event` dari setiap "variabel _Rx_",
karena semua didalamnya adalah `Streams`.

Ini secara harfiah adalah cara yang digunakan _BLoC_, lebih mudah dari _MobX_, dan tanpa code generator atau decoration.
Anda bisa mengubah **apapun** menjadi sebuah _"Observable"_ hanya dengan `.obs`.

### Performa Maksimum

Selain memiliki sebuah algoritma pintar untuk minimal rebuild, **GetX** menggunakan pembanding
untuk memastikan State nya berubah.

Jika anda mengalami error di aplikasi anda, dan mengirim sebuah duplikat terhadap perubahan State,
**GetX** akan memastikan aplikasi anda tidak crash.

Dengan **GetX**, State hanya berubah ketika `value` nya berubah.
Itu adalah perbedaan utama diantara **GetX**, dan dengan menggunakan _`computed` dari MobX_.
Ketika menggabungkan kedua __observable__, dan salah satunya berubah; listener dari _observable_ itu akan berubah juga.

Dengan **GetX**, jika anda menggabungkan dua variabel, `GetX()` (mirip seperti `Observer()`) hanya akan merebuild jika State nya benar-benar berubah.

### Mendeklarasikan reactive variable

Anda memiliki 3 cara untuk mengubah variabel menjadi sebuah "observable".

1 - Yang pertama adalah dengan menggunakan **`Rx{Type}`**.

```dart
// value awal direkomendasikan, tetapi tidak wajib
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - Yang kedua adalah dengan menggunakan **`Rx`** dan Darts Generics, `Rx<Type>`

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0)
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Kelas Kustom - ini bisa jadi kelas apapun, secara harfiah
final user = Rx<User>();
```

3 - Yang ketiga, cara yang lebih praktis, mudah dan lebih disukai, cukup tambahkan **`.obs`** sebagai properti dari `value` anda:

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Kelas Kustom - ini bisa jadi kelas apapun, secara harfiah
final user = User().obs;
```

#### Memiliki sebuah reactive state itu, mudah

Seperti yang kita ketahui, _Dart_ saat ini sedang mempersiapkan ke _null safety_.
Sebagai persiapan, mulai dari sekarang, anda harus selalu memulai variabel _Rx_ anda dengan sebuah **initial value** (nilai awal).

> Mengubah sebuah variabel menjadi sebuah _observable_ + _initial value_ dengan **GetX** adalah cara yang paling sederhana, dan sangat praktis.

Anda hanya cukup menambahkan sebuah "`.obs`" di akhir variabel anda, dan **selesai**, anda telah membuatnya observable,
dan untuk `.value` nya, yah, _initial value_ yang anda berikan.

### Menggunakan value didalam view

```dart
// file controller
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// file view
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

Jika kita meng-increment `count1.value++`, ini akan mencetak:

- `count 1 rebuild`
- `count 3 rebuild`

karena `count1` memiliki nilai `1`, dan `1 + 0 = 1`, mengubah nilai dari getter `sum`.

Jika kita mengubah `count2.value++`, ini akan mencetak:

- `count 2 rebuild`
- `count 3 rebuild`

karena `count2.value` berubah, dan hasil dari `sum` sekarang adalah `2`.

- CATATAN: Secara default, event yang paling pertama akan merebuild widget, meskipun `value` nya sama.
  perilaku ini hadir karena variabel Boolean.

Bayangkan anda melakukan ini:

```dart
var isLogged = false.obs;
```

Dan kemudian, anda melakukan pengecekan apakah user "sudah login" untuk men-trigger sebuah event didalam `ever`.

```dart
@override
onInit(){
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

jika `hasToken` nilainya `false`, tidak akan terjadi apa apa kepada `isLogged`, jadi `ever()` tidak akan dipanggil.
Untuk menghindari jenis perilaku ini, perubahan awal terhadap sebuah _observable_ harus selalu men-trigger sebuah event,
bahkan ketika mereka memiliki `.value` yang sama.

Anda bisa menghapus perilaku ini jika anda mau, menggunakan:
`isLogged.firstRebuild = false;`

### Kondisi untuk rebuild

Selain itu, Get menyediakan state kontrol yang telah dipoles. Anda bisa mengkondisikan sebuah event (seperti menambahkan sebuah object kedalam list), dalam suatu kondisi.

```dart
// Parameter pertama: kondisi, harus me-return true atau false
// Parameter kedua: nilai baru yang akan dimasukkan jika kondisinya true
list.addIf(item < limit, item);
```

Tanpa decoration, tanpa code generator, tanpa komplikasi :smile:

Anda tahu counter app milik Flutter? Controller anda mungkin terlihat seperti ini:

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Hanya dengan:

```dart
controller.count.value++
```

Anda bisa memperbarui variabel counter di UI anda, tidak perduli dimanapun itu diletakkan.

### Dimana .obs bisa digunakan

Anda bisa mengubah apapun dengan obs. Berikut adalah dua cara untuk melakukannya:

* Anda bisa mengkonversi value kelas anda menjadi obs

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* atau anda bisa mengkonversi seluruh kelasnya menjadi observable

```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// saat menginstansiasi:
final user = User(name: "Camila", age: 18).obs;
```

### Catatan mengenai List

List, dia observable secara menyeluruh, termasuk objek didalamnya.
Dengan itu, jika anda menambahkan value kedalam list, dia akan secara otomatis merebuild widget yang menggunakannya.

Anda juga tidak perlu menggunakan ".value" ketika mengakses list, API dart yang luar biasa mengizinkan kita untuk menghapusnya.
Sayangnya, tipe data primitif seperti String dan int tidak bisa di extend, membuat penggunaan .value menjadi suatu hal yang wajib, tapi itu bukan masalah jika anda bekerja menggunakan getter dan setter untuk mereka.

```dart
// Didalam Controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// Didalam View
Text(controller.title.value), // String harus memiliki .value didepannya
ListView.builder (
  itemCount: controller.list.length // list tidak perlu itu
)
```

Ketika anda membuat kelas anda sendiri observable, ada berbagai cara untuk memperbaruinya:

```dart
// didalam file model
// kita akan membuat seluruh kelas menjadi observable daripada
// mengimplementasikannya pada masing-masing atribut.
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}


// didalam file controller
final user = User().obs;
// ketika anda perlu mengupdate variabel user:
user.update( (user) { // parameter ini adalah kelas itu sendiri yang akan anda update
  user.name = 'Jonny';
  user.age = 18;
});
// cara alternatif untuk melakukannya:
user(User(name: 'João', age: 35));

// didalam view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// anda juga bisa mengakses nilai model tanpa .value:
user().name; // perhatikan bahwa yang digunakan adalah variabel user, bukan kelasnya (variabel memiliki "u" kecil)
```

Anda tidak perlu bekerja dengan sets jika anda tidak mau. Anda bisa menggunakan API "assign" dan "assignAll".
API "assign" akan membersihkan list anda, dan memasukkan satu objek sebagai permulaan.
API "assignAll" akan membersihkan list yang sudah ada dan menambahkan objek iterable yang anda inject kedalamnya.

### Mengapa harus menggunakan .value

Kami bisa saja menghapus kebijakan untuk menggunakan 'value' pada `String` dan `int` dengan decoration sederhana dan code generator, tapi tujuan dari library ini adalah untuk menghindari dependensi eksternal. Kami ingin menawarkan sebuah environment yang siap untuk programming, melibatkan hal-hal penting (route, dependency, dan state management), dengan cara yang sederhana, ringan, dan cepat, tanpa membutuhkan package dari luar.

Anda bisa secara harfial menambahkan 3 huruf ke pubspec anda dan sebuah titik dua dan mulai membuat sebuah program. Semua solusi sudah termasuk secara default, mulai dari route management, hingga state management, menargetkan kemudahan, produktifitas dan performa.

Berat total dari library ini kurang dari satu state manager, meskipun ini adalah solusi komplit, dan inilah yang harus anda pahami.

Jika anda terganggu dengan `.value`, dan menyukai code generator, MobX adalah alternatif yang baik, dan anda bisa menggunakannya bersamaan dengan Get. Untuk kalian yang ingin menambahkan satu dependensi di pubspec dan mulai membuat sebuah program tanpa mengkhawatirkan versi dari sebuah package tidak kompatibel dengan yang lain, atau sebuah error dari perbaruan state datang dari state manager atau dependensi, atau semacamnya, dan tidak mau khawatir tentang ketersediaan controller, ataupun secara harfiah "hanya ingin membuat program", get sudah sangat sempurna.

Jika anda merasa tidak masalah dengan code generator MobX, atau tidak masalah dengan boilerplate dari BLoC, anda bisa menggunakan Get untuk route, dan lupakan bahwa dia memiliki state manager. Get SEM dan RSM lahir karena kebutuhan, perusahaan saya memiliki proyek dengan lebih dari 90 controller, dan code generator sederhananya memakan waktu 30 menit untuk menyelesaikan tugasnya setelah Flutter Clean di komputer yang secara masuk akal bagus, jika proyek anda memiliki 5, 10, hingga 15 controller, state manager apapun akan mensuplai anda dengan baik. Jika anda memiliki proyek yang secara absurd berskala besar, dan code generator adalah masalah untuk anda, maka anggap ini sebagai hadiah.

Jelas, jika seseorang ingin berkontribusi terhadap proyek dan membuat sebuah code generator, atau sejenisnya, Saya akan tautkan kedalam readme ini sebagai alternatif, kebutuhan saya bukan kebutuhan untuk semua developer, namun untuk saat ini Saya mengatakan, sudah ada solusi yang baik diluar sana yang sudah melakukan hal itu, seperti MobX.

### Obx()

Memberi tipe di Get saat menggunakan Binding tidak diperlukan. Anda bisa menggunakan widget Obx daripada GetX yang mana hanya menerima fungsi anonim yang membuat sebuah widget.
Jelas, jika anda tidak menggunakan sebuah tipe, anda harus memiliki sebuah instance dari controller anda untuk menggunakan variabel didalamnya, atau gunakan `Get.find<Controller>()` .value atau Controller.to.value untuk mengambil value.

### Worker

Worker akan membantu anda, men-trigger callback spesifik ketika sebuah event terjadi.

```dart
/// Terpangil setiap kali `count1` berubah.
ever(count1, (_) => print("$_ telah dirubah"));

/// Terpanggil hanya pada saat pertama kali variabel $_ dirubah.
once(count1, (_) => print("$_ telah dirubah sekali"));

/// Anti DDos - Terpangil setiap kali the user berhenti mengetik setelah 1 detik, contoh:
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Abaikan semua perubahan selama 1 detik.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

Semua worker (kecuali `debounce`) memiliki sebuah `condition` named parameter, yang bisa jadi sebuah `bool` atau sebuah callback yang mereturn `bool`
`condition` ini terdefinisikan ketika fungsi `callback` di eksekusi.

Semua worker mereturn sebuah instance `Worker`, yang bisa anda gunakan untuk membatalkan worker tersebut (melalui `dispose()`).

- **`ever`**\
terpanggil setiap kali variabel _Rx_ meng-emit value baru.

- **`everAll`**\
Mirip seperti `ever`, tapi menerima `List` sebagai nilai _Rx_, terpanggil setiap kali variabel berubah.

- **`once`**\
Terpanggil hanya sekali pada saat pertama kali variabel berubah.

- **`debounce`**\
'debounce' sangat berguna pada fungsi pencarian, dimana anda hanya ingin API dipanggil ketika user selesai mengetik. Jika user mengetik "Jonny", anda akan pendapatkan 5 pencarian di API, dengan huruf J, o, n, n, dan y. Dengan Get, ini tidak terjadi lagi, karena anda memiliki sebuah "debounce" worker, yang akan men-trigger pada akhir pengetikan.

- **`interval`**\
berbeda dengan debounce. untuk debounce, jika user melakukan 1000 perubahan terhadap sebuah variabel dalam 1 detik, dia akan mengirim hanya yang terakhir setelah waktu yang ditetapkan (defaultnya adalah 800 milisekon).
\
\
Interval bekerja sebaliknya, dia akan mengabaikan semua interaksi user dalam rentang waktu yang ditentukan. Jika anda mengirim event dalam 1 menit, 1000 per detik, debounce akan mengirimkan anda yang terakhir, ketika user berhenti melakukan spam terhadap event. Interval akan mengantar event setiap detik, dan jika diatur menjadi 3 detik, dia akan mengirimkan 20 event setiap menit.
\
\
Ini direkomendasikan untuk menghindari penyalahgunaan, dalam fungsi dimana user bisa secara cepat melakukan klik pada sesuatu untuk mendapatkan sebuah keuntungan (bayangkan jika user bisa mendapat koin dengan meng-klik pada sesuatu, jika dia mengklik 300 kali dalam 1 menit, dia akan mendapatkan 300 koin, menggunakan interval, anda bisa mengatur jangka waktu selama 3 detik, dan meskipun user meng-klik sebanyak 300 kali atau ribuan kali, maksimum koin yang bisa dia dapatkan dalam 1 menit akan selalu 20 koin, bahkan ketika dia meng-klik 1 juta kali sekalipun)
\
\
Debounce cocok sebagai anti-DDos, untuk fungsi seperti search dimana setiap perubahan terhadap onChange akan mengirim sebuah query ke API anda. Debounce akan menunggu user berhenti mengetik nama, untuk membuat sebuah request. Jika ini digunakan pada skenario koin diatas, user hanya akan mendapatkan 1 koin, karena hanya akan di eksekusi ketika user memberi jeda terhadap waktu yang ditentukan.

- CATATAN: Worker harus selalu digunakan ketika memulai sebuah Controller atau Class, jadi dia harus selalu diletakkan didalam onInit (direkomendasikan), Class constructor, atau initState dari StatefulWidget (praktik ini tidak direkomendasikan dalam kebanyakan kasus, dan tidak akan ada side effect).

## Simple State Manager

Get memiliki state manager yang sangat ringan dan mudah, dan tidak menggunakan ChangeNotifier, yang akan memenuhi kebutuhan khususnya untuk mereka yang baru di Flutter, dan tidak akan membuat masalah untuk aplikasi besar.

GetBuilder membidik dengan tepat pada state control multipel. Bayangkan anda menambahkan 30 produk kedalam sebuah keranjang belanja, anda meng-klik "delete" pada salah satu produk tersebut, di waktu yang sama, list, harga, dan badge diperbarui ke angka yang lebih kecil. Pendekatan ini membuat GetBuilder mematikan, karena mengelompokkan state dan mengubah semuanya secara bersamaan dalam satu waktu tanpa "computational logic" untuk itu. Getbuilder dibuat dengan mempertimbangkan situasi seperti ini, untuk perubahan state "ephemeral", anda bisa menggunakan setState dan anda tidak membutuhkan sebuah state manager untuk itu.

Dengan begitu, jika anda menginginkan controller yang bekerja secara individu, anda bisa mengajukan ID untuknya, atau gunakan GetX. Semuanya terserah anda, mengingat bahwa semakin banyak "individual" widget yang anda miliki, performa dari GetX akan semakin terlihat, sementara performa dari GetBuilder harusnya lebih superior, ketika terjadi perubahan state secara multipel.

### Keuntungan

1. Hanya memperbarui widget yang diperlukan

2. Tidak menggunakan changeNotifier, ini adalah state manager yang menggunakan memori lebih kecil (mendekati 0mb).

3. Lupakan StatefulWidget! Dengan Get, anda tidak akan pernah membutuhkannya. Dengan state manager lain, anda mungkin harus menggunakan StatefulWidget untuk mendapatkan sebuah instance milik anda dari Provider, BLoC, MobX Controller, dsb. Tapi pernahkah anda berhenti untuk berfikir bahwa appBar, scaffold, dan kebanyakan widget anda itu stateless? Lalu mengapa menyimpan state dari seluruh kelas, jika anda hanya bisa menyimpan state dari Widget yang stateful? Get menyelesaikan masalah itu, juga. Buat kelas Stateless, buat semuanya stateless. Jika anda butuh update pada satu komponen, bungkus komponen itu dengan GetBuilder, dan state-nya akan di-maintain.

4. Organisir proyek anda secara nyata! Controller tidak seharusnya ada di UI, letakkan TextEditingController anda, atau controller apapun didalam kelas Controller anda.

5. Apakah anda perlu men-trigger sebuah event untuk widget segera setelah dirender? GetBuilder memiliki properti "initState", sama seperti StatefulWidget, dan anda akan bisa memanggil event dari controller anda, langsung dari sana, tidak ada lagi event diletakkan didalam initState anda.

6. Apakah anda perlu men-trigger sebuah action seperti menutup stream, timer, dan semacamnya? GetBuilder juga memiliki properti dispose, dimana anda bisa memanggil event segera setelah widget dihancurkan.

7. Gunakan stream hanya jika dibutuhkan. Anda bisa menggunakan StreamController didalam controller anda secara normal, dan menggunakan StreamBuilder juga secara normal, namun perlu di ingat, sebuah stream cukup memakan memori, reactive programming itu indah, namun anda tidak boleh menyalahgunakannya. 30 stream terbuka secara simultan bisa lebih buruk daripada changeNotifier (dan changeNotifier itu sangat buruk).

8. Perbarui widget tanpa menghabiskan RAM untuk itu. Get menyimpan hanya creator ID milik GetBuilder, dan memperbarui GetBuilder tersebut ketika diperlukan. Konsumsi memori dari get ID storage sangat rendah bahkan untuk ribuan GetBuilder sekalipun. Ketika anda membuat GetBuilder baru, anda sebenarnya berbagi state dari GetBuilder yang memiliki creator ID. State baru tidak dibuat untuk setiap GetBuilder, yang mana menghemat SANGAT BANYAK RAM untuk aplikasi berskala besar. Pada dasarnya, aplikasi anda akan Stateless secara menyeluruh, dan semakin sedikit Widget yang akan Stateful (didalam GetBuilder) akan memiliki satu state, dan oleh karena itu, mengupdate salah satu dari mereka akan mengupdate semuanya. State nya hanya satu.

9. Get maha tahu, dan dalam kebanyakan kasus, dia mengetahui dengan tepat kapan harus menghapus sebuah controller dari memori. Anda tidak perlu khawatir tentang kapan harus men-dispose sebuah controller, Get tahu waktu terbaik untuk melakukannya.

### Penggunaan

```dart
// Buat kelas controller dan extends GetxController
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // gunakan update() untuk mengupdate variabel counter di UI ketika increment dipanggil
  }
}
// Pada Stateless/Stateful widget anda, gunakan GetBuilder untuk mengupdate Text ketika increment dipanggil
GetBuilder<Controller>(
  init: Controller(), // INISIALISASIKAN CONTROLLER HANYA UNTUK PERTAMA KALI
  builder: (_) => Text(
    '${_.counter}',
  ),
)
// Inisialisasi controller anda hanya untuk pertama kali. Kedua kalinya anda menggunakan ReBuilder untuk controller yang sama, dan jangan gunakan itu lagi. Controller anda akan secara otomatis dihapus dari memori segera setelah widget yang ditandai sebagai 'init' di-deploy. Anda tidak perlu khawatir tentang itu, Get akan melakukannya secara otomatis, cukup pastikan anda tidak memulai controller yang sama dua kali.
```

**Selesai!**

- Anda sudah mempelajari bagaimana caranya memanage state menggunakan Get.

- Catatan: Anda mungkin menginginkan organisasi yang lebih besar, dan tidak menggunakan properti init. Untuk itu, anda bisa membuat kelas dan meng-extends kelas Bindings, dan didalamnya, sebutkan controller yang akan dibuat untuk route tersebut. Controller tidak akan dibuat pada waktu itu, sebaliknya, ini hanyalah sebuah statement, jadi pada saat pertama kali anda menggunakan sebuah Controller, Get akan tahu dimana harus mencarinya. Get akan melakukan lazyload, dan akan melanjutkan untuk men-dispose controller yang tidak lagi digunakan. Lihat contoh di pub.dev untuk melihat bagaimana cara kerjanya.

Jika anda bernavigasi ke banyak route dan membutuhkan data dari controller yang sebelumnya anda gunakan, anda hanya perlu menggunakan GetBuilder lagi (tanpa init):

```dart
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

Jika anda perlu menggunakan controller anda di banyak tempat, dan diluar dari GetBuilder, cukup buat getter didalam controller anda dan anda akan mendapatkannya dengan mudah (atau gunakan `Get.find<Controller>()`)

```dart
class Controller extends GetxController {

  /// Anda tidak membutuhkan itu. Saya menyarankan menggunakannya hanya untuk kemudahan sintaks.
  /// dengan static method: Controller.to.increment();
  /// tanpa static method: Get.find<Controller>().increment();
  /// Tidak ada perbedaan dari segi performa, atau efek samping apapun dalam menggunakan kedua sintaks diatas. Yang berbeda hanyalah yang satu tidak memerlukan type, dan yang satu lagi akan di autocomplete oleh IDE.
  static Controller get to => Get.find(); // Tambahkan baris ini

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

Dan anda bisa mengakses controller secara langsung, dengan cara itu:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // Ini luar biasa simpel!
  child: Text("${Controller.to.counter}"),
),
```

Ketika anda menekan FloatingActionButton, semua widget yang me-listen variabel 'counter' akan diupdate secara otomatis.

### Bagaimana Get meng-handle controller

Anggaplah kita memiliki ini:

`Class A => Class B (memiliki controller X) => Class C (memiliki controller X)`

Di kelas A, controller belum ada di memori, karena anda belum menggunakannya (Get itu lazyload). Di kelas B anda menggunakan controller tersebut, dan controller itu masuk kedalam memori. Di kelas C, anda menggunakan controller yang sama seperti di kelas B, Get akan berbagi state dari controller B dengan controller C, dan controller yang sama akan tetap ada di memori.

Jika anda menutup screen C dan screen B, Get akan secara otomatis menghapus controller X dari memori dan membebaskan resource, karena kelas A tidak menggunakan controller. Jika anda bernavigasi ke kelas B lagi, controller X akan masuk ke memori lagi, jika daripada menuju ke kelas C, anda kembali ke kelas A lagi, Get akan menghapus controller dari memori dengan cara yang sama. Jika kelas C tidak menggunakan controller, dan anda mengeluarkan kelas B dari memori, tidak ada kelas yang menggunakan controller X dan demikian pula kelas itu akan dibuang.

Satu-satunya exception yang bisa mengacau dengan Get, adalah jika anda menghapus B dari route secara tidak sengaja, dan mencoba menggunakan controller di C. Dalam kasus ini, creator ID dari controller yang ada di B terhapus, dan Get diprogram untuk menghapusnya dari memori untuk setiap controller yang tidak memiliki creator ID. Jika anda berniat melakukan ini, tambahkan flag "autoRemove: false" ke GetBuilder di kelas B dan gunakan "adoptID = true;" di GetBuilder pada kelas C.

### Anda tidak membutuhkan StatefulWidget lagi

Menggunakan StatefulWidget berarti menyimpan sebuah state dari seluruh layar secara tidak perlu, meski karena anda perlu untuk merebuild sebuah widget secara minimal, anda akan menyematkannya kedalam Consumer/Observer/BlocProvider/GetBuilder/GetX/Obx, yang mana akan menjadi StatfulWidget yang lain.

StatefulWidget adalah sebuah kelas yang lebih besar daripada StatelessWidget, yang mana akan mengalokasi lebih banyak RAM, dan ini mungkin tidak akan membuat perbedaan secara signifikan antara satu atau dua kelas, tapi itu pasti akan terjadi ketika anda memiliki 100 dari mereka!
Kecuali anda perlu menggunakan mixin, seperti TickerProviderStateMixin, akan sangat tidak dibutuhkan menggunakan StatefulWidget dengan Get.

Anda bisa memanggil semua method dari StatefulWidget secara langsung melalui GetBuilder.
Jika anda perlu memanggil initState() atau dispose() method contohnya, anda bisa memanggilnya secara langsung;

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Cara yang lebih baik daripada ini adalah dengan menggunakan onInit() dan onClose() method secara langsung dari controller anda.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- CATATAN: Jika anda ingin memulai sebuah method pada saat controller dipanggil pertama kali, anda TIDAK PERLU menggunakan constructor, faktanya, menggunakan package yang berorientasi pada performa seperti Get, ini berbatas pada bad practice, karena menyimpang dari logic dimana setiap controller dibuat atau dialokasikan (jika anda membuat sebuah instance dari controller, constructornya akan dipanggil dengan segera, anda akan menumpuk controller bahkan sebelum digunakan, anda mengalokasikan memori tanpa digunakan, hal ini benar-benar menyakiti prinsip dasar library ini). method onInit(); dan onClose(); dibuat untuk hal ini, mereka akan dipanggil ketika Controller dibuat, atau digunakan untuk pertama kali, bergantung pada kondisi apakah anda menggunakan Get.lazyPut atau tidak. Jika anda mau, sebagai contoh, membuat sebuah panggilan ke API anda untuk mempopulasikan data, anda bisa lupakan tentang metode lawas initState/dispose, cukup mulai memanggilnya didalam onInit, dan jika anda perlu meng-eksekusi perintah seperti menutup stream, gunakan onClose() untuk hal itu.

### Mengapa GetX ada

Tujuan dari package ini adalah secara tepat memberikan anda sebuah solusi komplit untuk navigasi route, dependency dan state management, menggunakan sedikit mungkin dependensi, dengan tingkat decoupling yang tinggi. Get melibatkan semua Flutter API baik dari level tertinggi dan terendah dalam dirinya sendiri, untuk memastikan bahwa anda bekerja dengan sedikit mungkin keterkaitan (coupling). Kami memusatkan semuanya kedalam satu package, untuk memastikan bahwa anda tidak memiliki keterkaitan (coupling) di proyek anda. Dengan begitu, anda bisa menaruh hanya widget di view anda, dan membiarkan bagian tim anda yang bekerja dengan business logic secara bebas, bekerja dengan business logic tanpa bergantung pada elemen apapun yang ada didalam View. Ini menyediakan lingkungan kerja yang lebih bersih, jadi bagian yang lain dari tim anda bisa bekerja hanya dengan widget, tanpa khawatir tentang mengirim data dari controller anda.

Jadi untuk menyederhanakannya:
Anda tidak perlu memanggil method di initState dan mengirim mereka menggunakan parameter ke controller anda, atau menggunakan constructor didalam controller anda untuk itu, anda memiliki method onInit() yang akan dipanggil di waktu yang tepat untuk memulai service anda.
Anda tidak perlu memanggil perangkatnya, anda memiliki method onClose() yang akan dipanggil di momen yang tepat ketika controller tidak lagi dibutuhkan dan akan dihapus dari memori. Dengan begitu, biarkan views hanya untuk widget, menghindari berbagai macam business logic darinya.

Jangan memanggil dispose method didalam GetxController, itu tidak akan melakukan apa-apa, ingat bahwa controller bukanlah sebuah Widget, anda tidak seharusnya men-"dispose" sebuah controller, dan dia akan secara otomatis dan secara pandai dihapus dari memori oleh Get. Jika anda menggunakan stream didalamnya dan ingin menutupnya, cukup masukkan itu kedalam close method. Contoh:

```dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// menutup stream = onClose method, bukan dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Controller life cycle (atau: siklus kehidupan controller):

- onInit() dimana ketika Controller dibuat.
- onClose() dimana ketika Controller ditutup untuk membuat segala jenis perubahan dalam rangka persiapan untuk metode penghapusan
- deleted: anda tidak lagi memiliki akses ke API ini karena secara harfiah menghapusnya dari memori, dan secara harfiah pula itu dihapus, tanpa meninggalkan jejak.

### Cara lain dalam menggunakannya

Anda bisa menggunakan Controller secara langsung didalam GetBuilder value:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', // Disini
  ),
),
```

Anda juga mungkin membutuhkan sebuah instance dari controller anda diluar GetBuilder, dan anda bisa menggunakan pendekatan ini:

```dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// didalam View:
GetBuilder<Controller>(  
  init: Controller(), // Gunakan ini hanya untuk pertama kali pada setiap controller
  builder: (_) => Text(
    '${Controller.to.counter}', // Disini
  )
),
```

atau

```dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // tanpa static getter
[...]
}
// didalam stateful/stateless class
GetBuilder<Controller>(  
  init: Controller(), // Gunakan ini hanya untuk pertama kali pada setiap controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // Disini
  ),
),
```

- Anda bisa menggunakan cara "non-canonical" untuk hal ini. Jika anda menggunakan dependensi manager lain, seperti get_it, modular, etc., dan hanya ingin mengirimkan instance controller, anda bisa melakukan ini:

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, // Disini
  builder: (_) => Text(
    '${controller.counter}', // Disini
  ),
),

```

### Unique ID

Jika anda ingin me-refine update control sebuah widget dengan GetBuilder, anda bisa mengajukan unique ID untuk mereka:

```dart
GetBuilder<Controller>(
  id: 'text' // Disini
  init: Controller(),
  builder: (_) => Text(
    '${Get.find<Controller>().counter}',
  ),
),
```

Dan mengupdatenya dalam bentuk ini:

```dart
update(['text']);
```

Anda juga bisa menerapkan kondisi untuk updatenya:

```dart
update(['text'], counter < 10);
```

GetX melakukan ini secara otomatis dan hanya merekonstruksi widget yang menggunakan variabel persis yang dirubah, jika anda mengubah sebuah variabel dengan hal yang sama seperti sebelumnya, dan tidak mengimplifikasikan sebuah perubahan sate , GetX tidak akan merebuild widget untuk menghemat memori dan siklus CPU.

## Mencampur 2 state manager

Beberapa orang membuka sebuah permintaan fitur, karena mereka hanya ingin menggunakan satu jenis variabel reaktif, dan mekanisme lain, dan diharuskan untuk memasukkan Obx kedalam GetBuilder untuk hal ini. Memikirkan hal ini, MixinBuilder dibuat. Ini mengizinkan kedua perubahan reaktif dengan mengubah variabel ".obs", dan mekanikal update via update(). Meski begitu, dari 4 widget dia adalah satu-satunya yang mengonsumsi resource paling banyak, karena selain memiliki langganan untuk menerima event perubahan dari children nya, dia juga berlangganan kepada metode update di controllernya.

Meng-extend GetxController sangatlah penting, karena mereka memiliki siklus dan bisa "memulai" dan "mengakhiri" event di method onInit() dan onClose() mereka. Anda bisa menggunakan kelas apapun untuk ini, tapi Saya sangat merekomendasikan anda untuk menggunakan kelas GetxController untuk menempatkan variabel anda, baik apakah mereka observable atau tidak.

## GetBuilder vs GetX vs Obx vs MixinBuilder

Dalam satu dekade bekerja dengan programming Saya mendapat beberapa pelajaran berharga.

Kontak pertama saya dengan reactive programming adalah seperti "waw, ini luar biasa" dan faktanya, reactive programming itu luar biasa.
Meski begitu, ini tidak cocok untuk segala situasi. Terkadang semua yang anda butuhkan adalah mengubah state dari 2 atau 3 widget dalam waktu yang sama, atau sebuah perubahan state sementara, yang mana reactive programming tidaklah buruk, tapi tidak cocok.

Reactive programming memiliki konsumsi lebih tinggi dalam penggunaan RAM yang bisa dikompensasi oleh alur kerja individu, dimana akan memastikan bahwa hanya satu widget direbuild dan jika dibutuhkan, namun membuat sebuah list dari 80 objek, masing masing dengan beberapa stream bukanlah ide yang bagus. Buka dart inspect dan cek berapa banyak yang dikonsumsi oleh StreamBuilder, dan anda akan memahami apa yang saya coba katakan kepada anda.

Dengan memikirkan hal itu, Saya membuat sebuah state manager yang simpel. Ini simpel, dan itulah yang harus anda tuntut darinya: mengupdate state dalam sebuah block dengan cara yang sederhana, dan dengan cara yang paling ekonomis.

GetBuilder sangat ekonomis di RAM, dan hampir tidak ada pendekatan yang lebih ekonomis darinya (setidaknya saya tidak bisa membayangkannya, jika itu ada, mohon beri tahu kami).

Meski begitu, GetBuilder tetaplah sebuah state manager mekanik, anda perlu memanggil update() seperti anda perlu memanggil notifyListeners() milik Provider.

Ada beberapa situasi lain dimana reactive programming benar benar menarik, dan tidak bekerja dengan itu sama saja seperti "reinventing the wheel". Dengan memikirkan hal itu, GetX dibuat untuk menyediakan semuanya yang paling modern dan advanced dalam sebuah state manager. Dia mengupdate hanya apa yang diperlukan dan ketika diperlukan, jika anda memiliki error dan mengirim 300 perubahan state secara beruntun, GetX akan memfilter dan mengupdate layar hanya jika state nya benar-benar berubah.

GetX masih lebih ekonomis dari reactive state manager yang lain, namun dia juga menkonsumsi sedikit lebih banyak RAM daripada GetBuilder. Memikirkan tentang hal itu dan menargetkan untuk memaksimalkan konsumsi resource yang dibuat oleh Obx. Tidak seperti GetX dan GetBuilder, anda tidak akan bisa menginisialisasi sebuah controller didalam Obx, itu hanyalah sebuah widget dengan StreamSubscription yang menerima event perubahan dari children anda, itu saja. Ini lebih ekonomis dari GetX, namun kalah dari GetBuilder, yang memang diharapkan, karena dia reactive dan GetBuilder memiliki pendekatan yang paling sederhana yang ada, untuk menyimpan hashCode milik sebuah widget dan StateSetter nya. Dengan Obx anda tidak perlu menulis tipe controller, dan anda bisa mendengar perubahan dari banyak controller yang berbeda, namun itu harus di inisialisasi sebelumnya, baik menggunakan contoh pendekatan di awal readme ini, atau menggunakan Binding class.

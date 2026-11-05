<div dir="rtl" lang="fa">

# GetX 5 — راهنمای جامع فارسی

[![pub package](https://img.shields.io/pub/v/get.svg?label=get)](https://pub.dev/packages/get)

[English](README.md) · [فارسی](README-fa.md) · [العربية](README-ar.md) · [বাংলা](README-bn.md) · [Español](README-es.md) · [Français](README-fr.md) · [हिन्दी](README-hi.md) · [Tiếng Việt](README-vi.md) · [Indonesia](README.id-ID.md) · [日本語](README.ja-JP.md) · [한국어](README.ko-kr.md) · [Polski](README.pl.md) · [Português](README.pt-br.md) · [Русский](README.ru.md) · [Türkçe](README.tr-TR.md) · [اردو](README.ur-PK.md) · [中文](README.zh-cn.md)

این راهنما تمام سرفصل‌های README انگلیسی را با مثال‌های همان شاخه پوشش می‌دهد. وضعیت نسخه، تغییرات و محدودیت‌ها در متن هر بخش آمده‌اند.

## فهرست

- [دربارهٔ GetX](#about)
- [سازگاری و نصب](#installation)
- [برنامهٔ کامل شمارنده](#counter)
- [سه رکن اصلی: مدیریت وضعیت](#state)
- [مقدارهای واکنشی، مجموعه‌ها و مدل‌ها](#rx)
- [Workerها و آزادسازی منابع](#workers)
- [StateMixin و وضعیت ناهم‌زمان](#status)
- [سه رکن اصلی: مدیریت وابستگی](#dependency)
- [Binding، مالکیت و چرخهٔ عمر](#bindings)
- [GetxService و آماده‌سازی ناهم‌زمان](#services)
- [سه رکن اصلی: مدیریت مسیر](#navigation)
- [مسیر تو‌در‌تو، deep link و تنظیمات برنامه](#nested)
- [دیالوگ، bottom sheet و snackbar](#overlays)
- [تاریخچهٔ مسیر نام‌دار و بازیابی وضعیت](#restoration)
- [بین‌المللی‌سازی و زبان](#translations)
- [پوسته و تنظیمات برنامه](#themes)
- [GetConnect: درخواست HTTP و بارگذاری](#http)
- [Modifier، احراز هویت و پردازش پاسخ](#interceptors)
- [WebSocket و dispose](#socket)
- [Middleware در GetPage](#middleware)
- [APIهای پیشرفتهٔ مسیر، پلتفرم و context](#advanced)
- [تنظیمات سراسری، لاگ و مسیریاب سفارشی](#configuration)
- [وضعیت محلی: ValueBuilder و ObxValue](#local)
- [GetView، GetWidget و View واکنش‌گرا](#views)
- [کار صف‌شده و لغو](#queue)
- [تست کنترلر، ویجت و پلتفرم](#tests)
- [مهاجرت از نسخه‌های قبلی GetX](#migration)
- [تغییرات این نامزد انتشار](#changes)
- [محدودیت‌های شناخته‌شده و دامنهٔ پشتیبانی](#limitations)
- [مثال‌ها و دستورهای اعتبارسنجی](#examples)
- [چرا GetX و اکوسیستم آن](#why)
- [جامعه، مشارکت و مجوز](#community)

<a id="about"></a>

## دربارهٔ GetX

GetX ابزارهای مدیریت وضعیت واکنشی و ساده، تزریق وابستگی، مسیریابی، overlay، ترجمه و ارتباط شبکه را برای Flutter فراهم می‌کند. سه هدف اصلی آن بهره‌وری، کارایی و سازمان‌دهی کد هستند. می‌توانید فقط ماژول مورد نیازتان را استفاده کنید؛ مدیریت وضعیت و دریافت وابستگی به GetMaterialApp نیاز ندارند.

منطق برنامه را در کنترلر و سرویس نگه دارید و View را با binding به آن متصل کنید. محدودهٔ بازسازی واکنشی را کوچک بگیرید و مالک timer، subscription و کنترلر را مشخص کنید. GetX APIهای stream هم دارد، اما لازم نیست برای هر مقدار یک StreamController و StreamBuilder دستی بسازید. انتخاب GetX جای بررسی کارایی و مدیریت منابع خارجی برنامه را نمی‌گیرد.

<a id="installation"></a>

## سازگاری و نصب

این README مخصوص کد GetX 5 RC در همین checkout است؛ API و نوع‌های عمومی شاخهٔ master ممکن است متفاوت باشند. نسخهٔ پکیج **5.0.0-release-candidate-9.4.0 و یک نامزد انتشار منتشرنشده** است. انتشار نسخهٔ stable یک مرحلهٔ جداگانه است.

مبنای اعتبارسنجی **Flutter 3.47.9 و Dart 3.13.7** است. manifest حداقل Flutter 3.47.9 و Dart 3.13.7 تا قبل از ۴ را می‌پذیرد؛ این حدود به معنی تأیید خودکار تمام SDKها و پلتفرم‌های بعدی نیست. این شاخه از کتابخانه‌های Material و Cupertino همراه Flutter استفاده می‌کند؛ نوع‌های مستقل material_ui و cupertino_ui را با سازنده‌های آن ترکیب نکنید.

برای آزمایش، checkout مخزن را کنار یک برنامهٔ مستقل Flutter بگذارید و وابستگی مسیر زیر را اضافه کنید. سپس در برنامه، `flutter --version`، `flutter pub get`، `flutter analyze` و `flutter test` را اجرا کنید. وابستگی pub.dev ممکن است کد دیگری دریافت کند؛ نسخهٔ واقعاً منتشرشده را انتخاب و مستندات همان نسخه را مطالعه کنید. برای وابستگی منبع، commit بررسی‌شده را ثبت و تثبیت کنید. نشان pub.dev وضعیت نسخه‌های منتشرشده را نمایش می‌دهد.

<div dir="ltr">

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

</div>

<a id="counter"></a>

## برنامهٔ کامل شمارنده

این مثال کامل را در lib/main.dart قرار دهید. binding برنامه، GetView، Obx و رویداد کنترلر را در عمل نشان می‌دهد. کنترلر یک‌بار با binding برنامه ثبت می‌شود و در هر build دوباره ساخته نمی‌شود. GetMaterialApp مسیریاب و امکانات سطح برنامهٔ GetX را تنظیم می‌کند؛ برای استفادهٔ مستقل از مدیریت وضعیت و DI ضروری نیست.

دستورهای نمونه‌های بعدی، importهای Flutter Material و GetX زیر را فرض می‌کنند. تابع‌های کمکی را در تنظیمات یا رویداد مناسب برنامه فراخوانی کنید؛ همهٔ آن‌ها دستورهای شروع برنامه نیستند.

<div dir="ltr">

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(const CounterApp());

class CounterController extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    binds: [Bind.lazyPut<CounterController>(() => CounterController())],
    home: const CounterPage(),
  );
}

class CounterPage extends GetView<CounterController> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('GetX 5')),
    body: Center(child: Obx(() => Text('${controller.count.value}'))),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.increment,
      child: const Icon(Icons.add),
    ),
  );
}
```

</div>

<a id="state"></a>

## سه رکن اصلی: مدیریت وضعیت

برای مقدارهای واکنشی ساخته‌شده با .obs، از Obx یا GetX استفاده کنید. برای اعلان صریح تغییر، GetBuilder و update مناسب‌اند. مقدار واکنشی باید داخل builder خوانده شود تا وابستگی ثبت شود. تغییر یک فیلد عادی خودبه‌خود واکنشی نمی‌شود. StatefulWidget همچنان برای چرخهٔ عمر محلی ویجت و منابع Flutter کاربرد دارد.

<div dir="ltr">

```dart
class SimpleCounter extends GetxController {
  int count = 0;
  void increment() {
    count++;
    update();
  }
}

Widget simpleCounter() => GetBuilder<SimpleCounter>(
  init: SimpleCounter(),
  builder: (controller) => TextButton(
    onPressed: controller.increment,
    child: Text('${controller.count}'),
  ),
);
```

</div>

<a id="rx"></a>

## مقدارهای واکنشی، مجموعه‌ها و مدل‌ها

برای خواندن و نوشتن مقدار Rx از .value استفاده کنید. عملیات مجموعه‌های RxList، RxMap و RxSet اعلان تغییر می‌فرستند. در این نامزد، سازندهٔ بدون آرگومان هر بار مجموعهٔ مستقل و قابل تغییر می‌سازد؛ مجموعهٔ ورودی صریح، هویت و قابلیت تغییر خودش را حفظ می‌کند، از جمله محدودیت مجموعهٔ immutable. assignAll ورودی‌های مشترک و خود مجموعه را با snapshot امن مدیریت می‌کند.

فیلدهای داخل مدل سفارشی به‌طور خودکار رصد نمی‌شوند. برای اعلان تغییر، در update() یک مدل جایگزین برگردانید؛ به متد protected مربوط به notifier تکیه نکنید. اشتراک stream یک Rx می‌تواند لغو و دوباره برقرار شود؛ منابع را در پایان طول عمر مالک آزاد کنید.

<div dir="ltr">

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

</div>

<a id="workers"></a>

## Workerها و آزادسازی منابع

ever هر تغییر، once اولین تغییر مناسب، debounce تغییر پس از وقفه و interval تغییر با محدودکردن بسامد callback را مدیریت می‌کنند. این‌ها اثر جانبی هستند و جای builder رابط کاربری نیستند. handleهای Worker را نگه دارید و در onClose آزاد کنید. timer، اشتراک stream و کنترلر اسکرول یا انیمیشنی را هم که خودتان ساخته‌اید آزاد کنید. BuildContext را در سرویس با طول عمر زیاد ذخیره نکنید.

<div dir="ltr">

```dart
class SearchController extends GetxController {
  final query = ''.obs;
  final List<Worker> _workers = [];

  @override
  void onInit() {
    super.onInit();
    _workers.add(ever<String>(query, (value) => Get.log('query: $value')));
    _workers.add(once<String>(query, (value) => Get.log('first: $value')));
    _workers.add(debounce<String>(
      query, (value) => Get.log('search: $value'),
      time: const Duration(milliseconds: 300),
    ));
    _workers.add(interval<String>(
      query, (value) => Get.log('sample: $value'),
      time: const Duration(seconds: 1),
    ));
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    query.close();
    super.onClose();
  }
}
```

</div>

<a id="status"></a>

## StateMixin و وضعیت ناهم‌زمان

`StateMixin<T>` حالت‌های loading، موفقیت همراه داده، empty و error را نمایش می‌دهد. در GetX 5 مقدار داده داخل وضعیت موفق است: از change(`GetStatus<T>.success(data)`) یا setSuccess(data) استفاده کنید. امضای قدیمی data همراه RxStatus مربوط به این API نیست. پیش از نمایش NamesView، کنترلر NamesController را با binding ثبت کنید.

futurize تابعی برای ساخت Future می‌گیرد و void برمی‌گرداند. با useEmpty:true که پیش‌فرض است، null یا iterable، map و رشتهٔ trimشدهٔ خالی به وضعیت empty تبدیل می‌شود. useEmpty:false موفقیت با دادهٔ خالی را حفظ می‌کند. فراخوانی‌های هم‌زمان به ترتیب تکمیل نتیجه اعمال می‌شوند، نه ترتیب شروع درخواست. تکمیل پس از dispose نادیده گرفته می‌شود؛ لغو و ترتیب درخواست‌های برنامه به سیاست صریح نیاز دارند.

<div dir="ltr">

```dart
class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);
}

class NamesView extends GetView<NamesController> {
  const NamesView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: controller.obx(
      (names) => Text(names.join(', ')),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data'),
      onError: (error) => Text(error ?? 'Unknown error'),
    ),
  );
}
```

</div>

<a id="dependency"></a>

## سه رکن اصلی: مدیریت وابستگی

Get.put نمونه را بلافاصله ثبت می‌کند و Get.lazyPut ساخت singleton را تا اولین دریافت عقب می‌اندازد. Get.spawn یک factory ثبت می‌کند که در هر Get.find نمونهٔ جدید می‌سازد؛ lazy singleton نیست. نوع و tag ثبت و دریافت باید یکی باشند. نمونه‌های مستقل factory هم باید مالک طول عمر داشته باشند.

Get.spawn جای global Get.create را می‌گیرد؛ Bind.create یک API محلی متفاوت با BuildContext است و نباید مکانیکی تغییر نام داده شود. factory مربوط به spawn به‌صورت پیش‌فرض permanent است؛ این ویژگی factory را نگه می‌دارد و نمونه‌ها را singleton مشترک نمی‌کند. Get.delete را با tag و طول عمر مناسب استفاده کنید و حذف اجباری یا reset را برای پاک‌سازی عمدی نگه دارید.

<div dir="ltr">

```dart
class Repository {}

void dependencyExamples() {
  Get.put<Repository>(Repository(), tag: 'primary');
  final repository = Get.find<Repository>(tag: 'primary');
  assert(identical(repository, Get.find<Repository>(tag: 'primary')));

  Get.lazyPut<Repository>(() => Repository(), tag: 'lazy');
  Get.spawn<Repository>(() => Repository(), tag: 'factory');
  final first = Get.find<Repository>(tag: 'factory');
  final second = Get.find<Repository>(tag: 'factory');
  assert(!identical(first, second));
}
```

</div>

<a id="bindings"></a>

## Binding، مالکیت و چرخهٔ عمر

Binding مفرد، `List<Bind>` برمی‌گرداند و با GetPage.bindings یا آرگومان bindings در مسیریابی مستقیم متصل می‌شود. GetPage.binds فهرست Bindها را می‌پذیرد و GetMaterialApp.binds وابستگی سطح برنامه را تنظیم می‌کند. Bindings جمع که deprecated است و دستورهای قدیمی initialBinding و BindingsBuilder، تنظیم پیشنهادی این شاخه نیستند.

SmartManagement.full پیش‌فرض و مالکیت binding در پاک‌سازی نقش دارند؛ permanent، fenix، autoRemove و factory معانی متفاوتی دارند. ثبت مشترک تا پایان طول عمر آخرین مالک مرتبط حفظ می‌شود و مالک قدیمی نباید ثبت جایگزین را حذف کند. GetView فقط lookup می‌کند و ثبت گم‌شده را نمی‌سازد. permanent کردن همهٔ کنترلرها راه اصلاح dispose نیست.

چرخهٔ عمر شامل onInit، onReady پس از فریم و onClose است. کنترلر حذف‌شده نباید onReady دیرهنگام دریافت کند. ساخت، rebuild معمول برنامه، اشتراک، جایگزینی و dispose نهایی را تست کنید.

<div dir="ltr">

```dart
class NamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<NamesController>(() => NamesController()),
  ];
}

Widget namesApplication() => GetMaterialApp(
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      page: () => const NamesView(),
      bindings: [NamesBinding()],
    ),
  ],
);
```

</div>

<a id="services"></a>

## GetxService و آماده‌سازی ناهم‌زمان

GetxService hookهای چرخهٔ عمر کنترلر را دارد و برای سرویس‌های با طول عمر برنامه مناسب است. حذف معمول از سرویس محافظت می‌کند، اما پاک‌سازی عمدی با force یا reset ممکن است. GetxService به معنی ذخیره‌سازی پایدار پس از مرگ process نیست.

Get.putAsync در این RC موجود نیست. ابتدا initialization را await و خطایش را مدیریت کنید، سپس نمونهٔ آماده را ثبت کنید. وابستگی‌ها را پیش از runApp به ترتیب مورد نیاز آماده کنید. مقدار تنظیمات این مثال نمایشی است؛ پیاده‌سازی ذخیره‌سازی خودتان را جایگزین کنید.

<div dir="ltr">

```dart
class SettingsService extends GetxService {
  String language = 'en';

  Future<SettingsService> init() async {
    language = await Future<String>.value('en');
    return this;
  }
}

Future<void> startWithServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
  runApp(const CounterApp());
}
```

</div>

<a id="navigation"></a>

## سه رکن اصلی: مدیریت مسیر

مسیریابی این RC بر پایهٔ Navigator 2 است. به Get.to، Get.off و Get.offAll تابع سازندهٔ ویجت بدهید. مقصد نام‌دار باید در getPages ثبت شود. off مقصد را جایگزین می‌کند و offAll تاریخچهٔ قبلی را کنار می‌گذارد. Get.`back<T>` نتیجهٔ هم‌نوع را برمی‌گرداند؛ برگشت سیستم یا لغو ممکن است null بدهد. عملیات navigation را در رویداد رابط یا callback مناسب اجرا کنید، نه در هر build.

<div dir="ltr">

```dart
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => Get.back<int>(result: 42),
      child: const Text('Return 42'),
    ),
  );
}

Future<int?> openDetails() async {
  final result = await Get.to<int>(() => const DetailsPage());
  return result;
}

Widget routedApplication() => GetMaterialApp(
  initialRoute: '/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(name: '/home', page: () => const CounterPage()),
    GetPage<int>(name: '/details', page: () => const DetailsPage()),
  ],
);

Future<int?> openNamedDetails() async => await Get.toNamed<int>('/details');
```

</div>

<a id="nested"></a>

## مسیر تو‌در‌تو، deep link و تنظیمات برنامه

ابتدا مسیر فرزند را با GetPage.children تعریف و سپس با GetRouterOutlet نمایش دهید. شناسهٔ delegate تو‌در‌تو در این RC رشته است؛ id مشخص‌کنندهٔ navigator یا delegate است، نه یک دیالوگ خاص. پیش از ورود به فرزند، سلسله‌مراتب متناظر را ثبت کنید. مثال کامل شامل redirect احراز هویت و مسیرهای dashboard و profile است.

میزبانی با URL مسیر باید برای مسیرهای فرزند، entry point برنامه را برگرداند. deep link از شروع سرد، refresh، bindingهای والد و فرزند و back/forward مرورگر را روی میزبان واقعی تست کنید. GetMaterialApp.router و GetCupertinoApp.router تنظیمات سفارشی مسیریاب را می‌پذیرند. مسیریاب پیش‌فرض routes map را هم سازگار می‌کند و RouteFactory پشتیبانی‌نشده را صریح گزارش می‌دهد. theme، locale، تنظیمات و مالکیت binding در rebuild معمول برنامه حفظ می‌شوند.

<div dir="ltr">

```dart
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GetRouterOutlet(
      anchorRoute: '/shell',
      initialRoute: '/shell/home',
    ),
  );
}

Widget nestedApplication() => GetMaterialApp(
  initialRoute: '/shell/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(
      name: '/shell',
      page: () => const ShellPage(),
      children: [
        GetPage<void>(name: '/home', page: () => const CounterPage()),
      ],
    ),
  ],
);
```

</div>

<a id="overlays"></a>

## دیالوگ، bottom sheet و snackbar

بستن صفحه و overlay عملیات جدا دارند. Get.back در این RC صفحه را برمی‌گرداند؛ رفتار overlay-first شاخهٔ master را به آن تعمیم ندهید. helper هم‌نوع و مربوط به overlay را انتخاب کنید. closeOverlay دیالوگ یا sheet فعلی را می‌بندد و closeCurrentSnackbar و closeAllSnackbars پاک‌سازی snackbar را انجام می‌دهند. backLegacy کمک مهاجرت است و API پیشنهادی برای کد تازه نیست.

overlay را پس از mount شدن برنامه و لایهٔ مربوط بسازید. Get.context و Get.overlayContext اختیاری‌اند و پیش از mount و پس از teardown مقدار null دارند. لغو snackbar صف‌شده، swipe و teardown، Future نمایش snackbar را تکمیل و کنترلر را پاک می‌کنند. transition یا سیاست PopScope سفارشی همچنان به تست روی دستگاه هدف نیاز دارد.

<div dir="ltr">

```dart
Future<bool?> confirmAction() => Get.dialog<bool>(
  AlertDialog(
    title: const Text('Continue?'),
    actions: [
      TextButton(
        onPressed: () => Get.closeDialog<bool>(result: true),
        child: const Text('Yes'),
      ),
    ],
  ),
);

Future<int?> chooseValue() => Get.bottomSheet<int>(
  Material(
    child: TextButton(
      onPressed: () => Get.closeBottomSheet<int>(result: 7),
      child: const Text('Choose 7'),
    ),
  ),
);

void showMessage() {
  Get.snackbar('Saved', 'Your changes were saved');
}

void dismissMessage() => Get.closeCurrentSnackbar();
```

</div>

<a id="restoration"></a>

## تاریخچهٔ مسیر نام‌دار و بازیابی وضعیت

با تعیین restorationScopeId برنامه، بازیابی تاریخچهٔ مسیرهای نام‌دار در GetDelegate پیش‌فرض فعال می‌شود. برای صفحه‌های قابل بازیابی، restorationId ثابت و متمایز بدهید و دادهٔ صفحه را با RestorationMixin و ویژگی‌های restorable فلاتر ذخیره کنید. اگر delegate سفارشی دارید، scope خود آن را هم علاوه بر برنامه تعیین کنید.

تاریخچه در RouteInformation.state نسخه‌بندی‌شده ذخیره می‌شود و URI معنای معمول خودش را حفظ می‌کند. آرگومان‌ها باید ساختار JSON معتبر داشته باشند: null، bool، عدد finite، رشته، فهرست و map با کلید رشته‌ای. ویجت، کنترلر، closure و نوع دلخواه مدل پشتیبانی نمی‌شوند. حدود ذخیره‌سازی ۱۲۸ ورودی تاریخچه، عمق ۱۶ برای آرگومان و ۶۴ کیبی‌بایت برای payload کدشده است. دادهٔ نامعتبر، بیش‌ازحد بزرگ یا چرخه‌ای، ناسازگاری scope یا صفحه و رد middleware به مسیریابی محافظت‌شده از URI برمی‌گردد.

process بازیابی‌شده کنترلر و completer تازه می‌سازد؛ Future منتظر از process ازبین‌رفته ادامه پیدا نمی‌کند. نتیجهٔ typed جدید پس از بازیابی کار می‌کند. back/forward مرورگر snapshot معتبر را با حفظ ورودی‌های مشترک زنده وارد می‌کند؛ reload کامل در bootstrap آزمایش‌شده با URI شروع می‌شود و بازیابی کل stack قدیمی را تضمین نمی‌کند. قرارداد دقیق guard و fallback در راهنمای مهاجرت و آزمون واقعی مرگ process در harness دستگاه آمده است.

<div dir="ltr">

```dart
Widget restorableApplication() => GetMaterialApp(
  restorationScopeId: 'example-history',
  initialRoute: '/home',
  binds: [Bind.lazyPut<CounterController>(() => CounterController())],
  getPages: [
    GetPage<void>(
      name: '/home',
      restorationId: 'home',
      page: () => const CounterPage(),
    ),
    GetPage<int>(
      name: '/details',
      restorationId: 'details',
      page: () => const DetailsPage(),
    ),
  ],
);
```

</div>

<a id="translations"></a>

## بین‌المللی‌سازی و زبان

Translations را با فرهنگ‌های لغت دارای کلید locale پیاده‌سازی کنید. .tr ترجمهٔ کلید، trParams جایگزینی پارامتر نام‌دار و trPlural انتخاب کلید مفرد یا جمع بر اساس تعداد را انجام می‌دهند؛ trPlural موتور کامل قواعد جمع تمام زبان‌ها نیست. locale و fallbackLocale را در برنامه تعیین و برای تغییر زبان Get.updateLocale را فراخوانی کنید. Get.deviceLocale زبان دستگاه را می‌خواند.

برای ترجمهٔ ویجت‌های خود Flutter، delegateهای flutter_localizations و supportedLocales مورد نیاز برنامه را هم تنظیم کنید. ترجمهٔ کلیدهای GetX جای آن delegateها را نمی‌گیرد. چیدمان راست‌به‌چپ، قلم، قالب اعداد و تاریخ و زبان جایگزین را برای زبان‌های محصول بررسی کنید.

<div dir="ltr">

```dart
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'greeting': 'Hello @name',
      'item': 'One item',
      'items': 'Many items',
    },
    'fa_IR': {
      'hello': 'سلام',
      'greeting': 'سلام @name',
      'item': 'یک مورد',
      'items': 'چند مورد',
    },
  };
}

Widget translatedApplication() => GetMaterialApp(
  translations: Messages(),
  locale: const Locale('fa', 'IR'),
  fallbackLocale: const Locale('en', 'US'),
  home: const TranslationPage(),
);

class TranslationPage extends StatelessWidget {
  const TranslationPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
      Text('hello'.tr),
      Text('greeting'.trParams({'name': 'Sara'})),
      Text('item'.trPlural('items', 2)),
    ]),
  );
}

Future<void> useEnglish() => Get.updateLocale(const Locale('en', 'US'));
```

</div>

<a id="themes"></a>

## پوسته و تنظیمات برنامه

theme، darkTheme و themeMode را روی GetMaterialApp تنظیم کنید و برای تغییر زنده از Get.changeTheme و Get.changeThemeMode استفاده کنید. Get.isDarkMode پوستهٔ مؤثر برنامهٔ mountشده را نشان می‌دهد. برای تغییر theme یا locale، binding و کنترلر را بی‌دلیل جایگزین نکنید؛ این شاخه مالکیت آن‌ها را در تنظیم مجدد معمول برنامه حفظ می‌کند.

<div dir="ltr">

```dart
Widget themedApplication() => GetMaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: ThemeMode.system,
  home: const Scaffold(body: Text('Theme example')),
);

void toggleTheme() {
  Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
}

void followSystemTheme() => Get.changeThemeMode(ThemeMode.system);
```

</div>

<a id="http"></a>

## GetConnect: درخواست HTTP و بارگذاری

برای درخواست HTTP دارای نوع، GetConnect را گسترش دهید. متد post بدنه را به‌عنوان آرگومان positional می‌گیرد. decoder مطابق API تعریف کنید و پیش از استفاده از پاسخ، هم status و هم nullable بودن body را بررسی کنید. URLهای example.com زیر جای نمونه هستند و سرویس آمادهٔ اجرا محسوب نمی‌شوند. اطلاعات محرمانه را داخل کد برنامه قرار ندهید.

FormData و MultipartFile برای بارگذاری فایل در دسترس‌اند. قوانین CORS مرورگر و سیاست TLS و شبکهٔ پلتفرم همچنان اعمال می‌شوند. timeout، لغو، خطای decoding و پاسخ ناموفق را صریح مدیریت کنید؛ موفقیت انتقال لزوماً موفقیت پاسخ برنامه نیست.

<div dir="ltr">

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

</div>

<a id="interceptors"></a>

## Modifier، احراز هویت و پردازش پاسخ

modifier درخواست و authenticator باید درخواستی را که می‌خواهند ارسال شود برگردانند؛ modifier پاسخ نیز پاسخ مرحلهٔ بعد را برمی‌گرداند. نوع generic باید پاسخ‌های client را بپذیرد؛ این نمونه با endpointهای متفاوت از modifier با نوع dynamic استفاده می‌کند، در حالی که getUser همچنان ApiUser را decode می‌کند. اگر بعداً callback را حذف می‌کنید، همان reference را نگه دارید. removeResponseModifier اکنون از مجموعهٔ modifierهای پاسخ حذف می‌کند و به modifier درخواست دست نمی‌زند. نمونهٔ زیر ApiUser بخش قبل و توکن تأمین‌شده توسط سرویس احراز هویت برنامه را استفاده می‌کند.

maxAuthRetries را آگاهانه تعیین کنید. جریان واقعی refresh توکن باید خطای refresh را مدیریت و از احراز هویت بازگشتی روی خود درخواست refresh جلوگیری کند. در این نامزد، خطای retry ناهم‌زمان داخل محدودهٔ مدیریت خطا باقی می‌ماند و درخواست جایگزین‌شده توسط authenticator استفاده می‌شود.

<div dir="ltr">

```dart
import 'package:get/get_connect/http/src/request/request.dart';

void configureUserClient(UserProvider client, String Function() token) {
  client.httpClient.addRequestModifier<dynamic>((request) {
    request.headers['Accept'] = 'application/json';
    return request;
  });
  client.httpClient.addAuthenticator<dynamic>((request) {
    request.headers['Authorization'] = 'Bearer ${token()}';
    return request;
  });
  client.httpClient.maxAuthRetries = 2;

  Response<dynamic> observeResponse(
    Request<dynamic> request, Response<dynamic> response,
  ) {
    Get.log('HTTP status: ${response.statusCode}');
    return response;
  }

  client.httpClient.addResponseModifier<dynamic>(observeResponse);
  client.httpClient.removeResponseModifier<dynamic>(observeResponse);
}

Future<String?> readUserName(UserProvider client) async {
  final response = await client.getUser(1);
  if (response.isOk && response.body != null) {
    return response.body!.name;
  }
  return null;
}
```

</div>

<a id="socket"></a>

## WebSocket و dispose

از endpoint با ws:// یا wss:// استفاده و پروتکل پیام برنامه را تعریف کنید. GetSocket callbackهای open، message، close و error را فراهم می‌کند. socket باید مالک داشته باشد و در پایان dispose شود؛ جایگزینی اتصال باید اتصال قبلی، heartbeat و subscriptionهای آن را آزاد کند. این نامزد انتقال متن و دادهٔ باینری را در مرورگر واقعی JS و WASM و همچنین socketهای IO تست می‌کند. تنظیم TLS یا CORS سرور به‌صورت خودکار انجام نمی‌شود.

<div dir="ltr">

```dart
class ChatController extends GetxController {
  final client = GetConnect();
  late final GetSocket connection;

  @override
  void onInit() {
    super.onInit();
    connection = client.socket('wss://example.com/chat');
    connection.onOpen(() => connection.send('hello'));
    connection.onMessage((message) => Get.log('message: $message'));
    connection.onError((error) => Get.log('socket: $error', isError: true));
    connection.connect();
  }

  @override
  void onClose() {
    connection.dispose();
    client.onClose();
    super.onClose();
  }
}
```

</div>

<a id="middleware"></a>

## Middleware در GetPage

زیرکلاس مشخص GetMiddleware را به GetPage.middlewares بدهید؛ خود GetMiddleware انتزاعی است. عدد priority کوچک‌تر زودتر اجرا می‌شود. برای delegate مربوط به Navigator 2، متد redirectDelegate را override کنید: RouteDecoder ورودی یعنی ادامه، decoder دیگر یعنی redirect و null یعنی لغو. مسیر login باید ثبت شده باشد و guard آن دوباره به خودش redirect نکند. تاریخچهٔ بازیابی‌شده هم از middleware عبور می‌کند.

hookهای چرخهٔ عمر صفحه عبارت‌اند از onPageCalled(GetPage?)، متد generic به نام `onBindingsStart<R>`(`List<R>`?)، متد onPageBuildStart(GetPageBuilder?)، متد onPageBuilt(Widget) و onPageDispose(). هنگام override امضای nullable و generic را حفظ کنید و Binding دلخواه را داخل فهرستی با نوع R نامعلوم نگذارید. برای DI، binding صریح مسیر معمولاً روشن‌تر است. hook قدیمی redirect(String?) با خروجی RouteSettings با redirectDelegate متفاوت است؛ فقط override کردن اولی دستور guard برای Navigator 2 نیست.

<div dir="ltr">

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

class PageLifecycleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Protected');

  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() => Get.log('Page disposed');
}
```

</div>

<a id="advanced"></a>

## APIهای پیشرفتهٔ مسیر، پلتفرم و context

Get.arguments، Get.parameters، Get.currentRoute، Get.previousRoute و Get.routing وضعیت فعلی مسیریاب تنظیم‌شده را در اختیار می‌گذارند. removeRoute نام مسیر می‌گیرد و until شرطی روی GetPage می‌پذیرد؛ نمایش اختصاریِ بدون آرگومان را به‌عنوان کد قابل اجرا کپی نکنید.

برای تشخیص پلتفرم از GetPlatform و برای رابط responsive از getterهای اندازه و MediaQuery روی BuildContext معتبر استفاده کنید. context.mediaQuerySize و context.orientation، getter هستند و پرانتز ندارند. context.textScaleFactor در این SDK یک TextScaler برمی‌گرداند. Get.context و Get.overlayContext خارج از طول عمر برنامه nullable هستند؛ دسترسی strict به root controller همچنان root فعال می‌خواهد. این contextها را پس از dispose یا عبور ناهم‌زمان نگه ندارید.

<div dir="ltr">

```dart
String environmentSummary(BuildContext context) {
  final size = context.mediaQuerySize;
  final padding = context.mediaQueryPadding;
  final orientation = context.orientation;
  final scaledText = context.textScaleFactor.scale(16);
  return '${GetPlatform.isWeb}: $size, $padding, $orientation, $scaledText';
}

void returnToHome() => Get.until((page) => page.name == '/home');
void removeDetails() => Get.removeRoute('/details');
```

</div>

<a id="configuration"></a>

## تنظیمات سراسری، لاگ و مسیریاب سفارشی

گزینه‌های پشتیبانی‌شده را روی GetMaterialApp یا GetCupertinoApp تنظیم کنید؛ دستور قدیمی Get.config در این شاخه موجود نیست. routingCallback تغییر مسیر را مشاهده و logWriterCallback لاگ GetX را به مقصد دلخواه هدایت می‌کند؛ پرچم isError را رعایت کنید. callback ممکن است حتی با خاموش‌بودن لاگ کنسول پیام دریافت کند؛ فیلتر و حذف اطلاعات حساس را خودتان اعمال کنید.

برای RouterConfig یا delegate سفارشی از سازندهٔ router برنامه استفاده و تنظیمات آن را هماهنگ متصل کنید. MaterialApp ساده فقط با Get.key و GetObserver معادل راه‌اندازی root مربوط به Navigator 2، binding و overlay این RC نیست.

<div dir="ltr">

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

</div>

<a id="local"></a>

## وضعیت محلی: ValueBuilder و ObxValue

ValueBuilder مقدار محلی را از طریق callback به‌روز می‌کند و ObxValue از مقدار Rx بازسازی می‌شود. برای switch، بازبودن یک بخش یا index انتخابی محلی مناسب‌اند و لازم نیست هر تعامل کوچک را به کنترلر سراسری ببرید. برای مقدار Rx که از بیرون می‌آید، مالک و سیاست پاک‌سازی مشخص کنید.

<div dir="ltr">

```dart
Widget localSwitch() => ValueBuilder<bool>(
  initialValue: false,
  builder: (value, update) => Switch(value: value, onChanged: update),
);

Widget reactiveSwitch(RxBool value) => ObxValue<RxBool>(
  (data) => Switch(
    value: data.value,
    onChanged: (next) => data.value = next,
  ),
  value,
);
```

</div>

<a id="views"></a>

## GetView، GetWidget و View واکنش‌گرا

`GetView<T>` یک View بدون state است که getter کنترلرش از Get.`find<T>` استفاده می‌کند؛ مثال شمارنده از آن بهره می‌برد. `GetWidget<T>` کنترلر همان نمونهٔ ویجت را cache می‌کند و همراه factoryهای Get.spawn کاربرد دارد. این کار ثبت را permanent نمی‌کند؛ کنترلر ساخته‌شده از factory با حذف ویجت مالک بسته می‌شود. این انتخاب باید عمدی باشد؛ هر lookup خودبه‌خود cache نمی‌شود.

GetResponsiveView اطلاعات اندازه و نوع صفحه و متدهای builder، desktop، tablet، phone و watch را فراهم می‌کند. برای انتخاب builder هر نوع، alwaysUseBuilder:false بگذارید و در صورت نیاز آستانه‌های ResponsiveScreenSettings را تنظیم کنید. نوع صفحهٔ انتخاب‌شده باید builder یا fallback معتبر داشته باشد. اندازه با resize تغییر می‌کند؛ پرچم پلتفرم به‌تنهایی breakpoint چیدمان نیست.

<div dir="ltr">

```dart
class ResponsivePage extends GetResponsiveView<CounterController> {
  ResponsivePage({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const Center(child: Text('Compact layout'));

  @override
  Widget tablet() => const Center(child: Text('Tablet layout'));

  @override
  Widget desktop() => const Center(child: Text('Wide layout'));
}

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

</div>

<a id="queue"></a>

## کار صف‌شده و لغو

GetQueue کارها را به ترتیب اجرا و خطا و stack trace اصلی را منتقل می‌کند؛ خطای یک کار مانع کارهای بعدی نمی‌شود. cancelAllJobs فقط کارهای شروع‌نشده را کنار می‌گذارد و کار فعال ادامه دارد. Future کار کنارگذاشته‌شده pending می‌ماند؛ این API نتیجهٔ قابل await برای لغو تولید نمی‌کند. انتظار exception خودکارِ لغو از Future حذف‌شده نداشته باشید. صف snackbar تکمیل مخصوص خودش را مدیریت می‌کند.

<div dir="ltr">

```dart
Future<int> queuedCalculation() async {
  final queue = GetQueue();
  final first = queue.add<int>(() async => 20);
  final second = queue.add<int>(() => 22);
  return await first + await second;
}
```

</div>

<a id="tests"></a>

## تست کنترلر، ویجت و پلتفرم

برای کنترلر و ویجت وابسته به Flutter از flutter_test استفاده و ثبت‌های سراسری GetX را بین تست‌ها reset کنید. نمونهٔ زیر در فایل تست قرار می‌گیرد و CounterController و CounterApp را از برنامهٔ خودتان import می‌کند؛ تعریف تکراری کد تولید داخل تست نیست. در تست مستقل کنترلری که navigation دارد، Get.testMode می‌تواند اثر جانبی navigation را محدود کند؛ برای تست خود مسیریابی جای router واقعی mountشده را نمی‌گیرد.

چرخهٔ عمر DI، نتیجه و guard مسیر، dispose و خطا را هم علاوه بر مقدار قابل مشاهده تست کنید. fake برای interfaceهای خودتان مناسب است؛ اگر پروژه از کتابخانهٔ mock استفاده می‌کند، تنظیمات فعلی همان را دنبال کنید و صرفاً برای GetX وابستگی تازه اضافه نکنید. تست‌های ریشه، پکیج‌های مستقل example را اجرا نمی‌کنند. back بومی، gesture پیش‌بینانه و restoration پس از مرگ process به harness دستگاه یا امولاتور واقعی نیاز دارند؛ صرف build شدن APK و harness در CI پذیرش native نیست.

<div dir="ltr">

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_app/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('counter increments', (tester) async {
    await tester.pumpWidget(const CounterApp());
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('dependency lookup returns the registered instance', () {
    final controller = Get.put(CounterController());
    controller.increment();
    expect(Get.find<CounterController>(), same(controller));
    expect(controller.count.value, 1);
  });
}
```

</div>

<a id="migration"></a>

## مهاجرت از نسخه‌های قبلی GetX

ابتدا [راهنمای کامل مهاجرت GetX 4 به 5](documentation/en_US/migration_guide_5.md) را بخوانید و رفتار را هم همراه syntax تغییر دهید:

| دستور قبلی | این RC |
|---|---|
| factory سراسری `Get.create` | `Get.spawn` با نوع و tag یکسان هنگام دریافت |
| `Get.putAsync` | آماده‌سازی با await، سپس `Get.put` |
| `initialBinding` و `BindingsBuilder` | `binds` برنامه و `Binding` مسیر با خروجی `List<Bind>` |
| `change(data, status: RxStatus.success())` | `change(GetStatus<T>.success(data))` یا `setSuccess(data)` |
| نمونهٔ ویجت در navigation مستقیم | تابع سازنده، مانند `Get.to(() => Page())` |
| یک `Get.back` برای تمام popupها | helper صریح دیالوگ، sheet و snackbar؛ `Get.back` برای صفحه |
| nested-key مربوط به Navigator 1 | `GetPage.children` و `GetRouterOutlet` با id رشته‌ای |
| `Get.config` سراسری | تنظیمات سازندهٔ برنامه یا router سفارشی پشتیبانی‌شده |

در مهاجرت تاریخی GetX 2، نوع‌های StringX، IntX، MapX، ListX، NumX و DoubleX به RxString، RxInt، RxMap، RxList، RxNum و RxDouble تبدیل شدند و دستورهای namedRoutes و GetRoute جای خود را به getPages و GetPage با تابع سازندهٔ صفحه دادند. این بخش توضیح سابقه است و سازندهٔ قدیمی برای کپی در کد جدید نیست.

<a id="changes"></a>

## تغییرات این نامزد انتشار

این نامزد قراردادهای انتخاب‌شدهٔ RC را تثبیت می‌کند و به معنی حل تمام issueهای تاریخی upstream نیست. جزئیات در [CHANGELOG](CHANGELOG.md) و [محدودهٔ انتشار و تطبیق با master](documentation/en_US/release_scope_5.md) ثبت شده است.

- **وضعیت و DI:** بازیابی اشتراک Rx پس از لغو، مدیریت ورودی مشترک در انتساب مجموعه، پیش‌فرض مستقل و mutable مجموعه‌های Rx، readiness و dispose ایمن‌تر، مالکیت و جایگزینی binding و نادیده‌گرفتن تکمیل StateMixin پس از dispose.
- **مسیریابی و برنامه:** تکمیل نتیجهٔ typed مسیر کنارگذاشته‌شده، اجرای middleware پیش از جایگزینی history، مسیر تو‌در‌تو، veto برگشت، context اختیاری، بستن صریح overlay، پاک‌سازی صف و timer و swipe مربوط به snackbar، transition مربوط به Cupertino sheet و انتقال تنظیمات برنامه.
- **بازیابی:** تاریخچهٔ محدود و opt-in مسیر نام‌دار با آرگومان معتبر و middleware، ساخت کنترلر و completer تازه پس از بازیابی process و probe بومی برای شروع سرد واقعی و نتیجهٔ typed جدید.
- **شبکه:** حذف درست modifier، مدیریت درخواست جایگزین و retry احراز هویت، خطای timeout و abort و decoding در IO و مرورگر، اتصال مجدد WebSocket، انتقال متن و باینری JS و dispose.
- **SDK و میزبان:** مبنای Flutter 3.47.9 و Dart 3.13.7، میزبان Android به‌روز و چرخهٔ scene در iOS، تنظیمات TickerMode و callbackهای حافظه و accessibility.
- **اعتبارسنجی و مستندات:** تست‌های regression واحد و ویجت، پکیج‌های مستقل مثال، آزمون واقعی Chrome در JS و WASM برای شبکه و تاریخچه، harness بومی، راهنمای مهاجرت و READMEهای جامع انگلیسی و فارسی و دستورهای به‌روز ترجمه‌ها.

تغییرات master بر اساس رفتار انتخاب شده‌اند؛ مهاجرت نوع‌های عمومی UI مستقل و قرارداد متفاوت Get.back بدون بررسی merge نشده‌اند. PRهای قبلی و منبع تغییرات در محدودهٔ انتشار و PR تثبیت ثبت شده‌اند.

<a id="limitations"></a>

## محدودیت‌های شناخته‌شده و دامنهٔ پشتیبانی

در Flutter 3.47.9، موتور وب ممکن است کاراکتر percent-encoded مسیر را هنگام ثبت در history decode کند: `?tag=a%2Bb` به `?tag=a+b` تبدیل می‌شود و refresh می‌تواند مقدار مورد نظر `a+b` را به `a b` تغییر دهد. نمونهٔ خالص Flutter بدون GetX هم همین خطا را بازتولید می‌کند. این محدودیت SDK است و راهکار سراسریِ double-encoding یا نوشتن مستقیم history اعمال نشده است. Flutter حفظ encoding را برای 3.50 به بعد مستند کرده؛ این به معنی اعتبارسنجی آن SDK در این پروژه نیست.

آزمون سخت‌گیرانهٔ encoded-query یک بررسی دستی جداست و سبزشدن CI عادی وب رفع آن را اعلام نمی‌کند. شروع URI-only پس از reload کامل هم مرز جداگانه‌ای برای بازیابی تاریخچه است. دستور اجرا و شواهد در [harness مرورگر](example_nav2/test/browser/README.md) آمده‌اند.

پذیرش native به transition، میزبان و نسخهٔ سیستم‌عامل تست‌شده محدود است. حداقل میزبان مثال Android API 24 و iOS 15 است؛ این‌ها تضمین تمام ترکیب‌های پلتفرم برای هر برنامه نیستند. issue قدیمی بازتولیدنشده، ترکیب‌های تازهٔ SDK و میزبان و مهاجرت UI مستقل، کارهای بعدی‌اند. regression جدید در قراردادهای منتخب باید پیش از انتشار ارزیابی شود.

<a id="examples"></a>

## مثال‌ها و دستورهای اعتبارسنجی

پکیج‌های مستقل [example](example/README.md) و [مثال Navigator 2](example_nav2/README.md) از طریق path به همین checkout وابسته‌اند. بررسی را در هر پکیج جدا اجرا کنید. دستورهای زیر SDK نصب یا ارتقا نمی‌دهند؛ resolution آفلاین علاوه بر این به cache وابستگی‌ها نیاز دارد. برای بررسی تعاملی برنامه، flutter run را روی target نصب‌شده اجرا کنید.

[گردش‌کار CI](.github/workflows/main.yml) SDK انتخابی را pin می‌کند و analyzer، تست‌ها، آزمون شبکه و مسیریابی Chrome، build وب JS و WASM، ساخت APK و کامپایل harness بومی را انجام می‌دهد. نتیجهٔ اجرای commit دقیق خود را بررسی کنید. [راهنمای دستگاه](example_nav2/test/device/README.md) و [راهنمای امولاتور Android](example_nav2/test/device/android/README.md) back، gesture پیش‌بینانه، بازیابی پس از مرگ process و تطبیق هویت artifact را توضیح می‌دهند.

<div dir="ltr">

```sh
flutter --version
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test

cd example
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test

cd ../example_nav2
flutter pub get
flutter analyze --no-fatal-infos lib test
flutter test
```

</div>

<a id="why"></a>

## چرا GetX و اکوسیستم آن

GetX روش هماهنگی برای اتصال وضعیت، DI و مسیریابی می‌دهد و در عین حال استفادهٔ مستقل از ماژول‌ها را ممکن می‌کند. کنترلر منطق ارائه را از ویجت جدا می‌کند، binding مالکیت را نشان می‌دهد و builder واکنشی رابط مشاهده‌کننده را به‌روز می‌کند. این‌ها ابزار طراحی‌اند و وعدهٔ درستی خودکار، حداقل مطلق حافظه یا سازگاری با تمام نسخه‌های آیندهٔ Flutter نیستند. نیاز برنامه را انتخاب و نتیجه را اندازه‌گیری کنید.

پروژه‌های مرتبط شامل [Get CLI](https://github.com/jonataslaw/get_cli)، [Get Server](https://github.com/jonataslaw/get_server)، [snippetهای VS Code](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) و [افزونهٔ Android Studio و IntelliJ](https://plugins.jetbrains.com/plugin/14975-getx-snippets) هستند. این ابزارها نسخه‌بندی مستقل دارند؛ پیش از استفاده از کد تولیدشده، سازگاری آن را بررسی کنید. پکیج‌های persistence و سرویس‌های backend تضمین ذخیره‌سازی همراه GetX نیستند.

<a id="community"></a>

## جامعه، مشارکت و مجوز

پرسش کاربردی را در کانال‌های جامعه مطرح و باگ قابل بازتولید کتابخانه را در همین مخزن گزارش کنید. کانال‌های معرفی‌شده شامل [Discord](https://discord.com/invite/9Hpt99N)، [Slack](https://communityinviter.com/apps/getxworkspace/getx) و [Telegram](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) هستند.

مشارکت می‌تواند رفتار runtime، تست، مثال، مستندات و ترجمه را بهتر کند. پیش از پیشنهاد اصلاح، issue و PR موجود را بررسی کنید، نمونهٔ کوچک قابل اجرا بدهید، نسخهٔ واقعی GetX و Flutter و Dart و پلتفرم را ثبت کنید، تست regression متمرکز اضافه و بررسی مرتبط ریشه و مثال را اجرا کنید. اگر قرارداد عمومی تغییر کرد، راهنمای آن را هم به‌روز کنید. مالکیت ماژول را حفظ کنید و مشکل طول عمر را با permanent کردن پنهان نکنید.

پروژه با [مجوز MIT](LICENSE) ارائه می‌شود. README انگلیسی و فارسی سرفصل‌ها و مثال‌های کد مشترک دارند؛ READMEهای ترجمه‌شده توضیحات خود را با دستورهای به‌روز RC در متن حفظ می‌کنند.

## مقاله‌ها و ویدیوها

منابع آموزشی قبلی برای مطالعه حفظ شده‌اند؛ ممکن است نسخه‌های قدیمی API یا ابزارهای مستقل را نشان دهند. مثال آن‌ها را با راهنمای مهاجرت همین شاخه تطبیق دهید.


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
- [GetConnect: The best way to perform API operations in Flutter with Get.](https://absyz.com/getconnect-the-best-way-to-perform-api-operations-in-flutter-with-getx/) - by [MD Sarfaraj](https://github.com/socialmad)
- [How To Create an App with GetX Architect in Flutter with Get CLI](https://www.youtube.com/watch?v=7mb4qBA7kTk&t=1380s) - by [MD Sarfaraj](https://github.com/socialmad)

</div>

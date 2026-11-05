<div dir="rtl" lang="fa">

# GetX 5 — راهنمای فارسی

[English](README.md) · [راهنمای مهاجرت از نسخهٔ ۴](documentation/en_US/migration_guide_5.md) · [محدودهٔ انتشار](documentation/en_US/release_scope_5.md) · [تاریخچهٔ تغییرات](CHANGELOG.md)

GetX مجموعه‌ای از ابزارهای مدیریت وضعیت، تزریق وابستگی و مسیریابی برای Flutter است. می‌توانید مدیریت وضعیت و وابستگی را جداگانه استفاده کنید؛ برای مسیریابی و نمایش دیالوگ یا snackbar از تنظیمات برنامهٔ GetX هم استفاده کنید.

این راهنما مخصوص کد GetX 5 در این شاخه است. نسخهٔ فعلی `5.0.0-release-candidate-9.4.0` یک **نامزد انتشار منتشرنشده** است؛ آماده‌سازی این شاخه به معنی انتشار نسخهٔ stable روی pub.dev نیست. مستندات قدیمی با برچسب **GetX 4 legacy** قراردادهای نسخهٔ ۴ را توضیح می‌دهند و باید با راهنمای مهاجرت تطبیق داده شوند.

## سازگاری و نصب

مبنای آزمایش این شاخه **Flutter 3.47.9 و Dart 3.13.7** است. حداقل نسخه‌های manifest همین‌ها هستند و Dart باید پایین‌تر از ۴ باشد. پشتیبانی از هر SDK جدیدتر یا هر پلتفرم به بررسی جداگانه نیاز دارد.

این شاخه از `package:flutter/material.dart` و `package:flutter/cupertino.dart` استفاده می‌کند. نوع‌های پکیج‌های مستقل `material_ui` و `cupertino_ui` را با این APIها ترکیب نکنید؛ مهاجرت آن‌ها در شاخهٔ master محدودهٔ متفاوتی دارد.

برای آزمایش همین کد، مخزن و شاخهٔ مورد نظر را دریافت کنید و در برنامهٔ آزمایشی به مسیر checkout وابستگی بدهید. مثال زیر فرض می‌کند پوشهٔ `getx` کنار پوشهٔ برنامه است:

<div dir="ltr">

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

```sh
flutter --version
flutter pub get
flutter analyze
flutter test
```

</div>

نام شاخه و commit دریافت‌شده را ثبت کنید. نصب `get` از pub.dev لزوماً کد این شاخه را دریافت نمی‌کند؛ شمارهٔ نامزد انتشار بالا را تا زمانی که واقعاً منتشر نشده، به‌عنوان نسخهٔ در دسترس معرفی نکنید. برای پروژهٔ واقعی، وابستگی را پس از انتخاب نسخهٔ منتشرشده یا commit بررسی‌شده تثبیت کنید.

## شروع سریع: شمارنده

کد زیر را در `lib/main.dart` برنامهٔ آزمایشی قرار دهید. کنترلر از طریق `binds` در برنامه ثبت می‌شود و `Obx` فقط بخش وابسته به مقدار واکنشی را بازسازی می‌کند:

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
  Widget build(BuildContext context) {
    return GetMaterialApp(
      binds: [Bind.lazyPut<CounterController>(() => CounterController())],
      home: const CounterPage(),
    );
  }
}

class CounterPage extends GetView<CounterController> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX 5')),
      body: Center(child: Obx(() => Text('${controller.count.value}'))),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

</div>

## مدیریت وضعیت

با `.obs` یک مقدار واکنشی بسازید و آن را داخل `Obx` بخوانید. برای مجموعه‌ها، `RxList`، `RxMap` و `RxSet` نیز در دسترس‌اند. سازندهٔ بدون آرگومان هر بار مجموعه‌ای مستقل و قابل تغییر می‌سازد؛ اگر مجموعه‌ای را صریحاً به سازنده بدهید، رفتار همان مجموعه حفظ می‌شود.

در مدیریت سادهٔ وضعیت، از `GetBuilder<Controller>` استفاده کنید و پس از تغییر داده در کنترلر، `update()` را فراخوانی کنید. برای یک تغییر صرفاً واکنشی در `Obx` نیازی به فراخوانی `update()` نیست.

در `StateMixin<T>`، وضعیت موفق مقدار داده را هم حمل می‌کند. این مثال یک کنترلر کامل است:

<div dir="ltr">

```dart
class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void load(Future<List<String>> Function() fetch) {
    futurize(fetch);
  }

  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);
}
```

</div>

در این RC، متد `futurize` تابعِ سازندهٔ Future می‌گیرد و خودش `void` برمی‌گرداند. به‌صورت پیش‌فرض دادهٔ تهی را به وضعیت empty تبدیل می‌کند؛ برای حفظ موفقیتِ دادهٔ تهی از `useEmpty: false` استفاده کنید. نتیجهٔ عملیات هم‌زمان به ترتیب تکمیل اعمال می‌شود؛ ترتیب شروع به معنی اولویت نتیجه نیست.

اگر فیلد داخلی یک مدل mutable را تغییر می‌دهید، اعلان تغییر آن را هم مدیریت کنید؛ مثلاً پس از تغییر فیلد، روی مقدار واکنشی `refresh()` بزنید. تغییر یک فیلد عادی به‌تنهایی اعلان واکنشی ایجاد نمی‌کند.

## تزریق وابستگی و طول عمر

`Get.put` یک نمونه را ثبت می‌کند، `Get.lazyPut` ساخت نمونهٔ singleton را تا اولین دریافت به تعویق می‌اندازد و `Get.spawn` برای هر `Get.find` نمونهٔ تازه می‌سازد. برای ثبت و دریافت نام‌دار، از `tag` یکسان استفاده کنید.

در GetX 5 به‌جای `Get.create` از `Get.spawn` استفاده می‌شود؛ این تغییر شامل `Bind.create` محلی نیست. API قدیمی `Get.putAsync` هم در این RC وجود ندارد: ابتدا مقدار را با `await` آماده و سپس با `Get.put` ثبت کنید.

برای وابستگی‌های صفحه، یک `Binding` بنویسید که `List<Bind>` برگرداند و آن را به `GetPage.bindings` بدهید. برای وابستگی‌های سراسری برنامه از `GetMaterialApp.binds` استفاده کنید؛ ویژگی قدیمی `initialBinding` مربوط به این قرارداد نیست. مثال کامل در [راهنمای Binding](documentation/en_US/migration_guide_5.md#route-bindings-and-application-bindings) آمده است.

منابعی مثل timer، subscription و کنترلرهای اسکرول را در چرخهٔ عمر مناسب آزاد کنید. برای پنهان‌کردن مشکل طول عمر، همهٔ کنترلرها را `permanent` نکنید. ساخت، اشتراک و حذف کنترلر را پس از خروج آخرین مالک تست کنید. در تست‌های مستقل، ثبت‌های سراسری را با `Get.reset()` پاک کنید.

## مسیریابی و نتیجهٔ صفحه

مسیریابی این RC بر Navigator 2 بنا شده است. در برنامهٔ راه‌اندازی‌شده با GetX، این قطعه را در رویدادی مانند `onPressed` اجرا کنید. `DetailsPage` ویجت برنامهٔ شماست:

<div dir="ltr">

```dart
final result = await Get.to<int>(() => const DetailsPage());
```

</div>

در صفحهٔ مقصد مقدار هم‌نوع را برگردانید:

<div dir="ltr">

```dart
Get.back<int>(result: 42);
```

</div>

نتیجه ممکن است `null` باشد؛ مثلاً وقتی کاربر با دکمهٔ سیستم برمی‌گردد. برای مسیرهای نام‌دار، ابتدا `getPages` را تعریف و سپس از `Get.toNamed` استفاده کنید. مسیریابی تو‌در‌تو از سلسله‌مراتب `GetPage.children` و `GetRouterOutlet` استفاده می‌کند؛ شناسهٔ navigator در این RC رشته است. [مثال Navigator 2](example_nav2/README.md) مسیرهای تو‌در‌تو، ورود کاربر و redirect را نشان می‌دهد.

## دیالوگ، bottom sheet و snackbar

`Get.back` در این RC برای برگشت صفحه است. برای بستن overlay مربوطه، helper مناسب را انتخاب کنید:

- `Get.closeDialog<T>(result: value)` برای دیالوگ؛
- `Get.closeBottomSheet<T>(result: value)` برای bottom sheet؛
- `Get.closeCurrentSnackbar()` برای snackbar.

این helperها را پس از ایجاد overlay در برنامهٔ متصل به GetX استفاده کنید. `Get.closeOverlay` و `Get.backLegacy` نیز برای موارد مشخص و مهاجرت وجود دارند؛ قرارداد آن‌ها را در [بخش بستن overlay](documentation/en_US/migration_guide_5.md#pages-and-overlays-have-separate-closing-operations) بخوانید. رفتار متفاوت `Get.back` در master را به این RC تعمیم ندهید.

`Get.context` و `Get.overlayContext` خارج از طول عمر برنامهٔ mountشده ممکن است `null` باشند. نمایش رابط کاربری را پس از آماده‌شدن برنامه انجام دهید و به context قدیمی پس از dispose تکیه نکنید.

## ترجمه و راست‌به‌چپ

برای ترجمهٔ متن‌ها می‌توانید `Translations` را پیاده‌سازی کنید:

<div dir="ltr">

```dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'fa_IR': {'hello': 'سلام'},
    'en_US': {'hello': 'Hello'},
  };
}
```

</div>

سپس `translations: AppTranslations()`، مقدار `locale: const Locale('fa', 'IR')` و `fallbackLocale` مورد نظر را روی `GetMaterialApp` تنظیم کنید. متن ترجمه‌شده با `'hello'.tr` در دسترس است و `Get.updateLocale(...)` زبان را تغییر می‌دهد.

برای ترجمهٔ ویجت‌های خود Flutter، delegateها و `supportedLocales` مناسب را هم تنظیم کنید؛ ترجمهٔ کلیدهای GetX جای آن‌ها را نمی‌گیرد. چیدمان راست‌به‌چپ، اعداد، تاریخ و قلم فارسی را در رابط واقعی برنامه بررسی کنید.

## ارتباط شبکه

`GetConnect` امکانات HTTP، modifier، authenticator و WebSocket را فراهم می‌کند. URL، مدل پاسخ و سیاست خطا را مطابق برنامهٔ خود تعریف کنید. خطای شبکه، timeout، لغو درخواست، احراز هویت و بسته‌شدن اتصال را در برنامه مدیریت کنید؛ نتیجهٔ HTTP ناموفق را معادل دادهٔ موفق فرض نکنید.

این شاخه برای مسیرهای IO و مرورگر تست‌های جداگانه دارد؛ پشتیبانی یک سناریوی شبکه در یک محیط، پیکربندی TLS، CORS یا سیاست شبکهٔ میزبان شما را تضمین نمی‌کند. راهنمای اجرای تست‌های واقعی مرورگر در [مستندات آزمون وب](example_nav2/test/browser/README.md) قرار دارد.

## بازیابی وضعیت و محدودیت وب

با تعیین `restorationScopeId` در `GetMaterialApp` یا `GetCupertinoApp`، تاریخچهٔ مسیرهای نام‌دار در delegate پیش‌فرض به‌صورت opt-in بازیابی می‌شود. صفحه‌ها باید شناسهٔ پایدار `GetPage.restorationId` داشته باشند و دادهٔ صفحه با قابلیت‌های restoration فلاتر ذخیره شود. برای delegate سفارشی، scope آن را هم صریح تنظیم کنید.

آرگومان‌های قابل بازیابی باید ساختار JSON معتبر داشته باشند؛ کنترلر، ویجت، closure یا مدل دلخواه قابل بازیابی نیست. بعد از مرگ process، کنترلرها و Futureهای جدید ساخته می‌شوند؛ ادامهٔ Future قدیمی زنده نمی‌ماند. حدود payload، بررسی middleware و fallback در [راهنمای restoration](documentation/en_US/migration_guide_5.md#named-route-history-and-restoration) توضیح داده شده است.

**محدودیت شناخته‌شدهٔ SDK:** در مبنای Flutter 3.47.9، ثبت URLهای percent-encoded در history مرورگر ممکن است مقدار query را پس از refresh تغییر دهد. همچنین reload کامل مرورگر با راه‌اندازی URI آغاز می‌شود و تضمین بازیابی کامل تاریخچه نیست. این موارد مستند باقی مانده‌اند؛ سبزشدن تست‌های معمول وب به معنی رفع encoding نیست. بررسی سخت‌گیرانهٔ encoded-query را برای SDK و میزبان انتخابی جداگانه اجرا کنید.

## نمونه‌ها، تست‌ها و مشارکت

- [مثال اصلی](example/README.md) و [مثال Navigator 2](example_nav2/README.md) از کد همین checkout استفاده می‌کنند.
- تست‌های ریشه، تست‌های پکیج‌های مستقل example را اجرا نمی‌کنند؛ هر سه را جدا بررسی کنید.
- [تست‌های دستگاه](example_nav2/test/device/README.md) و [آزمون‌های امولاتور Android](example_nav2/test/device/android/README.md) back، gesture و بازیابی پس از مرگ process را پوشش می‌دهند. حداقل نسخه‌های میزبان مثال Android API 24 و iOS 15 هستند؛ این‌ها تضمین همهٔ ترکیب‌های سیستم‌عامل نیستند.
- [گردش‌کار CI](.github/workflows/main.yml) و نتیجهٔ اجرای مربوط به commit خود را بررسی کنید. تست native روی دستگاه با صرفاً buildشدن APK در CI یکسان نیست.
- پیش از ارسال تغییر، باگ را با تست قابل تکرار نشان دهید، رفتار را اصلاح و مستندات API تغییرکرده را به‌روز کنید. برای گزارش باگ، نسخهٔ GetX، خروجی `flutter --version`، پلتفرم و نمونهٔ کوچک قابل اجرا را بنویسید.

فهرست تغییرات این نامزد در [CHANGELOG](CHANGELOG.md) و تصمیم‌های مربوط به master و کارهای بعدی در [محدودهٔ انتشار](documentation/en_US/release_scope_5.md) ثبت شده‌اند. همهٔ issueهای قدیمی در این انتشار حل‌شده محسوب نمی‌شوند؛ ادغام PR، انتخاب نسخهٔ نهایی، tag و انتشار پکیج مراحل جداگانه‌اند.

</div>

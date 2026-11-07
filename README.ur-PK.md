> GetX 5 RC: یہ candidate ابھی شائع نہیں ہوا۔ آزمودہ بنیاد Flutter 3.47.9 اور Dart 3.13.7 ہے اور Flutter کی شامل شدہ UI لائبریریاں استعمال ہوتی ہیں۔

[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)

﻿![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**🌎 اردو ( Selected ✔) [| انگریزی |](README.md) [| ویتنامی |](README-vi.md) [| انڈونیشی |](README.id-ID.md) [چینی |](README.zh-cn.md) [برازیلی پرتگالی |](README.pt-br.md) [ہسپانوی |](README-es.md) [روسی |](README.ru.md) [پولش |](README.pl.md) [کورین |](README.ko-kr.md), [French](README-fr.md)**

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

## فہرست

  - [اس برانچ میں GetX 5 کی تبدیلیاں](#getx5-current)
- [تعارف](#readme-section-2)
- [انسٹال](#readme-section-3)
- [کاؤنٹرایپ](#readme-section-4)
- [تین ستون](#readme-section-5)
  - [اسٹیٹ مینجمنٹ](#readme-section-6)
    - [ری ایکٹو اسٹیٹ منیجر](#readme-section-7)
    - [اسٹیٹ مینجمنٹ کے بارے میں مزید تفصیلات](#readme-section-8)
  - [روٹ مینجمنٹ](#readme-section-9)
    - [روٹ مینجمنٹ کے بارے میں مزید تفصیلات](#readme-section-10)
  - [انحصار کا انتظام](#readme-section-11)
    - [انحصار کے انتظام کے بارے میں مزید تفصیلات](#readme-section-12)
- [استعمال](#readme-section-13)
  - [عالمگیریت](#readme-section-14)
    - [ترجمہ](#readme-section-15)
    - [ترجمہ کا استعمال](#readme-section-16)
    - [مقامی](#readme-section-17)
    - [مقام کی تبدیلی](#readme-section-18)
    - [سسٹم لوکیشن](#readme-section-19)
  - [تھیم کی تبدیلی](#readme-section-20)
  - [رابطے کا قیام](#readme-section-21)
    - [ڈیفالٹ کنکشن کا قیام](#readme-section-22)
    - [خود سے رابطے کا قیام](#readme-section-23)
  - [گیٹ پیج مڈل ویئر](#readme-section-24)
    - [ترجیح](#readme-section-25)
    - [ری ڈائریکٹ](#readme-section-26)
    - [جب پیج کی درخواست کی جائے](#readme-section-27)
    - [آنبائنڈنگ اسٹارٹ](#readme-section-28)
    - [آنپیج بلڈ اسٹارٹ](#readme-section-29)
    - [جب پیج لوڈ ہو](#readme-section-30)
    - [جب صفحہ تصرف ہوجائے](#readme-section-31)
  - [دوسرے اعلی درجے کی APIs](#readme-section-32)
    - [اختیاری عالمی ترتیبات اور دستی تشکیلات](#readme-section-33)
    - [مقامی اسٹیٹ ویجٹ](#readme-section-34)
    - [ویلیو بلڈر](#readme-section-35)
    - [اوبکس ویلیو](#readme-section-36)
  - [کارآمد نکات](#readme-section-37)
    - [گیٹ ویو](#readme-section-38)
    - [گیٹ ویجٹ](#readme-section-39)
    - [گیٹکس سروس](#readme-section-40)
- [پچھلے ورژن سے اہم تبدیلیاں](#readme-section-41)
- [گیٹکس کیوں؟](#readme-section-42)
- [سماجی خدمات](#readme-section-43)
  - [کمیونٹی چینلز](#readme-section-44)
  - [کس طرح شراکت کریں](#readme-section-45)
  - [مضامین اور ویڈیوز](#readme-section-46)

<a id="getx5-current"></a>

## اس برانچ میں GetX 5 کی تبدیلیاں

یہ candidate ابھی شائع نہیں ہوا۔ آزمودہ بنیاد Flutter 3.47.9 اور Dart 3.13.7 ہے اور Flutter کی شامل شدہ UI لائبریریاں استعمال ہوتی ہیں۔

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

Binding سے `List<Bind>` واپس کریں۔ ایپ کے لیے binds اور روٹ کے لیے bindings استعمال کریں۔ Get.create کی جگہ Get.spawn لیں؛ async initialization کو await کرنے کے بعد تیار قدر Get.put سے رجسٹر کریں۔

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

`GetStatus<T>.success(data)` کامیاب ڈیٹا رکھتا ہے۔ futurize، Future بنانے والا فنکشن لیتا اور void لوٹاتا ہے؛ نتائج تکمیل کی ترتیب سے لگتے ہیں۔ خالی Rx مجموعوں کا الگ قابل تبدیلی storage ہوتا ہے۔

نیویگیشن Navigator 2 پر ہے۔ Get.back صفحات واپس کرتا ہے؛ dialog، sheet اور snackbar کے لیے الگ helper استعمال کریں۔ ایپ کی زندگی سے باہر Get.context اور Get.overlayContext null ہو سکتے ہیں۔

نام والے روٹس کی تاریخ بحال کرنے کے لیے restorationScopeId اور مستقل restorationId دیں۔ JSON موافق arguments پر حد اور middleware لاگو ہیں؛ process ختم ہونے کے بعد نئے controller اور Future بنتے ہیں۔

Response modifier ہٹانا، authentication، timeout، abort اور decoding errors درست کیے گئے ہیں۔ IO، browser اور JS/WASM میں HTTP/WebSocket اور وسائل کی صفائی جانچی جاتی ہے۔

Flutter 3.47.9 کی browser-history percent-encoding حد برقرار ہے؛ عام web test کی کامیابی اس کا حل نہیں۔ اصل host اور device پر refresh، back اور restoration جانچیں۔

پرانے Get.config کے بجائے GetMaterialApp یا GetCupertinoApp کی settings استعمال کریں۔ Custom router کے لیے مکمل Navigator 2 ترتیب چاہیے۔

GetxService ایپ کی زندگی کی سروس کے لیے onInit/onReady/onClose دیتا ہے۔ عام deletion اسے محفوظ رکھتا ہے؛ جان بوجھ کر force یا Get.reset سے صاف کیا جا سکتا ہے۔ یہ process کے بعد مستقل storage نہیں۔ init await کرکے Get.put کریں۔

GetWidget اسی widget instance کا controller cache کرتا ہے اور const کی حمایت کرتا ہے۔ Get.spawn کا controller مالک widget ہٹنے پر بند ہوتا ہے۔ GetView اس cache کے بجائے lookup کرتا ہے۔

GetNavigator اور GetRouterOutlet.pickPages میں `onPopPage` کی جگہ `onDidRemovePage` ہے۔ یہ حذف کے بعد اطلاع ہے؛ back روکنے کے لیے `GetPage.canPop` یا `PopScope` لیں، اور custom outlet callback سے `delegate.didRemovePage` کو اطلاع دیں۔

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# تعارف

گیٹ ایکس  اسٹیٹ مینجمنٹ کے لئے ایک ہلکا پھلکا اور طاقتور حل ہے۔ یہ تیز اور عملی انداز میں اعلی کارکردگی والی اسٹسٹ مینجمنٹ ، ذہین انحصار انجکشن ، اور روٹ مینجمنٹ کو یکجا کرتا ہے۔ گیٹ ایکس کے 3 بنیادی اصول ہیں ، اس کا مطلب یہ ہے کہ لائبریری میں موجود تمام وسائل کی ترجیح یہی ہے: **پروڈکٹیوٹی,  کارکردگی اور تنظیم**

 **پروڈکٹیوٹی :** گیٹ ایکس کارکردگی اور وسائل کی کم سے کم کھپت پر مرکوز ہے۔ گیٹ ایکس اسٹریمز یا چینج نوٹیفائر استعمال نہیں کرتا ہے۔
  
 **کارکردگی :** گیٹ ایکس ایک آسان اور خوشگوار ترکیب استعمال کرتا ہے۔ اس سے کوئی فرق نہیں پڑتا ہے کہ آپ کیا کرنا چاہتے ہیں ، گیٹ-ایکس کے ساتھ ہمیشہ ایک آسان راستہ رہتا ہے۔ اس سے کوڈنگ کے کئی گھنٹوں کی بچت ہوگی اور یہ آپ کی ایپلیکیشن فراہم کرنے والی زیادہ سے زیادہ کارکردگی کو نکال دے گی۔ عام طور پر ، ڈویلپر میموری سے کنٹرولرز کو ہٹانے سے متعلق رہنا چاہئے۔ گیٹ-ایکس کے ساتھ یہ ضروری نہیں ہے ، کیونکہ وسائل میموری سے حذف ہوجاتے ہیں جب وہ بطور ڈیفالٹ استعمال نہیں ہوتے ہیں۔ اگر آپ اسے یاد میں رکھنا چاہتے ہیں تو ، آپ کو اپنی انحصار میں واضح طور پر "مستقل: سچ" کا اعلان کرنا ہوگا۔ اس طرح ، وقت کی بچت کے علاوہ ، آپ کو میموری پر غیر ضروری انحصار کرنے کا خطرہ بھی کم ہوتا ہے۔ انحصار لوڈنگ ڈیفالٹ کے لحاظ سے بھی سست ہے۔

 **تنظیم :** گیٹ-ایکس کی مدد سے منظر ، نمائش کی منطق ، کاروباری منطق ، انحصار انجیکشن ، اور نیویگیشن کی مجموعی ڈوپولنگ کی اجازت دیتا ہے۔ راستوں کے مابین تشریف لے جانے کے لئے سیاق و سباق کی ضرورت نہیں ہے ، لہذا ، آپ اس کے لئے ویجیٹ ٹری (ویژنائزیشن) پر منحصر نہیں ہیں۔ وراثت میں ملنے والے ویجیٹ کے ذریعے اپنے کنٹرولرز / بلاکس تک رسائی حاصل کرنے کے لئے سیاق و سباق کی ضرورت نہیں ہے ، لہذا آپ اپنی پریزنٹیشن منطق اور کاروباری منطق کو اپنی نظریاتی پرت سے مکمل طور پر ڈوپل کرتے ہیں۔ آپ کو متعدد فراہم کنندگان کے ذریعہ اپنے ویجیٹ ٹری میں اپنے کنٹرولرز / ماڈلز / بلاکس کی کلاسیں انجیکشن کرنے کی ضرورت نہیں ہے ، کیونکہ یہ گیٹ ایکس اپنی انحصار انجیکشن کی خصوصیت استعمال کرتا ہے ، جس سے ڈی آئی کو اس کے نظارے کو مکمل طور پر خارج کردیتی ہے۔ گیٹ-ایکس کے ذریعے آپ جانتے ہو کہ اپنی درخواست کی ہر خصوصیت کو کہاں تلاش کرنا ہے ، بطور ڈیفالٹ صاف ستھرا۔ بحالی کی سہولت فراہم کرنے کے علاوہ ، یہ ماڈیولوں کی شیئرنگ کو بھی یقینی بناتا ہے ، ایسی کوئی چیز جو اس وقت تک پھڑپھڑ پھینک کر ناقابل فہم تھی ، اور کچھ مکمل طور پر ممکن تھا۔
بی ایل او سی پھڑپھڑا میں کوڈ کو منظم کرنے کا نقطہ آغاز تھا ، یہ کاروباری منطق کو تصور سے الگ کرتا ہے۔ گیٹ ایکس اس کا فطری ارتقا ہے ، جس سے نہ صرف کاروباری منطق کو الگ کیا جائے بلکہ پیش کش کی منطق بھی۔ انحصار اور راستوں کا بونس انجیکشن بھی ڈوپل ہوچکا ہے ، اور ڈیٹا لیئر ان سب سے باہر ہے۔ آپ جانتے ہیں کہ سب کچھ کہاں ہے ، اور یہ سب کچھ ہیلو دنیا کی تعمیر سے زیادہ آسان طریقے سے ہے۔ گیٹ-ایکس ، فلٹر ایس ڈی کے کے ساتھ اعلی کارکردگی کی ایپلی کیشنز کی تعمیر کا آسان ترین ، عملی اور اسکیل ایبل طریقہ ہے ، جس کے ارد گرد ایک بہت بڑا ماحولیاتی نظام ہے جو کامل کے ساتھ مل کر کام کرتا ہے ، ابتدائی افراد کے لئے آسان اور ماہرین کے لئے درست ہے۔ یہ محفوظ ، مستحکم ، تازہ ترین ہے ، اور APIs کی ایک بہت بڑی رینج پیش کرتا ہے جو پہلے سے طے شدہ فلوٹر SDK پر موجود نہیں ہے۔

گیٹ ایکس پھولا ہوا نہیں ہے۔ اس میں بہت ساری خصوصیات ہیں جو آپ کو کسی بھی چیز کی فکر کیے بغیر پروگرامنگ شروع کرنے کی اجازت دیتی ہیں ، لیکن ان خصوصیات میں سے ہر ایک الگ الگ کنٹینر میں ہے ، اور صرف استعمال کے بعد شروع کی گئی ہے۔ اگر آپ صرف اسٹیٹ مینجمنٹ کا استعمال کرتے ہیں تو صرف اسٹیٹ مینجمنٹ مرتب کی جائے گی۔ اگر آپ صرف راستے ہی استعمال کرتے ہیں تو ، اسٹیٹ مینجمنٹ کی طرف سے کوئی بھی چیز مرتب نہیں کی جائے گی۔

گیٹ ایکس میں ایک بہت بڑا ماحولیاتی نظام ، ایک بڑی برادری ، بڑی تعداد میں تعاون کار موجود ہے ، اور جب تک پھڑپھڑ موجود ہے اس کو برقرار رکھا جائے گا۔ گیٹ ایکس بھی اسی کوڈ کے ساتھ اینڈروئیڈ ، آئی او ایس ، ویب ، میک ، لینکس ، ونڈوز اور اپنے سرور پر چلنے کے قابل ہے۔
**یہ ممکن ہے کہ اپنے پس منظر میں فرنٹ اینڈ پر تیار کردہ اپنے کوڈ کو پوری طرح سے استعمال کریں [گیٹ ایکس سرور](https://github.com/jonataslaw/get_server)**.

**اس کے علاوہ ، سرور پر اور سامنے والے اختتام پر ، پوری ترقی کا عمل مکمل طور پر خودکار ہوسکتا ہے [CLI حاصل کریں](https://github.com/jonataslaw/get_cli)**.

**اس کے علاوہ ، آپ کی پیداوری کو مزید بڑھانے کے لئے ، ہمارے پاس ہے
[VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) اور [Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

<a id="readme-section-3"></a>

# انسٹال
کوڈ میں گیٹ ایکس کی تنصیب
```yaml
# pubspec.yaml
dependencies:
  get:
```
ان فائلوں میں امپورٹ کریں جو استعمال ہوں گی
```dart
import 'package:get/get.dart';
```

<a id="readme-section-4"></a>

# کاؤنٹرایپ

گیٹ-ایکس کی طاقت کو ظاہر کرنے کے ل I ، میں یہ ظاہر کروں گا کہ کس طرح ہر کلک کے ساتھ "کاؤنٹر" بنانا ہے ، کس طرح صفحات کے مابین تبادلہ کرنا اور اسکرینوں کے درمیان اسٹسٹ کو مشترکہ انداز میں بانٹنا ، کاروباری منطق کو صرف نظر سے الگ کرنا ، 26 لائنز کوڈ شامل تبصرے۔

- پہلا قدم :
  اپنے میٹریل ایپ سے پہلے "گیٹ" شامل کریں ، اسے گیٹ میٹریئل ایپ میں تبدیل کریں

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

نوٹ: اس سے مٹیریل ایپ میں ترمیم نہیں ہوتی ، گیٹ میٹیرال ایپ کوئی ترمیم شدہ میٹریل ایپ نہیں ہے ، یہ ایک کنفیگریڈ ویجیٹ ہے ، جس میں بطور سی سی فلڈ میٹریل ایپ ہے۔ آپ اسے دستی طور پر تشکیل دے سکتے ہیں ، لیکن یہ یقینی طور پر ضروری نہیں ہے۔ گیٹ میٹریئل ایپ راستوں کو تخلیق کرے گی ، انہیں انجیکشن دے گی ، ترجمہ انجیکشن کرے گی ، روٹ نیویگیشن کے لئے آپ کی ضرورت کی ہر چیز کو انجیکشن دے گی۔ اگر آپ صرف ریاستی انتظام یا انحصار کے انتظام کے لئے گیٹیکس کا استعمال کرتے ہیں تو ، گیٹ میٹریئل ایپ کو استعمال کرنے کی ضرورت نہیں ہے۔ گیٹ میٹیرال ایپ راستوں ، سنیکبارز ، عالمگیریت ، نچلی شیٹس ، مکالموں ، اور روٹس سے متعلق اعلی سطحی اپس اور سیاق و سباق کی عدم موجودگی کے لئے ضروری ہے۔
یہ اقدام صرف اس صورت میں ضروری ہے اگر آپ روٹ مینجمنٹ کا استعمال کریں گے (`Get.to()`, `Get.back()`). اگر آپ اسے استعمال نہیں کریں گے تو پھر ضروری نہیں ہے کہ قدم 1 کریں

- دوسرا مرحلہ :
  اپنی کاروباری منطق کلاس بنائیں اور اس کے اندر تمام متغیرات ، طریقے اور کنٹرولر رکھیں۔
   کا استعمال کرتے ہوئے کسی بھی متغیر کو قابل مشاہدہ کرسکتے ہیں ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- تیسرا قدم :
  اپنا نظارہ بنائیں ، اسٹیٹ لیس ویجیٹ استعمال کریں اور کچھ رام کو بچائیں ، گیٹ-ایکس کی مدد سے آپ کو اب اسٹیٹ فل ویجٹ استعمال کرنے کی ضرورت نہیں ہوگی۔

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {
    // آپ کی کلاس کا آغاز
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(() => Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

نتیجہ
![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)
یہ ایک سادہ پروجیکٹ ہے لیکن اس سے پہلے ہی یہ واضح ہوجاتا ہے کہ گیٹ کتنا طاقتور ہے۔ جیسے جیسے آپ کا پروجیکٹ بڑھتا جائے گا ، یہ فرق مزید نمایاں ہوتا جائے گا۔
گیٹ کو ٹیموں کے ساتھ کام کرنے کے لئے ڈیزائن کیا گیا تھا ، لیکن اس سے ایک فرد ڈویلپر کا کام آسان ہوجاتا ہے۔
اپنی آخری تاریخ کو بہتر بنائیں ، کارکردگی کو کھونے کے بغیر وقت پر سب کچھ فراہم کریں۔ اگر آپ نے اس جملے کی نشاندہی کی ہے تو ، گیٹ-ایکس آپ کے لئے ہے!
<a id="readme-section-5"></a>

# تین ستون
<a id="readme-section-6"></a>

## اسٹیٹ مینجمنٹ
گیٹ کے دو مختلف مینیجر ہوتے ہیں: سادہ ریاستی مینیجر (ہم اسے گیٹ بلڈر کہیں گے) اور رد عمل کا مظاہرہ کرنے والے مینیجر (گیٹ-ایکس / اوب-ایکس)
<a id="readme-section-7"></a>

### ری ایکٹو اسٹیٹ منیجر
ری ایکٹیو پروگرامنگ بہت سے لوگوں کو اجنبی بنا سکتا ہے کیونکہ ایسا کہا جاتا ہے کہ یہ پیچیدہ ہے۔ گیٹ ایکس نے رد عمل مندانہ پروگرامنگ کو کسی آسان چیز میں تبدیل کردیا:
- آپ کو اسٹریمکنٹرولر بنانے کی ضرورت نہیں ہوگی
- آپ کو ہر متغیر کے لئے ایک اسٹریم بلڈر بنانے کی ضرورت نہیں ہوگی
- آپ کو ہر ریاست کے لئے کلاس بنانے کی ضرورت نہیں ہوگی
- آپ کو ابتدائی قدر کے لئے گیٹ ایکس بنانے کی ضرورت نہیں ہوگی
- آپ کو کوڈ جنریٹر استعمال کرنے کی ضرورت نہیں ہوگی


گیٹ-ایکس کے ساتھ قابل عمل پروگرامنگ اتنا ہی آسان ہے جتنا سیٹ اسٹیٹ کے استعمال سے۔

آئیے تصور کریں کہ آپ کے پاس متغیر ہے اور چاہتے ہیں کہ جب بھی آپ اسے تبدیل کریں ، اس کا استعمال کرنے والے تمام وجیٹس خود بخود تبدیل ہوجائیں۔

یہ آپ کی گنتی متغیر ہے:

```dart
var name = 'Jonatas Borges';
```

".obs" اسے مشاہدہ کرنے کے لئے؛ آپ کو اس کے آخر میں  شامل کرنے کی ضرورت ہے

```dart
var name = 'Jonatas Borges'.obs;
```

اور صارف کے انٹرفیس میں ، جب آپ اس نمبر کو دکھانا چاہتے ہیں اور جب بھی اس کی اہمیت بدل جاتی ہے تو اسکرین کو اپ ڈیٹ کرنا چاہتے ہیں ، صرف یہ کریں:

```dart
Obx(() => Text("${controller.name}"));
```

بس۔ یہ آسان ہے.

<a id="readme-section-8"></a>

### اسٹیٹ مینجمنٹ کے بارے میں مزید تفصیلات

**اسٹیٹ مینجمنٹ کی مزید گہرائی سے وضاحت ملاحظہ کریں [یہاں](./documentation/en_US/state_management.md).  وہاں آپ مزید مثالیں دیکھیں گے اور آسان ریاستی مینیجر اور رد عمل ریاست کے مینیجر کے مابین بھی فرق**

آپ کو گیٹ ایکس پاور کا ایک اچھا خیال ملے گا۔

<a id="readme-section-9"></a>

## روٹ مینجمنٹ
اگر آپ سیاق و سباق کے بغیر راستے / سنیکبارز / مکالمے / بوتل شیٹ استعمال کرنے جارہے ہیں تو گیٹ ایکس آپ کے لئے بھی بہترین ہے ، بس اسے دیکھیں:
اپنے میٹریل ایپ سے پہلے "گیٹ" شامل کریں ، اسے گیٹ میٹریئل ایپ میں تبدیل کریں
```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

نئی اسکرین پر جائیں:

```dart

Get.to(() => NextScreen());
```

نام کے ساتھ نئی اسکرین پر جائیں۔ نامزد راستوں کے بارے میں مزید تفصیلات دیکھیں [یہاں](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

سنیک بار ، ڈائیلاگ ، نیچے شیٹ کو بند کریں 
Navigator.pop(context);

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

اگلی اسکرین پر جانے کے لئے اور پچھلی اسکرین پر واپس جانے کا کوئی آپشن نہیں (اسپلش اسکرین ، لاگ ان اسکرینوں وغیرہ میں استعمال کیلئے)

```dart
Get.off(() => NextScreen());
```

اگلی سکرین پر جانے اور پچھلے سبھی راستوں کو منسوخ کرنے کے لئے (شاپنگ کارٹس ، پولز اور ٹیسٹوں میں کارآمد)

```dart
Get.offAll(() => NextScreen());
```

غور کیا کہ آپ کو ان میں سے کوئی بھی کام کرنے کے لئے سیاق و سباق کا استعمال نہیں کرنا پڑا؟ گیٹ روٹ مینجمنٹ کو استعمال کرنے کا سب سے بڑا فائدہ یہ ہے۔ اس کی مدد سے ، آپ اپنے کنٹرولر کلاس کے اندر ، تشویش کے بغیر ، ان تمام طریقوں کو انجام دے سکتے ہیں۔

<a id="readme-section-10"></a>

### روٹ مینجمنٹ کے بارے میں مزید تفصیلات

**گیٹ ایکس نامی روٹ کے ساتھ کام کرتا ہے اور اپنے راستوں پر نچلی سطح کا کنٹرول بھی پیش کرتا ہے! ایک گہرائی میں دستاویزات موجود ہیں [یہاں](./documentation/en_US/route_management.md)**

<a id="readme-section-11"></a>

## انحصار کا انتظام

گیٹ ایکس کے پاس ایک سادہ اور طاقتور انحصار منیجر ہے جو آپ کو اپنے بلاک یا کنٹرولر کی طرح ایک ہی کلاس کو دوبارہ حاصل کرنے کی سہولت دیتا ہے جس میں کوڈ کی صرف 1 لائنز ، کوئی فراہم کنندہ سیاق و سباق ، کوئی وراثت والا ویجٹ نہیں ہے۔

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
نوٹ: اگر آپ گیٹ اسٹیٹ منیجر استعمال کررہے ہیں تو ، اے پی آئی کی پابندیوں پر زیادہ توجہ دیں ، جس سے آپ کے قول کو اپنے کنٹرولر سے مربوط کرنے میں آسانی ہوگی۔

آپ جس کلاس کو استعمال کررہے ہیں اس میں اپنی کلاس کو تیز کرنے کے بجائے ، آپ اسے حاصل کریں مثال کے طور پر اندر داخل کررہے ہیں ، جس سے یہ آپ کے ایپ میں دستیاب ہوگا۔
لہذا آپ اپنے کنٹرولر (یا کلاس بلاک) کو عام طور پر استعمال کرسکتے ہیں

**اشارہ:**گیٹ ایکس انحصار کا انتظام پیکیج کے دوسرے حصوں سے گر گیا ہے ، لہذا اگر مثال کے طور پر آپ کی ایپ پہلے ہی اسٹیٹ مینیجر کو استعمال کررہی ہے (کوئی بھی ، اس سے کوئی فرق نہیں پڑتا ہے) ، آپ کو یہ سب کچھ دوبارہ لکھنے کی ضرورت نہیں ہے ، آپ اس انحصار کو استعمال کرسکتے ہیں۔
```dart
controller.fetchApi();
```

ذرا تصور کریں کہ آپ نے متعدد راستوں سے گھوما ہوا ہے ، اور آپ کو ایک ایسے ڈیٹا کی ضرورت ہے جو آپ کے کنٹرولر میں پیچھے رہ گیا ہو ، آپ کو فراہم کنندہ یا گیٹ_یٹ کے ساتھ مل کر ایک ریاستی مینیجر کی ضرورت ہوگی ، صحیح؟ گیٹ ایکس کے ساتھ نہیں۔ آپ کو اپنے کنٹرولر کے ل "" ڈھونڈنے "کے لئے گیٹ ایکس سے پوچھنے کی ضرورت ہے ، آپ کو کسی بھی اضافی انحصار کی ضرورت نہیں ہے۔

```dart
Controller controller = Get.find();
```

اور پھر آپ اپنا کنٹرولر ڈیٹا دوبارہ حاصل کرنے میں کامیاب ہوجائیں گے جو وہاں واپس حاصل کیا گیا تھا

```dart
Text(controller.textFromApi);
```

<a id="readme-section-12"></a>

### انحصار کے انتظام کے بارے میں مزید تفصیلات

**انحصار کے انتظام کی مزید گہرائی سے وضاحت ملاحظہ کریں [یہاں](./documentation/en_US/dependency_management.md)**

<a id="readme-section-13"></a>

# استعمال

<a id="readme-section-14"></a>

## عالمگیریت

<a id="readme-section-15"></a>

### ترجمہ

ترجمہ کو ایک آسان کلیدی قدر والے لغت کے نقشے کے طور پر رکھا جاتا ہے۔
حسب ضرورت ترجمہ شامل کرنے کے لئے ، ایک کلاس تشکیل دیں اور توسیع کریں 
`Translations`
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

<a id="readme-section-16"></a>

#### ترجمہ کا استعمال

بس ضمیمہ کریں `.tr` مخصوص کی میں اور اس کی موجودہ قیمت کا استعمال کرتے ہوئے ترجمہ کیا جائے گا`Get.locale` اور `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

<a id="readme-section-17"></a>

### مقامی

مقام اور ترجمے کی وضاحت کے لئے پیرامیٹرز کو `گیٹ میٹیرال ایپ` پاس کریں۔

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

<a id="readme-section-18"></a>

#### مقام کی تبدیلی

لوکل کو اپ ڈیٹ کرنے کے لئے کال کریں گیٹ۔ اپ ڈیٹ لوکل (لوکل)۔ پھر ترجمے خود بخود نیا مقام استعمال کرتے ہیں۔

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-19"></a>

#### سسٹم لوکیشن

ڈیوائس لوکل حاصل کرنے کے لئے اس لائن کو استعمال کریں

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

<a id="readme-section-20"></a>

## تھیم کی تبدیلی

برائے کرم `گیٹ میٹرال ایپ` سے زیادہ کسی بھی اعلی سطح کے ویجیٹ کو اپ ڈیٹ کرنے کیلئے استعمال نہ کریں۔ اس سے ڈپلیکیٹ کیز کو متحرک کیا جاسکتا ہے۔ بہت سارے لوگ صرف اپنی ایپ کے تھیم کو تبدیل کرنے کے لئے "تھیم پیڈائزر" ویجیٹ بنانے کے پراگیتہاسک نقطہ نظر کے عادی ہیں ، اور یہ ** گیٹ ایکس ™ ** کے ساتھ یقینی طور پر ضروری نہیں ہے۔

آپ اپنا کسٹم تھیم تشکیل دے سکتے ہیں اور اس کے لئے کسی بھی بوائلر پلیٹ کے بغیر اسے `گیٹ.چینج تھیم` میں شامل کرسکتے ہیں:

```dart
Get.changeTheme(ThemeData.light());
```


اگر آپ بٹن کی طرح کوئی چیز بنانا چاہتے ہیں جو تھیم کو `آن ٹیپ میں تبدیل کردے ، تو آپ اس کے لئے دو ** گیٹ ایکس ™ ** اے پی پی کو جوڑ سکتے ہیں:

- اے پی آئی جو چیک کرتا ہے کہ آیا گہرا `تھیم` استعمال کیا جارہا ہے۔
- اور `تھیم` کی تبدیلی ، آپ اسے صرف `آن پیسڈ` میں ڈال سکتے ہیں۔

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

جب ڈارک موڈ چالو ہوجاتا ہے ، تو وہ _ لائٹ تھیم_ میں تبدیل ہوجائے گا ، اور جب _ لائٹ تھیم_ فعال ہوجائے گا ، تو یہ _ ڈارک تھیم_ میں بدل جائے گا۔

<a id="readme-section-21"></a>

## رابطے کا قیام
گیٹ کنیکٹ آپ کی پیٹھ سے اپنے سامنے تک HTTP یا ویب ساکٹس کے ذریعہ مواصلت کرنے کا ایک آسان طریقہ ہے

<a id="readme-section-22"></a>

### ڈیفالٹ کنکشن کا قیام
آپ آرام سے گیٹ کنیکٹ کو بڑھا سکتے ہیں اور GET / POST / PUT / DELETE / SOCKET طریقوں کو اپنے ریسٹ API یا ویب ساکٹس کے ساتھ بات چیت کرسکتے ہیں۔

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

### خود سے رابطے کا قیام

گیٹ کنیکٹ انتہائی حسب ضرورت ہے آپ درخواست کو تبدیل کرنے والے ، جواب دہندگان کے بطور ، جواب دہندگان کی حیثیت سے ، ایک مستند کی وضاحت ، اور حتی کہ کوششوں کی تعداد بھی کرسکتے ہیں جس میں وہ خود کو مستند کرنے کی کوشش کرے گی ، اس کے علاوہ یہ ایک معیاری ڈیکوڈر کی وضاحت کے امکان کو بھی فراہم کرے گی جو تبدیل ہوجائے گی۔ آپ کی ساری درخواستیں آپ میں اضافی تشکیل کے بغیر ماڈل کرتی ہیں۔

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

## گیٹ پیج مڈل ویئر

گیٹ پیج کے پاس اب نئی پراپرٹی ہے جو گیٹ میڈل ویئر کی فہرست لیتی ہے اور انہیں مخصوص ترتیب میں چلاتی ہے۔

نوٹ: جب گیٹ پیج کے مڈل ویئرز ہوں گے تو ، اس صفحے کے سبھی بچوں میں ایک جیسے مڈل ویئرز خودبخود ہوں گے۔

<a id="readme-section-25"></a>

### ترجیح

مڈل ویئر کو چلانے کا آرڈر گیٹ میڈل ویئر میں ترجیحی طور پر ترتیب دیا جاسکتا ہے۔

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
وہ مڈل ویئر اسی ترتیب سے چلائے جائیں گے **-8 => 2 => 4 => 5**

<a id="readme-section-26"></a>

### ری ڈائریکٹ

redirectDelegate میں route جاری رکھتا ہے، دوسرا RouteDecoder redirect کرتا ہے اور null منسوخ کرتا ہے۔ login رجسٹر کریں اور loop سے بچیں۔

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

### جب پیج کی درخواست کی جائے

جب اس صفحے کو کچھ بھی تخلیق کرنے سے پہلے بلایا جائے گا تو اس فنکشن کو کہا جائے گا
آپ اسے صفحہ کے بارے میں کچھ تبدیل کرنے یا نیا صفحہ دینے کیلئے استعمال کرسکتے ہیں

```dart
class PageTitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Welcome');
}
```

<a id="readme-section-28"></a>

### آنبائنڈنگ اسٹارٹ

اس فنکشن کو بائنڈنگ شروع کرنے سے پہلے ہی کہا جائے گا۔
یہاں آپ اس صفحے کے لئے پابندیوں کو تبدیل کرسکتے ہیں۔

```dart
class BindingMiddleware extends GetMiddleware {
  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);
}
```

<a id="readme-section-29"></a>

### آنپیج بلڈ اسٹارٹ

اس فنکشن کو بائنڈنگ شروع کرنے کے بعد ہی کہا جائے گا۔
یہاں آپ اس کے بعد اور پیج ویجیٹ بنانے سے پہلے پابندیوں کو تخلیق کرنے کے بعد کچھ کرسکتے ہیں۔

```dart
class BuildMiddleware extends GetMiddleware {
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;
}
```

<a id="readme-section-30"></a>

### جب پیج لوڈ ہو

اس فنکشن کو گیٹ پیج ڈاٹ پیج فنکشن کے بلانے کے ٹھیک ہی بعد میں کہا جائے گا اور آپ کو اس فنکشن کا نتیجہ پیش کرے گا۔ اور دکھایا جائے گا کہ ویجیٹ لے لو.

<a id="readme-section-31"></a>

### جب صفحہ تصرف ہوجائے

اس فنکشن کو صفحے کے تمام متعلقہ اشیاء (کنٹرولرز ، آراء ، ...) کو ضائع کرنے کے بعد ہی کہا جائے گا۔

<a id="readme-section-32"></a>

## دوسرے اعلی درجے کی APIs

```dart
// give the current args from currentScreen
Get.arguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Routing API from GetObserver
Get.routing

// check if snackbar is open
Get.isSnackbarOpen

// check if dialog is open
Get.isDialogOpen

// check if bottomsheet is open
Get.isBottomSheetOpen

// remove one route.
Get.removeRoute('/details')

// back repeatedly until the predicate returns true.
Get.until((page) => page.name == '/home')

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil(() => const Scaffold(), (page) => page.name == '/home')

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil('/details', (page) => page.name == '/home')

//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Check the device type
GetPlatform.isMobile
GetPlatform.isDesktop
//All platforms are supported independently in web!
//You can tell if you are running inside a browser
//on Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.overlayContext

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

// Gives you the power to define half the screen, a third of it and so on.
// Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets

/// Similar to MediaQuery.of(context).orientation;
context.orientation

/// Check if device is on landscape mode
context.isLandscape

/// Check if device is on portrait mode
context.isPortrait

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor

/// Get the shortestSide from screen
context.mediaQueryShortestSide

/// True if width be larger than 800
context.showNavbar

/// True if the shortestSide is smaller than 600p
context.isPhone

/// True if the shortestSide is largest than 600p
context.isSmallTablet

/// True if the shortestSide is largest than 720p
context.isLargeTablet

/// True if the current device is Tablet
context.isTablet

/// اسکرین کے سائز کے مطابق <T> ایک قیمت لوٹاتا ہے
/// اس کی قیمت دے سکتے ہیں:
/// واچ: اگر مختصر ترین جگہ 300 سے چھوٹی ہے
/// موبائل: اگر مختصر ترین سائٹ 600 سے چھوٹی ہے
/// ٹیبلٹ: اگر مختصر ترین سائٹ 1200 سے چھوٹی ہے
/// ڈیسک ٹاپ: اگر چوڑائی 1200 سے زیادہ ہے
context.responsiveValue<T>()
```

<a id="readme-section-33"></a>

### اختیاری عالمی ترتیبات اور دستی تشکیلات

گیٹ میٹریئل ایپ آپ کے لئے ہر چیز کو کنفیگر کرتی ہے ، لیکن اگر آپ تشکیل کرنا چاہتے ہیں تو دستی طور پر حاصل کریں۔

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

آپ `گیٹ اوزرور` کے اندر اپنا مڈل ویئر بھی استعمال کرسکیں گے ، اس سے کسی بھی چیز پر اثر نہیں پڑے گا۔

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

آپ `گیٹ` کیلئے _ عالمی ترتیبات_ تشکیل دے سکتے ہیں۔ کسی بھی راستے کو آگے بڑھانے سے پہلے صرف اپنے کوڈ میں `گیٹ کنفیگ` شامل کریں۔
یا اسے اپنے `گیٹ میٹیرال ایپ` میں براہ راست کریں

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

آپ لاگ ان پیغامات کو اختیاری طور پر `گیٹ` سے دوبارہ بھیج سکتے ہیں۔
اگر آپ خود اپنا ، پسندیدہ لاگنگ پیکیج استعمال کرنا چاہتے ہیں تو ،
اور وہاں موجود نوشتہ جات پر قبضہ کرنا چاہتے ہیں:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // pass the message to your favourite logging package here
  // please note that even if enableLog: false log messages will be pushed in this callback
  // you get check the flag if you want through GetConfig.isLogEnable
}
```

<a id="readme-section-34"></a>

### مقامی اسٹیٹ ویجٹ

یہ وجیٹس آپ کو ایک ہی قیمت کا انتظام کرنے ، اور مقامی طور پر ریاست کو دائمی اور مقامی رکھنے کی اجازت دیتے ہیں۔
ہمارے پاس ری ایکٹیو اور سادہ ذائقے ہیں۔
مثال کے طور پر ، آپ ان کو ٹیکسٹ فیلڈ میں چھپے ہوئے متن کو ٹوگل کرنے کے لئے استعمال کرسکتے ہیں ، شاید کوئی رواج بنائیں
توسیع پذیر پینل ، یا ہوسکتا ہے کہ موجودہ فہرست میں ترمیم کرکے نیچے کی نیویگیشن بار میں مواد کو تبدیل کرتے ہوئے
`Scaffold` میں جسم کا

<a id="readme-section-35"></a>

#### ویلیو بلڈر

`StatefulWidget` کی ایک سادگی جو` .setState` کال بیک کے ساتھ کام کرتی ہے جو تازہ ترین قیمت لیتی ہے۔

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // same signature! you could use ( newValue ) => updateFn( newValue )
  ),
  // if you need to call something outside the builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

<a id="readme-section-36"></a>

#### اوبکس ویلیو

اس طرح آپ کو قیمت ملتی ہے

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

<a id="readme-section-37"></a>

## کارآمد نکات

`.obs`ervables ( _Rx_ Types) 
```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

 `message`  --> **RxString**

[x] `message.substring( 0, 4 )`.
[o] `.value`

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

#### گیٹ ویو


مجھے یہ ویجیٹ پسند ہے ، بہت آسان ، پھر بھی ، اتنا مفید ہے!

ایک کانسٹیٹ اسٹیٹ لیس ویجیٹ ہے جس میں رجسٹرڈ `کنٹرولر` کے لئے حاصل کرنے والا `کنٹرولر` ہے ، بس۔

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // ALWAYS remember to pass the `Type` you used to register your controller!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // just call `controller.something`
     );
   }
 }
```

<a id="readme-section-39"></a>

#### گیٹ ویجٹ

زیادہ تر لوگوں کو اس ویجیٹ کے بارے میں کوئی اندازہ نہیں ہے ، یا اس کے استعمال کو پوری طرح سے الجھن میں ہے
استعمال کا معاملہ بہت کم ہے ، لیکن بہت ہی خاص ہے: یہ ایک کنٹرولر کی مدد کرتا ہے
کیچ_کی وجہ سے ، `مجاز اسٹیٹ لیس  نہیں ہوسکتا ہے

> تو ، جب آپ کو ایک کنٹرولر "کیش" کرنے کی ضرورت ہے؟

اگر آپ استعمال کرتے ہیں تو ، ** گیٹ ایکس ** کی ایک اور "اتنی عام نہیں" خصوصیت: `گیٹ.کریٹ`۔

`Get.spawn(()=>Controller())` ایک نیا پیدا کرے گا `Controller` ہر بار جب آپ کال کریں گے
`Get.find<Controller>()`,

اسی جگہ پر `گیٹ ویجٹ` چمکتا ہے ... جیسے کہ آپ اسے استعمال کرسکتے ہیں ، مثال کے طور پر ،
ٹوڈو اشیاء کی ایک فہرست رکھنے کے ل. لہذا ، اگر آپکے پاس وجٹس کو "دوبارہ تعمیر" ہو جاتا ہے تو ، یہ وہی کنٹرولر مثال برقرار رکھے گا۔

<a id="readme-section-40"></a>

#### گیٹکس سروس

This class is like a `GetxController`, it shares the same lifecycle ( `onInit()`, `onReady()`, `onClose()`).
But has no "logic" inside of it. It just notifies **GetX** Dependency Injection system, that this subclass
**can not** be removed from memory.

So is super useful to keep your "Services" always reachable and active with `Get.find()`. Like:
`ApiService`, `StorageService`, `CacheService`.

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

`گیٹکسسروس` کو اصل میں حذف کرنے کا واحد راستہ ،`گیٹ.ریسیٹ`  ہے جو ایک جیسے ہے
آپ کی ایپ کا "گرم ریبوٹ"۔ لہذا ، یاد رکھیں ، اگر آپ کو دوران کلاس مثال کے طور پر مطلق استقامت کی ضرورت ہو
اپنی ایپ کی زندگی بھر ، `گیٹکسسروس` استعمال کریں۔

<a id="readme-section-41"></a>

# پچھلے ورژن سے اہم تبدیلیاں

1.  آر ایکس اقسام:

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

آر ایکس کنٹرولر اور گیٹ بلڈر اب آپس میں مل گئے ہیں ، اب آپ کو یہ حفظ کرنے کی ضرورت نہیں ہے کہ آپ کون سے کنٹرولر استعمال کرنا چاہتے ہیں ، صرف گیٹکسکنٹرولر کا استعمال کریں ، یہ سادہ سسٹم مینجمنٹ اور رد عمل کے  بھی کام کرے گا۔

2.  نامزد روٹس
پہلے:

```text
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

اب:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

یہ تبدیلی کیوں؟
اکثر ، یہ فیصلہ کرنا ضروری ہوسکتا ہے کہ پیرامیٹر ، یا لاگ ان ٹوکن سے کون سا صفحہ ڈسپلے ہوگا ، پچھلا نقطہ نظر پیچیدہ تھا ، کیونکہ اس نے اس کی اجازت نہیں دی۔
صفحہ کو کسی فنکشن میں داخل کرنے سے رام کی کھپت میں نمایاں کمی واقع ہوئی ہے ، کیونکہ ایپ شروع ہونے کے بعد سے روٹوں کو میموری میں مختص نہیں کیا جائے گا ، اور اس طرح اس طرح کے نقطہ نظر کو کرنے کی بھی اجازت دی گئی ہے۔

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

<a id="readme-section-42"></a>

# گیٹکس کیوں؟

1.  فلٹر کی تازہ کاری کے بعد ، آپ کے بہت سے پیکیجز ٹوٹ جائیں گے۔ بعض اوقات تالیف کی غلطیاں ہوتی ہیں ، غلطیاں اکثر ظاہر ہوتی ہیں کہ اب بھی اس کے بارے میں کوئی جواب نہیں ملتا ہے ، اور ڈویلپر کو یہ جاننے کی ضرورت ہوتی ہے کہ غلطی کہاں سے ہوئی ہے ، غلطی کو ٹریک کریں ، تب ہی متعلقہ ذخیرہ میں کوئی مسئلہ کھولنے کی کوشش کریں ، اور دیکھیں کہ اس کا مسئلہ حل ہوتا ہے۔ ترقی کے مرکزی وسائل کو مرکز بنائیں (ریاست ، انحصار اور روٹ مینجمنٹ) ، آپ کو اپنے پبسپیک میں ایک پیکیج شامل کرنے اور کام شروع کرنے کی اجازت دے۔ پھڑپھڑانے کی تازہ کاری کے بعد ، آپ کو صرف انحصار کرنے کی ضرورت ہے گیٹ انحصار کو اپ ڈیٹ کریں ، اور کام کریں۔ مطابقت کے مسائل کو بھی حل کریں حاصل کریں۔ ایک پیکج کا ورژن کتنی بار دوسرے کے ورژن کے ساتھ مطابقت نہیں رکھتا ہے ، کیونکہ ایک ورژن میں انحصار استعمال کرتا ہے ، اور دوسرا دوسرے ورژن میں۔ گیٹ کو استعمال کرنے میں بھی یہ کوئی تشویش نہیں ہے ، کیونکہ سب کچھ ایک ہی پیکج میں ہے اور مکمل طور پر ہم آہنگ ہے۔

2. فلٹر آسان ہے .فلٹر ناقابل یقین ہے ، لیکن .فلٹر کے پاس اب بھی کچھ بوائلرپلیٹ موجود ہے جو زیادہ تر ڈویلپرز کے لئے ناپسندیدہ ہوسکتا ہے ، جیسے `Navigator.of(context).push (context, builder [...]`. پروگرامنگ کو آسان بنائیں۔ صرف راستے پر کال کرنے کے لئے 8 لائنوں کے کوڈ لکھنے کے بجائے ، آپ صرف یہ کرسکتے ہیں: `Get.to(() => Home())` اور آپ کر چکے ہیں ، آپ اگلے صفحے پر جائیں گے۔ متحرک ویب یو آر ایل ایک بہت تکلیف دہ چیز ہے جس کے ساتھ کرنا ہے ۔فلٹر فی الحال ، اور یہ کہ گیٹیکس کے ساتھ احمقانہ حد تک آسان ہے۔ .. فلٹر میں ریاستوں کا انتظام کرنا ، اور انحصار کا انتظام کرنا بھی ایک ایسی چیز ہے جو بہت ساری بحثیں پیدا کرتی ہے ، کیوں کہ پب میں سیکڑوں نمونوں کی موجودگی موجود ہے۔ لیکن آپ کے متغیر کے اختتام پر `.obs` شامل کرنے جتنا آسان کوئی چیز نہیں ہے ، اور اپنے ویجیٹ کو کسی اوکس کے اندر رکھ دیں ، اور بات یہ ہے کہ اس متغیر کی تمام تر تازہ کاری خود بخود اسکرین پر اپ ڈیٹ ہوجائے گی۔

3. کارکردگی کی فکر کئے بغیر آسانی۔ .فلٹر کی کارکردگی پہلے ہی حیرت انگیز ہے ، لیکن تصور کریں کہ آپ اپنے بلاکس / اسٹورز / کنٹرولرز / وغیرہ کلاسوں کو تقسیم کرنے کے لئے اسٹیٹ مینیجر اور لوکیٹر کا استعمال کرتے ہیں۔ جب آپ کو ضرورت نہ ہو تو آپ کو دستی طور پر اس انحصار کے اخراج کو کال کرنا پڑے گا۔ لیکن کیا آپ نے کبھی اپنے کنٹرولر کو محض استعمال کرنے کے بارے میں سوچا ہے ، اور جب اب یہ کسی کے ذریعہ استعمال نہیں ہو رہا تھا تو ، اسے آسانی سے میموری سے حذف کردیا جائے گا؟ گیٹ ایکس یہی کرتا ہے۔ اسمارٹ مینجمنٹ کے ساتھ ، ہر وہ چیز جو استعمال نہیں ہورہی ہے اسے میموری سے حذف کردیا جاتا ہے ، اور آپ کو پروگرامنگ کے علاوہ کسی بھی چیز کی فکر کرنے کی ضرورت نہیں ہے۔ آپ کو یقین دلایا جائے گا کہ آپ کم از کم ضروری وسائل بروئے کار لا رہے ہیں ، حتی کہ اس کے لئے بھی کوئی منطق پیدا نہیں کیا۔

4. اصل ڈیکوپلنگ۔ آپ نے یہ نظریہ "کاروبار کی منطق سے نظریہ کو الگ کریں" سنا ہوگا۔ یہ ریاستی انتظام کے دیگر حلوں کی کوئی خاصیت نہیں ہے اور مارکیٹ میں کسی دوسرے معیار کا یہ تصور ہے۔ تاہم ، سیاق و سباق کے استعمال کی وجہ سے پھڑپھڑ میں اکثر اس تصور کو کم کیا جاسکتا ہے۔
اگر آپ کو وراثت والے ویجیٹ کو تلاش کرنے کے لئے سیاق و سباق کی ضرورت ہوتی ہے تو ، آپ کو اس کی نظر میں ضرورت ہوگی ، یا پیرامیٹر کے ذریعہ سیاق و سباق کو منتقل کریں۔ مجھے خاص طور پر یہ حل بہت ہی بدصورت معلوم ہوتا ہے ، اور ٹیموں میں کام کرنے کے لئے ہمیں ہمیشہ ویو کی کاروباری منطق پر انحصار کرنا پڑے گا۔ گیٹکس معیاری نقطہ نظر کے ساتھ غیر روایتی ہے ، اور اگرچہ اس میں اسٹیٹ فل وِیجٹس ، انیسٹیٹ وغیرہ کے استعمال پر مکمل پابندی نہیں ہے تو ، اس کا ہمیشہ ایسا ہی نقطہ نظر ہوتا ہے جو صاف ستھرا ہوسکتا ہے۔ کنٹرولرز کے پاس زندگی کا دور رہتا ہے ، اور جب آپ کو مثال کے طور پر درخواست دینے کی ضرورت ہوتی ہے تو ، آپ کو نظر میں کسی چیز پر انحصار نہیں کرنا ہوتا ہے۔ آپ ایچ ٹی ٹی پی کال شروع کرنے کے لئے اونٹ کا استعمال کرسکتے ہیں ، اور جب ڈیٹا آجائے گا تو متغیرات آباد ہوجائیں گے۔ چونکہ گیٹ ایکس مکمل طور پر رد عمل مند ہے (واقعتا، ، اور نہروں کے تحت کام کرتا ہے) ، ایک بار جب سامان بھر جاتا ہے تو ، اس متغیر کو استعمال کرنے والے تمام ویجٹ خود بخود منظر میں اپ ڈیٹ ہوجائیں گے۔ اس سے UI کی مہارت رکھنے والے افراد کو صرف وگیٹس کے ساتھ کام کرنے کا موقع ملتا ہے ، اور صارف کے واقعات (جیسے بٹن پر کلک کرنے کے علاوہ) کے علاوہ کاروباری منطق پر کچھ بھی نہیں بھیجنا پڑتا ہے ، جبکہ کاروباری منطق کے ساتھ کام کرنے والے افراد الگ الگ کاروبار کی منطق کی تخلیق اور جانچ کر سکتے ہیں۔

اس لائبریری کو ہمیشہ اپ ڈیٹ کیا جائے گا اور نئی خصوصیات کو نافذ کیا جائے گا۔ بلا جھجک پی آر پیش کریں اور ان میں اپنا حصہ ڈالیں۔

<a id="readme-section-43"></a>

# سماجی خدمات

<a id="readme-section-44"></a>

## کمیونٹی چینلز

گیٹ ایکس میں انتہائی فعال اور مددگار کمیونٹی ہے۔ اگر آپ کے ذہن میں سوالات ہیں ، یا اس فریم ورک کے استعمال کے سلسلے میں کوئی مدد چاہتے ہیں تو ، براہ کرم ہمارے کمیونٹی چینلز میں شامل ہوں ، آپ کے سوال کا زیادہ جلد جواب دیا جائے گا ، اور یہ سب سے موزوں جگہ ہوگی۔ یہ ذخیر. مسائل کو کھولنے ، اور وسائل کی درخواست کرنے کے لئے خصوصی ہے ، لیکن گیٹ ایکس کمیونٹی کا حصہ بننے میں آزاد محسوس کرتے ہیں۔

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="readme-section-45"></a>

## کس طرح شراکت کریں


منصوبے میں شراکت کرنا چاہتے ہیں؟ ہمیں اپنے ایک ساتھی کی حیثیت سے آپ کو اجاگر کرنے پر فخر ہوگا۔ یہاں کچھ نکات ہیں جہاں آپ اپنا حصہ ڈال سکتے ہیں اور گیٹ (اور پھڑپھڑنا) کو اور بہتر بنا سکتے ہیں۔

- ریڈمی کو دوسری زبانوں میں ترجمہ کرنے میں مدد کرنا۔
- دستاویزات کو ریڈ می میں شامل کرنا (گیٹ کے بہت سارے کام ابھی دستاویزی نہیں ہوئے ہیں)۔
- مضامین لکھیں یا ویڈیوز بنائیں جس کی تعلیم دیتے ہیں کہ گیٹ (ان کو ریڈیم میں اور مستقبل میں ہمارے ویکی میں داخل کیا جائے گا) کو کس طرح استعمال کیا جائے۔
- کوڈ / ٹیسٹ کے لئے پی آر پیش کرنا۔
- نئے افعال سمیت.

کسی بھی شراکت کا خیرمقدم ہے!

<a id="readme-section-46"></a>

## مضامین اور ویڈیوز

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



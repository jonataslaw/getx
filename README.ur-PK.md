![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![popularity](https://img.shields.io/pub/popularity/get?logo=dart)](https://pub.dev/packages/get/score)
[![likes](https://img.shields.io/pub/likes/get?logo=dart)](https://pub.dev/packages/get/score)
[![pub points](https://img.shields.io/pub/points/sentry?logo=dart)](https://pub.dev/packages/get/score)
![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)
[![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)
[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g)
<a href="https://github.com/Solido/awesome-flutter">
<img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" >
</a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)

<div align="center">

**Languages:**

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![Vietnamese](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
[![Indonesian](https://img.shields.io/badge/Language-Indonesian-blueviolet?style=for-the-badge)](README.id-ID.md)
[![Urdu](https://img.shields.io/badge/Language-Urdu-blueviolet?style=for-the-badge)](README.ur-PK.md)
[![Chinese](https://img.shields.io/badge/Language-Chinese-blueviolet?style=for-the-badge)](README.zh-cn.md)
[![Portuguese](https://img.shields.io/badge/Language-Portuguese-blueviolet?style=for-the-badge)](README.pt-br.md)
[![Spanish](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README-es.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blueviolet?style=for-the-badge)](README.ru.md)
[![Polish](https://img.shields.io/badge/Language-Polish-blueviolet?style=for-the-badge)](README.pl.md)
[![Korean](https://img.shields.io/badge/Language-Korean-blueviolet?style=for-the-badge)](README.ko-kr.md)
[![French](https://img.shields.io/badge/Language-French-blueviolet?style=for-the-badge)](README-fr.md)
[![Japanese](https://img.shields.io/badge/Language-Japanese-blueviolet?style=for-the-badge)](README.ja-JP.md)
[![Hindi](https://img.shields.io/badge/Language-Hindi-blueviolet?style=for-the-badge)](README-hi.md)

</div>

- [گیٹ کے بارے میں](#about-get)
- [انسٹال کرنا](#installing)
- [گیٹ ایکس کے ساتھ کاؤنٹر ایپ](#counter-app-with-getx)
- [تین ستون](#the-three-pillars)
  - [حالت کا انتظام](#state-management)
    - [ری ایکٹو حالت مینیجر](#reactive-state-manager)
    - [حالت کے انتظام کے بارے میں مزید تفصیلات](#more-details-about-state-management)
  - [راستہ کا انتظام](#route-management)
    - [راستہ کے انتظام کے بارے میں مزید تفصیلات](#more-details-about-route-management)
  - [تعلق کا انتظام](#dependency-management)
    - [تعلق کے انتظام کے بارے میں مزید تفصیلات](#more-details-about-dependency-management)
- [یوٹلز](#utils)
  - [بین الاقوامیت](#internationalization)
    - [ترجمے](#translations)
      - [ترجموں کا استعمال](#using-translations)
    - [لوکلز](#locales)
      - [لوکل تبدیل کریں](#change-locale)
      - [نظام کی لوکل](#system-locale)
  - [تھیم تبدیل کریں](#change-theme)
  - [گیٹ کنیکٹ](#getconnect)
    - [ڈیفالٹ تشکیل](#default-configuration)
    - [کسٹم تشکیل](#custom-configuration)
  - [گیٹ پیج مڈڈلویئر](#getpage-middleware)
    - [ترجیح](#priority)
    - [ری ڈائریکٹ](#redirect)
    - [آن پیج کالڈ](#onpagecalled)
    - [آن بائنڈنگز اسٹارٹ](#onbindingsstart)
    - [آن پیج بلڈ اسٹارٹ](#onpagebuildstart)
    - [آن پیج بلٹ](#onpagebuilt)
    - [آن پیج ڈسپوز](#onpagedispose)
  - [دیگر ایڈوانسڈ اے پی آئیز](#other-advanced-apis)
    - [اختیاری عالمی تشکیلات اور دستی تشکیلات](#optional-global-settings-and-manual-configurations)
    - [مقامی حالت ویجٹس](#local-state-widgets)
      - [ویلیو بلڈر](#valuebuilder)
      - [اوبیکس ویلیو](#obxvalue)
  - [مفید نکتے](#useful-tips)
    - [گیٹ ویو](#getview)
    - [گیٹ ری اسپانسو ویو](#getresponsiveview)
      - [اس کا استعمال کیسے کریں](#how-to-use-it)
    - [گیٹ ویجٹ](#getwidget)
    - [گیٹ ایکس سروس](#getxservice)
- [2.0 سے توڑنے والی تبدیلیاں](#breaking-changes-from-20)
- [گیٹ ایکس کیوں؟](#why-getx)
- [کمیونٹی](#community)
  - [کمیونٹی چینلز](#community-channels)
  - [کس طرح شراکت کریں](#how-to-contribute)
  - [مضامین اور ویڈیوز](#articles-and-videos)

# About Get
### گیٹ کے بارے میں

- GetX فلٹر کے لئے ایک اضافی ہلکا اور طاقتور حل ہے۔ یہ اعلی درجے کی حالت کا انتظام، ہوشیار تعلق کا انجیکشن، اور راستہ کا انتظام فوراً اور عملی طریقے سے ملا دیتا ہے۔

- GetX کے 3 بنیادی اصول ہیں۔ اس کا مطلب ہے کہ یہ لائبریری میں تمام وسائل کی ترجیح ہیں: **پراڈکٹوٹی, پرفارمنس اور آرگنائزیشن۔**

  - **پرفارمنس:** GetX کا مرکز پرفارمنس اور وسائل کی کم سے کم صرفیہ پر ہے۔ GetX اسٹریمز یا چینج نوٹیفائر کا استعمال نہیں کرتا۔

  - **پراڈکٹوٹی:** GetX ایک آسان اور خوشگوار سنٹیکس کا استعمال کرتا ہے۔ کوئی فرق نہیں پڑتا کہ آپ کیا کرنا چاہتے ہیں، GetX کے ساتھ ہمیشہ ایک آسان طریقہ ہوتا ہے۔ یہ توسیع کی گھنٹوں کی بچت کرے گا اور آپ کی ایپلیکیشن کا زیادہ سے زیادہ پرفارمنس فراہم کرے گا۔

    عموماً، ڈویلپر کو کنٹرولرز کو میموری سے ہٹانے کی فکر ہوتی ہے۔ GetX کے ساتھ یہ ضروری نہیں ہے کیونکہ جب وہ طے شدہ طور پر استعمال نہیں ہوتے تو وسائل میموری سے ہٹا دیے جاتے ہیں۔ اگر آپ اسے میموری میں رکھنا چاہتے ہیں تو آپ کو اپنے تعلق میں "ہمیشہ: سچ" کا اظہار کرنا ہوگا۔ اس طرح، وقت بچانے کے علاوہ، آپ میموری پر غیر ضروری تعلقات کا کم سے کم خطرہ ہے۔ تعلق کی لوڈنگ بھی طے شدہ طور پر سست ہے۔

  - **آرگنائزیشن:** GetX دیکھنے، پیش کرنے کی منطق، کاروبار کی منطق، تعلق کا انجیکشن، اور نیویگیشن کی مکمل علیحدگی کی اجازت دیتا ہے۔ آپ کو راستوں کے درمیان نیویگیٹ کرنے کے لئے کانٹیکسٹ کی ضرورت نہیں ہے، تو آپ اس کے لئے ویجٹ ٹری (ویژوالائزیشن) پر معتمد نہیں ہیں۔ آپ کو اپنے کنٹرولرز/بلوکس کو ایک انہیرٹڈ ویجٹ کے ذریعے تک پہنچنے کے لئے کانٹیکسٹ کی ضرورت نہیں ہے، تو آپ اپنی پیش کرنے کی منطق اور کاروبار کی منطق کو اپنے ویژوالائزیشن لیئر سے مکمل طور پر علیحدہ کرتے ہیں۔ آپ کو اپنے کنٹرولرز/ماڈلز/بلوک کلاسز کو `ملٹی پرووائیڈر` کے ذریعے اپنے ویجٹ ٹری میں انجیکٹ کرنے کی ضرورت نہیں ہے۔ اس کے لئے، GetX اپنی تعلق کا انجیکشن فیچر کا استعمال کرتا ہے، DI کو اس کے دیدھ سے مکمل طور پر علیحدہ کرتا ہے۔

    GetX کے ساتھ آپ جانتے ہیں کہ آپ کی ایپلیکیشن کی ہر خصوصیت کہاں ملتی ہے، طے شدہ طور پر صاف کوڈ ہوتا ہے۔ دیکھ بھال کو آسان بنانے کے علاوہ، یہ ماڈیولز کی شیئرنگ کو کچھ ایسا بناتا ہے جو فلٹر میں اب تک سوچنا ناممکن تھا، کچھ مکمل طور پر ممکن ہے۔
    BLoC فلٹر میں کوڈ کو منظم کرنے کا ایک آغاز تھا، یہ کاروبار کی منطق کو ویژوالائزیشن سے علیحدہ کرتا ہے۔ GetX اس کا قدرتی ارتقا ہے، نہ صرف کاروبار کی منطق کو علیحدہ کرتا ہے بلکہ پیش کرنے کی منطق۔ بونس تعلقات کا انجیکشن اور راستے بھی علیحدہ ہیں، اور ڈیٹا کا ورق اس سب میں سے باہر ہے۔ آپ جانتے ہیں کہ ہر چیز کہاں ہے، اور یہ سب ایک ہیلو ورلڈ بنانے سے زیادہ آسان طریقے سے۔
    GetX فلٹر ایس ڈی کے ساتھ اعلی درجے کی ایپلیکیشن بنانے کا سب سے آسان، عملی، اور قابل مقیاس طریقہ ہے۔ اس کے ارد گرد ایک بڑا ایکو سسٹم ہے جو کام کرتا ہے، یہ شروعات کے لئے آسان ہے، اور یہ ماہرین کے لئے درست ہے۔ یہ محفوظ، مستقل، تازہ ترین ہے، اور فلٹر ایس ڈی کے ڈیفالٹ میں موجود نہیں ہونے والی ایک بڑی سیریز آف اے پی آئیز فراہم کرتا ہے۔

- GetX پھولا ہوا نہیں ہے۔ اس میں ایک مختلف فیچرز کی بڑی تعداد ہے جو آپ کو کچھ بھی چنتا کیے بغیر پروگرامنگ شروع کرنے کی اجازت دیتی ہیں، لیکن ہر ایک فیچر علیحدہ کنٹینرز میں ہے اور صرف استعمال کے بعد شروع ہوتے ہیں۔ اگر آپ صرف حالت کا انتظام استعمال کرتے ہیں تو صرف حالت کا انتظام ترتیب دیا جائے گا۔ اگر آپ صرف راستے استعمال کرتے ہیں تو حالت کے انتظام سے کچھ بھی نہیں کیا جائے گا۔

- GetX کا ایک بڑا ایکو سسٹم ہے، ایک بڑی کمیونٹی، بڑی تعداد میں شراکت دار، اور جب تک فلٹر موجود ہے تب تک دیکھ بھال کی جائے گی۔ GetX بھی ایک ہی کوڈ پر اینڈرائیڈ، آئی او ایس، ویب، میک، لنکس، ونڈوز، اور آپ کے سرور پر چلنے کے قابل ہے۔
  **[گیٹ سرور](https://github.com/jonataslaw/get_server) کے ساتھ آپ کے فرنٹ اینڈ پر بنایا گیا کوڈ کو آپ کے بیک اینڈ پر مکمل طور پر دوبارہ استعمال کرنا ممکن ہے۔**

**اس کے علاوہ، تمام تر ترقی کا عمل مکمل طور پر خودکار کیا جا سکتا ہے، سرور اور فرنٹ اینڈ دونوں پر [گیٹ CLI](https://github.com/jonataslaw/get_cli) کے ساتھ۔**

**اس کے علاوہ، آپ کی پراڈکٹوٹی کو مزید بڑھانے کے لئے ہمارے پاس
[VSCode کے لئے ایکسٹینشن](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) اور [Android Studio/Intellij کے لئے ایکسٹینشن](https://plugins.jetbrains.com/plugin/14975-getx-snippets) ہے۔**

# Installing
### انسٹالیشن

اپنی `pubspec.yaml` فائل میں Get شامل کریں:

```yaml
dependencies:
  get:
```

جو فائلیں استعمال ہوںگی، ان میں get درآمد کریں:
```dart
import 'package:get/get.dart';
```

# Counter App with GetX
### گیٹ ایکس کے ساتھ کاؤنٹر ایپ

فلٹر پر نیا پروجیکٹ بناتے وقت ڈیفالٹ طور پر بنایا گیا "کاؤنٹر" پروجیکٹ 100 سے زائد لائنز کا ہوتا ہے (کمینٹس کے ساتھ)۔ گیٹ کی طاقت دکھانے کے لئے، میں یہ دکھاؤں گا کہ کس طرح "کاؤنٹر" بنایا جا سکتا ہے، ہر کلک کے ساتھ حالت کو تبدیل کرتا ہے، صفحوں کے درمیان سوئچ کرتا ہے اور اسکرینز کے درمیان حالت کا اشتراک کرتا ہے، سب کچھ ایک منظم طریقے سے، کاروبار کی منطق کو دیدھ سے علیحدہ کرتا ہے، صرف 26 لائن کوڈ میں، جس میں کمینٹس شامل ہیں۔

- قدم 1:
  اپنے MaterialApp کے پہلے "گیٹ" شامل کریں، اسے GetMaterialApp میں تبدیل کریں۔

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

 نوٹ: یہ فلٹر کا MaterialApp ترتیب نہیں دیتا، GetMaterialApp ایک ترتیب شدہ ویجٹ ہے، جو ڈیفالٹ MaterialApp کو ایک بچہ بناتا ہے۔ آپ اسے دستی طور پر ترتیب دے سکتے ہیں، لیکن یہ ضرور نہیں ہے۔ GetMaterialApp روٹس بنائے گا، انہیں انجیکٹ کرے گا، ترجمے انجیکٹ کرے گا، روٹ نیویگیشن کے لئے آپ کو ضرورت ہونے والی ہر چیز کو انجیکٹ کرے گا۔ اگر آپ صرف حالت کا انتظام یا تعلق کا انتظام کے لئے گیٹ کا استعمال کرتے ہیں تو GetMaterialApp کا استعمال کرنا ضروری نہیں ہے۔ GetMaterialApp روٹس، سنیکبارز، بین الاقوامیت، بوٹمشیٹس، ڈائلاگز، اور روٹس اور متعلقہ کا عدم استعمال کرنے والی اعلی درجہ کی اے پی آئیز کے لئے ضروری ہے۔


 نوٹ²: یہ قدم صرف اس وقت ضروری ہے جب آپ روٹ کا انتظام استعمال کریں گے (Get.to(), Get.back() وغیرہ)۔ اگر آپ اس کا استعمال نہیں کریں گے تو قدم 1 کرنا ضروری نہیں ہے۔


- قدم 2:
اپنی کاروبار کی منطق کی کلاس بنائیں اور اس میں تمام متغیرات، طریقے اور کنٹرولرز کو رکھیں۔
آپ کسی بھی متغیر کو ایک سادہ ".obs" کا استعمال کرکے مشاہدہ کر سکتے ہیں۔

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- قدم 3:
اپنا ویو بنائیں، StatelessWidget کا استعمال کریں اور کچھ ریم بچائیں، گیٹ کے ساتھ آپ کو StatefulWidget کا استعمال کرنے کی ضرورت نہیں ہوگی۔
```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Use Get.put() to make your class available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
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
- نتیجہ:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

یہ ایک سادہ پروجیکٹ ہے لیکن یہ پہلے ہی واضح کر دیتا ہے کہ گیٹ کتنی طاقتور ہے۔ جیسے جیسے آپ کا پروجیکٹ بڑھتا جاتا ہے، یہ فرق اور بھی اہم ہوتا جاتا ہے۔

گیٹ کو ٹیموں کے ساتھ کام کرنے کے لئے ڈیزائن کیا گیا تھا، لیکن یہ ایک انفرادی ڈویلپر کا کام بھی آسان بناتا ہے۔

اپنی میعادوں میں بہتری کریں، ہر چیز کو وقت پر فراہم کریں بغیر کہ کارگزاری کھوئے۔ گیٹ ہر کسی کے لئے نہیں ہے، لیکن اگر آپ اس جملے کے ساتھ شناخت کرتے ہیں تو گیٹ آپ کے لئے ہے!


# The Three pillars
### تین ستون

## State management
### حالت کا انتظام

گیٹ کے پاس دو مختلف حالت منیجر ہیں: سادہ حالت منیجر (ہم اسے GetBuilder کہیں گے) اور رد عکسی حالت منیجر (GetX/Obx)

### Reactive State Manager

### رد عکسی حالت منیجر

رد عکسی پروگرامنگ بہت سارے لوگوں کو بے جا کر سکتی ہے کیونکہ کہا جاتا ہے کہ یہ پیچیدہ ہے۔ گیٹ رد عکسی پروگرامنگ کو کچھ کاфی سادہ بنا دیتا ہے:

- آپ کو StreamControllers بنانے کی ضرورت نہیں ہوگی۔
- آپ کو ہر متغیر کے لئے ایک StreamBuilder بنانے کی ضرورت نہیں ہوگی۔
- آپ کو ہر حالت کے لئے ایک کلاس بنانے کی ضرورت نہیں ہوگی۔
- آپ کو ایک ابتدائی قیمت کے لئے گیٹ بنانے کی ضرورت نہیں ہوگی۔
- آپ کو کوڈ جنریٹرز کا استعمال کرنے کی ضرورت نہیں ہوگی۔

گیٹ کے ساتھ رد عکسی پروگرامنگ کرنا setState کا استعمال کرنا اتنا ہی آسان ہے۔

چلیے تصور کرتے ہیں کہ آپ کے پاس ایک نام کا متغیر ہے اور چاہتے ہیں کہ ہر دفعہ جب آپ اسے تبدیل کریں، تمام ویجٹ جو اسے استعمال کرتے ہیں خود بخود تبدیل ہو جائیں۔

یہ آپ کا گننے کا متغیر ہے:

```dart
var name = 'Usama Sarwar';
```
اسے مشاہدہ کے قابل بنانے کے لئے، آپ کو بس اس کے آخر میں ".obs" شامل کرنے کی ضرورت ہے:

```dart
var name = 'Usama Sarwar'.obs;
```

اور UI میں، جب آپ اس قیمت کو دکھانا چاہتے ہیں اور جب بھی قیمتیں تبدیل ہوتی ہیں تو اسکرین کو اپ ڈیٹ کرنا چاہتے ہیں، بس یہ کریں:

```dart
Obx(() => Text("${controller.name}"));
```

بس یہی سب ہے۔ یہ _اس_ حد تک سادہ ہے۔

### More details about state management
### حالت کے انتظام کے بارے میں مزید تفصیلات

**حالت کے انتظام کی زیادہ گہرائی تک وضاحت [یہاں](./documentation/en_US/state_management.md) دیکھیں۔ وہاں آپ کو مزید مثالیں دیکھنے کو ملیں گی اور سادہ حالت منیجر اور رد عکسی حالت منیجر کے درمیان کا فرق بھی دیکھائیں گے۔**

آپ کو GetX کی طاقت کا اچھا خیال ملے گا۔

## Route management
## راستہ کا انتظام

اگر آپ کنٹیکسٹ کے بغیر روٹس/سنیکبارز/ڈائلاگز/بوٹم شیٹس کا استعمال کرنے والے ہیں، تو GetX آپ کے لئے بھی شاندار ہے، بس اسے دیکھیں:

اپنے MaterialApp سے پہلے "Get" شامل کریں، اسے GetMaterialApp میں تبدیل کریں

```dart
GetMaterialApp( // سے پہلے MaterialApp(
  home: MyHome(),
)
```
نئی اسکرین پر نیویگیٹ کریں:

```dart
Get.to(NextScreen());
```

نام کے ساتھ نئی اسکرین پر نیویگیٹ کریں۔ نامزد روٹس پر مزید تفصیلات [یہاں](./documentation/en_US/route_management.md#navigation-with-named-routes) دیکھیں۔


```dart

Get.toNamed('/details');
```

سنیکبارز، ڈائلاگز، بوٹم شیٹس کو بند کرنے کے لئے، یا کچھ بھی جو آپ عموماً Navigator.pop(context); کے ساتھ بند کریں گے۔


```dart
Get.back();
```

اگلی اسکرین پر جانے اور پچھلی اسکرین پر واپس جانے کا کوئی اختیار نہیں (SplashScreens، لاگ ان اسکرینز وغیرہ کے استعمال کے لئے۔)


```dart
Get.off(NextScreen());
```

اگلی اسکرین پر جائیں اور سب پچھلے روٹس کو منسوخ کریں (خریداری کی ٹوکریوں، سروے اور ٹیسٹس میں مفید ہے)


```dart
Get.offAll(NextScreen());
```
کیا آپ نے نوٹ کیا کہ آپ کو ان سب چیزوں کو کرنے کے لئے کنٹیکسٹ کا استعمال کرنے کی ضرورت نہیں تھی؟ یہ گیٹ کے روٹ منیجمنٹ کا استعمال کرنے کی بڑی فائدہ مندیوں میں سے ایک ہے۔ اس کے ساتھ، آپ اپنی کنٹرولر کلاس کے اندر سے یہ سب طریقے انجام دے سکتے ہیں، بغیر فکر کے۔

### More details about route management
### روٹ منیجمنٹ کے بارے میں مزید تفصیلات

**گیٹ نامزد روٹس کے ساتھ کام کرتا ہے اور آپ کے روٹس پر ادنی سطح پر کنٹرول فراہم کرتا ہے! [یہاں](./documentation/en_US/route_management.md) گہرائی تک دستاویزات ہے۔**

## Dependency management
## ڈپینڈنسی منیجمنٹ

گیٹ کا ایک سادہ اور طاقتور ڈپینڈنسی منیجر ہے جو آپ کو صرف 1 لائن کے کوڈ کے ساتھ اپنے Bloc یا کنٹرولر کی طرح کی کلاس حاصل کرنے کی اجازت دیتا ہے، کوئی فراہم کنندہ کنٹیکسٹ نہیں، کوئی inheritedWidget نہیں:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```
- نوٹ: اگر آپ گیٹ کے اسٹیٹ منیجر کا استعمال کر رہے ہیں، تو بائنڈنگز API پر زیادہ توجہ دیں، جو آپ کو اپنے ویو کو اپنے کنٹرولر سے جوڑنے میں آسانی فراہم کرے گی۔

آپ کے اسٹنس کو آپ کے کلاس کے اندر انسٹیٹیٹ کرنے کی بجائے، آپ اسے گیٹ کے انسٹینس کے اندر انسٹیٹیٹ کر رہے ہیں، جو اسے آپ کے ایپ کے عرض میں دستیاب کرے گا۔
تو آپ اپنے کنٹرولر (یا کلاس Bloc) کو عام طور پر استعمال کر سکتے ہیں۔

**ٹپ:** گیٹ کا ڈپینڈنسی منیجمنٹ پیکیج کے دوسرے حصوں سے الگ ہے، تو اگر مثلاً، آپ کا ایپ پہلے ہی کسی اسٹیٹ منیجر کا استعمال کر رہا ہے (کوئی بھی، یہ ماینہ نہیں رکھتا)، تو آپ کو یہ سب کچھ دوبارہ لکھنے کی ضرورت نہیں ہے، آپ اس ڈپینڈنسی انجیکشن کو بلا کسی مشکل کے استعمال کر سکتے ہیں۔

```dart
controller.fetchApi();
```

تصور کریں کہ آپ نے مختلف روٹس سے گزرا ہے، اور آپ کو اپنے کنٹرولر میں پیچھے چھوڑے گئے ڈیٹا کی ضرورت ہے، آپ کو پروائیڈر یا Get_it کے ساتھ ملا ہوا ایک اسٹیٹ منیجر کی ضرورت ہوگی، صحیح؟ گیٹ کے ساتھ نہیں۔ آپ کو صرف گیٹ سے اپنے کنٹرولر کے لئے "تلاش" کرنے کی ضرورت ہے، آپ کو کوئی اضافی ڈپینڈنسیوں کی ضرورت نہیں ہے:

```dart
Controller controller = Get.find();
// ہاں، یہ جادو کی طرح لگتا ہے، گیٹ آپ کا کنٹرولر تلاش کرے گا، اور آپ کو دے دے گا۔ آپ کے پاس 1 ملین کنٹرولرز کا انسٹینشیشن ہو سکتا ہے، گیٹ ہمیشہ آپ کو صحیح کنٹرولر فراہم کرے گا۔
```

اور پھر آپ وہاں پر حاصل کئے گئے اپنے کنٹرولر کے ڈیٹا کو دوبارہ حاصل کر پائیں گے:


```dart
Text(controller.textFromApi);
```

### More details about dependency management
### ڈپینڈنسی منیجمنٹ کے بارے میں مزید تفصیلات

**ڈپینڈنسی منیجمنٹ کی مزید گہرائی میں وضاحت [یہاں](./documentation/en_US/dependency_management.md) دیکھیں**

# Utils

## Internationalization

### Translations

Translations are kept as a simple key-value dictionary map.
To add custom translations, create a class and extend `Translations`.

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

#### Using translations

Just append `.tr` to the specified key and it will be translated, using the current value of `Get.locale` and `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Using translation with singular and plural

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Using translation with parameters

```dart
import 'package:get/get.dart';


Map<String, Map<String, String>> get keys => {
    'en_US': {
        'logged_in': 'logged in as @name with email @email',
    },
    'es_ES': {
       'logged_in': 'iniciado sesión como @name con e-mail @email',
    }
};

Text('logged_in'.trParams({
  'name': 'Jhon',
  'email': 'jhon@example.com'
  }));
```

### Locales

Pass parameters to `GetMaterialApp` to define the locale and translations.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### Change locale

Call `Get.updateLocale(locale)` to update the locale. Translations then automatically use the new locale.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### System locale

To read the system locale, you could use `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Change Theme

Please do not use any higher level widget than `GetMaterialApp` in order to update it. This can trigger duplicate keys. A lot of people are used to the prehistoric approach of creating a "ThemeProvider" widget just to change the theme of your app, and this is definitely NOT necessary with **GetX™**.

You can create your custom theme and simply add it within `Get.changeTheme` without any boilerplate for that:

```dart
Get.changeTheme(ThemeData.light());
```

If you want to create something like a button that changes the Theme in `onTap`, you can combine two **GetX™** APIs for that:

- The api that checks if the dark `Theme` is being used.
- And the `Theme` Change API, you can just put this within an `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

When `.darkmode` is activated, it will switch to the _light theme_, and when the _light theme_ becomes active, it will change to _dark theme_.

## GetConnect

GetConnect is an easy way to communicate from your back to your front with http or websockets

### Default configuration

You can simply extend GetConnect and use the GET/POST/PUT/DELETE/SOCKET methods to communicate with your Rest API or websockets.

```dart
class UserProvider extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // Post request with File
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

### Custom configuration

GetConnect is highly customizable You can define base Url, as answer modifiers, as Requests modifiers, define an authenticator, and even the number of attempts in which it will try to authenticate itself, in addition to giving the possibility to define a standard decoder that will transform all your requests into your Models without any additional configuration.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // It define baseUrl to
    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Even if the server sends data from the country "Brazil",
    // it will never be displayed to users, because you remove
    // that data from the response, even before the response is delivered
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Set the header
      request.headers['Authorization'] = "$token";
      return request;
    });

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

The GetPage has now new property that takes a list of GetMiddleWare and run them in the specific order.

**Note**: When GetPage has a Middlewares, all the children of this page will have the same middlewares automatically.

### Priority

The Order of the Middlewares to run can be set by the priority in the GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

those middlewares will be run in this order **-8 => 2 => 4 => 5**

### Redirect

This function will be called when the page of the called route is being searched for. It takes RouteSettings as a result to redirect to. Or give it null and there will be no redirecting.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

This function will be called right before the Bindings are initialize.
Here you can change Bindings for this page.

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

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

### OnPageDispose

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

## Other Advanced APIs

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
Get.removeRoute()

// back repeatedly until the predicate returns true.
Get.until()

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil()

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil()

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
Get.contextOverlay

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

/// Similar to MediaQuery.sizeOf(context);
context.mediaQuerySize()

/// Similar to MediaQuery.paddingOf(context);
context.mediaQueryPadding()

/// Similar to MediaQuery.viewPaddingOf(context);
context.mediaQueryViewPadding()

/// Similar to MediaQuery.viewInsetsOf(context);
context.mediaQueryViewInsets()

/// Similar to MediaQuery.orientationOf(context);
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.devicePixelRatioOf(context);
context.devicePixelRatio()

/// Similar to MediaQuery.textScaleFactorOf(context);
context.textScaleFactor()

/// Get the shortestSide from screen
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// True if the shortestSide is smaller than 600p
context.isPhone()

/// True if the shortestSide is largest than 600p
context.isSmallTablet()

/// True if the shortestSide is largest than 720p
context.isLargeTablet()

/// True if the current device is Tablet
context.isTablet()

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

### Optional Global Settings and Manual configurations

GetMaterialApp configures everything for you, but if you want to configure Get manually.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

You will also be able to use your own Middleware within `GetObserver`, this will not influence anything.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

You can create _Global Settings_ for `Get`. Just add `Get.config` to your code before pushing any route.
Or do it directly in your `GetMaterialApp`

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

You can optionally redirect all the logging messages from `Get`.
If you want to use your own, favourite logging package,
and want to capture the logs there:

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

### Local State Widgets

These Widgets allows you to manage a single value, and keep the state ephemeral and locally.
We have flavours for Reactive and Simple.
For instance, you might use them to toggle obscureText in a `TextField`, maybe create a custom
Expandable Panel, or maybe modify the current index in `BottomNavigationBar` while changing the content
of the body in a `Scaffold`.

#### ValueBuilder

A simplification of `StatefulWidget` that works with a `.setState` callback that takes the updated value.

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

#### ObxValue

Similar to [`ValueBuilder`](#valuebuilder), but this is the Reactive version, you pass a Rx instance (remember the magical .obs?) and
updates automatically... isn't it awesome?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Useful tips

`.obs`ervables (also known as _Rx_ Types) have a wide variety of internal methods and operators.

> Is very common to _believe_ that a property with `.obs` **IS** the actual value... but make no mistake!
> We avoid the Type declaration of the variable, because Dart's compiler is smart enough, and the code
> looks cleaner, but:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Even if `message` _prints_ the actual String value, the Type is **RxString**!

So, you can't do `message.substring( 0, 4 )`.
You have to access the real `value` inside the _observable_:
The most "used way" is `.value`, but, did you know that you can also use...

```dart
final name = 'GetX'.obs;
// only "updates" the stream, if the value is different from the current one.
name.value = 'Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name('Hello');

// is like a getter, prints 'Hello'.
name() ;

/// numbers:

final count = 0.obs;

// You can use all non mutable operations from num primitives!
count + 1;

// Watch out! this is only valid if `count` is not final, but var
count += 1;

// You can also compare against values:
count > 2;

/// booleans:

final flag = false.obs;

// switches the value between true/false
flag.toggle();


/// all types:

// Sets the `value` to null.
flag.nil();

// All toString(), toJson() operations are passed down to the `value`
print( count ); // calls `toString()` inside  for RxInt

final abc = [0,1,2].obs;
// Converts the value to a json Array, prints RxList
// Json is supported by all Rx types!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList and RxSet are special Rx types, that extends their native types.
// but you can work with a List as a regular list, although is reactive!
abc.add(12); // pushes 12 to the list, and UPDATES the stream.
abc[3]; // like Lists, reads the index 3.


// equality works with the Rx and the value, but hashCode is always taken from the value
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() are deferred to the child, so you can implement override on them, and print() the observable directly.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Roi';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```
## StateMixin

Another way to handle your `UI` state is use the `StateMixin<T>` .
To implement it, use the `with` to add the `StateMixin<T>`
to your controller which allows a T model.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(data, status: RxStatus.success());
```

RxStatus allow these status:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

To represent it in the UI, use:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

I love this Widget, is so simple, yet, so useful!

Is a `const Stateless` Widget that has a getter `controller` for a registered `Controller`, that's all.

```dart
 class AwesomeController extends GetController {
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

#### GetResponsiveView

Extend this widget to build responsive view.
this widget contains the `screen` property that have all
information about the screen size and type.

##### How to use it

You have two options to build it.

- with `builder` method you return the widget to build.
- with methods `desktop`, `tablet`,`phone`, `watch`. the specific
  method will be built when the screen type matches the method
  when the screen is [ScreenType.Tablet] the `tablet` method
  will be exuded and so on.
  **Note:** If you use this method please set the property `alwaysUseBuilder` to `false`

With `settings` property you can set the width limit for the screen types.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Most people have no idea about this Widget, or totally confuse the usage of it.
The use case is very rare, but very specific: It `caches` a Controller.
Because of the _cache_, can't be a `const Stateless`.

> So, when do you need to "cache" a Controller?

If you use, another "not so common" feature of **GetX**: `Get.create()`.

`Get.create(()=>Controller())` will generate a new `Controller` each time you call
`Get.find<Controller>()`,

That's where `GetWidget` shines... as you can use it, for example,
to keep a list of Todo items. So, if the widget gets "rebuilt", it will keep the same controller instance.

#### GetxService

This class is like a `GetxController`, it shares the same lifecycle ( `onInit()`, `onReady()`, `onClose()`).
But has no "logic" inside of it. It just notifies **GetX** Dependency Injection system, that this subclass
**can not** be removed from memory.

So is super useful to keep your "Services" always reachable and active with `Get.find()`. Like:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Is a smart move to make your Services intiialize before you run the Flutter app.
/// as you can control the execution flow (maybe you need to load some Theme configuration,
/// apiKey, language defined by the User... so load SettingService before running ApiService.
/// so GetMaterialApp() doesnt have to rebuild, and takes the values directly.
void initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
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


### Tests

You can test your controllers like any other class, including their lifecycles:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Change value to name2
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
    /// You can test the controller without the lifecycle,
    /// but it's not recommended unless you're not using
    ///  GetX dependency injection
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// If you are using it, you can test everything,
    /// including the state of the application after each lifecycle.
    Get.put(controller); // onInit was called
    expect(controller.name.value, 'name2');

    /// Test your functions
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose was called
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### Tips

##### Mockito or mocktail
If you need to mock your GetxController/GetxService, you should extend GetxController, and mixin it with Mock, that way

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Using Get.reset()
If you are testing widgets, or test groups, use Get.reset at the end of your test or in tearDown to reset all settings from your previous test.

##### Get.testMode 
if you are using your navigation in your controllers, use `Get.testMode = true` at the beginning of your main.


# Breaking changes from 2.0

1- Rx types:

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController and GetBuilder now have merged, you no longer need to memorize which controller you want to use, just use GetxController, it will work for simple state management and for reactive as well.

2- NamedRoutes
Before:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

Now:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

Why this change?
Often, it may be necessary to decide which page will be displayed from a parameter, or a login token, the previous approach was inflexible, as it did not allow this.
Inserting the page into a function has significantly reduced the RAM consumption, since the routes will not be allocated in memory since the app was started, and it also allowed to do this type of approach:

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

# Why Getx?

1- Many times after a Flutter update, many of your packages will break. Sometimes compilation errors happen, errors often appear that there are still no answers about, and the developer needs to know where the error came from, track the error, only then try to open an issue in the corresponding repository, and see its problem solved. Get centralizes the main resources for development (State, dependency and route management), allowing you to add a single package to your pubspec, and start working. After a Flutter update, the only thing you need to do is update the Get dependency, and get to work. Get also resolves compatibility issues. How many times a version of a package is not compatible with the version of another, because one uses a dependency in one version, and the other in another version? This is also not a concern using Get, as everything is in the same package and is fully compatible.

2- Flutter is easy, Flutter is incredible, but Flutter still has some boilerplate that may be unwanted for most developers, such as `Navigator.of(context).push (context, builder [...]`. Get simplifies development. Instead of writing 8 lines of code to just call a route, you can just do it: `Get.to(Home())` and you're done, you'll go to the next page. Dynamic web urls are a really painful thing to do with Flutter currently, and that with GetX is stupidly simple. Managing states in Flutter, and managing dependencies is also something that generates a lot of discussion, as there are hundreds of patterns in the pub. But there is nothing as easy as adding a ".obs" at the end of your variable, and place your widget inside an Obx, and that's it, all updates to that variable will be automatically updated on the screen.

3- Ease without worrying about performance. Flutter's performance is already amazing, but imagine that you use a state manager, and a locator to distribute your blocs/stores/controllers/ etc. classes. You will have to manually call the exclusion of that dependency when you don't need it. But have you ever thought of simply using your controller, and when it was no longer being used by anyone, it would simply be deleted from memory? That's what GetX does. With SmartManagement, everything that is not being used is deleted from memory, and you shouldn't have to worry about anything but programming. You will be assured that you are consuming the minimum necessary resources, without even having created a logic for this.

4- Actual decoupling. You may have heard the concept "separate the view from the business logic". This is not a peculiarity of BLoC, MVC, MVVM, and any other standard on the market has this concept. However, this concept can often be mitigated in Flutter due to the use of context.
If you need context to find an InheritedWidget, you need it in the view, or pass the context by parameter. I particularly find this solution very ugly, and to work in teams we will always have a dependence on View's business logic. Getx is unorthodox with the standard approach, and while it does not completely ban the use of StatefulWidgets, InitState, etc., it always has a similar approach that can be cleaner. Controllers have life cycles, and when you need to make an APIREST request for example, you don't depend on anything in the view. You can use onInit to initiate the http call, and when the data arrives, the variables will be populated. As GetX is fully reactive (really, and works under streams), once the items are filled, all widgets that use that variable will be automatically updated in the view. This allows people with UI expertise to work only with widgets, and not have to send anything to business logic other than user events (like clicking a button), while people working with business logic will be free to create and test the business logic separately.

This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

# Community

## Community channels

GetX has a highly active and helpful community. If you have questions, or would like any assistance regarding the use of this framework, please join our community channels, your question will be answered more quickly, and it will be the most suitable place. This repository is exclusive for opening issues, and requesting resources, but feel free to be part of GetX Community.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## How to contribute

_Want to contribute to the project? We will be proud to highlight you as one of our collaborators. Here are some points where you can contribute and make Get (and Flutter) even better._

- Helping to translate the readme into other languages.
- Adding documentation to the readme (a lot of Get's functions haven't been documented yet).
- Write articles or make videos teaching how to use Get (they will be inserted in the Readme and in the future in our Wiki).
- Offering PRs for code/tests.
- Including new functions.

Any contribution is welcome!

## Articles and videos

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

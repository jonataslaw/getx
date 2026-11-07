> GetX 5 RC: এই candidate এখনো প্রকাশিত নয়। পরীক্ষিত ভিত্তি Flutter 3.47.9 ও Dart 3.13.7; Flutter-এর অন্তর্ভুক্ত UI লাইব্রেরি ব্যবহার করা হয়।

[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)

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
<a href="https://www.buymeacoffee.com/jonataslaw" target="_blank"><img src="https://i.imgur.com/aV6DDA7.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/getx.png)


## সূচিপত্র

  - [এই শাখায় GetX 5-এর পরিবর্তন](#getx5-current)
- [Get সম্পর্কে](#readme-section-2)
- [ইনস্টল](#readme-section-3)
- [GetX দিয়ে কাউন্টার অ্যাপ](#readme-section-4)
- [GetX এর তিনটি স্তম্ভ](#readme-section-5)
  - [স্টেট ব্যবস্থাপনা](#readme-section-6)
    - [প্রতিক্রিয়াশীল স্টেট ম্যানেজার](#readme-section-7)
    - [স্টেট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#readme-section-8)
  - [রুট ব্যবস্থাপনা](#readme-section-9)
    - [রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#readme-section-10)
  - [ডিপেনডেন্সি ব্যবস্থাপনা](#readme-section-11)
    - [ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#readme-section-12)
- [ইউটিলিটি](#readme-section-13)
  - [আন্তর্জাতিকীকরণ](#readme-section-14)
    - [অনুবাদ](#readme-section-15)
    - [অনুবাদের ব্যবহার](#readme-section-16)
    - [একবচন এবং বহুবচন সহ অনুবাদ ব্যবহার](#readme-section-17)
    - [প্যারামিটার সহ অনুবাদ ব্যবহার](#readme-section-18)
    - [লোকেল](#readme-section-19)
    - [লোকেল পরিবর্তন করুন](#readme-section-20)
    - [লোকেল পদ্ধতি](#readme-section-21)
  - [থিম পরিবর্তন করুন](#readme-section-22)
  - [গেট কানেক্ট (GetConnect)](#readme-section-23)
    - [ডিফল্ট কনফিগারেশন](#readme-section-24)
    - [কাস্টম কনফিগারেশন](#readme-section-25)
  - [গেট পেজ মিডিলওয়্যার](#readme-section-26)
    - [অগ্রাধিকার (Priority)](#readme-section-27)
    - [পুনঃনির্দেশ (Redirect)](#readme-section-28)
    - [অন-পেজ কলড (onPageCalled)](#readme-section-29)
    - [অন-বাইন্ডিং স্টার্ট (OnBindingsStart)](#readme-section-30)
    - [অন-পেজ বিল্ড স্টার্ট (OnPageBuildStart)](#readme-section-31)
    - [অন-পেজ বিল্ড (OnPageBuilt)](#readme-section-32)
    - [অন-পেজ ডিসপোজ (OnPageDispose)](#readme-section-33)
  - [অন্যান্য এপিআই সমূহ](#readme-section-34)
    - [ঐচ্ছিক গ্লোবাল সেটিংস এবং ম্যানুয়াল কনফিগারেশন](#readme-section-35)
    - [লোকাল স্টেট উইজেট](#readme-section-36)
    - [ভ্যালু বিল্ডার (ValueBuilder)](#readme-section-37)
    - [অবএক্সভ্যালু (ObxValue)](#readme-section-38)
  - [প্রয়োজনীয় পরামর্শ](#readme-section-39)
  - [StateMixin](#readme-section-40)
    - [গেট ভিউ (GetView)](#readme-section-41)
    - [গেট রেস্পন্সিভ ভিউ (GetResponsiveView)](#readme-section-42)
    - [কিভাবে এটি ব্যবহার করতে হয়](#readme-section-43)
    - [গেট উইজেট (GetWidget)](#readme-section-44)
    - [গেট এক্স সার্ভিস (GetxService)](#readme-section-45)
    - [পরীক্ষা (Tests)](#readme-section-46)
    - [পরামর্শ](#readme-section-47)
    - [Mockito or mocktail](#readme-section-48)
    - [Using Get.reset()](#readme-section-49)
    - [Get.testMode ](#readme-section-50)
- [2.0 থেকে পরিবর্তন](#readme-section-51)

<a id="getx5-current"></a>

## এই শাখায় GetX 5-এর পরিবর্তন

এই candidate এখনো প্রকাশিত নয়। পরীক্ষিত ভিত্তি Flutter 3.47.9 ও Dart 3.13.7; Flutter-এর অন্তর্ভুক্ত UI লাইব্রেরি ব্যবহার করা হয়।

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

Binding থেকে `List<Bind>` ফেরত দিন। অ্যাপের জন্য binds এবং রুটের জন্য bindings ব্যবহার করুন। Get.create-এর বদলে Get.spawn; async initialization await করে প্রস্তুত মান Get.put দিয়ে নিবন্ধন করুন।

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

`GetStatus<T>.success(data)` সফল ডেটা বহন করে। futurize Future তৈরির ফাংশন নেয় ও void ফেরায়; ফল সম্পূর্ণ হওয়ার ক্রমে প্রয়োগ হয়। খালি Rx collection আলাদা পরিবর্তনযোগ্য backing collection তৈরি করে।

Navigator 2 ব্যবহৃত হয়। Get.back পৃষ্ঠা ফেরায়; dialog, sheet ও snackbar বন্ধে নির্দিষ্ট helper ব্যবহার করুন। অ্যাপের জীবনকালের বাইরে Get.context ও Get.overlayContext null হতে পারে।

নামযুক্ত রুটের history ফেরাতে restorationScopeId এবং স্থির restorationId দিন। JSON-সদৃশ argument, আকারসীমা ও middleware যাচাই প্রযোজ্য; process শেষ হলে নতুন controller ও Future তৈরি হয়।

Response modifier অপসারণ, authentication, timeout, abort ও decoding error সংশোধিত হয়েছে। IO ও ব্রাউজারের HTTP/WebSocket এবং JS/WASM পরীক্ষা ও resource cleanup অন্তর্ভুক্ত।

Flutter 3.47.9-এর browser history percent-encoding সীমাবদ্ধতা রয়ে গেছে; সাধারণ web test পাস মানে এটি ঠিক নয়। প্রকৃত host ও device-এ refresh, back ও restoration পরীক্ষা করুন।

GetMaterialApp বা GetCupertinoApp-এর option ব্যবহার করুন; পুরোনো Get.config নয়। কাস্টম navigation-এর জন্য পূর্ণ Navigator 2 configuration প্রয়োজন।

GetNavigator ও GetRouterOutlet.pickPages-এর `onPopPage` এখন `onDidRemovePage`। এটি অপসারণের পরের notification; back আটকাতে `GetPage.canPop` বা `PopScope` নিন। custom outlet callback থেকে `delegate.didRemovePage`-এ notification পাঠান।

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# Get সম্পর্কে

- GetX হল ফ্লটারের জন্য একটি লাইটওয়েট এবং শক্তিশালী সমাধান। এটি দ্রুত এবং ব্যবহারিকভাবে উচ্চ-পারফরম্যান্স স্টেট ব্যবস্থাপনা, বুদ্ধিমান ডিপেনডেন্সি ইনজেকশন এবং রুট ব্যবস্থাপনাকে একত্রিত করে।

- GetX এর ৩টি মৌলিক নীতি রয়েছে: **উৎপাদনশীলতা, কর্মক্ষমতা এবং সংগঠন**। এর মানে হল যে এইগুলি লাইব্রেরির সমস্ত রিসোর্স এর জন্য অগ্রাধিকার।

  - **কর্মক্ষমতা:** GetX কর্মক্ষমতা এবং রিসোর্স এর ন্যূনতম ব্যবহারের উপর ফোকাস করে। এটি স্ট্রিম বা চেঞ্জনোটিফায়ার ব্যবহার করে না।

  - **উৎপাদনশীলতা:** GetX একটি সহজ এবং মনোরম সিনট্যাক্স ব্যবহার করে। আপনি যা করতে চান না কেন, Getx এর সাথে সর্বদা একটি সহজ উপায় রয়েছে। এটি ডেভেলপমেন্ট এর সময় সাশ্রয় করবে এবং এটি আপনার অ্যাপ্লিকেশনটি সরবরাহ করতে পারে এমন সর্বাধিক কর্মক্ষমতা সরবরাহ করবে।

  - **সংগঠন:** GetX ভিউ, প্রেজেন্টেশন লজিক, বিজনেস লজিক, ডিপেন্ডেন্সি ইনজেকশন এবং নেভিগেশনের মোট ডিকপলিং করার অনুমতি দেয়। রুটগুলির মধ্যে নেভিগেট করার জন্য আপনার কনটেক্সট (context) প্রয়োজন নেই, তাই আপনাকে এর জন্য উইজেট ট্রি (ভিজ্যুয়ালাইজেশন) এর উপর নির্ভরশীল হতে হবে না। 

- GetX এর একটি বিশাল ইকো সিস্টেম, একটি বৃহত সম্প্রদায়, প্রচুর সংখ্যক সহযোগী রয়েছে এবং যতক্ষণ ফ্লাটার বিদ্যমান থাকবে ততক্ষণ রক্ষণাবেক্ষণ করা হবে। গেটএক্স অ্যান্ড্রয়েড, আইওএস, ওয়েব, ম্যাক, লিনাক্স, উইন্ডোজ এবং আপনার সার্ভারে একই কোড দিয়ে চলতে সক্ষম। **[গেট সার্ভার (Get Server)](https://github.com/jonataslaw/get_server) দিয়ে আপনার ফ্রন্টএন্ডে তৈরি কোডটি পুনরায় সম্পূর্ণরূপে ব্যাকএন্ডে ব্যবহার করা সম্ভব।**

**এছাড়াও সম্পূর্ণ ডেভেলপমেন্ট প্রক্রিয়া সার্ভারে এবং ফ্রন্টএন্ডে [Get CLI](https://github.com/jonataslaw/get_cli) এর মাধ্যমে স্বয়ংক্রিয়ভাবে করা যেতে পারে**।

**এছাড়াও আপনার উত্পাদনশীলতা আরও বাড়াতে, আমাদের রয়েছে [VSCode extension](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) এবং [Android Studio/Intellij extension](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**।

<a id="readme-section-3"></a>

# ইনস্টল

আপনার pubspec.yaml ফাইলে get যোগ করুন:

```yaml
dependencies:
  get:
```

যে ফাইল এ ব্যবহার করবেন সেখানে ইম্পোর্ট করুন:

```dart
import 'package:get/get.dart';
```

<a id="readme-section-4"></a>

# GetX দিয়ে কাউন্টার অ্যাপ

Flutter-এ নতুন ডিফল্ট তৈরি করা "কাউন্টার" প্রজেক্টে 100 টিরও বেশি লাইন রয়েছে (মন্তব্য সহ)। Get ব্যবহার করে এটি মাত্র ২৬ লাইনে করা সম্ভব (মন্তব্য সহ)।

- ধাপ 1:
  আপনার MaterialApp এর আগে "Get" যোগ করুন, এটিকে GetMaterialApp এ পরিণত করুন

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- নোট: এটি ফ্লটারের MaterialApp পরিবর্তন করে না, GetMaterialApp একটি পরিবর্তিত MaterialApp নয়, এটি শুধুমাত্র একটি পূর্ব-কনফিগার করা উইজেট, যেটিতে একটি চাইল্ড হিসাবে ডিফল্ট MaterialApp আছে। আপনি এটি ম্যানুয়ালি কনফিগার করতে পারেন, তবে এটি অবশ্যই প্রয়োজনীয় নয়। GetMaterialApp রুট তৈরি করবে, সেগুলিকে ইনজেকশন দেবে, অনুবাদগুলি ইনজেকশন করবে, রুট নেভিগেশনের জন্য আপনার প্রয়োজনীয় সমস্ত কিছু ইনজেক্ট করবে। আপনি যদি শুধুমাত্র স্টেট ব্যবস্থাপনা বা ডিপেন্ডেন্সি ব্যবস্থাপনার জন্য Get ব্যবহার করেন, তাহলে GetMaterialApp ব্যবহার করার প্রয়োজন নেই। GetMaterialApp রুট, স্ন্যাকবার, আন্তর্জাতিকীকরণ, বটমশিট, ডায়ালগ এবং রুট সম্পর্কিত উচ্চ-স্তরের এপিএস এবং প্রসঙ্গ অনুপস্থিতির জন্য প্রয়োজনীয়।
- নোট-²: আপনি যদি রুট ম্যানেজমেন্ট ব্যবহার করেন তবেই এই ধাপটি প্রয়োজনীয় (`Get.to()`, `Get.back()` এবং অন্যান্য)। আপনি যদি এটি ব্যবহার না করেন তবে ধাপ-1 করার দরকার নেই

- ধাপ 2:
  আপনার বিজনেস লজিক ক্লাস তৈরি করুন এবং এর ভিতরে সমস্ত ভেরিয়েবল, পদ্ধতি এবং কন্ট্রোলার রাখুন।
  আপনি একটি সাধারণ ".obs" ব্যবহার করে যেকোনো পরিবর্তনশীলকে পর্যবেক্ষণযোগ্য করতে পারেন।

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- ধাপ 3:
  আপনার ভিউ তৈরি করুন, স্টেটলেস উইজেট ব্যবহার করুন এবং কিছু র‌্যাম সেভ করুন, Get এর সাথে আপনাকে হয়তো আর StatefulWidget ব্যবহার করার প্রয়োজন হবে না।

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

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

<a id="readme-section-5"></a>

# GetX এর তিনটি স্তম্ভ

<a id="readme-section-6"></a>

## স্টেট ব্যবস্থাপনা

Get দুই ভিন্ন স্টেট ম্যানেজার আছে: সাধারণ স্টেট ম্যানেজার (আমরা একে GetBuilder বলব) and প্রতিক্রিয়াশীল স্টেট ম্যানেজার (GetX/Obx)

<a id="readme-section-7"></a>

### প্রতিক্রিয়াশীল স্টেট ম্যানেজার

প্রতিক্রিয়াশীল প্রোগ্রামিং অনেক লোককে উদাসীন করতে পারে কারণ এটি জটিল। GetX প্রতিক্রিয়াশীল প্রোগ্রামিংকে বেশ সহজে পরিণত করে:

- আপনাকে StreamControllers তৈরি করতে হবে না।
- আপনাকে প্রতিটি ভেরিয়েবলের জন্য একটি StreamBuilder তৈরি করতে হবে না।
- আপনাকে প্রতিটি স্টেটের জন্য একটি ক্লাস তৈরি করতে হবে না।
- আপনাকে initial value এর জন্য get তৈরি করতে হবে না।
- আপনাকে কোড জেনারেটর ব্যবহার করতে হবে না।

Get এর সাথে প্রতিক্রিয়াশীল প্রোগ্রামিং setState ব্যবহার করার মতোই সহজ।

কল্পনা করুন যে আপনার একটি নাম ভ্যারিয়েবল আছে এবং আপনি চান যে প্রতিবার আপনি এটি পরিবর্তন করবেন, এটি ব্যবহার করে এমন সমস্ত উইজেট স্বয়ংক্রিয়ভাবে পরিবর্তন করতে পারবেন।

মনে করুন এটি আপনার নাম ভ্যারিয়েবল:

```dart
var name = 'Ashiqur Rahman Alif';
```

এটিকে observable করতে, আপনাকে এটির শেষে ".obs" যোগ করতে হবে:

```dart
var name = 'Ashiqur Rahman Alif'.obs;
```

এবং UI-তে যখন আপনি সেই নামটি দেখাতে চান এবং যখনই মান পরিবর্তন হয় তখন স্ক্রীনটি আপডেট করতে চান, কেবল এটি করুন:

```dart
Obx(() => Text("${controller.name}"));
```

এখানেই শেষ। এটা এমনই সহজ।

<a id="readme-section-8"></a>

### স্টেট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**স্টেট পরিচালনার আরও ব্যাখ্যা দেখুন [এখানে](./documentation/en_US/state_management.md)। সেখানে আপনি আরও উদাহরণ দেখতে পাবেন এবং সাধারণ স্টেট ব্যবস্থাপক এবং প্রতিক্রিয়াশীল স্টেট ব্যবস্থাপকের মধ্যে পার্থক্যও দেখতে পাবেন**

GetX পাওয়ার সম্পর্কে ভালো ধারণা পাবেন।

<a id="readme-section-9"></a>

## রুট ব্যবস্থাপনা

আপনি যদি context ছাড়াই রুট/স্ন্যাকবার/ডায়ালগ/বটমশীট ব্যবহার করতে চান, GetX আপনার জন্য, এটি দেখুন:

আপনার MaterialApp এর আগে "Get" যোগ করুন, এটিকে GetMaterialApp এ পরিণত করুন

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

একটি নতুন স্ক্রিনে নেভিগেট করুন:

```dart

Get.to(() => NextScreen());
```

নাম সহ নতুন স্ক্রিনে নেভিগেট করুন। নামযুক্ত রুট সম্পর্কিত আরও বিস্তারিত বিবরণ দেখুন [এখানে](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

স্ন্যাকবার, ডায়ালগ, বটমশীট, বা যেকোনো কিছু বন্ধ করতে আপনি Navigator.pop(context) এর পরিবর্তে ব্যবহার করুন:

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

পরবর্তী স্ক্রিনে যাওয়ার পর আগের স্ক্রিনে ফিরে যাওয়া বন্ধ করুন (স্প্ল্যাশস্ক্রিন, লগইন স্ক্রিন ইত্যাদিতে ব্যবহারের জন্য)

```dart
Get.off(() => NextScreen());
```

পরবর্তী স্ক্রিনে যেতে এবং আগের সমস্ত রুট বাতিল করতে (শপিং কার্ট, পোল  ইত্যাদিতে ব্যবহারের জন্য)

```dart
Get.offAll(() => NextScreen());
```

লক্ষ্য করেছেন যে এই জিনিসগুলির কোনটি করার জন্য আপনাকে context ব্যবহার করতে হবে না? এটি Get রুট ম্যানেজমেন্ট ব্যবহার করার সবচেয়ে বড় সুবিধাগুলির মধ্যে একটি। এটির সাহায্যে, আপনি চিন্তা ছাড়াই আপনার controller class এর মধ্যে থেকে এই সমস্ত পদ্ধতিগুলি চালাতে পারেন।

<a id="readme-section-10"></a>

### রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত ডকুমেন্টেশন আছে [এখানে](./documentation/en_US/route_management.md)**

<a id="readme-section-11"></a>

## ডিপেনডেন্সি ব্যবস্থাপনা

Get এর একটি সহজ এবং শক্তিশালী ডিপেনডেন্সি পরিচালক রয়েছে যা আপনাকে কোনও Provider context বা inheritedWidget ছাড়াই, মাত্র 1 লাইনের কোডের মাধ্যমে আপনার ব্লক বা কন্ট্রোলারের মতো একই class রিট্রিভ করতে দেয়:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- দ্রষ্টব্য: আপনি যদি Get's State Manager ব্যবহার করেন, তাহলে bindings API-এ আরও মনোযোগ দিন, যা আপনার কন্ট্রোলারের সাথে আপনার ভিউকে সংযোগ করা সহজ করে তুলবে।

আপনি যে ক্লাসটি ব্যবহার করছেন তার মধ্যে আপনার ক্লাসকে ইনস্ট্যান্টিয়েট করার পরিবর্তে Get ইনস্ট্যান্সের মধ্যে ইনস্ট্যান্টিয়েট করুন, যা এটিকে আপনার অ্যাপ জুড়ে উপলব্ধ করবে।
তখন আপনি স্বাভাবিকভাবে আপনার controller (বা class Bloc) ব্যবহার করতে পারবেন।

**টিপ:** Get ডিপেন্ডেন্সি ম্যানেজমেন্ট প্যাকেজের অন্যান্য অংশ থেকে ডিকপল করা হয়েছে, উদাহরণ স্বরূপ, আপনার অ্যাপ ইতিমধ্যেই একটি স্টেট ম্যানেজার ব্যবহার করে (যেকোনোটি হতে পারে, এটা কোন ব্যাপার না), তবে আপনার পুনরায় সব লেখার দরকার নেই, আপনি কোনও সমস্যা ছাড়াই এই ডিপেন্ডেন্সি ইনজেকশনটি ব্যবহার করতে পারেন।

```dart
controller.fetchApi();
```

কল্পনা করুন যে আপনি অসংখ্য রুটে নেভিগেট করেছেন, এবং আপনার controller এর পিছনে ফেলে আসা ডেটার প্রয়োজন, আপনার প্রোভাইডার বা Get_it এর সাথে মিলিত একটি স্টেট ম্যানেজারের প্রয়োজন হবে, তাই না? Get এর সাথে তা প্রয়োজন নেই। আপনাকে শুধু আপনার controller এর জন্য "find" জিজ্ঞাসা করতে হবে, আপনার কোনো অতিরিক্ত ডিপেন্ডেন্সি প্রয়োজন নেই:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

এবং তারপরে আপনি আপনার নিয়ামক ডেটা পুনরুদ্ধার করতে সক্ষম হবেন যা সেখানে ফিরে প্রাপ্ত হয়েছিল:

```dart
Text(controller.textFromApi);
```

<a id="readme-section-12"></a>

### ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত ব্যাখ্যা দেখুন [এখানে](./documentation/en_US/dependency_management.md)**

<a id="readme-section-13"></a>

# ইউটিলিটি

<a id="readme-section-14"></a>

## আন্তর্জাতিকীকরণ

<a id="readme-section-15"></a>

### অনুবাদ

অনুবাদগুলি একটি সাধারণ কী-মানের অভিধান মানচিত্র হিসাবে রাখা হয়।
To add custom translations, create a class and extend `Translations`.
কাস্টম অনুবাদ যোগ করতে, একটি class তৈরি করুন এবং `Translations` এ extends করুন।

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

#### অনুবাদের ব্যবহার

শুধুমাত্র নির্দিষ্ট key তে `.tr` যোগ করুন এবং এটি অনুবাদ করা হবে, `Get.locale` এবং `Get.fallbackLocale` এর বর্তমান মান ব্যবহার করে।

```dart
Text('title'.tr);
```

<a id="readme-section-17"></a>

#### একবচন এবং বহুবচন সহ অনুবাদ ব্যবহার

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length));
```

<a id="readme-section-18"></a>

#### প্যারামিটার সহ অনুবাদ ব্যবহার

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

<a id="readme-section-19"></a>

### লোকেল

লোকেল এবং অনুবাদ সংজ্ঞায়িত করতে `GetMaterialApp`-এ প্যারামিটার পাস করুন।

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

<a id="readme-section-20"></a>

#### লোকেল পরিবর্তন করুন

লোকেল আপডেট করতে `Get.updateLocale(locale)` কল করুন। অনুবাদগুলি তখন স্বয়ংক্রিয়ভাবে নতুন লোকেল ব্যবহার করে।

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-21"></a>

#### লোকেল পদ্ধতি

সিস্টেম লোকেল পড়তে, আপনি `Get.deviceLocale` ব্যবহার করতে পারেন।

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

<a id="readme-section-22"></a>

## থিম পরিবর্তন করুন

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

<a id="readme-section-23"></a>

## গেট কানেক্ট (GetConnect)

GetConnect is an easy way to communicate from your back to your front with http or websockets

<a id="readme-section-24"></a>

### ডিফল্ট কনফিগারেশন

You can simply extend GetConnect and use the GET/POST/PUT/DELETE/SOCKET methods to communicate with your Rest API or websockets.

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

<a id="readme-section-25"></a>

### কাস্টম কনফিগারেশন

GetConnect is highly customizable You can define base Url, as answer modifiers, as Requests modifiers, define an authenticator, and even the number of attempts in which it will try to authenticate itself, in addition to giving the possibility to define a standard decoder that will transform all your requests into your Models without any additional configuration.

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

<a id="readme-section-26"></a>

## গেট পেজ মিডিলওয়্যার

The GetPage has now new property that takes a list of GetMiddleWare and run them in the specific order.

**Note**: When GetPage has a Middlewares, all the children of this page will have the same middlewares automatically.

<a id="readme-section-27"></a>

### অগ্রাধিকার (Priority)

The Order of the Middlewares to run can be set by the priority in the GetMiddleware.

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

those middlewares will be run in this order **-8 => 2 => 4 => 5**

<a id="readme-section-28"></a>

### পুনঃনির্দেশ (Redirect)

redirectDelegate থেকে route দিলে চলবে, অন্য RouteDecoder দিলে redirect, null দিলে বাতিল। login route নিবন্ধন করুন এবং redirect loop এড়ান।

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

<a id="readme-section-29"></a>

### অন-পেজ কলড (onPageCalled)

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
class PageTitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Welcome');
}
```

<a id="readme-section-30"></a>

### অন-বাইন্ডিং স্টার্ট (OnBindingsStart)

This function will be called right before the Bindings are initialize.
Here you can change Bindings for this page.

```dart
class BindingMiddleware extends GetMiddleware {
  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);
}
```

<a id="readme-section-31"></a>

### অন-পেজ বিল্ড স্টার্ট (OnPageBuildStart)

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
class BuildMiddleware extends GetMiddleware {
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;
}
```

<a id="readme-section-32"></a>

### অন-পেজ বিল্ড (OnPageBuilt)

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

<a id="readme-section-33"></a>

### অন-পেজ ডিসপোজ (OnPageDispose)

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

<a id="readme-section-34"></a>

## অন্যান্য এপিআই সমূহ

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

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

<a id="readme-section-35"></a>

### ঐচ্ছিক গ্লোবাল সেটিংস এবং ম্যানুয়াল কনফিগারেশন

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

GetMaterialApp বা GetCupertinoApp-এর option ব্যবহার করুন; পুরোনো Get.config নয়। কাস্টম navigation-এর জন্য পূর্ণ Navigator 2 configuration প্রয়োজন।

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

<a id="readme-section-36"></a>

### লোকাল স্টেট উইজেট

These Widgets allows you to manage a single value, and keep the state ephemeral and locally.
We have flavours for Reactive and Simple.
For instance, you might use them to toggle obscureText in a `TextField`, maybe create a custom
Expandable Panel, or maybe modify the current index in `BottomNavigationBar` while changing the content
of the body in a `Scaffold`.

<a id="readme-section-37"></a>

#### ভ্যালু বিল্ডার (ValueBuilder)

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

<a id="readme-section-38"></a>

#### অবএক্সভ্যালু (ObxValue)

Similar to [`ValueBuilder`](README.md#local), but this is the Reactive version, you pass a Rx instance (remember the magical .obs?) and
updates automatically... isn't it awesome?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

<a id="readme-section-39"></a>

## প্রয়োজনীয় পরামর্শ

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
<a id="readme-section-40"></a>

## StateMixin

Another way to handle your `UI` state is use the `StateMixin<T>` .
To implement it, use the `with` to add the `StateMixin<T>`
to your controller which allows a T model.

``` dart
class Controller extends GetxController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(GetStatus.success(data));
```

GetStatus allow these status:

``` dart
GetStatus.loading();
GetStatus.success(data);
GetStatus.empty();
GetStatus.error('message');
```

To represent it in the UI, use:

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

<a id="readme-section-41"></a>

#### গেট ভিউ (GetView)

I love this Widget, is so simple, yet, so useful!

Is a `const Stateless` Widget that has a getter `controller` for a registered `Controller`, that's all.

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

<a id="readme-section-42"></a>

#### গেট রেস্পন্সিভ ভিউ (GetResponsiveView)

Extend this widget to build responsive view.
this widget contains the `screen` property that have all
information about the screen size and type.

<a id="readme-section-43"></a>

##### কিভাবে এটি ব্যবহার করতে হয়

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

<a id="readme-section-44"></a>

#### গেট উইজেট (GetWidget)

GetWidget একই widget instance-এর controller cache করে এবং const সমর্থন করে। Get.spawn factory হলে widget সরালে তার controller বন্ধ হয়। GetView প্রতিবার lookup করে।

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

<a id="readme-section-45"></a>

#### গেট এক্স সার্ভিস (GetxService)

GetxService অ্যাপ-জীবনকালের সেবা, যার onInit/onReady/onClose আছে। সাধারণ deletion সুরক্ষিত; ইচ্ছাকৃত force বা Get.reset দিয়ে পরিষ্কার করা যায়। এটি process-পরবর্তী storage নয়। init await করে Get.put করুন।

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

<a id="readme-section-46"></a>

### পরীক্ষা (Tests)

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

<a id="readme-section-47"></a>

#### পরামর্শ

<a id="readme-section-48"></a>

##### Mockito or mocktail
If you need to mock your GetxController/GetxService, you should extend GetxController, and mixin it with Mock, that way

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

<a id="readme-section-49"></a>

##### Using Get.reset()
If you are testing widgets, or test groups, use Get.reset at the end of your test or in tearDown to reset all settings from your previous test.

<a id="readme-section-50"></a>

##### Get.testMode 
if you are using your navigation in your controllers, use `Get.testMode = true` at the beginning of your main.


<a id="readme-section-51"></a>

# 2.0 থেকে পরিবর্তন

1- Rx এর প্রকারভেদ :

| পূর্বে  | এখন      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController এবং GetBuilder এখন একত্রিত, আপনি কোন নিয়ামক ব্যবহার করতে চান তা আর মুখস্ত করার দরকার নেই, শুধু GetxController ব্যবহার করুন, এটি সাধারণ স্টেট ব্যবস্থাপনা এবং প্রতিক্রিয়াশীল স্টেট ব্যবস্থাপনা এর জন্যও কাজ করবে।

2- নেমড রুটস (NamedRoutes)

আগে:

```text
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

এখন:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

কেন এই পরিবর্তন? প্রায়শই, কোন পৃষ্ঠাটি প্যারামিটার বা লগইন টোকেন থেকে প্রদর্শিত হবে তা নির্ধারণ করার প্রয়োজন হতে পারে, পূর্ববর্তী পদ্ধতিটি অনমনীয় ছিল, কারণ এটি সেই অনুমতি দিতো না।
এটি ফাংশনে পৃষ্ঠাটি ইনসার্ট করার জন্য উল্লেখযোগ্যভাবে RAM খরচ হ্রাস করেছে, যেহেতু অ্যাপটি শুরু হওয়ার পর থেকে রুটগুলি মেমরিতে বরাদ্দ করা হবে না, এটি এই ধরণের পদ্ধতিরও অনুমতি দেয়:

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

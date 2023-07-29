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


- [Get সম্পর্কে](#about-get)
- [ইনস্টল](#installing)
- [GetX দিয়ে কাউন্টার অ্যাপ](#counter-app-with-getx)
- [GetX এর তিনটি স্তম্ভ](#the-three-pillars)
  - [স্টেট ব্যবস্থাপনা](#state-management)
    - [প্রতিক্রিয়াশীল স্টেট ম্যানেজার](#reactive-state-manager)
    - [স্টেট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#more-details-about-state-management)
  - [রুট ব্যবস্থাপনা](#route-management)
    - [রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#more-details-about-route-management)
  - [ডিপেনডেন্সি ব্যবস্থাপনা](#dependency-management)
    - [ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত](#more-details-about-dependency-management)
- [ইউটিলিটি](#utils)
  - [আন্তর্জাতিকীকরণ](#internationalization)
    - [অনুবাদ](#translations)
      - [অনুবাদের ব্যবহার](#using-translations)
    - [লোকেল](#locales)
      - [লোকেল পরিবর্তন করুন](#change-locale)
      - [লোকেল পদ্ধতি](#system-locale)
  - [থিম পরিবর্তন করুন](#change-theme)
  - [গেট কানেক্ট](#getconnect)
    - [ডিফল্ট কনফিগারেশন](#default-configuration)
    - [কাস্টম কনফিগারেশন](#custom-configuration)
  - [গেট পেজ মিডিলওয়্যার](#getpage-middleware)
    - [অগ্রাধিকার](#priority)
    - [পুনঃনির্দেশ](#redirect)
    - [অন-পেজ কলড](#onpagecalled)
    - [অন-বাইন্ডিং স্টার্ট](#onbindingsstart)
    - [অন-পেজ বিল্ড স্টার্ট](#onpagebuildstart)
    - [অন-পেজ বিল্ড](#onpagebuilt)
    - [অন-পেজ ডিসপোজ](#onpagedispose)
  - [অন্যান্য এপিআই সমূহ](#other-advanced-apis)
    - [ঐচ্ছিক গ্লোবাল সেটিংস এবং ম্যানুয়াল কনফিগারেশন](#optional-global-settings-and-manual-configurations)
    - [লোকাল স্টেট উইজেট](#local-state-widgets)
      - [ভ্যালু বিল্ডার](#valuebuilder)
      - [অব এক্স ভ্যালু](#obxvalue)
  - [প্রয়োজনীয় পরামর্শ](#useful-tips)
    - [গেট ভিউ](#getview)
    - [গেট রেস্পন্সিভ ভিউ](#getresponsiveview)
      - [কিভাবে এটি ব্যবহার করতে হয়](#how-to-use-it)
    - [গেট উইজেট](#getwidget)
    - [গেট এক্স সার্ভিস](#getxservice)
- [2.0 থেকে পরিবর্তন](#breaking-changes-from-20)

# Get সম্পর্কে

- GetX হল ফ্লটারের জন্য একটি লাইটওয়েট এবং শক্তিশালী সমাধান। এটি দ্রুত এবং ব্যবহারিকভাবে উচ্চ-পারফরম্যান্স স্টেট ব্যবস্থাপনা, বুদ্ধিমান ডিপেনডেন্সি ইনজেকশন এবং রুট ব্যবস্থাপনাকে একত্রিত করে।

- GetX এর ৩টি মৌলিক নীতি রয়েছে: **উৎপাদনশীলতা, কর্মক্ষমতা এবং সংগঠন**। এর মানে হল যে এইগুলি লাইব্রেরির সমস্ত রিসোর্স এর জন্য অগ্রাধিকার।

  - **কর্মক্ষমতা:** GetX কর্মক্ষমতা এবং রিসোর্স এর ন্যূনতম ব্যবহারের উপর ফোকাস করে। এটি স্ট্রিম বা চেঞ্জনোটিফায়ার ব্যবহার করে না।

  - **উৎপাদনশীলতা:** GetX একটি সহজ এবং মনোরম সিনট্যাক্স ব্যবহার করে। আপনি যা করতে চান না কেন, Getx এর সাথে সর্বদা একটি সহজ উপায় রয়েছে। এটি ডেভেলপমেন্ট এর সময় সাশ্রয় করবে এবং এটি আপনার অ্যাপ্লিকেশনটি সরবরাহ করতে পারে এমন সর্বাধিক কর্মক্ষমতা সরবরাহ করবে।

  - **সংগঠন:** GetX ভিউ, প্রেজেন্টেশন লজিক, বিজনেস লজিক, ডিপেন্ডেন্সি ইনজেকশন এবং নেভিগেশনের মোট ডিকপলিং করার অনুমতি দেয়। রুটগুলির মধ্যে নেভিগেট করার জন্য আপনার কনটেক্সট (context) প্রয়োজন নেই, তাই আপনাকে এর জন্য উইজেট ট্রি (ভিজ্যুয়ালাইজেশন) এর উপর নির্ভরশীল হতে হবে না। 

- GetX এর একটি বিশাল ইকো সিস্টেম, একটি বৃহত সম্প্রদায়, প্রচুর সংখ্যক সহযোগী রয়েছে এবং যতক্ষণ ফ্লাটার বিদ্যমান থাকবে ততক্ষণ রক্ষণাবেক্ষণ করা হবে। গেটএক্স অ্যান্ড্রয়েড, আইওএস, ওয়েব, ম্যাক, লিনাক্স, উইন্ডোজ এবং আপনার সার্ভারে একই কোড দিয়ে চলতে সক্ষম। **[গেট সার্ভার (Get Server)](https://github.com/jonataslaw/get_server) দিয়ে আপনার ফ্রন্টএন্ডে তৈরি কোডটি পুনরায় সম্পূর্ণরূপে ব্যাকএন্ডে ব্যবহার করা সম্ভব।**

**এছাড়াও সম্পূর্ণ ডেভেলপমেন্ট প্রক্রিয়া সার্ভারে এবং ফ্রন্টএন্ডে [Get CLI](https://github.com/jonataslaw/get_cli) এর মাধ্যমে স্বয়ংক্রিয়ভাবে করা যেতে পারে**।

**এছাড়াও আপনার উত্পাদনশীলতা আরও বাড়াতে, আমাদের রয়েছে [VSCode extension](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) এবং [Android Studio/Intellij extension](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**।

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

# GetX এর তিনটি স্তম্ভ

## স্টেট ব্যবস্থাপনা

Get দুই ভিন্ন স্টেট ম্যানেজার আছে: সাধারণ স্টেট ম্যানেজার (আমরা একে GetBuilder বলব) and প্রতিক্রিয়াশীল স্টেট ম্যানেজার (GetX/Obx)

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

### স্টেট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**স্টেট পরিচালনার আরও ব্যাখ্যা দেখুন [এখানে](./documentation/en_US/state_management.md)। সেখানে আপনি আরও উদাহরণ দেখতে পাবেন এবং সাধারণ স্টেট ব্যবস্থাপক এবং প্রতিক্রিয়াশীল স্টেট ব্যবস্থাপকের মধ্যে পার্থক্যও দেখতে পাবেন**

GetX পাওয়ার সম্পর্কে ভালো ধারণা পাবেন।

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

Get.to(NextScreen());
```

নাম সহ নতুন স্ক্রিনে নেভিগেট করুন। নামযুক্ত রুট সম্পর্কিত আরও বিস্তারিত বিবরণ দেখুন [এখানে](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

স্ন্যাকবার, ডায়ালগ, বটমশীট, বা যেকোনো কিছু বন্ধ করতে আপনি Navigator.pop(context) এর পরিবর্তে ব্যবহার করুন:

```dart
Get.back();
```

পরবর্তী স্ক্রিনে যাওয়ার পর আগের স্ক্রিনে ফিরে যাওয়া বন্ধ করুন (স্প্ল্যাশস্ক্রিন, লগইন স্ক্রিন ইত্যাদিতে ব্যবহারের জন্য)

```dart
Get.off(NextScreen());
```

পরবর্তী স্ক্রিনে যেতে এবং আগের সমস্ত রুট বাতিল করতে (শপিং কার্ট, পোল  ইত্যাদিতে ব্যবহারের জন্য)

```dart
Get.offAll(NextScreen());
```

লক্ষ্য করেছেন যে এই জিনিসগুলির কোনটি করার জন্য আপনাকে context ব্যবহার করতে হবে না? এটি Get রুট ম্যানেজমেন্ট ব্যবহার করার সবচেয়ে বড় সুবিধাগুলির মধ্যে একটি। এটির সাহায্যে, আপনি চিন্তা ছাড়াই আপনার controller class এর মধ্যে থেকে এই সমস্ত পদ্ধতিগুলি চালাতে পারেন।

### রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**রুট ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত ডকুমেন্টেশন আছে [এখানে](./documentation/en_US/route_management.md)**

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

### ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত

**ডিপেনডেন্সি ব্যবস্থাপনা সম্পর্কে আরো বিস্তারিত ব্যাখ্যা দেখুন [এখানে](./documentation/en_US/dependency_management.md)**

# ইউটিলিটি

## আন্তর্জাতিকীকরণ

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

#### অনুবাদের ব্যবহার

শুধুমাত্র নির্দিষ্ট key তে `.tr` যোগ করুন এবং এটি অনুবাদ করা হবে, `Get.locale` এবং `Get.fallbackLocale` এর বর্তমান মান ব্যবহার করে।

```dart
Text('title'.tr);
```

#### একবচন এবং বহুবচন সহ অনুবাদ ব্যবহার

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

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

### লোকেল

লোকেল এবং অনুবাদ সংজ্ঞায়িত করতে `GetMaterialApp`-এ প্যারামিটার পাস করুন।

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### লোকেল পরিবর্তন করুন

লোকেল আপডেট করতে `Get.updateLocale(locale)` কল করুন। অনুবাদগুলি তখন স্বয়ংক্রিয়ভাবে নতুন লোকেল ব্যবহার করে।

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### লোকেল পদ্ধতি

সিস্টেম লোকেল পড়তে, আপনি `Get.deviceLocale` ব্যবহার করতে পারেন।

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

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

## গেট কানেক্ট (GetConnect)

GetConnect is an easy way to communicate from your back to your front with http or websockets

### ডিফল্ট কনফিগারেশন

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

### কাস্টম কনফিগারেশন

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

## গেট পেজ মিডিলওয়্যার

The GetPage has now new property that takes a list of GetMiddleWare and run them in the specific order.

**Note**: When GetPage has a Middlewares, all the children of this page will have the same middlewares automatically.

### অগ্রাধিকার (Priority)

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

### পুনঃনির্দেশ (Redirect)

This function will be called when the page of the called route is being searched for. It takes RouteSettings as a result to redirect to. Or give it null and there will be no redirecting.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### অন-পেজ কলড (onPageCalled)

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### অন-বাইন্ডিং স্টার্ট (OnBindingsStart)

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

### অন-পেজ বিল্ড স্টার্ট (OnPageBuildStart)

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### অন-পেজ বিল্ড (OnPageBuilt)

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

### অন-পেজ ডিসপোজ (OnPageDispose)

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

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

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similar to MediaQuery.of(context).orientation;
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similar to MediaQuery.of(context).textScaleFactor;
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

### লোকাল স্টেট উইজেট

These Widgets allows you to manage a single value, and keep the state ephemeral and locally.
We have flavours for Reactive and Simple.
For instance, you might use them to toggle obscureText in a `TextField`, maybe create a custom
Expandable Panel, or maybe modify the current index in `BottomNavigationBar` while changing the content
of the body in a `Scaffold`.

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

#### অবএক্সভ্যালু (ObxValue)

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

#### গেট ভিউ (GetView)

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

#### গেট রেস্পন্সিভ ভিউ (GetResponsiveView)

Extend this widget to build responsive view.
this widget contains the `screen` property that have all
information about the screen size and type.

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

#### গেট উইজেট (GetWidget)

Most people have no idea about this Widget, or totally confuse the usage of it.
The use case is very rare, but very specific: It `caches` a Controller.
Because of the _cache_, can't be a `const Stateless`.

> So, when do you need to "cache" a Controller?

If you use, another "not so common" feature of **GetX**: `Get.create()`.

`Get.create(()=>Controller())` will generate a new `Controller` each time you call
`Get.find<Controller>()`,

That's where `GetWidget` shines... as you can use it, for example,
to keep a list of Todo items. So, if the widget gets "rebuilt", it will keep the same controller instance.

#### গেট এক্স সার্ভিস (GetxService)

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

#### পরামর্শ

##### Mockito or mocktail
If you need to mock your GetxController/GetxService, you should extend GetxController, and mixin it with Mock, that way

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Using Get.reset()
If you are testing widgets, or test groups, use Get.reset at the end of your test or in tearDown to reset all settings from your previous test.

##### Get.testMode 
if you are using your navigation in your controllers, use `Get.testMode = true` at the beginning of your main.


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

```dart
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

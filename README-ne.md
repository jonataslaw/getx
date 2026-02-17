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
[![Bangla](https://img.shields.io/badge/Language-Bangla-blueviolet?style=for-the-badge)](README-bn.md)
[![Nepali](https://img.shields.io/badge/Language-Nepali-blueviolet?style=for-the-badge)](README-ne.md)

</div>

- [Get को बारेमा](#about-get)
- [इन्स्टल गर्ने तरिका](#installing)
- [GetX सहित काउन्टर एप](#counter-app-with-getx)
- [तीन मुख्य आधार](#the-three-pillars)
  - [स्टेट व्यवस्थापन](#state-management)
    - [रिएक्टिभ स्टेट म्यानेजर](#reactive-state-manager)
    - [स्टेट व्यवस्थापनबारे थप विवरण](#more-details-about-state-management)
  - [रुट व्यवस्थापन](#route-management)
    - [रुट व्यवस्थापनबारे थप विवरण](#more-details-about-route-management)
  - [डिपेन्डेन्सी व्यवस्थापन](#dependency-management)
    - [डिपेन्डेन्सी व्यवस्थापनबारे थप विवरण](#more-details-about-dependency-management)
- [युटिल्स (Utils)](#utils)
  - [अन्तर्राष्ट्रियकरण](#internationalization)
    - [अनुवादहरू](#translations)
      - [अनुवाद प्रयोग गर्ने तरिका](#using-translations)
    - [लोकेलहरू (Locales)](#locales)
      - [लोकेल परिवर्तन गर्ने](#change-locale)
      - [सिस्टम लोकेल](#system-locale)
  - [थिम परिवर्तन](#change-theme)
  - [GetConnect](#getconnect)
    - [डिफल्ट कन्फिगरेसन](#default-configuration)
    - [कस्टम कन्फिगरेसन](#custom-configuration)
  - [GetPage मिडलवेयर](#getpage-middleware)
    - [प्राथमिकता](#priority)
    - [रिडाइरेक्ट (Redirect)](#redirect)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [अन्य उन्नत API हरू](#other-advanced-apis)
    - [वैकल्पिक ग्लोबल सेटिङ र म्यानुअल कन्फिगरेसन](#optional-global-settings-and-manual-configurations)
    - [लोकल स्टेट विजेटहरू](#local-state-widgets)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [उपयोगी टिप्स](#useful-tips)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [यसलाई कसरी प्रयोग गर्ने](#how-to-use-it)
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
- [2.0 बाट भएका ब्रेकिङ परिवर्तनहरू](#breaking-changes-from-20)
- [किन Getx?](#why-getx)
- [कम्युनिटी](#community)
  - [कम्युनिटी च्यानलहरू](#community-channels)
  - [कसरी योगदान गर्ने](#how-to-contribute)
  - [लेख र भिडियोहरू](#articles-and-videos)

# Get को बारेमा

- GetX Flutter को लागि एक अतिरिक्त-हल्का र शक्तिशाली समाधान हो। यसले उच्च प्रदर्शनको स्टेट व्यवस्थापन, बौद्धिक डिपेन्डेन्सी इन्जेक्शन, र रुट व्यवस्थापनलाई छिटो र व्यावहारिक रूपमा संयोजन गर्दछ।

- GetX का ३ आधारभूत सिद्धान्तहरू छन्। यसको अर्थ पुस्तकालयका सबै स्रोतहरूको लागि यी प्राथमिकताहरू हुन्: **PRODUCTIVITY (उत्पादकता), PERFORMANCE (प्रदर्शन) र ORGANIZATION (संगठन)।**
  - **PERFORMANCE (प्रदर्शन):** GetX प्रदर्शन र स्रोतहरूको न्यूनतम खपतमा केन्द्रित छ। GetX ले Streams वा ChangeNotifier प्रयोग गर्दैन।

  - **PRODUCTIVITY (उत्पादकता):** GetX ले सजिलो र रमाइलो सिन्ट्याक्स प्रयोग गर्दछ। तपाईं जे गर्न चाहनुहुन्छ, GetX सँग सधैं सजिलो तरिका हुन्छ। यसले विकासका घण्टाहरू बचत गर्नेछ र तपाईंको अनुप्रयोगले दिन सक्ने अधिकतम प्रदर्शन प्रदान गर्नेछ।

    सामान्यतया, विकासकर्ताले मेमोरीबाट Controller हरू हटाउने बारे चिन्ता गर्नुपर्छ। GetX सँग यो आवश्यक छैन किनकि स्रोतहरू डिफल्ट रूपमा प्रयोग नभएपछि मेमोरीबाट हटाइन्छन्। यदि तपाईं यसलाई मेमोरीमा राख्न चाहनुहुन्छ भने, तपाईंले आफ्नो डिपेन्डेन्सीमा "permanent: true" स्पष्ट रूपमा घोषणा गर्नुपर्छ। त्यसरी, समय बचत गर्नुको साथै, तपाईं मेमोरीमा अनावश्यक डिपेन्डेन्सीहरू हुने जोखिममा कम हुनुहुन्छ। डिपेन्डेन्सी लोडिङ पनि डिफल्ट रूपमा लेजी (lazy) हुन्छ।

  - **ORGANIZATION (संगठन):** GetX ले View, प्रिजेन्टेसन लजिक, बिजनेस लजिक, डिपेन्डेन्सी इन्जेक्शन, र नेभिगेसनको पूर्ण डिकपलिंग (decoupling) गर्न अनुमति दिन्छ। रुटहरू बीच नेभिगेट गर्न तपाईंलाई context को आवश्यकता पर्दैन, त्यसैले तपाईं यसको लागि widget tree (visualization) मा निर्भर हुनुहुन्न। तपाईंलाई inheritedWidget मार्फत आफ्ना controllers/blocs पहुँच गर्न context आवश्यकता पर्दैन, त्यसैले तपाईंले आफ्नो प्रिजेन्टेसन लजिक र बिजनेस लजिकलाई आफ्नो भिजुअलाइजेसन लेयरबाट पूर्ण रूपमा अलग गर्नुहुन्छ। तपाईंले `MultiProvider` हरू मार्फत आफ्नो widget tree मा Controllers/Models/Blocs कक्षाहरू इन्जेक्ट गर्नुपर्दैन। यसको लागि, GetX ले आफ्नो डिपेन्डेन्सी इन्जेक्शन सुविधा प्रयोग गर्दछ, DI लाई यसको view बाट पूर्ण रूपमा अलग गर्दछ।

    GetX सँग तपाईं आफ्नो एप्लिकेसनको हरेक फिचर कहाँ छ भन्ने कुरा सजिलै थाहा पाउनुहुन्छ, र डिफल्ट रूपमा कोड सफा रहन्छ। यसले मर्मतसम्भार (maintenance) सजिलो बनाउनुका साथै, Flutter मा पहिले असम्भवजस्तै लाग्ने मोड्युल साझेदारीलाई पनि पूर्ण रूपमा सम्भव बनाउँछ।
    Flutter मा कोड व्यवस्थित गर्ने सुरुआती बिन्दु BLoC थियो, जसले business logic लाई visualization बाट अलग गर्‍यो। GetX यसको प्राकृतिक विकास हो—यसले business logic मात्र होइन, presentation logic पनि अलग गर्छ। थप रूपमा, dependency injection र routes पनि decoupled छन्, र data layer पनि यीबाट छुट्टै रहन्छ। तपाईंलाई सबै कुरा कहाँ छ भन्ने स्पष्ट हुन्छ, र यो सबै "hello world" बनाउने भन्दा पनि सजिलो तरिकाले गर्न सकिन्छ।
    GetX, Flutter SDK प्रयोग गरेर उच्च-प्रदर्शन एपहरू बनाउने सबैभन्दा सजिलो, व्यवहारिक, र scalable तरिका हो। यसको वरिपरि ठूलो ecosystem छ जुन उत्कृष्ट रूपमा सँगै काम गर्छ; यो सुरु गर्नेहरूका लागि सजिलो छ र अनुभवी विकासकर्ताहरूका लागि पनि सटीक छ। यो सुरक्षित, स्थिर, अद्यावधिक, र default Flutter SDK मा नभएका धेरै built-in API हरूसहित आउँछ।

- GetX अनावश्यक रूपमा भारी (bloated) छैन। यसमा धेरै सुविधाहरू छन् जसले तपाईंलाई कुनै चिन्ता बिना विकास सुरु गर्न मद्दत गर्छ, तर प्रत्येक सुविधा छुट्टाछुट्टै container मा हुन्छ र प्रयोग गरेपछि मात्रै सुरु हुन्छ। यदि तपाईंले State Management मात्र प्रयोग गर्नुभयो भने State Management मात्रै compile हुन्छ। यदि तपाईंले routes मात्रै प्रयोग गर्नुभयो भने state management सम्बन्धी कोड compile हुँदैन।

- GetX को विशाल ecosystem, ठूलो समुदाय, धेरै सहयोगीहरू छन्, र Flutter रहुञ्जेल यसको मर्मतसम्भार जारी रहनेछ। GetX एउटै कोडबाट Android, iOS, Web, Mac, Linux, Windows र server मा पनि चल्न सक्षम छ।
  **[Get Server](https://github.com/jonataslaw/get_server) प्रयोग गरेर frontend मा लेखेको कोड backend मा पनि पूर्ण रूपमा पुन: प्रयोग गर्न सकिन्छ।**

**थप रूपमा, [Get CLI](https://github.com/jonataslaw/get_cli) प्रयोग गरेर server र frontend दुवैमा सम्पूर्ण विकास प्रक्रिया पूर्ण रूपमा automate गर्न सकिन्छ।**

**अझ बढी उत्पादकता बढाउनका लागि, हामीसँग [VSCode को extension](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) र [Android Studio/Intellij को extension](https://plugins.jetbrains.com/plugin/14975-getx-snippets) पनि उपलब्ध छन्।**

# इन्स्टल गर्ने तरिका

तपाईंको `pubspec.yaml` फाइलमा Get थप्नुहोस्:

```yaml
dependencies:
  get:
```

जहाँ प्रयोग हुन्छ, ती फाइलहरूमा get इम्पोर्ट गर्नुहोस्:

```dart
import 'package:get/get.dart';
```

# GetX सहित काउन्टर एप

Flutter मा नयाँ प्रोजेक्ट बनाउँदा डिफल्ट आउने "counter" प्रोजेक्टमा (comments सहित) 100 भन्दा बढी लाइन हुन्छन्। Get कति शक्तिशाली छ देखाउन, म प्रत्येक क्लिकमा state परिवर्तन हुने, पेजहरू बीच स्विच हुने, र स्क्रिनहरूबीच state साझा हुने "counter" कसरी बनाउने भनेर देखाउँछु—यो सबै व्यवस्थित तरिकाले, business logic लाई view बाट अलग गरेर, comments सहित जम्मा 26 लाइन कोडमा।

- चरण १:
  आफ्नो `MaterialApp` अगाडि `Get` थपेर यसलाई `GetMaterialApp` बनाउनुहोस्

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- नोट: यसले Flutter को `MaterialApp` लाई परिवर्तन गर्दैन। `GetMaterialApp` परिवर्तन गरिएको `MaterialApp` होइन; यो केवल pre-configured Widget हो, जसको child को रूपमा default `MaterialApp` हुन्छ। तपाईंले यसलाई manually configure गर्न सक्नुहुन्छ, तर सामान्यतया आवश्यक पर्दैन। `GetMaterialApp` ले routes बनाउँछ, तिनीहरू inject गर्छ, translations inject गर्छ, र route navigation का लागि चाहिने सबै कुरा तयार पार्छ। यदि तपाईं Get लाई state management वा dependency management का लागि मात्र प्रयोग गर्दै हुनुहुन्छ भने `GetMaterialApp` आवश्यक छैन। `GetMaterialApp` routes, snackbars, internationalization, bottomSheets, dialogs, र context बिना प्रयोग हुने high-level APIs का लागि आवश्यक हुन्छ।
- नोट²: यो चरण route management (`Get.to()`, `Get.back()` आदि) प्रयोग गर्ने हो भने मात्र आवश्यक हुन्छ। यदि प्रयोग गर्नुहुन्न भने चरण १ आवश्यक छैन।

- चरण २:
  आफ्नो business logic class बनाउनुहोस् र त्यसभित्र सबै variables, methods, र controllers राख्नुहोस्।
  साधारण `.obs` प्रयोग गरेर कुनै पनि variable लाई observable बनाउन सकिन्छ।

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- चरण ३:
  आफ्नो View बनाउनुहोस्, `StatelessWidget` प्रयोग गर्नुहोस् र केही RAM बचत गर्नुहोस्। Get प्रयोग गर्दा `StatefulWidget` को आवश्यकता धेरै अवस्थामा नपर्न सक्छ।

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

        // आफ्नो class लाई Get.put() प्रयोग गरेर instantiate गर्नुहोस्,
        // ताकि त्यो त्यहाँका सबै "child" routes मा उपलब्ध होस्।
    final Controller c = Get.put(Controller());

    return Scaffold(
          // count परिवर्तन हुँदा Text() अपडेट गर्न Obx(() => ...) प्रयोग गर्नुहोस्।
          appBar: AppBar(title: Obx(() => Text("क्लिक: ${c.count}"))),

          // 8 लाइनको Navigator.push को सट्टा साधारण Get.to() प्रयोग गर्नुहोस्। context चाहिँदैन।
      body: Center(child: ElevatedButton(
            child: Text("अर्को पेजमा जानुहोस्"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // अर्को पेजले प्रयोग गरिरहेको Controller लाई Get.find() मार्फत पाउन सकिन्छ।
  final Controller c = Get.find();

  @override
  Widget build(context){
    // अपडेट भएको count variable प्रयोग गर्नुहोस्
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

नतिजा:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

यो सरल प्रोजेक्ट हो, तर यसले Get कति शक्तिशाली छ भन्ने कुरा स्पष्ट देखाउँछ। तपाईंको प्रोजेक्ट बढ्दै जाँदा यो फरक अझ स्पष्ट देखिन्छ।

Get टिमसँग काम गर्न डिजाइन गरिएको हो, तर यसले एकल डेभलपरको काम पनि सरल बनाउँछ।

आफ्नो deadline सुधार्नुहोस्, performance नघटाई काम समयमै डेलिभर गर्नुहोस्। Get सबैका लागि नहुन सक्छ, तर यदि तपाईंलाई यो कुरा उपयुक्त लाग्छ भने Get तपाईंका लागि हो!

# तीन मुख्य आधार

## स्टेट व्यवस्थापन

Get मा दुई फरक स्टेट म्यानेजर छन्: simple state manager (यसलाई हामी GetBuilder भन्छौं) र reactive state manager (GetX/Obx)।

### रिएक्टिभ स्टेट म्यानेजर

रिएक्टिभ प्रोग्रामिङ जटिल छ भन्ने धारणा भएकाले धेरैलाई यो अप्ठ्यारो लाग्न सक्छ। तर GetX ले reactive programming लाई धेरै सरल बनाउँछ:

- तपाईंले StreamController बनाउनुपर्दैन।
- प्रत्येक variable को लागि StreamBuilder बनाउनुपर्दैन।
- प्रत्येक state का लागि छुट्टै class बनाउनुपर्दैन।
- initial value का लागि get बनाउनुपर्दैन।
- code generators प्रयोग गर्नुपर्दैन।

Get सँग reactive programming गर्नु `setState` प्रयोग गरे जत्तिकै सजिलो हुन्छ।

मानौं तपाईंसँग `name` variable छ र तपाईं चाहनुहुन्छ कि यसलाई परिवर्तन गर्दा यसलाई प्रयोग गर्ने सबै widgets स्वतः अपडेट होउन्।

यो तपाईंको `name` variable हो:

```dart
var name = 'Jonatas Borges';
```

यसलाई observable बनाउन, अन्त्यमा `.obs` थप्नुहोस्:

```dart
var name = 'Jonatas Borges'.obs;
```

UI मा त्यो value देखाउन र value परिवर्तन हुँदा स्क्रिन अपडेट गर्न, यसरी गर्नुहोस्:

```dart
Obx(() => Text("${controller.name}"));
```

यत्ति हो। यति सजिलो छ।

### स्टेट व्यवस्थापनबारे थप विवरण

**स्टेट व्यवस्थापनको अझ विस्तृत व्याख्या [यहाँ](./documentation/en_US/state_management.md) हेर्नुहोस्। त्यहाँ तपाईंले थप उदाहरणहरू र simple state manager तथा reactive state manager बीचको फरक पनि देख्नुहुनेछ।**

यसले तपाईंलाई GetX को शक्ति राम्रोसँग बुझ्न मद्दत गर्छ।

## रुट व्यवस्थापन

यदि तपाईं context बिना routes/snackbars/dialogs/bottomsheets प्रयोग गर्न चाहनुहुन्छ भने GetX तपाईंका लागि उत्कृष्ट विकल्प हो:

आफ्नो `MaterialApp` अगाडि `Get` थपेर यसलाई `GetMaterialApp` बनाउनुहोस्:

```dart
GetMaterialApp( // पहिले: MaterialApp(
  home: MyHome(),
)
```

नयाँ स्क्रिनमा जान:

```dart

Get.to(NextScreen());
```

नाम (named route) प्रयोग गरेर नयाँ स्क्रिनमा जान। Named routes बारे थप विवरण [यहाँ](./documentation/en_US/route_management.md#navigation-with-named-routes) हेर्नुहोस्।

```dart

Get.toNamed('/details');
```

snackbar, dialog, bottomsheet, वा सामान्यतया `Navigator.pop(context)` ले बन्द गर्ने कुनै पनि चीज बन्द गर्न:

```dart
Get.back();
```

अर्को स्क्रिनमा जान र अघिल्लो स्क्रिनमा फर्किने विकल्प हटाउन (SplashScreen, login screens आदि लागि):

```dart
Get.off(NextScreen());
```

अर्को स्क्रिनमा जान र सबै अघिल्ला routes हटाउन (shopping carts, polls, tests मा उपयोगी):

```dart
Get.offAll(NextScreen());
```

हेर्नुभयो? यी कुनै पनि काम गर्न तपाईंलाई context चाहिएन। यही नै Get route management को सबैभन्दा ठूलो फाइदामध्ये एक हो। यसरी तपाईं यी सबै methods आफ्नो controller class भित्रैबाट सजिलै चलाउन सक्नुहुन्छ।

### रुट व्यवस्थापनबारे थप विवरण

**Get ले named routes सँग काम गर्छ र तपाईंलाई routes माथि low-level control पनि दिन्छ! यसको विस्तृत documentation [यहाँ](./documentation/en_US/route_management.md) उपलब्ध छ।**

## डिपेन्डेन्सी व्यवस्थापन

Get सँग सरल र शक्तिशाली dependency manager छ, जसले Provider context वा inheritedWidget बिना, केवल १ लाइन कोडमै तपाईंको Bloc वा Controller जस्तै class प्राप्त गर्न दिन्छ:

```dart
Controller controller = Get.put(Controller()); // Controller controller = Controller(); को सट्टा
```

- नोट: यदि तपाईं Get को State Manager प्रयोग गर्दै हुनुहुन्छ भने bindings API मा ध्यान दिनुहोस्; यसले तपाईंको view र controller जोड्न सजिलो बनाउँछ।

तपाईंले प्रयोग गरिरहेको class भित्र instantiate गर्नुको सट्टा, तपाईं class लाई Get instance भित्र instantiate गर्नुहुन्छ, जसले यसलाई पुरै App मा उपलब्ध बनाउँछ।
त्यसपछि तपाईं आफ्नो controller (वा Bloc class) सामान्य रूपमा प्रयोग गर्न सक्नुहुन्छ।

**टिप:** Get को dependency management, package का अन्य भागहरूबाट decoupled छ। त्यसैले तपाईंको app पहिले नै कुनै पनि state manager प्रयोग गरिरहेको छ भने पनि सबै कुरा फेरि लेख्नुपर्दैन; यो dependency injection सिधै प्रयोग गर्न सकिन्छ।

```dart
controller.fetchApi();
```

मानौं तपाईं धेरै routes हुँदै अघि बढ्नुभयो र controller मा पहिलेको data फेरि चाहियो। सामान्यतया state manager सँग Provider वा Get_it चाहिन्थ्यो, हैन? Get सँग त्यस्तो चाहिँदैन। तपाईंले Get लाई controller "find" गर्न भन्नु मात्र पर्छ; अतिरिक्त dependency आवश्यक पर्दैन:

```dart
Controller controller = Get.find();
// हो, यो जादू जस्तो देखिन्छ—Get ले सही controller फेला पारेर तपाईंलाई दिन्छ।
// लाखौं controllers instantiate भए पनि Get ले सही controller नै दिन्छ।
```

त्यसपछि तपाईं पहिले प्राप्त भएको controller data फेरि प्रयोग गर्न सक्नुहुन्छ:

```dart
Text(controller.textFromApi);
```

### डिपेन्डेन्सी व्यवस्थापनबारे थप विवरण

**डिपेन्डेन्सी व्यवस्थापनको विस्तृत व्याख्या [यहाँ](./documentation/en_US/dependency_management.md) हेर्नुहोस्।**

# युटिल्स

## अन्तर्राष्ट्रियकरण

### अनुवादहरू

अनुवादहरू साधारण key-value dictionary map को रूपमा राखिन्छन्।
custom translations थप्न class बनाएर `Translations` लाई extend गर्नुहोस्।

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

#### अनुवाद प्रयोग गर्ने तरिका

निर्दिष्ट key को अन्त्यमा `.tr` थप्नुहोस्। त्यसपछि `Get.locale` र `Get.fallbackLocale` को हालको मान अनुसार अनुवाद हुन्छ।

```dart
Text('title'.tr);
```

#### एकवचन र बहुवचनसहित अनुवाद प्रयोग गर्ने तरिका

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### parameters सहित अनुवाद प्रयोग गर्ने तरिका

```dart
import 'package:get/get.dart';


Map<String, Map<String, String>> get keys => {
    'en_US': {
    'logged_in': '@name को रूपमा @email इमेलसहित लगइन गरिएको छ',
    },
    'es_ES': {
     'logged_in': '@name को रूपमा @email इमेलसहित लगइन गरिएको छ',
    }
};

Text('logged_in'.trParams({
  'name': 'Jhon',
  'email': 'jhon@example.com'
  }));
```

### लोकेलहरू

locale र translations सेट गर्न `GetMaterialApp` मा parameters दिनुहोस्।

```dart
return GetMaterialApp(
  translations: Messages(), // तपाईंका अनुवादहरू
  locale: Locale('en', 'US'), // अनुवाद यही locale मा देखाइन्छ
  fallbackLocale: Locale('en', 'UK'), // अमान्य locale चयन भए fallback locale प्रयोग हुन्छ
);
```

#### लोकेल परिवर्तन गर्ने

locale अपडेट गर्न `Get.updateLocale(locale)` चलाउनुहोस्। त्यसपछि अनुवादले स्वतः नयाँ locale प्रयोग गर्छ।

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### सिस्टम लोकेल

system locale पढ्न `Get.deviceLocale` प्रयोग गर्न सकिन्छ।

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## थिम परिवर्तन

अपडेट गर्न `GetMaterialApp` भन्दा माथिल्लो स्तरको widget प्रयोग नगर्नुहोस्। यसले duplicate keys समस्या ल्याउन सक्छ। थिम बदल्न मात्र `ThemeProvider` widget बनाउने पुरानो शैली धेरैले प्रयोग गर्छन्, तर **GetX™** मा यो आवश्यक छैन।

तपाईं custom theme बनाएर कुनै boilerplate बिना `Get.changeTheme` भित्र सिधै प्रयोग गर्न सक्नुहुन्छ:

```dart
Get.changeTheme(ThemeData.light());
```

यदि `onTap` मा Theme बदल्ने बटन बनाउनु छ भने, तपाईं **GetX™** का दुई API संयोजन गर्न सक्नुहुन्छ:

- dark `Theme` प्रयोगमा छ कि छैन जाँच्ने API
- र `Theme` परिवर्तन गर्ने API, जसलाई `onPressed` मा राख्न सकिन्छ:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

`.darkmode` सक्रिय हुँदा यो _light theme_ मा स्विच हुन्छ, र _light theme_ सक्रिय हुँदा _dark theme_ मा बदलिन्छ।

## GetConnect

GetConnect भनेको backend र frontend बीच http वा websocket मार्फत संवाद गर्ने सजिलो तरिका हो।

### डिफल्ट कन्फिगरेसन

तपाईं GetConnect लाई extend गरेर GET/POST/PUT/DELETE/SOCKET methods प्रयोग गरी आफ्नो REST API वा websocket सँग सजिलै संवाद गर्न सक्नुहुन्छ।

```dart
class UserProvider extends GetConnect {
  // GET अनुरोध
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // POST अनुरोध
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // फाइलसहित POST अनुरोध
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

### कस्टम कन्फिगरेसन

GetConnect धेरै नै customizable छ। तपाईं base URL, response modifiers, request modifiers, authenticator, र authenticate गर्ने प्रयास संख्या सेट गर्न सक्नुहुन्छ। साथै standard decoder सेट गरेर कुनै अतिरिक्त configuration बिना सबै requests लाई तपाईंका Models मा रूपान्तरण गर्न सकिन्छ।

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // सबै requests jsonDecode हुँदै CasesModel.fromJson मा जान्छन्
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // यसले baseUrl सेट गर्छ
    // यदि [httpClient] instance बिना प्रयोग भयो भने Http र websocket दुवैका लागि

    // यसले सबै requests का headers मा 'apikey' थप्छ
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // server ले "Brazil" को data पठाए पनि,
    // response deliver हुनुअघि नै हटाइने भएकाले
    // त्यो data प्रयोगकर्तालाई देखिँदैन
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // header सेट गर्ने
      request.headers['Authorization'] = "$token";
      return request;
    });

    // यदि HttpStatus.unauthorized आयो भने
    // authenticator 3 पटकसम्म call हुन्छ
    httpClient.maxAuthRetries = 3;
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage मिडलवेयर

अब GetPage मा नयाँ property छ जसले GetMiddleware को list लिन्छ र तिनलाई निर्दिष्ट क्रम अनुसार चलाउँछ।

**नोट**: GetPage मा middleware भएमा, त्यस page का सबै child pages मा पनि ती middleware स्वतः लागू हुन्छन्।

### प्राथमिकता

middlewares चल्ने क्रम GetMiddleware भित्रको priority बाट सेट गर्न सकिन्छ।

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

यी middlewares **-8 => 2 => 4 => 5** क्रममै चल्छन्।

### रिडाइरेक्ट

यो function call गरिएको route को page खोजिँदै गर्दा चल्छ। यसले redirect का लागि `RouteSettings` return गर्छ। `null` फर्काए redirect हुँदैन।

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

यो function page call भएपछि, कुनै object create हुनुअघि चल्छ।
यसले page का केही गुण परिवर्तन गर्न वा नयाँ page return गर्न मद्दत गर्छ।

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

यो function Bindings initialize हुनुअघि चल्छ।
यहाँबाट तपाईं यस page का Bindings परिवर्तन गर्न सक्नुहुन्छ।

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

यो function Bindings initialize भएलगत्तै चल्छ।
यहाँ bindings तयार भएपछि र page widget बन्नुअघि केही काम गर्न सकिन्छ।

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings तयार छन्');
  return page;
}
```

### OnPageBuilt

यो function `GetPage.page` call भएलगत्तै चल्छ र त्यस function को result (देखाइने widget) दिन्छ।

### OnPageDispose

यो function page सँग सम्बन्धित सबै objects (Controllers, views, ...) dispose भएपछि तुरुन्त चल्छ।

## अन्य उन्नत API हरू

```dart
// हालको स्क्रिनबाट वर्तमान args पाउने
Get.arguments

// अघिल्लो route को नाम पाउने
Get.previousRoute

// raw route मा पहुँच दिने, जस्तै rawRoute.isFirst()
Get.rawRoute

// GetObserver बाट Routing API मा पहुँच
Get.routing

// snackbar खुला छ कि छैन जाँच्ने
Get.isSnackbarOpen

// dialog खुला छ कि छैन जाँच्ने
Get.isDialogOpen

// bottomsheet खुला छ कि छैन जाँच्ने
Get.isBottomSheetOpen

// एउटा route हटाउने
Get.removeRoute()

// predicate true नआएसम्म बारम्बार back जाने
Get.until()

// अर्को route मा जाने र predicate true नआएसम्म अघिल्ला routes हटाउने
Get.offUntil()

// अर्को named route मा जाने र predicate true नआएसम्म अघिल्ला routes हटाउने
Get.offNamedUntil()

// app कुन platform मा चलिरहेको छ जाँच्ने
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// device को प्रकार जाँच्ने
GetPlatform.isMobile
GetPlatform.isDesktop
// web मा सबै platforms स्वतन्त्र रूपमा समर्थित छन्!
// तपाईं browser भित्र चलिरहेको छ कि छैन थाहा पाउन सक्नुहुन्छ
// Windows, iOS, OSX, Android आदि मा पनि
GetPlatform.isWeb


// MediaQuery.of(context).size.height को equivalent,
// तर immutable
Get.height
Get.width

// Navigator को current context दिन्छ
Get.context

// तपाईंको code को जहाँबाट पनि foreground snackbar/dialog/bottomsheet को context दिन्छ
Get.contextOverlay

// नोट: तलका methods, context मा extensions हुन्।
// UI को जहाँ context छ, त्यहीँ यी प्रयोग गर्न सकिन्छ

// changeable height/width चाहिएको छ भने (जस्तै Desktop वा browser window resize हुँदा)
// context प्रयोग गर्नुपर्छ
context.width
context.height

// स्क्रिनको आधा, एक-तिहाइ आदि जस्ता आकार सजिलै परिभाषित गर्न मद्दत गर्छ
// responsive app का लागि उपयोगी
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// MediaQuery.sizeOf(context) जस्तै
context.mediaQuerySize()

/// MediaQuery.paddingOf(context) जस्तै
context.mediaQueryPadding()

/// MediaQuery.viewPaddingOf(context) जस्तै
context.mediaQueryViewPadding()

/// MediaQuery.viewInsetsOf(context) जस्तै
context.mediaQueryViewInsets()

/// MediaQuery.orientationOf(context) जस्तै
context.orientation()

/// device landscape mode मा छ कि छैन जाँच्ने
context.isLandscape()

/// device portrait mode मा छ कि छैन जाँच्ने
context.isPortrait()

/// MediaQuery.devicePixelRatioOf(context) जस्तै
context.devicePixelRatio()

/// MediaQuery.textScaleFactorOf(context) जस्तै
context.textScaleFactor()

/// स्क्रिनको shortestSide पाउने
context.mediaQueryShortestSide()

/// width 800 भन्दा ठूलो भए true
context.showNavbar()

/// shortestSide 600 भन्दा सानो भए true
context.isPhone()

/// shortestSide 600 भन्दा ठूलो भए true
context.isSmallTablet()

/// shortestSide 720 भन्दा ठूलो भए true
context.isLargeTablet()

/// हालको device tablet भए true
context.isTablet()

/// screen size अनुसार value<T> return गर्छ
/// निम्न अवस्थाका लागि value दिन सकिन्छ:
/// watch: shortestSide 300 भन्दा सानो
/// mobile: shortestSide 600 भन्दा सानो
/// tablet: shortestSide 1200 भन्दा सानो
/// desktop: width 1200 भन्दा ठूलो
context.responsiveValue<T>()
```

### वैकल्पिक ग्लोबल सेटिङ र म्यानुअल कन्फिगरेसन

`GetMaterialApp` ले धेरैजसो कुरा स्वचालित रूपमा configure गर्छ, तर तपाईं Get लाई manually पनि configure गर्न सक्नुहुन्छ।

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

तपाईं `GetObserver` भित्र आफ्नै Middleware पनि प्रयोग गर्न सक्नुहुन्छ, यसले अरू व्यवहारमा असर गर्दैन।

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // यहाँ
  ],
);
```

तपाईं `Get` का लागि _Global Settings_ बनाउन सक्नुहुन्छ। कुनै route push गर्नु अघि code मा `Get.config` थप्नुहोस्।
वा सिधै `GetMaterialApp` भित्र पनि सेट गर्न सकिन्छ।

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

तपाईं चाहनुहुन्छ भने `Get` का सबै logging messages लाई redirect गर्न सक्नुहुन्छ।
आफ्नो मनपर्ने logging package प्रयोग गरेर
त्यहीं logs capture गर्न:

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // message लाई यहाँ आफ्नो मनपर्ने logging package मा पठाउनुहोस्
  // नोट: enableLog: false भए पनि logs यो callback मा पठाइन्छन्
  // चाहनुहुन्छ भने GetConfig.isLogEnable मार्फत flag जाँच्न सक्नुहुन्छ
}

```

### लोकल स्टेट विजेटहरू

यी Widgets ले तपाईंलाई एउटै value व्यवस्थापन गर्न र state लाई local/ephemeral रूपमा राख्न मद्दत गर्छ।
Reactive र Simple दुवै प्रकार उपलब्ध छन्।
उदाहरणका लागि, `TextField` मा obscureText toggle गर्न, custom
Expandable Panel बनाउन, वा `Scaffold` को body परिवर्तन गर्दै `BottomNavigationBar` को current index बदल्न सकिन्छ।

#### ValueBuilder

`StatefulWidget` को सरल रूप, जसले updated value लिने `.setState` callback सँग काम गर्छ।

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // उही signature! चाहनुहुन्छ भने ( newValue ) => updateFn( newValue ) पनि प्रयोग गर्न सकिन्छ
  ),
  // builder method बाहिर केही call गर्नुपरेमा
  onUpdate: (value) => print("मान अपडेट भयो: $value"),
  onDispose: () => print("विजेट हटाइयो"),
),
```

#### ObxValue

[`ValueBuilder`](#valuebuilder) जस्तै, तर यो Reactive version हो। तपाईं Rx instance पास गर्नुहुन्छ (`.obs` याद छ?) र
यो स्वतः अपडेट हुन्छ... शानदार छैन र?

```dart
ObxValue((data) => Switch(
        value: data.value,
  onChanged: data, // Rx मा _callable_ function हुन्छ! चाहनुहुन्छ भने (flag) => data.value = flag पनि प्रयोग गर्न सकिन्छ
    ),
    false.obs,
),
```

## उपयोगी टिप्स

`.obs` observables (जसलाई _Rx_ Types पनि भनिन्छ) मा धेरै प्रकारका internal methods र operators हुन्छन्।

> `.obs` भएको property नै वास्तविक value हो भनेर _सोच्नु_ सामान्य कुरा हो... तर यो भ्रममा नपर्नुहोस्!
> हामी variable को Type declaration धेरै पटक छोड्छौं, किनकि Dart compiler पर्याप्त स्मार्ट छ, र code
> सफा देखिन्छ, तर:

```dart
var message = 'Hello world'.obs;
print( 'सन्देश "$message" को Type ${message.runtimeType} हो');
```

`message` ले वास्तविक String value _print_ गरे पनि यसको Type **RxString** नै हुन्छ!

त्यसैले, `message.substring( 0, 4 )` सिधै गर्न मिल्दैन।
तपाईंले _observable_ भित्रको वास्तविक `value` पहुँच गर्नुपर्छ:
सबैभन्दा धेरै प्रयोग हुने तरिका `.value` हो, तर तपाईंले यो पनि प्रयोग गर्न सक्नुहुन्छ...

```dart
final name = 'GetX'.obs;
// value अहिलेको भन्दा फरक भए मात्र stream "update" हुन्छ
name.value = 'Hey';

// सबै Rx properties "callable" हुन्छन् र नयाँ value फर्काउँछन्
// तर यो तरिकाले `null` स्वीकार्दैन, UI rebuild हुँदैन
name('Hello');

// getter जस्तै काम गर्छ, 'Hello' print हुन्छ
name() ;

/// numbers:

final count = 0.obs;

// num primitives का सबै non-mutable operations प्रयोग गर्न सकिन्छ!
count + 1;

// ध्यान दिनुहोस्! `count` final नभई var हुँदा मात्र यो मान्य हुन्छ
count += 1;

// values सँग compare पनि गर्न सकिन्छ:
count > 2;

/// booleans:

final flag = false.obs;

// value लाई true/false बीच switch गर्छ
flag.toggle();


/// all types:

// `value` लाई null बनाउँछ
flag.nil();

// सबै toString(), toJson() operations `value` मा forward हुन्छन्
print( count ); // RxInt को भित्री `toString()` call हुन्छ

final abc = [0,1,2].obs;
// value लाई JSON array मा बदल्छ, RxList print हुन्छ
// सबै Rx types मा Json support हुन्छ!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList र RxSet विशेष Rx types हुन्, जसले आफ्नै native types extend गर्छन्
// तर reactive हुँदाहुँदै पनि List जस्तै सामान्य रूपमा काम गर्न सकिन्छ!
abc.add(12); // list मा 12 थप्छ र stream UPDATE गर्छ
abc[3]; // List जस्तै index 3 पढ्छ


// equality Rx र value दुवैसँग काम गर्छ, तर hashCode चाहिँ सधैं value बाट लिइन्छ
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() child मा defer हुन्छन्, त्यसैले तपाईं override गरेर observable लाई direct print() गर्न सक्नुहुन्छ

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
  String toString() => '$name $last, $age वर्ष';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` "reactive" हो, तर भित्रका properties भने reactive छैनन्!
// त्यसैले भित्रको कुनै variable परिवर्तन गर्‍यौं भने...
user.value.name = 'Roi';
// widget rebuild हुँदैन
// `Rx` लाई user भित्रको परिवर्तन स्वतः थाहा हुँदैन
// त्यसैले custom class मा परिवर्तन manually "notify" गर्नुपर्छ
user.refresh();

// वा `update()` method प्रयोग गर्न सकिन्छ!
user.update((value){
  value.name='Roi';
});

print( user );
```

## StateMixin

`UI` state व्यवस्थापन गर्ने अर्को तरिका `StateMixin<T>` प्रयोग गर्नु हो।
यसलाई लागू गर्न, `with` प्रयोग गरेर controller मा `StateMixin<T>` थप्नुहोस्,
जसले T model स्वीकार्छ।

```dart
class Controller extends GetController with StateMixin<User>{}
```

`change()` method ले चाहिएको बेला State परिवर्तन गर्छ।
data र status यसरी पास गर्नुहोस्:

```dart
change(data, status: RxStatus.success());
```

RxStatus मा यी status उपलब्ध छन्:

```dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

यसलाई UI मा देखाउन:

```dart
class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),

        // यहाँ तपाईं custom loading indicator राख्न सक्नुहुन्छ,
        // default रूपमा Center(child:CircularProgressIndicator()) हुन्छ
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('डाटा फेला परेन'),

        // यहाँ पनि आफ्नो error widget राख्न सकिन्छ,
        // default रूपमा Center(child:Text(error)) हुन्छ
        onError: (error)=>Text(error),
      ),
    );
}
```

#### GetView

यो Widget धेरै सरल तर निकै उपयोगी छ!

यो `const Stateless` Widget हो, जसमा registered `Controller` का लागि `controller` getter हुन्छ—बस त्यत्ति।

```dart
 class AwesomeController extends GetController {
   final String title = 'मेरो उत्कृष्ट View';
 }

  // controller register गर्दा प्रयोग गरेको `Type` सधैं पास गर्न सम्झनुहोस्!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // `controller.something` सिधै call गर्नुहोस्
     );
   }
 }
```

#### GetResponsiveView

responsive view बनाउन यो widget extend गर्नुहोस्।
यस widget मा `screen` property हुन्छ जसमा
screen को size र type सम्बन्धी सबै जानकारी हुन्छ।

##### कसरी प्रयोग गर्ने

यसलाई build गर्ने दुई तरिका छन्।

- `builder` method प्रयोग गरेर build हुने widget return गर्ने।
- `desktop`, `tablet`, `phone`, `watch` methods प्रयोग गर्ने।
  screen type जुन method सँग मिल्छ, त्यही method build हुन्छ।
  जस्तै screen [ScreenType.Tablet] भए `tablet` method चल्छ, आदि।
  **नोट:** यो तरिका प्रयोग गर्दा `alwaysUseBuilder` property लाई `false` राख्नुहोस्।

`settings` property प्रयोग गरेर screen types का width limit सेट गर्न सकिन्छ।

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
यो screen को कोड
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

धेरै मानिसलाई यो Widget बारे थाहा हुँदैन, वा यसको प्रयोगबारे भ्रम हुन्छ।
यसको use case कमै हुन्छ, तर निकै specific छ: यसले Controller लाई `cache` गर्छ।
यो _cache_ गर्ने भएकाले, यो `const Stateless` हुन सक्दैन।

> त्यसो भए Controller लाई "cache" कहिले गर्नुपर्छ?

यदि तपाईं **GetX** को अर्को कम प्रयोग हुने feature `Get.create()` प्रयोग गर्नुहुन्छ भने।

`Get.create(()=>Controller())` ले `Get.find<Controller>()` तपाईंले कल गरेको प्रत्येक पटक
नयाँ `Controller` बनाउँछ,

यहीँ `GetWidget` सबैभन्दा उपयोगी हुन्छ... उदाहरणका लागि,
Todo items को list राख्न। त्यसैले widget "rebuilt" भए पनि उही controller instance कायम रहन्छ।

#### GetxService

यो class `GetxController` जस्तै हो, र यसको lifecycle (`onInit()`, `onReady()`, `onClose()`) पनि उस्तै हुन्छ।
तर यसभित्र आफ्नै "logic" हुँदैन। यसले **GetX** Dependency Injection system लाई यो subclass
मेमोरीबाट **हटाउन नमिल्ने** हो भनेर मात्र सूचित गर्छ।

त्यसैले `Get.find()` बाट आफ्ना "Services" सधैं reachable र active राख्न यो निकै उपयोगी छ। जस्तै:
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  await initServices(); /// SERVICES INITIALIZATION पर्खनुहोस्।
  runApp(SomeApp());
}

/// Flutter app चलाउनु अघि Services initialize गर्नु राम्रो अभ्यास हो।
/// यसले execution flow नियन्त्रण गर्न मद्दत गर्छ (जस्तै Theme configuration,
/// apiKey, User को language आदि लोड गर्नुपरेमा... त्यसैले ApiService अघि SettingService लोड गर्नुहोस्।
/// यसरी GetMaterialApp() लाई rebuild गर्न नपरी values सिधै लिन सक्छ।
void initServices() async {
  print('services सुरु हुँदैछन् ...');
  /// यहीँ get_storage, hive, shared_pref initialization राखिन्छ।
  /// वा moor connection, वा अन्य कुनै async initialization।
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(SettingsService()).init();
  print('सबै services सुरु भए...');
}

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType 2 सेकेन्ड ढिलाइ');
    await 2.delay();
    print('$runtimeType तयार!');
    return this;
  }
}

class SettingsService extends GetxService {
  void init() async {
    print('$runtimeType 1 सेकेन्ड ढिलाइ');
    await 1.delay();
    print('$runtimeType तयार!');
  }
}

```

`GetxService` लाई वास्तवमै delete गर्ने एक मात्र तरिका `Get.reset()` हो,
जुन app को "Hot Reboot" जस्तै हो। त्यसैले app को सम्पूर्ण जीवनकालभरि class instance निरन्तर चाहिन्छ भने
`GetxService` प्रयोग गर्नुहोस्।

### परीक्षणहरू

तपाईं आफ्ना controllers लाई अन्य class जस्तै test गर्न सक्नुहुन्छ, lifecycle सहित:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // मानलाई name2 मा परिवर्तन गर्ने
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
reactive variable "name" को state, सबै lifecycle मा test गर्ने''',
      () {
    /// lifecycle बिना पनि controller test गर्न सकिन्छ,
    /// तर GetX dependency injection प्रयोग गर्दै हुनुहुन्छ भने
    ///  यो सिफारिस गरिँदैन
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// GetX dependency injection प्रयोग गर्दा, तपाईं सबै test गर्न सक्नुहुन्छ,
    /// प्रत्येक lifecycle पछि app को state समेत।
    Get.put(controller); // onInit was called
    expect(controller.name.value, 'name2');

    /// functions test गर्ने
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose was called
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

#### सुझावहरू

##### Mockito वा mocktail

यदि तपाईंले आफ्नो GetxController/GetxService mock गर्नुपर्छ भने, GetxController लाई extend गरी Mock सँग mixin गर्नुहोस्, यसरी:

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

##### Get.reset() प्रयोग गर्ने

यदि widget वा test groups परीक्षण गर्दै हुनुहुन्छ भने, अघिल्लो test का settings reset गर्न test अन्त्यमा वा `tearDown` मा `Get.reset` प्रयोग गर्नुहोस्।

##### Get.testMode

यदि controllers भित्र navigation प्रयोग गर्दै हुनुहुन्छ भने, `main` को सुरुमा `Get.testMode = true` राख्नुहोस्।

# 2.0 बाट भएका ब्रेकिङ परिवर्तनहरू

1- Rx types:

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController र GetBuilder अब merge भएका छन्। अब कुन controller प्रयोग गर्ने भनेर छुट्टै सम्झिरहनुपर्दैन—`GetxController` मात्र प्रयोग गरे पुग्छ; यो simple state management र reactive दुवैमा काम गर्छ।

2- Named Routes
पहिले:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

अब:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

यो परिवर्तन किन?
धेरै अवस्थामा parameter वा login token का आधारमा कुन page देखाउने भन्ने निर्णय गर्नुपर्छ, तर पुरानो तरिका यसका लागि लचिलो थिएन।
page लाई function भित्र राख्दा RAM खपत उल्लेखनीय रूपमा घट्यो, किनकि app सुरुहुँदा नै सबै routes मेमोरीमा allocate हुँदैनन्। साथै यसले यस्तो approach सम्भव बनायो:

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

# किन Getx?

1- Flutter update पछि धेरै package हरू टुट्ने अवस्था धेरै पटक आउँछ। कहिलेकाहीँ compilation errors आउँछन्, जसको समाधान तुरुन्त उपलब्ध हुँदैन। विकासकर्ताले error को स्रोत पत्ता लगाउनुपर्छ, trace गर्नुपर्छ, त्यसपछि मात्र सम्बन्धित repository मा issue खोल्नुपर्छ। Get ले विकासका मुख्य स्रोतहरू (state, dependency र route management) एउटै ठाउँमा ल्याउँछ, जसले pubspec मा एउटै package थपेर काम सुरु गर्न दिन्छ। Flutter update पछि सामान्यतया Get dependency update गरे पुग्छ। Get ले compatibility समस्या पनि कम गर्छ। एउटा package को version अर्कोसँग नमिल्ने समस्या पनि धेरै घट्छ, किनकि सबै कुरा एउटै package भित्र पूर्ण रूपमा compatible हुन्छ।

2- Flutter सजिलो र उत्कृष्ट छ, तर अझै केही boilerplate चाहिन्छ जुन धेरै विकासकर्तालाई अनावश्यक लाग्न सक्छ, जस्तै `Navigator.of(context).push (context, builder [...])`। Get ले विकासलाई सरल बनाउँछ। route call गर्न 8 लाइन लेख्नुको सट्टा `Get.to(Home())` लेखेर सीधै अर्को page मा जान सकिन्छ। Flutter मा dynamic web URLs बनाउन अहिले पनि झन्झटिलो छ, तर GetX सँग यो धेरै सरल छ। Flutter मा state management र dependency management का लागि pub मा सयौं patterns छन्, जसले चर्चा बढाउँछ। तर variable को अन्त्यमा `.obs` थपेर widget लाई `Obx` भित्र राख्नु जत्तिकै सजिलो तरिका विरलै छ—त्यसपछि त्यो variable का सबै updates स्क्रिनमा स्वतः देखिन्छन्।

3- performance को चिन्ता बिना सजिलो विकास। Flutter को performance पहिले नै राम्रो छ, तर मानौं तपाईं state manager र locator प्रयोग गरेर blocs/stores/controllers आदि बाँडिरहनु भएको छ—अब नचाहिँदा dependency manually हटाउनुपर्छ। GetX मा भने controller प्रयोग गरिरहँदा ठीकै, र कसैले प्रयोग नगरेपछि त्यो स्वतः memory बाट हट्छ। यही काम GetX गर्छ। SmartManagement सँग प्रयोग नभएका सबै चीजहरू memory बाट हट्छन्, र तपाईंले programming बाहेक अरू धेरै चिन्ता लिनुपर्दैन। यसरी कुनै अतिरिक्त logic नलेखी पनि न्यूनतम स्रोत प्रयोग सुनिश्चित हुन्छ।

4- वास्तविक decoupling। तपाईंले "view र business logic अलग राख्ने" अवधारणा पक्कै सुन्नुभएको छ। यो BLoC, MVC, MVVM जस्ता patterns मा सामान्य अवधारणा हो। तर Flutter मा context प्रयोगका कारण यो व्यवहारमा कमजोर पर्न सक्छ।
यदि InheritedWidget फेला पार्न context चाहियो भने context view मा राख्नुपर्छ वा parameter बाट पास गर्नुपर्छ। team मा काम गर्दा यसले View र business logic बीच अनावश्यक निर्भरता बढाउँछ। Getx ले केही unorthodox तर सफा approach दिन्छ। यसले StatefulWidget, InitState आदि पूर्ण रूपमा निषेध गर्दैन, तर प्रायः सफा विकल्प दिन्छ। Controllers का lifecycle हुन्छन्, र API REST call जस्ता कामका लागि view मा निर्भर हुनुपर्दैन। `onInit` बाट http call सुरु गर्न सकिन्छ, data आएपछि variables populate हुन्छन्। GetX पूर्ण रूपमा reactive भएकाले (streams मा काम गर्छ), data भरिएपछि त्यसलाई प्रयोग गर्ने widgets view मा स्वतः update हुन्छन्। यसले UI मा काम गर्ने व्यक्तिलाई widgets मै केन्द्रित हुन दिन्छ, र business logic टोलीलाई छुट्टै business logic बनाउन तथा test गर्न स्वतन्त्रता दिन्छ।

यो library निरन्तर update हुँदै नयाँ features थपिरहनेछ। निःसंकोच PR पठाएर योगदान गर्नुहोस्।

# कम्युनिटी

## कम्युनिटी च्यानलहरू

GetX को समुदाय अत्यन्त सक्रिय र सहयोगी छ। तपाईंलाई प्रश्न छ वा यो framework प्रयोगमा सहयोग चाहिन्छ भने, हाम्रो community channels मा जोडिनुहोस्—त्यहाँ छिटो र उचित उत्तर पाउनुहुन्छ। यो repository मुख्यतः issues खोल्न र features अनुरोध गर्नका लागि हो, तर GetX Community को हिस्सा बन्न निःसंकोच आउनुहोस्।

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="how-to-contribute"></a>

## योगदान कसरी गर्ने

_प्रोजेक्टमा योगदान गर्न चाहनुहुन्छ? हामी तपाईंलाई हाम्रो सहयोगीको रूपमा देखाउन पाउँदा खुसी हुनेछौं। तपाईंले Get (र Flutter) लाई अझ राम्रो बनाउन योगदान गर्न सक्ने केही क्षेत्रहरू:_

- README लाई अन्य भाषामा अनुवाद गर्न सहयोग गर्ने।
- README मा documentation थप्ने (Get का धेरै functions अझै documented छैनन्)।
- Get प्रयोग सिकाउने लेख वा भिडियो बनाउने (यी README र भविष्यमा Wiki मा थपिनेछन्)।
- code/tests का लागि PRs दिने।
- नयाँ functions थप्ने।

कुनै पनि योगदान स्वागतयोग्य छ!

<a id="articles-and-videos"></a>

## लेख र भिडियोहरू

- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - [Pesa Coder](https://github.com/UsamaElgendy) को ट्युटोरियल।
- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - [Rod Brown](https://github.com/RodBr) को ट्युटोरियल।
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Amateur Coder द्वारा Route management भिडियो।
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - Amateur Coder द्वारा State management भिडियो।
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Amateur Coder द्वारा Utils, storage, bindings र अन्य features सम्बन्धी भिडियो।
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Amateur Coder द्वारा भिडियो।
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Amateur Coder द्वारा भिडियो।
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - [Aachman Garg](https://github.com/imaachman) द्वारा State management लेख।
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - [Aachman Garg](https://github.com/imaachman) द्वारा Dependency Injection लेख।
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - Thad Carnevalli द्वारा State Management र Navigation समेटिएको छोटो ट्युटोरियल।
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - Thad Carnevalli द्वारा UI + State Management + Storage भिडियो।
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Jeff McMorris द्वारा लेख।
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - App With Flutter द्वारा।
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - App With Flutter द्वारा।
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - [Roi Peker](https://github.com/roipeker) द्वारा।
- [GetConnect: The best way to perform API operations in Flutter with Get.](https://absyz.com/getconnect-the-best-way-to-perform-api-operations-in-flutter-with-getx/) - [MD Sarfaraj](https://github.com/socialmad) द्वारा।
- [How To Create an App with GetX Architect in Flutter with Get CLI](https://www.youtube.com/watch?v=7mb4qBA7kTk&t=1380s) - [MD Sarfaraj](https://github.com/socialmad) द्वारा।

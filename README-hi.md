
![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

[![pub  package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)

[![popularity](https://badges.bar/get/popularity)](https://pub.dev/packages/sentry/score)

[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)

[![pub  points](https://badges.bar/get/pub%20points)](https://pub.dev/packages/get/score)

![building](https://github.com/jonataslaw/get/workflows/build/badge.svg)

[![style:  effective  dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

[![Discord  Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N)

[![Get  on  Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx)

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

[![Turkish](https://img.shields.io/badge/Language-Turkish-blueviolet?style=for-the-badge)](README.tr-TR.md)

[![Hindi](https://img.shields.io/badge/Language-Hindi-blueviolet?style=for-the-badge)](README-hi.md)

</div>

- [Get के बारे में](#about-get)

- [इंस्टॉलिंग](#installing)

- [Get के साथ काउंटर ऐप](#counter-app-with-getx)

- [तीन सिद्धांत](#the-three-pillars)

  - [स्टेट मैनेजमेंट](#state-management)

    - [रिएक्टिव स्टेट मैनेजर ](#reactive-state-manager)

    - [स्टेट मैनेजमेंट के बारे में और जाने](#more-details-about-state-management)

  - [रूट मैनेजमेंट ](#route-management)

    - [रूट मैनेजमेंट के बारे में और जाने](#more-details-about-route-management)

  - [डिपेंडेंसी मैनेजमेंट](#dependency-management)

    - [डिपेंडेंसी मैनेजमेंट के बारे में और जाने](#more-details-about-dependency-management)

- [मदद करने वाले फीचर्स](#utils)

  - [इंटरनॅशनलिनाइज़ेशन](#internationalization)

    - [अनुवाद](#translations)

      - [अनुवादों का उपयोग करना](#using-translations)

    - [क्षेत्र के अनुसार पसंद](#locales)

      - [लोकेल बदलें](#change-locale)

      - [सिस्टम लोकेलस ](#system-locale)

  - [थीम बदलें](#change-theme)

  - [GetConnect](#getconnect)

    - [डिफ़ॉल्ट कॉन्फ़िगरेशन ](#default-configuration)

    - [कस्टम कॉन्फ़िगरेशन](#custom-configuration)

  - [GetPage Middleware](#getpage-middleware)

    - [वरीयता](#priority)

    - [रीडायरेक्ट](#redirect)

    - [पेज कॉल होने पर](#onpagecalled)

    - [बाइंडिंग शुरू होने पर](#onbindingsstart)

    - [पेज बिल्ड स्टार्ट पर](#onpagebuildstart)

    - [पेज पूरा बन ने पर](#onpagebuilt)

    - [पेज डिस्पोसे होने पर](#onpagedispose)

  - [अन्य उन्नत एपीआई](#other-advanced-apis)

    - [वैकल्पिक वैश्विक सेटिंग्स और मैन्युअल कॉन्फ़िगरेशन](#optional-global-settings-and-manual-configurations)

    - [लोकल स्टेट विद्गेट्स ](#local-state-widgets)

      - [वैल्यू बिल्डर](#valuebuilder)

      - [ObxValue](#obxvalue)

  - [उपयोगी सलाह](#useful-tips)

    - [GetView](#getview)

    - [GetResponsiveView](#getresponsiveview)

      - [इसका उपयोग कैसे करना है](#how-to-use-it)

    - [GetWidget](#getwidget)

    - [GetxService](#getxservice)

- [2.0 से बड़े बदलाव](#breaking-changes-from-20)

- [क्यों GetX?](#why-getx)

- [समुदाय](#community)

  - [सामुदायिक चैनल](#community-channels)

  - [कैसे योगदान करें](#how-to-contribute)

  - [लेख और वीडियो](#articles-and-videos)

# Get के बारे में

- GetX, Flutter के लिए एक अतिरिक्त हल्का और शक्तिशाली समाधान है। यह स्टेट मैनेजमेंट, डिपेंडेंसी इंजेक्शन और नेविगेशन  को जल्दी और व्यावहारिक रूप से जोड़ता है।

- GetX के 3 बुनियादी सिद्धांत हैं। इसका मतलब है कि पुस्तकालय में सभी संसाधनों के लिए ये प्राथमिकताएं हैं: **उत्पादकता, प्रदर्शन और संगठन।**

  - **प्रदर्शन**: GetX प्रदर्शन और संसाधनों की न्यूनतम खपत पर केंद्रित है। GetX स्ट्रीम या चेंज नोटिफ़ायर का उपयोग नहीं करता है।

  - **उत्पादकता**: GetX एक आसान और सुखद सिंटैक्स का उपयोग करता है। कोई फर्क नहीं पड़ता कि आप क्या करना चाहते हैं, GetX के साथ हमेशा एक आसान तरीका होता है। यह विकास के घंटों को बचाएगा और अधिकतम प्रदर्शन प्रदान करेगा जो आपका एप्लिकेशन प्रदान कर सकता है।

    आम तौर पर, डेवलपर को स्मृति से नियंत्रकों को हटाने के बारे में चिंतित होना चाहिए। GetX के साथ यह आवश्यक नहीं है क्योंकि संसाधनों को स्मृति से हटा दिया जाता है जब वे डिफ़ॉल्ट रूप से उपयोग नहीं किए जाते हैं। यदि आप इसे स्मृति में रखना चाहते हैं, तो आपको अपनी निर्भरता में स्पष्ट रूप से **"permanent: true"** घोषित करना होगा। इस तरह, समय बचाने के अलावा, आपको स्मृति पर अनावश्यक निर्भरता होने का जोखिम कम होता है। डिपेंडेंसी लोडिंग भी डिफ़ॉल्ट रूप से आलसी है।

  - **संगठन**: गेटएक्स व्यू, प्रेजेंटेशन लॉजिक, बिजनेस लॉजिक, डिपेंडेंसी इंजेक्शन और नेविगेशन को पूरी तरह से अलग करने की अनुमति देता है। आपको मार्गों के बीच नेविगेट करने के लिए संदर्भ की आवश्यकता नहीं है, इसलिए आप इसके लिए विजेट ट्री (विज़ुअलाइज़ेशन) पर निर्भर नहीं हैं। आपको विरासत में मिले विजेट के माध्यम से अपने नियंत्रकों/ब्लॉकों तक पहुँचने के लिए संदर्भ की आवश्यकता नहीं है, इसलिए आप अपने प्रस्तुति तर्क और व्यावसायिक तर्क को अपनी विज़ुअलाइज़ेशन परत से पूरी तरह से अलग कर सकते हैं। आपको मल्टीप्रोवाइडर्स के माध्यम से अपने विजेट ट्री में अपने कंट्रोलर/मॉडल/ब्लॉक क्लास को इंजेक्ट करने की आवश्यकता नहीं है। इसके लिए, GetX अपने स्वयं के निर्भरता इंजेक्शन सुविधा का उपयोग करता है, DI को अपने दृष्टिकोण से पूरी तरह से अलग करता है।

    **GetX** के साथ आप जानते हैं कि डिफ़ॉल्ट रूप से क्लीन कोड वाले अपने एप्लिकेशन की प्रत्येक सुविधा को कहां खोजना है। रखरखाव को आसान बनाने के अलावा, यह मॉड्यूल के साझाकरण को कुछ ऐसा बनाता है जो तब तक फ़्लटर में अकल्पनीय था, कुछ पूरी तरह से संभव था।

    **BLoC** फ़्लटर में कोड व्यवस्थित करने के लिए एक प्रारंभिक बिंदु था, यह व्यावसायिक तर्क को विज़ुअलाइज़ेशन से अलग करता है। GetX इसका एक स्वाभाविक विकास है, न केवल व्यावसायिक तर्क बल्कि प्रस्तुति तर्क को अलग करना। निर्भरता और मार्गों के बोनस इंजेक्शन को भी अलग कर दिया गया है, और डेटा स्तर इससे बाहर है। आप जानते हैं कि सब कुछ कहाँ है, और यह सब एक हैलो वर्ल्ड बनाने की तुलना में आसान तरीके से है।

    Flutter SDK के साथ उच्च-प्रदर्शन अनुप्रयोगों के निर्माण के लिए गेटएक्स सबसे आसान, व्यावहारिक और स्केलेबल तरीका है। इसके चारों ओर एक बड़ा पारिस्थितिकी तंत्र है जो पूरी तरह से एक साथ काम करता है, यह शुरुआती लोगों के लिए आसान है, और यह विशेषज्ञों के लिए सटीक है। यह सुरक्षित, स्थिर, अप-टू-डेट है, और अंतर्निहित एपीआई की एक विशाल श्रृंखला प्रदान करता है जो डिफ़ॉल्ट फ़्लटर एसडीके में मौजूद नहीं हैं।

- **GetX** फूला हुआ नहीं है। इसमें कई विशेषताएं हैं जो आपको बिना किसी चिंता के प्रोग्रामिंग शुरू करने की अनुमति देती हैं, लेकिन इनमें से प्रत्येक सुविधा अलग-अलग कंटेनरों में होती है और केवल उपयोग के बाद ही शुरू होती है। यदि आप केवल राज्य प्रबंधन का उपयोग करते हैं, तो केवल राज्य प्रबंधन संकलित किया जाएगा। यदि आप केवल मार्गों का उपयोग करते हैं, तो राज्य प्रबंधन से कुछ भी संकलित नहीं किया जाएगा।

- GetX में एक विशाल पारिस्थितिकी तंत्र, एक बड़ा समुदाय, बड़ी संख्या में सहयोगी हैं, और जब तक फ़्लटर मौजूद है, तब तक इसे बनाए रखा जाएगा। GetX भी **Android, iOS, Web, Mac, Linux, Windows** और आपके Server पर समान Code के साथ चलने में सक्षम है।

  **आपके Backend पर Frontend पर बने आपके कोड का पूरी तरह से पुन: उपयोग करना संभव है  [Get  Server](https://github.com/jonataslaw/get_server)**.

**इसके अलावा, संपूर्ण विकास प्रक्रिया पूरी तरह से स्वचालित हो सकती है, दोनों सर्वर पर और फ्रंट एंड पर  [Get  CLI](https://github.com/jonataslaw/get_cli)**.

**इसके अलावा, आपकी उत्पादकता को और बढ़ाने के लिए, हमारे पास है

**[VSCODE के लिए एक्सटेंशन](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)  and  the  [Android Studio और Intellij के लिए एक्सटेंशन](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# इंस्टॉलिंग

अपनी ```pubspec.yaml``` फ़ाइल में Get को ऐड करे

```yaml

dependencies:
  ...
  get:

```

Get को अन फाइल्स में Import करे जहां आप Get को इस्तेमाल करेंगे: 

```dart

import 'package:get/get.dart';

```

# GetX के साथ काउंटर ऐप

Flutter पर नए Project पर Default रूप से बनाए गए "काउंटर" प्रोजेक्ट में 100 से अधिक लाइनें (टिप्पणियों के साथ) हैं। Get की शक्ति दिखाने के लिए, मैं प्रदर्शित करूंगा कि प्रत्येक क्लिक के साथ राज्य को बदलने वाला "काउंटर" कैसे बनाया जाए, Navigation किया जाए और State Management किया जाए, सभी एक संगठित तरीके से, व्यावसायिक तर्क को दृश्य से अलग करते हुए, केवल में टिप्पणियों सहित 26 लाइन कोड।

- चरण 1:

  अपने **MaterialApp()** से पहले “Get” जोड़ें, इसे **GetMaterialApp()** में बदल दें

```dart

void main() => runApp(GetMaterialApp(home: Home()));

```

- **सूचना**: यह Flutter के MaterialApp को संशोधित नहीं करता है, GetMaterialApp एक संशोधित MaterialApp नहीं है, यह सिर्फ एक पूर्व-कॉन्फ़िगर विजेट है, जिसमें एक बच्चे के रूप में डिफ़ॉल्ट MaterialApp है। आप इसे मैन्युअल रूप से कॉन्फ़िगर कर सकते हैं, लेकिन यह निश्चित रूप से आवश्यक नहीं है। GetMaterialApp मार्ग बनाएगा, उन्हें इंजेक्ट करेगा, अनुवाद इंजेक्ट करेगा, मार्ग नेविगेशन के लिए आपको जो कुछ भी चाहिए उसे इंजेक्ट करेगा। यदि आप केवल राज्य प्रबंधन या निर्भरता प्रबंधन के लिए गेट का उपयोग करते हैं, तो GetMaterialApp का उपयोग करना आवश्यक नहीं है। GetMaterialApp मार्गों, स्नैकबार, अंतर्राष्ट्रीयकरण, बॉटमशीट, संवाद, और मार्गों से संबंधित उच्च-स्तरीय एपिस और संदर्भ की अनुपस्थिति के लिए आवश्यक है।

- **सूचना²**: यह चरण केवल तभी आवश्यक है जब आप Navigation (`Get.to()`, `Get.back()` इत्यादि) का उपयोग करने वाले हों। यदि आप इसका उपयोग नहीं करने जा रहे हैं तो चरण 1 करने की आवश्यकता नहीं है।

- चरण 2:

  अपना व्यावसायिक तर्क वर्ग बनाएं और उसके अंदर सभी चर, विधियों और नियंत्रकों को रखें।

  आप किसी भी Variable Ko ".obs" का प्रयोग करके Observable बना सकते है

```dart

class Controller extends GetxController{

  var count = 0.obs;

  increment() => count++;

}

```

- चरण 3:

  अपना दृश्य बनाएं, StatelessWidget का उपयोग करें और कुछ RAM सहेजें, Get के साथ आपको StatefulWidget का उपयोग करने की आवश्यकता नहीं है।

```dart

class Home extends StatelessWidget {

  @override

  Widget build(context) {

    // Get.put() का उपयोग करके अपनी Class के सभी Children के लिए उपलब्ध कराने के लिए तत्काल करें।

    final Controller c = Get.put(Controller());

    return Scaffold(

      // जब भी गिनती बदली जाए तो Text() को अपडेट करने के लिए Obx(()=> का उपयोग करें।

      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // 8 लाइन Navigator.push() को एक साधारण Get.to() से बदलें । आपको "context" की आवश्यकता नहीं है ।

      body: Center(child: ElevatedButton(

              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),

      floatingActionButton:

          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));

  }

}

class Other extends StatelessWidget {

  // आप किसी अन्य Page द्वारा उपयोग किए जा रहे Controller को खोजने के लिए Get से पूछ सकते हैं और आपको उस पर Redirect कर सकते हैं।

  final Controller c = Get.find();

  @override

  Widget build(context){

     // बदले हुए count Variable को Access करें

     return Scaffold(body: Center(child: Text("${c.count}")));

  }

}

```

**परिणाम**:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

यह एक सरल Project है लेकिन यह पहले ही स्पष्ट कर देती है कि Get कितना शक्तिशाली है। जैसे-जैसे आपकी परियोजना बढ़ती है, यह अंतर और अधिक महत्वपूर्ण होता जाएगा।

Get को टीमों के साथ काम करने के लिए डिज़ाइन किया गया था, लेकिन यह व्यक्तिगत डेवलपर के काम को आसान बनाता है।

अपनी समय सीमा में सुधार करें, Performance को खोए बिना समय पर सब कुछ वितरित करें। Get हर किसी के लिए नहीं है, लेकिन अगर आपने उस वाक्यांश के साथ पहचान की है, तो Get आपके लिए है!

# तीन सिद्धांत

## State  management

Get के दो अलग-अलग State Manager हैं: Simple State Builder (हम इसे GetBuilder कहते हैं) और Reactive State Manager (GetX/Obx)

### Reactive  State  Manager

Reactive Programming कई लोगों को अलग-थलग कर सकती है क्योंकि इसे जटिल कहा जाता है। GetX Reactive Programming को काफी सरल बना देता है:

- आपको StreamControllers बनाने की आवश्यकता नहीं होगी।

- आपको प्रत्येक Variable के लिए StreamBuilder बनाने की आवश्यकता नहीं होगी

- आपको प्रत्येक Class के लिए एक State बनाने की आवश्यकता नहीं होगी।

- आपको Initial Value के लिए एक Get बनाने की आवश्यकता नहीं होगी।

- आपको Code Generators का उपयोग करने की आवश्यकता नहीं होगी

**Get** के साथ **Reactive Programming**, **"setState()"** का उपयोग करने जितना आसान है।

आइए कल्पना करें कि आपके पास एक name Variable है और चाहते हैं कि हर बार जब आप इसे बदलते हैं, तो इसका उपयोग करने वाले सभी Widgets बदल जाएँ ।
यह आपका count Variable है

```dart

var name = 'Adison Masih';

```

इसे Observable बनाने के लिए, आपको बस इसके अंत में ".obs" जोड़ना होगा:
```dart

var name = 'Adison Masih'.obs;

```

अगर आप आप उस Value को दिखाना चाहते हैं और जब भी Value बदलती हैं तो स्क्रीन को करना चाहते हैं, तो यह करें:

```dart

Obx(() => Text("${controller.name}"));

```

बस इतना ही। यह _इत्ना_ आसान है।

### State Management के बारे में अधिक जानकारी

राज्य प्रबंधन की अधिक गहन व्याख्या [यहां](./documentation/en_US/state_management.md) देखें । वहां आपको अधिक उदाहरण और **Simple State Manager** और **Reactive State Manager** के बीच का अंतर दिखाई देगा

आपको GetX की शक्ति का अच्छा अंदाजा हो जाएगा।

## Route  प्रबंधन

यदि आप बिना **context** के **Routes/Snackbars/Dialogs/Bottomsheets** का उपयोग करने जा रहे हैं, तो GetX आपके लिए भी उत्कृष्ट है, बस इसे देखें:

अपने **"MaterialApp()"** से पहले **“Get”** जोड़ें, इसे **"GetMaterialApp()"** में बदल दें

```dart

GetMaterialApp( // यह पहले MaterialApp था

  home: MyHome(),

)

```

एक नई स्क्रीन पर Navigate करें:
```dart

Get.to(NextScreen());

```

नाम के साथ नई स्क्रीन पर Navigate करें। **Named Routes** पर अधिक विवरण [यहां](./documentation/en_US/route_management.md#navigation-with-named-routes) देखें।

```dart

Get.toNamed('/details');

```

Snackbar, Dialog तथा Bottomsheets या ऐसी किसी भी चीज़ को बंद करने के लिए आप आम तौर पर ```Navigator.pop(context);``` के साथ बंद करते हैं;

```dart

Get.back();

```
अगली Screen पर जाने के लिए और पिछली Screen पर वापस जाने का कोई विकल्प नहीं है (SplashScreens, Login Screens आदि में उपयोग के लिए)

```dart

Get.off(NextScreen());

```

अगली Screen पर जाने और पिछले सभी Routes को रद्द करने के लिए (Shopping Carts, Polls और Tests में उपयोगी)

```dart

Get.offAll(NextScreen());

```

ध्यान दिया कि आपको इनमें से कोई भी काम करने के लिए **"context"** का उपयोग करने की आवश्यकता नहीं है? **"Get Route Management"** का उपयोग करने का यह सबसे बड़ा लाभ है। इसके साथ, आप इन सभी **"Methods"** को अपने **"Controller Class"** से बिना किसी चिंता के Execute कर सकते हैं।

### Route Management के बारे में अधिक जानकारी

**"Named Routes"** के साथ काम करें और अपने Routes पर **"Lower-Level Control"** भी प्राप्त करें! [यहां](./documentation/en_US/route_management.md) गहन दस्तावेज है

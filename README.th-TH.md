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

**ภาษาอื่นๆ**

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
[![Thai](https://img.shields.io/badge/Language-Thai-blueviolet?style=for-the-badge)](README-bn.md)

</div>

- [เกี่ยวกับ Get](#about-get)
- [การติดตั้ง](#installing)
- [สร้างแอปตัวนับด้วย GetX](#counter-app-with-getx)
- [เสาหลัก 3 ประการ](#the-three-pillars)
  - [ตัวจัดการข้อมูล](#state-management)
    - [ตัวจัดการข้อมูลแบบตอบโต้](#reactive-state-manager)
    - [รายละเอียดเพิ่มเติมเกี่ยวกับตัวจัดการข้อมูล](#more-details-about-state-management)
  - [ตัวจัดการเส้นทาง](#route-management)
    - [รายละเอียดเพิ่มเติมเกี่ยวกับตัวจัดการเส้นทาง](#more-details-about-route-management)
  - [ตัวจัดการ Dependency](#dependency-management)
    - [รายละเอียดเพิ่มเติมเกี่ยวกับตัวจัดการ dependency](#more-details-about-dependency-management)
- [ยูทิล (Utils)](#utils)
  - [การทำให้เป็นสากล](#internationalization)
    - [แปลภาษา](#translations)
      - [การแปลภาษา](#using-translations)
    - [ท้องถิ่น](#locales)
      - [การเปลี่ยนข้อมูลท้องถิ่น](#change-locale)
      - [ข้อมูลท้องถิ่นจากเครื่อง](#system-locale)
  - [เปลี่ยนธีม](#change-theme)
  - [GetConnect](#getconnect)
    - [การตั้งค่าแบบค่าเริ่มต้น](#default-configuration)
    - [การตั้งค่าแบบกำหนดเอง](#custom-configuration)
  - [GetPage มิดเดิลแวร์](#getpage-middleware)
    - [ลำดับความสำคัญ](#priority)
    - [redirect](#redirect)
    - [onPageCalled](#onpagecalled)
    - [onBindingsStart](#onbindingsstart)
    - [onPageBuildStart](#onpagebuildstart)
    - [onPageBuilt](#onpagebuilt)
    - [onPageDispose](#onpagedispose)
  - [ฟีเจอร์ขั้นสูงอื่น ๆ](#other-advanced-apis)
    - [การตั้งค่าทั่วโลกแบบทางเลือกและการกำหนดค่าด้วยตนเอง](#optional-global-settings-and-manual-configurations)
    - [วิดเจ็ตสถานะภายใน)](#local-state-widgets)
      - [ตัวสร้างค่า](#valuebuilder)
      - [ค่า Obx](#obxvalue)
  - [เคล็ดลับที่เป็นประโยชน์](#useful-tips)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [วิธีใช้](#how-to-use-it)
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
- [การเปลี่ยนแปลงที่สำคัญจากเวอร์ชัน 2.0](#breaking-changes-from-20)
- [ทำไมต้องGetX?](#why-getx)
- [ชุมชน](#community)
  - [ช่องทางชุมชนต่างๆ](#community-channels)
  - [วิธีการมีส่วนร่วม](#how-to-contribute)
  - [บทความและวิดีโอ](#articles-and-videos)

# เกี่ยวกับ Get

- GetX คือ การแก้ไขปัญหาที่มีประสิทธิภาพ และเบา (ไลบรารีมีขนาดเล็ก) สำหรับ Flutter ผสมผสานตัวจัดการข้อมูล (State Management) ที่มีประสิทธิภาพ, การแทรก dependency ที่ฉลาด และตัวจัดการเส้นทางอย่างรวดเร็ว และใช้งานได้จริง

- GetX มีหลักการพื้นฐาน 3 ประการ หมายถึง สิ่งเหล่านี้เป็นสิ่งสำคัญอันดับแรกสำหรับทรัพยากรทั้งหมดในไลบรารี: **ผลผลิต, ประสิทธิภาพ และการจัดระเบียบ**

  - **ประสิทธิภาพ:** GetX มุ่งเน้นไปที่ประสิทธิภาพและการใช้ทรัพยากรน้อยที่สุด GetX ไม่ใช้ Streams หรือ ChangeNotifier

  - **ผลผลิต:** GetX ใช้ไวยากรณ์ที่ง่ายและสะดวก ไม่ว่าคุณต้องการทำอะไรก็ตาม GetX จะมีวิธีที่ง่ายกว่าเสมอ มันจะช่วยประหยัดเวลาในการพัฒนาหลายชั่วโมงและจะมอบประสิทธิภาพสูงสุดที่แอปพลิเคชันของคุณสามารถส่งมอบได้

    โดยทั่วไป ผู้พัฒนาควรคำนึงถึงการนำ ตัวควบคุม(controller) ออกจากหน่วยความจำ ด้วย GetX สิ่งนี้ไม่จำเป็น เนื่องจากทรัพยากรจะถูกลบออกจากหน่วยความจำเมื่อไม่ได้ใช้งานตามค่าเริ่มต้น หากคุณต้องการเก็บไว้ในหน่วยความจำ คุณต้องประกาศ "permanent: true" อย่างชัดเจนในการอ้างอิงของคุณ ด้วยวิธีนี้ นอกเหนือจากการประหยัดเวลาแล้ว คุณยังเสี่ยงน้อยลงที่จะมีการอ้างอิงที่ไม่จำเป็นในหน่วยความจำ การโหลดการอ้างอิงยังเป็นแบบ Lazy ตามค่าเริ่มต้น

  - **การจัดระเบียบ:** GetX อนุญาตให้แยก View, ตรรกทางการนำเสนอ, ตรรกเชิงธุระกิจ, dependency injection และการนำทางออกจากกันโดยสิ้นเชิง คุณไม่จำเป็นต้องใช้ Context เพื่อนำทางระหว่างเส้นทาง ดังนั้น คุณจึงไม่ขึ้นอยู่กับโครงสร้าง Widget (การจำลอง) สำหรับสิ่งนี้ คุณไม่จำเป็นต้องใช้ Context เพื่อเข้าถึงตัวควบคุม/บล็อกของคุณผ่าน inheritedWidget ดังนั้น คุณจึงแยกตรรกะการนำเสนอและตรรกะทางธุรกิจของคุณออกจากเลเยอร์การมองเห็นของคุณอย่างสมบูรณ์ คุณไม่จำเป็นต้อง inject คลาสตัวควบคุม/โมเดล/บล็อกของคุณลงในโครงสร้าง Widget ของคุณผ่าน `MultiProvider`s สำหรับสิ่งนี้ GetX ใช้คุณสมบัติ dependency injection ของตัวเอง ทำให้ DI แยกออกจากมุมมองอย่างสมบูรณ์

    ด้วย GetX ณจะทราบว่าฟีเจอร์ต่างๆ ของแอปพลิเคชันของคุณอยู่ที่ไหน ส่งผลให้โค้ดมีความสะอาดตั้งแต่เริ่มต้น นอกจากนี้ ยังช่วยให้การแชร์โมดูลทำได้ง่ายขึ้น ซึ่งก่อนหน้านี้ถือว่าเป็นเรื่องที่คิดไม่ถึงใน Flutter แต่ GetX ทำให้เป็นไปได้อย่างสมบูรณ์
    BLoC เป็นจุดเริ่มต้นสำหรับการจัดระเบียบโค้ดใน Flutter โดยแยกตรรกะทางธุรกิจออกจากการแสดงผล GetX ถือเป็นวิวัฒนาการตามธรรมชาติของแนวคิดนี้ ไม่เพียงแต่แยกตรรกะทางธุรกิจเท่านั้น แต่ยังแยกตรรกะการนำเสนอด้วย นอกจากนี้ dependency injection และการจัดการเส้นทาง (route) ยังแยกออกจากกันอย่างอิสระ และเลเยอร์ข้อมูลก็แยกออกจากส่วนอื่นๆ ทั้งหมด ด้วย GetX คุณจะทราบว่าทุกอย่างอยู่ที่ไหน และทั้งหมดนี้ทำได้ง่ายกว่าการสร้างโปรแกรม "Hello World" เสียอีก
    GetX เป็นวิธีที่ง่ายที่สุด ปฏิบัติได้จริง และปรับขยายได้ง่ายที่สุดในการสร้างแอปพลิเคชันประสิทธิภาพสูงด้วย Flutter SDK GetX มีระบบนิเวศที่หลากหลายรอบๆ ตัวมันเอง ซึ่งทำงานร่วมกันได้อย่างสมบูรณ์ เหมาะสำหรับผู้เริ่มต้นใช้งาน และมีประสิทธิภาพสำหรับผู้เชี่ยวชาญ นอกจากนี้ GetX ยังมีความปลอดภัย เสถียรภาพ และทันสมัย รวมถึงมี API มากมายที่สร้างไว้ภายใน ซึ่งไม่มีอยู่ใน Flutter SDK เริ่มต้น

- GetX ไม่ใช่ไลบรารีที่ใหญ่เกินไป แม้จะมีฟีเจอร์มากมายที่ช่วยให้คุณเริ่มเขียนโปรแกรมได้โดยไม่ต้องกังวล แต่ละฟีเจอร์จะอยู่ในคอนเทนเนอร์แยกต่างหากและจะเริ่มทำงานเฉพาะหลังจากใช้งานเท่านั้น ตัวอย่างเช่น หากคุณใช้แค่ตัวจัดการข้อมูล (State Management) เฉพาะส่วนของ ตัวจัดการข้อมูล (State Management) เท่านั้นที่จะถูกคอมไพล์ ส่วนฟีเจอร์อื่น ๆ จะไม่ถูกคอมไพล์

- GetX มี ecosystem ใหญ่ ชุมชนผู้ใช้ขนาดใหญ่ จำนวนผู้ร่วมพัฒนาจำนวนมาก และจะได้รับการดูแลต่อไปตราบเท่าที่ Flutter ยังคงอยู่ นอกจากนี้ GetX ยังสามารถรันโค้ดเดียวกันบน Android, iOS, Web, Mac, Linux, Windows และบนเซิร์ฟเวอร์ของคุณได้อีกด้วย
  **คุณสามารถนำโค้ดที่เขียนไว้บน Frontend ไปใช้บน Backend ได้อย่างเต็มที่ด้วย [Get Server](https://github.com/jonataslaw/get_server)**.

**นอกจากนี้ กระบวนการพัฒนาทั้งหมดสามารถ automat ได้อย่างสมบูรณ์ ทั้งบนเซิร์ฟเวอร์และบน Frontend ด้วย [Get CLI](https://github.com/jonataslaw/get_cli)**.

**นอกจากนี้ เพื่อเพิ่มผลผลิตของคุณให้มากขึ้น เรามี
[extension to VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) และ [extension to Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# การติดตั้ง

เพิ่ม Get ไปที่ไฟล์ pubspec.yaml:

```yaml
dependencies:
  get:
```

เพิ่ม get โดยการอิมพอร์ตในไฟล์ที่ต้องการใช้:

```dart
import 'package:get/get.dart';
```

# สร้างแอปตัวนับด้วย GetX

counter โปรเจ็กต์ ที่สร้างขึ้นตามค่าเริ่มต้นในโปรเจ็กต์ใหม่บน Flutter มีโค้ดเกินกว่า 100 บรรทัด (รวมคอมเมนต์) เพื่อแสดงพลังของ GetX ผมจะสาธิตวิธีการสร้าง "counter" ที่เปลี่ยนสถานะทุกครั้งที่คลิก สลับหน้าจอ และแชร์สถานะระหว่างหน้าจอทั้งหมดนี้ในรูปแบบที่จัดระเบียบ แยกตรรกะทางธุรกิจออกจากมุมมอง ใช้ง่าย "เพียง 26 บรรทัด รวมคอมเมนต์"

- ขั้นตอนที่ 1:
  เพิ่ม "Get" ก่อนหน้า MaterialApp, จะได้ GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- หมายเหตุ: สิ่งนี้ไม่ได้แก้ไข MaterialApp ของ Flutter, GetMaterialApp ไม่ใช่ MaterialApp ที่ได้รับการแก้ไข มันเป็นเพียงวิดเจ็ตที่กำหนดค่าไว้ล่วงหน้าซึ่งมี MaterialApp เริ่มต้นเป็น child คุณสามารถกำหนดค่านี้ได้ด้วยตนเอง แต่ไม่จำเป็นอย่างแน่นอน GetMaterialApp จะสร้างเส้นทาง แทรกเส้นทาง แทรกการแปล แทรกทุกสิ่งที่คุณต้องการสำหรับการนำทางเส้นทาง หากคุณใช้ Get เพื่อการจัดการสถานะหรือการจัดการ dependency เท่านั้น คุณไม่จำเป็นต้องใช้ GetMaterialApp GetMaterialApp จำเป็นสำหรับเส้นทาง (routes), สแน็คบาร์ (snackbars), การเปลี่ยนข้อมูลท้องถิ่น (internationalization), BottomSheets, ไดอะล็อก (dialogs) และ API ระดับสูง (high-level apis) ที่เกี่ยวข้องกับเส้นทางและไม่มีบริบท
- หมายเหตุ²: ขั้นตอนนี้จำเป็นเฉพาะในกรณีที่คุณใช้การจัดการเส้นทาง (`Get.to()`, `Get.back()` และอื่นๆ) หากคุณจะไม่ใช้ก็ไม่จำเป็นต้องทำขั้นตอนที่ 1

- ขั้นตอนที่ 2:
  สร้างคลาสตรรกะทางธุรกิจของคุณและวางตัวแปร วิธีการ และตัวควบคุมทั้งหมดไว้ข้างใน
  คุณสามารถทำให้ตัวแปรใดๆ สังเกตได้โดยใช้ ".obs" แบบง่ายๆ

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- ขั้นตอนที่ 3:
  สร้างมุมมองของคุณ ใช้ StatelessWidget และประหยัด RAM บางส่วน ด้วย Get คุณอาจไม่จำเป็นต้องใช้ StatefulWidget อีกต่อไป

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // สร้างอินสแตนซ์ชั้นเรียนของคุณโดยใช้ Get.put() เพื่อให้พร้อมใช้งานสำหรับเส้นทาง "ลูก" ทั้งหมดที่นั่น
    final Controller c = Get.put(Controller());

    return Scaffold(
      // ใช้ Obx(()=> เพื่ออัปเดต Text() ทุกครั้งที่มีการเปลี่ยนแปลงการนับ
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // แทนที่ Navigator.push 8 บรรทัดด้วย Get.to() แบบธรรมดา คุณไม่จำเป็นต้องมีบริบท
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // คุณสามารถขอให้ Get ค้นหาคอนโทรลเลอร์ที่เพจอื่นใช้อยู่และเปลี่ยนเส้นทางคุณไปยังคอนโทรลเลอร์นั้น
  final Controller c = Get.find();

  @override
  Widget build(context){
     // เข้าถึงตัวแปรการนับที่อัปเดต
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

ผลลัพธ์:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

นี่เป็นโปรเจ็กต์ที่เรียบง่ายแต่ได้แสดงให้เห็นชัดเจนว่า Get มีประสิทธิภาพเพียงใด เมื่อโครงการของคุณเติบโตขึ้น ความแตกต่างนี้จะมีความสำคัญมากขึ้น

Get ได้รับการออกแบบมาเพื่อทำงานร่วมกับทีม แต่ทำให้งานของนักพัฒนารายบุคคลเป็นเรื่องง่าย

ปรับปรุงกำหนดเวลาของคุณ ส่งมอบทุกอย่างตรงเวลาโดยไม่สูญเสียประสิทธิภาพ Get ไม่ใช่สำหรับทุกคน แต่ถ้าคุณระบุด้วยวลีนั้น Get ก็เหมาะกับคุณ!

# เสาหลัก 3 ประการ

## ตัวจัดการข้อมูล

Get มีตัวจัดการข้อมูลที่แตกต่างกันสองแบบ: ตัวจัดการข้อมูลแบบธรรมดา (เราจะเรียกว่า GetBuilder) และตัวจัดการข้อมูลแบบโต้ตอบ (GetX/Obx)

### ตัวจัดการข้อมูลแบบ Reactive

การเขียนโปรแกรมเชิงโต้ตอบอาจทำให้คนจำนวนมากแปลกแยกเพราะว่ามีความซับซ้อน GetX เปลี่ยนการเขียนโปรแกรมเชิงโต้ตอบให้เป็นสิ่งที่ค่อนข้างง่าย:

- คุณไม่จำเป็นต้องสร้าง StreamControllers
- คุณไม่จำเป็นต้องสร้าง StreamBuilder สำหรับแต่ละตัวแปร
- คุณไม่จำเป็นต้องสร้างคลาสสำหรับแต่ละ state
- คุณไม่จำเป็นต้องสร้าง ตัวรับ ให้เป็นค่าเริ่มต้น
- คุณจะไม่จำเป็นต้องใช้ตัวสร้างโค้ด

การเขียนโปรแกรมแบบโต้ตอบด้วย Get นั้นง่ายเหมือนกับการใช้ setState

ลองจินตนาการว่าคุณมีชื่อตัวแปร และต้องการให้ทุกครั้งที่คุณเปลี่ยน วิดเจ็ตทั้งหมดที่ใช้ตัวแปรนั้นจะถูกเปลี่ยนโดยอัตโนมัติ

นี่คือตัวแปรการนับของคุณ:

```dart
var name = 'Jonatas Borges';
```

ต้องการทำ observable คุณเพียงแค่ต้องเพิ่ม ".obs" ต่อท้าย:

```dart
var name = 'Jonatas Borges'.obs;
```

และใน UI เมื่อคุณต้องการแสดงค่านั้นและอัปเดตหน้าจอทุกครั้งที่ค่าเปลี่ยนแปลง เพียงทำดังนี้:

```dart
Obx(() => Text("${controller.name}"));
```

นั่นคือทั้งหมดที่ มัน _ง่าย_ ขนาดนั้น

### รายละเอียดเพิ่มเติมเกี่ยวกับตัวจัดการข้อมูล

**ดูคำอธิบายเชิงลึกเพิ่มเติมเกี่ยวกับตัวจัดการข้อมูล [ที่นี้](./documentation/en_US/state_management.md). ณจะเห็นตัวอย่างเพิ่มเติมและความแตกต่างระหว่างตัวจัดการข้อมูลแบบธรรมดาและตัวจัดการข้อมูลแบบโต้ตอบ (Reactive)**

คุณจะได้รับแนวคิดดีๆ เกี่ยวกับพลังของ GetX

## ตัวจัดการเส้นทาง (Route management)

If you are going to use routes/snackbars/dialogs/bottomsheets without context, GetX is excellent for you too, just see it:

Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Navigate to a new screen:

```dart

Get.to(NextScreen());
```

Navigate to new screen with name. See more details on named routes [here](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);

```dart
Get.back();
```

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens, etc.)

```dart
Get.off(NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(NextScreen());
```

Noticed that you didn't have to use context to do any of these things? That's one of the biggest advantages of using Get route management. With this, you can execute all these methods from within your controller class, without worries.

### More details about route management

**Get works with named routes and also offers lower-level control over your routes! There is in-depth documentation [here](./documentation/en_US/route_management.md)**

## Dependency management

Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Note: If you are using Get's State Manager, pay more attention to the bindings API, which will make it easier to connect your view to your controller.

Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

**Tip:** Get dependency management is decoupled from other parts of the package, so if for example, your app is already using a state manager (any one, it doesn't matter), you don't need to rewrite it all, you can use this dependency injection with no problems at all

```dart
controller.fetchApi();
```

Imagine that you have navigated through numerous routes, and you need data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "find" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

### More details about dependency management

**See a more in-depth explanation of dependency management [here](./documentation/en_US/dependency_management.md)**

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

```dart
class Controller extends GetController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(data, status: RxStatus.success());
```

RxStatus allow these status:

```dart
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

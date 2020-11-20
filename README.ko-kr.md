![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

_Languages: [English](README.md), [Chinese](README.zh-cn.md), [Brazilian Portuguese](README.pt-br.md), [Spanish](README-es.md), [Russian](README.ru.md), [Polish](README.pl.md), 한국어(이파일)._

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
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

- [Get에 대하여](#Get에-대하여)
- [설치](#설치)
- [GetX를 사용한 Counter 앱](#GetX를-사용한-Counter-앱)
- [세가지 주요점](#세가지-주요점)
  - [상태 관리](#상태-관리)
    - [반응형 상태 관리자](#반응형-상태-관리자)
    - [상태 관리에 대한 자세한 내용](#상태-관리에-대한-자세한-내용)
  - [라우트 관리](#라우트-관리)
    - [라우트 관리에 대한 자세한 내용](#라우트-관리에-대한-자세한-내용)
  - [종속성 관리](#종속성-관리)
    - [종속성 관리에 대한 자세한 내용](#종속성-관리에-대한-자세한-내용)
- [기능들](#기능들)
  - [국제화](#국제화)
    - [번역](#번역)
      - [번역 사용법](#번역-사용법)
    - [지역화](#지역화)
      - [지역 변경](#지역-변경)
      - [시스템 지역](#시스템-지역)
  - [테마 변경](#테마-변경)
  - [기타 고급 API](#기타-고급-API)
    - [선택적 전역 설정과 수동 구성](#선택적-전역-설정과-수동-구성)
    - [지역 상태 위젯들](#지역-상태-위젯들)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [유용한 팁](#유용한-팁)
      - [GetView](#getview)
      - [GetWidget](#getwidget)
      - [GetxService](#getxservice)
- [2.0의 주요 변경점](#2.0의-주요-변경점)
- [왜-Getx인가?](#왜-Getx인가?)
- [커뮤니티](#커뮤니티)
  - [커뮤니티 채널](#커뮤니티-채널)
  - [기여하는 방법](#기여하는-방법)
  - [기사 및 비디오](#기사-및-비디오)

# Get에 대하여

- GetX는 Flutter를 위한 매우 가볍고 강력한 솔루션입니다. 고성능 상태 관리, 지능형 종속성 주입 및 빠르고 실용적인 라우트 관리가 결합되어 있습니다.

- GetX는 라이브러리의 모든 사항에 대해서 **생산성, 성능, 조직화**의 3 가지 기본 원칙을 가지고 있습니다.

  - **성능:** GetX는 성능과 최소한의 리소스 소비에 중점을 둡니다. GetX는 Streams나 ChangeNotifier를 사용하지 않습니다.
  
  - **생산성:** GetX는 쉽고 친숙한 구문을 사용합니다. 원하시는 것보다 Getx에는 항상 더 쉬운 방법이 있습니다. 개발 시간을 아끼고 애플리케이션을 최대 성능으로 제공할 수 있습니다. 
  일반적으로 개발자는 메모리에서 컨트롤러들을 제거하는 데 관심을 가져야합니다. GetX에서는 리소스가 기본적으로 사용되지 않으면 메모리에서 제거되므로 필요하지 않습니다. 만약 메모리에 유지하려면 종속성에서 "permanent : true"를 명시적으로 선언해야합니다. 이렇게하면 시간을 절약 할 수있을뿐만 아니라 불필요한 메모리 종속성이 발생할 위험이 줄어 듭니다. 종속성은 기본적으로 lazy로 로드됩니다.
  
  - **조직화:** GetX는 화면, 프레젠테이션 로직, 비즈니스 로직, 종속성 주입 및 네비게이션을 완전히 분리 할 수 있습니다. 라우트간 전환을 하는데에 컨텍스트가 필요하지 않아 위젯 트리(시각객체)에 독립적입니다. inheritedWidget을 통해 컨트롤러/블록에 접근하는 데 컨텍스트가 필요하지 않아 시각화 계층에서 프레젠테이션 로직과 비즈니스 로직을 완전히 분리됩니다. 이 GetX는 자체 종속성 주입 기능을 사용하여 DI를 뷰에서 완전히 분리하기 때문에 다중 Provider를 통해 위젯 트리에서 컨트롤러/모델/블록으로 주입 할 필요가 없습니다.
  GetX를 사용하면 기본적으로 클린 코드를 가지게 되어 애플리케이션의 각 기능을 쉽게 찾을 수있습니다. 이것은 유지 보수를 용이하게 하며 모듈의 공유가 가능하고 Flutter에서는 생각할 수 없었던 것들도 전부 가능합니다.
  BLoC은 Flutter에서 코드를 구성하기 위한 시작점으로 비즈니스 로직과 시각객체를 분리합니다. Getx는 비즈니스 로직 뿐만 아니라 프레젠테이션 로직을 분리하는 자연스러운 진화입니다. 추가로 종속성 주입과 라우트 또한 분리되고 데이터 계층이 모두로부터 분리됩니다. Hello World를 구현하는 것보다 더 쉽게 모든 것이 어디 있는지 알수 있습니다.  
  Flutter SDK와 함께 GetX를 사용하면 가장 쉽고 실용적이며 확장 가능한 고성능 어플리케이션을 만들수 있습니다. 초보자에게는 쉬우며 전문가에게는 정확하고 완벽하게 동작하는 대규모 생태계가 함께합니다. 안전하고 안정적이며 업데이트되고 기본 Flutter SDK에 없는 광범위한 API 빌드를 제공합니다.

- GetX는 비대하지 않습니다. 아무 걱정없이 프로그래밍을 시작할 수 있는 다양한 기능이 있지만 각 기능은 별도의 컨테이너에 있으며 사용한 후에만 시작됩니다. 만약 상태 관리만 사용하면 오직 상태 관리만 컴파일 됩니다. 라우트만 사용하는 경우 상태 관리는 컴파일되지 않습니다.

- GetX는 거대한 생태계, 대규모 커뮤니티, 수많은 공동 작업자를 보유하고 있으며 Flutter가 존재하는 한 유지됩니다. GetX도 Android, iOS, 웹, Mac, Linux, Windows 및 서버에서 동일한 코드로 실행할 수 있습니다.
**[Get Server](https://github.com/jonataslaw/get_server)를 사용한 백엔드에는 프런트엔드에서 만든 코드를 완전히 재사용 할 수 있습니다.**

**추가로 [Get CLI](https://github.com/jonataslaw/get_cli)를 프런트엔드와 서버 양쪽에서 사용하면 전체 개발 프로세스를 자동화 할 수 있습니다.**

**추가로 생산성 향상을 위해 [VSCode 확장](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)과 [Android Studio/Intellij 확장](https://plugins.jetbrains.com/plugin/14975-getx-snippets)이 있습니다.**

# 설치

pubspec.yaml 파일에 Get 추가:

```yaml
dependencies:
  get:
```

사용할 파일에 Import get:

```dart
import 'package:get/get.dart';
```

# GetX를 사용한 Counter 앱

Flutter의 새 프로젝트에서 기본적으로 생성 되는 "counter" 프로젝트는 100줄이 넘습니다 (코멘트 포함). Get의 힘을 보여주기 위해 클릭 할 때마다 상태를 변경하고, 페이지 사이를 전환하고, 화면 사이의 상태를 공유하는 "counter"를 만드는 방법을 주석이 포함된 26줄의 코드로 보여줄 것입니다.

- 1 단계:
  MaterialApp 에 "Get"을 추가하여 GetMaterialApp 으로 변경합니다.

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- 주석: 이는 Flutter의 MaterialApp을 변경하지 않으며 GetMaterialApp 또한 수정 된 MaterialApp이 아니고, 기본 MaterialApp을 자식으로 갖는 사전 구성된 위젯 일뿐입니다. 수동으로 구성 할 수 있지만 반드시 필요한 것은 아닙니다. GetMaterialApp은 라우트를 생성하고 추가하며, 번역을 추가하고, 라우트 탐색에 필요한 모든 것을 추가합니다. 만약 상태 관리 또는 종속성 관리에만 Get을 사용하는 경우 GetMaterialApp을 사용할 필요가 없습니다. GetMaterialApp은 라우트, 스택바, 국제화, bottomSheets, 다이얼로그 및 컨텍스트 부재와 라우트에 연관된 상위 api들에 필요합니다.
   
- 주석²: 이 단계는 라우트 관리 (`Get.to ()`,`Get.back ()` 등)를 사용하려는 경우에만 필요합니다. 사용하지 않을 경우 1 단계를 수행 할 필요가 없습니다.

- 2 단계:
  비즈니스 로직 클래스를 만들고 모든 변수, 함수, 컨트롤러를 포함하십시오.
  ".obs"를 이용하면 간단히 모든 변수를 observable로 만들수 있습니다.

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- 3 단계:
  StatelessWidget를 이용해 View를 만들어 RAM을 아끼고 StatefulWidget은 더 이상 사용하지 않아도 됩니다.

```dart
class Home extends StatelessWidget {

  // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 "child'에서 사용가능하게 합니다.
  final Controller c = Get.put(Controller());

  @override
  Widget build(context) => Scaffold(
      // count가 변경 될 때마다 Obx(()=> 를 사용하여 Text()에 업데이트합니다.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // 8줄의 Navigator.push를 간단한 Get.to()로 변경합니다. context는 필요없습니다.
      body: Center(child: RaisedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
}

class Other extends StatelessWidget {
  // 다른 페이지에서 사용되는 컨트롤러를 Get으로 찾아서 redirect 할 수 있습니다.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // 업데이트된 count 변수에 연결
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

결론:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

이것은 간단한 프로젝트 이지만 Get이 얼마나 강력한지 명확히 보여줍니다. 프로젝트가 성장하면 차이점이 더 커질 것 입니다.

Get은 팀단위 업무에 맞춰 디자인되었지만 개별 개발자의 작업도 단순화합니다.

마감일을 개선하고 성능의 손실 없이 재시간에 제공하십시오. Get은 모두를 위한 것은 아니지만 위의 설명에 해당사항이 있으면 당신을 위한 것입니다!

# 세가지 주요점

## 상태 관리

Get은 두가지 상태 관리자가 있습니다: 단순 상태관리자(GetBuilder라고 함)와 반응형 상태관리자(GetX/Obx)

### 반응형 상태 관리자

반응형 프로그래밍은 복잡하다고 알려져있기 때문에 많은 사람들에게 소외될 수 있습니다. GetX가 매우 단순하게 반응형 프로그래밍을 바꿉니다:

- StreamControllers를 만들 필요가 없습니다.
- 각 변수에 대해 StreamBuilder를 만들 필요가 없습니다.
- 각각의 상태(state)를 위한 클래스를 만들 필요가 없습니다.
- 초기값을 위한 get이 필요하지 않습니다.
- 코드 생성기를 사용할 필요가 없스빈다.

Get의 반응형 프로그램은 setState를 사용하는 것 만큼 쉽습니다.

매번 변경되기를 원하고 모든 위젯에서 자동적으로 반영되는 변수가 있다고 가정해봅시다.

여기 name 변수가 있습니다:

```dart
var name = 'Jonatas Borges';
```

".obs"만 끝에 추가하여 observable로 만듭니다:

```dart
var name = 'Jonatas Borges'.obs;
```

아래와 같이 간단히 보여주고 싶은 UI에 추가하면 값이 변경될때마다 화면에 업데이트 됩니다:

```dart
Obx(() => Text("${controller.name}"));
```

이게 다 입니다. _정말_ 간단하죠.

### 상태 관리에 대한 자세한 내용

**상태 관리에 대한 자세한 설명은 [여기](./documentation/en_US/state_management.md)를 보십시오. 여기에서 더 많은 예제와 단순 상태 관리자와 반응형 상태 관리자의 차이점을 볼 수 있습니다.**

GetX 능력에 대한 좋은 아이디어를 얻을 수 있습니다.

## 라우트 관리

만약 라우트/스낵바/다이얼로그/bottomsheets을 context 없이 사용하려면 GetX는 훌륭한 대안입니다. 여기를 보십시오:

MaterialApp 앞에 "Get"을 추가해서 GetMaterialApp으로 변경합니다.

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

새로운 화면으로 이동합니다:

```dart

Get.to(NextScreen());
```

명칭으로 새로운 화면으로 이동합니다. 명칭으로 라우트하는 더 자세한 사항은 [여기](./documentation/en_US/route_management.md#navigation-with-named-routes) 있습니다.

```dart

Get.toNamed('/details');
```

스낵바, 다이얼로그, bottomsheets 또는 Navigator.pop(context);로 닫아야 하는 어떤것도 닫게 합니다:

```dart
Get.back();
```

다음 화면으로 이동하고 이전 화면으로 돌아갈 필요가 없는 경우 (스플래시, 로그인화면 등..)

```dart
Get.off(NextScreen());
```

다음 화면으로 이동하고 이전 화면들 모두 닫는 경우 (쇼핑카트, 투표, 테스트에 유용)

```dart
Get.offAll(NextScreen());
```

이러한 작업을 수행하기 위해 컨텍스트를 사용할 필요가 없다는 것을 보셨나요? 이것이 Get 라우트 관리를 사용하는 가장 큰 장점 중 하나입니다. 이를 통해 걱정없이 컨트롤러 클래스 내에서 이러한 모든 메서드를 실행할 수 있습니다.

### 라우트 관리에 대한 자세한 내용

**Get은 명명된 라우트로 작업하고 더 쉬운 방식으로 라우트의 제어를 제공합니다! [여기](./documentation/en_US/route_management.md)에 더 자세한 문서가 있습니다.**

## 종속성 관리

Get은 간단하고 강력한 종속성 관리자를 가지고 있어 Bloc나 Controller와 유사한 클래스를 Provide context, inheritedWidget 없이 1줄의 코드로 끌어낼 수 있습니다:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- 주석: Get의 상태 관리자를 사용중이면 뷰를 controller에 더 쉽게 연결할 수 있는 바인딩 api에 더 주의를 기울이십시오.

사용 중인 클래스에서 클래스를 인스턴스화하는 대신에 Get 인스턴스에서 인스턴스화하면 앱에서 해당 클래스를 사용할 수 있습니다.
그래서 controller(또는 Bloc)를 정상적으로 사용할 수 있습니다.

**팁:** Get 종속성 관리는 패키지의 다른 부분과 분리되어서 예제 앱이 이미 상태 관리자(하나여도 상관없음)를 사용중이면 모두 다시 작성할 필요 없이 아무 문제 없이 종속성 주입을 사용할 수 있습니다.

```dart
controller.fetchApi();
```

여러 경로를 통해 이동했고 controller에 남아있는 데이터가 필요가 있다고 가정하십시오. Get_it이나 Provider와 조합된 상태 관리자가 필요합니다. 맞습니까? Get은 아닙니다. 다른 추가적인 종속성이 필요없이 controller를 Get의 "find"로 찾으면 됩니다:

```dart
Controller controller = Get.find();
//마법처럼 Get이 controller를 찾아서 가져올 것 입니다. 백만개의 인스턴스화 contrller를 가질수 있고 Get은 올바른 controller를 항상 가져다 줄 것입니다.
```

그리고나서 가져온 controller 데이터를 사용할 수 있습니다:

```dart
Text(controller.textFromApi);
```

### 종속성 관리에 대한 자세한 내용

**종속성 관리에 대한 더 제사한 사항은 [여기](./documentation/en_US/dependency_management.md)에 있습니다.**

# 기능들

## 국제화

### 번역

번역은 간단한 key-value 맵으로 유지됩니다.
커스텀 번역을 추가하려면 `Translations`으로 확장하여 클래스를 만드세요.

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

#### 번역 사용법

단지 `.tr`로 명시된 키만 추가하면 `Get.locale`과 `Get.fallbackLocale`의 현재값을 사용해서 번역될 것 입니다.

```dart
Text('title'.tr);
```

### 지역화

`GetMaterialApp`의 파라미터를 전달하여 지역과 번역어를 정의합니다.

```dart
return GetMaterialApp(
    translations: Messages(), // 번역들
    locale: Locale('en', 'US'), // 해당 지역의 번역이 표시
    fallbackLocale: Locale('en', 'UK'), // 잘못된 지역이 선택된 경우 복구될 지역을 지정
);
```

#### 지역 변경

지역을 업데이트할때 `Get.updateLocale(locale)`를 콜하십시오. 새로운 지역을 사용하여 자동적으로 번역합니다.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### 시스템 지역

`Get.deviceLocale`를 사용해서 시스템 지역을 읽어옵니다.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## 테마 변경

테마를 업데이트하기 위해 `GetMaterialApp` 보다 더 상위 위젯을 사용하지 말아 주십시오. 이러면 중복 키가 트리거 될 수 있습니다. 많은 사람들이 테마를 바꾸기 위해 "ThemeProvider" 위젯을 사용하고 있는데 **GetX**는 이런 방식이 필요 없습니다.

다른 표준사항은 없이 `Get.changeTheme`로 추가하고 간단하게 커스텀 테마를 만들수 있습니다:

```dart
Get.changeTheme(ThemeData.light());
```

`onTap`에 테마 변경이 있는 버튼 같은 무언가를 만들고 싶다면 두개의 **GetX™** API를 조합하여 가능합니다:

- 다크`테마`를 사용중인지 확인합니다.
- 그리고 `테마` 변경 API 를 `onPressed`에 넣으면 됩니다:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

`.darkmode`가 활성활 될때 _light theme_ 로 바뀔것 이고 _light theme_ 가 활성화되면 _dark theme_ 로 변경될 것입니다.

## 기타 고급 API

```dart
// give the current args from currentScreen
Get.arguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Rounting API from GetObserver
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

### 선택적 전역 설정과 수동 구성

GetMaterialApp은 모든 것이 구성되어 있지만 원한다면 수동으로 Get을 구성할 수 있습니다.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

`GetObserver`안에 Middleware를 사용할 수 있고 이로 인한 어떤 영향도 없습니다.

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

`Get`을 위한 _Global Settings_ 을 만들수 있습니다. 어떠한 라우트도 포함되기 전에 `Get.config`에 추가하십시오.
또는 `GetMaterialApp`에 직접 추가 하십시오.

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

선택적으로 `Get`으로 모든 로그 메세지를 리다이렉트 할 수 있습니다.
만약 유명한 로그 패키지를 사용하고 싶으면
여기에서 원하는 로그가 있습니다:

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

### 지역 상태 위젯들

이러한 위젯은 단일값을 관리하고 지역적이고 임시적인 상태를 유지합니다.
우리는 반응적이고 단순함을 위해 추가할 수 있습니다.
예를 들어 `TextField`의 obscureText의 전환으로 사용하거나 
커스텀된 확장되는 패널을 만들거나 
`Scaffold`의 body가 변경되는 동안 `BottomNavigationBar`의 현재 index를 수정할 수 있습니다.

#### ValueBuilder

업데이트된 값을 되돌려 받는 `.setState`로 작동하는 `StatefulWidget`의 단순화 입니다.

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

[`ValueBuilder`](#valuebuilder)와 비슷하지만 Rx 인스턴스(마법같은 .obs를 기억하세요)를 전달하고 자동적으로 업데이트되는 반응형 버전입니다... 놀랍지 않습니까?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx에는 호출가능한 함수가 있습니다! (flag) => data.value = flag, 가 사용가능 합니다.
    ),
    false.obs,
),
```

## 유용한 팁

`.obs`(_Rx_ 타입이라고 알려진)는 다양한 내부 메소드와 연산자가 있습니다.

> `.obs`프로퍼티가 **실제 값**이라고 _믿는_ 것은 일반적이지만 실수하지 마십시오!
> 다트의 컴파일러는 충분히 똑똑하고 코드가 깔끔하기 때문에 변수의 타입 선언을 하지 않습니다.
> 하지만:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

`message`가 실제 String 값을 _출력_ 하더라도 타입은 **RxString**입니다!

그래서 `message.substring( 0, 4 )`은 사용하지 못합니다.
_observable(.obs)_ 안의 실제 값에 접근해야 합니다:
가장 많이 사용되는 방법은 `.value`지만 사용할 수 있었는지 알고 있었나요...

```dart
final name = 'GetX'.obs;
// 현재 값과 다른 값이면 stream을 업데이트만 합니다.
name.value = 'Hey';

// 모든 Rx 프로퍼티가 "호출 가능"하고 새로운 값을 반환합니다.
// 하지만 이 접근방식은 `null`를 허용하지 않고 UI가 재구축하지 않습니다.
name('Hello');

// getter와 과 같이 'Hello'를 출력합니다.
name() ;

/// 숫자 타입들:

final count = 0.obs;

// 기존 숫자 타입으로 모든 변형 불가 작업을 사용할수 있습니다.
count + 1;

// 주의하세요! 아래는 `count`가 final이 아닌 경우에만 유효합니다.
count += 1;

// 값들을 비교할 수도 있습니다:
count > 2;

/// booleans:

final flag = false.obs;

// true/false 사이의 전환이 됩니다.
flag.toggle();


/// 모든 타입들:

// `값`을 null로 셋합니다.
flag.nil();

//  모든 toString(), toJson() 함수들은 `값`으로 전달됩니다.
print( count ); // RxInt 내부에서 `toString()`이 호출됩니다.

final abc = [0,1,2].obs;
// 값을 json 배열로 바꾸고 RxList를 출력합니다.
// Json은 모든 Rx 타입들을 지원합니다!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList 그리고 RxSet은 그들의 native 타입들을 확장한 특별한 Rx 타입들입니다.
// 반응형이긴 하지만 일반 list로서 RxList가 동작합니다!
abc.add(12); // list에 12가 들어가고 stream을 업데이트합니다.
abc[3]; // List와 같이 인덱스 3을 읽습니다.


// 동등비교는 Rx와 값에서 동작하지만 해시코드는 항상 값으로부터 받습니다.
final number = 12.obs;
print( number == 12 ); // prints > true

/// 커스텀 Rx 모델들:

// toJson(), toString()은 child에게 지연됩니다. 그래서 이것들을 재정의 하고 직접 관찰하여 print() 할수 있습니다.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user`는 "반응형"이지만 내부 프로퍼티들은 아닙니다!
// 그래서 만약 내부의 변수를 바꾸면...
user.value.name = 'Roi';
// 위젯은 재구성 되지 않을것 입니다!
// user의 내부의 무언가가 바뀌어도 `Rx`는 알 수가 않습니다.
// 그래서 커스텀 클래스들은 수동으로 바뀌었다고 "알릴" 필요가 있습니다.
user.refresh();

// 또는 `update()` 함수를 사용할 수 있습니다!
user.update((value){
  value.name='Roi';
});

print( user );
```

#### GetView

이 위젯을 사랑합니다. 매우 간단하고 유용합니다!

등록된 `Controller`인 `controller`의 gettr로 가져온 `const Stateless`위젯 입니다. 이게 전부입니다.

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // controller를 등록할때 사용한 `타입`을 전달하는 것을 항상 기억하세요!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text( controller.title ), // 단지 `controller.something`을 호출합니다.
     );
   }
 }
```

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
"Hot Reboot" of your app. So remember, if you need absolute persistance of a class instance during the
lifetime of your app, use `GetxService`.

# 2.0의 주요 변경점

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

# 왜 Getx인가?

1- Many times after a Flutter update, many of your packages will break. Sometimes compilation errors happen, errors often appear that there are still no answers about, and the developer needs to know where the error came from, track the error, only then try to open an issue in the corresponding repository, and see its problem solved. Get centralizes the main resources for development (State, dependency and route management), allowing you to add a single package to your pubspec, and start working. After a Flutter update, the only thing you need to do is update the Get dependency, and get to work. Get also resolves compatibility issues. How many times a version of a package is not compatible with the version of another, because one uses a dependency in one version, and the other in another version? This is also not a concern using Get, as everything is in the same package and is fully compatible.

2- Flutter is easy, Flutter is incredible, but Flutter still has some boilerplate that may be unwanted for most developers, such as `Navigator.of(context).push (context, builder [...]`. Get simplifies development. Instead of writing 8 lines of code to just call a route, you can just do it: `Get.to(Home())` and you're done, you'll go to the next page. Dynamic web urls are a really painful thing to do with Flutter currently, and that with GetX is stupidly simple. Managing states in Flutter, and managing dependencies is also something that generates a lot of discussion, as there are hundreds of patterns in the pub. But there is nothing as easy as adding a ".obs" at the end of your variable, and place your widget inside an Obx, and that's it, all updates to that variable will be automatically updated on the screen.

3- Ease without worrying about performance. Flutter's performance is already amazing, but imagine that you use a state manager, and a locator to distribute your blocs/stores/controllers/ etc. classes. You will have to manually call the exclusion of that dependency when you don't need it. But have you ever thought of simply using your controller, and when it was no longer being used by anyone, it would simply be deleted from memory? That's what GetX does. With SmartManagement, everything that is not being used is deleted from memory, and you shouldn't have to worry about anything but programming. You will be assured that you are consuming the minimum necessary resources, without even having created a logic for this.

4- Actual decoupling. You may have heard the concept "separate the view from the business logic". This is not a peculiarity of BLoC, MVC, MVVM, and any other standard on the market has this concept. However, this concept can often be mitigated in Flutter due to the use of context.
If you need context to find an InheritedWidget, you need it in the view, or pass the context by parameter. I particularly find this solution very ugly, and to work in teams we will always have a dependence on View's business logic. Getx is unorthodox with the standard approach, and while it does not completely ban the use of StatefulWidgets, InitState, etc., it always has a similar approach that can be cleaner. Controllers have life cycles, and when you need to make an APIREST request for example, you don't depend on anything in the view. You can use onInit to initiate the http call, and when the data arrives, the variables will be populated. As GetX is fully reactive (really, and works under streams), once the items are filled, all widgets that use that variable will be automatically updated in the view. This allows people with UI expertise to work only with widgets, and not have to send anything to business logic other than user events (like clicking a button), while people working with business logic will be free to create and test the business logic separately.

This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

# 커뮤니티

## 커뮤니티 채널

GetX has a highly active and helpful community. If you have questions, or would like any assistance regarding the use of this framework, please join our community channels, your question will be answered more quickly, and it will be the most suitable place. This repository is exclusive for opening issues, and requesting resources, but feel free to be part of GetX Community.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## 기여하는 방법

_Want to contribute to the project? We will be proud to highlight you as one of our collaborators. Here are some points where you can contribute and make Get (and Flutter) even better._

- Helping to translate the readme into other languages.
- Adding documentation to the readme (a lot of Get's functions haven't been documented yet).
- Write articles or make videos teaching how to use Get (they will be inserted in the Readme and in the future in our Wiki).
- Offering PRs for code/tests.
- Including new functions.

Any contribution is welcome!

## 기사 및 비디오

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


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
    - [지역 State Widgets](#지역-State-Widgets)
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

You will get a good idea of GetX power.

## 라우트 관리

If you are going to use routes/snackbars/dialogs/bottomsheets without context, GetX is excellent for you too, just see it:

Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Navigate to new screen:

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

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens and etc.)

```dart
Get.off(NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(NextScreen());
```

Noticed that you didn't had to use context to do any of these things? That's one of the biggest advantages of using Get route management. With this, you can execute all these methods from within your controller class, without worries.

### 라우트 관리에 대한 자세한 내용

**Get work with named routes and also offer a lower level control over your routes! There is a in-depth documentation [here](./documentation/en_US/route_management.md)**

## 종속성 관리

Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Note: If you are using Get's State Manager, pay more attention to the bindings api, which will make easier to connect your view to your controller.

Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

**Tip:** Get dependency management is decloupled from other parts of the package, so if for example your app is already using a state manager (any one, it doesn't matter), you don't need to rewrite it all, you can use this dependency injection with no problems at all

```dart
controller.fetchApi();
```

Imagine that you have navigated through numerous routes, and you need a data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "find" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

### 종속성 관리에 대한 자세한 내용

**See a more in-depth explanation of dependency management [here](./documentation/en_US/dependency_management.md)**

# 기능들

## 국제화

### 번역

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

#### 번역 사용법

Just append `.tr` to the specified key and it will be translated, using the current value of `Get.locale` and `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

### 지역화

Pass parameters to `GetMaterialApp` to define the locale and translations.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### 지역 변경

Call `Get.updateLocale(locale)` to update the locale. Translations then automatically use the new locale.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### 시스템 지역

To read the system locale, you could use `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## 테마 변경

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

### 지역 State Widgets

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

## 유용한 팁

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

#### GetView

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
       child: Text( controller.title ), // just call `controller.something`
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


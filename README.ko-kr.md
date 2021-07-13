![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**언어: [영어](README.md), [베트남어](README-vi.md), [인도네시아어](README.id-ID.md), [우르두어](README.ur-PK.md), [중국어](README.zh-cn.md), [브라질 포르투칼어](README.pt-br.md), [스페인어](README-es.md), [러시아어](README.ru.md), [폴란드어](README.pl.md), 한국어(이파일), [프랑스어](README-fr.md)**

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

- [Get에 대하여](#get에-대하여)
- [설치](#설치)
- [GetX를 사용한 Counter 앱](#getx를-사용한-counter-앱)
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
  - [GetConnect](#getconnect)
    - [기본 구성](#기본-구성)
    - [커스텀 구성](#커스텀-구성)
  - [GetPage Middleware](#getpage-middleware)
    - [Priority](#priority)
    - [Redirect](#redirect)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [기타 고급 API](#기타-고급-api)
    - [선택적 전역 설정과 수동 구성](#선택적-전역-설정과-수동-구성)
    - [지역 상태 위젯들](#지역-상태-위젯들)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [유용한 팁](#유용한-팁)
      - [GetView](#getview)
      - [GetWidget](#getwidget)
      - [GetxService](#getxservice)
- [2.0의 주요 변경점](#20의-주요-변경점)
- [왜 Getx인가?](#왜-getx인가)
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

  @override
  Widget build(context) {

    // Get.put()을 사용하여 클래스를 인스턴스화하여 모든 "child'에서 사용가능하게 합니다.
    final Controller c = Get.put(Controller());
    
    return Scaffold(
      // count가 변경 될 때마다 Obx(()=> 를 사용하여 Text()에 업데이트합니다.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // 8줄의 Navigator.push를 간단한 Get.to()로 변경합니다. context는 필요없습니다.
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
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
- 코드 생성기를 사용할 필요가 없습니다.

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

**상태 관리에 대한 자세한 설명은 [여기](./documentation/kr_KO/state_management.md)를 보십시오. 여기에서 더 많은 예제와 단순 상태 관리자와 반응형 상태 관리자의 차이점을 볼 수 있습니다.**

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

명칭으로 새로운 화면으로 이동합니다. 명칭으로 라우트하는 더 자세한 사항은 [여기](./documentation/kr_KO/route_management.md#이름있는-라우트-탐색) 있습니다.

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

**Get은 명명된 라우트로 작업하고 더 쉬운 방식으로 라우트의 제어를 제공합니다! [여기](./documentation/kr_KO/route_management.md)에 더 자세한 문서가 있습니다.**

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

여러 경로들을 탐색했고 controller에 남아있는 데이터가 필요가 있다고 가정하십시오. Get_it이나 Provider와 조합된 상태 관리자가 필요합니다. 맞습니까? Get은 아닙니다. 다른 추가적인 종속성이 필요없이 controller를 Get의 "find"로 찾으면 됩니다:

```dart
Controller controller = Get.find();
//마법처럼 Get이 controller를 찾아서 가져올 것 입니다. 백만개의 인스턴스화 contrller를 가질수 있고 Get은 올바른 controller를 항상 가져다 줄 것입니다.
```

그리고나서 가져온 controller 데이터를 사용할 수 있습니다:

```dart
Text(controller.textFromApi);
```

### 종속성 관리에 대한 자세한 내용

**종속성 관리에 대한 더 제사한 사항은 [여기](./documentation/kr_KO/dependency_management.md)에 있습니다.**

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

`.darkmode`가 활성화 될때 _light theme_ 로 바뀔것 이고 _light theme_ 가 활성화되면 _dark theme_ 로 변경될 것입니다.

## GetConnect
GetConnect는 http나 websockets으로 프론트와 백엔드의 통신을 위한 쉬운 방법입니다.

### 기본 구성
GetConnect를 간단하게 확장하고 Rest API나 websockets의 GET/POST/PUT/DELETE/SOCKET 메서드를 사용할 수 있습니다.

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
### 커스텀 구성
GetConnect는 고도로 커스텀화 할 수 있습니다. base Url을 정의하고 응답자 및 요청을 수정하고 인증자를 정의할 수 있습니다. 그리고 인증 횟수까지 정의 할 수 있습니다. 더해서 추가 구성없이 모델로 응답을 변형시킬 수 있는 표준 디코더 정의도 가능합니다.

```dart
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // 모든 요청은 jsonEncode로 CasesModel.fromJson()를 거칩니다.
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // [httpClient] 인스턴트 없이 사용하는경우 Http와 websockets의 baseUrl 정의
    
    // 모든 요청의 헤더에 'apikey' 속성을 첨부합니다.
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // 서버가 "Brazil"이란 데이터를 보내더라도
    // 응답이 전달되기 전에 응답의 데이터를 지우기 때문에 
    // 사용자에게 표시되지 않을 것입니다.
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // 헤더 설정
      request.headers['Authorization'] = "$token";
      return request;
    });

    // 인증자가 HttpStatus가 HttpStatus.unauthorized이면
    // 3번 호출됩니다.
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

GetPage는 GetMiddleWare의 목록을 특정 순서로 실행하는 새로운 프로퍼티를 가집니다.

**주석**: GetPage가 Middleware를 가질때 페이지의 모든 하위는 같은 Middleware를 자동적으로 가지게 됩니다.

### Priority

Middleware의 실행 순서는 GetMiddleware안의 priority에 따라서 설정할 수 있습니다.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```
이 Middleware는 다음 순서로 실행됩니다. **-8 => 2 => 4 => 5**

### Redirect

이 함수는 호출된 라우트의 페이지를 검색할때 호출됩니다. 리다이렉트한 결과로 RouteSettings을 사용합니다. 또는 null을 주면 리다이렉트 하지 않습니다.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

이 함수는 생성되지 않은 페이지가 호출될 때 호출됩니다.
페이지에 대한 어떤것을 변경하는데 사용하거나 새로운 페이지를 줄 수 있습니다.

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

이 함수는 Bindings가 초기화되기 바로 직전에 호출됩니다.
여기에서 이 페이지를 위해 Bindings을 변경할 수 있습니다.

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

이 함수는 Bindings가 초기화된 직후에 호출됩니다.
여기에서 bindings를 생성한 후 페이지 위젯을 생성하기 전에 무엇이든 할 수 있습니다.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

이 함수는 GetPage.page 함수가 호출된 직후에 호출며 함수의 결과를 제공합니다. 그리고 표시될 위젯을 가져옵니다.

### OnPageDispose

이 함수는 페이지의 연관된 모든 오브젝트들(Controllers, views, ...)이 해제된 직후에 호출됩니다.

## 기타 고급 API

```dart
// currentScreen에서 현재 인수들을 제공
Get.arguments

// 이전 경로의 이름을 제공
Get.previousRoute

// rawRoute.isFirst()와 같은 접근에 필요한 원시 경로를 제공
Get.rawRoute

// GetObserver로 부터 Rounting API의 접근을 제공
Get.routing

// snackbar가 열려 있는지 확인
Get.isSnackbarOpen

// dialog가 열려 있는지 확인
Get.isDialogOpen

// bottomsheet가 열려 있는지 확인
Get.isBottomSheetOpen

// 1개의 경로 제거
Get.removeRoute()

// 값이 true가 될때까지 반복적으로 되돌림
Get.until()

// 다음 경로로 이동하고 값이 true가 될때까지 이전 모든 경로를 제거
Get.offUntil()

// 명명된 다음 경로로 이동하고 값이 true가 될때까지 이전 모든 경로를 제거
Get.offNamedUntil()

// 앱이 구동중인 플랫폼을 확인
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

// 장치 타입을 확인
GetPlatform.isMobile
GetPlatform.isDesktop
// 모든 플랫폼은 독립적으로 웹을 제공합니다!
// Windows, iOS, OSX, Android 등의
// 브러우저에서 구동중이면 알 수 있습니다.
GetPlatform.isWeb


// MediaQuery.of(context).size.height 과 동일
// 하지만 불변함.
Get.height
Get.width

// Navigator의 현재 context를 제공
Get.context

// 코드 어디에서든지 foreground에서 snackbar/dialog/bottomsheet의 context를 제공
Get.contextOverlay

// 주석: 다음 메서드는 context의 확장입니다.
// UI의 모든 위치에서 컨텍스트에 액세스 할 수 있으므로 UI 코드의 어느 곳에서나 사용할 수 있습니다.

// 변경되는 height/width(데스크탑이나 브라우저와 같이 늘어날 수 있는 것)가 필요하면 context를 사용해야함
context.width
context.height

// 화면의 절반, 1/3 등을 정의할 수 있는 기능을 제공합니다.
// 반응성이 높은 앱에 유용합니다.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// MediaQuery.of(context).size 와 유사함
context.mediaQuerySize()

/// MediaQuery.of(context).padding 와 유사함
context.mediaQueryPadding()

/// MediaQuery.of(context).viewPadding 와 유사함
context.mediaQueryViewPadding()

/// MediaQuery.of(context).viewInsets; 와 유사함
context.mediaQueryViewInsets()

/// MediaQuery.of(context).orientation; 와 유사함
context.orientation()

/// 장치의 가로 모드 확인
context.isLandscape()

/// 장치의 세로 모드 확인
context.isPortrait()

/// MediaQuery.of(context).devicePixelRatio; 와 유사함
context.devicePixelRatio()

/// MediaQuery.of(context).textScaleFactor; 와 유사함
context.textScaleFactor()

/// 화면에서 shortestSide를 제공
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// shortestSide가 600p 미만이면 True
context.isPhone()

/// shortestSide가 600p 이상이면 True
context.isSmallTablet()

/// shortestSide가 720p 이상이면 True
context.isLargeTablet()

/// 현재 장치가 Tablet이면 True
context.isTablet()

/// 화면 사이즈에 따라 value<T>를 반환
/// 반환될 수 있는 값들:
/// watch: shortestSide가 300 미만일 때
/// mobile: shortestSide가 600 미만일 때
/// tablet: shortestSide가 1200 미만일 때
/// desktop: shortestSide가 1200 이상일 때
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

`.obs`(_Rx_ 타입이라고 알려진)는 다양한 내부 메서드와 연산자가 있습니다.

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

등록된 `Controller`인 `controller`의 getter로 가져온 `const Stateless`위젯 입니다. 이게 전부입니다.

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
       child: Text(controller.title), // 단지 `controller.something`을 호출합니다.
     );
   }
 }
```

#### GetWidget

대부분의 사람들이 이 위젯에대해 모르거나 사용법을 완전히 혼동합니다.
사용 사례는 매우 드물지만 매우 구체적입니다: Controller를 `caches`합니다.
_cache_ 이기 때문에 `const Stateless`가 될 수 없습니다.

> 그러면 언제 Controller를 "cache"할 필요가 있을까요?

만약 **GetX**의 기능 중 또 다른 "흔하지 않은" 기능을 사용하는 경우:`Get.create()`

`Get.create(()=>Controller())`가 `Get.find<Controller>()`을 호출할 때마다 새로운 `Controller`를 생성할 것 입니다.

여기서 `GetWidget`이 빛나게 됩니다... 예를 들어 Todo 리스트를 유지하려고 사용할 때 입니다.
위젯이 "재구성"될때 동일한 controller 인스턴스를 유지할 것입니다.

#### GetxService

이 클래스틑 `GetxController`와 같이 동일한 생성주기(`onInit()`, `onReady()`, `onClose()`)를 공유합니다.
하지만 이안에 "로직"은 없습니다. 단지 **GetX** 종속성 주입 시스템이 하위클래스를 메모리에서 삭제할 수 없음을 알립니다.

그래서 `Get.find()`로 활성화하고 항상 접근하는 "서비스들"을 유지하는데 매우 유용합니다. :
`ApiService`, `StorageService`, `CacheService`.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized()
  await initServices(); /// 서비스들 초기화를 기다림.
  runApp(SomeApp());
}

/// 플러터 앱이 실행되기 전에 서비스들을 초기화하는 현명한 방법입니다.
/// 실행 흐름을 제어 할수 있으므로(테마 구성, apiKey, 사용자가 정의한 언어등을 로드해야 할 필요가 있으므로 
/// ApiService의 구동전에 SettingService를 로드해야 합니다.
/// 그래서 GetMaterialApp()은 재구성하지 않고 직접적으로 값을 가져옵니다.
Future<void> initServices() async {
  print('starting services ...');
  /// 여기에서 get_storage, hive, shared_pref 초기화를 하세요.
  /// 또는 연결 고정 또는 비동기적인 무엇이든 하세요.
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

`GetxService`를 실질적으로 지우는 한가지 방법은 앱의 "Hot Reboot"과 같은 `Get.reset()`뿐 입니다.
따라서 앱 실행중 절대로 유지되어야 하는 클래스 인스턴스가 필요하면 `GetxService`를 사용하세요.

# 2.0의 주요 변경점

1- Rx 타입들:

| 이전    | 이후       |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController와 GetBuilder는 합쳐졌습니다. 더이상 사용할 controller를 기억시킬 필요가 없습니다. GetxController를 사용하세요. 단순 및 반응형 상태관리 모두에서 잘 동작합니다.

2- 명명된 라우트
이전:

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

지금:

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

무엇이 달라졌습니까?
종종 매개 변수 또는 로그인 토큰에 의해 표시 할 페이지를 결정해야 할 수 있습니다. 이전 접근 방식은 이를 허용하지 않았기 때문에 유연하지 않았습니다.
페이지를 함수에 삽입하면 앱이 시작된 이후 라우트가 메모리에 할당되지 않고 이러한 유형의 접근 방식이 가능하기 때문에 RAM 소비가 크게 감소했습니다:

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

1- 플러터가 업데이트된 이후 자주 많은 패키지가 깨졌을 것입니다. 때때로 컴파일중 에러가 발생하고 종종 이에 대해 답변을 해줄 사람이 없었을 겁니다. 그리고 개발자는 에러가 어디에서 발생했는지 추적해서 알아야합니다. 그리고 오직 리포지트리를 통해서 이슈를 오픈하고 해결책을 찾아야합니다. Get은 개발을 위한 주 리소스들(상태, 종속성, 라우트 관리)을 중앙화합니다. pubspec에 단일 패키지를 추가하고 작업을 시작 할 수 있습니다. 플러터가 업데이트 된 이후에도 Get 의존을 업데이트하면 작업할 수 있습니다. Get은 호환성 이슈도 해결합니다. 한 버전에서 종속적으로 사용하여 다른 버전에서 다른 버전을 사용할때 패키지 버전이 다른 버전과 호환되지 않는 경우가 몇 번입니까? 모든 것이 동일한 패키지에 있고 완벽하게 호환되므로 Get을 사용하면 문제가 되지 않습니다.

2- 플러터는 쉽고 놀랍지만 대다수의 개발자들이 원하지 않는 몇가지 상용구가 있습니다. `Navigator.of(context).push (context, builder [...]` 같은 것들 입니다. Get은 개발을 단순화합니다. 라우트를 위해 8줄의 코드를 작성하고 `Get.to(Home())`만 하면 다음 페이지로 갈 수 있습니다. 동적 웹 url은 현재 플러터에서 정말로 고통스러운 것이고 GetX로 하는 것은 정말 간단합니다. 플러터에서 상태와 종속성을 관리하는 것은 pub에서 수백가지의 패턴이라 많은 논의를 생산합니다. 그러나 변수 끝에 ".obs"를 추가하고 위젯을 Obx 안에 배치하는 것만큼 쉬운 것은 없습니다. 이것으로 해당 변수가 업데이트되면 화면에 자동으로 업데이트됩니다.

3- 성능에 대하여 걱정하지 않아도 됩니다. 플러터의 성능은 이미 놀랍습니다. 하지만 상태관리자를 사용하고 blocs/stores/controllers 등의 클래스들을 로케이터로 배포하는 것을 상상해보십시오. 종속성이 필요 없는 경우 종속성 제외를 수동으로 호출해야 합니다. 하지만 간단하게 controller를 사용하고 이것들을 더이상 사용하지 않을때 간단하게 메모리에서 삭제될수 있을까요? 이것이 GetX가 하는 일입니다. SmartManagement를 사용하면 사용하지 않는 모든것이 메모리에서 삭제되기 때문에 프로그래밍 말고 다른 걱정을 할 필요가 없습니다. 이러한 로직을 만들지 않고도 최소한의 리소스만 사용함을 보장합니다.

4- 실질적으로 분리됨. "비즈니스 로직으로부터 뷰를 분리"라는 개념을 들어보셨을 겁니다. 이것은 BLoC, MVC, MVVM의 특징이 아니며 이미 나와 있는 또 다른 표준 개념입니다. 그러나 이 개념은 context의 사용으로 인해 플러터에서 종종 완화됩니다.
만약 InheritedWidget을 찾기 위해 context가 필요하면 뷰나 파라미터로 conetext를 전달해야 합니다. 저는 특히 이 방식이 매우 별로이고 팀의 작업이 항상 뷰의 비즈니스 로직에 의존하게 됩니다. GetX는 표준 접근에서 비정통적이고 StatefulWidgets, InitState 등의 사용을 완전 배제하지 않지만 항상 깔끔하게 유사한 접근을 제공합니다. 예를 들어 Controllers의 수명주기에서 APIREST 요청이 필요할 때 뷰에 어떤 것도 의존할 필요가 없습니다. http 호출의 초기화를 onInit 에서 사용가능 하고 데이터가 도착하면 변수들이 채워집니다. GetX는 완전히 반응형이며(실제 스트림으로 동작) 아이탬중 하나가 채워지면 이 변수를 사용중인 모든 위젯이 자동적으로 화면에서 갱신됩니다. 이를 통해 UI 전문가는 위젯으로만 작업하고 사용자 이벤트(예 : 버튼 클릭) 이외의 비즈니스 로직에 아무것도 보낼 필요가 없으며 비즈니스 로직을 개발하는 사람들은 비즈니스 로직을 별도로 만들고 테스트 할 수 있습니다.

이 라이브러리는 항상 업데이트되고 새로운 기능이 포함됩니다. 자유롭게 PR을 제공하고 여기에 기여하세요.

# 커뮤니티

## 커뮤니티 채널

GetX에는 매우 활동적이고 유용한 커뮤니티가 있습니다. 이 프레임워크의 사용과 관련하여 질문이 있거나 도움이 필요한 경우 커뮤니티 채널에 가입하십시오. 질문에 대한 답변이 더 빨리 제공되며 가장 적합한 장소가 될 것입니다. 이 저장소는 이슈오픈 및 리소스 요청 전용이지만 GetX 커뮤니티의 일부에 속해있습니다.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## 기여하는 방법

_프로젝트에 기여하고 싶으신가요? 우리는 귀하를 우리의 협력자 중 한 명으로 부각시켜 자랑스럽게 생각합니다. 다음은 Get(그리고 플러터)을 더욱 향상시키고 기여할 수 있는 몇 가지 사항입니다._

- readme을 다른 언어로 번역하는 데 도움이 됩니다.
- readme에 문서를 추가합니다(Get의 많은 기능이 아직 문서화되지 않았습니다).
- Get 사용법을 설명하는 기사를 쓰거나 비디오를 만듭니다(읽기 및 향후 위키에 삽입될 예정).
- 코드/테스트에 대한 PR을 제공합니다.
- 새로운 기능을 포함합니다.

어떤 기여도 환영합니다!

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


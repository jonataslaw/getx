# 종속성 관리
- [종속성 관리](#종속성-관리)
  - [인스턴스 메서드](#인스턴스-메서드)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [인스턴스화 된 메서드/클래스 사용](#인스턴스화-된-메서드/클래스-사용)
  - [메서드간의 차이점](#메서드간의-차이점)
  - [바인딩](#바인딩)
    - [사용 방법](#사용-방법)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [변경하는 방법](#변경하는-방법)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [바인딩이 작동하는 자세한 설명](#바인딩이-작동하는-자세한-설명)
  - [주석](#주석)

Get은 Provider context, inheritedWidget 없이 단 1줄의 코드로 Bloc 나 Controller 같은 클래스를 찾을수 있는 간단하고 강력한 종속성 관리자가 있습니다.

```dart
Controller controller = Get.put(Controller()); // Controller controller = Controller(); 대체
```

사용중인 클래스 내에서 클래스를 인스턴스화하는 대신 Get 인스턴스 내에서 인스턴스화하여 앱 전체에서 사용할 수 있습니다.
그러고나면 컨트롤러 (또는 Bloc 클래스)를 정상적으로 사용할 수 있습니다.

- 주석: Get의 상태 관리자를 사용하는 경우 [바인딩](#바인딩) api에 더 많은 주의를 기울여야합니다. 그러면 뷰를 컨트롤러에 더 쉽게 연결할 수 있습니다.
- 주석²: Get의 종속성 관리는 패키지의 다른 부분에서 분리되므로 예를 들어 앱이 이미 상태 관리자를 사용하고있는 경우라도(하나라도 상관 없음) 변경할 필요가 없습니다. 아무 문제 없이 종속성 주입 관리자를 사용할 수 있습니다.

## 인스턴스 메서드
메서드와 구성 파라미터는 다음과 같습니다:

### Get.put()

종속성 인스턴스화의 가장 흔한 방법 입니다. 예를 들어 뷰의 controller들에 좋습니다.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

put 사용시 설정 가능한 모든 사항:
```dart
Get.put<S>(
  // 필수: cotroller나 어떤것이든 get에 저장하려는 클래스  
  // 주석: "S"는 모든 유형의 클래스가 가능합니다.
  S dependency

  // 선택: 동일한 유형의 여러 클래스를 사용하기를 원하면
  // 일반적으로 Get.find<Controller>() 로 클래스를 가져오므로
  // 어떤 인스턴스인지 구분을 위해 tag를 사용해야합니다.
  // 고유한 string 이여야 합니다.
  String tag,

  // 선택: 기본적으로 get은 더이상 사용하지 않는 인스턴스는 dispose 합니다. by default, get will dispose instances after they are not used anymore (example,
  // (예를 들어 뷰의 controller가 닫힌 경우) 하지만 sharedPreferences와 같은 인스턴스는 앱 전체에서 유지되어야 할 필요가 있습니다.
  // 이런 경우 사용합니다.
  // 기본값은 false
  bool permanent = false,

  // 선택: 테스트에서 추상 클래스를 사용한 후에 다른 클래스로 교체하고 테스트를 수행합니다.
  // 기본값은 false
  bool overrideAbstract = false,

  // 선택: 자체 종속성 대신에 함수로 종속성을 생성합니다.
  // 이것은 일반적으로 사용되지 않습니다.
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
인스턴스하게 사용하는 경우에만 의존성을 lazyLoad 할 수 있습니다. 계산 비용이 많이 드는 클래스나 한곳에서 다양한 클래스를 당장 사용하지 않으면서 인스턴스화 하기를 원한다면(Bindings 클래스처럼) 매우 유용합니다.

```dart
/// ApiMock은 처음으로 Get.find<ApiMock>을 사용하는 경우에만 호출됩니다.
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () => {
  // 어떤 로직이 필요하다면 ...
    return FirebaseAuth()
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

lazyPut을 사용시 설정 가능한 모든 사항:
```dart
Get.lazyPut<S>(
  // 필수: 이 메서드는 처음으로 클래스가 호출할 때 실행될 것입니다
  InstanceBuilderCallback builder,
  
  // 선택: Get.put()과 같이 같은 클래스를 다중으로 인스턴스할 경우 사용합니다.
  // 고유값이어야 합니다.
  String tag,

  // 선택: "permanent"와 유사합니다. 차이점은 인스턴스가 사용되지 않으면 폐기되지만
  // 다시 사용할 때 Get이 바인딩 api의 "SmartManagement.keepFactory"와 동일하게 인스턴스를 재생성한다는 것입니다.
  // 기본값은 false
  bool fenix = false
  
)
```

### Get.putAsync
만약 비동기로 인스턴스를 등록하길 원하면 `Get.putAsync`를 사용할 수 있습니다.:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

putAsync 사용시 설정 가능한 모든 사항:
```dart
Get.putAsync<S>(

  // 필수: 클래스를 인스턴스화 하기 위해 실행되는 비동기 메서드입니다.
  AsyncInstanceBuilderCallback<S> builder,

  // 선택: Get.put()과 같이 같은 클래스를 다중으로 인스턴스할 경우 사용합니다.
  // 고유값이어야 합니다.
  String tag,

  // 선택: Get.put()과 같이 앱 유지중에 인스턴스가 활성되어야 하는 경우 사용합니다.
  // 기본값은 false
  bool permanent = false
)
```

### Get.create

이것은 까다롭습니다. 이것이 무엇인지 상세한 설명과 다른것과의 차이점에 대해서는 [메서드간의 차이점:](#메서드간의-차이점) 섹션에서 확인할 수 있습니다.

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

create 사용시 설정 가능한 모든 사항:

```dart
Get.create<S>(
  // 필수: `Get.find()`가 호출 될 때마다 만들어진 클래스를 반환하는 메서드입니다.
  // 예시: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // 선택: Get.put()과 거의 동일하지만 동일 클래스의 여러 인스턴스가 필요할 때 사용합니다.
  // 개개의 리스트별로 controller가 필요한 경우 유용합니다.
  // 고유값이어야 합니다. 단지 tag에서 name으로 변경되었습니다.
  String name,

  // 선택: Get.put()과 같이 앱 유지중에 인스턴스가 활성되어야 하는 경우 사용합니다.
  // Get.create에서 다른점은
  // permanent의 기본값이 true 입니다.
  bool permanent = true
```

## 인스턴스화 된 메서드/클래스 사용

여러 경로를 탐색했고 controller에 남겨진 데이터가 필요하다고 상상해보세요. Provider 또는 Get_it과 결합된 상태 관리자가 필요합니다. 맞습니까? Get은 아닙니다.
어떤 종속적인 추가가 필요 없고 단지 Get에게 controller를 "find"하라고 하면 됩니다:

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// 그렇습니다. 마법 같아요. Get은 controller를 찾고 배달해 줍니다.
// Get은 백만개의 contrller를 인스턴스화해서 가질수 있고 항상 올바르게 전달해 줍니다.
```

그리고 나서 얻어낸 controller에서 데이터를 가져올 수 있습니다:

```dart
Text(controller.textFromApi);
```

반환된 값은 일반 클래스라서 무엇이든 할 수 있습니다:

```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Get의 인스턴스에서 삭제합니다:

```dart
Get.delete<Controller>(); // 보통 GetX는 미사용 controller를 삭제하기 때문에 수행할 필요가 없습니다
```

## 메서드간의 차이점

첫째, Get.lazyPut의 `fenix`와 다른 메서드들의 `permanent`을 살펴보겠습니다.

`permanent`와 `fenix` 사이의 근본적인 다른점은 인스턴스를 저장하는 방법입니다.

보강: 기본적으로 GetX는 사용하지 않을때 인스턴스를 삭제합니다.
의미: 만약 화면 1이 컨트롤러 1을 가지고 있고 화면 2가 컨트롤러 2를 가졌을때 스택에서 첫번째 경로가 제거되면(`Get.off()`나 `Get.offNamed()`를 사용하는 경우) 컨트롤러 1은 사용하지 않아 지워질 것입니다.

하지만 `permanent:true`를 설정하면 컨르롤러가 이런 전환에서 손실되지 않을 것입니다. - 어플리케이션 실행되는 동안에 계속 유지하려고 하는 서비스에 매우 유용합니다.

`fenix` in the other hand is for services that you don't worry in losing between screen changes, but when you need that service, you expect that it is alive. So basically, it will dispose the unused controller/service/class, but when you need it, it will "recreate from the ashes" a new instance.
반면 `fenix`는 화면 전환 사이에 손실이 없어야 하는 서비스를 위해 있습니다. 이 서비스가 필요할 때 그것이 살아 있다고 기대할 것입니다. 그래서 기본적으로 사용하지 않는 controller/service/class를 폐기하지만 필요한 경우 새 인스턴스에서 흔적으로부터 다시 생성합니다.

메서드간 차이점 진행:

- Get.put과 Get.putAsync는 동일한 생성 명령을 따르지만 두번째가 비동기 메서드를 사용하는 것이 차이점입니다: 두 메서드는 인스턴스를 생성하고 초기화 합니다. 이것은 `permanent: false`와 `isSingleton: true` 파라미터들과 내부 `insert` 메서드를 사용하여 메모리에 직접 추가됩니다.(여기의 isSingleton 파라미터의 목적은 `dependency`에 의한 종속성을 사용할 것인지 `FcBuilderFunc`에 의한 종속성을 사용할 것인지 알려주는 것입니다.) 이후에 `Get.find()`는 즉시 초기화한 메모리안의 인스턴스를 호출합니다.

- Get.create: 이름 그대로 종속성을 "생성"합니다! `Get.put()`과 마찬가지로 내부 메서드 `insert`를 호출하여 인스턴스화 합니다. 그러나 `permanent`가 true가 되고 `isSingleton`이 false가 됩니다(종속성을 "생성중"인 상태라 싱글톤 인스턴스가 될 방법이 없어서 false 입니다.) 그리고 `permanent: true`이기 때문에 기본적으로 화면 전환간에 손실되지 않는 장점이 있습니다! 또한 `Get.find()`는 즉시 호출되지 않으며 호출될 화면에서 사용되기를 기다립니다. `permanent` 파라미터를 사용하기 위한 방법으로 만들어졌습니다. 다음의 가치를 가지고 있습니다. 생성을 위한 목적으로 `Get.create()`는 공유되는 인스턴스가 아니지만 폐기되지 않습니다. 예를들어 리스트뷰 안의 버튼은 리스트를 위한 고유한 인스턴스입니다. - 이때문에 Get.create는 GetWidget과 함께 사용되어야만 합니다.

- Get.lazyPut: 이름 그대로 lazy 처리됩니다. 인스턴스가 만들어지나 즉시 사용되도록 호출되지 않고 호출되기를 기다립니다. 다른 메서드와 다르게 `insert`가 여기에서 호출되지 않습니다. 대신 인스턴스는 메모리의 다른 부분에 추가됩니다. 인스턴스가 재생성 가능한지 아닌지를 책임지는 부분으로 "factory"라고 부릅니다. 나중에 사용할 어떤 것을 생성하기 원한다면 지금 사용했던 것과 섞이지 않아야 할 것입니다. 그리고 여기에서 `fenix` 마법이 시작됩니다: `fenix: false`를 그대로두고 `smartManagement`는 `keepFactory`가 아니면 `Get.find`를 사용할 때 인스턴스는 "factory"에서 공통 인스턴스 메모리 영역으로 위치가 변경됩니다. 바로 그뒤에 기본적으로 "factory"에서 제거됩니다. 이제 `fenix: true`로 설정하면 인스턴스는 전용부분에서 계속 존재하며 공통 영역으로 이동하여 미래에 다시 호출됩니다.

## 바인딩

이 패키지의 가장 큰 특이한점 중 하나는 아마도 라우트, 상태 관리자, 종속성 관리자의 완전한 통합의 가능성 일 것입니다.
스택에서 라우트가 삭제되면 모든 컨르롤러, 변수 및 관련된 인스턴스 오브젝트가 메모리에서 제거됩니다. 스트림이나 타이머를 사용중이면 자동적으로 종료되고 이것에 대한 어떤 걱정도 할 필요가 없습니다.
Get의 2.10 버전에는 Bindings API를 완전히 구현했습니다.
이제 init 메서드는 더 이상 사용할 필요가 없습니다. 원하지 않으며 컨트롤러 타입도 필요 없습니다. 컨트롤러와 서비스를 위한 적절한 위치에서 시작할 수 있습니다.
바인딩 클래스는 상태 관리자와 종속성 관리자에 라우트를 "결합"하는 동시에 종속성 주입을 분리하는 클래스입니다.
이를 통해 Get은 특정 컨트롤러가 사용될때 표시되는 스크린을 알고 어디서 어떻게 이것이 제거 되는지 알수 있습니다.
추가로 Binding 클래스로 SmartManager 구성을 제어 할 수 있습니다. 스택에서 경로를 제거하거나 경로를 사용한 위젯이 배치되거나 둘 다 배치되지 않을 때 정렬되도록 종속성을 설정 할 수 있습니다. 지능적으로 종속성 관리가 동작하지만 원하는대로 구성 할 수 있습니다.

### 사용 방법

- class를 생성하고 Binding 포함합니다.

```dart
class HomeBinding implements Bindings {}
```

IDE가 자동적으로 "종속적인" 메서드를 재정의할지 요청하며 램프를 클릭하기만 하면 됩니다. 그리고 메서드를 재정의하고 해당 경로에 사용할 모든 클래스들을 추가하면 됩니다:

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<Service>(()=> Api());
  }
}

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
```

이제 라우트에 라우트, 종속성, 상태 관리자 사이를 연결하는데 해당 바인딩을 사용할 것이라고 알리기만 하면 됩니다.

- 명명된 라우트 사용법:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: DetailsBinding(),
  ),
];
```

- 일반 라우트 사용법:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

이제 어플리케이션의 어디서도 메모리 관리에 대해서 걱정하지 않아도 됩니다. Get이 그것을 처리 할 것입니다.

Binding 클래스는 라우트가 호출될 때 불려집니다. GetMaterialApp의 "initialBinding"에서 모든 종속성을 추가하여 생성할 수 있습니다.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

바인딩을 생성하는 기본 방법은 바인딩을 구현한 클래스를 만드는 것 입니다.
하지만 대안으로 `BindingsBuilder` 콜백을 사용하여 간단하게 원하는 것을 인스턴스화하는 함수를 사용할 수 있습니다.

예시:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

이 방법은 각 라우트에 대해 한개의 바인딩 클래스 만드는 것을 피할수 있어서 더 간단하게 할 수 있습니다.

두 방법 모두 완벽하게 작동하며 취향에 맞춰서 사용하시면 됩니다.

### SmartManagement

GetX는 기본적으로 메모리에서 사용되지 않는 컨트롤러들을 제거합니다. 문제가 생기거나 적절히 사용하지 않는 위젯도 마찬가지 입니다.
이것이 종속성 관리의 `full`모드 입니다.
하지만 GetX 클래스의 제거를 제어하는 방식을 변경하기 원한다면 `SmartManagement` 클래스로 다른 행동을 설정할 수 있습니다.

#### 변경하는 방법

구성을 변경(보통은 필요 없습니다)하려면 이렇게 하세요:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders // 이곳
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

이것이 기본입니다. permanent가 설정되지 않으면 사용되지 않는 클래스를 제거합니다. 대부분의 경우 이 구성을 변경하지 않고 유지하십시오. GetX가 처음이라면 바꾸지 마십시오.

#### SmartManagement.onlyBuilders
이 옵션은 오직 컨트롤러가 `init:`에서 시작되었거나 `Get.lazyPut()`으로 바인딩되어 로드되면 제거됩니다.

`Get.put()`이나 `Get.putAsync()` 또는 다른 접근을 를 사용하면 SmartManagement는 종속성 제거를 위한 권한을 가지지 못합니다.

기본 동작은 SmartManagement.onlyBuilders와 다르게 "Get.put"으로 인스턴스화된 위젯들도 삭제됩니다.

#### SmartManagement.keepFactory

SmartManagement.full과 같이 더이상 사용되지 않으면 종속성이 제거됩니다. 하지만 factory가 유지되어 다시 인스턴스가 필요하면 종속성이 재생성됩니다.

### 바인딩이 작동하는 자세한 설명
바인딩은 다른 화면으로 이동하려고 클릭하는 순간에 임시 factory를 생성합니다. 그리고 화면 전환 애니메이션이 발생하는 즉시 제거됩니다.
이 행위는 매우 빨라 분석기에 등록도 되지 않습니다.
다시 화면으로 이동하면 새로운 임시 factory를 호출하므로 SmartManagement.keepFactory 사용을 선택할 수도 있습니다. 그러나 바인딩을 생성하지 않거나 동일한 바인딩에 대해 모든 종속성을 유지하고 싶다면 도움이 됩니다.
Factory는 적은 메모리만 사용하고 인스턴스를 가지지 않지만 원하는 클래스의 "형태"를 가진 함수를 가집니다.
메모리에서 매우 적은 비용을 가지지만 이 라이브러리의 목적이 최소 리소스를 사용하여 가능한 최대 성능을 가지는 것이라 GetX는 기본적으로 factory를 제거합니다.
가장 편한방법을 취하십시오.

## 주석

- 다중 바인딩을 사용한다면 SmartManagement.keepFactory를 사용하지 마세요. 바인딩을 사용하지 않거나 GetMaterialApp의 initialBinding에 연결한 1개의 바인딩만 설계하세요.

- 바인딩의 사용은 완전히 선택사항입니다. 클래스에서 `Get.put()`과 `Get.find()`를 사용하면 아무 문제없이 컨트롤러가 주어집니다.
그러나 서비스나 다른 추상적인 동작을 원하면 더 나은 구성의 바인딩을 추천합니다.

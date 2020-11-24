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
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [How bindings work under the hood](#how-bindings-work-under-the-hood)
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

Get.put과 Get.putAsync는 동일한 생성 명령을 따르지만 두번째가 비동기 메서드를 사용하는 것이 차이점입니다: 두 메서드는 인스턴스를 생성하고 초기화 합니다. 이것은 `permanent: false`와 `isSingleton: true` 파라미터들과 내부 `insert` 메서드를 사용하여 메모리에 직접 추가됩니다.(여기의 isSingleton 파라미터의 목적은 `dependency`에 의한 종속성을 사용할 것인지 `FcBuilderFunc`에 의한 종속성을 사용할 것인지 알려주는 것입니다.)
- Get.put and Get.putAsync follows the same creation order, with the difference that the second uses an asynchronous method: those two methods creates and initializes the instance. That one is inserted directly in the memory, using the internal method `insert` with the parameters `permanent: false` and `isSingleton: true` (this isSingleton parameter only porpuse is to tell if it is to use the dependency on `dependency` or if it is to use the dependency on `FcBuilderFunc`). After that, `Get.find()` is called that immediately initialize the instances that are on memory.

- Get.create: As the name implies, it will "create" your dependency! Similar to `Get.put()`, it also calls the internal method `insert` to instancing. But `permanent` became true and `isSingleton` became false (since we are "creating" our dependency, there is no way for it to be a singleton instace, that's why is false). And because it has `permanent: true`, we have by default the benefit of not losing it between screens! Also, `Get.find()` is not called immediately, it wait to be used in the screen to be called. It is created this way to make use of the parameter `permanent`, since then, worth noticing, `Get.create()` was made with the goal of create not shared instances, but don't get disposed, like for example a button in a listView, that you want a unique instance for that list - because of that, Get.create must be used together with GetWidget.

- Get.lazyPut: As the name implies, it is a lazy proccess. The instance is create, but it is not called to be used immediately, it remains waiting to be called. Contrary to the other methods, `insert` is not called here. Instead, the instance is inserted in another part of the memory, a part responsable to tell if the instance can be recreated or not, let's call it "factory". If we want to create something to be used later, it will not be mix with things been used right now. And here is where `fenix` magic enters: if you opt to leaving `fenix: false`, and your `smartManagement` are not `keepFactory`, then when using `Get.find` the instance will change the place in the memory from the "factory" to common instance memory area. Right after that, by default it is removed from the "factory". Now, if you opt for `fenix: true`, the instance continues to exist in this dedicated part, even going to the common area, to be called again in the future.

## 바인딩

One of the great differentials of this package, perhaps, is the possibility of full integration of the routes, state manager and dependency manager.
When a route is removed from the Stack, all controllers, variables, and instances of objects related to it are removed from memory. If you are using streams or timers, they will be closed automatically, and you don't have to worry about any of that.
In version 2.10 Get completely implemented the Bindings API.
Now you no longer need to use the init method. You don't even have to type your controllers if you don't want to. You can start your controllers and services in the appropriate place for that.
The Binding class is a class that will decouple dependency injection, while "binding" routes to the state manager and dependency manager.
This allows Get to know which screen is being displayed when a particular controller is used and to know where and how to dispose of it.
In addition, the Binding class will allow you to have SmartManager configuration control. You can configure the dependencies to be arranged when removing a route from the stack, or when the widget that used it is laid out, or neither. You will have intelligent dependency management working for you, but even so, you can configure it as you wish.

### 사용 방법

- Create a class and implements Binding

```dart
class HomeBinding implements Bindings {}
```

Your IDE will automatically ask you to override the "dependencies" method, and you just need to click on the lamp, override the method, and insert all the classes you are going to use on that route:

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

Now you just need to inform your route, that you will use that binding to make the connection between route manager, dependencies and states.

- Using named routes:

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

- Using normal routes:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

There, you don't have to worry about memory management of your application anymore, Get will do it for you.

The Binding class is called when a route is called, you can create an "initialBinding in your GetMaterialApp to insert all the dependencies that will be created.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

The default way of creating a binding is by creating a class that implements Bindings.
But alternatively, you can use `BindingsBuilder` callback so that you can simply use a function to instantiate whatever you desire.

Example:

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

That way you can avoid to create one Binding class for each route making this even simpler.

Both ways of doing work perfectly fine and we want you to use what most suit your tastes.

### SmartManagement

GetX by default disposes unused controllers from memory, even if a failure occurs and a widget that uses it is not properly disposed.
This is what is called the `full` mode of dependency management.
But if you want to change the way GetX controls the disposal of classes, you have `SmartManagement` class that you can set different behaviors.

#### How to change

If you want to change this config (which you usually don't need) this is the way:

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //here
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

It is the default one. Dispose classes that are not being used and were not set to be permanent. In the majority of the cases you will want to keep this config untouched. If you new to GetX then don't change this.

#### SmartManagement.onlyBuilders
With this option, only controllers started in `init:` or loaded into a Binding with `Get.lazyPut()` will be disposed.

If you use `Get.put()` or `Get.putAsync()` or any other approach, SmartManagement will not have permissions to exclude this dependency.

With the default behavior, even widgets instantiated with "Get.put" will be removed, unlike SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Just like SmartManagement.full, it will remove it's dependencies when it's not being used anymore. However, it will keep their factory, which means it will recreate the dependency if you need that instance again.

### How bindings work under the hood
Bindings creates transitory factories, which are created the moment you click to go to another screen, and will be destroyed as soon as the screen-changing animation happens.
This happens so fast that the analyzer will not even be able to register it.
When you navigate to this screen again, a new temporary factory will be called, so this is preferable to using SmartManagement.keepFactory, but if you don't want to create Bindings, or want to keep all your dependencies on the same Binding, it will certainly help you.
Factories take up little memory, they don't hold instances, but a function with the "shape" of that class you want.
This has a very low cost in memory, but since the purpose of this lib is to get the maximum performance possible using the minimum resources, Get removes even the factories by default.
Use whichever is most convenient for you.

## 주석

- DO NOT USE SmartManagement.keepFactory if you are using multiple Bindings. It was designed to be used without Bindings, or with a single Binding linked in the GetMaterialApp's initialBinding.

- Using Bindings is completely optional, if you want you can use `Get.put()` and `Get.find()` on classes that use a given controller without any problem.
However, if you work with Services or any other abstraction, I recommend using Bindings for a better organization.

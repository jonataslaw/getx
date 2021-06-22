- [상태 관리자](#상태-관리자)
  - [반응형 상태 관리자](#반응형-상태-관리자)
    - [장점](#장점)
    - [최대의 성능](#최대의-성능)
    - [반응형 변수 선언하기](#반응형-변수-선언하기)
        - [반응형 상태를 갖는 간단한 방법](#반응형-상태를-갖는-간단한-방법)
    - [변수를 화면에 적용하기](#변수를-화면에-적용하기)
    - [재빌드에 조건 걸기](#재빌드에-조건-걸기)
    - [.obs를 사용하는 방법](#obs를-사용하는-방법)
    - [List를 사용할 때](#list를-사용할-때)
    - [어째서 .value를 사용하는가](#어째서-value를-사용하는가)
    - [Obx()](#obx)
    - [Workers](#workers)
  - [간단한 상태 관리자](#간단한-상태-관리자)
    - [장점](#장점-1)
    - [사용법](#사용법)
    - [controller의 동작 방식](#controller의-동작-방식)
    - [StatefulWidget을 더 이상 사용할 필요없습니다](#statefulwidget을-더-이상-사용할-필요없습니다)
    - [이 패키지의 목표](#이-패키지의-목표)
    - [다른 사용법](#다른-사용법)
    - [고유 ID](#고유-id)
  - [2개의 상태 관리자 섞어쓰기](#2개의-상태-관리자-섞어쓰기)
  - [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# 상태 관리자

GetX는 다른 상태 관리자처럼 Streams나 ChangeNotifier를 사용하지 않습니다. 어째서일까요? GetX를 사용하면 Android, iOS, 웹, Linux, macOS, Linux 용 어플리케이션뿐만 아니라, 서버 어플리케이션도 Flutter/GetX의 문법으로 만들 수 있습니다. 반응 시간을 줄이고, RAM을 효율적으로 사용하기 위해, 우리는 GetValue와 GetStream을 만들었습니다. GetValue와 GetStream은 적은 연산 자원으로 낮은 레이턴시와 높은 퍼포먼스를 보여줍니다. 우리는 이를 토대로 상태관리를 포함해 모든 리소스를 빌드합니다.

- _복잡도_: 어떤 상태관리자들은 복잡하고 매우 비슷한 형태를 띕니다. GetX를 이용하면 모든 이벤트를 위한 클래스를 정의할 필요가 없습니다. 이는 당신의 코드를 매우 깔끔하게 만들어주며, 적을 코드들을 줄여줍니다. 많은 Flutter 개발자들이 이런 이유로 개발을 포기해왔지만, 드디어 상태관리를 해결해줄 엄청나게 간단한 방법이 나왔습니다.
- _code generators에 의존하지 않음_: 당신은 어플리케이션 개발을 위한 로직을 작성하는데 개발시간의 절반을 할애했을 것입니다. 어떤 상태관리자들은 code generator에 의존하여 읽기 쉬운 코드를 작성했을 것입니다. 변수를 바꾸고 build_runner를 실행해야 하는 것은 비생산적일 수 있으며, 심지어 Flutter가 이를 반영되기를 기다리면서 커피 한 잔을 즐겨야 할 정도로 오래 기다릴 수 있습니다. GetX는 모든것을 즉각적으로 반응합니다. code generator에 의존하지 않고, 모든 면에서 당신의 생산성을 높여줍니다.
- _필요없는 context_: 아마 당신은 비즈니스 로직을 UI에 반영하기 위해, 여러 위젯 컨트롤러에 context를 넘겨주었을 것입니다. context를 이용한 위젯을 사용하기 위해, context를 다양한 클래스와 함수들을 이용하여 전달하였을 것입니다. GetX를 이용하면 그럴 필요가 없습니다. context없이 controller만으로 접근하여 사용할 수 있습니다. 말 그대로 아무 의미 없이 context를 파라미터로 넘겨줄 필요가 없습니다.
- _세분화된 컨트롤_: 대부분의 상태관리자들은 ChangeNotifier을 기반으로 동작합니다. ChangeNotifier는 notifyListeners가 호출되면 모든 위젯들에게 알릴 것입니다. 만약 당신 스크린에 수많은 ChangeNotifier 클래스를 갖는 40개의 위젯이 있다면, 한 번 없데이트 할 때마다 모든 위젯들이 다시 빌드될 것입니다. GetX를 이용하면 위젯이 중첩되더라도, 변경된 위젯만 다시 빌드됩니다. 한 Obx가 ListView를 보고있고, 다른 Obx가 ListView 안의 checkbox를 보고있을 때, checkBox 값이 변경죄면, checkBox만 업데이트 되고, ListView 값이 변경되면 ListView만 업데이트 됩니다.
- _**정말** 바뀌었을 때만 재구성_: GetX는 흐름제어를 합니다. '진탁'이라는 Text를 화면에 보여준다고 해봅시다. 만약 당신이 obserable 변수인 '진탁'을 다시 한 번 '진탁'으로 변경한다면, 그 위젯은 재구성되지 않습니다. 왜냐하면 GetX는 '진탁'이 이미 Text로 보여주고 있다는 것을 알고 있기 때문에, 불필요한 재구성을 하지 않습니다. 대부분(모두일 수도 있는) 지금까지의 대부분의 상태관리자들은 스크린에 다시 빌드하여 보여줍니다.

## 반응형 상태 관리자

반응형 프로그래밍은 복잡하다고 말해지기 때문에 많은 사람들이 접하기 힘들게 합니다. GetX는 반응형 프로그래밍을 꽤 간단한 것으로 만들어줍니다:

- StreamControllers를 생성할 필요가 없습니다.
- StreamBuilder를 각 변수마다 생성할 필요가 없습니다.
- 각 상태마다 클래스를 만들어줄 필요가 없습니다.
- 초기값을 위한 get을 만들어줄 필요가 없습니다.

GetX와 함께하는 반응형 프로그래밍은 setState를 사용하는 것만큼 쉽습니다.

이름 변수가 하나 있고, 이 변수가 변경될 때마다 해당 변수를 사용하는 모든 위젯들이 자동적으로 변경된다고 해봅시다.

여기 이름 변수가 있습니다.

```dart
var name = 'Jonatas Borges';
```

이 변수를 observable로 만들고 싶다면, 맨 뒤에 ".obs"만 붙이면 됩니다.

```dart
var name = 'Jonatas Borges'.obs;
```

이게 끝입니다. 정말 쉽죠?

지금부터, 우리는 이런 반응형-".obs"(ervables) 변수들을 _Rx_ 라고 부르겠습니다.

우리가 내부에서 무엇을 했나요? 우리는 `String`의 `Stream`에 초기값인 `"Jonatas Borges"`를 할당했습니다. 우리는 `"Jonatas Borges"`을 사용하는 위젯들에게, 이제 이 변수에 "속한다"고 알리며 이 Rx 변수가 바뀔 때마다, 그 위젯들도 바뀌어야 한다고 알립니다.

이것이 Dart 언어의 기능에 기반한, **GetX의 마법**입니다.

하지만, 알다시피 static 클래스들은 "자동 변경"할 힘이 없기 때문에, `위젯`은 함수 안에 있는 경우에만 변경이 가능합니다.

몇몇 변수를 동일한 범위 내에서 변화시키고 싶을 때, 당신은 `StreamBuilder`를 생성하여 이 변수를 지켜보면서 변화를 감지하고, "연쇄적으로" 중첩된 `StreamBuilder`를 만들 것입니다, 맞죠?

아뇨, 더 이상 `StreamBuilder`를 만들 필요 없습니다. 하지만 static 클래스를 사용한다는 점은 맞아요.

특정한 위젯을 변경하고 싶을 때, 우리는 모양이 비슷한 코드들을 봐야 했습니다. 그건 Flutter 방식이죠. **GetX**를 이용하면 이런 비슷한 모양의 코드는 잊어버릴 수 있습니다.

`StreamBuilder( … )`? `initialValue: …`? `builder: …`? 아뇨, 당신은 그저 `Obx()` 위젯 안에 변수를 넣기만 하면 됩니다.

```dart
Obx (() => Text (controller.name));
```

_당신이 기억해야할 것은?_  `Obx(() =>`만 기억하세요.

당신은 화살표함수를 통해 그 위젯을 `Obx()`으로 전달하는 것입니다. (그 _Rx_ 의 "Observer")

`Obx`는 꽤 스마트하며 `controller.name`이 바뀔 경우에만 바뀔 것입니다.

만약 `name`이 `"John"`이고, 당신이 이를 `"John"` (`name.value = "John"`)으로 바꾼다면, 기존 `value`와 동일하므로 화면상으로 바뀌는 것이 없습니다. 그리고 `Obx`는 리소스를 아끼기 위해 새 값을 무시하고 재빌드하지 않습니다. **놀랍지 않나요?**

> 그래서, 제가 만약 5개의 _Rx_ (observable) 변수를 `Obx`안에 가지고 있다면 아떻게 되나요?

그 변수들 중 **아무거나** 변경이 되었을 때 업데이트 됩니다.

> 그리고 제가 만약 클래스 안에 30개의 변수를 갖고 있고 하나만 업데이트 했다면, 클래스 안의 **모든** 변수가 업데이트 되나요?

아뇨, 단지 그 _Rx_ 변수를 사용하는 **특정한 위젯만** 업데이트 됩니다.

그래서 **GetX**는 _Rx_ 변수의 변경이 있을 때만 화면에 업데이트 합니다.

```
final isOpen = false.obs;

// 아무일도 일어나지 않습니다. 동일한 값이기 때문입니다.
void onButtonTap() => isOpen.value=false;
```
### 장점

**GetX()** 는 업데이트된 것들을 **세부적으로** 제어해야할 때 유용합니다.

어떤 동작을 수행할 때 모든 변수가 수정되어 `고유 ID`가 필요없을 때 `GetBuilder`를 사용하세요. `GetBuilder`는 단 몇줄의 코드로 상태를 변경시켜줍니다(`setState()`처럼). 이것은 단순하면서 CPU에 최소한의 부담을 주며, State 재빌드라는 하나의 목적을 수행하기 위해 가능한한 최소의 리소스를 사용합니다.

**강력한** 상택 관리자가 필요하다면, **GetX**와 함께하세요.

GetX는 변수를 이용하지 않고, 내부에서 모든 것이 `Streams`로 구성된 __flow__ 를 이용합니다. 
모든 것이 `Streams`이기 때문에, 접속사로써 _rxDart_ 를 이용합니다.
모든 것이 `Streams`이기 때문에, 각 "_Rx_ 변수"의 `event`를 주시할 수 있습니다.

말 그대로 _BLoC_ 의 접근 법이며, generator와 decoration 없이 _MobX_ 보다 쉽습니다. 
**모든 것들을** `.obs`를 붙임으로써 _"Observable"_ 하게 만들 수 있습니다.

### 최대의 성능

최소의 재빌드를 위해 똑똑한 알고리즘을 적용하기 위해, **GetX**는 상태가 변했는지 확인하는 comparator를 사용합니다.

당신의 앱에서 에러가 발생하고 상태 변경을 중복하여 보내면, **GetX**는 충돌하지 않도록 보장해줍니다.

**GetX**를 사용하면 `value`가 변경된 경우만 상태가 변경됩니다.
이 점이 **GetX**와 _`computed`를 사용하는 MobX_ 와의 주요 차이점입니다.
2개의 __observable__ 변수를 결합하고 하나만 변경되는 경우, 그 _observable_ 를 참조하는 것 또한 변경됩니다.

**GetX**를 사용하면, 2개의 변수를 결합한 경우 (`Oberver()`와 비슷한)`GetX()`는 정말 상태가 변경된 경우만 재빌드됩니다.

### 반응형 변수 선언하기

변수를 "observable"하게 만드는 방법은 3가지가 있습니다.


1 - 첫 번째 방법: **`Rx{Type}`**.

```dart
// 초기값을 설정하는 것을 추천하지만, 필수는 아닙니다.
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - 두 번째 방법: **`Rx`**와 Dart의 제너릭을 이용 `Rx<Type>`

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// 커스텀 클래스 - 그 어떤 클래스도 가능합니다
final user = Rx<User>();
```

3 - The third, more practical, easier and preferred approach, just add **`.obs`** as a property of your `value`:

3 - 세 번째 방법: 실용적이며 쉽고 선호되는 방법으로, 단순히 **`.obs`**를 `value`의 속성으로 덧붙이는 방법

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// 커스텀 클래스 - 그 어떤 클래스도 가능합니다
final user = User().obs;
```

##### 반응형 상태를 갖는 간단한 방법

알다시피 _Dart_ 는 _null safety_ 가 곧 도입될 것입니다.
이를 대비하기 위해 지금부터, _Rx_ 변수를 항상 **초기값**으로 초기화해주세요.

> 변수를 **GetX** 를 이용하여 _observable_ + _초기값_ 으로 바꾸는 것은 매우 쉽고 실용적입니다.

변수의 맨 뒤에 "`.obs`" 글자를 붙이기만 하면 되고, **이게 다입니다**. 
당신은 변수를 observable 하게 만들었으며 `.value`를 이용하여 _초기값_ 에 접근할 수 있습니다.


### 변수를 화면에 적용하기

```dart
// controller file
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

```dart
// view file
GetX<Controller>(
  builder: (controller) {
    print("count 1 rebuild");
    return Text('${controller.count1.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("count 2 rebuild");
    return Text('${controller.count2.value}');
  },
),
GetX<Controller>(
  builder: (controller) {
    print("sum rebuild");
    return Text('${controller.sum}');
  },
),
```

`count1.value++`를 하면, 다음이 출력됩니다:
- `count 1 rebuild` 
- `sum rebuild`

because `count1` has a value of `1`, and `1 + 0 = 1`, changing the `sum` getter value.

왜냐하면 `count1`은 `1`을 갖고 있고, `1 + 0 = 1`이며 `sum` getter의 값을 변경하기 때문입니다.

`count2.value++`를 하면, 다음이 출력됩니다:
- `count 2 rebuild` 
- `sum rebuild`

왜냐하면 `count2.value`가 바뀌었고 `sum` 결과는 이제 `2`이기 때문입니다.


- 참고: 기본적으로, 동일한 `value`로 변경되더라도, 첫 번째 이벤트는 위젯을 재빌드합니다. 이 동작은 Boolean 변수로 인해 일어납니다.

다음과 같이 했다고 생각해봅시다:

```dart
var isLogged = false.obs;
```

그리고 `ever`에서 이벤트를 발생시키기 위해, 사용자가 "로그인" 되어있는지 확인한다고 해봅시다.

```dart
@override
onInit(){
  ever(isLogged, fireRoute);
  isLogged.value = await Preferences.hasToken();
}

fireRoute(logged) {
  if (logged) {
   Get.off(Home());
  } else {
   Get.off(Login());
  }
}
```

만약 `hasToken`이 `false`라면, `isLogged`에 변화는 없을 것입니다. 그러면 `ever()`는 호출되지 않을 것입니다.
이런 동작을 피하기 위해서, `.value`가 동일한 값으로 변경되더라도 _observable_ 의 첫 변경은 이벤트를 발생시킬 것입니다.

이런 동작을 원하지 않는다면, 다음으로 막을 수 있습니다:
`isLogged.firstRebuild = false;`


### 재빌드에 조건 걸기

또한, Get은 정교한 상태 관리 기능을 제공합니다. 특정 조건에서 이벤트를 조건화할 수 있습니다.(리스트에 요소를 추가하는 등)

```dart
// 첫 번째 parameter: 조건, 반드시 true 혹은 false를 return
// 두 번째 parameter: 조건이 true 일 경우 적용할 새 value 
list.addIf(item < limit, item);
```

decoration 없이, code generator 없이, 복잡함 없이 :smile:

Flutter의 counter 앱을 아시나요? 당신의 Controller 클래스는 아마 다음과 같을 것입니다.

```dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

간단합니다:

```dart
controller.count.value++
```

어디에서 변경되든지 간에 관계없이, counter 변수를 당신의 UI 내에서 업데이트 할 수 있습니다.

### .obs를 사용하는 방법

그 어떠한 것도 obs로 바꿀 수 있습니다. 2가지 방법이 있습니다.

* 클래스 값들을 obs로 바꿀 수 있습니다.
```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* 또는 클래스 전체를 observable로 만들 수 있습니다.
```dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// 인스턴스화 할때
final user = User(name: "Camila", age: 18).obs;
```

### List를 사용할 때

리스트내 요소들과 마찬가지로 리스트 또한 완벽하게 observable로 만들 수 있습니다. 이렇게 하면, 리스트에 요소를 추가하였을 때 자동적으로 그 리스트를 사용하는 위젯들을 리빌드할 수 있습니다.

리스트는 ".value"를 이용할 필요가 없습니다. 놀랍게도 dart api가 ".value" 없이도 사용할 수 있게 만들어줍니다.
불행히도 String, int와 같은 primitive type들은 확장할 수 없기때문에 ".value"가 반드시 필요합니다만, getter와 setter를 이용하면 이러한 문제는 해결됩니다.

```dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // String은 .value가 필요합니다
ListView.builder (
  itemCount: controller.list.length // 리스트는 .value가 필요없습니다.
)
```

당신이 만든 observable 클래스를 만들었을 때, 업데이트를 하는 다른 방법이 있습니다.

```dart
// model 파일에서
// 각 field들을 observable로 만드는 대신, 클래스 전체를 observable로 만들 것입니다.
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}


// controller 파일에서
final user = User().obs;
// when you need to update the user variable:
// user의 변수를 업데이트해야할 때
user.update( (user) { // 이 parameter는 업데이트 하길 원하는 인스턴스 자체입니다.
user.name = 'Jonny';
user.age = 18;
});
// user 인스턴스를 업데이트하는 또다른 방법
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// .value 없이 model의 value에 접근할 수 있습니다.
user().name; // User 클래스가 아니라, user 변수임을 주의하세요 (변수는 소문자 u를 갖고 있습니다.)
```

원하지 않으면 set을 이용하지 않아도 됩니다. "assign"과 "assignAll" api를 이용할 수 있습니다.
"assign" api는 당신의 리스트를 비우고, 채우고 싶은 하나의 요소를 넣을 수 있습니다.
"assignAll" api는 존재하는 리스트를 비우고, 삽입하길 원하는 iterable 객체들을 추가할 수 있습니다.

### 어째서 .value를 사용하는가

code generator와 decoration을 이용하면 `String`과 `int`와 같은 타입에도 '.value'를 이용하지 않아도 되었겠지만, 이 라이브러리의 목표는 외부 종속성을 피하는 것입니다. 우리는 외부 패키지를 이용하지 않고, 간단하고 가벼우며 성능좋은  필수요소들(라우트 관리, 종속성 관리, 상태 관리)을 제공하고, 쾌적한 프로그래밍 환경을 제공하고 싶었습니다.

단 3글자(get)와 콜론(;)만 pubspec에 적고 프로그래밍을 시작하세요. 모든 솔루션들이 기본적으로 제공되며, 쉽고 생산성과 성능 좋게 라우트와 상태 관리를 할 수 있습니다.

이 라이브러리는 완벽한 솔루션임에도 불구하고 단일 상태 관리 패키지보다 가볍습니다. 이 점을 꼭 아셔야 합니다.

만약 `.value`가 code generator처럼 당신을 괴롭힌다면, MobX가 훌륭한 대안으로 Get과 함께 활용할 수 있습니다. pubspec에서 단일 종속성을 원하고, 호환되지 않는 버전의 패키지들을 걱정하지 않고 프로그래밍을 시작하길 원하거나, 상태 업데이트 오류가 상태 관리자나 패키지에서 비롯되는 경우, controller에 사용가능성에 대한 걱정하기 원하지 않고 말그대로 "프로그래밍만"을 하고 싶은 경우, get은 완벽한 방안입니다.

당신이 MobX의 code  generator를 이용하는데 문제가 없었거나 BloC의 boilerplate를 이용하는데 문제가 없었다면, Get을 라우트하는데 쉽게 사용할 수 있을 것이며 상태 관리자를 갖고 있다는 사실을 잊을 것입니다. Get의 SEM과 RSM은 필수적으로 탄생했습니다. 저희 회사에는 90개의 controller가 넘는 프로젝트가 있었는데, 충분히 좋은 디바이스에서도 flutter clean 이후, code generator는 작업을 끝내는데 30분 이상이 걸렸습니다. 당신의 프로젝트에 5, 10, 15개 정도의 controller들만 있다면 어떤 상태 관리자들도 충분히 좋겠지만, 엄청 큰 프로젝트를 진행하고 있다면 code generator는 문제를 일으킬 것입니다. get은 매우 훌륭한 해결책입니다.

누군가 이 프로젝트에 기여하고자 code generator나 비슷한 것을 만들고 있다면, 저는 이 readme로 링크시키겠습니다. 저한테 필요한 것들이 모든 개발자에게 필요한 것들은 아니겠지만, 지금으로써는 MobX와 같은 좋은 솔루션들이 있다고 말할 수 있습니다. 

### Obx()

바인딩을 이용해 Get을 입력하는 것은 불필요합니다. 익명 함수만 받는 GetX 대신 Obx 위젯을 이용할 수 있습니다. 타입을 이용하지 않는다면, 변수를 사용하기 위한 controller 객체를 이용하거나, `Get.find<Controller>().value` 혹은 `Controller.to.value`를 이용하여 value에 접근하면 됩니다. 

### Workers

Worker는 이벤트가 일어났을 때, 특정 콜백함수들을 호출하는 것을 도와줍니다.

```dart
/// 'count1'이 변경될 때마다 호출
ever(count1, (_) => print("$_ has been changed"));

/// 'count1'이 처음으로 변경될 때 호출
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - 'count1'이 변경되고 1초간 변화가 없을 때 호출
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// 'count1'이 변경되고 있는 동안 1초 간격으로 호출
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```
(`debounce`를 제외한)모든 worker들은 `condition` parameter를 가집니다. 이 parameter는 `bool` 이거나 `bool`을 return 하는 콜백함수입니다. 이 `condition`은 `callback` 함수가 언제 실행될지 정의합니다.

모든 worker들은 `Worker` 객체를 return하며, `dispose()`를 이용하여 worker 동작을 취소시킬 수 있습니다.
 
- **`ever`**
_Rx_ 변수가 바뀔 때마다 항상 호출됩니다.

- **`everAll`**
`ever`처럼, `List` _Rx_ 변수가 주어지고 변경될 때마다 호출됩니다. 

- **`once`**
변수가 최초로 변경될 때(한 번만) 호출됩니다.

- **`debounce`**
'debounce'는 검색 함수를 구현하는 데에 매우 유용합니다. API 호출을 타이핑이 모두 끝났을 때만 호출 시킬 수 있습니다. 만약 사용자가 "진탁"을 타이핑한다면, 당신은 'ㅈ,ㅣ,ㄴ,ㅌ,ㅏ,ㄱ'에 해당하는 6번의 검색을 해야할 것입니다. Get을 이용하면 이런 일은 일어나지 않을 것입니다. 왜냐하면 "debounce" Worker는 타이핑이 끝났을 때에만 검색하도록 만들어주기 때문입니다.

- **`interval`**
'interval'은 debounce와 다릅니다. 사용자가 1초에 1000번의 변화를 주는 행동을 한다고 해봅시다. debounce는 마지막 변화가 있은 후, 정해진 시간(기본적으로는 800ms)이 지나면 한 번만 호출됩니다. interval은 정해진 시간동안 사용자의 행동들을 무시합니다. 사용자가 1분동안 1초에 1000번의 변화를 주는 행동을 지속한다면, debounce는 사용자가 행동을 멈춘 후 한 번만 호출됩니다. 1초로 time이 설정된 interval은 매 초마다 1번씩 총 60번 호출되며, 3초로 time이 설정된 interval은 3초마다 1번씩 총 20번 호출 될 것입니다. interval은 엄청 빠른 터치(클릭)를 이용한 어뷰징(abusing)을 막는데 사용하는 데에 사용하기를 추천합니다.(예를 들어 특정 버튼을 눌러 코인을 얻는다고 해봅시다. 1분에 300번의 터치를 한다면, 사용자는 1분에 300코인을 얻을 것입니다. 하지만 interval를 이용하여 3초를 time으로 설정하면 사용자가 300번을 터치하든, 수 천번을 터치하든지 간에 20코인밖에 얻지 못할 것입니다.) 검색과 같이 변화가 api를 통해 쿼리를 호출해야 하는 경우, debounce는 DDos 공격을 막는데 효과적입니다. debounce는 사용자가 타이핑을 멈추길 기다리고, 멈추면  호출되기 때문입니다. 위쪽의 코인 시나리오에 대입해서 생각해보면, 터치를 "멈춘" 때, 코인 1개만 얻을 수 있을 것입니다.
  


- 참고: Worker는 Controller 혹은 클래스를 시작할 때만 사용할 수 있습니다. 그래서 항상 onInit 내에 있거나(권장사항), 클래스 생성자, StatefulWidget의 initState 안에(권장하지는 않지만 부작용은 없습니다.) 있어야 합니다.

## 간단한 상태 관리자

Get은 ChangeNotifier를 사용하지 않고, 엄청나게 가볍고 사용하기 쉬운 상태 관리자를 제공합니다. 이 상태 관리자는 Flutter가 처음인 사람들의 요구를 충족하며 대규모 어플리케이션에서도 문제를 발생시키지 않습니다.

GetBuilder는 여러 상태 컨트롤을 정확하게 해내는 것을 목표로 합니다. 장바구니에 30개의 상품이 있고, 사용자가 하나를 삭제하기 위해 터치(클릭)하면 상품 목록이 업데이트 되어 가격과 품목 수가 줄어든다고 해봅시다. 이런 상황에서 GetBuilder는 매우 유용합니다. 왜냐하면 상태들을 그룹화하여 "연산 로직"없이 한 번에 변경하기 때문입니다. GetBuilder는 이런 상황을 고려하여 만들어졌습니다. 일시적인 상태 변화를 위해 setState를 사용하면 되므로 상태 관리자가 필요없기 때문입니다.

이렇게 하면 개별적 controller를 원하는 경우, 각 ID를 할당해주거나 GetX를 사용할 수 있습니다. 어떤 것을 선택할지 당신에게 달려있지만 이 점을 기억하세요. "개별" 위젯이 많은 경우에는 GetX의 성능이 뛰어나고, 상태 변화가 여러 번 일어나는 경우에는 GetBuilder의 성능이 뛰어납니다.



### 장점

1. 필요한 위젯만 업데이트 해줍니다.

2. ChangeNotifier를 사용하지 않고, 적은 메모리(거의 0mb)를 이용하여 상태 관리를 해줍니다.

3. StatfulWidget을 이용 안 해도 됩니다! Get을 이용하면 더 이상 StatefulWidget이 필요 없습니다. 다른 상태 관리자들을 사용하면, Provider, BLoC, MobX Controller 등의 객체를 갖기 위해 StatefulWidget을 사용해야 합니다. appBar, Scaffold, 그리고 대부분의 위젯들이 StatelessWidget로 구성된 것을 생각해본 적이 있나요? Get은 이 부분도 해결해줍니다. 모든 것들을 Stateless로 만드세요. 하나의 위젯만 업데이트할 필요가 있다면, GetBuilder로 감싸면 해당 상태를 가질 수 있습니다.

4. 당신의 프로젝트를 잘 정돈할 수 있습니다! Controller들은 UI내에 두지 않고, TextEditController나 다른 controller 들을 당신의 Controller 클래스 내에 두세요!

5. 렌더링 된 직후, 위젯을 업데이트하기 위해 이벤트를 발생시킬 필요가 있나요? GetBuilder는 StatefulWidget처럼 "initState"를 갖고 있습니다. 그리고 controller로부터 직접적으로 이벤트를 호출하고, 더 이상 이벤트를 initState내에 배치할 필요가 없습니다. 

6. timers 등과 같은 streams를 닫는 행동을 트리거해야 하나요? GetBuilder는 dispose 또한 갖고 있어서, 위젯이 없어지자마자 dispose를 호출할 수 있습니다.

7. streams는 정말 필요할 때만 사용하세요. StreamController와 StreamBuilder는 controller 안에 정상적으로 사용할 수 있습니다만! 기억하세요. stream은 메모리를 적당히 사용하지만, 남용해서는 안됩니다. 30개의 stream이 동시에 열려있다면 ChangeNotifier보다 안좋습니다(ChangeNotifier는 매우 나쁩니다).

8. RAM의 소모 없이 위젯을 업데이트 하세요. Get은 GetBuilder의 creator ID만 저장하고 필요한 경우에만 해당 GetBuilder만 업데이트 합니다. 수천개의 GetBuilder가 있어도 get은 ID를 저장하는데 매우 적은 메모리를 사용합니다. 새 GetBuilder를 생성한다면, creator ID를 갖고 있는 GetBuilder의 상태를 공유합니다. 각 GetBuilder의 새 상태는 생성 되지 않기 때문에 큰 규모의 어플리케이션에서도 **많은** RAM 자원을 절약합니다. 기본적으로 당신의 어플리케이션은 전반적으로 Stateless 이고, 극히 일부의 위젯만 단일 상태를 가진 (GetBuilder를 포함한)Stateful일 것이기 때문에, 하나의 업데이트만으로 그것들을 전부 업데이트 합니다. 상태는 단  하나뿐입니다.

9. Get은 전지적으로 대부분의 경우 어느 타이밍에 메모리에서 제거해야할 지 알 고 있습니다. 당신은 언제 컨트롤러를 dispose해야하는지만 걱정하세요.

### 사용법

```dart
// GetxController를 상속(extends)하는 controller 클래스를 만드세요
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // increment()가 호출되었을 때, counter 변수가 변경되어 UI에 반영되어야 한다는 것을 update()로 알려주세요
  }
}
// 당신의 Stateless/Stateful 클래스에서, increment()가 호출되었을 때 GetBuilder를 이용해 Text를 업데이트 하세요
GetBuilder<Controller>(
  init: Controller(), // 맨 처음만! 초기화(init)해주세요
  builder: (_) => Text(
    '${_.counter}',
  ),
)

// controller는 처음만 초기화하면 됩니다. 같은 controller로 GetBuilder를 또 사용하려는 경우에는 init을 하지 마세요.
// 중복으로 'init'이 있는 위젯이 배치되자마자, controller는 자동적으로 메모리에서 제거될 것입니다.
// 걱정하실 필요 없이, Get은 자동적으로 controller를 찾아서 해줄겁니다. 그냥 2번 init하지 않는 것만 하시면 됩니다. 
```

**끝입니다!**

- 당신은 이미 Get을 이용하여 상태관리를 어떻게 하는지 다 배우셨어요!

- 참고: 큰 규모의 프로젝트를 진행하면서 init 속성을 사용하지 않을 수도 있습니다. 그럴 때에는, Binding 클래스를 상속(extends)한 클래스를 만들고, 그 클래스 내에서 해당 라우트에 생성되어야 하는 controller를 선언하세요. controller가 즉각적으로 만들어지지는 않지만, controller가 처음 사용될 때 Get이 알아서 잘 만들어줄 것입니다. Get은 lazyLoad를 지원하며, controller가 더 이상 필요하지 않을 때 dispose를 해줍니다. 사용예제는 pub.dev에서 확인하세요.

수많은 라우트를 진행하면서 예전에 사용하였던 controller의 데이터가 필요하면, GetBuilder를 다시 사용하시면 됩니다 (init 없이):

```dart
class OtherClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<Controller>(
          builder: (s) => Text('${s.counter}'),
        ),
      ),
    );
  }

```

GetBuilder 밖의 여러 곳에서 controller를 사용해야 하는 경우, 간단하게 Controller 클래스 안의 getter로 접근할 수 있습니다. (아니면 `Get.find<Controller>()`를 사용하세요)

```dart
class Controller extends GetxController {

  /// You do not need that. I recommend using it just for ease of syntax.
  /// with static method: Controller.to.increment();
  /// with no static method: Get.find<Controller>().increment();
  /// There is no difference in performance, nor any side effect of using either syntax. Only one does not need the type, and the other the IDE will autocomplete it.
  static Controller get to => Get.find(); // add this line

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

그리고 아래와 같은 방법으로, controller에 바로 접근하세요:

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

FloatingActionButton을 눌렀을 때, counter 변수를 주시(listen)하고 있는 위젯은 자동적으로 업데이트됩니다.

### controller의 동작 방식

아래와 같은 상황을 가정해보겠습니다:

`Class A => Class B (has controller X) => Class C (has controller X)`

A 클래스에서 controller를 아직 사용하지 않았기 때문에, controller는 메모리에 없습니다(Get은 lazyLoad를 지원합니다). B 클래스에서는 controller를 사용하기 때문에 메모리에 로드됩니다. C 클래스에서는 B 클래스에서 사용한 controller와 같은 controller를 사용하기 때문에, Get은 B의 controller와 C의 controller의 상태를 공유하며, 그 동일한 controller는 여전히 메모리에 있습니다. 그리고 C 화면과 B 화면을 닫으면, Get은 자동적으로 controller X (B와 C에서 쓰인 controller)를 메모리에서 해제해줄 것입니다. 왜냐하면 A 클래스에서는 controller X를 사용하지 않기 때문이죠. 만약 B 화면으로 라우팅한다면 controller X는 다시 메모리에 로드됩니다. 그리고 C 화면으로 라우팅되는 대신, A 화면으로 되돌아간다면 같은 방식으로 controller X는 메모리에서 해제됩니다. 만약 클래스 C에서 controller를 사용하지 않고, 클래스 B가 메모리에서 해제된다면, controller를 사용하는 클래스가 없기 때문에 같은 방식으로 controller는 메모리에서 해제됩니다. Get이 에러날 수 있는 유일한 예외 상황은 B가 예기치않게 라우트 상에서 제거되고, C에서 controller를 사용하려고 하는 경우입니다. 이 경우, B에 있던 controller의 creator ID가 제거되는데, Get은 creator ID를 갖고 있지 않은 controller는 메모리에서 제거하도록 프로그래밍되어 있습니다. 이런 일을 원하지 않으신다면, "authoRemove: false" 플래그를 B 클래스의 GetBuilder에 추가하고, "assignId: true"를 C 클래스의 GetBuilder에 추가해주세요.

### StatefulWidget을 더 이상 사용할 필요없습니다

SatefullWidget을 사용한다는 것은 위젯을 최소한으로 재빌드해야하는 경우에도, 위젯을 Consumer / Oberver / BlocProvider / GetBuilder / GetX / Obx 안에 넣어줄 것이기 때문에, 또다른 StatefulWidget을 사용하는 것과 마찬가지이므로 화면 전체의 상태를 불필요하게 저장합니다. StatefulWidget 클래스는 StatelessWidget 클래스보다 더 많은 RAM 할당이 필요한 큰 규모의 클래스입니다. 1개나 2개 정도의 클래스라면 별 차이가 없겠지만, 100개 이상부터는 차이가 있을 것입니다! TickerProviderStateMixin과 같은 mixin이 필요없는 경우, Get을 사용하면 StatefulWidget은 필요 없습니다.

StatefulWidget에서 메소드를 직접적으로 호출하는 것처럼, Getbuilder를 통해 메소드를 호출할 수 있습니다.
initState()나 dispose()를 호출할 필요가 있을 때에도, 직접적으로 호출할 수 있습니다.

```dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

위 방법보다 더 좋은 방법은 Controller에서 onInit()과 onClose()를 이용하는 것입니다.

```dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

- 참고: controller가 처음 불려졌을 때 어떤 메소드가 호출되길 원하는 경우, (좋은 성능을 목표로하는 Get 패키지를 이용하면)이를 위해서 생성자를 **사용할 필요가 없습니다**. 생성자를 사용한다는 것은 controller가 생성되거나 할당되었을 때의 로직에서 벗어나는 일이기 때문에 좋지 않습니다. (controller 객체를 생성하려하면 생성자는 즉시 호출되며, controller를 사용하기 이전부터 메모리에 로드됩니다. 이러한 동작은 이 라이브러리의 성능을 저해합니다.) onInit()과 onClose()는 이를 위해 만들어졌습니다. Get.lazyPut하는지 여부에 따라, controller가 생성되거나 처음 사용될 때 onInit()과 onClose()가 호출됩니다. API를 호출하기 위한 데이터를 초기화 등을 위해 구식 방식의 initState/dispose를 사용하는 대신 onInit()을 사용하고, stream을 닫는 등의 동작이 필요하면 onClose()를 사용하세요. 

### 이 패키지의 목표

이 패키지의 목표는 당신에게 최소의 종속성(pubspec의 dependencies)으로 라우트/상태/종속성 관리를 위한 완전한 솔루션을 제공하는 것입니다. Get은 어떤 종속성에서도, 어떤 버전의 Flutter API를 사용하더라도 동작하도록 보장해줍니다. 어떤 종속성에서도 당신의 프로젝트가 동작하도록 단일 패키지로 모든 것을 집약하였습니다. 이런 방법으로 당신은 화면상 위젯들만 신경쓰고, 팀원 중 일부는 비즈니스 로직에만 신경쓸 수 있도록 하였습니다. 이 점은 당신에게 더 나은 작업환경을 제공합니다.  팀원 중 일부는 controller에 보내지는 데이터에 신경 쓰지 않고 위젯에만 집중하고, 다른 팀원들은 위젯 배치에는 신경쓰지 않고 비즈니스 로직에만 집중하여 작업할 수 있습니다.

간단히 말하면: 여러 메소드들을 initState에서 호출할 필요도 없고, 메소드들을 parameter로 controller에 넘겨줄 필요 없고, controller 생성자를 호출할 필요도 없습니다. 여러분의 서비스가 시작하고 호출되는 onInit()를 이용하면 됩니다. 그리고 controller가 더 이상 필요 없을 때 메모리에서 제거 될 때 호출되는 onClose()를 이용하세요. 이 방법으로 화면 구성은 위젯 배치만 신경써도 되게 해줍니다.

GetxController 안에서 dispose를 호출하지 마세요. 아무동작도 하지 않을 뿐더러 controller는 위젯이  아니기 때문에 "dispose"할 수 없다는 점을 기억하세요. Get에 의해 자동적으로 똑똑하게 메모리에서 해제 될 것입니다. 만약 stream들을 닫고 싶다면 onClose() 메소드 안에서 닫아주세요. 예를 들어:

```dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// dispose가 아니라 onClose()에서 stream을 닫으세요
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Controller 생명 주기:

- onInit()은 생성되었을 때 호출
- onClose()는 delete 메소드를 준비하기 위해 닫히는 경우
- deleted: controller가 메모리에서 해제되어 더 이상 API에 접근할 수 없을 때. 말 그대로 삭제되어 추적할 수 없습니다.

### 다른 사용법

Controller 객체를 GetBuilder 안에서 value로 직접 접근할 수 있습니다:

```dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', // 여기!
  ),
),
```

GetBuilder 바깥에서도 controller 객체가 필요하면, 다음과 같이 접근할 수 있습니다:

```dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// 화면상
GetBuilder<Controller>(  
  init: Controller(), // 각 controller를 처음 사용할 때 init 하세요
  builder: (_) => Text(
    '${Controller.to.counter}', // 여기!
  )
),
```

아니면

```dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // static get 없이
[...]
}
// stateless/stateful 클래스에서
GetBuilder<Controller>(  
  init: Controller(), // 각 controller를 처음 사용할 때 init 하세요
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // 여기!
  ),
),
```

- "비표준"적인 방식의 접근도 다음과 같이 가능합니다. get_it, modular 등과 같은 다른 종속성 관리자를 사용한다면, 아래와 같이 controller 객체를 전달해줄 수 있습니다:

```dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, // 여기!
  builder: (_) => Text(
    '${controller.counter}', // 여기!
  ),
),

```

### 고유 ID

GetBuilder로 위젯의 업데이트를 좀 더 세분화하여 다루고 싶다면, 고유 ID를 부여하세요:

```dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // 각 controller를 처음 사용할 때 init 하세요
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', // 여기!
  ),
),
```

그리고 다음과 같이 update 하세요:

```dart
update(['text']);
```

또, update하는데 조건도 줄 수 있습니다:

```dart
update(['text'], counter < 10);
```

GetX는 위젯이 정말 값이 변경되었을 때에만 재빌드합니다. 만약 변수의 값이 전과 같은 값으로 변경되었다면, GetX는 메모리와 CPU 자원을 아끼기 위해 재빌드하지 않습니다.(화면에 3이라는 숫자가 보여지고 있고, 그 숫자가 다시 3으로 변경된 경우를 가정하겠습니다. 대부분의 상태 관리자들은 이러한 경우에 재빌드를 합니다만, GetX를 사용하면 정말 값이 변경되었을 때에만 재빌드를 합니다.)

## 2개의 상태 관리자 섞어쓰기

단 하나의 반응변수(.obs)와 다른 메커니즘(update())가 모두 필요해서 Getbuilder 안에 Obx를 넣어야 하는 경우가 필요했습니다. 이 경우를 위해 MixinBuilder가 만들어졌습니다. ".obs"변수의 값이 바뀔 때 즉각적으로 바뀌는 것과 update()를 통해 바뀌는 것 모두를 지원합니다. 하지만, 이 위젯이 GetBuilder, GetX, Obx 보다 더 많은 리소스를 필요로합니다. 왜냐하면 controller의 update() 메소드와 자식으로부터의 .obs 변수의 변화를 주시하고 있어야 하기 때문입니다.

GetxController를 상속(extends)하는 것은 중요합니다. onInit()과 onClose()에서 "시작"과 "종료" 이벤트를 수행할 수 있는 생명 주기를 갖고 있기 때문입니다. 이를 위해서 어떤 클래스를 사용해도 괜찮지만, obervable한 변수든 아니든 간에 GetXController를 사용해 변수를 다루길 적극 권장합니다.


## GetBuilder vs GetX vs Obx vs MixinBuilder

10년간 프로그래밍을 하며 일해오면서, 귀중한 교훈을 얻을 수 있었습니다.

반응형 프로그래밍을 처음 접했을 때 "와, 진짜 굉장한데!"라고 느꼈고, 실제로도 반응형 프로그래밍은 정말 놀랍습니다. 하지만, 모든 상황에서 올바르지는 않습니다. 많은 경우 2개내지 3개의 위젯의 상태를 동시에 변경하거나 일시적으로 변경해야하는데, 반응형 프로그래밍은 나쁘지 않지만 적적하지 않습니다.

반응형 프로그래밍은 각각의 워크플로우를 위한 RAM 자원을 많이 필요로 합니다. 하나의 위젯만이 재빌드 되어야 하는 경우는 괜찮지만, 리스트에 80개 가량의 요소가 있고, 각각 stream이 있을 경우에는 좋지 않습니다. dart inspect 창을 열고 StreamBuilder가 얼마나 많은 리소스를 사용하는지 보신다면, 제 말이 이해가 가실겁니다.

이런 생각에, 저는 간단한 상태 관리자를 만들었습니다. 간단합니다. 그리고 이것이 여러분이 정말 요구하는 것이에요: 블록 단위로 매우 경제적이고 간단하게 상태를 업데이트합니다. 

`GetBuilder`는 RAM의 측면에서 가장 경제적입니다. 이보다 더 경제적인 방법은 없을 겁니다(만약 그런 방법을 고안하신다면, 꼭 저희에게 알려주세요!)

하지만 `GetBuilder`는 수동적인 상태 관리자입니다. Provider의 notifyListeners()를 호출하는 것처럼 update()를 호출해야만 합니다.

반응형 프로그래밍이 정말 도움이 되는 상황들이 많습니다. 이를 활용하지 않는건 바퀴를 다시 만드는 것과 마찬가지입니다. 이런 생각에, `GetX`는 상태 관리자로 가장 현대적이고 높은 수준의 기능들을 제공하기 위해 만들어졌습니다. 이것은 필요한 것들을 필요한 때에 업데이트합니다. 만약 에러가 있고 300개의 상태가 동시에 변경되면, `GetX`는 화면상에 반영되어야할 것들만 필터링하여 업데이트 합니다.

`GetX`는 다른 반응형 상태 관리자들보다 경제적이지만, `GetBuiler`보다 조금 더 RAM을 소모합니다. 능동적이면서 RAM의 최대한 효율적으로 사용하기 위해 `Obx`가 만들어졌습니다. `GetX`와 `GetBuilder`와 다르게 `Obx`안에서 controller를 초기화할 수 없습니다. 단지 자식으로부터 변화를 감지하는 StreamSubscription을 갖고 있는 위젯일 뿐입니다. `Obx`는 `GetX`보다는 경제적이지만 `GetBuilder`보다는 덜 경제적입니다. 왜냐하면 `Obx`는 반응적이고, `GetBuilder`는 위젯의 해시코드와 StateSetter만 저장하는 최적의 접근 방식을 갖고 있기 때문입니다. `Obx`를 이용하면 controller의 타입을 적어줄 필요가 없고, 여러 개의 다른 controller 변화를 감지합니다. 하지만 사용 전에 초기화거나, readme에 있는 예제처럼 사용하거나, Binding 클래스를 사용해야 합니다.

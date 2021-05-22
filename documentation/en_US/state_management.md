* [Quản lý State](#state-management)
  + [Quản lý Reactive State](#reactive-state-manager)
    - [Lợi thế](#advantages)
    - [Hiệu suất tối đa:](#maximum-performance)
    - [Khai báo một biến phản ứng (reactive variable)](#declaring-a-reactive-variable)
        - [Thât dễ khi có reactive state.](#having-a-reactive-state-is-easy)
    - [Sử dụng values trong View](#using-the-values-in-the-view)
    - [Điều kiện để tái tạo lại](#conditions-to-rebuild)
    - [Nơi .obs có thể dùng](#where-obs-can-be-used)
    - [Chí ú về Lists](#note-about-lists)
    - [Tại sao tôi phải dùng .value](#why-i-have-to-use-value)
    - [Obx()](#obx)
    - [Workers](#workers)
  + [Quản lý State đơn giản](#simple-state-manager)
    - [Lợi thế](#advantages-1)
    - [Sử dụng](#usage)
    - [Cách GetX sử dụng controllers](#how-it-handles-controllers)
    - [Không cần StatefulWidget nữa!](#you-wont-need-statefulwidgets-anymore)
    - [Tại sao GetX tồn tại?](#why-it-exists)
    - [Cách sử dụng khác](#other-ways-of-using-it)
    - [IDs độc nhất](#unique-ids)
  + [Trộn hai trình quản lý state](#mixing-the-two-state-managers)
  + [GetBuilder vs GetX vs Obx vs MixinBuilder](#getbuilder-vs-getx-vs-obx-vs-mixinbuilder)

# Quản lý State

GetX không sử dụng Streams hoặc ChangeNotifier như các quản lý state khác. Tại sao? Ngoài việc xây dựng các ứng dụng cho android, iOS, web, linux, macos và linux, với GetX bạn có thể xây dựng các ứng dụng máy chủ với cú pháp tương tự như Flutter / GetX. Để cải thiện thời gian phản hồi và giảm mức tiêu thụ RAM, chúng tôi đã tạo GetValue và GetStream, là các giải pháp có độ trễ thấp mang lại nhiều hiệu suất với chi phí vận hành thấp. Chúng tôi sử dụng cơ sở này để xây dựng tất cả các nguồn lực của mình, bao gồm cả quản lý state.

* _Phức hợp_: Một số quản lý state rất phức tạp và có rất nhiều cơ sở hạ tầng. Với GetX, bạn không phải xác định một class cho mỗi event, code rất rõ ràng và rõ ràng, và bạn làm được nhiều việc hơn bằng cách viết ít hơn. Nhiều người đã từ bỏ Flutter vì chủ đề này, và cuối cùng họ đã có một giải pháp đơn giản đến mức đần độn để quản lý các state.
* _Không trình tạo mã_: Bạn dành một nửa thời gian phát triển để viết logic ứng dụng của mình. Một số quản lý state dựa vào trình tạo mã để có mã có thể đọc được ở mức tối thiểu. Việc thay đổi một biến và phải chạy build_runner có thể gây mất hiệu quả, chuyện này rất ngốn thời gian chờ đợi sau khi quét sạch sẽ rất lâu và bạn phải uống rất nhiều cà phê.

Với GetX, mọi thứ đều hoạt động và độc lập với trình tạo mã, giúp tăng năng suất của bạn trong mọi khía cạnh phát triển của bạn.

* _Không phụ thuộc vào context_: Có thể bạn đã cần gửi context của chế độ xem của mình tới controller, làm cho khả năng kết hợp của View với business logic của bạn cao hơn. Bạn có thể phải sử dụng một dependency cho một nơi không có context và phải chuyển context qua các class và hàm khác nhau. Điều này không tồn tại với GetX. Bạn có quyền truy cập vào controller của mình từ bên trong controller mà không cần bất kỳ context nào. Bạn không cần phải gửi context theo tham số vì không có gì theo nghĩa đen.
* _Kiểm soát hạt_: Hầu hết các quản lý state đều dựa trên ChangeNotifier. ChangeNotifier sẽ thông báo cho tất cả các widget phụ thuộc vào nó khi thông báo cho các widget được gọi. Nếu bạn có 40 widget con trên một màn hình, trong đó có một biến thuộc class ChangeNotifier của bạn, khi bạn cập nhật một widget con, tất cả chúng sẽ được xây dựng lại.

Với GetX, ngay cả các widget lồng nhau cũng được tôn trọng. Nếu bạn có Obx đang xem ListView của bạn và người khác đang xem hộp kiểm bên trong ListView, thì khi thay đổi giá trị CheckBox, chỉ nó mới được cập nhật, khi thay đổi giá trị List, chỉ ListView sẽ được cập nhật.

* _Chỉ tái tạo lại nếu biến CẦN thay đổi_: GetX có tính năng kiểm soát streams, điều đó có nghĩa là nếu bạn hiển thị Text là 'Kaiser', nếu bạn thay đổi lại biến có thể quan sát thành 'Kaiser', widget sẽ không được tạo lại. Đó là bởi vì GetX biết rằng 'Kaiser' đã được hiển thị trong Văn bản và sẽ không thực hiện các thao tác tái tạo không cần thiết.

Hầu hết (nếu không phải tất cả) các trình quản lý state hiện tại sẽ xây dựng lại trên màn hình.

## Quản lý Reactive State

Lập trình phản ứng (Reactive programming) có thể khiến nhiều người xa lánh vì nó được cho là phức tạp. GetX biến lập trình phản ứng thành một thứ khá đơn giản:

* Bạn sẽ không cần tạo StreamControllers.
* Bạn sẽ không cần tạo StreamBuilder cho mỗi biến
* Bạn sẽ không cần phải tạo một class cho mỗi state.
* Bạn sẽ không cần tạo get cho một giá trị ban đầu.

Lập trình phản ứng với Get dễ dàng như sử dụng setState.

Hãy tưởng tượng rằng bạn có một biến tên và muốn rằng mỗi khi bạn thay đổi nó, tất cả các widget sử dụng nó sẽ được tự động thay đổi.

Đây là count variable của bạn:

``` dart
var name = 'Khang Huỳnh';
```

Để làm cho nó có thể quan sát được, bạn chỉ cần thêm ".obs" vào cuối nó:

``` dart
var name = 'Khang Huỳnh'.obs;
```

Chỉ vậy thôi, chỉ *vậy thôi* người ơi~

Từ bây giờ, chúng ta có thể tham chiếu đến các biến reactive - ". Obs" (có thể thay thế) này là _Rx_.   

Chúng tôi đã làm gì phía dưới class code? Chúng tôi đã tạo một `Stream` của `String`, được gán giá trị ban đầu `"Khang Huỳnh"`, chúng tôi đã thông báo cho tất cả các widget con sử dụng `"Khang Huỳnh"` rằng chúng hiện "thuộc về" biến này và khi giá trị _Rx_ thay đổi, chúng phải thay đổi theo.
Đây là **phép màu của GetX**, nhờ vào khả năng của Dart.

Tuy nhiên, như chúng ta đã biết, một `Widget` chỉ có thể được thay đổi nếu nó nằm bên trong một hàm, bởi vì các class tĩnh không có quyền" tự động thay đổi ".

Bạn sẽ cần tạo một `StreamBuilder`, đăng ký biến này để lắng nghe các thay đổi và tạo một "stream" các` StreamBuilder` lồng nhau nếu bạn muốn thay đổi một số biến trong cùng một phạm vi, phải không?

Không, bạn không cần `StreamBuilder`, nhưng bạn đã đúng về các class tĩnh.

Theo quan điểm, chúng ta thường có rất nhiều bảng soạn sẵn khi chúng ta muốn thay đổi một Widget cụ thể, đó là cách Flutter.
Với ** GetX **, bạn cũng có thể quên mã soạn sẵn này.

`StreamBuilder (…)`? `initialValue:…`? `builder:…`? Không, bạn chỉ cần đặt biến này bên trong Widget `Obx ()`.

``` dart
Obx (() => Text (controller.name));
```

_Bạn cần nhớ gì?_  Chỉ `Obx(() =>` . 

Bạn chỉ đang chuyển Widget đó thông qua một hàm mũi tên vào một `Obx ()` ("Observer" của _Rx_).

`Obx` khá thông minh và sẽ chỉ thay đổi nếu giá trị của `controller.name` thay đổi.

Nếu `name` là` "Kaiser" `và bạn thay đổi nó thành` "Kaiser" `(` name.value = "Kaiser" `), vì nó giống như` giá trị` như trước, sẽ không có gì thay đổi trên màn hình, và `Obx`, để tiết kiệm tài nguyên, sẽ đơn giản bỏ qua giá trị mới và không xây dựng lại Widget. **Tuyệt vời ông mặt trời chứ?**

> So, what if I have 5 _Rx_ (observable) variables within an `Obx` ?

Nó sẽ chỉ cập nhật khi ** bất kỳ ** nào trong số chúng thay đổi.

> And if I have 30 variables in a class, when I update one, will it update **all** the variables that are in that class?

Không, chỉ **Widget cụ thể** sử dụng biến _Rx_ đó.

Vì vậy, **GetX** chỉ cập nhật màn hình, khi biến _Rx_ thay đổi giá trị của nó.

``` 

final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value=false;
```

### Lợi thế

**GetX()** giúp bạn khi bạn cần kiểm soát **chi tiết** đối với những gì đang được cập nhật.

Nếu bạn không cần `ID duy nhất`, vì tất cả các biến của bạn sẽ được sửa đổi khi bạn thực hiện một hành động, thì hãy sử dụng` GetBuilder`,
bởi vì nó là một Trình cập nhật state đơn giản (trong các khối, như `setState ()` '), được tạo chỉ trong một vài dòng mã.
Nó được làm đơn giản, ít ảnh hưởng đến CPU nhất và chỉ để thực hiện một mục đích duy nhất (xây dựng lại _State_) và sử dụng tài nguyên tối thiểu có thể.

Nếu bạn cần một Trình quản lý state **mạnh mẽ**, bạn không thể làm sai với **GetX**.

Nó không hoạt động với các biến, nhưng __flows__, mọi thứ trong đó đều là `Streams`.

Bạn có thể sử dụng _rxDart_ kết hợp với nó, vì mọi thứ đều là `Luồng`,
bạn có thể nghe `event` của từng" biến _Rx_ ",
bởi vì mọi thứ trong đó đều là `Streams`.

Nó thực sự là một cách tiếp cận _BLoC_, dễ dàng hơn _MobX_ và không có trình tạo code hoặc decorations.
Bạn có thể biến **mọi thứ** thành một _"Observable" _ chỉ với một `.obs`.

### Hiệu suất tối đa:

Ngoài việc có một thuật toán thông minh để xây dựng lại tối thiểu, **GetX** sử dụng trình so sánh để đảm bảo rằng Bang đã thay đổi.

Nếu bạn gặp bất kỳ lỗi nào trong ứng dụng của mình và gửi một bản thay đổi state, **GetX** sẽ đảm bảo rằng nó sẽ không gặp sự cố.

Với **GetX** State chỉ thay đổi nếu `giá trị` thay đổi.
Đó là sự khác biệt chính giữa **GetX** và việc sử dụng _ `computed` từ MobX_.
Khi kết hợp hai __observables__, và một thay đổi; trình nghe của _observable_ đó cũng sẽ thay đổi.

Với **GetX**, nếu bạn nối hai biến, `GetX ()` (tương tự như `Observer ()`) sẽ chỉ xây dựng lại nếu nó ngụ ý thay đổi state thực sự.

### Khai báo một biến phản ứng (reactive variable)

Bạn có 3 cách để thay đổi variable thành "observable".

1 - Sử dụng **`Rx{Type}`**.

``` dart
// initial value is recommended, but not mandatory
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

2 - Sử dụng **`Rx`** và dùng Darts Generics, `Rx<Type>`

``` dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// Custom classes - it can be any class, literally
final user = Rx<User>();
```

3 - Cách tối ưu nhất, thêm **`.obs`** ở `value` :

``` dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - it can be any class, literally
final user = User().obs;
```

##### Thât dễ khi có reactive state.

Như chúng ta biết, _Dart_ đang hướng tới _null safety_.
Để chuẩn bị, từ bây giờ, bạn phải luôn bắt đầu các biến _Rx_ của mình bằng một **initial value**.

> Transforming a variable into an _observable_ + _initial value_ with **GetX** is the simplest, and most practical approach.

Theo đúng nghĩa đen, bạn sẽ thêm một "` .obs` "vào cuối biến của mình và **vậy thôi người ơi~**, bạn đã làm cho nó có thể quan sát được, và `.value` của nó sẽ là _initial value_).

### Sử dụng values trong View

``` dart
// controller file
final count1 = 0.obs;
final count2 = 0.obs;
int get sum => count1.value + count2.value;
```

``` dart
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
    print("count 3 rebuild");
    return Text('${controller.sum}');
  },
),
```

Nếu chúng ta cộng `count1.value++` , nó sẽ in:

* `count 1 rebuild`

* `count 3 rebuild`

bởi vì `count1` có giá trị là` 1` và `1 + 0 = 1`, thay đổi giá trị getter` sum`.

Nếu ta thay đổi `count2.value++` , nó sẽ in:

* `count 2 rebuild`

* `count 3 rebuild`

bởi vì `count2.value` đã thay đổi, và kết quả của` sum` bây giờ là `2`.

* LƯU Ý: Theo mặc định, event đầu tiên sẽ xây dựng lại widget con, ngay cả khi nó là cùng một `giá trị`.

Hành vi này tồn tại do các biến Boolean.

Ví dụ, bạn code thế này:

``` dart
var isLogged = false.obs;
```

Và sau đó, bạn đã kiểm tra xem người dùng có "đăng nhập" để kích hoạt event trong `ever` không.

``` dart
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

nếu `hasToken` là` false`, sẽ không có thay đổi thành `isLogged`, vì vậy `ever ()` sẽ không bao giờ được gọi.
Để tránh loại hành vi này, thay đổi đầu tiên đối với _observable_ sẽ luôn kích hoạt một event,
ngay cả khi nó chứa cùng một `.value`.

Bạn có thể xóa hành vi này nếu muốn, bằng cách sử dụng:
 `isLogged.firstRebuild = false;`

### Điều kiện để tái tạo lại

Ngoài ra, Get cung cấp khả năng kiểm soát state đã được tinh chỉnh. Bạn có thể điều kiện một event (chẳng hạn như thêm một đối tượng vào danh sách), với một điều kiện nhất định.

``` dart
// First parameter: condition, must return true or false.
// Second parameter: the new value to apply if the condition is true.
list.addIf(item < limit, item);
```

Không có decoration, không có trình tạo mã, không có phức tạp hóa vấn đề: smile:

Bạn có biết ứng dụng counter của Flutter không? Class controller của bạn có thể trông giống như sau:

``` dart
class CountController extends GetxController {
  final count = 0.obs;
}
```

Đơn giản hơn:

``` dart
controller.count.value++
```

Bạn có thể cập nhật counter trong UI của mình, bất kể nó được lưu trữ ở đâu.

### Nơi .obs có thể dùng

Bạn có thể biến đổi bất cứ thứ gì trên obs. Đây là hai cách để làm điều đó:

* Bạn có thể chuyển đổi các giá trị class của mình thành obs

``` dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}
```

* hoặc bạn có thể biến cả 1 class thành observable

``` dart
class User {
  User({String name, int age});
  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

### Chí ú về Lists

List hoàn toàn có thể quan sát được cũng như các đối tượng bên trong nó. Bằng cách đó, nếu bạn thêm một giá trị vào danh sách, nó sẽ tự động xây dựng lại các widget con sử dụng nó.

Bạn cũng không cần phải sử dụng ".value" với các danh sách, api phi tiêu tuyệt vời đã cho phép chúng tôi loại bỏ điều đó.
Tiếc thay, các kiểu nguyên thủy như String và int không thể được mở rộng, khiến việc sử dụng .value là bắt buộc, nhưng điều đó sẽ không thành vấn đề nếu bạn làm việc với getters và setters cho những thứ này.

``` dart
// On the controller
final String title = 'User Info:'.obs
final list = List<User>().obs;

// on the view
Text(controller.title.value), // String need to have .value in front of it
ListView.builder (
  itemCount: controller.list.length // lists don't need it
)
```

Khi bạn đang làm cho các class của riêng mình có thể quan sát được, có một cách khác để cập nhật chúng:

``` dart
// on the model file
// we are going to make the entire class observable instead of each attribute
class User() {
  User({this.name = '', this.age = 0});
  String name;
  int age;
}

// on the controller file
final user = User().obs;
// when you need to update the user variable:
user.update( (user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});
// an alternative way of update the user variable:
user(User(name: 'João', age: 35));

// on view:
Obx(()=> Text("Name ${user.value.name}: Age: ${user.value.age}"))
// you can also access the model values without the .value:
user().name; // notice that is the user variable, not the class (variable has lowercase u)
```

Bạn không cần phải làm việc với các bộ nếu bạn không muốn. bạn có thể sử dụng api "assign" và "assignAll".
Api "assign" sẽ xóa danh sách của bạn và thêm một đối tượng duy nhất mà bạn muốn bắt đầu ở đó.
Api "allowAll" sẽ xóa danh sách hiện có và thêm bất kỳ đối tượng có thể lặp lại nào mà bạn đưa vào đó.

### Tại sao tôi phải dùng .value

Chúng ta có thể loại bỏ việc sử dụng 'value' đối với `String` và` int` bằng một trình tạo mã và decoration đơn giản, nhưng mục đích của thư viện này chính là tránh các dependency bên ngoài. Chúng tôi muốn cung cấp một môi trường sẵn sàng cho việc lập trình, liên quan đến các yếu tố cần thiết (quản lý các route, dependency và state), theo cách đơn giản, nhẹ và hiệu quả mà không cần gói bên ngoài.

Theo nghĩa đen, bạn có thể thêm 3 chữ cái vào pubspec (get) của mình và dấu hai chấm và bắt đầu lập trình. Tất cả các giải pháp được bao gồm theo mặc định, từ quản lý route đến quản lý state, nhằm mục đích dễ dàng, năng suất và hiệu suất.

Tổng trọng lượng của thư viện này ít hơn của một trình quản lý state duy nhất, mặc dù nó là một giải pháp hoàn chỉnh và đó là những gì bạn phải hiểu.

Nếu bạn bị làm phiền bởi `.value`, và giống như một trình tạo mã, MobX là một giải pháp thay thế tuyệt vời và bạn có thể sử dụng nó cùng với Get. Đối với những người muốn thêm một gói dependency duy nhất vào pubspec và bắt đầu lập trình mà không cần lo lắng về phiên bản của gói không tương thích với gói khác hoặc nếu lỗi cập nhật state đến từ trình quản lý state hoặc dependency, hoặc vẫn không muốn lo lắng về sự sẵn có của controller, cho dù theo nghĩa đen là "chỉ là lập trình", GetX là lựa chọn hoàn hảo.

Nếu bạn không gặp vấn đề gì với trình tạo mã MobX hoặc không gặp vấn đề gì với bảng soạn sẵn BLoC, bạn có thể chỉ cần sử dụng Get cho các route và quên rằng nó có trình quản lý state. Get SEM và RSM ra đời không cần thiết, công ty của tôi có một dự án với hơn 90 controller và trình tạo mã chỉ mất hơn 30 phút để hoàn thành nhiệm vụ của nó sau khi Flutter Clean trên một máy khá tốt, nếu dự án của bạn có 5, 10, 15 controller, bất kỳ nhà quản lý state sẽ cung cấp cho bạn tốt. Nếu bạn có một dự án lớn đến mức ngớ ngẩn và trình tạo mã là một vấn đề đối với bạn, thì bạn đã được trao giải pháp này.

Rõ ràng, nếu ai đó muốn đóng góp vào dự án và tạo trình tạo mã, hoặc thứ gì đó tương tự, tôi sẽ liên kết trong readme này như một giải pháp thay thế, nhu cầu của tôi không phải là nhu cầu của tất cả các nhà phát triển, nhưng ý tôi là thế, đã có những giải pháp tốt đã làm được điều đó, như MobX.

### Obx()

Nhập vào Get bằng cách sử dụng Bindings là không cần thiết. bạn có thể sử dụng widget Obx thay vì GetX, widget chỉ nhận được chức năng ẩn danh tạo widget.
Rõ ràng, nếu bạn không sử dụng một kiểu, bạn sẽ cần phải có một phiên bản của controller để sử dụng các biến hoặc sử dụng `Get.find <Controller> ()` .value hoặc Controller.to.value để truy xuất giá trị .

### Workers

Workers sẽ hỗ trợ bạn, kích hoạt các lệnh gọi lại cụ thể khi một event xảy ra.

``` dart
/// Called every time `count1` changes.
ever(count1, (_) => print("$_ has been changed"));

/// Called only first time the variable $_ is changed
once(count1, (_) => print("$_ was changed once"));

/// Anti DDos - Called every time the user stops typing for 1 second, for example.
debounce(count1, (_) => print("debouce$_"), time: Duration(seconds: 1));

/// Ignore all changes within 1 second.
interval(count1, (_) => print("interval $_"), time: Duration(seconds: 1));
```

Tất cả các workers (except `debounce` ) có `condition` tham số được đặt tên, mà có thể là loại `bool` hoặc lệnh gọi lại trả về một `bool` .
`condition` này mô tả khi `callback` kích hoạt.

Tất cả các workers đều trả về trường hợp `Worker`, mà bạn có thể đóng ( thông qua `dispose()` ) của worker.
 

* **`ever`**

 được gọi mỗi khi biến _Rx_ tạo ra một giá trị mới.

* **`everAll`**

Giống như `ever`, nhưng nó có một` List` gồm các giá trị _Rx_ Được gọi mỗi khi biến của nó bị thay đổi. Chỉ vậy thôi người ơi~ 😊

* **`once`**

'once' chỉ được gọi lần đầu tiên biến được thay đổi.

* **`debounce`**

'debounce' rất hữu ích trong các hàm tìm kiếm, nơi bạn chỉ muốn API được gọi khi người dùng nhập xong. Nếu người dùng nhập "Kaiser", bạn sẽ có 6 tìm kiếm trong các API, theo ký tự K, a, i, s, e và r. Với Get, điều này không xảy ra, bởi vì bạn sẽ có một Worker "debounce" sẽ chỉ được kích hoạt khi kết thúc nhập.

* **`interval`**

'interval' khác với debounce. Debounce xảy ra nếu người dùng thực hiện 1000 thay đổi đối với một biến trong vòng 1 giây, y sẽ chỉ gửi biến cuối cùng sau bộ hẹn giờ quy định (mặc định là 800 mili giây). Thay vào đó, interval sẽ bỏ qua tất cả các hành động của người dùng trong interval quy định. Nếu bạn gửi event trong 1 phút, 1000 mỗi giây, tính năng gỡ lỗi sẽ chỉ gửi cho bạn event cuối cùng, khi người dùng ngừng phân chia event. interval sẽ phân phối các event mỗi giây và nếu được đặt thành 3 giây, nó sẽ phân phối 20 event trong phút đó. Điều này được khuyến nghị để tránh lạm dụng, trong các chức năng mà người dùng có thể nhanh chóng nhấp vào một thứ gì đó và có được một số lợi thế (hãy tưởng tượng rằng người dùng có thể kiếm được xu bằng cách nhấp vào thứ gì đó, nếu y nhấp 300 lần trong cùng một phút, y sẽ có 300 xu, bằng cách sử dụng interval, bạn có thể đặt khung thời gian trong 3 giây, và thậm chí sau đó nhấp vào 300 hoặc một nghìn lần, tối đa y sẽ nhận được trong 1 phút sẽ là 20 xu, nhấp 300 hoặc 1 triệu lần). Việc gỡ lỗi này phù hợp cho việc chống DDos, cho các chức năng như tìm kiếm trong đó mỗi thay đổi đối với onChange sẽ gây ra một truy vấn tới api của bạn. Debounce sẽ đợi người dùng ngừng nhập tên để thực hiện yêu cầu. Nếu nó được sử dụng trong kịch bản đồng xu được đề cập ở trên, người dùng sẽ chỉ giành được 1 đồng xu, bởi vì nó chỉ được thực thi, khi người dùng "tạm dừng" trong thời gian đã thiết lập.

* CHÍ Ú: Workers phải luôn được sử dụng khi khởi động Controller hoặc Class, vì vậy nó phải luôn ở trên onInit (được khuyến nghị), phương thức khởi tạo Class hoặc initState của StatefulWidget (phương pháp này không được khuyến khích trong hầu hết các trường hợp, nhưng nó không nên có hiệu ứng phụ nào khác).

## Quản lý State đơn giản

Get có một trình quản lý state cực kỳ nhẹ và dễ dàng, không sử dụng ChangeNotifier, sẽ đáp ứng nhu cầu đặc biệt cho những người mới sử dụng Flutter và sẽ không gây ra sự cố cho các ứng dụng lớn.

GetBuilder nhắm chính xác vào việc kiểm soát nhiều state. Hãy tưởng tượng rằng bạn đã thêm 30 sản phẩm vào giỏ hàng, bạn nhấp vào xóa một sản phẩm, đồng thời danh sách được cập nhật, giá được cập nhật và huy hiệu trong giỏ hàng được cập nhật thành số lượng nhỏ hơn. Kiểu tiếp cận này khiến GetBuilder trở thành kẻ giết người, bởi vì nó nhóm các state và thay đổi tất cả chúng cùng một lúc mà không có bất kỳ "logic tính toán" nào cho điều đó. GetBuilder được tạo ra với loại tình huống này, vì để thay đổi state tạm thời, bạn có thể sử dụng setState và bạn sẽ không cần trình quản lý state cho việc này.

Bằng cách đó, nếu bạn muốn một controller riêng lẻ, bạn có thể gán ID cho controller đó hoặc sử dụng GetX. Điều này là tùy thuộc vào bạn, hãy nhớ rằng bạn càng có nhiều widget "riêng lẻ" thì hiệu suất của GetX càng nổi bật, trong khi hiệu suất của GetBuilder phải vượt trội hơn khi có nhiều thay đổi state.

### Lợi thế

1. Chỉ cập nhật các widget được yêu cầu.

2. Không sử dụng changeNotifier, đó là trình quản lý state sử dụng ít bộ nhớ hơn (gần như bằng 0mb).

3. Quên StatefulWidget! Với Get, bạn sẽ không bao giờ cần đến nó. Với các trình quản lý state khác, bạn có thể sẽ phải sử dụng StatefulWidget để lấy phiên bản của Provider, BLoC, MobX, v.v. Nhưng bạn đã bao giờ nghĩ rằng AppBar, Scaffole và hầu hết các widget trong class của bạn là stateless? Vậy tại sao phải lưu state của toàn bộ class, nếu bạn chỉ có thể lưu state của Widget là stateful? Get giải quyết được điều đó bằng cách tạo một class Stateless, làm cho mọi thứ trở nên vô trạng. Nếu bạn cần cập nhật một thành phần riêng lẻ, hãy bọc nó bằng GetBuilder và state của nó sẽ được duy trì.

4. Tái cơ cấu cho dự án của bạn xanh, sạch và đẹp! Controller không được nằm trong UI của bạn, hãy đặt TextEditController của bạn hoặc bất kỳ controller nào bạn sử dụng trong class Controller của mình.

5. Bạn có cần kích hoạt event để cập nhật widget con ngay khi nó được hiển thị không? GetBuilder có thuộc tính "initState", giống như StatefulWidget và bạn có thể gọi các event từ controller của mình, trực tiếp từ nó, không có thêm event nào được đặt trong initState của bạn.

6. Bạn có cần phải kích hoạt một hành động như đóng streams, hẹn giờ, v.v. không? GetBuilder cũng có dispose property, nơi bạn có thể gọi các event ngay khi widget đó bị phá hủy.

7. Chỉ sử dụng các streams nếu cần thiết. Bạn có thể sử dụng StreamControllers bên trong controller của mình một cách bình thường và sử dụng StreamBuilder cũng bình thường, nhưng hãy nhớ rằng, một streams tiêu thụ bộ nhớ một kha khá, lập trình phản ứng rất đẹp, nhưng bạn không nên lạm dụng nó. 30 streams mở cùng lúc có thể tệ hơn changeNotifier (và changeNotifier đã rất là tệ).

8. Cập nhật các widgets mà không tốn ram. Chỉ lưu trữ ID người tạo GetBuilder và cập nhật GetBuilder đó khi cần thiết. Mức tiêu thụ bộ nhớ của get ID trong bộ nhớ là rất thấp ngay cả đối với hàng nghìn GetBuilders. Khi bạn tạo GetBuilder mới, bạn thực sự đang chia sẻ state GetBuilder có ID người tạo. Một state mới không được tạo cho mỗi GetBuilder, giúp tiết kiệm RẤT NHIỀU ram cho các ứng dụng lớn. Về cơ bản, ứng dụng của bạn sẽ hoàn toàn là Không state và một số ít Tiện ích sẽ có state (trong GetBuilder) sẽ có một state duy nhất, và do đó cập nhật một sẽ cập nhật tất cả. Nhà nước chỉ là một.

9. Get là toàn trí và trong hầu hết các trường hợp, nó biết chính xác thời gian để lấy controller ra khỏi bộ nhớ. Bạn không nên lo lắng về việc khi nào nên vứt bỏ controller, Get biết thời điểm tốt nhất để thực hiện việc này.

### Sử dụng

``` dart
// Create controller class and extends GetxController
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // use update() to update counter variable on UI when increment be called
  }
}
// On your Stateless/Stateful class, use GetBuilder to update Text when increment be called
GetBuilder<Controller>(
  init: Controller(), // INIT IT ONLY THE FIRST TIME
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//Initialize your controller only the first time. The second time you are using ReBuilder for the same controller, do not use it again. Your controller will be automatically removed from memory as soon as the widget that marked it as 'init' is deployed. You don't have to worry about that, Get will do it automatically, just make sure you don't start the same controller twice.
```

**OK, giải thích xong rồi!**

* Bạn đã học cách quản lý state với Get.

* Lưu ý: Bạn có thể muốn một tổ chức lớn hơn và không sử dụng thuộc tính init. Vì vậy, bạn có thể tạo một class và mở rộng class Bindings và trong đó đề cập đến các controller sẽ được tạo trong route đó. Khi đó các Controllers sẽ không được tạo, ngược lại, đây chỉ là một câu lệnh, để lần đầu sử dụng Controller, Get sẽ biết cần tìm ở đâu. Get sẽ vẫn là lazyLoad và sẽ tiếp tục loại bỏ Controller khi chúng không còn cần thiết nữa. Hãy xem ví dụ pub.dev để xem nó hoạt động như thế nào.

Nếu bạn điều hướng nhiều route và cần dữ liệu trong controller đã sử dụng trước đó, bạn chỉ cần sử dụng GetBuilder Again (không có init):

``` dart
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

Nếu bạn cần sử dụng controller của mình ở nhiều nơi khác và bên ngoài GetBuilder, chỉ cần tạo quyền truy cập vào controller của bạn và có nó một cách dễ dàng. (hoặc sử dụng `Get.find <Controller> ()`)

``` dart
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

Sau đó, truy cập thẳng vào controller của bạn:

``` dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // This is incredibly simple!
  child: Text("${Controller.to.counter}"),
),
```

Khi bạn nhấn FloatingActionButton, tất cả các widget đang lắng nghe biến 'counter' sẽ được cập nhật tự động.

### Cách GetX sử dụng controllers

Ví dụ:

 `Class a => Class B (has controller X) => Class C (has controller X)`

Trong class A, controller chưa có trong bộ nhớ, vì bạn chưa sử dụng nó (Get là lazyLoad). Trong class B, bạn đã sử dụng controller và nó đã vào bộ nhớ. Trong class C, bạn đã sử dụng cùng một controller như trong class B, Get sẽ chia sẻ state của controller B với controller C, và controller tương tự vẫn còn trong bộ nhớ. Nếu bạn đóng màn hình C và màn hình B, Get sẽ tự động lấy controller X ra khỏi bộ nhớ và giải phóng tài nguyên, vì Class A không sử dụng controller. Nếu bạn điều hướng đến B một lần nữa, controller X sẽ nhập lại bộ nhớ, nếu thay vì đi đến class C, bạn quay lại class A một lần nữa, Get sẽ đưa controller ra khỏi bộ nhớ theo cách tương tự. Nếu class C không sử dụng controller và bạn đã lấy class B ra khỏi bộ nhớ, thì sẽ không có class nào sử dụng controller X và tương tự như vậy, nó sẽ bị loại bỏ. Ngoại lệ duy nhất có thể gây rắc rối với Get là nếu bạn xóa B khỏi route một cách bất ngờ và cố gắng sử dụng controller trong C. Trong trường hợp này, ID người tạo của controller ở B đã bị xóa và Get được lập trình để xóa nó khỏi bộ nhớ mọi controller không có ID người tạo. Nếu bạn dự định làm điều này, hãy thêm flag "autoRemove: false" vào GetBuilder của class B và sử dụng adoptID = true trong GetBuilder của class C.

### Không cần StatefulWidget nữa!

Sử dụng StatefulWidgets có nghĩa là lưu trữ state của toàn bộ màn hình một cách không cần thiết, ngay cả khi bạn cần xây dựng lại một cách tối thiểu widget, bạn sẽ nhúng nó vào Consumer / Observer / BlocProvider / GetBuilder / GetX / Obx, đây sẽ là một StatefulWidget khác.
Class StatefulWidget là một class lớn hơn StatelessWidget, class này sẽ phân bổ nhiều RAM hơn và điều này có thể không tạo ra sự khác biệt đáng kể giữa một hoặc hai class, nhưng chắc chắn nó sẽ làm được khi bạn có 100 class trong số chúng!
Trừ khi bạn cần sử dụng một mixin, như TickerProviderStateMixin, thì việc sử dụng StatefulWidget với Get là hoàn toàn không cần thiết.

Bạn có thể gọi trực tiếp tất cả các phương thức của StatefulWidget từ GetBuilder.
Nếu bạn cần gọi phương thức initState () hoặc dispose () chẳng hạn, bạn có thể gọi chúng trực tiếp;

``` dart
GetBuilder<Controller>(
  initState: (_) => Controller.to.fetchApi(),
  dispose: (_) => Controller.to.closeStreams(),
  builder: (s) => Text('${s.username}'),
),
```

Một cách tiếp cận tốt hơn nhiều so với cách này là sử dụng phương thức onInit () và onClose () trực tiếp từ controller của bạn.

``` dart
@override
void onInit() {
  fetchApi();
  super.onInit();
}
```

* CHÍ Ú: Nếu bạn muốn bắt đầu một phương thức tại thời điểm controller được gọi lần đầu tiên, bạn KHÔNG CẦN sử dụng các hàm tạo cho việc này, trên thực tế, bằng cách sử dụng gói hướng hiệu suất như Get, điều này không phù hợp với thực tiễn xấu, bởi vì nó lệch khỏi logic trong đó controller được tạo hoặc chỉ định (nếu bạn tạo một phiên bản của controller này, hàm tạo sẽ được gọi ngay lập tức, bạn sẽ điền controller trước khi nó được sử dụng, bạn đang cấp phát bộ nhớ mà không sử dụng nó , điều này chắc chắn làm hỏng các nguyên tắc của thư viện này). Các phương thức onInit(); và onClose(); được tạo ra cho mục đích này, chúng sẽ được gọi khi Controller được tạo hoặc được sử dụng lần đầu tiên, tùy thuộc vào việc bạn có đang sử dụng Get.lazyPut hay không. Ví dụ: nếu bạn muốn thực hiện lệnh gọi tới API của mình để điền dữ liệu, bạn có thể quên phương thức cũ của initState / dispose, chỉ cần bắt đầu lệnh gọi tới api trong onInit. Nếu bạn cần thực thi bất kỳ lệnh nào, như đóng streams, hãy sử dụng onClose() cho việc đó.

### Tại sao GetX tồn tại?

Mục đích của gói này chính xác là cung cấp cho bạn một giải pháp hoàn chỉnh để điều hướng các route, quản lý các dependency và state, sử dụng các dependency ít nhất có thể, với mức độ tách biệt cao. Nhận tất cả các API Flutter cấp cao và cấp thấp trong chính nó, để đảm bảo rằng bạn làm việc với ít khớp nối nhất có thể. Chúng tôi tập trung mọi thứ trong một gói duy nhất, để đảm bảo rằng bạn không có bất kỳ loại khớp nối nào trong dự án của mình. Bằng cách đó, bạn có thể chỉ đặt các widget trong chế độ xem của mình và để phần của nhóm làm việc với logic nghiệp vụ tự do làm việc với logic nghiệp vụ độc lập với View. Điều này cung cấp một môi trường làm việc sạch hơn nhiều, để một phần nhóm của bạn chỉ hoạt động với các widget mà không phải lo lắng về việc gửi dữ liệu đến controller của bạn và một phần nhóm của bạn chỉ làm việc với logic nghiệp vụ trong phạm vi bề rộng của nó mà không dependency vào bất kỳ yếu tố View.

Vì vậy, để đơn giản hóa điều này:
Bạn không cần gọi các phương thức trong initState và gửi chúng theo tham số đến controller của mình, cũng như không sử dụng phương thức khởi tạo controller cho việc đó, bạn có phương thức onInit() được gọi vào đúng thời điểm để bạn khởi động các dịch vụ của mình.
Bạn không cần phải gọi thiết bị, bạn có phương thức onClose() sẽ được gọi vào thời điểm chính xác khi controller của bạn không còn cần thiết nữa và sẽ bị xóa khỏi bộ nhớ. Bằng cách đó, chỉ để lại chế độ xem cho các widget, tránh bất kỳ loại logic nghiệp vụ nào từ nó.

Đừng gọi một phương thức vứt bỏ bên trong GetxController, nó sẽ không làm được gì cả, hãy nhớ rằng controller không phải là một Widget, bạn không nên "vứt bỏ" nó, và nó sẽ được Get tự động và thông minh xóa khỏi bộ nhớ. Nếu bạn đã sử dụng bất kỳ streams nào trên đó và muốn đóng streams đó, chỉ cần chèn streams đó vào phương thức đóng. Thí dụ:

``` dart
class Controller extends GetxController {
  StreamController<User> user = StreamController<User>();
  StreamController<String> name = StreamController<String>();

  /// close stream = onClose method, not dispose.
  @override
  void onClose() {
    user.close();
    name.close();
    super.onClose();
  }
}
```

Vòng đời của controller:

* onInit() nơi nó được tạo.
* onClose() nơi nó được đóng để thực hiện bất kỳ thay đổi nào nhằm chuẩn bị cho phương thức xóa
* deleted: bạn không có quyền truy cập vào API này vì nó sẽ xóa controller khỏi bộ nhớ theo đúng nghĩa đen. Nó được xóa theo đúng nghĩa đen, mà không để lại bất kỳ dấu vết nào.

### Cách sử dụng khác

Bạn có thể sử dụng phiên bản Controller trực tiếp trên giá trị GetBuilder:

``` dart
GetBuilder<Controller>(
  init: Controller(),
  builder: (value) => Text(
    '${value.counter}', //here
  ),
),
```

Bạn cũng có thể cần một phiên bản của controller bên ngoài GetBuilder và bạn có thể sử dụng các phương pháp này để đạt được điều này:

``` dart
class Controller extends GetxController {
  static Controller get to => Get.find();
[...]
}
// on you view:
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Controller.to.counter}', //here
  )
),
```

or

``` dart
class Controller extends GetxController {
 // static Controller get to => Get.find(); // with no static get
[...]
}
// on stateful/stateless class
GetBuilder<Controller>(  
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

* Bạn có thể sử dụng các phương pháp tiếp cận "không chuẩn" để thực hiện việc này. Nếu bạn đang sử dụng một số trình quản lý dependency khác, như get_it, modular, v.v. và chỉ muốn cung cấp phiên bản controller, bạn có thể thực hiện điều này:

``` dart
Controller controller = Controller();
[...]
GetBuilder<Controller>(
  init: controller, //here
  builder: (_) => Text(
    '${controller.counter}', // here
  ),
),

```

### IDs độc nhất

Nếu bạn muốn tinh chỉnh kiểm soát cập nhật của widget con với GetBuilder, bạn có thể gán cho chúng các ID độc:

``` dart
GetBuilder<Controller>(
  id: 'text'
  init: Controller(), // use it only first time on each controller
  builder: (_) => Text(
    '${Get.find<Controller>().counter}', //here
  ),
),
```

Và cập nhật nó vào biểu mẫu này:

``` dart
update(['text']);
```

Bạn cũng có thể áp đặt các điều kiện cho bản cập nhật:

``` dart
update(['text'], counter < 10);
```

GetX thực hiện điều này tự động và chỉ cấu trúc lại widget con sử dụng biến chính xác đã được thay đổi, nếu bạn thay đổi một biến thành giống với biến trước đó và điều đó không ngụ ý thay đổi state, GetX sẽ không xây dựng lại widget con để tiết kiệm bộ nhớ và Chu kỳ CPU ( 3 đang được hiển thị trên màn hình và bạn lại thay đổi biến thành 3. Trong hầu hết các trình quản lý state, điều này sẽ gây ra việc xây dựng lại mới, nhưng với GetX, widget sẽ chỉ được xây dựng lại, nếu trên thực tế state của nó đã thay đổi ).

## Trộn hai trình quản lý state

Một số người đã mở một yêu cầu tính năng, vì họ chỉ muốn sử dụng một loại biến phản ứng và cơ chế khác và cần chèn Obx vào GetBuilder cho việc này. Suy nghĩ về nó MixinBuilder đã được tạo ra. Nó cho phép cả những thay đổi phản ứng bằng cách thay đổi các biến ".obs" và cập nhật thủ công thông qua update(). Tuy nhiên, trong số 4 widget, nó là widget tiêu tốn nhiều tài nguyên nhất, vì ngoài việc có Subscription để nhận các event thay đổi từ con mình, nó còn đăng ký phương thức cập nhật của controller của mình.

Việc mở rộng GetxController rất quan trọng, vì chúng có vòng đời và có thể "bắt đầu" và "kết thúc" các event trong các phương thức onInit() và onClose() của chúng. Bạn có thể sử dụng bất kỳ lớp nào cho việc này, nhưng tôi thực sự khuyên bạn nên sử dụng lớp GetxController để đặt các biến của bạn, cho dù chúng có thể quan sát được hay không.

## StateMixin

Một cách khác để xử lý state `UI` của bạn là sử dụng` StateMixin <T> `.
Để triển khai nó, hãy sử dụng dấu `với` để thêm` StateMixin <T> ` bộ điều khiển của bạn cho phép một mô hình T.

``` dart
class Controller extends GetController with StateMixin<User>{}
```

Phương thức `change()` thay đổi state bất cứ khi nào chúng ta muốn.
Chỉ cần truyền dữ liệu và state theo cách này:

```dart
change(data, status: RxStatus.success());
```

RxStatus cho phép các state này:

``` dart
RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');
```

Để diễn tả nó trên UI, sử dụng:

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

## GetBuilder vs GetX vs Obx vs MixinBuilder

Trong một thập kỷ làm việc với lập trình, tôi đã có thể học được một số bài học quý giá.

Lần đầu tiên tôi tiếp xúc với lập trình phản ứng là rất "Trời thần ơi, tuyệt vời ông mặt trời!" và trên thực tế, lập trình phản ứng là không thể tin được.
Tuy nhiên, nó không phải là thích hợp cho tất cả các trường hợp. Thông thường, tất cả những gì bạn cần là thay đổi state của 2 hoặc 3 widget cùng lúc, hoặc thay đổi state trong thời gian ngắn, trong trường hợp này, lập trình phản ứng không phải là xấu, nhưng nó không phù hợp.

Lập trình phản ứng có mức tiêu thụ RAM cao hơn có thể được bù đắp bởi quy trình làm việc riêng lẻ, điều này sẽ đảm bảo rằng chỉ một widget con được xây dựng lại và khi cần thiết, nhưng tạo danh sách với 80 đối tượng, mỗi đối tượng có nhiều streams không phải là một ý kiến hay . Mở thanh kiểm tra phi tiêu và kiểm tra xem StreamBuilder tiêu thụ bao nhiêu và bạn sẽ hiểu những gì tôi đang cố gắng nói với bạn.

Với ý nghĩ đó, tôi đã tạo trình quản lý state đơn giản. Nó đơn giản, và đó chính xác là những gì bạn cần ở nó: cập nhật state trong các khối theo cách đơn giản và tiết kiệm nhất.

GetBuilder rất tiết kiệm RAM và khó có cách tiếp cận nào tiết kiệm hơn nó (ít nhất là tôi không thể tưởng tượng được, nếu đã tồn tại cách khác, vui lòng cho chúng tôi biết).

Tuy nhiên, GetBuilder vẫn là một trình quản lý state cơ học, bạn cần phải gọi update () giống như bạn sẽ cần gọi tới Provider's InformListaries ().

Có những tình huống khác mà lập trình phản ứng thực sự thú vị và nếu không dùng nó đồng nghĩa như đang phát minh lại cái bánh xe. Với suy nghĩ đó, GetX được tạo ra để cung cấp mọi thứ hiện đại và tiên tiến nhất trong một trình quản lý state. Nó chỉ cập nhật những gì cần thiết và khi cần thiết, nếu bạn gặp lỗi và gửi 300 state thay đổi đồng thời, GetX sẽ lọc và cập nhật màn hình chỉ khi state thực sự thay đổi.

GetX vẫn tiết kiệm hơn bất kỳ trình quản lý state phản ứng nào khác, nhưng nó tiêu tốn nhiều RAM hơn GetBuilder một chút. Suy nghĩ về điều đó và hướng tới việc tiêu thụ tối đa tài nguyên mà Obx đã tạo ra. Không giống như GetX và GetBuilder, bạn sẽ không thể khởi tạo controller bên trong Obx, nó chỉ là một Widget với StreamSubscription nhận các event thay đổi từ con bạn, vậy thôi. Nó tiết kiệm hơn GetX, nhưng thua GetBuilder, điều được mong đợi, vì nó có tính phản ứng và GetBuilder có cách tiếp cận đơn giản nhất tồn tại, đó là lưu trữ hashCode của widget con và StateSetter của nó. Với Obx, bạn không cần phải viết loại controller của mình và bạn có thể nghe thấy sự thay đổi từ nhiều controller khác nhau, nhưng nó cần được khởi tạo trước đó, sử dụng phương pháp ví dụ ở đầu readme này hoặc sử dụng class Bindings.

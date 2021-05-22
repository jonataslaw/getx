# Quản lý dependency
- [Quản lý dependency](#dependency-management)
  - [Instancing methods](#instancing-methods)
    - [Get.put()](#getput)
    - [Get.lazyPut](#getlazyput)
    - [Get.putAsync](#getputasync)
    - [Get.create](#getcreate)
  - [Sử dụng các phương thức / class](#using-instantiated-methodsclasses)
  - [Khác nhau giữa phương thức (methods)](#differences-between-methods)
  - [Bindings](#bindings)
    - [Cách sử dụng](#how-to-use)
    - [BindingsBuilder](#bindingsbuilder)
    - [SmartManagement](#smartmanagement)
      - [Cách thay đổi](#How-to-change)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    - [Cách bindings làm việc ngầm](#how-bindings-work-under-the-hood)
  - [Chí ú](#notes)

Get có một trình quản lý dependency đơn giản và mạnh mẽ cho phép bạn truy xuất cùng một class với Blocs hoặc Controller của bạn chỉ với 1 dòng mã, không có "context", không có InheritedWidget

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

Thay vì khởi tạo class của bạn trong class bạn đang sử dụng, bạn đang khởi tạo nó trong phiên bản Get, điều này sẽ làm cho nó có sẵn trên toàn bộ Ứng dụng của bạn.
Vì vậy, bạn có thể sử dụng controller (hoặc class Blocs) của mình một cách bình thường

- Note: Nếu bạn đang sử dụng Get's State Manager, hãy chú ý hơn đến [Bindings](#bindings) api, điều này sẽ giúp kết nối chế độ xem với controller của bạn dễ dàng hơn.
- Note²: Quản lý state của Get được tách biệt khỏi các phần khác của gói, vì vậy, nếu ví dụ: nếu ứng dụng của bạn đã sử dụng trình quản lý state (bất kỳ cái nào, không quan trọng), bạn không cần phải thay đổi điều đó, bạn có thể sử dụng phần dependency này người quản lý không có vấn đề gì cả

## Instancing methods
Các phương thức và các tham số có thể định cấu hình của nó là:

### Get.put()

Cách phổ biến nhất để chèn một dependency, là một điều tốt cho controller của View của bạn.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

Đây là tùy chọn mà bạn có thể đặt lệnh:
```dart
Get.put<S>(
  // mandatory: the class that you want to get to save, like a controller or anything
  // note: "S" means that it can be a class of any type
  S dependency

  // optional: this is for when you want multiple classess that are of the same type
  // since you normally get a class by using Get.find<Controller>(),
  // you need to use tag to tell which instance you need
  // must be unique string
  String tag,

  // optional: by default, get will dispose instances after they are not used anymore (example,
  // the controller of a view that is closed), but you might need that the instance
  // to be kept there throughout the entire app, like an instance of sharedPreferences or something
  // so you use this
  // defaults to false
  bool permanent = false,

  // optional: allows you after using an abstract class in a test, replace it with another one and follow the test.
  // defaults to false
  bool overrideAbstract = false,

  // optional: allows you to create the dependency using function instead of the dependency itself.
  // this one is not commonly used
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
Có thể lazyLoad một dependecy để nó chỉ được khởi tạo khi được sử dụng. Rất hữu ích cho các class ngốn nhiều tài nguyên hoặc nếu bạn muốn khởi tạo một số class chỉ ở một nơi (như trong class Bindings) và bạn biết rằng mình sẽ không sử dụng class đó tại thời điểm nhất định.

```dart
/// ApiMock will only be called when someone uses Get.find<ApiMock> for the first time
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    // ... some logic if needed
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

Đây là các tùy chọn bạn có thể đặt lệnh:
```dart
Get.lazyPut<S>(
  // mandatory: a method that will be executed when your class is called for the first time
  InstanceBuilderCallback builder,
  
  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: It is similar to "permanent", the difference is that the instance is discarded when
  // is not being used, but when it's use is needed again, Get will recreate the instance
  // just the same as "SmartManagement.keepFactory" in the bindings api
  // defaults to false
  bool fenix = false
  
)
```

### Get.putAsync
 Đây là khi bạn muốn xài asynchronize code `Get.putAsync`:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

Đây là tùy chọn bạn có thể đặt lệnh với putAsync:
```dart
Get.putAsync<S>(

  // mandatory: an async method that will be executed to instantiate your class
  AsyncInstanceBuilderCallback<S> builder,

  // optional: same as Get.put(), it is used for when you want multiple different instance of a same class
  // must be unique
  String tag,

  // optional: same as in Get.put(), used when you need to maintain that instance alive in the entire app
  // defaults to false
  bool permanent = false
)
```

### Get.create

Cái này hơi khó giải thích, nhưng sự khác nhau giữa chúng có thể được tìm thấy trên mục [Differences between methods:](#differences-between-methods)

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

Tùy chọn có thể sử dụng:

```dart
Get.create<S>(
  // required: a function that returns a class that will be "fabricated" every
  // time `Get.find()` is called
  // Example: Get.create<YourClass>(() => YourClass())
  FcBuilderFunc<S> builder,

  // optional: just like Get.put(), but it is used when you need multiple instances
  // of a of a same class
  // Useful in case you have a list that each item need it's own controller
  // needs to be a unique string. Just change from tag to name
  String name,

  // optional: just like int`Get.put()`, it is for when you need to keep the
  // instance alive thoughout the entire app. The difference is in Get.create
  // permanent is true by default
  bool permanent = true
```

## Sử dụng các phương thức / class

Hãy tưởng tượng rằng bạn đã điều hướng qua nhiều route và bạn cần một dữ liệu còn sót trong controller của mình, bạn sẽ cần một trình quản lý state kết hợp với Provider hoặc Get_it, phải hem? Với Get, bạn chỉ cần yêu cầu Get to "find" cho controller của mình và thế là xong:

```dart
final controller = Get.find<Controller>();
// OR
Controller controller = Get.find();

// Yes, it looks like Magic, Get will find your controller, and will deliver it to you.
// You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Và sau đó, bạn sẽ có thể khôi phục dữ liệu controller của mình đã lấy được ở đó:

```dart
Text(controller.textFromApi);
```

Vì giá trị trả về là một class bình thường, bạn có thể làm bất cứ điều gì bạn muốn:
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

Để xóa một controller đang chạy ngầm của Get:

```dart
Get.delete<Controller>(); //thường thì Get tự xóa, bạn không cần phải đặt lệnh này.
```

## Khác nhau giữa phương thức (methods)

Đầu tiên, hãy nói về `fenix` của Get.lazyPut và `permanent`của các phương thức khác.

Sự khác biệt cơ bản giữa `permanent` và `fenix` là cách bạn muốn lưu trữ các cá thể của mình.

Củng cố: theo mặc định, GetX xóa các trường hợp khi chúng không được sử dụng.
Có nghĩa là: Nếu màn hình 1 có controller 1 và màn hình 2 có controller 2 và bạn xóa route đầu tiên khỏi stack, (chẳng hạn như nếu bạn sử dụng `` Get.off () 'hoặc' `Get.offNamed()``) thì controller 1 bị mất việc sử dụng nó vì vậy nó sẽ bị xóa.

Nhưng nếu bạn muốn chọn sử dụng `permanent: true`, thì controller sẽ không bị mất trong quá trình chuyển đổi này - điều này rất hữu ích cho các dịch vụ mà bạn muốn duy trì hoạt động trong toàn bộ ứng dụng.

Mặt khác, `fenix` dành cho các dịch vụ mà bạn không lo bị mất giữa các lần thay đổi màn hình, nhưng khi bạn cần dịch vụ đó, bạn hy vọng rằng nó vẫn tồn tại. Vì vậy, về cơ bản, nó sẽ loại bỏ controller / service / class không sử dụng, nhưng khi bạn cần, nó sẽ "tạo lại từ đống tro tàn" ở một trường hợp (instance) mới.

Tiếp tục với sự khác biệt giữa các phương pháp:

- Get.put và Get.putAsync tuân theo cùng một thứ tự tạo, với sự khác biệt là một cái sử dụng phương thức không đồng bộ: hai phương thức đó đều tạo và khởi tạo các trường hợp. Cái sử dụng không đồng bộ được chèn trực tiếp vào bộ nhớ, bằng cách sử dụng phương thức nội bộ `insert` với các tham số `permanent: false` và` isSingleton: true` (tham số isSingleton này chỉ nhằm mục đích cho biết liệu nó có sử dụng dependency vào `dependency` hay không hoặc nếu nó được sử dụng dependency vào `FcBuilderFunc`). Sau đó, `Get.find ()` được gọi để khởi tạo ngay lập tức các các trường hợp trên bộ nhớ.

- Get.create: Như tên của nó, nó sẽ "tạo ra" sự dependency cho bạn! Tương tự như `Get.put ()`, nó cũng gọi phương thức nội bộ là `insert` để các trường hợp. Nhưng `permanent` trở thành true và` isSingleton` trở thành false (vì chúng ta đang "tạo" dependency của mình, không có cách nào để nó là một instace singleton, đó là lý do tại sao lại là false). Và bởi vì nó có `permanent: true`, chúng tôi mặc định có lợi ích là không bị mất nó giữa các màn hình! Ngoài ra, `` Get.find () 'không được gọi ngay lập tức, nó phải chờ được sử dụng trong màn hình để được gọi. Nó được tạo ra theo cách này để sử dụng tham số `permanent ', vì vậy, đáng chú ý là` Get.create () `được tạo ra với mục tiêu tạo ra các phiên bản không được chia sẻ, nhưng không bị loại bỏ, như ví dụ: trong listView, mà bạn muốn có một phiên bản duy nhất cho danh sách đó - do đó, Get.create phải được sử dụng cùng với GetWidget.

- Get.lazyPut: Như tên của nó, nó là một quy trình lười biếng. Cá thể được tạo, nhưng nó không được gọi để sử dụng ngay lập tức, nó vẫn đang chờ được gọi. Trái ngược với các phương thức khác, `insert` không được gọi ở đây. Thay vào đó, cá thể được chèn vào một phần khác của bộ nhớ, một phần chịu trách nhiệm cho biết liệu cá thể đó có thể được tạo lại hay không, chúng ta hãy gọi nó là "nhà máy". Nếu chúng ta muốn tạo ra thứ gì đó để sử dụng sau này, nó sẽ không bị trộn lẫn với những thứ đã được sử dụng ngay bây giờ. Và đây là nơi phép thuật của `fenix` đi vào: nếu bạn chọn bỏ` fenix: false`, và `smartManagement` của bạn không phải là` keepFactory`, thì khi sử dụng `Get.find`, instance sẽ thay đổi vị trí trong bộ nhớ từ "nhà máy" đến vùng bộ nhớ cá thể chung. Ngay sau đó, theo mặc định, nó được xóa khỏi "nhà máy". Bây giờ, nếu bạn chọn `fenix: true`, cá thể vẫn tiếp tục tồn tại trong phần dành riêng này, thậm chí sẽ chuyển sang vùng chung, sẽ được gọi lại trong tương lai.

## Bindings

Có lẽ, một trong những điểm khác biệt lớn của gói này là khả năng tích hợp đầy đủ các route, trình quản lý state và trình quản lý dependency.
Khi một route bị xóa khỏi stack, tất cả các controller, biến và phiên bản của các đối tượng liên quan đến nó sẽ bị xóa khỏi bộ nhớ. Nếu bạn đang sử dụng luồng hoặc bộ hẹn giờ, chúng sẽ tự động bị đóng và bạn không phải lo lắng về bất kỳ điều gì trong số đó.
Trong phiên bản 2.10 Được triển khai hoàn toàn API bindings.
Bây giờ bạn không cần sử dụng phương thức init nữa. Bạn thậm chí không cần phải nhập controller của mình nếu bạn không muốn. Bạn có thể khởi động controller và dịch vụ của mình ở nơi thích hợp cho việc đó.
Lớp Binding là một class sẽ tách riêng việc tiêm dependency, trong khi "bindings" các route đường tới trình quản lý state và trình quản lý dependency.
Điều này cho phép Nhận biết màn hình nào đang được hiển thị khi một controller cụ thể được sử dụng và biết vị trí và cách vứt bỏ nó.
Ngoài ra, class Binding sẽ cho phép bạn kiểm soát cấu hình SmartManager. Bạn có thể định cấu hình các phần dependency được sắp xếp khi xóa một route khỏi ngăn xếp hoặc khi widget con đã sử dụng nó được bố trí hoặc không. Bạn sẽ có quản lý dependency thông minh làm việc cho bạn, nhưng ngay cả như vậy, bạn có thể định cấu hình nó theo ý muốn.

### Bindings class

- Tạo một class và implements Binding

```dart
class HomeBinding implements Bindings {}
```

IDE của bạn sẽ tự động yêu cầu bạn ghi đè phương thức "dependency" và bạn chỉ cần nhấp vào đèn, ghi đè phương thức và chèn tất cả các class bạn sẽ sử dụng trên route đó:

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

Bây giờ bạn chỉ cần thông báo route của mình, rằng bạn sẽ sử dụng bindings đó để tạo kết nối giữa trình quản lý route, các dependency và state.

- Sử dụng routes có tên:

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

- Sử dụng routes thường:

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

Ở đó, bạn không phải lo lắng về việc quản lý bộ nhớ của ứng dụng của mình nữa, Get sẽ thay bạn làm điều đó.

Lớp Binding được gọi khi một route được gọi, bạn có thể tạo một "InitialBinding trong GetMaterialApp của mình để chèn tất cả các dependency sẽ được tạo.

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

Cách mặc định để tạo bindings là tạo một class thực hiện các bindings.
Nhưng cách khác, bạn có thể sử dụng lệnh gọi lại `BindingsBuilder` để bạn có thể chỉ cần sử dụng một hàm để khởi tạo bất cứ thứ gì bạn muốn.

Example:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(()=> Api());
    }),
  ),
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
  ),
];
```

Bằng cách đó, bạn có thể tránh tạo một class Binding cho mỗi routes, làm cho việc này trở nên đơn giản hơn.

Cả hai cách làm việc đều hoàn toàn tốt và chúng tôi muốn bạn sử dụng những gì phù hợp với sở thích của bạn nhất.

### SmartManagement

GetX theo mặc định loại bỏ controller không sử dụng khỏi bộ nhớ, ngay cả khi xảy ra lỗi và widget con sử dụng nó không được xử lý đúng cách.
Đây được gọi là chế độ quản lý dependency `` đầy đủ`.
Nhưng nếu bạn muốn thay đổi cách GetX kiểm soát việc xử lý các class, bạn có class `SmartManagement` để bạn có thể thiết lập các hành vi khác nhau.

#### Cách thay đổi

Nếu bạn muốn thay đổi cấu hình này (mà bạn thường không cần) thì đây là cách:

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

Nó là một trong những mặc định. Loại bỏ các class không được sử dụng và không được đặt thành vĩnh viễn. Trong phần lớn các trường hợp, bạn sẽ muốn giữ nguyên cấu hình này. Nếu bạn mới sử dụng GetX thì đừng thay đổi điều này.

#### SmartManagement.onlyBuilders
Với tùy chọn này, chỉ những controller bắt đầu trong `init: 'hoặc được tải vào Binding với` `Get.lazyPut ()` mới được xử lý.

Nếu bạn sử dụng `Get.put () 'hoặc' Get.putAsync ()` hoặc bất kỳ cách tiếp cận nào khác, SmartManagement sẽ không có quyền loại trừ sự dependency này.

Với hành vi mặc định, ngay cả các widget con được khởi tạo bằng "Get.put" sẽ bị xóa, không giống như SmartManagement.onlyBuilders.

#### SmartManagement.keepFactory

Cũng giống như SmartManagement.full, nó sẽ loại bỏ các phần dependency của nó khi nó không được sử dụng nữa. Tuy nhiên, nó sẽ giữ nguyên chế độ factory của họ, có nghĩa là nó sẽ tạo lại phần dependency nếu bạn cần lại phiên bản đó.

### Cách bindings làm việc ngầm
Các liên kết tạo ra các factory tạm thời, được tạo ra ngay khi bạn nhấp để chuyển sang màn hình khác và sẽ bị phá hủy ngay sau khi hoạt ảnh thay đổi màn hình xảy ra.
Điều này xảy ra quá nhanh đến nỗi máy phân tích thậm chí sẽ không thể đăng ký nó.
Khi bạn điều hướng đến màn hình này một lần nữa, một factory tạm thời mới sẽ được gọi, vì vậy điều này thích hợp hơn khi sử dụng SmartManagement.keepFactory, nhưng nếu bạn không muốn tạo Bindings hoặc muốn giữ tất cả các dependency của mình trên cùng một Binding, thì chắc chắn sẽ giúp ích cho bạn.
Các factory chiếm ít bộ nhớ, chúng không chứa các cá thể mà là một chức năng có "hình dạng" của class đó mà bạn muốn.
Điều này có chi phí bộ nhớ rất thấp, nhưng vì mục đích của lib này là để đạt được hiệu suất tối đa có thể bằng cách sử dụng tài nguyên tối thiểu, Get xóa ngay cả các factory theo mặc định.
Sử dụng cái nào thuận tiện nhất cho bạn.

## Chí ú

- KHÔNG SỬ DỤNG SmartManagement.keepFactory nếu bạn đang sử dụng nhiều Binding. Nó được thiết kế để sử dụng mà không có Bindings, hoặc với một Bindings duy nhất được liên kết trong `initialBinding` của GetMaterialApp.

- Việc sử dụng Bindings là hoàn toàn tùy chọn, nếu muốn, bạn có thể sử dụng `Get.put () 'và' Get.find()` trên các class sử dụng controller nhất định mà không gặp bất kỳ vấn đề gì.
Tuy nhiên, nếu bạn làm việc với Service hoặc bất kỳ abstract nào khác, tôi khuyên bạn nên sử dụng Bindings để tổ chức tốt hơn.

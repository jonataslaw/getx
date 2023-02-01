- [Quản lý route](#route-management)
  - [Hướng dẫn sử dụng trước khi dùng](#how-to-use)
  - [Điều hướng không cần tên](#navigation-without-named-routes)
  - [Điều hướng cần tên](#navigation-with-named-routes)
    - [Gửi data cho route có tên](#send-data-to-named-routes)
    - [Dynamic urls links](#dynamic-urls-links)
    - [Middleware](#middleware)
  - [Điều hướng không cần context](#navigation-without-context)
    - [SnackBars](#snackbars)
    - [Dialogs](#dialogs)
    - [BottomSheets](#bottomsheets)
  - [Điều hướng lồng (Nested Navigation)](#nested-navigation)

# Quản lý route

Đây là lời giải thích đầy đủ về tất cả những gì có cho Getx khi vấn đề là quản lý routes.

## Hướng dẫn sử dụng trước khi dùng

Thêm cái này vào file pubspec.yaml của bạn:

```yaml
dependencies:
  get:
```

Nếu bạn định sử dụng các routes / snackbars / dialogs / bottomsheets mà không có "context" hoặc sử dụng các API cấp cao, bạn chỉ cần thêm Get trước MaterialApp của mình, biến nó thành GetMaterialApp và tung hành!

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

## Điều hướng không cần tên

Để điều hướng đến một màn hình mới:

```dart
Get.to(NextScreen());
```

Để đóng snackbars, dialog, bottomsheets hoặc bất cứ thứ gì bạn thường đóng bằng Navigator.pop (context);

```dart
Get.back();
```

Để chuyển đến màn hình tiếp theo và không có tùy chọn nào để quay lại màn hình trước đó (để sử dụng trong SplashScreens, màn hình đăng nhập, v.v.)

```dart
Get.off(NextScreen());
```

Để chuyển đến màn hình tiếp theo và hủy tất cả các lộ trình trước đó (hữu ích trong giỏ hàng, polls và test)

```dart
Get.offAll(NextScreen());
```

Để điều hướng đến routes tiếp theo và nhận hoặc cập nhật dữ liệu ngay sau khi bạn trở về từ routes đó:

```dart
var data = await Get.to(Payment());
```

trên màn hình khác, gửi dữ liệu cho routes trước đó:

```dart
Get.back(result: 'success');
```

And use it:

ex:

```dart
if(data == 'success') madeAnything();
```

Bạn không muốn học cú pháp của chúng tôi?
Chỉ cần thay đổi Navigator (chữ in hoa) thành navigator (chữ thường) và bạn sẽ có tất cả các chức năng của điều hướng tiêu chuẩn mà không cần phải sử dụng "context"
Thí dụ:

```dart

// Default Flutter navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// Get using Flutter syntax without needing context
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// Get syntax (It is much better, but you have the right to disagree)
Get.to(HomePage());


```

## Điều hướng cần tên

- Nếu bạn thích điều hướng bằng tên, Get cũng hỗ trợ điều này.

To navigate to nextScreen

```dart
Get.toNamed("/NextScreen");
```

Để điều hướng và xóa màn hình trước đó khỏi cây widget.

```dart
Get.offNamed("/NextScreen");
```

Để điều hướng và xóa tất cả các màn hình trước đó khỏi cây widget.

```dart
Get.offAllNamed("/NextScreen");
```

Để định dạng routes, sử dụng GetMaterialApp:

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
        GetPage(
          name: '/third',
          page: () => Third(),
          transition: Transition.zoom  
        ),
      ],
    )
  );
}
```

Để xử lý điều hướng đến các routes không được xác định (lỗi 404), bạn có thể xác định trang 'không xác định' trong GetMaterialApp.

```dart
void main() {
  runApp(
    GetMaterialApp(
      unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
      ],
    )
  );
}
```

### Gửi data cho route có tên

Chỉ cần gửi những gì bạn muốn cho các đối số (arguments). Get chấp nhận bất kỳ thứ gì ở đây, cho dù đó là String, Map, List hay thậm chí là một class trường hợp.

```dart
Get.toNamed("/NextScreen", arguments: 'Get is the best');
```

Trong class controller của bạn:

```dart
print(Get.arguments);
//print out: Get is the best
```

### Dynamic urls links

Get hỗ trợ các url động nâng cao giống như trên Web. Các nhà phát triển web có lẽ đã muốn tính năng này trên Flutter và rất có thể đã thấy một gói hứa hẹn tính năng này và cung cấp một cú pháp hoàn toàn khác so với một URL sẽ có trên web, và Get cũng giải quyết được điều này.

```dart
Get.offAllNamed("/NextScreen?device=phone&id=354&name=Enzo");
```

trong controller/bloc/stateful/stateless của class:

```dart
print(Get.parameters['id']);
// out: 354
print(Get.parameters['name']);
// out: Enzo
```

Bạn có thể đặt NamedParameters với Get dễ dàng:

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
      GetPage(
        name: '/',
        page: () => MyHomePage(),
      ),
      GetPage(
        name: '/profile/',
        page: () => MyProfile(),
      ),
       //You can define a different page for routes with arguments, and another without arguments, but for that you must use the slash '/' on the route that will not receive arguments as above.
       GetPage(
        name: '/profile/:user',
        page: () => UserProfile(),
      ),
      GetPage(
        name: '/third',
        page: () => Third(),
        transition: Transition.cupertino  
      ),
     ],
    )
  );
}
```

Gửi data bằng tên

```dart
Get.toNamed("/profile/34954");
```

Trên màn hình thứ hai, lấy dữ liệu theo tham số (parameters)

```dart
print(Get.parameters['user']);
// out: 34954
```

hoặc gửi nhiều tham số như thế này

```dart
Get.toNamed("/profile/34954?flag=true&country=italy");
```
or
```dart
var parameters = <String, String>{"flag": "true","country": "italy",};
Get.toNamed("/profile/34954", parameters: parameters);
```

Trên màn hình thứ hai, lấy dữ liệu theo các tham số như thường lệ

```dart
print(Get.parameters['user']);
print(Get.parameters['flag']);
print(Get.parameters['country']);
// out: 34954 true italy
```



Và bây giờ, tất cả những gì bạn cần làm là sử dụng Get.toNamed () để điều hướng các routes đã đặt tên của bạn mà không cần bất kỳ "context" nào (bạn có thể gọi các routes của mình trực tiếp từ BLoC hoặc lớp Bộ điều khiển) và khi ứng dụng của bạn được biên dịch lên web, các routes sẽ xuất hiện trong url <3

### Middleware

Nếu bạn muốn nghe Get events để kích hoạt các hành động, bạn có thể sử dụng routingCallback cho nó

```dart
GetMaterialApp(
  routingCallback: (routing) {
    if(routing.current == '/second'){
      openAds();
    }
  }
)
```

Nếu bạn không sử dụng GetMaterialApp, bạn có thể sử dụng API thủ công để đính kèm trình quan sát Middleware.

```dart
void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: "/",
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(MiddleWare.observer), // HERE !!!
      ],
    ),
  );
}
```

Tạo một MiddleWare class

```dart
class MiddleWare {
  static observer(Routing routing) {
    /// You can listen in addition to the routes, the snackbars, dialogs and bottomsheets on each screen.
    ///If you need to enter any of these 3 events directly here,
    ///you must specify that the event is != Than you are trying to do.
    if (routing.current == '/second' && !routing.isSnackbar) {
      Get.snackbar("Hi", "You are on second route");
    } else if (routing.current =='/third'){
      print('last route called');
    }
  }
}
```

Bây giờ, hãy sử dụng Get trên code của bạn:

```dart
class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/second");
          },
        ),
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "i am a modern snackbar");
          },
        ),
        title: Text('second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Get.toNamed("/third");
          },
        ),
      ),
    );
  }
}

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
```

## Điều hướng không cần context

### SnackBars

Để có một SnackBar đơn giản với Flutter, bạn phải lấy context của Scaffold, hoặc bạn phải sử dụng GlobalKey được gắn vào Scaffold của bạn

```dart
final snackBar = SnackBar(
  content: Text('Hi!'),
  action: SnackBarAction(
    label: 'I am a old and ugly snackbar :(',
    onPressed: (){}
  ),
);
// Find the Scaffold in the widget tree and use
// it to show a SnackBar.
Scaffold.of(context).showSnackBar(snackBar);
```

With Get:

```dart
Get.snackbar('Hi', 'i am a modern snackbar');
```

Với Get, tất cả những gì bạn phải làm là gọi thanh Get.snackbar từ bất kỳ đâu trong code của bạn hoặc tùy chỉnh nó theo cách bạn muốn!

```dart
Get.snackbar(
  "Hey i'm a Get SnackBar!", // title
  "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
  icon: Icon(Icons.alarm),
  shouldIconPulse: true,
  onTap:(){},
  barBlur: 20,
  isDismissible: true,
  duration: Duration(seconds: 3),
);


  ////////// ALL FEATURES //////////
  //     Color colorText,
  //     Duration duration,
  //     SnackPosition snackPosition,
  //     Widget titleText,
  //     Widget messageText,
  //     bool instantInit,
  //     Widget icon,
  //     bool shouldIconPulse,
  //     double maxWidth,
  //     EdgeInsets margin,
  //     EdgeInsets padding,
  //     double borderRadius,
  //     Color borderColor,
  //     double borderWidth,
  //     Color backgroundColor,
  //     Color leftBarIndicatorColor,
  //     List<BoxShadow> boxShadows,
  //     Gradient backgroundGradient,
  //     TextButton mainButton,
  //     OnTap onTap,
  //     bool isDismissible,
  //     bool showProgressIndicator,
  //     AnimationController progressIndicatorController,
  //     Color progressIndicatorBackgroundColor,
  //     Animation<Color> progressIndicatorValueColor,
  //     SnackStyle snackStyle,
  //     Curve forwardAnimationCurve,
  //     Curve reverseAnimationCurve,
  //     Duration animationDuration,
  //     double barBlur,
  //     double overlayBlur,
  //     Color overlayColor,
  //     Form userInputForm
  ///////////////////////////////////
```

Nếu bạn thích snackbar truyền thống hoặc muốn tùy chỉnh nó từ đầu, bao gồm chỉ thêm một dòng (Get.snackbar sử dụng tiêu đề và thông báo bắt buộc), bạn có thể sử dụng
`Get.rawSnackbar ()`; 'cung cấp API RAW trên đó Get.

### Dialogs

To open dialog:

```dart
Get.dialog(YourDialogWidget());
```

To open default dialog:

```dart
Get.defaultDialog(
  onConfirm: () => print("Ok"),
  middleText: "Dialog made in 3 lines of code"
);
```

Bạn cũng có thể sử dụng Get.generalDialog thay vì showGeneralDialog.

Đối với tất cả các tiện ích hộp thoại Flutter khác, bao gồm cả cupertinos, bạn có thể sử dụng Get.overlayContext thay vì context và mở nó ở bất kỳ đâu trong mã của bạn.
Đối với các widget không sử dụng Overlay, bạn có thể sử dụng Get.context.
Hai context này sẽ hoạt động trong 99% trường hợp để thay thế context của UI của bạn, ngoại trừ các trường hợp trong đó inheritWidget được sử dụng mà không có context điều hướng.

### BottomSheets

Get.bottomSheet giống như showModalBottomSheet, nhưng không cần context.

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Music'),
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.videocam),
          title: Text('Video'),
          onTap: () {},
        ),
      ],
    ),
  )
);
```

## Điều hướng lồng (Nested Navigation)

Làm cho điều hướng lồng (nested navigation) của Flutter thậm chí còn dễ dàng hơn.
Bạn không cần context và bạn sẽ tìm thấy stack điều hướng của mình theo Id.

- CHÍ Ú: Việc tạo các stack điều hướng song song có thể gây nguy hiểm. Lý tưởng nhất là không sử dụng NestedNavigators, hoặc sử dụng một cách tối thiểu. Nếu dự án của bạn yêu cầu, hãy tiếp tục, nhưng hãy nhớ rằng việc giữ nhiều stack điều hướng trong bộ nhớ có thể không phải là một ý tưởng hay cho việc tiêu thụ RAM.

Xem nó code đơn giản nè:

```dart
Navigator(
  key: Get.nestedKey(1), // create a key by index
  initialRoute: '/',
  onGenerateRoute: (settings) {
    if (settings.name == '/') {
      return GetPageRoute(
        page: () => Scaffold(
          appBar: AppBar(
            title: Text("Main"),
          ),
          body: Center(
            child: TextButton(
              color: Colors.blue,
              onPressed: () {
                Get.toNamed('/second', id:1); // navigate by your nested route by index
              },
              child: Text("Go to second"),
            ),
          ),
        ),
      );
    } else if (settings.name == '/second') {
      return GetPageRoute(
        page: () => Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Main"),
            ),
            body: Center(
              child:  Text("second")
            ),
          ),
        ),
      );
    }
  }
),
```

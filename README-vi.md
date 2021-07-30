![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

**Ngôn ngữ: Tiếng Việt (file này), [English](README.md), [Indonesian](README.id-ID.md), [Urdu](README.ur-PK.md), [Chinese](README.zh-cn.md), [Brazilian Portuguese](README.pt-br.md), [Spanish](README-es.md), [Russian](README.ru.md), [Polish](README.pl.md), [Korean](README.ko-kr.md), [French](README-fr.md).**

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

- [Về Getx](#về-getx)
- [Cài Đặt](#cài-đặt)
- [Counter App với GetX](#counter-app-với-getx)
- [Tam Trụ](#tam-trụ)
  - [Quản lý State](#quản-lý-state)
    - [Quản lý Reactive State](#quản-lý-reactive-state)
    - [Thêm thông tin về quản lý state](#thêm-thông-tin-về-quản-lý-state)
  - [Quản lý route](#quản-lý-route)
    - [Thêm thông tin về quản lý route](#thêm-thông-tin-về-quản-lý-route)
  - [Quản lý dependency](#quản-lý-dependency)
    - [Thêm thông tin về quản lý dependency](#thêm-thông-tin-về-quản-lý-dependency)
- [Utils](#utils)
  - [Internationalization](#internationalization)
    - [Dịch thuật](#dịch-thuật)
      - [Sử dụng bản dịch thuật](#sử-dụng-bản-dịch-thuật)
    - [Locales](#locales)
      - [Đổi locale](#đổi-locale)
      - [System locale](#system-locale)
  - [Đổi Theme](#đổi-theme)
  - [GetConnect](#getconnect)
    - [Cấu hình mặc định](#cấu-hình-mặc-định)
    - [Tùy chỉnh](#tùy-chỉnh)
  - [GetPage Middleware](#getpage-middleware)
    - [Ưu tiên](#ưu-tiên)
    - [Chuyển hướng](#chuyển-hướng)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [APIs nâng cao khác](#apis-nâng-cao-khác)
    - [Cấu hình thủ công và cài đặt chung tuỳ chọn](#cấu-hình-thủ-công-và-cài-đặt-chung-tuỳ-chọn)
    - [Local State Widgets](#local-state-widgets)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [Mẹo hữu ích](#mẹo-hữu-ích)
    - [GetView](#getview)
    - [GetResponsiveView](#getresponsiveview)
      - [Hướng dẫn sử dụng trước khi dùng](#hướng-dẫn-sử-dụng-trước-khi-dùng)
    - [GetWidget](#getwidget)
    - [GetxService](#getxservice)
- [Thay đổi đột phá 2.0](#thay-đổi-đột-phá-2.0)
- [Tại sao lại dùng GetX](#tại-sao-lại-dùng-getx)
- [Cộng đồng](#cộng-đồng)
  - [Kênh Cộng đồng](#kênh-cộng-đồng)
  - [Cách cống hiến](#cách-cống-hiến)
  - [Các bài báo và video](#các-bài-báo-và-video)

# Về Getx

- GetX hướng tới sự nhỏ gọn và giải pháp tối ưu cho Flutter với tốc độ ưu việt trong quản lý state, nạp dependency thông minh, và quản lý route nhanh chóng và thực tế.

- GetX hướng tới 3 tham vọng chính, nghĩa là tất cả các tài nguyên của thư viện sẽ dành cho những điểm ưu tiên sau: **NĂNG SUẤT, HIỆU SUẤT VÀ TỔ CHỨC.**

  - **HIỆU SUẤT:** GetX tập trung vào hiệu suất và mức tiêu thụ tài nguyên tối thiểu, do đó nó không sử dụng Streams hoặc ChangeNotifier.

  - **NĂNG SUẤT:** GetX sử dụng một cú pháp dễ dàng và dễ thở. Bất kể bạn muốn làm gì, luôn có một cách dễ dàng hơn với GetX. Nó sẽ tiết kiệm hàng giờ phát triển và sẽ cung cấp hiệu suất tối đa mà ứng dụng của bạn có thể mang lại.

    Nói chung, nhà phát triển nên quan tâm đến việc xóa những controller ra khỏi bộ nhớ. Với GetX, mặc định các tài nguyên sẽ
    TỰ ĐỘNG xóa khỏi bộ nhớ khi không dùng nữa. Nếu bạn muốn giữ nó trong bộ nhớ, bạn phải khai báo rõ ràng "permanent: true" trong phần dependency của mình. Từ đó, bạn sẽ tiết kiệm thời gian và giảm rủi ro khi phụ thuộc vào bộ nhớ. Theo mặc định, tính năng tải dependency cũng lười biếng.

  - **TỔ CHỨC:**
    GetX cho phép tách toàn bộ View, presentation logic, business logic, nạp dependencies và điều hướng. Bạn không cần "context" để điều hướng giữa các route, vì vậy bạn sẽ độc lập trong sơ đồ widget (trực quan hóa). Bạn không cần "context" để truy cập Controller / Blocs của mình thông qua một InheritedWidget, vì vậy bạn hoàn toàn tách rời presentation logic và business logic ra khỏi lớp trực quan của mình. Bạn không cần phải đưa các Controller / Models / Blocs vào sơ đồ widget của mình thông qua `MultiProvider`, vì GetX sử dụng tính năng nạp dependency của riêng nó, tách hoàn toàn DI khỏi chế độ xem của nó.

    Với GetX, bạn biết nơi tìm từng tính năng ứng dụng của mình, với cơ chế clean code theo mặc định. Ngoài việc giúp bảo trì dễ dàng, GetX giúp việc chia sẻ các mô-đun trở thành khả thi trong Flutter.
    BLoC là điểm khởi đầu để tổ chức code trong Flutter, nó tách biệt business logic ra khỏi lớp trực quan hóa (visualization). GetX nảy sinh từ điều này, không chỉ tách biệt presentation logic mà còn cả business logic. Nạp dependency bổ sung và route cũng được tách ra và lớp dữ liệu cũng biến mất. Bạn sẽ biết mọi thứ ở đâu và sẽ hình dung tất cả những điều này dễ hơn cả xây dựng chương trình "Hello World".
    GetX là cách dễ nhất, thiết thực và có thể mở rộng để xây dựng các ứng dụng hiệu suất cao với Flutter SDK. GetX chứa đựng một hệ sinh thái rộng lớn xung quanh nó hoạt động hoàn hảo cùng nhau, rất dễ dàng cho người mới bắt đầu và nó chính xác cho các chuyên gia. Nó an toàn, ổn định, luôn cập nhật và cung cấp một loạt các API được tích hợp sẵn mà không có trong Flutter SDK mặc định.

- GetX không cồng kềnh và có vô số tính năng cho phép bạn bắt đầu lập trình mà không cần lo lắng về bất cứ điều gì. Đặc biệt, nó cho phép mỗi tính năng này nằm trong các vùng chứa riêng biệt và chỉ được bắt đầu sau khi sử dụng. Nếu bạn chỉ sử dụng phần quản lý state của GetX thì sẽ chỉ có quản lý state được sử dụng. Nếu bạn chỉ sử dụng route, thì GetX không biên dịch phần quản lý state.

- GetX có một hệ sinh thái khổng lồ, một cộng đồng lớn, một số lượng lớn cộng tác viên và sẽ được duy trì miễn là Flutter còn tồn tại. GetX có khả năng chạy cùng một mã (code) trên Android, iOS, Web, Mac, Linux, Windows và trên máy chủ của bạn.
  **Bạn hoàn toàn có thể sử dụng lại mã của mình trên frontend qua backend với [Get Server](https://github.com/jonataslaw/get_server)**.

**Ngoài ra, toàn bộ quá trình phát triển có thể hoàn toàn tự động, cả trên máy chủ và frontend với [Get CLI](https://github.com/jonataslaw/get_cli)**.

**Ngoài ra, nhằm tăng thêm năng suất của bạn, chúng tôi hỗ trợ
[tiện ích trên VSCode](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets) và [tiện ích cho Android Studio/Intellij](https://plugins.jetbrains.com/plugin/14975-getx-snippets)**

# Cài Đặt

Thêm Get vào file pubspec.yaml:

```yaml
dependencies:
  get:
```

Import get vào file cần sử dụng:

```dart
import 'package:get/get.dart';
```

# Counter App với GetX

Dự án "counter" được tạo theo mặc định trên dự án mới trên Flutter có hơn 100 dòng (có comments). Để thể hiện sức mạnh của Get, tôi sẽ trình bày cách tạo "counter" thay đổi trạng thái với mỗi lần nhấp, chuyển đổi giữa các trang và chia sẻ trạng thái giữa các màn hình, tất cả đều theo cách có tổ chức, tách biệt logic nghiệp vụ khỏi chế độ xem, CHỈ VỚI 26 DÒNG!

- Bước 1:
  Thêm "Get" trước MaterialApp, nó sẽ thành GetMaterialApp

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- Chú ý: điều này không sửa đổi MaterialApp của Flutter, GetMaterialApp không phải là MaterialApp được sửa đổi, nó chỉ là một Widget được tạo trước với MaterialApp mặc định là child. Bạn có thể cấu hình điều này theo cách thủ công, nhưng nó chắc chắn là không cần thiết. GetMaterialApp sẽ tạo các route, đưa chúng vào, đưa bản dịch, đưa mọi thứ bạn cần để điều hướng route. Nếu bạn chỉ sử dụng Get để quản lý trạng thái hoặc quản lý phụ thuộc, thì không cần thiết phải sử dụng GetMaterialApp. Tóm lại, GetMaterialApp chỉ cần thiết cho các route, snacksbar, internationalization, bottomSheets, Dialog và các APIs cấp cao liên quan đến route và không có "context".
- Chú ý²: Một lần nữa, bước này chỉ cần thiết nếu bạn sử dụng quản lý route (`Get.to ()`, `Get.back ()`, v.v.). Nếu bạn không sử dụng nó thì không cần thực hiện bước 1

- Bước 2:
  Tạo lớp business logic của bạn và đặt tất cả các biến (variables), hàm (function) và controller bên trong nó.
  Bạn có thể làm cho bất kỳ biến nào có thể quan sát được đơn giản bằng cách sử dụng ".obs".

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- Bước 3:
  Tạo widget của bạn, sử dụng StatelessWidget và tiết kiệm RAM, với Get, bạn có thể không cần sử dụng StatefulWidget nữa.

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

Kết quả:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

Đây là một dự án đơn giản nhưng nó đã cho thấy rõ sức mạnh của Get. Khi dự án của bạn phát triển, sự khác biệt này sẽ trở nên đáng kể hơn.

Get được thiết kế để làm việc với các nhóm, nhưng nó làm cho công việc của một nhà phát triển cá nhân trở nên đơn giản.

Cải thiện thời gian, giao mọi thứ đúng hạn mà không làm giảm hiệu suất. Get không dành cho tất cả mọi người, nhưng nếu bạn đã xác định gắn với Get, Get sẽ "get" bạn!

# Tam Trụ

## Quản lý State

Get có 2 cách quản lý trạng thái (state managers) khác nhau : quản lý trạng thái đơn giản (chúng ta gọi nó là GetBuilder) và quản lý trạng thái phản ứng (the reactive state manager) (GetX/Obx).

### Quản lý Reactive State

Lập trình phản ứng (reactive programming) có thể khiến nhiều người xa lánh vì nó được cho là phức tạp. GetX biến lập trình phản ứng thành một thứ khá đơn giản:

- Bạn sẽ không cần tạo StreamControllers.
- Bạn sẽ không cần tạo StreamBuilder cho mỗi biến.
- Bạn sẽ không cần tạo một lớp (class) cho mỗi trạng thái.
- Bạn sẽ không cần tạo get cho một giá trị ban đầu.
- Bạn sẽ không cần sử dụng trình tạo mã.

Lập trình phản ứng với Get dễ dàng như sử dụng setState.

Hãy tưởng tượng rằng bạn có một biến tên và muốn rằng mỗi khi bạn thay đổi nó, tất cả các widget sử dụng nó sẽ được tự động thay đổi.

Đây là biến đếm của bạn:

```dart
var name = 'Jonatas Borges';
```

Để nó có thể được lắng nghe, bạn chỉ cần thêm ".obs" ở cuối:

```dart
var name = 'Jonatas Borges'.obs;
```

Và trong UI, khi bạn muốn hiển thị giá trị đó và cập nhật màn hình bất cứ khi nào giá trị thay đổi, chỉ cần thực hiện điều này:

```dart
Obx(() => Text("${controller.name}"));
```

Thế thôi. Chỉ là _thế_ thôi người ơi~.

### Thêm thông tin về Quản lý state

**Xem thông tin cụ thể tại [đây](./documentation/en_US/state_management.md). Tại đó, bạn có thể tham khảo ví dụ và so sánh sự khác nhau giữa quản lý state cơ bản và quản lý state reactive**

Bạn sẽ hình dung được sức mạnh của GetX.

## Quản lý route

Nếu bạn chỉ sử dụng routes/snackbars/dialogs/bottomsheets không có context, GetX là lựa chọn số 2 trừ 1, nhìn đây:

Thêm "Get" trước MaterialApp, nó sẽ biến thành GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Di chuyển tới màn hình mới:

```dart

Get.to(NextScreen());
```

Di chuyển tới màn hình mới theo tên. Xem thêm tại [đây](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

Để đóng snackbars, dialogs, bottomsheets, hay bất kì thứ gì, bạn có thể xài cái này để thay Navigator.pop(context);

```dart
Get.back();
```

Đi đến màn hình kế tiếp và bỏ luôn màn hình cũ (thường dùng cho màn hình giới thiệu, màn hình đăng nhập, etc.)

```dart
Get.off(NextScreen());
```

Đi đến màn hình kế tiếp và đóng tất cả các routes (hữu dụng cho shopping cart, polls, và tests)

```dart
Get.offAll(NextScreen());
```

Bạn có thấy nãy giờ chúng ta không sử dụng từ khóa "context"? Đây chính là thang điểm 9 + 1 của quản lý route ở Get. Với điểm mạnh trên, bạn có thể thao tác bất cứ đâu, kể cả trong controller class.

### Thêm thông tin về quản lý route

**Get hoạt động được với named routes và cũng cung cấp cách điều khiển ở cấp thấp (lower-level control) cho routes của bạn! Tài liệu chi tiết tại [đây](./documentation/en_US/route_management.md)**

## Quản lý dependency

Get hỗ trợ tính năng giúp bạn lấy class như Bloc hoặc Controller chỉ với 1 dòng, khỏi cần Provider context hay InheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Chí ú: Nếu bạn dùng cái này, nhớ đặt attention to thànhe bindings API, which will make it easier to connect your view to your controller.

Thay vì khởi tạo class của bạn trong class bạn đang sử dụng, bạn đang khởi tạo nó trong phiên bản Get, điều này sẽ làm cho nó có sẵn trên toàn bộ Ứng dụng của bạn.
Vì vậy, bạn có thể sử dụng bộ điều khiển (hoặc Bloc) của mình một cách bình thường

**Mẹo:** Nhận quản lý dependency được tách ra khỏi các phần khác của package, vì vậy, ví dụ: nếu ứng dụng của bạn đã sử dụng trình quản lý trạng thái (bất kỳ cái nào, không quan trọng), bạn không cần phải viết lại tất cả, bạn có thể sử dụng điều này nạp dependency vô lo

```dart
controller.fetchApi();
```

Hãy tưởng tượng rằng bạn đã điều hướng qua nhiều route và bạn cần dữ liệu bị còn sót trong controller của mình, bạn sẽ cần một trình quản lý dependency kết hợp với Provider hoặc Get_it, đúng hơm? Với Get, sử dụng Get to "find" cho controller, bạn sẽ hoàn toàn độc lập:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

Và sau đó, bạn sẽ có thể khôi phục dữ liệu controller của mình đã lấy được ở đó:

```dart
Text(controller.textFromApi);
```

### Thêm thông tin về quản lý dependency

**Xem thêm tại đây [here](./documentation/en_US/dependency_management.md)**

# Utils

## Internationalization

### Dịch thuật

Các bản dịch được lưu giữ như một bản đồ từ điển key-value đơn giản.
Để thêm các bản dịch tùy chỉnh, hãy tạo một class và extends `Translation`.

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

#### Sử dụng bản dịch thuật

Chỉ cần append `.tr` vào key được chỉ định và nó sẽ được dịch, sử dụng giá trị hiện tại của` Get.locale` và `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

#### Sử dụng bản dịch thuật với số ít và số nhiều

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length, Args));
```

#### Sử dụng bản dịch với tham số (parameters)

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

Chuyển các tham số (parameters) cho `GetMaterialApp` để xác định ngôn ngữ và bản dịch.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

#### Đổi locale

Gọi `Get.updateLocale (locale)` 'để cập nhật ngôn ngữ. Các bản dịch sau đó sẽ tự động sử dụng ngôn ngữ mới.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### System locale

Để đọc system locale, sử dụng `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

## Đổi Theme

Vui lòng không sử dụng bất kỳ Widget con nào cấp cao hơn `GetMaterialApp` để cập nhật nó. Điều này có thể kích hoạt các key trùng lặp. Rất nhiều người đã quen với cách tiếp cận thời tiền sử là tạo tiện ích "ThemeProvider" chỉ để thay đổi chủ đề ứng dụng của bạn và điều này KHÔNG cần thiết với ** GetX ™ **.

Bạn có thể tạo chủ đề tùy chỉnh của mình và chỉ cần thêm nó vào trong `Get.changeTheme` mà không cần bất kỳ điều gì khác:

```dart
Get.changeTheme(ThemeData.light());
```

Nếu bạn muốn tạo một cái gì đó giống như một nút thay đổi Theme với `onTap`, bạn có thể kết hợp hai API ** GetX ™ ** cho điều đó:

- Api kiểm tra xem `Theme` tối có đang được sử dụng hay không.
- Và `Theme` sẽ thay đổi API, bạn sử dụng với `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

Khi bật `.darkmode`, nó sẽ chuyển _light theme_, và khi bật _light theme_ , nó sẽ chuyển _dark theme_.

## GetConnect

GetConnect tạo giao thức tới http hoặc websockets

### Cấu hình mặc định

Đơn giản hóa các lệnh GET/POST/PUT/DELETE/SOCKET khi giao tiếp Rest API hoặc websockets.

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

### Tùy chỉnh

GetConnect có khả năng tùy chỉnh cao Bạn có thể xác định Url chính như answers, modifiers như request, xác địng authenticator và thậm chí số lần thử mà nó sẽ cố gắng authenticate, ngoài việc cung cấp khả năng xác định bộ giải mã chuẩn sẽ chuyển đổi tất cả các request của bạn thành Model mà không cần bất kỳ cấu hình bổ sung nào.

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
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage Middleware

GetPage hiện có thuộc tính mới lấy danh sách GetMiddleWare và chạy chúng theo thứ tự cụ thể.

**Chí ú**: Khi GetPage có Middleware (phần trung gian), tất cả các children của trang này sẽ tự động có cùng middlewares.

### Ưu tiên

Thứ tự ưu tiên của Middlewares có thể đặt như sau trong GetMiddleware.

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

và chúng sẽ chạy như thế này **-8 => 2 => 4 => 5**

### Chuyển hướng

Khi bạn muốn tìm kiếm trang của route được gọi, function (hàm) sẽ khởi động. Kết quả là phải có RouteSettings để chuyển hướng đến. Hoặc cung cấp cho nó null và chuyển hướng không xảy ra.

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

Khi bạn gọi một trang trước mọi thứ được tạo, hàm này sẽ khởi động và
bạn có thể sử dụng nó để thay đổi điều gì đó về trang hoặc tạo cho nó một trang mới

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

Function này sẽ khởi động trước khi Bindinds diễn ra và bạn có thể thay đổi Bindings cho trang này.

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

Function này sẽ khởi động sau khi Bindings diễn ra. Ở đây, bạn có thể làm thứ gì đó sau khi bạn tạo Bindings và trước khi tạo trange widget.

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

Function này sẽ khởi động ngay sau khi GetPage.page được gọi và sẽ cho bạn kết quả của function và lấy widget được hiển thị.

### OnPageDispose

Function này sẽ khởi động ngay sau khi hủy bỏ tất cả các đối tượng liên quan (Controller, views, ...) của trang.

## APIs nâng cao khác

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

// Chí ú: Nếu bạn dùng cái này, nhớ đặtt. thànhnce you
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

### Cấu hình thủ công và cài đặt chung tuỳ chọn

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

Các Widget này cho phép bạn quản lý một giá trị duy nhất và giữ trạng thái tạm thời và cục bộ.
Chúng tôi có các hướng đi cho Reactive và Simple.
Ví dụ: bạn có thể sử dụng chúng để chuyển đổi văn bản tối nghĩa trong một `TextField`, có thể tạo một widget
Expandable Panel tùy chỉnh hoặc có thể sửa đổi chỉ mục hiện tại trong `BottomNavigationBar` trong khi thay đổi nội dung
bên trong một `Scaffold`.

#### ValueBuilder

Đơn giản hóa của `StatefulWidget` hoạt động với lệnh gọi lại` .setState` nhận giá trị cập nhật.

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

Tương tự như [`ValueBuilder`] (# valuebuilder), nhưng đây là phiên bản Reactive, bạn kèm một lệnh Rx (nhớ cái .obs không?) và nó cập nhật tự động ... hay chưa?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

## Mẹo hữu ích

`.obs` observable (variable có thể quan sát được) (còn được gọi là loại _Rx_) có nhiều phương thức và toán tử bên trong.

> Is very common to _believe_ that a property with `.obs` **IS** the actual value... but make no mistake!
> We avoid the Type declaration of the variable, because Dart's compiler is smart enough, and the code
> looks cleaner, but:

```dart
var message = 'Xin Chào'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Ngay cả khi `message` _prints_ giá trị String, Loại là ** RxString **!

Vì vậy, bạn không thể thực hiện `message.substring (0, 4) '. Bạn phải truy cập vào `value`thực bên trong _observable_: Cách được sử dụng nhiều nhất là`.value`, nhưng, bạn có biết rằng bạn cũng có thể sử dụng ...

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

final user = User(name: 'Khang', last: 'Huỳnh', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Kaiser';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Kaiser';
});

print( user );
```

## StateMixin

Một cách khác để xử lý trạng thái `UI` của bạn là sử dụng`StateMixin <T>`.
Để triển khai nó, hãy sử dụng dấu `with` để thêm`StateMixin <T>` bộ điều khiển của bạn cho phép tích hợp kèm mô hình T.

```dart
class Controller extends GetController with StateMixin<User>{}
```

Phương thức `change ()` thay đổi trạng thái bất cứ khi nào chúng ta muốn.
Chỉ cần chuyển dữ liệu và trạng thái theo cách này:

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

Widget này là bảo bối của Getx, rất đơn giản, nhưng rất hữu ích!

Là một Widget `const Stateless` có getter` controller` cho một `Controller` đã đăng ký, chỉ vậy thôi người ơi~.

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

Mở rộng tiện ích này để xây dựng chế độ responsive.
Ưidget này chứa thuộc tính `screen` có tất cả
thông tin về kích thước và loại màn hình.

##### Hướng dẫn sử dụng trước khi dùng

Bạn có hai lựa chọn để xây dựng nó.

- với phương thức `builder` bạn trả về tiện ích con để xây dựng.
- với các phương thức `desktop`,` tablet`, `phone`,` watch`. cụ thể, các phương thức này sẽ tạo các loại màn hình khớp với ngữ cảnh khi màn hình là [ScreenType.Tablet] thì phương thức `tablet` sẽ được tạo ra và cứ như vậy.
  **Chí ú:** Nếu bạn dùng cái này, nhớ đặt `alwaysUseBuilder` thành `false`

Với `settings` property bạn có thể đặt chiều dài tối thiểu cho các loại màn hình.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

#### GetWidget

Hầu hết mọi người không biết gì về Widget này, hoặc hoàn toàn nhầm lẫn về cách sử dụng nó.
Trường hợp sử dụng rất hiếm, nhưng rất cụ thể: Nó `caches` một Bộ điều khiển.
Bởi vì _cache_ không thể là một `const Stateless`.

> So, when do you need to "cache" a Controller?

Nếu sử dụng, bạn sẽ dùng cái này **GetX**: `Get.create()`.

`Get.create(()=>Controller())` sẽ tạo một `Controller` với mỗi lần gọi `Get.find<Controller>()`,

Đó là nơi mà `` GetWidget` tỏa sáng ... chẳng hạn như bạn có thể sử dụng nó, để giữ một danh sách các mục Todo. Vì vậy, nếu widget được "xây dựng lại", nó sẽ giữ nguyên phiên bản controller.

#### GetxService

Class này giống như một `GetxController`, nó chia sẻ cùng một vòng đời (`onInit ()`,`onReady ()`,`onClose ()`).
Nhưng không có "logic" bên trong của nó. Nó chỉ thông báo cho ** GetX ** Hệ thống Nạp Dependency rằng class con này ** không thể ** bị xóa khỏi bộ nhớ.

Vì vậy, rất hữu ích để giữ cho "Service" của bạn luôn có thể truy cập và hoạt động với `Get.find ()`. Giống:
`ApiService`,` StorageService`, `CacheService`.

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

Cách duy nhất để thực sự xóa một `GetxService`, là với`Get.reset ()`giống như cách thức "Khởi động nóng" ứng dụng của bạn. Vì vậy, hãy nhớ rằng, nếu bạn cần sự tồn tại tuyệt đối của một class trong vòng đời tồn tại của nó trong ứng dụng của bạn, hãy sử dụng `GetxService`.

# Thay đổi đột phá 2.0

1- Rx types:

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController và GetBuilder bây giờ đã hợp nhất, bạn không cần phải ghi nhớ bộ điều khiển nào bạn muốn sử dụng, chỉ cần sử dụng GetxController, nó sẽ hoạt động để quản lý trạng thái đơn giản và reactive.

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

Tại sao lại thay đổi?
Thông thường, có thể cần phải quyết định trang nào sẽ được hiển thị từ một tham số hoặc mã thông báo đăng nhập, cách tiếp cận trước đây không linh hoạt, vì nó không cho phép điều này.
Việc chèn trang vào một hàm đã làm giảm đáng kể mức tiêu thụ RAM, vì các tuyến sẽ không được cấp phát trong bộ nhớ kể từ khi ứng dụng được khởi động và nó cũng cho phép thực hiện kiểu tiếp cận này:

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

# Tại sao lại dùng GetX

1- Nhiều lần sau khi cập nhật Flutter, nhiều package của bạn sẽ bị hỏng. Đôi khi lỗi biên dịch code xảy ra, lỗi thường xuất hiện mà vẫn không có câu trả lời; và, chúng ta, nhà phát triển, cần biết lỗi đến từ đâu, theo dõi lỗi, chỉ sau đó cố gắng mở một vấn đề trong kho lưu trữ tương ứng và xem vấn đề của nó đã được giải quyết. Tập trung các tài nguyên chính để phát triển (Quản lý state, dependency và route), cho phép bạn thêm một gói duy nhất vào pubspec của mình và bắt đầu hoạt động. Sau khi cập nhật Flutter, điều duy nhất bạn cần làm là cập nhật Get dependency và bắt đầu làm việc. Get cũng giải quyết các vấn đề tương thích. Có bao nhiêu lần một phiên bản của một gói không tương thích với phiên bản của gói khác, vì một gói sử dụng phần phụ thuộc trong một phiên bản và gói kia trong phiên bản khác? Đây cũng không phải là vấn đề đáng lo ngại khi sử dụng Get, vì mọi thứ đều nằm trong cùng một gói và hoàn toàn tương thích.

2- Flutter dễ học, Flutter siêu phàm, nhưng Flutter vẫn có một số bản soạn sẵn có thể không mong muốn đối với hầu hết các nhà phát triển, chẳng hạn như `Navigator.of (context) .push (context, builder [...] '. Get đơn giản hóa việc phát triển. Thay vì viết 8 dòng mã chỉ để gọi một tuyến đường, bạn chỉ cần làm điều đó: `` Get.to (Home ()) 'và bạn đã hoàn tất, bạn sẽ chuyển sang trang tiếp theo. Các url web động là một điều thực sự khó khăn để làm với Flutter hiện tại và điều đó với GetX đơn giản đến đần độn :). Quản lý trạng thái trong Flutter và quản lý các phần phụ thuộc cũng là điều tạo ra nhiều cuộc thảo luận, vì có hàng trăm mẫu trong pub (Dart package website). Nhưng không có gì dễ dàng bằng việc thêm ".obs" ở cuối biến của bạn, và đặt tiện ích của bạn bên trong Obx, và thế là xong, tất cả các cập nhật cho biến đó sẽ được tự động cập nhật trên màn hình.

3- Dễ dàng mà không phải lo lắng về hiệu suất. Hiệu suất của Flutter đã đáng kinh ngạc rồi, nhưng hãy tưởng tượng rằng bạn sử dụng trình quản lý state và trình định vị để phân phối các Blocs / stores / controllers / v.v. của bạn. Bạn sẽ phải gọi thủ công loại trừ sự phụ thuộc khi bạn không cần đến chúng. Nhưng bạn đã bao giờ nghĩ chỉ cần sử dụng bộ điều khiển của mình và khi nó không còn được ai sử dụng nữa, nó sẽ đơn giản được xóa khỏi bộ nhớ? Đó là những gì GetX làm. Với SmartManagement, mọi thứ không được sử dụng sẽ được xóa khỏi bộ nhớ và bạn không phải lo lắng về bất cứ điều gì ngoài lập trình. Bạn sẽ được đảm bảo rằng bạn đang sử dụng các nguồn tài nguyên cần thiết tối thiểu mà thậm chí không cần tạo ra một logic nào cho việc này.

4- Tách khỏi thực tế. Bạn có thể đã nghe đến khái niệm "tách khung nhìn (view) khỏi business logic". Đây không phải là đặc thù của BLoC, MVC, MVVM và bất kỳ tiêu chuẩn nào khác trên thị trường đều có khái niệm này. Tuy nhiên, khái niệm này thường có thể được giảm thiểu trong Flutter do việc sử dụng ngữ cảnh (context).
Nếu bạn cần ngữ cảnh để tìm một InheritedWidget, bạn cần nó trong dạng xem hoặc chuyển ngữ cảnh theo tham số. Tôi đặc biệt thấy giải pháp này rất chán đời; hơn nữa, để làm việc theo nhóm, chúng tôi sẽ luôn phụ thuộc vào business logic của View. Getx không chính thống với cách tiếp cận tiêu chuẩn và mặc dù nó không cấm hoàn toàn việc sử dụng StatefulWidgets, InitState, v.v., nhưng nó luôn có một cách tiếp cận tương tự có thể rõ ràng hơn. Controller có vòng đời và khi bạn cần thực hiện yêu cầu APIREST chẳng hạn, bạn độc lập với View. Bạn có thể sử dụng onInit để bắt đầu cuộc gọi http và khi dữ liệu đến, các biến sẽ được điền. Vì GetX hoạt động hoàn toàn reactive (đó là sự thực và hoạt động theo luồng), khi các mục được lấp đầy, tất cả tiện ích con sử dụng biến đó sẽ được cập nhật tự động trong View. Điều này cho phép những người có chuyên môn về UI chỉ làm việc với các widget và không phải gửi bất kỳ thứ gì đến logic nghiệp vụ ngoài các sự kiện của người dùng (như nhấp vào nút), trong khi những người làm việc với logic nghiệp vụ sẽ được tự do tạo và kiểm tra logic nghiệp vụ riêng.

Thư viện này sẽ luôn được cập nhật và triển khai các tính năng mới. Hãy thoải mái đưa ra các bài PR và đóng góp cho chúng.

# Cộng đồng

## Kênh Cộng đồng

GetX có một cộng đồng rất tích cực và hữu ích. Nếu bạn có thắc mắc hoặc muốn được hỗ trợ về việc sử dụng khuôn khổ này, vui lòng tham gia các kênh cộng đồng của chúng tôi, câu hỏi của bạn sẽ được trả lời nhanh hơn và đó sẽ là nơi phù hợp nhất. Kho lưu trữ này dành riêng cho các vấn đề mở và yêu cầu tài nguyên, nhưng hãy thoải mái trở thành một phần của Cộng đồng GetX.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## Cách cống hiến

_Bạn muốn đóng góp cho dự án? Chúng tôi sẽ tự hào giới thiệu bạn với tư cách là một trong những cộng tác viên của chúng tôi. Dưới đây là một số điểm mà bạn có thể đóng góp và làm cho Get (và Flutter) tốt hơn nữa._

- Giúp dịch readme sang các ngôn ngữ khác.
- Thêm tài liệu vào readme (rất nhiều chức năng của Get chưa được tài liệu hóa).
- Viết bài hoặc làm video dạy cách sử dụng Get (chúng sẽ được chèn vào Readme và trong tương lai trong Wiki của chúng tôi).
- Đưa ra các PR cho mã / bài kiểm tra.
- Bao gồm các chức năng mới.

Mọi đóng góp đều được hoan nghênh!

## Các bài báo và video

- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - Hướng dẫn bởi [Pesa Coder](https://github.com/UsamaElgendy).
- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Hướng dẫn bởi [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Quản lý route bởi Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - Quản lý State video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - Utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - Quản lý State by [Aachman Garg](https://github.com/imaachman).
- [The Flutter GetX™ Ecosystem ~ Dependency Injection](https://medium.com/flutter-community/the-flutter-getx-ecosystem-dependency-injection-8e763d0ec6b9) - Nạp dependency by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - Giới thiệu sơ lược về quản lý State and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter.
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - by [Roi Peker](https://github.com/roipeker)

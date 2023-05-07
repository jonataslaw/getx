![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

_语言：中文，[英文](README.md)，[越南文](README-vi.md)，[印度尼西亚](README.id-ID.md)，[乌尔都语](README.ur-PK.md)，[巴西葡萄牙语](README.pt-br.md)，[俄语](README.ru.md)，[西班牙语](README-es.md)，[波兰语](README.pl.md)，[韩国语](README.ko-kr.md)，[法语](README-fr.md)。_

[![pub package](https://img.shields.io/pub/v/get.svg?label=get&color=blue)](https://pub.dev/packages/get)
[![popularity](https://badges.bar/get/popularity)](https://pub.dev/packages/sentry/score)
[![likes](https://badges.bar/get/likes)](https://pub.dev/packages/get/score)
[![pub points](https://badges.bar/get/pub%20points)](https://pub.dev/packages/get/score)
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

- [关于 Get](#关于-get)
- [安装](#安装)
- [GetX 的计数器示例](#getx-的计数器示例)
- [三大功能](#三大功能)
  - [状态管理](#状态管理)
    - [响应式状态管理器](#响应式状态管理器)
    - [关于状态管理的更多细节](#关于状态管理的更多细节)
  - [路由管理](#路由管理)
    - [关于路由管理的更多细节](#关于路由管理的更多细节)
  - [依赖管理](#依赖管理)
    - [关于依赖管理的更多细节](#关于依赖管理的更多细节)
- [实用工具](#实用工具)
  - [国际化](#国际化)
    - [翻译](#翻译)
      - [使用翻译](#使用翻译)
    - [语言](#语言)
      - [改变语言](#改变语言)
      - [系统语言](#系统语言)
  - [改变主题](#改变主题)
  - [GetConnect](#getconnect)
    - [默认配置](#默认配置)
    - [自定义配置](#自定义配置)
  - [GetPage 中间件](#getpage-中间件)
    - [优先级](#优先级)
    - [Redirect](#redirect)
    - [onPageCalled](#onpagecalled)
    - [OnBindingsStart](#onbindingsstart)
    - [OnPageBuildStart](#onpagebuildstart)
    - [OnPageBuilt](#onpagebuilt)
    - [OnPageDispose](#onpagedispose)
  - [其他高级 API](#其他高级-api)
    - [可选的全局设置和手动配置](#可选的全局设置和手动配置)
    - [局部状态组件](#局部状态组件)
      - [ValueBuilder](#valuebuilder)
      - [ObxValue](#obxvalue)
  - [有用的提示](#有用的提示)
      - [GetView](#getview)
      - [GetWidget](#getwidget)
      - [GetxService](#getxservice)
- [从 2.0 开始的兼容性变化](#从-20-开始的兼容性变化)
- [为什么选择 Getx？](#为什么选择-getx)
- [社区](#社区)
  - [社区渠道](#社区渠道)
  - [如何做贡献](#如何做贡献)
  - [文章和视频](#文章和视频)

# 关于 Get

- GetX 是一个为 Flutter 打造的轻量且强大的解决方案：高性能的状态管理、智能的依赖注入和便捷的路由管理。

- GetX 有 3 个基本原则：

  - **性能：**GetX 专注于性能和最小资源消耗。GetX 打包后的 apk 占用大小和运行时的内存占用与其他状态管理插件不相上下。如果你感兴趣，这里有一个[性能测试](https://github.com/jonataslaw/benchmarks)。
  - **效率：**GetX 的语法非常简捷，并保持了极高的性能，能极大缩短你的开发时长。
  - **结构：**GetX 可以将界面、逻辑、依赖和路由完全解耦，用起来更清爽，逻辑更清晰，代码更容易维护。
  
- GetX 并不臃肿，反而很轻量。如果你只使用状态管理，只有状态管理模块会被编译，其他没用到的东西都不会被编译到你的代码中。它拥有众多的功能，但这些功能都在独立的容器中，只有在使用时才会启动。

- Getx 有一个庞大的生态系统，能够在 Android、iOS、Web、Mac、Linux、Windows 和你的服务器上用同样的代码运行。
**通过 [Get Server](https://github.com/jonataslaw/get_server)** 可以在你的后端完全重用你在前端写的代码。

**此外，通过 [Get CLI](https://github.com/jonataslaw/get_cli)**，无论是在服务器上还是在前端，整个开发过程都可以完全自动化。

**此外，为了进一步提高您的生产效率，我们还为您准备了一些插件**

- **getx_template**：一键生成每个页面必需的文件夹、文件、模板代码等等
  - [Android Studio/Intellij 插件](https://plugins.jetbrains.com/plugin/15919-getx)
- **GetX Snippets**：输入少量字母，自动提示选择后，可生成常用的模板代码
  - [Android Studio/Intellij 扩展](https://plugins.jetbrains.com/plugin/14975-getx-snippets)
  - [VSCode 扩展](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)

# 安装

将 Get 添加到你的 pubspec.yaml 文件中。

```yaml
dependencies:
  get:
```

在需要用到它的文件中导入：

```dart
import 'package:get/get.dart';
```

# GetX 的计数器示例

Flutter 默认创建的 “计数器” 项目有 100 多行 (含注释)，为了展示 Get 的强大功能，我将使用 GetX 重写一个 “计数器 Plus 版”，实现：
- 每次点击都能改变状态
- 在不同页面之间切换
- 在不同页面之间共享状态
- 将业务逻辑与界面分离

而完成这一切只需 **26 行代码 (含注释)** 

- 步骤 1。
在你的 MaterialApp 前添加 “Get”，将其变成 GetMaterialApp。

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

- 注意：这并不能修改 Flutter 的 MaterialApp，GetMaterialApp 并不是修改后的 MaterialApp，它只是一个预先配置的 Widget，它的子组件是默认的 MaterialApp。你可以手动配置，但绝对没有必要。GetMaterialApp 会创建路由，注入它们，注入翻译，注入你需要的一切路由导航。如果你只用 Get 来进行状态管理或依赖管理，就没有必要使用 GetMaterialApp。GetMaterialApp 对于路由、snackbar、国际化、bottomSheet、对话框以及与路由相关的高级 API 和没有上下文 (context) 的情况下是必要的。
- 注 2：只有当你要使用路由管理 (`Get.to()`，`Get.back()` 等) 时才需要这一步。如果你不打算使用它，那么就不需要做第 1 步。

- 第二步：
  创建你的业务逻辑类，并将所有的变量，方法和控制器放在里面。
  你可以使用一个简单的 “.obs” 使任何变量成为可观察的。

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

- 第三步：
  创建你的界面，使用 StatelessWidget 节省一些内存，使用 Get 你可能不再需要使用 StatefulWidget。

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // 使用 Get.put() 实例化你的类，使其对当下的所有子路由可用。
    final Controller c = Get.put(Controller());

    return Scaffold(
      // 使用 Obx(()=> 每当改变计数时，就更新 Text()。
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // 用一个简单的 Get.to() 即可代替 Navigator.push 那 8 行，无需上下文！
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // 你可以让 Get 找到一个正在被其他页面使用的 Controller，并将它返回给你。
  final Controller c = Get.find();

  @override
  Widget build(context){
     // 访问更新后的计数变量
     return Scaffold(body: Center(child: Text("${c.count}")));
  }
}
```

结果：

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

这是一个简单的项目，但它已经让人明白 Get 的强大。随着项目的发展，这种差异将变得更加显著。

Get 的设计是为了与团队合作，但它也可以让个人开发者的工作变得更简单。

加快开发速率，在不损失性能的情况下按时交付一切。Get 并不适合每一个人，但如果你认同这句话，Get 就是为你准备的！

# 三大功能

## 状态管理

目前，Flutter 有几种状态管理器。但是，它们中的大多数都涉及到使用 ChangeNotifier 来更新 widget，这对于中大型应用的性能来说是一个很糟糕的方法。你可以在 Flutter 的官方文档中查看到，[ChangeNotifier 应该使用 1 个或最多 2 个监听器](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)，这使得它们实际上无法用于任何中等或大型应用。

Get 并不是比任何其他状态管理器更好或更差，而是说你应该分析这些要点以及下面的要点来选择只用 Get，还是与其他状态管理器结合使用。

Get 不是其他状态管理器的敌人，因为 Get 是一个微框架，而不仅仅是一个状态管理器，既可以单独使用，也可以与其他状态管理器结合使用。

Get 有两个不同的状态管理器：简单的状态管理器 (GetBuilder) 和响应式状态管理器 (GetX)。

### 响应式状态管理器

响应式编程可能会让很多人感到陌生，因为觉得它很复杂，但是 GetX 将响应式编程变得非常简单。

- 你不需要创建 StreamControllers。
- 你不需要为每个变量创建一个 StreamBuilder。
- 你不需要为每个状态创建一个类。
- 你不需要为一个初始值创建一个 get。

使用 Get 的响应式编程就像使用 setState 一样简单。

让我们想象一下，你有一个名称变量，并且希望每次你改变它时，所有使用它的小组件都会自动刷新。

这就是你的计数变量。

```dart
var name = 'Jonatas Borges';
```

要想让它变得可观察，你只需要在它的末尾加上 “.obs”。

```dart
var name = 'Jonatas Borges'.obs;
```

而在 UI 中，当你想显示该值并在值变化时更新页面，只需这样做。

```dart
Obx(() => Text("${controller.name}"));
```

这就是全部，就这么简单。

### 关于状态管理的更多细节

**关于状态管理更深入的解释请查看[这里](./documentation/zh_CN/state_management.md)。在那里你将看到更多的例子，以及简单的状态管理器和响应式状态管理器之间的区别**。

你会对 GetX 的能力有一个很好的了解。

## 路由管理

如果你想免上下文 (context) 使用路由 /snackbars/dialogs/bottomsheets，GetX 对你来说也是极好的，看看这个：

在你的 MaterialApp 前加上 “Get”，把它变成 GetMaterialApp。

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

导航到新页面

```dart

Get.to(NextScreen());
```

用别名导航到新页面。查看更多关于命名路由的详细信息[这里](./documentation/zh_CN/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

要关闭 snackbars，dialogs，bottomsheets 或任何你通常会用 Navigator.pop(context) 关闭的东西。

```dart
Get.back();
```

进入下一个页面，但没有返回上一个页面的选项 (用于闪屏页，登录页面等)。

```dart
Get.off(NextScreen());
```

进入下一个页面并取消之前的所有路由 (在购物车、投票和测试中很有用)。

```dart
Get.offAll(NextScreen());
```

注意到你不需要使用 context 来做这些事情吗？这就是使用 Get 路由管理的最大优势之一。有了它，你可以在你的控制器类中执行所有这些方法，而不用担心 context 在哪里。

### 关于路由管理的更多细节

**关于别名路由，和对路由的低级控制，请看[这里](./documentation/zh_CN/route_management.md)**。

## 依赖管理

Get 有一个简单而强大的依赖管理器，它允许你只用 1 行代码就能检索到与你的 Bloc 或 Controller 相同的类，无需 Provider context，无需 inheritedWidget。

```dart
Controller controller = Get.put(Controller()); // 而不是 Controller controller = Controller();
```

- 注意：如果你使用的是 Get 的状态管理器，请多注意绑定 api，这将使你的界面更容易连接到你的控制器。

你是在 Get 实例中实例化它，而不是在你使用的类中实例化你的类，这将使它在整个 App 中可用。
所以你可以正常使用你的控制器 (或类 Bloc)。

**提示：**Get 依赖管理与包的其他部分是解耦的，所以如果你的应用已经使用了一个状态管理器 (任何一个，都没关系)，你不需要全部重写，你可以使用这个依赖注入。

```dart
controller.fetchApi();
```

想象一下，你已经浏览了无数条路由，现在你需要拿到一个被遗留在控制器中的数据，那你需要一个状态管理器与 Provider 或 Get_it 一起使用来拿到它，对吗？用 Get 则不然，Get 会自动为你的控制器找到你想要的数据，而你甚至不需要任何额外的依赖关系。

```dart
Controller controller = Get.find();
//是的，它看起来像魔术，Get会找到你的控制器，并将其提供给你。你可以实例化100万个控制器，Get总会给你正确的控制器。
```

然后你就可以恢复你在后面获得的控制器数据。

```dart
Text(controller.textFromApi);
```

### 关于依赖管理的更多细节

**关于依赖管理的更深入解释请看[此处](./documentation/zh_CN/dependency_management.md)**。

# 实用工具

## 国际化

### 翻译

翻译被保存为一个简单的键值字典映射。
要添加自定义翻译，请创建一个类并继承 `Translations`。

```dart
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'hello': '你好 世界',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
```

#### 使用翻译

只要将 `.tr` 追加到指定的键上，就会使用 `Get.locale` 和 `Get.fallbackLocale` 的当前值进行翻译。

```dart
Text('title'.tr);
```

### 语言

传递参数给 `GetMaterialApp` 来定义语言和翻译。

```dart
return GetMaterialApp(
    translations: Messages(), // 你的翻译
    locale: Locale('zh', 'CN'), // 将会按照此处指定的语言翻译
    fallbackLocale: Locale('en', 'US'), // 添加一个回调语言选项，以备上面指定的语言翻译不存在
);
```

#### 改变语言

调用 `Get.updateLocale(locale)` 来更新语言环境。然后翻译会自动使用新的 locale。

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

#### 系统语言

要读取系统语言，可以使用 `window.locale`。

```dart
import 'dart:ui' as ui;

return GetMaterialApp(
    locale: ui.window.locale,
);
```

## 改变主题

请不要使用比 `GetMaterialApp` 更高级别的 widget 来更新主题，这可能会造成键重复。很多人习惯于创建一个 “ThemeProvider” 的 widget 来改变应用主题，这在 **GetX™** 中是绝对没有必要的。

你可以创建你的自定义主题，并简单地将其添加到 `Get.changeTheme` 中，而无需任何模板。

```dart
Get.changeTheme(ThemeData.light());
```

如果你想在 “onTap” 中创建类似于改变主题的按钮，你可以结合两个 **GetX™** API 来实现。

- 检查是否使用了深色的 “Theme” 的 API，以及 “Theme” 更改 API。
- 而 `Theme` Change API，你可以把下面的代码放在 `onPressed` 里。

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

当 `.darkmode` 被激活时，它将切换到 light 主题，当 light 主题被激活时，它将切换到 dark 主题。

## GetConnect

GetConnect 可以便捷的通过 http 或 websockets 进行前后台通信。

### 默认配置

你能轻松的通过 extend GetConnect 就能使用 GET/POST/PUT/DELETE/SOCKET 方法与你的 Rest API 或 websockets 通信。

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

### 自定义配置

GetConnect 具有多种自定义配置。你可以配置 base Url，配置响应，配置请求，添加权限验证，甚至是尝试认证的次数，除此之外，还可以定义一个标准的解码器，该解码器将把您的所有请求转换为您的模型，而不需要任何额外的配置。

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

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}
```

## GetPage 中间件

GetPage 现在有个新的参数可以把列表中的 Get 中间件按指定顺序执行。

**注意**：当 GetPage 有中间件时，所有的子 page 会自动有相同的中间件。

### 优先级

设置中间件的优先级定义 Get 中间件的执行顺序。

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

这些中间件会按这个顺序执行 **-8 => 2 => 4 => 5**

### Redirect

当被调用路由的页面被搜索时，这个函数将被调用。它将 RouteSettings 作为重定向的结果。或者给它 null，就没有重定向了。

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

### onPageCalled

在调用页面时，创建任何东西之前，这个函数会先被调用。
您可以使用它来更改页面的某些内容或给它一个新页面。

```dart
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}
```

### OnBindingsStart

这个函数将在绑定初始化之前被调用。
在这里，您可以更改此页面的绑定。

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

这个函数将在绑定初始化之后被调用。
在这里，您可以在创建绑定之后和创建页面 widget 之前执行一些操作。

```dart
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}
```

### OnPageBuilt

这个函数将在 GetPage.page 调用后被调用，并给出函数的结果，并获取将要显示的 widget。

### OnPageDispose

这个函数将在处理完页面的所有相关对象 (Controllers，views， ...) 之后被调用。

## 其他高级 API

```dart
// 给出当前页面的args。
Get.arguments

//给出以前的路由名称
Get.previousRoute

// 给出要访问的原始路由，例如，rawRoute.isFirst()
Get.rawRoute

// 允许从GetObserver访问Rounting API。
Get.routing

// 检查 snackbar 是否打开
Get.isSnackbarOpen

// 检查 dialog 是否打开
Get.isDialogOpen

// 检查 bottomsheet 是否打开
Get.isBottomSheetOpen

// 删除一个路由。
Get.removeRoute()

//反复返回，直到表达式返回真。
Get.until()

// 转到下一条路由，并删除所有之前的路由，直到表达式返回true。
Get.offUntil()

// 转到下一个命名的路由，并删除所有之前的路由，直到表达式返回true。
Get.offNamedUntil()

//检查应用程序在哪个平台上运行。
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//检查设备类型
GetPlatform.isMobile
GetPlatform.isDesktop
//所有平台都是独立支持web的!
//你可以知道你是否在浏览器内运行。
//在Windows、iOS、OSX、Android等系统上。
GetPlatform.isWeb


// 相当于.MediaQuery.of(context).size.height,
//但不可改变。
Get.height
Get.width

// 提供当前上下文。
Get.context

// 在你的代码中的任何地方，在前台提供 snackbar/dialog/bottomsheet 的上下文。
Get.contextOverlay

// 注意：以下方法是对上下文的扩展。
// 因为在你的UI的任何地方都可以访问上下文，你可以在UI代码的任何地方使用它。

// 如果你需要一个可改变的高度/宽度（如桌面或浏览器窗口可以缩放），你将需要使用上下文。
context.width
context.height

// 让您可以定义一半的页面、三分之一的页面等。
// 对响应式应用很有用。
// 参数： dividedBy (double) 可选 - 默认值：1
// 参数： reducedBy (double) 可选 - 默认值：0。
context.heightTransformer()
context.widthTransformer()

/// 类似于 MediaQuery.of(context).size。
context.mediaQuerySize()

/// 类似于 MediaQuery.of(context).padding。
context.mediaQueryPadding()

/// 类似于 MediaQuery.of(context).viewPadding。
context.mediaQueryViewPadding()

/// 类似于 MediaQuery.of(context).viewInsets。
context.mediaQueryViewInsets()

/// 类似于 MediaQuery.of(context).orientation;
context.orientation()

///检查设备是否处于横向模式
context.isLandscape()

///检查设备是否处于纵向模式。
context.isPortrait()

///类似于MediaQuery.of(context).devicePixelRatio。
context.devicePixelRatio()

///类似于MediaQuery.of(context).textScaleFactor。
context.textScaleFactor()

///查询设备最短边。
context.mediaQueryShortestSide()

///如果宽度大于800，则为真。
context.showNavbar()

///如果最短边小于600p，则为真。
context.isPhone()

///如果最短边大于600p，则为真。
context.isSmallTablet()

///如果最短边大于720p，则为真。
context.isLargeTablet()

///如果当前设备是平板电脑，则为真
context.isTablet()

///根据页面大小返回一个值<T>。
///可以给值为：
///watch：如果最短边小于300
///mobile：如果最短边小于600
///tablet：如果最短边（shortestSide）小于1200
///desktop：如果宽度大于1200
context.responsiveValue<T>()
```

### 可选的全局设置和手动配置

GetMaterialApp 为你配置了一切，但如果你想手动配置 Get。

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);
```

你也可以在 `GetObserver` 中使用自己的中间件，这不会影响任何事情。

```dart
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);
```

你可以为 “Get” 创建 _ 全局设置。只需在推送任何路由之前将 `Get.config` 添加到你的代码中。
或者直接在你的 `GetMaterialApp` 中做。

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

你可以选择重定向所有来自 `Get` 的日志信息。
如果你想使用你自己喜欢的日志包，并想查看那里的日志。

```dart
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);

void localLogWriter(String text, {bool isError = false}) {
  // 在这里把信息传递给你最喜欢的日志包。
  // 请注意，即使enableLog: false，日志信息也会在这个回调中被推送。
  // 如果你想的话，可以通过GetConfig.isLogEnable来检查这个标志。
}

```

### 局部状态组件

这些 Widgets 允许您管理一个单一的值，并保持状态的短暂性和本地性。
我们有 Reactive 和 Simple 两种风格。
例如，你可以用它们来切换 `TextField` 中的 obscureText，也许可以创建一个自定义的可扩展面板 (Expandable Panel)，或者在 “Scaffold” 的主体中改变内容的同时修改 `BottomNavigationBar` 中的当前索引。


#### ValueBuilder

`StatefulWidget` 的简化，它与 `.setState` 回调一起工作，并接受更新的值。

```dart
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // 你可以用( newValue )=> updateFn( newValue )。
  ),
  // 如果你需要调用 builder 方法之外的东西。
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),
```

#### ObxValue

类似于 [`ValueBuilder`](#valuebuilder)，但这是 Reactive 版本，你需要传递一个 Rx 实例 (还记得神奇的.obs 吗？自动更新......是不是很厉害？)

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx 有一个 _callable_函数! 你可以使用 (flag) => data.value = flag,
    ),
    false.obs,
),
```

## 有用的提示

`.obs` ervables (也称为 _Rx_ Types) 有各种各样的内部方法和操作符。

> `.obs` 的属性**是**实际值，不要搞错了！
> 我们避免了变量的类型声明，因为 Dart 的编译器足够聪明，而且代码
> 看起来更干净，但：

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

即使 `message` _prints_ 实际的字符串值，类型也是 **RxString**！
所以，你不能做 `message.substring( 0, 4 )`。
你必须在 _observable_ 里面访问真正的 `value`。
最常用的方法是 “.value”，但是你也可以用...

```dart
final name = 'GetX'.obs;
//只有在值与当前值不同的情况下，才会 "更新 "流。
name.value = 'Hey';

// 所有Rx属性都是 "可调用 "的，并返回新的值。
//但这种方法不接受 "null"，UI将不会重建。
name('Hello');

// 就像一个getter，打印'Hello'。
name() ;

///数字。

final count = 0.obs;

// 您可以使用num基元的所有不可变操作!
count + 1;

// 注意！只有当 "count "不是final时，这才有效，除了var
count += 1;

// 你也可以与数值进行比较。
count > 2;

/// booleans:

final flag = false.obs;

// 在真/假之间切换数值
flag.toggle();


/// 所有类型。

// 将 "value "设为空。
flag.nil();

// 所有的toString()、toJson()操作都会向下传递到`value`。
print( count ); // 在内部调用 "toString() "来GetRxInt

final abc = [0,1,2].obs;
// 将值转换为json数组，打印RxList。
// 所有Rx类型都支持Json!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList 和 RxSet 是特殊的 Rx 类型，扩展了它们的原生类型。
// 但你可以像使用普通列表一样使用列表，尽管它是响应式的。
abc.add(12); // 将12添加到列表中，并更新流。
abc[3]; // 和Lists一样，读取索引3。


// Rx和值是平等的，但hashCode总是从值中提取。
final number = 12.obs;
print( number == 12 ); // prints > true

///自定义Rx模型。

// toJson(), toString()都是递延给子代的，所以你可以在它们上实现覆盖，并直接打印()可观察的内容。

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user`是 "响应式 "的，但里面的属性却不是!
// 所以，如果我们改变其中的一些变量：
user.value.name = 'Roi';
// 小部件不会重建！ 
// 对于自定义类，我们需要手动 "通知 "改变。
user.refresh();

// 或者我们可以使用`update()`方法!
user.update((value){
  value.name='Roi';
});

print( user );
```

#### GetView

我很喜欢这个 Widget，很简单，很有用。

它是一个对已注册的 `Controller` 有一个名为 `controller` 的 getter 的 `const Stateless` 的 Widget，仅此而已。

```dart
 class AwesomeController extends GetxController {
   final String title = 'My Awesome View';
 }

  // 一定要记住传递你用来注册控制器的`Type`!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text( controller.title ), // 只需调用 "controller.something"。
     );
   }
 }
```

#### GetWidget

大多数人都不知道这个 Widget，或者完全搞不清它的用法。
这个用例非常少见且特殊：它 “缓存” 了一个 Controller，由于 _cache_，不能成为一个 “const Stateless” (因为 _cache_，所以不能成为一个 `const Stateless`)。

> 那么，什么时候你需要 “缓存” 一个 Controller？

如果你使用了 **GetX** 的另一个 “不常见” 的特性 `Get.create()`

`Get.create(()=>Controller())` 会在每次调用时生成一个新的 `Controller`
`Get.find<Controller>()`

你可以用它来保存 Todo 项目的列表，如果小组件被 “重建”，它将保持相同的控制器实例。

#### GetxService

这个类就像一个 “GetxController”，它共享相同的生命周期 (“onInit()”、“onReady()”、“onClose()”)。
但里面没有 “逻辑”。它只是通知 **GetX** 的依赖注入系统，这个子类**不能**从内存中删除。

所以这对保持你的 “服务” 总是可以被 `Get.find()` 获取到并保持运行是超级有用的。比如
`ApiService`，`StorageService`，`CacheService`。

```dart
Future<void> main() async {
  await initServices(); /// 等待服务初始化.
  runApp(SomeApp());
}

/// 在你运行Flutter应用之前，让你的服务初始化是一个明智之举。
////因为你可以控制执行流程（也许你需要加载一些主题配置，apiKey，由用户自定义的语言等，所以在运行ApiService之前加载SettingService。
///所以GetMaterialApp()不需要重建，可以直接取值。
void initServices() async {
  print('starting services ...');
  ///这里是你放get_storage、hive、shared_pref初始化的地方。
  ///或者moor连接，或者其他什么异步的东西。
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

实际删除一个 `GetxService` 的唯一方法是使用 `Get.reset()`，它就像 “热重启” 你的应用程序。

所以如果你需要在你的应用程序的生命周期内对一个类实例进行绝对的持久化，请使用 `GetxService`。

# 从 2.0 开始的兼容性变化

1- Rx 类型。

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

现在 RxController 和 GetBuilder 已经合并了，你不再需要记住你要用哪个控制器，只要用 GetxController 就可以了，它可以用于简单的状态管理，也可以用于响应式。

2- 别名路由
之前：

```dart
GetMaterialApp(
  namedRoutes: {
    '/': GetRoute(page: Home()),
  }
)
```

现在：

```dart
GetMaterialApp(
  getPages: [
    GetPage(name: '/', page: () => Home()),
  ]
)
```

为什么要做这样的改变？
通常情况下，可能需要通过一个参数，或者一个登录令牌来决定显示哪个页面。
将页面插入到一个函数中，大大降低了 RAM 的消耗，因为自从应用程序启动后，路由将不会在内存中分配。

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

# 为什么选择 Getx？

1- Flutter 更新后，很多时候，你的很多包都会坏掉。有时会发生编译错误，经常出现的错误，至今仍没有答案，开发者需要知道错误的来源，跟踪错误，才会尝试在相应的仓库中开一个问题，并看到其问题的解决。Get 集中了开发的主要资源 (状态、依赖和路由管理)，让你可以在 pubspec 中添加一个包，然后开始工作。Flutter 更新后，你唯一需要做的就是更新 Get 依赖，然后开始工作。Get 还可以解决兼容性问题。有多少次，一个包的版本与另一个包的版本不兼容，因为一个包在一个版本中使用了依赖，而另一个包在另一个版本中使用了依赖？使用 Get 也不用担心这个问题，因为所有的东西都在同一个包里，是完全兼容的。

2- Flutter 很简单，Flutter 很不可思议，但是 Flutter 仍然有一些代码，对于大多数开发者来说可能是不需要的，比如 `Navigator.of(context).push (context, builder [...]`，你写了 8 行代码仅仅只为了调用一个路由。而使用 Get 只需 `Get.to(Home())` 就完成了，你将进入下一个页面。动态网页 URL 是目前 Flutter 中非常痛苦的一件事，而用 GetX 则非常简单。在 Flutter 中管理状态，管理依赖关系也产生了很多讨论，因为 pub 中的模式有上百种。但是没有什么比在你的变量末尾加一个 “.obs” 更简单的了，把你的 widget 放在一个 Obx 里面，就这样，所有对这个变量的更新都会在页面上自动更新。

3-轻松，不用担心性能。Flutter 的性能已经很惊人了，但是想象一下，你使用一个状态管理器，和一个定位器来分布你的 blocs/stores/controllers/ 等等类。当你不需要那个依赖的时候，你必须手动调用排除它。但是，你有没有想过简单地使用你的控制器，当它不再被任何人使用时，它会简单地从内存中删除？这就是 GetX 所做的。有了 SmartManagement，所有不被使用的东西都会从内存中删除，除了编程，您不应该担心任何事情。GetX 将保证您消耗的是最低限度的必要资源，甚至没有为此创建一个逻辑。

4-实际解耦。你可能听说过 “将界面与业务逻辑分离” 的概念。这并不是 BLoC、MVC、MVVM 的特例，市面上的其他标准都有这个概念。但是，由于使用了上下文 (context)，这个概念在 Flutter 中往往可以得到缓解。
如果你需要上下文来寻找 InheritedWidget，你需要在界面中找到它，或者通过参数传递上下文。我特别觉得这种解决方案非常丑陋，要在团队中工作，我们总会对 View 的业务逻辑产生依赖。Getx 与标准的做法不一样，虽然它并没有完全禁止使用 StatefulWidgets、InitState 等，但它总有类似的方法，可以更干净。控制器是有生命周期的，例如当你需要进行 APIREST 请求时，你不依赖于界面中的任何东西。你可以使用 onInit 来启动 http 调用，当数据到达时，变量将被填充。由于 GetX 是完全响应式的 (真的，在流下工作)，一旦项目被填充，所有使用该变量的 widgets 将在界面中自动更新。这使得具有 UI 专业知识的人只需要处理 widget，除了用户事件 (比如点击按钮) 之外，不需要向业务逻辑发送任何东西，而处理业务逻辑的人将可以自由地单独创建和测试业务逻辑。

这个库会一直更新和实现新的功能。欢迎提供 PR，并为其做出贡献。

# 社区

## 社区渠道

GetX 拥有一个非常活跃且乐于助人的社区。如果你有问题，或者想得到关于这个框架使用的任何帮助，请加入我们的社区频道。这个资源库是提问、申请资源的专用库，欢迎随时加入 GetX 社区。

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

## 如何做贡献

_ 想为项目做贡献吗？我们将自豪地强调你是我们的合作者之一。以下是您可以做出贡献并使 Get (和 Flutter) 变得更好的几点。

- 帮助将 readme 翻译成其他语言。
- 为 readme 添加文档 (Get 的很多功能还没有被记录下来)。
- 撰写文章或制作视频，教大家如何使用 Get (它们将被记录到 readme 和未来的 Wiki 中)。
- 提供代码/测试的 PR。
- 包括新功能。

欢迎任何贡献

## 文章和视频

- [Dynamic Themes in 3 lines using GetX™](https://medium.com/swlh/flutter-dynamic-themes-in-3-lines-c3b375f292e3) - Tutorial by [Rod Brown](https://github.com/RodBr).
- [Complete GetX™ Navigation](https://www.youtube.com/watch?v=RaqPIoJSTtI) - Route management video by Amateur Coder.
- [Complete GetX State Management](https://www.youtube.com/watch?v=CNpXbeI_slw) - State management video by Amateur Coder.
- [GetX™ Other Features](https://youtu.be/ttQtlX_Q0eU) - utils, storage, bindings and other features video by Amateur Coder.
- [Firestore User with GetX | Todo App](https://www.youtube.com/watch?v=BiV0DcXgk58) - Video by Amateur Coder.
- [Firebase Auth with GetX | Todo App](https://www.youtube.com/watch?v=-H-T_BSgfOE) - Video by Amateur Coder.
- [The Flutter GetX™ Ecosystem ~ State Management](https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d) - State management by [Aachman Garg](https://github.com/imaachman).
- [GetX, the all-in-one Flutter package](https://www.youtube.com/watch?v=IYQgtu9TM74) - A brief tutorial covering State Management and Navigation by Thad Carnevalli.
- [Build a To-do List App from scratch using Flutter and GetX](https://www.youtube.com/watch?v=EcnqFasHf18) - UI + State Management + Storage video by Thad Carnevalli.
- [GetX Flutter Firebase Auth Example](https://medium.com/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2) - Article by Jeff McMorris.
- [Flutter State Management with GetX – Complete App](https://www.appwithflutter.com/flutter-state-management-with-getx/) - by App With Flutter.
- [Flutter Routing with Animation using Get Package](https://www.appwithflutter.com/flutter-routing-using-get-package/) - by App With Flutter.
- [Flutter GetX use --- simple charm!](https://github.com/CNAD666/getx_template/blob/main/docs/Use%20of%20Flutter%20GetX---simple%20charm!.md) - CNAD666
- [Flutter GetX使用---简洁的魅力！](https://juejin.cn/post/6924104248275763208)

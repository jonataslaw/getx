# ＃依赖管理
- [依赖管理](#依赖管理)
  - [实例方法](#实例方法)
    - [Get.put()](#Get.put())
    - [Get.lazyPut](#Get.lazyPut)
    - [Get.putAsync](#Get.putAsync)
    - [Get.create](#Get.create)
  - [使用实例化方法/类](#使用实例化方法/类)
  - [方法之间的差异](#方法之间的差异)
  - [Bindings](#Bindings)
    - [Bindings类](#Bindings类)
    - [BindingsBuilder](#BindingsBuilder)
    - [智能管理](#智能管理)
      - [SmartManagement.full](#smartmanagementfull)
      - [SmartManagement.onlyBuilders](#SmartManagement.onlyBuilders)
      - [SmartManagement.keepFactory](#smartmanagementkeepFactory)
    - [Bindings的工作原理](#Bindings的工作原理)
  - [注释](#注释)

Get有一个简单而强大的依赖管理器，它允许你只用1行代码就能检索到与你的Bloc或Controller相同的类，无需Provider上下文，无需 inheritedWidget。

```dart
Controller controller = Get.put(Controller()); // 而不是 Controller controller = Controller();
```

你是在Get实例中实例化它，而不是在你正在使用的类中实例化你的类，这将使它在整个App中可用。
所以你可以正常使用你的控制器（或Bloc类）。

- 注意：如果你使用的是Get的状态管理器，请多关注[Bindings](#Bindings)api，这将使你的视图更容易连接到你的控制器。
- 注意事项²。Get的依赖管理与包中的其他部分是分离的，所以如果你的应用已经使用了一个状态管理器（任何一个，都没关系），你不需要修改也可以同时使用这个依赖注入管理器，完全没有问题。

## 实例方法
这些方法和它的可配置参数是：

### Get.put()

最常见的插入依赖关系的方式。例如，对于你的视图的控制器来说：

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

这是你使用put时可以设置的所有选项。
```dart
Get.put<S>(
  // 必备：你想得到保存的类，比如控制器或其他东西。
  // 注："S "意味着它可以是任何类型的类。
  S dependency

  // 可选：当你想要多个相同类型的类时，可以用这个方法。
  // 因为你通常使用Get.find<Controller>()来获取一个类。
  // 你需要使用标签来告诉你需要哪个实例。
  // 必须是唯一的字符串
  String tag,

  // 可选：默认情况下，get会在实例不再使用后进行销毁
  // （例如：一个已经销毁的视图的Controller)
  // 但你可能需要这个实例在整个应用生命周期中保留在那里，就像一个sharedPreferences的实例或其他东西。
  //所以你设置这个选项
  // 默认值为false
  bool permanent = false,

  // 可选：允许你在测试中使用一个抽象类后，用另一个抽象类代替它，然后再进行测试。
  // 默认为false
  bool overrideAbstract = false,

  // 可选：允许你使用函数而不是依赖（dependency）本身来创建依赖。
  // 这个不常用
  InstanceBuilderCallback<S> builder,
)
```

### Get.lazyPut
可以懒加载一个依赖，这样它只有在使用时才会被实例化。这对于计算代价高的类来说非常有用，或者如果你想在一个地方实例化几个类（比如在Bindings类中），而且你知道你不会在那个时候使用这个类。

```dart
///只有当第一次使用Get.find<ApiMock>时，ApiMock才会被调用。
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () => {
  // ... some logic if needed
    return FirebaseAuth()
  },
  tag: Math.random().toString(),
  fenix: true
)

Get.lazyPut<Controller>( () => Controller() )
```

这是你在使用lazyPut时可以设置的所有选项。
```dart
Get.lazyPut<S>(
  // 强制性：当你的类第一次被调用时，将被执行的方法。
  InstanceBuilderCallback builder,
  
  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
  // 必须是唯一的
  String tag,

  // 可选：类似于 "永久"，
  // 不同的是，当不使用时，实例会被丢弃，但当再次需要使用时，Get会重新创建实例，
  // 就像 bindings api 中的 "SmartManagement.keepFactory "一样。
  // 默认值为false
  bool fenix = false
  
)
```

### Get.putAsync
如果你想注册一个异步实例，你可以使用`Get.putAsync`。

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>( () async => await YourAsyncClass() )
```

这都是你在使用putAsync时可以设置的选项。
```dart
Get.putAsync<S>(

  // 必备：一个将被执行的异步方法，用于实例化你的类。
  AsyncInstanceBuilderCallback<S> builder,

  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
  // 必须是唯一的
  String tag,

  // 可选：与Get.put()相同，当你需要在整个应用程序中保持该实例的生命时使用。
  // 默认值为false
  bool permanent = false
)
```

### Get.create

这个就比较棘手了。关于这个是什么和其他的区别，可以在[方法之间的差异](#方法之间的差异)部分找到详细的解释。

```dart
Get.Create<SomeClass>(() => SomeClass());
Get.Create<LoginController>(() => LoginController());
```

这是你在使用create时可以设置的所有选项。

```dart
Get.create<S>(
  // 需要：一个返回每次调用"Get.find() "都会被新建的类的函数。
  // 示例: Get.create<YourClass>(()=>YourClass())
  FcBuilderFunc<S> builder,

  // 可选：就像Get.put()一样，但当你需要多个同类的实例时，会用到它。
  // 当你有一个列表，每个项目都需要自己的控制器时，这很有用。
  // 需要是一个唯一的字符串。只要把标签改成名字
  String name,

  // 可选：就像 Get.put() 一样，
  // 它是为了当你需要在整个应用中保活实例的时候
  // 区别在于 Get.create 的 permanent默认为true
  bool permanent = true
```

## 使用实例化方法/类

想象一下，你已经浏览了无数条路由，现在你需要拿到一个被遗留在控制器中的数据，那么你会需要一个状态管理器与Provider或Get_it相结合，对吗？用Get则不然，你只需要让Get为你的控制器自动 "寻找"，你不需要任何额外的依赖关系。

```dart
final controller = Get.find<Controller>();
// 或者
Controller controller = Get.find();

// 是的，它看起来像魔术，Get会找到你的控制器，并将其提供给你。
// 你可以实例化100万个控制器，Get总会给你正确的控制器。
```

然后你就可以恢复你在后面获得的控制器数据。

```dart
Text(controller.textFromApi);
```

由于返回的值是一个正常的类，你可以做任何你想做的事情。
```dart
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // out: 12345
```

移除一个Get实例:

```dart
Get.delete<Controller>(); //通常你不需要这样做，因为GetX已经删除了未使用的控制器。
```

## 方法之间的差异

首先，让我们来看看Get.lazyPut的 "fenix "和其他方法的 "permanent"。

`permanent`和`fenix`的根本区别在于你想如何存储实例。

强化：默认情况下，GetX会在不使用实例时删除它们。
这意味着 如果页面1有控制器1，页面2有控制器2，而你从堆栈中删除了第一个路由，（比如你使用`Get.off()`或`Get.offNamed()`）控制器1失去了它的使用，所以它将被删除。

但是如果你想选择使用`permanent:true`，那么控制器就不会在这个过渡中丢失--这对于你想在整个应用程序中保持生命的服务来说非常有用。

`fenix`则是针对那些你不担心在页面变化之间丢失的服务，但当你需要该服务时，你希望它还活着。所以基本上，它会处理未使用的控制器/服务/类，但当你需要它时，它会 "从灰烬中重新创建 "一个新的实例。

继续说说方法之间的区别：

- Get.put和Get.putAsync的创建顺序是一样的，不同的是，第二个方法使用的是异步方法创建和初始化实例。put是直接插入内存，使用内部方法`insert`，参数`permanent: false`和`isSingleton: true`（这个isSingleton参数只是告诉它是使用`dependency`上的依赖，还是使用`FcBuilderFunc`上的依赖），之后，调用`Get.find()`，立即初始化内存中的实例。

- Get.create。顾名思义，它将 "创建 "你的依赖关系！类似于`Get.put()`。与`Get.put()`类似，它也会调用内部方法`insert`来实例化。但是`permanent`变成了true，而`isSingleton`变成了false（因为我们是在 "创建 "我们的依赖关系，所以它没有办法成为一个单例，这就是为什么是false）。因为它有`permanent: true`，所以我们默认的好处是不会在页面跳转之间销毁它。另外，`Get.find()`并不是立即被调用，而是等待在页面中被调用，这样创建是为了利用 "permanent "这个参数，值得注意的是，`Get.create()`的目标是创建不共享的实例，但不会被销毁，比如listView中的一个按钮，你想为该列表创建一个唯一的实例--正因为如此，Get.create必须和GetWidget一起使用。

- Get.lazyPut。顾名思义，这是一个懒加载的过程。实例被创建了，但它并没有被调用来立即使用，而是一直等待被调用。与其他方法相反，这里没有调用 "insert"。取而代之的是，实例被插入到内存的另一个部分，这个部分负责判断实例是否可以被重新创建，我们称之为 "工厂"。如果我们想创建一些以后使用的东西，它不会和现在使用的东西混在一起。这就是 "fenix "的魔力所在：如果你选择留下 "fenix: false"，并且你的 "smartManagement "不是 "keepFactory"，那么当使用 "Get.find "时，实例将把内存中的位置从 "工厂 "改为普通实例内存区域。紧接着，默认情况下，它将从 "工厂 "中移除。现在，如果你选择 "fenix: true"，实例将继续存在这个专用的部分，甚至进入公共区域，以便将来再次被调用。

## Bindings

这个包最大的区别之一，也许就是可以将路由、状态管理器和依赖管理器完全集成。
当一个路由从Stack中移除时，所有与它相关的控制器、变量和对象的实例都会从内存中移除。如果你使用的是流或定时器，它们会自动关闭，你不必担心这些。
在2.10版本中，Get完全实现了Bindings API。
现在你不再需要使用init方法了。如果你不想的话，你甚至不需要键入你的控制器。你可以在适当的地方启动你的控制器和服务来实现。
Binding类是一个将解耦依赖注入的类，同时 "Bindings "路由到状态管理器和依赖管理器。
这使得Get可以知道当使用某个控制器时，哪个页面正在显示，并知道在哪里以及如何销毁它。
此外，Binding类将允许你拥有SmartManager配置控制。你可以配置依赖关系，当从堆栈中删除一个路由时，或者当使用它的widget被布置时，或者两者都不布置。你将有智能依赖管理为你工作，但即使如此，你也可以按照你的意愿进行配置。

### Bindings类

- 创建一个类并实现Binding

```dart
class HomeBinding implements Bindings {}
```

你的IDE会自动要求你重写 "dependencies"方法，然后插入你要在该路由上使用的所有类。

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

现在你只需要通知你的路由，你将使用该 Binding 来建立路由管理器、依赖关系和状态之间的连接。

- 使用别名路由：

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

- 使用正常路由。

```dart
Get.to(Home(), binding: HomeBinding());
Get.to(DetailsView(), binding: DetailsBinding())
```

至此，你不必再担心你的应用程序的内存管理，Get将为你做这件事。

Binding类在调用路由时被调用，你可以在你的GetMaterialApp中创建一个 "initialBinding "来插入所有将要创建的依赖关系。

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

### BindingsBuilder

创建Bindings的默认方式是创建一个实现Bindings的类，但是，你也可以使用`BindingsBuilder`回调，这样你就可以简单地使用一个函数来实例化任何你想要的东西。

例子:

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

这样一来，你就可以避免为每条路径创建一个 Binding 类，使之更加简单。

两种方式都可以完美地工作，我们希望您使用最适合您的风格。

### 智能管理

GetX 默认情况下会将未使用的控制器从内存中移除。
但是如果你想改变GetX控制类的销毁方式，你可以用`SmartManagement`类设置不同的行为。

#### 如何改变

如果你想改变这个配置（你通常不需要），就用这个方法。

```dart
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //这里
      home: Home(),
    )
  )
}
```

#### SmartManagement.full

这是默认的。销毁那些没有被使用的、没有被设置为永久的类。在大多数情况下，你会希望保持这个配置不受影响。如果你是第一次使用GetX，那么不要改变这个配置。

#### SmartManagement.onlyBuilders
使用该选项，只有在`init:`中启动的控制器或用`Get.lazyPut()`加载到Binding中的控制器才会被销毁。

如果你使用`Get.put()`或`Get.putAsync()`或任何其他方法，SmartManagement将没有权限移除这个依赖。

在默认行为下，即使是用 "Get.put "实例化的widget也会被移除，这与SmartManagement.onlyBuilders不同。

#### SmartManagement.keepFactory

就像SmartManagement.full一样，当它不再被使用时，它将删除它的依赖关系，但它将保留它们的工厂，这意味着如果你再次需要该实例，它将重新创建该依赖关系。
### Bindings的工作原理
Bindings会创建过渡性工厂，在你点击进入另一个页面的那一刻，这些工厂就会被创建，一旦换屏动画发生，就会被销毁。
这种情况发生得非常快，以至于分析器甚至都来不及注册。
当你再次导航到这个页面时，一个新的临时工厂将被调用，所以这比使用SmartManagement.keepFactory更可取，但如果你不想创建Bindings，或者想让你所有的依赖关系都在同一个Binding上，它肯定会帮助你。
Factories占用的内存很少，它们并不持有实例，而是一个具有你想要的那个类的 "形状 "的函数。
这在内存上的成本很低，但由于这个库的目的是用最少的资源获得最大的性能，所以Get连工厂都默认删除。
请使用对你来说最方便的方法。

## 注释

- 如果你使用多个Bindings，不要使用SmartManagement.keepFactory。它被设计成在没有Bindings的情况下使用，或者在GetMaterialApp的初始Binding中链接一个Binding。

- 使用Bindings是完全可选的，你也可以在使用给定控制器的类上使用`Get.put()`和`Get.find()`。
然而，如果你使用Services或任何其他抽象，我建议使用Bindings来更好地组织。

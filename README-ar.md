> GetX 5 RC: هذا المرشح غير منشور بعد؛ الأساس المختبر هو Flutter 3.47.9 وDart 3.13.7 مع مكتبات واجهة Flutter المضمّنة.

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png)

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

<div align="center">

**Languages:**

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![فارسی](https://img.shields.io/badge/Language-Persian-blueviolet?style=for-the-badge)](README-fa.md)
[![Vietnamese](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
[![Indonesian](https://img.shields.io/badge/Language-Indonesian-blueviolet?style=for-the-badge)](README.id-ID.md)
[![Urdu](https://img.shields.io/badge/Language-Urdu-blueviolet?style=for-the-badge)](README.ur-PK.md)
[![Chinese](https://img.shields.io/badge/Language-Chinese-blueviolet?style=for-the-badge)](README.zh-cn.md)
[![Portuguese](https://img.shields.io/badge/Language-Portuguese-blueviolet?style=for-the-badge)](README.pt-br.md)
[![Spanish](https://img.shields.io/badge/Language-Spanish-blueviolet?style=for-the-badge)](README-es.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blueviolet?style=for-the-badge)](README.ru.md)
[![Polish](https://img.shields.io/badge/Language-Polish-blueviolet?style=for-the-badge)](README.pl.md)
[![Korean](https://img.shields.io/badge/Language-Korean-blueviolet?style=for-the-badge)](README.ko-kr.md)
[![French](https://img.shields.io/badge/Language-French-blueviolet?style=for-the-badge)](README-fr.md)
[![العربيه](https://img.shields.io/badge/Language-arabic-blueviolet?style=for-the-badge)](README-ar.md)

</div>
<div dir="rtl">

## المحتويات

  - [تحديثات GetX 5 في هذا الفرع](#getx5-current)
- [عن المكتبة](#readme-section-2)
- [التركيب](#readme-section-3)
- [بناء تطبيق العداد 🔢](#readme-section-4)
- [The Three pillars](#readme-section-5)
  - [State management](#readme-section-6)
    - [Reactive State Manager](#readme-section-7)
    - [More details about state management](#readme-section-8)
  - [Route management](#readme-section-9)
    - [More details about route management](#readme-section-10)
  - [Dependency management](#readme-section-11)
    - [More details about dependency management](#readme-section-12)
- [Utils](#readme-section-13)
  - [Internationalization](#readme-section-14)
    - [Translations](#readme-section-15)
    - [Using translations](#readme-section-16)
    - [Using translation with singular and plural](#readme-section-17)
    - [Using translation with parameters](#readme-section-18)
    - [Locales](#readme-section-19)
    - [Change locale](#readme-section-20)
    - [System locale](#readme-section-21)
  - [Change Theme](#readme-section-22)
  - [GetConnect](#readme-section-23)
    - [Default configuration](#readme-section-24)
    - [Custom configuration](#readme-section-25)
  - [GetPage Middleware](#readme-section-26)
    - [Priority](#readme-section-27)
    - [Redirect](#readme-section-28)
    - [onPageCalled](#readme-section-29)
    - [OnBindingsStart](#readme-section-30)
    - [OnPageBuildStart](#readme-section-31)
    - [OnPageBuilt](#readme-section-32)
    - [OnPageDispose](#readme-section-33)
  - [Other Advanced APIs](#readme-section-34)
    - [Optional Global Settings and Manual configurations](#readme-section-35)
    - [Local State Widgets](#readme-section-36)
    - [ValueBuilder](#readme-section-37)
    - [ObxValue](#readme-section-38)
  - [Useful tips](#readme-section-39)
  - [StateMixin](#readme-section-40)
    - [GetView](#readme-section-41)
    - [GetResponsiveView](#readme-section-42)
    - [How to use it](#readme-section-43)
    - [GetWidget](#readme-section-44)
    - [GetxService](#readme-section-45)
    - [Tests](#readme-section-46)
    - [Tips](#readme-section-47)
    - [Mockito or mocktail](#readme-section-48)
    - [Using Get.reset()](#readme-section-49)
    - [Get.testMode](#readme-section-50)
- [Breaking changes from 2.0](#readme-section-51)
- [Why Getx?](#readme-section-52)
- [Community](#readme-section-53)
  - [Community channels](#readme-section-54)
  - [How to contribute](#readme-section-55)
  - [Articles and videos](#readme-section-56)

<a id="getx5-current"></a>

## تحديثات GetX 5 في هذا الفرع

هذا المرشح غير منشور بعد؛ الأساس المختبر هو Flutter 3.47.9 وDart 3.13.7 مع مكتبات واجهة Flutter المضمّنة.

```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
    path: ../getx
```

تعيد Binding قائمة `List<Bind>`. استخدم binds للتطبيق وbindings للمسار. استبدل Get.create بـGet.spawn، وانتظر التهيئة غير المتزامنة ثم سجّل القيمة عبر Get.put.

```dart
class RcNamesController extends GetxController with StateMixin<List<String>> {
  final labels = RxSet<String>();

  void showNames(List<String> names) =>
      change(GetStatus<List<String>>.success(names));

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
}

class RcNamesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<RcNamesController>(() => RcNamesController()),
  ];
}

Widget rcNamesApplication() => GetMaterialApp(
  restorationScopeId: 'names-app',
  initialRoute: '/names',
  getPages: [
    GetPage<void>(
      name: '/names',
      restorationId: 'names',
      bindings: [RcNamesBinding()],
      page: () => Scaffold(
        body: Get.find<RcNamesController>().obx(
          (names) => Text(names.join(', ')),
          onEmpty: const Text('No data'),
          onError: (error) => Text(error ?? 'Unknown error'),
        ),
      ),
    ),
  ],
);
```

تحمل `GetStatus<T>.success(data)` البيانات الناجحة. تستقبل futurize دالة تنشئ Future وتعيد void؛ تطبّق النتائج بترتيب اكتمالها. تنشئ مجموعات Rx الافتراضية مخازن مستقلة قابلة للتعديل.

تعمل الملاحة عبر Navigator 2. يعيد Get.back الصفحات؛ أغلق الحوار والورقة وsnackbar بالوظائف المخصصة. قد تكون Get.context وGet.overlayContext بقيمة null خارج عمر التطبيق.

فعّل restorationScopeId وأعط الصفحات restorationId ثابتة لاستعادة سجل المسارات المسمّاة. الوسائط JSON فقط، مع فحص middleware وحدود للحجم. تنشأ متحكمات وFuture جديدة بعد موت العملية.

أُصلحت إزالة response modifiers وأخطاء المصادقة والمهلة والإلغاء وفك الاستجابة. اختُبرت HTTP وWebSocket في IO والمتصفح وJS/WASM مع تحرير الاتصالات والاشتراكات.

يبقى خلل percent-encoding في سجل متصفح Flutter 3.47.9 موثقاً؛ لا تعني اختبارات الويب العادية إصلاحه. اختبر refresh وback والاستعادة على المضيف والجهاز الفعليين.

اضبط الخيارات على GetMaterialApp أو GetCupertinoApp؛ لا تستخدم Get.config القديم. للمسارات المخصصة استخدم إعداد Navigator 2 متكاملاً.

تغيّر وسيط GetNavigator وGetRouterOutlet.pickPages من `onPopPage` إلى `onDidRemovePage`. هذا إشعار بعد الحذف؛ استخدم `GetPage.canPop` أو `PopScope` لمنع الرجوع، ومرّر الإشعار إلى `delegate.didRemovePage` إذا خصّصت callback المخرج.

[Migration](documentation/en_US/migration_guide_5.md) · [Release scope](documentation/en_US/release_scope_5.md) · [CHANGELOG](CHANGELOG.md) · [English](README.md) · [فارسی](README-fa.md)

<a id="readme-section-2"></a>

# عن المكتبة

- `GetX` مكتبه خفيفه وقوية لفلاتر , توفر المكتبه السرعه العاليه في التحكم في الحاله , نظام حقن `Ddependency injection` ذكي , والتحكم في التنقل بين الصفحات بسرعه وسهوله

- `GetX`
- تعتمد علي 3 نقاط اساسية . **الانتاجية والسرعه والتنظيم**

  - **الأداء:** توفّر GetX واجهات تفاعلية وواجهات stream؛ لا يلزم إنشاء StreamController وStreamBuilder يدويين لكل قيمة. اختر Obx أوGetBuilder حسب نمط التحديث، وقِس إعادة البناء والموارد في تطبيقك.

  - **الانتاجية:** `GetX` تستخدم طريقه سهله ومريحة في كتابة الكود , لا يهم ماذا تريد انت تبني , يوجد دائما طريقه اسهل لبناء باستخدام `GetX` , ستوفر ساعات من العمل وتوفر لك اعلي سرعه يمكن الوصل لها في تطبيقاتك عموما , يجب ان يهتم المطور بالتخلص من الموارد الغير مستخدمه من الذاكرة , مع `GetX` هذا غير ضروري لانه يتم التخلص من الموارد الغير مستخدمه من الذاكره تلقائيا, اذا اردت تركهم دائما في الذاكرة يمكنك ذلك لكن يجب عليك ان تستخدم `permanent: true` بالاضافه الي توفير الوقت تم تقليل امكانية ترك الموارد في الذاكره بدون التخلص منها , يتم حقن الموارد `lazy` افتراضيا

  - **التنظيم:** `GetX` تسمح لك بفصل الـ `view` عن الـ `presentation logic` و `business logic` باكامل,
    بالنسبة للحقن `dependency injection` و التنقل بين الشاشات لا تحتاج فيهم `context` للتنقل بين الصفحات , ولا تحتاك `context` للوصول للموارد عن طريق widget tree, لذلك يتم الفصل بالكامل بين `presentation logic` و `business logic` لا تحتاج لحقن ال `Controllers/Models/Blocs`
    داخل شجره العناصر `Widget Tree` خلال `MultiProvider`s.
    لان , `GetX` تستخدم نظام حقن خاص بها ويمكنك من فصل الـ `DI` عن الوجهات بالكامل .

- مع `Getx` تعرف ايه يكون الكود الخاص ب كل جزء في التطبيق , تساعدك في كتابة كود نظيف , بالاضافه الي سهوله التطوير مستقبلا , وهذا يمكنك من مشاركه الاجزاء `modules` امر صعب ليصبح سهل جدا .
  `BLOC` كان نقطه البداية لهذا الامر وتظيم الكود بهذه الطريقه في فلاتر , عن طريق فصل كود البزنس عن الواجهات , `GetX` هي التطور لذلك الامر , وذلك عن طريق الاضافه الي ذلك فصل حقن الموارد وفصل التنقل بين الشاشات ايضا , وطبقه البيانات بالكامل ايضا , تعلم اين يكون كل شي في المشروع

- `Getx` توفر لك السهوله في بناء المشروع والاستقرار كلما كبر حجم المشروع واقصي سرعه ممكن , توفر لك ايضا نظام كامل يعمل في تجانس تام , سهل للمبتدئين , ومنظم للخبراء , امن , مستقر , ومحدث باستمرار ويوفر لك موجموعه من الادوات لتسهل عليك

- `GetX` ليست ضخمه , تمتلك المكتبة العديد من المميزات تجعلك تبدا في البرمجه بدون القلق عن اي شي كل ميزه منهم منقسمه عن الاخري ولا يبداو الا عندما تستخدمهم , اذا استخدمت جزء التحكم في الحاله فقط لن يتم استخدام جزء التنقل بين الشاشات في تطبيقك الا `Compiled` والعكس صحيح ! .

-`Getx` لديها نظام شامل , ومجتمع كبير , وعداد كبير من المطورين , وسوف يتم تحديثها باستمرار , تعمل المكتبة علي كل الانظمه بنفس الكود دون تغيير `Android`, `iOS`, `Web`, `Mac`, `Linux`, `Windows` حتي علي الخادم يمكنك استخدام `Getx` لبناء تطبيقات الويب
**[Get Server](https://github.com/jonataslaw/get_server)**.

**بالاضافه الي ذلك يمكن محاكاه الامر اكثر في فلاتر والخادم عن طريق [Get CLI](https://github.com/jonataslaw/get_cli)**.

**وللمزيد من الانتاجية يمكنك استخدام اضافه للـ**

- [فيجوال ستوديو كود](https://marketplace.visualstudio.com/items?itemName=get-snippets.get-snippets)
- [اندرويد استوديو و انتلج](https://plugins.jetbrains.com/plugin/14975-getx-snippets)

<a id="readme-section-3"></a>

# التركيب

استخدم المكتبة في ملف `pubspec.yaml`

<div dir="ltr" >

```yaml
dependencies:
  get:
```

</div>
استدعي المكتبة في الملفات الي ستستخدمها
<div dir="ltr" >

```dart
import 'package:get/get.dart';
```

</div>

<a id="readme-section-4"></a>

# بناء تطبيق العداد 🔢

تطبيق العداد الذي يتم انشاء مع كل مشروع جديد يتعدي ال 100 سطر (بالتعليقات) ولكي اريك مدي قوه `GetX`
ساوضح لك كيفيه بناء التطبيق مع تغير قيمه العداد مع كل ضغطه زر والتقل بين الشاشات ومشاركه الحاله كل ذلك بطريقه منذمه وفصل تام لكود البزنس عن الواجهات فقط ب 26 سطر من ضمنهم التعليقات 🔥

- الخطوه الاولي :
  اكتب `Get` امام `MaterialApp` لتصبح `GetMaterialApp`

<div dir="ltr" >

```dart
void main() => runApp(GetMaterialApp(home: Home()));
```

</div>

- ملحوظه : هذا لا يعتبر تعديل علي `MaterialApp` لان , `GetMaterialApp` عباره عن عنصر معد مسبقا ويستخدم `MaterialApp` تحت الغطاء , يمكن تغير الاعدادات يدوين لكن هذا غير ضروري لان ``سيقوم بعمل المسارات و حقن العناصر والترجمه وكل شي تحتاجه ولكن اذا كنت تنوي لاستخدام المكتبة فقط للتحكم في الحاله`State managment`فهذه الخطوه غير ضرورية تكون هذه الخطوه ضرورية عندما تريد التنقل بين الشاشات او عرض`snackbars`والترجمه و اي شي يعتمد علي`context`وتقوم`getx` بتوفيره

- الخطوه الثانية
  قم بكتابة الكود داخل `class` وكتابة المتغيرات والدوال , يمكنك جعل المتغير قابلع لاعاده بناء الواجها عند تغير قيمته باستخدام ال `getter` `.obs` .

<div dir="ltr" >

```dart
class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}
```

</div>

- الخطوه الثالثه
ابني الواجهه واستخدم `StatelessWidget` لتوفير الموارد , مع `Getx` يمكنك الاستغناء عن `StatefulWidget`.
<div dir="ltr" >

```dart
class Home extends StatelessWidget {

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final  c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Center(child: ElevatedButton(
              child: Text("Go to Other"), onPressed: () => Get.to(() => Other()))),
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

</div>

Result:

![](https://raw.githubusercontent.com/jonataslaw/getx-community/master/counter-app-gif.gif)

This is a simple project but it already makes clear how powerful Get is. As your project grows, this difference will become more significant.

Get was designed to work with teams, but it makes the job of an individual developer simple.

Improve your deadlines, deliver everything on time without losing performance. Get is not for everyone, but if you identified with that phrase, Get is for you!

<a id="readme-section-5"></a>

# The Three pillars

<a id="readme-section-6"></a>

## State management

Get has two different state managers: the simple state manager (we'll call it GetBuilder) and the reactive state manager (GetX/Obx)

<a id="readme-section-7"></a>

### Reactive State Manager

Reactive programming can alienate many people because it is said to be complicated. GetX turns reactive programming into something quite simple:

- You won't need to create StreamControllers.
- You won't need to create a StreamBuilder for each variable
- You will not need to create a class for each state.
- You will not need to create a get for an initial value.
- You will not need to use code generators

Reactive programming with Get is as easy as using setState.

Let's imagine that you have a name variable and want that every time you change it, all widgets that use it are automatically changed.

This is your count variable:

```dart
var name = 'Jonatas Borges';
```

To make it observable, you just need to add ".obs" to the end of it:

```dart
var name = 'Jonatas Borges'.obs;
```

And in the UI, when you want to show that value and update the screen whenever the values changes, simply do this:

```dart
Obx(() => Text("${controller.name}"));
```

That's all. It's _that_ simple.

<a id="readme-section-8"></a>

### More details about state management

**See an more in-depth explanation of state management [here](./documentation/en_US/state_management.md). There you will see more examples and also the difference between the simple state manager and the reactive state manager**

You will get a good idea of GetX power.

<a id="readme-section-9"></a>

## Route management

If you are going to use routes/snackbars/dialogs/bottomsheets without context, GetX is excellent for you too, just see it:

Add "Get" before your MaterialApp, turning it into GetMaterialApp

```dart
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
```

Navigate to a new screen:

```dart

Get.to(() => NextScreen());
```

Navigate to new screen with name. See more details on named routes [here](./documentation/en_US/route_management.md#navigation-with-named-routes)

```dart

Get.toNamed('/details');
```

To close snackbars, dialogs, bottomsheets, or anything you would normally close with Navigator.pop(context);

```dart
Get.closeDialog();
Get.closeOverlay(); // Current dialog or bottom sheet
Get.closeCurrentSnackbar();
// Return a page instead:
Get.back();
```

To go to the next screen and no option to go back to the previous screen (for use in SplashScreens, login screens, etc.)

```dart
Get.off(() => NextScreen());
```

To go to the next screen and cancel all previous routes (useful in shopping carts, polls, and tests)

```dart
Get.offAll(() => NextScreen());
```

Noticed that you didn't have to use context to do any of these things? That's one of the biggest advantages of using Get route management. With this, you can execute all these methods from within your controller class, without worries.

<a id="readme-section-10"></a>

### More details about route management

**Get works with named routes and also offers lower-level control over your routes! There is in-depth documentation [here](./documentation/en_US/route_management.md)**

<a id="readme-section-11"></a>

## Dependency management

Get has a simple and powerful dependency manager that allows you to retrieve the same class as your Bloc or Controller with just 1 lines of code, no Provider context, no inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // Rather Controller controller = Controller();
```

- Note: If you are using Get's State Manager, pay more attention to the bindings API, which will make it easier to connect your view to your controller.

Instead of instantiating your class within the class you are using, you are instantiating it within the Get instance, which will make it available throughout your App.
So you can use your controller (or class Bloc) normally

**Tip:** Get dependency management is decoupled from other parts of the package, so if for example, your app is already using a state manager (any one, it doesn't matter), you don't need to rewrite it all, you can use this dependency injection with no problems at all

```dart
controller.fetchApi();
```

Imagine that you have navigated through numerous routes, and you need data that was left behind in your controller, you would need a state manager combined with the Provider or Get_it, correct? Not with Get. You just need to ask Get to "find" for your controller, you don't need any additional dependencies:

```dart
Controller controller = Get.find();
//Yes, it looks like Magic, Get will find your controller, and will deliver it to you. You can have 1 million controllers instantiated, Get will always give you the right controller.
```

And then you will be able to recover your controller data that was obtained back there:

```dart
Text(controller.textFromApi);
```

<a id="readme-section-12"></a>

### More details about dependency management

**See a more in-depth explanation of dependency management [here](./documentation/en_US/dependency_management.md)**

<a id="readme-section-13"></a>

# Utils

<a id="readme-section-14"></a>

## Internationalization

<a id="readme-section-15"></a>

### Translations

Translations are kept as a simple key-value dictionary map.
To add custom translations, create a class and extend `Translations`.

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

<a id="readme-section-16"></a>

#### Using translations

Just append `.tr` to the specified key and it will be translated, using the current value of `Get.locale` and `Get.fallbackLocale`.

```dart
Text('title'.tr);
```

<a id="readme-section-17"></a>

#### Using translation with singular and plural

```dart
var products = [];
Text('singularKey'.trPlural('pluralKey', products.length));
```

<a id="readme-section-18"></a>

#### Using translation with parameters

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

<a id="readme-section-19"></a>

### Locales

Pass parameters to `GetMaterialApp` to define the locale and translations.

```dart
return GetMaterialApp(
    translations: Messages(), // your translations
    locale: Locale('en', 'US'), // translations will be displayed in that locale
    fallbackLocale: Locale('en', 'UK'), // specify the fallback locale in case an invalid locale is selected.
);
```

<a id="readme-section-20"></a>

#### Change locale

Call `Get.updateLocale(locale)` to update the locale. Translations then automatically use the new locale.

```dart
var locale = Locale('en', 'US');
Get.updateLocale(locale);
```

<a id="readme-section-21"></a>

#### System locale

To read the system locale, you could use `Get.deviceLocale`.

```dart
return GetMaterialApp(
    locale: Get.deviceLocale,
);
```

<a id="readme-section-22"></a>

## Change Theme

Please do not use any higher level widget than `GetMaterialApp` in order to update it. This can trigger duplicate keys. A lot of people are used to the prehistoric approach of creating a "ThemeProvider" widget just to change the theme of your app, and this is definitely NOT necessary with **GetX™**.

You can create your custom theme and simply add it within `Get.changeTheme` without any boilerplate for that:

```dart
Get.changeTheme(ThemeData.light());
```

If you want to create something like a button that changes the Theme in `onTap`, you can combine two **GetX™** APIs for that:

- The api that checks if the dark `Theme` is being used.
- And the `Theme` Change API, you can just put this within an `onPressed`:

```dart
Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
```

When `.darkmode` is activated, it will switch to the _light theme_, and when the _light theme_ becomes active, it will change to _dark theme_.

<a id="readme-section-23"></a>

## GetConnect

GetConnect is an easy way to communicate from your back to your front with http or websockets

<a id="readme-section-24"></a>

### Default configuration

You can simply extend GetConnect and use the GET/POST/PUT/DELETE/SOCKET methods to communicate with your Rest API or websockets.

```dart
class ApiUser {
  ApiUser(this.name);
  final String name;

  static ApiUser fromJson(dynamic data) =>
      ApiUser((data as Map<String, dynamic>)['name'] as String);
}

class UserProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response<ApiUser>> getUser(int id) =>
      get<ApiUser>('/users/$id', decoder: ApiUser.fromJson);

  Future<Response<dynamic>> createUser(String name) =>
      post<dynamic>('/users', {'name': name});

  Future<Response<dynamic>> uploadAvatar(List<int> bytes) =>
      post<dynamic>('/upload', FormData({
        'file': MultipartFile(bytes, filename: 'avatar.png'),
      }));
}
```

<a id="readme-section-25"></a>

### Custom configuration

GetConnect is highly customizable You can define base Url, as answer modifiers, as Requests modifiers, define an authenticator, and even the number of attempts in which it will try to authenticate itself, in addition to giving the possibility to define a standard decoder that will transform all your requests into your Models without any additional configuration.

```dart
class HomeProvider extends GetConnect {
  HomeProvider(this.token);
  final String Function() token;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://example.com/api';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
    httpClient.addResponseModifier<dynamic>((request, response) {
      Get.log('HTTP status: ${response.statusCode}');
      return response;
    });
    httpClient.addAuthenticator<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${token()}';
      return request;
    });
    httpClient.maxAuthRetries = 2;
  }

  Future<Response<Map<String, dynamic>>> getCases(String path) =>
      get<Map<String, dynamic>>(path);
}
```

<a id="readme-section-26"></a>

## GetPage Middleware

The GetPage has now new property that takes a list of GetMiddleWare and run them in the specific order.

**Note**: When GetPage has a Middlewares, all the children of this page will have the same middlewares automatically.

<a id="readme-section-27"></a>

### Priority

The Order of the Middlewares to run can be set by the priority in the GetMiddleware.

```dart
class PriorityMiddleware extends GetMiddleware {
  PriorityMiddleware({super.priority});
}

final middlewares = [
  PriorityMiddleware(priority: 2),
  PriorityMiddleware(priority: 5),
  PriorityMiddleware(priority: 4),
  PriorityMiddleware(priority: -8),
];
```

those middlewares will be run in this order **-8 => 2 => 4 => 5**

<a id="readme-section-28"></a>

### Redirect

في redirectDelegate، أعد route للمتابعة أوRouteDecoder آخر للتحويل أوnull للإلغاء. سجّل مسار login وتجنب حلقة التحويل.

```dart
class AuthService extends GetxService {
  final authed = false.obs;
}

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({super.priority});

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final auth = Get.find<AuthService>();
    return auth.authed.value ? route : RouteDecoder.fromRoute('/login');
  }
}
```

<a id="readme-section-29"></a>

### onPageCalled

This function will be called when this Page is called before anything created
you can use it to change something about the page or give it new page

```dart
class PageTitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) => page?.copyWith(title: 'Welcome');
}
```

<a id="readme-section-30"></a>

### OnBindingsStart

This function will be called right before the Bindings are initialize.
Here you can change Bindings for this page.

```dart
class BindingMiddleware extends GetMiddleware {
  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) =>
      bindings == null ? null : List<R>.of(bindings);
}
```

<a id="readme-section-31"></a>

### OnPageBuildStart

This function will be called right after the Bindings are initialize.
Here you can do something after that you created the bindings and before creating the page widget.

```dart
class BuildMiddleware extends GetMiddleware {
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;
}
```

<a id="readme-section-32"></a>

### OnPageBuilt

This function will be called right after the GetPage.page function is called and will give you the result of the function. and take the widget that will be showed.

<a id="readme-section-33"></a>

### OnPageDispose

This function will be called right after disposing all the related objects (Controllers, views, ...) of the page.

<a id="readme-section-34"></a>

## Other Advanced APIs

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
Get.removeRoute('/details')

// back repeatedly until the predicate returns true.
Get.until((page) => page.name == '/home')

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil(() => const Scaffold(), (page) => page.name == '/home')

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil('/details', (page) => page.name == '/home')

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
Get.overlayContext

// Note: the following methods are extensions on context. Since you
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
context.mediaQuerySize

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets

/// Similar to MediaQuery.of(context).orientation;
context.orientation

/// Check if device is on landscape mode
context.isLandscape

/// Check if device is on portrait mode
context.isPortrait

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor

/// Get the shortestSide from screen
context.mediaQueryShortestSide

/// True if width be larger than 800
context.showNavbar

/// True if the shortestSide is smaller than 600p
context.isPhone

/// True if the shortestSide is largest than 600p
context.isSmallTablet

/// True if the shortestSide is largest than 720p
context.isLargeTablet

/// True if the current device is Tablet
context.isTablet

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

<a id="readme-section-35"></a>

### Optional Global Settings and Manual configurations

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

اضبط الخيارات على GetMaterialApp أو GetCupertinoApp؛ لا تستخدم Get.config القديم. للمسارات المخصصة استخدم إعداد Navigator 2 متكاملاً.

```dart
Widget configuredApplication() => GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  transitionDuration: const Duration(milliseconds: 250),
  popGesture: true,
  logWriterCallback: localLogWriter,
  routingCallback: (routing) {
    if (routing != null) {
      debugPrint('Route: ${routing.current}');
    }
  },
  home: const Scaffold(body: Text('Configuration')),
);

void localLogWriter(String text, {bool isError = false}) {
  debugPrint('${isError ? "ERROR" : "GETX"}: $text');
}
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

<a id="readme-section-36"></a>

### Local State Widgets

These Widgets allows you to manage a single value, and keep the state ephemeral and locally.
We have flavours for Reactive and Simple.
For instance, you might use them to toggle obscureText in a `TextField`, maybe create a custom
Expandable Panel, or maybe modify the current index in `BottomNavigationBar` while changing the content
of the body in a `Scaffold`.

<a id="readme-section-37"></a>

#### ValueBuilder

A simplification of `StatefulWidget` that works with a `.setState` callback that takes the updated value.

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

<a id="readme-section-38"></a>

#### ObxValue

Similar to [`ValueBuilder`](#valuebuilder), but this is the Reactive version, you pass a Rx instance (remember the magical .obs?) and
updates automatically... isn't it awesome?

```dart
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),
```

<a id="readme-section-39"></a>

## Useful tips

`.obs`ervables (also known as _Rx_ Types) have a wide variety of internal methods and operators.

> Is very common to _believe_ that a property with `.obs` **IS** the actual value... but make no mistake!
> We avoid the Type declaration of the variable, because Dart's compiler is smart enough, and the code
> looks cleaner, but:

```dart
var message = 'Hello world'.obs;
print( 'Message "$message" has Type ${message.runtimeType}');
```

Even if `message` _prints_ the actual String value, the Type is **RxString**!

So, you can't do `message.substring( 0, 4 )`.
You have to access the real `value` inside the _observable_:
The most "used way" is `.value`, but, did you know that you can also use...

```dart
class Person {
  Person({required this.name});
  String name;
}

void reactiveExamples() {
  final name = 'GetX'.obs;
  name.value = 'Hello';
  final enabled = false.obs;
  enabled.toggle();

  final items = RxList<int>()..add(1);
  final counters = RxMap<String, int>()..['visits'] = 1;
  final labels = RxSet<String>()..add('new');
  items.assignAll(items.where((value) => value > 0));

  final person = Person(name: 'Sara').obs;
  person.update((previous) => Person(name: '${previous!.name}!'));

  name.close();
  enabled.close();
  items.close();
  counters.close();
  labels.close();
  person.close();
}
```

<a id="readme-section-40"></a>

## StateMixin

Another way to handle your `UI` state is use the `StateMixin<T>` .
To implement it, use the `with` to add the `StateMixin<T>`
to your controller which allows a T model.

```dart
class Controller extends GetxController with StateMixin<User>{}
```

The `change()` method change the State whenever we want.
Just pass the data and the status in this way:

```dart
change(GetStatus.success(data));
```

GetStatus allow these status:

```dart
GetStatus.loading();
GetStatus.success(data);
GetStatus.empty();
GetStatus.error('message');
```

To represent it in the UI, use:

```dart
class NamesController extends GetxController with StateMixin<List<String>> {
  void showNames(List<String> names) {
    change(GetStatus<List<String>>.success(names));
  }

  void load(Future<List<String>> Function() fetch) => futurize(fetch);
  void showLoading() => setLoading();
  void showEmpty() => setEmpty();
  void showError(Object error) => setError(error);
}

class NamesView extends GetView<NamesController> {
  const NamesView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: controller.obx(
      (names) => Text(names.join(', ')),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data'),
      onError: (error) => Text(error ?? 'Unknown error'),
    ),
  );
}
```

<a id="readme-section-41"></a>

#### GetView

I love this Widget, is so simple, yet, so useful!

Is a `const Stateless` Widget that has a getter `controller` for a registered `Controller`, that's all.

```dart
 class AwesomeController extends GetxController {
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

<a id="readme-section-42"></a>

#### GetResponsiveView

Extend this widget to build responsive view.
this widget contains the `screen` property that have all
information about the screen size and type.

<a id="readme-section-43"></a>

##### How to use it

You have two options to build it.

- with `builder` method you return the widget to build.
- with methods `desktop`, `tablet`,`phone`, `watch`. the specific
  method will be built when the screen type matches the method
  when the screen is [ScreenType.Tablet] the `tablet` method
  will be exuded and so on.
  **Note:** If you use this method please set the property `alwaysUseBuilder` to `false`

With `settings` property you can set the width limit for the screen types.

![example](https://github.com/SchabanBo/get_page_example/blob/master/docs/Example.gif?raw=true)
Code to this screen
[code](https://github.com/SchabanBo/get_page_example/blob/master/lib/pages/responsive_example/responsive_view.dart)

<a id="readme-section-44"></a>

#### GetWidget

GetWidget يخزّن متحكم هذه النسخة من الودجت؛ يدعم const. مع Get.spawn تُنشأ نسخة لكل مالك وتُغلق عند إزالة الودجت؛ GetView ينفذ lookup ولا يخزّن النتيجة بهذه الطريقة.

```dart
class ItemController extends GetxController {
  final label = 'Item'.obs;
}

void registerItemFactory() => Get.spawn<ItemController>(() => ItemController());

class ItemView extends GetWidget<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Text(controller.label.value));
}
```

<a id="readme-section-45"></a>

#### GetxService

GetxService لخدمات عمر التطبيق ويشارك onInit/onReady/onClose. الحذف العادي يحميه؛ يمكن التنظيف المتعمد بـforce أوGet.reset. ليس تخزيناً دائماً بعد موت العملية. انتظر init ثم سجّل القيمة بـGet.put.

```dart
class DbService extends GetxService {
  Future<DbService> init() async => this;
}

class SettingsService extends GetxService {
  Future<SettingsService> init() async => this;
}

Future<void> initServices() async {
  final database = await DbService().init();
  Get.put<DbService>(database, permanent: true);
  final settings = await SettingsService().init();
  Get.put<SettingsService>(settings, permanent: true);
}

Future<void> startApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(home: const Scaffold(body: Text('Ready'))));
}
```

<a id="readme-section-46"></a>

### Tests

You can test your controllers like any other class, including their lifecycles:

```dart
class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Change value to name2
    name.value = 'name2';
  }

  @override
  void onClose() {
    name.value = '';
    super.onClose();
  }

  final name = 'name1'.obs;

  void changeName() => name.value = 'name3';
}

void main() {
  test('''
Test the state of the reactive variable "name" across all of its lifecycles''',
      () {
    /// You can test the controller without the lifecycle,
    /// but it's not recommended unless you're not using
    ///  GetX dependency injection
    final controller = Controller();
    expect(controller.name.value, 'name1');

    /// If you are using it, you can test everything,
    /// including the state of the application after each lifecycle.
    Get.put(controller); // onInit was called
    expect(controller.name.value, 'name2');

    /// Test your functions
    controller.changeName();
    expect(controller.name.value, 'name3');

    /// onClose was called
    Get.delete<Controller>();

    expect(controller.name.value, '');
  });
}
```

<a id="readme-section-47"></a>

#### Tips

<a id="readme-section-48"></a>

##### Mockito or mocktail

If you need to mock your GetxController/GetxService, you should extend GetxController, and mixin it with Mock, that way

```dart
class NotificationServiceMock extends GetxService with Mock implements NotificationService {}
```

<a id="readme-section-49"></a>

##### Using Get.reset()

If you are testing widgets, or test groups, use Get.reset at the end of your test or in tearDown to reset all settings from your previous test.

<a id="readme-section-50"></a>

##### Get.testMode

if you are using your navigation in your controllers, use `Get.testMode = true` at the beginning of your main.

<a id="readme-section-51"></a>

# Breaking changes from 2.0

1- Rx types:

| Before  | After      |
| ------- | ---------- |
| StringX | `RxString` |
| IntX    | `RxInt`    |
| MapX    | `RxMap`    |
| ListX   | `RxList`   |
| NumX    | `RxNum`    |
| DoubleX | `RxDouble` |

RxController and GetBuilder now have merged, you no longer need to memorize which controller you want to use, just use GetxController, it will work for simple state management and for reactive as well.

2- NamedRoutes
Before:

```text
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

Why this change?
Often, it may be necessary to decide which page will be displayed from a parameter, or a login token, the previous approach was inflexible, as it did not allow this.
Inserting the page into a function has significantly reduced the RAM consumption, since the routes will not be allocated in memory since the app was started, and it also allowed to do this type of approach:

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

<a id="readme-section-52"></a>

# Why Getx?

1- Many times after a Flutter update, many of your packages will break. Sometimes compilation errors happen, errors often appear that there are still no answers about, and the developer needs to know where the error came from, track the error, only then try to open an issue in the corresponding repository, and see its problem solved. Get centralizes the main resources for development (State, dependency and route management), allowing you to add a single package to your pubspec, and start working. After a Flutter update, the only thing you need to do is update the Get dependency, and get to work. Get also resolves compatibility issues. How many times a version of a package is not compatible with the version of another, because one uses a dependency in one version, and the other in another version? This is also not a concern using Get, as everything is in the same package and is fully compatible.

2- Flutter is easy, Flutter is incredible, but Flutter still has some boilerplate that may be unwanted for most developers, such as `Navigator.of(context).push (context, builder [...]`. Get simplifies development. Instead of writing 8 lines of code to just call a route, you can just do it: `Get.to(() => Home())` and you're done, you'll go to the next page. Dynamic web urls are a really painful thing to do with Flutter currently, and that with GetX is stupidly simple. Managing states in Flutter, and managing dependencies is also something that generates a lot of discussion, as there are hundreds of patterns in the pub. But there is nothing as easy as adding a ".obs" at the end of your variable, and place your widget inside an Obx, and that's it, all updates to that variable will be automatically updated on the screen.

3- Ease without worrying about performance. Flutter's performance is already amazing, but imagine that you use a state manager, and a locator to distribute your blocs/stores/controllers/ etc. classes. You will have to manually call the exclusion of that dependency when you don't need it. But have you ever thought of simply using your controller, and when it was no longer being used by anyone, it would simply be deleted from memory? That's what GetX does. With SmartManagement, everything that is not being used is deleted from memory, and you shouldn't have to worry about anything but programming. You will be assured that you are consuming the minimum necessary resources, without even having created a logic for this.

4- Actual decoupling. You may have heard the concept "separate the view from the business logic". This is not a peculiarity of BLoC, MVC, MVVM, and any other standard on the market has this concept. However, this concept can often be mitigated in Flutter due to the use of context.
If you need context to find an InheritedWidget, you need it in the view, or pass the context by parameter. I particularly find this solution very ugly, and to work in teams we will always have a dependence on View's business logic. Getx is unorthodox with the standard approach, and while it does not completely ban the use of StatefulWidgets, InitState, etc., it always has a similar approach that can be cleaner. Controllers have life cycles, and when you need to make an APIREST request for example, you don't depend on anything in the view. You can use onInit to initiate the http call, and when the data arrives, the variables will be populated. As GetX is fully reactive (really, and works under streams), once the items are filled, all widgets that use that variable will be automatically updated in the view. This allows people with UI expertise to work only with widgets, and not have to send anything to business logic other than user events (like clicking a button), while people working with business logic will be free to create and test the business logic separately.

This library will always be updated and implementing new features. Feel free to offer PRs and contribute to them.

<a id="readme-section-53"></a>

# Community

<a id="readme-section-54"></a>

## Community channels

GetX has a highly active and helpful community. If you have questions, or would like any assistance regarding the use of this framework, please join our community channels, your question will be answered more quickly, and it will be the most suitable place. This repository is exclusive for opening issues, and requesting resources, but feel free to be part of GetX Community.

| **Slack**                                                                                                                   | **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Get on Slack](https://img.shields.io/badge/slack-join-orange.svg)](https://communityinviter.com/apps/getxworkspace/getx) | [![Discord Shield](https://img.shields.io/discord/722900883784073290.svg?logo=discord)](https://discord.com/invite/9Hpt99N) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/joinchat/PhdbJRmsZNpAqSLJL6bH7g) |

<a id="readme-section-55"></a>

## How to contribute

_Want to contribute to the project? We will be proud to highlight you as one of our collaborators. Here are some points where you can contribute and make Get (and Flutter) even better._

- Helping to translate the readme into other languages.
- Adding documentation to the readme (a lot of Get's functions haven't been documented yet).
- Write articles or make videos teaching how to use Get (they will be inserted in the Readme and in the future in our Wiki).
- Offering PRs for code/tests.
- Including new functions.

Any contribution is welcome!

<a id="readme-section-56"></a>

## Articles and videos

- [Flutter Getx EcoSystem package for arabic people](https://www.youtube.com/playlist?list=PLV1fXIAyjeuZ6M8m56zajMUwu4uE3-SL0) - Tutorial by [Pesa Coder](https://github.com/UsamaElgendy).
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
- [A minimal example on dartpad](https://dartpad.dev/2b3d0d6f9d4e312c5fdbefc414c1727e?) - by [Roi Peker](https://github.com/roipeker)

</div>

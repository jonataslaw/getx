
---

# إدارة التبعيات

* [إدارة التبعيات](#dependency-management)

  * [طرق إنشاء الكائنات](#instancing-methods)

    * [Get.put()](#getput)
    * [Get.lazyPut](#getlazyput)
    * [Get.putAsync](#getputasync)
    * [Get.create](#getcreate)
  * [استخدام الكائنات المنشأة](#using-instantiated-methodsclasses)
  * [تحديد نسخة بديلة](#specifying-an-alternate-instance)
  * [الاختلافات بين الطرق](#differences-between-methods)
  * [Bindings](#bindings)

    * [فئة Bindings](#bindings-class)
    * [BindingsBuilder](#bindingsbuilder)
    * [SmartManagement](#smartmanagement)

      * [كيفية التغيير](#how-to-change)
      * [SmartManagement.full](#smartmanagementfull)
      * [SmartManagement.onlyBuilders](#smartmanagementonlybuilders)
      * [SmartManagement.keepFactory](#smartmanagementkeepfactory)
    * [كيف تعمل Bindings تحت الغطاء](#how-bindings-work-under-the-hood)
  * [ملاحظات](#notes)

Get توفر مدير تبعيات بسيط وقوي يسمح لك باستدعاء نفس الكلاس مثل الـ Bloc أو Controller بخط واحد فقط، بدون الحاجة لاستخدام Provider context أو inheritedWidget:

```dart
Controller controller = Get.put(Controller()); // بدلاً من Controller controller = Controller();
```

بدلاً من إنشاء الكلاس داخل الكلاس نفسه، يتم إنشاؤه ضمن Get instance، ليكون متاحًا في جميع أنحاء التطبيق. يمكنك استخدام الـ Controller أو Bloc class بشكل طبيعي.

* ملاحظة: إذا كنت تستخدم مدير الحالة الخاص بـ Get، راقب الـ [Bindings](#bindings) لأنه يسهل ربط العرض بالـ Controller.
* ملاحظة²: إدارة التبعيات في Get منفصلة عن باقي الحزمة، لذا إذا كان تطبيقك يستخدم بالفعل مدير حالة آخر، لا تحتاج لتغييره، يمكنك استخدام هذا المدير بدون مشاكل.

---

## طرق إنشاء الكائنات

الطرق والمعاملات القابلة للإعداد:

### Get.put()

الطريقة الأكثر شيوعًا لإدخال التبعيات. جيدة للـ Controllers على سبيل المثال.

```dart
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
```

خيارات Get.put() بالكامل:

```dart
Get.put<S>(
  S dependency, // الكلاس المطلوب تخزينه، مثل Controller
  String tag,   // اختياري: لتحديد نسخة مميزة من نفس النوع
  bool permanent = false, // اختياري: للحفاظ على الكائن طوال عمر التطبيق
  bool overrideAbstract = false, // اختياري: لتغيير الكلاس المجرد في الاختبارات
  InstanceBuilderCallback<S> builder, // اختياري: لإنشاء التبعيات بواسطة دالة
)
```

---

### Get.lazyPut

يمكنك إنشاء الكائن عند الحاجة فقط. مفيد للكلاسات المكلفة أو إذا أردت إعداد عدة كائنات في Bindings دون استخدامها فورًا.

```dart
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<FirebaseAuth>(
  () {
    return FirebaseAuth();
  },
  tag: Math.random().toString(),
  fenix: true
);

Get.lazyPut<Controller>(() => Controller());
```

خيارات Get.lazyPut():

```dart
Get.lazyPut<S>(
  InstanceBuilderCallback builder, // دالة إنشاء عند أول استخدام
  String tag, // اختياري: لتحديد نسخة مميزة
  bool fenix = false // اختياري: إعادة إنشاء الكائن عند الحاجة
)
```

---

### Get.putAsync

لإنشاء كائنات غير متزامنة:

```dart
Get.putAsync<SharedPreferences>(() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('counter', 12345);
  return prefs;
});

Get.putAsync<YourAsyncClass>(() async => await YourAsyncClass());
```

خيارات Get.putAsync():

```dart
Get.putAsync<S>(
  AsyncInstanceBuilderCallback<S> builder, // دالة async لإنشاء الكائن
  String tag, // اختياري: لتحديد نسخة مميزة
  bool permanent = false // اختياري: للحفاظ على الكائن طوال التطبيق
)
```

---

### Get.create

يُنشئ نسخة جديدة في كل مرة يتم استدعاؤها:

```dart
Get.create<SomeClass>(() => SomeClass());
Get.create<LoginController>(() => LoginController());
```

خيارات Get.create():

```dart
Get.create<S>(
  FcBuilderFunc<S> builder, // دالة لإنشاء نسخة جديدة
  String name,               // اختياري: لتحديد نسخة مميزة
  bool permanent = true      // اختياري: الحفاظ على الكائن طوال التطبيق، افتراضيًا true
)
```

---

## استخدام الكائنات المنشأة

يمكنك استرجاع الكائنات باستخدام:

```dart
final controller = Get.find<Controller>();
// أو
Controller controller = Get.find();
```

يمكنك بعد ذلك الوصول للبيانات بسهولة:

```dart
Text(controller.textFromApi);
int count = Get.find<SharedPreferences>().getInt('counter');
print(count); // 12345
```

لحذف كائن:

```dart
Get.delete<Controller>(); // عادة لا تحتاج لذلك، GetX يحذف الكائنات غير المستخدمة تلقائيًا
```

---

## تحديد نسخة بديلة

يمكن استبدال نسخة موجودة:

```dart
abstract class BaseClass {}
class ParentClass extends BaseClass {}
class ChildClass extends ParentClass {
  bool isChild = true;
}

Get.put<BaseClass>(ParentClass());
Get.replace<BaseClass>(ChildClass());
final instance = Get.find<BaseClass>();
print(instance is ChildClass); // true
```

---

## الاختلافات بين الطرق

* `permanent`: الكائن يبقى طوال التطبيق.

* `fenix`: الكائن يُحذف عند عدم الاستخدام، لكنه يُعاد إنشاؤه عند الحاجة.

* `Get.put` و `Get.putAsync`: يتم إنشاء الكائن مباشرة.

* `Get.create`: يُنشئ نسخة جديدة عند كل استدعاء.

* `Get.lazyPut`: يُنشئ الكائن عند الحاجة فقط، مع إمكانية إعادة إنشائه باستخدام `fenix`.

---

## Bindings

ربط المسارات مع الحالة والتبعيات. عند إزالة الشاشة، تُحذف كل الكائنات المرتبطة بها تلقائيًا.

### فئة Bindings

```dart
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<Service>(() => Api());
  }
}
```

استخدامه في المسارات:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: HomeBinding(),
  ),
];
```

أو عند التنقل العادي:

```dart
Get.to(Home(), binding: HomeBinding());
```

يمكن تعيين `initialBinding` في GetMaterialApp لإنشاء تبعيات عند بدء التطبيق:

```dart
GetMaterialApp(
  initialBinding: SampleBind(),
  home: Home(),
);
```

---

### BindingsBuilder

بديل لإنشاء Binding بدون فصل جديد:

```dart
getPages: [
  GetPage(
    name: '/',
    page: () => HomeView(),
    binding: BindingsBuilder(() {
      Get.lazyPut<ControllerX>(() => ControllerX());
      Get.put<Service>(() => Api());
    }),
  ),
];
```

---

### SmartManagement

التحكم في التخلص من الكائنات غير المستخدمة:

```dart
GetMaterialApp(
  smartManagement: SmartManagement.onlyBuilders,
  home: Home(),
)
```

خيارات:

* `full`: الافتراضي، يحذف الكائنات غير المستخدمة.
* `onlyBuilders`: يحذف الكائنات التي تم إنشاؤها في Bindings أو lazyPut فقط.
* `keepFactory`: يحذف الكائنات غير المستخدمة، لكن يحتفظ بالدالة المنشئة لإعادة الإنشاء عند الحاجة.

---

### كيف تعمل Bindings تحت الغطاء

Bindings تنشئ "مصانع مؤقتة" تنشأ عند الانتقال للشاشة وتُحذف عند الخروج بسرعة عالية جدًا لتقليل استهلاك الذاكرة.

---

## ملاحظات

* لا تستخدم `keepFactory` مع Bindings متعددة، صُمم للاستخدام بدون Bindings أو مع Binding واحد.
* استخدام Bindings اختياري، لكن يُنصح به لتنظيم أفضل عند التعامل مع Services أو أي تجريد.

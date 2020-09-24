import 'get_instance.dart';

/// [Bindings] should be extended or implemented.
/// When using [GetMaterialApp], all [GetPage]s and navigation
/// methods (like Get.to()) have a [binding] property that takes an
/// instance of Bindings to manage the
/// dependencies() (via [Get.put()]) for the Route you are opening.
// ignore: one_member_abstracts
abstract class Bindings {
  void dependencies();
}

/// Simplifies Bindings generation from a single callback.
/// To avoid the creation of a custom Binding instance per route.
///
/// Example:
/// ```
/// GetPage(
///   name: '/',
///   page: () => Home(),
///   // This might cause you an error.
///   // binding: BindingsBuilder(() => Get.put(HomeController())),
///   binding: BindingsBuilder(() { Get.put(HomeController(); })),
///   // Using .lazyPut() works fine.
///   // binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
/// ),
/// ```
class BindingsBuilder<T> extends Bindings {
  /// Register your dependencies in the [builder] callback.
  final VoidCallback builder;

  /// Shortcut to register 1 Controller with Get.put(),
  /// Prevents the issue of the fat arrow function with the constructor.
  /// BindingsBuilder(() => Get.put(HomeController())),
  ///
  /// Sample:
  /// ```
  /// GetPage(
  ///   name: '/',
  ///   page: () => Home(),
  ///   binding: BindingsBuilder.put(() => HomeController()),
  /// ),
  /// ```
  factory BindingsBuilder.put(InstanceBuilderCallback<T> builder,
      {String tag, bool permanent = false}) {
    return BindingsBuilder(() => GetInstance()
        .put<T>(null, tag: tag, permanent: permanent, builder: builder));
  }

  /// WARNING: don't use `()=> Get.put(Controller())`,
  /// if only passing 1 callback use `BindingsBuilder.put(Controller())`
  /// or `BindingsBuilder(()=> Get.lazyPut(Controller()))`
  BindingsBuilder(this.builder);

  @override
  void dependencies() {
    builder();
  }
}

// abstract class INavigation {}
// typedef Snack = Function();
// typedef Modal = Function();
// typedef Route = Function();
typedef VoidCallback = void Function();

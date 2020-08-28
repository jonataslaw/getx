/// [Bindings] should be extended or implemented.
/// When using [GetMaterialApp], all [GetPage]s and navigation methods (like Get.to())
/// have a [binding] property that takes an instance of Bindings to manage the
/// dependencies() (via [Get.put()]) for the Route you are opening.
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
///   binding: BindingsBuilder(() => Get.put(HomeController())),
/// ),
/// ````
class BindingsBuilder extends Bindings {
  /// Register your dependencies in the [builder] callback.
  final Function() builder;

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

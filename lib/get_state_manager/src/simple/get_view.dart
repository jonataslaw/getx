import 'package:flutter/widgets.dart';
import '../../../get_instance/src/get_instance.dart';
import '../../../instance_manager.dart';
import 'get_widget_cache.dart';

/// GetView is a great way of quickly access your Controller
/// without having to call Get.find<AwesomeController>() yourself.
///
/// Sample:
/// ```
/// class AwesomeController extends GetxController {
///   final String title = 'My Awesome View';
/// }
///
/// class AwesomeView extends GetView<AwesomeController> {
///   /// if you need you can pass the tag for
///   /// Get.find<AwesomeController>(tag:"myTag");
///   @override
///   final String tag = "myTag";
///
///   AwesomeView({Key key}):super(key:key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: EdgeInsets.all(20),
///       child: Text( controller.title ),
///     );
///   }
/// }
///``
abstract class GetView<T> extends StatelessWidget {
  const GetView({Key key}) : super(key: key);

  final String tag = null;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context);
}

// abstract class GetView<A, B> extends StatelessWidget {
//   const GetView({Key key}) : super(key: key);
//   A get controller => GetInstance().find();
//   B get controller2 => GetInstance().find();

//   @override
//   Widget build(BuildContext context);
// }

// abstract class GetView2<A, B, C> extends StatelessWidget {
//   const GetView2({Key key}) : super(key: key);
//   A get controller => GetInstance().find();
//   B get controller2 => GetInstance().find();
//  C get controller3 => GetInstance().find();

//   @override
//   Widget build(BuildContext context);
// }

/// GetWidget is a great way of quickly access your individual Controller
/// without having to call Get.find<AwesomeController>() yourself.
/// Get save you controller on cache, so, you can to use Get.create() safely
/// GetWidget is perfect to multiples instance of a same controller. Each
/// GetWidget will have your own controller, and will be call events as [onInit]
/// and [onClose] when the controller get in/get out on memory.
abstract class GetWidget<S extends GetLifeCycleBase> extends GetWidgetCache {
  const GetWidget({Key key}) : super(key: key);

  @protected
  final String tag = null;

  S get controller => GetWidget._cache[this] as S;

  static final _cache = <GetWidget, GetLifeCycleBase>{};

  @protected
  Widget build(BuildContext context);

  @override
  WidgetCache createWidgetCache() => _GetCache<S>();
}

class _GetCache<S extends GetLifeCycleBase> extends WidgetCache<GetWidget<S>> {
  S _controller;
  @override
  void onInit() {
    _controller = Get.find<S>(tag: widget.tag);
    GetWidget._cache[widget] = _controller;
    super.onInit();
  }

  @override
  void onClose() {
    GetWidget._cache.remove(widget);
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}

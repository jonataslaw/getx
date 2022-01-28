import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import '../../../utils.dart';
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
  const GetView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}

/// GetWidget is a great way of quickly access your individual Controller
/// without having to call Get.find<AwesomeController>() yourself.
/// Get save you controller on cache, so, you can to use Get.create() safely
/// GetWidget is perfect to multiples instance of a same controller. Each
/// GetWidget will have your own controller, and will be call events as `onInit`
/// and `onClose` when the controller get in/get out on memory.
abstract class GetWidget<S extends GetLifeCycleMixin> extends GetWidgetCache {
  const GetWidget({Key? key}) : super(key: key);

  @protected
  final String? tag = null;

  S get controller => GetWidget._cache[this] as S;

  // static final _cache = <GetWidget, GetLifeCycleBase>{};

  static final _cache = Expando<GetLifeCycleMixin>();

  @protected
  Widget build(BuildContext context);

  @override
  WidgetCache createWidgetCache() => _GetCache<S>();
}

class _GetCache<S extends GetLifeCycleMixin> extends WidgetCache<GetWidget<S>> {
  S? _controller;
  bool _isCreator = false;
  InstanceInfo? info;
  @override
  void onInit() {
    info = GetInstance().getInstanceInfo<S>(tag: widget!.tag);

    _isCreator = info!.isPrepared && info!.isCreate;

    if (info!.isRegistered) {
      _controller = Get.find<S>(tag: widget!.tag);
    }

    GetWidget._cache[widget!] = _controller;
    super.onInit();
  }

  @override
  void onClose() {
    if (_isCreator) {
      Get.asap(() {
        widget!.controller.onDelete();
        Get.log('"${widget!.controller.runtimeType}" onClose() called');
        Get.log('"${widget!.controller.runtimeType}" deleted from memory');
        GetWidget._cache[widget!] = null;
      });
    }
    info = null;
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return widget!.build(context);
  }
}


/// GetSelfManagedView is used for rare cases where you would want to
/// instanciate a controller everytime a widget is added to the widget tree
/// and remove the controller when the widget is removed from the widget tree
/// 
/// it was used in cases where a bottom navigation is needed every page of 
/// the bottom navigation can now be have their own instanciated and 
/// destroyed controller as they are swiched between them
abstract class GetSelfManagedView<T> extends StatefulWidget {
  /// controller builder
  /// ``
  ///      ExtendedGetSelfManagedView({Key: key}) : 
  ///         super(key: this.key, controller: () => SampleGetXController());
  /// ``
  final T Function() controller;
  const GetSelfManagedView({Key? key, required this.controller})
      : super(key: key);
}

abstract class GetSelfManagedViewState<
    StFulWidget extends GetSelfManagedView<T>, T> extends State<StFulWidget> {
  T get controller => Get.find<T>();

  @override
  void initState() {
    Get.put<T>(widget.controller());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<T>();
    super.dispose();
  }
}

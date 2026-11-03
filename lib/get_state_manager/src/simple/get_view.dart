import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import '../../../utils.dart';
import 'get_state.dart';
import 'get_widget_cache.dart';

/// A stateless view that resolves its controller through [Get.find].
///
/// Sample:
/// ```dart
/// class AwesomeController {
///   final String title = 'My Awesome View';
/// }
///
/// class AwesomeView extends GetView<AwesomeController> {
///   @override
///   final String tag = 'myTag';
///
///   const AwesomeView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: const EdgeInsets.all(20),
///       child: Text(controller.title),
///     );
///   }
/// }
/// ```
abstract class GetView<T> extends StatelessWidget {
  const GetView({super.key});

  final String? tag = null;

  T get controller => Get.find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}

/// A view that caches the controller resolved for this widget instance.
///
/// With a factory registered by `Get.spawn`, each widget caches its own
/// controller and closes that controller when removed. Unlike [GetView],
/// repeated controller reads do not perform another lookup.
abstract class GetWidget<S extends GetLifeCycleMixin> extends GetWidgetCache {
  const GetWidget({super.key});

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
    info = Get.getInstanceInfo<S>(tag: widget!.tag);

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
        // GetWidget._cache[widget!] = null;
      });
    }
    info = null;
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Binder(
      init: () => _controller,
      child: widget!.build(context),
    );
  }
}

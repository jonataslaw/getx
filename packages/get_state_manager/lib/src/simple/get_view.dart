import 'package:flutter/widgets.dart';
import 'package:get_instance/get_instance.dart';

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

abstract class GetWidget<T extends GetLifeCycle> extends GetStatelessWidget {
  GetWidget({Key key}) : super(key: key);

  final Set<T> _value = <T>{};

  final String tag = null;

  T get controller {
    if (_value.isEmpty) _value.add(GetInstance().find<T>(tag: tag));
    return _value.first;
  }

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

class GetStatelessElement extends ComponentElement {
  GetStatelessElement(GetStatelessWidget widget) : super(widget);

  @override
  GetStatelessWidget get widget => super.widget as GetStatelessWidget;

  @override
  Widget build() => widget.build(this);

  @override
  void update(GetStatelessWidget newWidget) {
    super.update(newWidget);
    markNeedsBuild();
    rebuild();
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    widget.controller?.onStart();
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    widget.controller?.onClose();
    super.unmount();
  }
}

abstract class GetStatelessWidget<T extends GetLifeCycle> extends Widget {
  const GetStatelessWidget({Key key}) : super(key: key);
  @override
  GetStatelessElement createElement() => GetStatelessElement(this);
  @protected
  Widget build(BuildContext context);

  T get controller;
}

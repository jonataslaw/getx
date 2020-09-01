import 'package:flutter/widgets.dart';
import 'package:get/src/instance/get_instance.dart';

/// GetView is a great way of quickly access your Controller
/// without having call Get.find<Controller>() yourself.
abstract class GetView<T> extends StatelessWidget {
  const GetView({Key key}) : super(key: key);
  T get controller => GetInstance().find<T>();

  @override
  Widget build(BuildContext context);
}

abstract class GetWidget<T> extends StatelessWidget {
  GetWidget({Key key}) : super(key: key);

  final Set<T> _value = Set<T>();

  T get controller {
    if (_value.isEmpty) _value.add(GetInstance().find<T>());
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

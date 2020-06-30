import 'package:flutter/widgets.dart';
import 'package:get/src/instance/get_instance.dart';

abstract class GetWidget<T> extends StatelessWidget {
  const GetWidget({Key key}) : super(key: key);
  T get controller => GetInstance().find();

  @override
  Widget build(BuildContext context);
}

abstract class GetView<T> extends StatelessWidget {
  const GetView({Key key}) : super(key: key);
  T get controller => GetInstance().find();

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

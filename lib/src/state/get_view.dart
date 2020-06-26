import 'package:flutter/widgets.dart';
import 'package:get/src/get_instance.dart';

abstract class GetView<T> extends StatelessWidget {
  const GetView({Key key}) : super(key: key);
  T get controller => GetInstance().find();

  @override
  Widget build(BuildContext context);
}

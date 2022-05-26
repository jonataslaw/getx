import 'package:flutter/material.dart';

import '../rx_flutter/rx_obx_widget.dart';
import 'get_controllers.dart';
import 'get_state.dart';

class MixinBuilder<T extends GetxController> extends StatelessWidget {
  @required
  final Widget Function(T) builder;
  final bool global;
  final String? id;
  final bool autoRemove;
  final void Function(BindElement<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(Binder<T> oldWidget, BindElement<T> state)?
      didUpdateWidget;
  final T? init;

  const MixinBuilder({
    Key? key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.initState,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        init: init,
        global: global,
        autoRemove: autoRemove,
        initState: initState,
        dispose: dispose,
        id: id,
        didChangeDependencies: didChangeDependencies,
        didUpdateWidget: didUpdateWidget,
        builder: (controller) => Obx(() => builder.call(controller)));
  }
}

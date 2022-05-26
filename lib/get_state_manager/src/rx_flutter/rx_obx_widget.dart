import 'package:flutter/widgets.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../simple/simple_builder.dart';

typedef WidgetCallback = Widget Function();

/// The [ObxWidget] is the base for all GetX reactive widgets
///
/// See also:
/// - [Obx]
/// - [ObxValue]
abstract class ObxWidget extends ObxStatelessWidget {
  const ObxWidget({Key? key}) : super(key: key);
}

/// The simplest reactive widget in GetX.
///
/// Just pass your Rx variable in the root scope of the callback to have it
/// automatically registered for changes.
///
/// final _name = "GetX".obs;
/// Obx(() => Text( _name.value )),... ;
class Obx extends ObxWidget {
  final WidgetCallback builder;

  const Obx(this.builder);

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}

/// Similar to Obx, but manages a local state.
/// Pass the initial data in constructor.
/// Useful for simple local states, like toggles, visibility, themes,
/// button states, etc.
///  Sample:
///    ObxValue((data) => Switch(
///      value: data.value,
///      onChanged: (flag) => data.value = flag,
///    ),
///    false.obs,
///   ),
class ObxValue<T extends RxInterface> extends ObxWidget {
  final Widget Function(T) builder;
  final T data;

  const ObxValue(this.builder, this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => builder(data);
}

import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../../get_rx/src/rx_types/rx_types.dart';

typedef WidgetCallback = Widget Function();

/// The [ObxWidget] is the base for all GetX reactive widgets
///
/// See also:
/// - [Obx]
/// - [ObxValue]
abstract class ObxWidget extends StatefulWidget {
  const ObxWidget({Key key}) : super(key: key);

  @override
  _ObxState createState() => _ObxState();

  @protected
  Widget build();
}

class _ObxState extends State<ObxWidget> {
  RxInterface _observer;
  StreamSubscription subs;

  _ObxState() {
    _observer = RxNotifier();
  }

  @override
  void initState() {
    subs = _observer.listen((data) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    subs.cancel();
    _observer.close();
    super.dispose();
  }

  Widget get notifyChilds {
    final observer = RxInterface.proxy;
    RxInterface.proxy = _observer;
    final result = widget.build();
    if (!_observer.canUpdate) {
      throw """
      [Get] the improper use of a GetX has been detected. 
      You should only use GetX or Obx for the specific widget that will be updated.
      If you are seeing this error, you probably did not insert any observable variables into GetX/Obx 
      or insert them outside the scope that GetX considers suitable for an update 
      (example: GetX => HeavyWidget => variableObservable).
      If you need to update a parent widget and a child widget, wrap each one in an Obx/GetX.
      """;
    }
    RxInterface.proxy = observer;
    return result;
  }

  @override
  Widget build(BuildContext context) => notifyChilds;
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
  Widget build() => builder();
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

  const ObxValue(this.builder, this.data, {Key key}) : super(key: key);

  @override
  Widget build() => builder(data);
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
class RxValue<T> extends ObxWidget {
  final Widget Function(T data) builder;
  final Rx<T> data = Rx<T>();

  RxValue(this.builder, {Key key}) : super(key: key);

  @override
  Widget build() => builder(data.value);
}

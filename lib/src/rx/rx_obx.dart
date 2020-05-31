import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/src/rx/rx_interface.dart';
import '../get_main.dart';
import 'rx_impl.dart';

Widget obx(Widget Function() builder) {
  final b = builder;
  return Obx(b);
}

class Obx extends StatefulWidget {
  final Widget Function() builder;

  const Obx(
    this.builder,
  );
  _ObxState createState() => _ObxState();
}

class _ObxState extends State<Obx> {
  RxInterface _observer;
  StreamSubscription _listenSubscription;
  bool isCreator = false;

  _ObxState() {
    _observer = ListX();
  }

  @override
  void initState() {
    _listenSubscription = _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _observer.close();
    _listenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final observer = Get.obs;
    Get.obs = this._observer;
    final result = widget.builder();
    Get.obs = observer;
    return result;
  }
}

import 'package:flutter/widgets.dart';
import 'package:get/src/rx/rx_interface.dart';
import '../get_main.dart';
import 'rx_impl.dart';

Widget obx(Widget Function() builder) {
  final b = builder;
  return Obxx(b);
}

/// it's very very very very experimental, or now, it's just tests.
class Obxx extends StatelessWidget {
  final Widget Function() builder;
  Obxx(this.builder, {Key key}) : super(key: key);
  final RxInterface _observer = Rx();

  @override
  Widget build(_) {
    _observer.subject.stream.listen((data) => (_ as Element)..markNeedsBuild());
    final observer = Get.obs;
    Get.obs = _observer;
    final result = builder();
    Get.obs = observer;
    return result;
  }
}

class Obx extends StatefulWidget {
  final Widget Function() builder;

  const Obx(this.builder);
  _ObxState createState() => _ObxState();
}

class _ObxState extends State<Obx> {
  RxInterface _observer;

  _ObxState() {
    _observer = Rx();
  }

  @override
  void initState() {
    _observer.subject.stream.listen((data) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _observer.close();
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

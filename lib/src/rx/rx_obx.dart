import 'package:flutter/widgets.dart';
import 'package:get/src/rx/rx_interface.dart';
import 'rx_impl.dart';

Widget obx(Widget Function() builder) {
  final b = builder;
  return Obxx(b);
}

/// it's very very very very experimental
class Obxx extends StatelessWidget {
  final Widget Function() builder;
  Obxx(this.builder, {Key key}) : super(key: key);
  final RxInterface _observer = Rx();

  @override
  Widget build(_) {
    _observer.subject.stream.listen((data) => (_ as Element)..markNeedsBuild());
    final observer = getObs;
    getObs = _observer;
    final result = builder();
    getObs = observer;
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
    _observer.subject.stream.listen((data) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _observer.close();
    super.dispose();
  }

  Widget get notifyChilds {
    final observer = getObs;
    getObs = _observer;
    final result = widget.builder();
    getObs = observer;
    return result;
  }

  @override
  Widget build(BuildContext context) => notifyChilds;
}

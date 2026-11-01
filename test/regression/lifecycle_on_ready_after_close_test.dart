import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Ctl extends GetxController {
  _Ctl(this.log);
  final List<String> log;

  @override
  void onReady() {
    super.onReady();
    log.add('onReady');
  }

  @override
  void onClose() {
    log.add('onClose');
    super.onClose();
  }
}

void main() {
  testWidgets('onReady() does not run on a controller closed before the frame',
      (tester) async {
    Get.testMode = true;

    // Control: a controller that is NOT closed must still get onReady(),
    // otherwise this harness would prove nothing.
    final alive = <String>[];
    _Ctl(alive).onStart();
    await tester.pumpWidget(const SizedBox());
    expect(alive, ['onReady'], reason: 'the harness does reach onReady');

    // Created, then destroyed before the next frame.
    final short = <String>[];
    final controller = _Ctl(short)..onStart();
    controller.onDelete();
    await tester.pumpWidget(const SizedBox(key: ValueKey('next')));

    expect(
      short,
      ['onClose'],
      reason: 'onReady must not run after onClose. '
          'MUTATION: drop the `if (!_isClosed)` guard in '
          'GetLifeCycleMixin.onInit and this expects [onClose, onReady].',
    );
  });
}

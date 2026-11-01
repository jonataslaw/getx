import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('an Rx keeps delivering to ever() after its last worker is disposed',
      () async {
    // Typical shape: a long-lived Rx; a route-scoped controller subscribes
    // with ever() and disposes the worker in onClose(); the route is closed
    // and opened again.
    final serviceRx = RxString('');

    final firstVisit = <String>[];
    final worker = ever<String>(serviceRx, firstVisit.add);
    serviceRx.value = 'a';
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(firstVisit, ['a']);

    worker.dispose(); // onClose() of the first controller

    final secondVisit = <String>[];
    ever<String>(serviceRx, secondVisit.add); // fresh controller, same Rx
    serviceRx.value = 'b';
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(
      secondVisit,
      ['b'],
      reason: 'MUTATION: restore `onCancel: addListener(_streamListener)` in '
          'GetListenable.subject and this is [] -- the Rx goes permanently '
          'deaf once its last stream subscriber cancels.',
    );
  });

  test('the bridge survives several detach/reattach cycles', () async {
    final rx = RxInt(0);
    for (var round = 1; round <= 3; round++) {
      final seen = <int>[];
      final w = ever<int>(rx, seen.add);
      rx.value = round;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(seen, [round], reason: 'round $round');
      w.dispose();
    }
  });

  test('an Obx-style listener does not mask the defect', () async {
    // Obx subscribes through ListNotifier.addListener, not through the
    // stream. It kept rebuilding while ever() had gone silent, which is why
    // the defect was invisible on screen.
    final rx = RxString('');
    var notifierRebuilds = 0;
    rx.addListener(() => notifierRebuilds++);

    ever<String>(rx, (_) {}).dispose();

    final seen = <String>[];
    ever<String>(rx, seen.add);
    rx.value = 'x';
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(notifierRebuilds, greaterThan(0));
    expect(seen, ['x']);
  });

  test('close() tears the bridge down', () async {
    final rx = RxString('');
    final seen = <String>[];
    ever<String>(rx, seen.add);

    rx.value = 'before close';
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(seen, ['before close']);

    rx.close();
    // Upstream does not make the Rx throw on write after close, and this
    // patch does not change that: the assertion is only that nothing is
    // delivered any more once the bridge is torn down.
    //
    // Calling close() TWICE does throw ('used after being disposed'),
    // upstream and here alike -- `removeListener` asserts. Left as is: it is
    // a distinct defect, out of scope here.
    rx.value = 'after close';
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(seen, ['before close'], reason: 'no delivery after close()');
  });
}

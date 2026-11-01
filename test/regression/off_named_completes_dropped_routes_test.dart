import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// `offAllNamed` and `offNamedUntil` drop the pages above their target.
/// Those pages may have been pushed by an awaited `Get.toNamed(...)` -- the
/// "screen returns a value to its caller" idiom. Dropping them with a bare
/// `removeLast()` leaves the caller's future pending for the lifetime of
/// the process.
void main() {
  Widget app() => GetMaterialApp(
        initialRoute: '/first',
        getPages: [
          GetPage(name: '/first', page: () => const Scaffold(key: Key('1'))),
          GetPage(name: '/second', page: () => const Scaffold(key: Key('2'))),
          GetPage(name: '/third', page: () => const Scaffold(key: Key('3'))),
        ],
      );

  testWidgets('offAllNamed completes the futures of the pages it drops',
      (tester) async {
    await tester.pumpWidget(app());

    var settled = false;
    Get.toNamed<void>('/second')?.then((_) => settled = true);
    await tester.pumpAndSettle();
    expect(settled, isFalse, reason: 'still on screen, nothing to settle yet');

    Get.offAllNamed<void>('/third');
    await tester.pumpAndSettle();

    expect(
      settled,
      isTrue,
      reason: 'MUTATION: use `_activePages.removeLast()` instead of '
          '`_popWithResult()` in offAllNamed and this stays false forever.',
    );
  });

  testWidgets('offNamedUntil completes the futures of the pages it drops',
      (tester) async {
    await tester.pumpWidget(app());

    var settled = false;
    Get.toNamed<void>('/second')?.then((_) => settled = true);
    await tester.pumpAndSettle();

    Get.offNamedUntil<void>('/third', (_) => false);
    await tester.pumpAndSettle();

    expect(settled, isTrue);
  });

  testWidgets('an ordinary back still completes with its result',
      (tester) async {
    await tester.pumpWidget(app());

    String? result;
    Get.toNamed<String>('/second')?.then((v) => result = v);
    await tester.pumpAndSettle();

    Get.back<String>(result: 'picked');
    await tester.pumpAndSettle();

    expect(result, 'picked', reason: 'the normal path is unchanged');
  });
}

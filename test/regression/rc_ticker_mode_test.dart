import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _SingleTickerController extends GetxController
    with GetSingleTickerProviderStateMixin {}

class _MultipleTickerController extends GetxController
    with GetTickerProviderStateMixin {}

void main() {
  for (final single in [true, false]) {
    testWidgets('Get ticker honors enabled and forced frames ($single)',
        (tester) async {
      final controller =
          single ? _SingleTickerController() : _MultipleTickerController();
      final ticker = single
          ? (controller as _SingleTickerController).createTicker((_) {})
          : (controller as _MultipleTickerController).createTicker((_) {});
      for (final mode in [
        const TickerModeData(enabled: true, forceFrames: true),
        const TickerModeData(enabled: false, forceFrames: false),
        const TickerModeData(enabled: true, forceFrames: false),
      ]) {
        await tester.pumpWidget(TickerMode(
          enabled: mode.enabled,
          forceFrames: mode.forceFrames,
          child: Builder(builder: (context) {
            if (single) {
              (controller as _SingleTickerController)
                  .didChangeDependencies(context);
            } else {
              (controller as _MultipleTickerController)
                  .didChangeDependencies(context);
            }
            return const SizedBox.shrink();
          }),
        ));
        expect(ticker.muted, !mode.enabled);
        expect(ticker.forceFrames, mode.forceFrames);
      }
      ticker.dispose();
      controller.onDelete();
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}

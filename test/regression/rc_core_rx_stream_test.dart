import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> _flushStreamEvents() => Future<void>.delayed(Duration.zero);

void main() {
  group('Rx bridge subscription ownership', () {
    test('only the last stream cancellation detaches the bridge', () async {
      final rx = RxInt(0);
      final subscriptions = <StreamSubscription<int>>[];
      var notifierCalls = 0;
      final removeNotifier = rx.addListener(() => notifierCalls++);
      addTearDown(() async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
        removeNotifier();
        rx.close();
      });

      final first = <int>[];
      final second = <int>[];
      final firstSubscription = rx.listen(first.add);
      subscriptions.add(firstSubscription);
      final secondSubscription = rx.listen(second.add);
      subscriptions.add(secondSubscription);

      rx.value = 1;
      await _flushStreamEvents();
      await firstSubscription.cancel();
      rx.value = 2;
      await _flushStreamEvents();
      expect(first, [1]);
      expect(second, [1, 2]);

      await secondSubscription.cancel();
      rx.value = 3;
      await _flushStreamEvents();
      expect(notifierCalls, 3);

      final third = <int>[];
      subscriptions.add(rx.listen(third.add));
      rx.value = 4;
      await _flushStreamEvents();
      expect(third, [4]);
      expect(notifierCalls, 4);
    });

    test(
      'can replace the last subscription inside its data callback',
      () async {
        final rx = RxInt(0);
        final first = <int>[];
        final replacement = <int>[];
        final subscriptions = <StreamSubscription<int>>[];
        addTearDown(() async {
          for (final subscription in subscriptions) {
            await subscription.cancel();
          }
          rx.close();
        });

        late StreamSubscription<int> initial;
        initial = rx.listen((value) {
          first.add(value);
          unawaited(initial.cancel());
          subscriptions.add(rx.listen(replacement.add));
          rx.value = 2;
        });
        subscriptions.add(initial);

        rx.value = 1;
        await _flushStreamEvents();
        expect(first, [1]);
        expect(replacement, [2]);
      },
    );

    test('closing from a stream callback still delivers done', () async {
      final rx = RxInt(0);
      final seen = <int>[];
      final done = Completer<void>();
      final subscription = rx.listen((value) {
        seen.add(value);
        rx.close();
      }, onDone: done.complete);
      addTearDown(() async {
        await subscription.cancel();
        if (!rx.isDisposed) rx.close();
      });

      rx.value = 1;
      await done.future.timeout(const Duration(seconds: 1));
      rx.value = 2;
      await _flushStreamEvents();
      expect(seen, [1]);
      expect(rx.isDisposed, isTrue);
    });

    test('paused subscriptions finish queued events after Rx closes', () async {
      final rx = RxInt(0);
      final seen = <int>[];
      final done = Completer<void>();
      final subscription = rx.listen(seen.add, onDone: done.complete);
      addTearDown(() async {
        subscription.resume();
        await subscription.cancel();
        if (!rx.isDisposed) rx.close();
      });

      rx.value = 1;
      await _flushStreamEvents();
      subscription.pause();
      rx.value = 2;
      rx.close();
      rx.value = 3;
      subscription.resume();
      await done.future.timeout(const Duration(seconds: 1));
      expect(seen, [1, 2]);
      expect(rx.isDisposed, isTrue);
    });

    test(
        'close during synchronous notifier dispatch does not write a closed stream',
        () async {
      final rx = RxInt(0);
      rx.addListener(rx.close);
      final seen = <int>[];
      final subscription = rx.listen(seen.add);
      addTearDown(() async {
        await subscription.cancel();
        if (!rx.isDisposed) rx.close();
      });

      expect(() => rx.value = 1, returnsNormally);
      await _flushStreamEvents();
      expect(seen, isEmpty);
      expect(rx.isDisposed, isTrue);
    });
  });

  test('assignAll snapshots a cast view of its own backing list', () {
    final backing = <num>[1, 2, 3];
    final rx = RxList<num>(backing);
    addTearDown(rx.close);

    rx.assignAll(backing.cast<num>());

    expect(rx, [1, 2, 3]);
  });
}

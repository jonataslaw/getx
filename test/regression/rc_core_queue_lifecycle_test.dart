import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

const _deadline = Duration(seconds: 1);

Future<(Object, StackTrace)> _captureFailure<T>(Future<T> future) {
  return future
      .then<(Object, StackTrace)>(
        (_) => throw TestFailure('Expected a failed queue job'),
        onError: (Object error, StackTrace stack) => (error, stack),
      )
      .timeout(_deadline);
}

int _throwRawQueueFailure() {
  throw 'synchronous queue failure';
}

class _LifecycleRecorder extends GetxController {
  _LifecycleRecorder(this.events, this.name);

  final List<String> events;
  final String name;

  @override
  void onInit() {
    events.add('$name:init');
    super.onInit();
  }

  @override
  void onReady() {
    events.add('$name:ready');
    super.onReady();
  }

  @override
  void onClose() {
    events.add('$name:close');
    super.onClose();
  }
}

void main() {
  group('Queue error recovery', () {
    test(
      'queued sync and async failures preserve FIFO and error identity',
      () async {
        final queue = GetQueue();
        final gate = Completer<int>();
        final order = <String>[];
        final syncFailure = StateError('sync error');
        final asyncFailure = ArgumentError('async error');

        final first = queue.add<int>(() => gate.future);
        final sync = _captureFailure(
          queue.add<int>(() {
            order.add('sync failure');
            throw syncFailure;
          }),
        );
        final async = _captureFailure(
          queue.add<int>(() async {
            order.add('async failure');
            await Future<void>.value();
            throw asyncFailure;
          }),
        );
        final last = queue.add<int>(() {
          order.add('success');
          return 42;
        });

        expect(order, isEmpty);
        gate.complete(1);

        expect(await first.timeout(_deadline), 1);
        expect((await sync).$1, same(syncFailure));
        expect((await async).$1, same(asyncFailure));
        expect(await last.timeout(_deadline), 42);
        expect(order, ['sync failure', 'async failure', 'success']);
      },
    );

    test('synchronous raw failure keeps its originating stack trace', () async {
      final queue = GetQueue();
      final failure = await _captureFailure(
        queue.add<int>(_throwRawQueueFailure),
      );

      expect(failure.$1, 'synchronous queue failure');
      expect(failure.$2.toString(), contains('_throwRawQueueFailure'));
      expect(await queue.add<int>(() => 7).timeout(_deadline), 7);
    });

    test(
      'asynchronous raw failure forwards the supplied stack trace',
      () async {
        final queue = GetQueue();
        final origin = StackTrace.fromString('queue-job-origin-marker');
        final failure = await _captureFailure(
          queue.add<int>(
            () => Future<int>.error('asynchronous queue failure', origin),
          ),
        );

        expect(failure.$1, 'asynchronous queue failure');
        expect(failure.$2.toString(), origin.toString());
        expect(await queue.add<int>(() => 8).timeout(_deadline), 8);
      },
    );

    test(
      'a failing job can enqueue another job without losing queued work',
      () async {
        final queue = GetQueue();
        final gate = Completer<void>();
        final order = <String>[];
        final first = queue.add<void>(() => gate.future);
        late Future<int> nested;
        final failed = _captureFailure(
          queue.add<int>(() {
            order.add('failed parent');
            nested = queue.add<int>(() {
              order.add('nested');
              return 3;
            });
            throw 'parent failed';
          }),
        );
        final existing = queue.add<int>(() {
          order.add('existing');
          return 2;
        });

        gate.complete();
        await first.timeout(_deadline);
        expect((await failed).$1, 'parent failed');
        expect(await existing.timeout(_deadline), 2);
        expect(await nested.timeout(_deadline), 3);
        expect(order, ['failed parent', 'existing', 'nested']);
      },
    );

    test(
      'an incompatible job result fails its future and releases the slot',
      () async {
        final queue = GetQueue();
        final failure = await _captureFailure(
          queue.add<int>(() => 'not an integer'),
        );

        expect(failure.$1, isA<TypeError>());
        expect(await queue.add<int?>(() => null).timeout(_deadline), isNull);
        expect(await queue.add<int>(() async => 9).timeout(_deadline), 9);
      },
    );
  });

  group('Controller lifecycle', () {
    tearDown(() => Get.reset());

    testWidgets(
      'onStart schedules ready once across repeated starts and frames',
      (tester) async {
        final events = <String>[];
        final controller = _LifecycleRecorder(events, 'alive');
        addTearDown(controller.onDelete);

        controller.onStart();
        controller.onStart();
        await tester.pumpWidget(const SizedBox());
        controller.onStart();
        await tester.pump();
        await tester.pump();

        expect(events, ['alive:init', 'alive:ready']);
      },
    );

    testWidgets(
      'closing and recreating registration only readies new instance',
      (tester) async {
        Get.testMode = true;
        final events = <String>[];
        final first = Get.put(_LifecycleRecorder(events, 'first'));
        expect(Get.delete<_LifecycleRecorder>(), isTrue);
        final second = Get.put(_LifecycleRecorder(events, 'second'));
        expect(second, isNot(same(first)));

        await tester.pumpWidget(const SizedBox());
        await tester.pump();

        expect(events, [
          'first:init',
          'first:close',
          'second:init',
          'second:ready',
        ]);
        expect(Get.find<_LifecycleRecorder>(), same(second));
        expect(first.isClosed, isTrue);
        expect(second.isClosed, isFalse);
      },
    );

    testWidgets(
      'deletion is idempotent and never readies a closed controller',
      (tester) async {
        final events = <String>[];
        final controller = _LifecycleRecorder(events, 'closed')..onStart();

        controller.onDelete();
        controller.onDelete();
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
        controller.onStart();
        await tester.pump();

        expect(events, ['closed:init', 'closed:close']);
        expect(controller.isClosed, isTrue);
      },
    );
  });
}

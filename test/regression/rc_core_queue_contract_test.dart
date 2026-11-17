import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';

const _deadline = Duration(seconds: 1);

class _Settlement<T> {
  final values = <T>[];
  final errors = <Object>[];

  void observe(Future<T> future) {
    unawaited(future.then<void>(values.add,
        onError: (Object error, StackTrace stack) => errors.add(error)));
  }

  void expectPending() {
    expect(values, isEmpty);
    expect(errors, isEmpty);
  }
}

void main() {
  test('a synchronous active job is not undone by cancellation', () async {
    final queue = GetQueue();
    final events = <String>[];
    final active = queue.add<int>(() {
      events.add('active');
      return 1;
    });
    final discarded = _Settlement<int>();
    discarded.observe(queue.add<int>(() {
      events.add('discarded');
      return 2;
    }));

    queue.cancelAllJobs();
    final barrier = queue.add<int>(() {
      events.add('after cancellation');
      return 3;
    });
    expect(events, ['active']);
    expect(await active.timeout(_deadline), 1);
    expect(await barrier.timeout(_deadline), 3);
    expect(events, ['active', 'after cancellation']);
    discarded.expectPending();
  });

  test('cancellation drops pending jobs but lets active work finish', () async {
    final queue = GetQueue();
    final activeWork = Completer<int>();
    final events = <String>[];
    final active = queue.add<int>(() {
      events.add('active');
      return activeWork.future;
    });
    final discarded = _Settlement<int>();
    for (final value in [2, 3]) {
      discarded.observe(queue.add<int>(() {
        events.add('discarded $value');
        return value;
      }));
    }

    queue.cancelAllJobs();
    final after = queue.add<int>(() {
      events.add('after');
      return 4;
    });
    await Future<void>.delayed(Duration.zero);
    expect(events, ['active']);
    activeWork.complete(1);
    expect(await active.timeout(_deadline), 1);
    expect(await after.timeout(_deadline), 4);
    expect(events, ['active', 'after']);
    discarded.expectPending();
  });

  test('active errors still settle after pending jobs were discarded',
      () async {
    final queue = GetQueue();
    final work = Completer<int>();
    final active = queue.add<int>(() => work.future);
    final failure = StateError('active failure');
    final stack = StackTrace.fromString('active-cancellation-origin');
    final observed = active.then<Object?>((_) => fail('Expected an error'),
        onError: (Object error, StackTrace origin) {
      expect(error, same(failure));
      expect(origin.toString(), stack.toString());
      return error;
    });
    final discarded = _Settlement<int>()..observe(queue.add<int>(() => 2));

    queue.cancelAllJobs();
    final after = queue.add<int>(() => 3);
    work.completeError(failure, stack);
    expect(await observed.timeout(_deadline), same(failure));
    expect(await after.timeout(_deadline), 3);
    discarded.expectPending();
  });

  test('repeated cancellation discards only work pending at each call',
      () async {
    final queue = GetQueue();
    final work = Completer<int>();
    final active = queue.add<int>(() => work.future);
    final discarded = _Settlement<int>();
    discarded.observe(queue.add<int>(() => 2));
    queue.cancelAllJobs();
    discarded.observe(queue.add<int>(() => 3));
    queue.cancelAllJobs();
    queue.cancelAllJobs();
    final survivor = queue.add<int>(() => 4);

    work.complete(1);
    expect(await active.timeout(_deadline), 1);
    expect(await survivor.timeout(_deadline), 4);
    discarded.expectPending();
    queue.cancelAllJobs();
    expect(await queue.add<int>(() => 5).timeout(_deadline), 5);
  });

  test('a running job can discard the tail and enqueue replacement work',
      () async {
    final queue = GetQueue();
    final gate = Completer<int>();
    final first = queue.add<int>(() => gate.future);
    late Future<int> replacement;
    var discardedRan = false;
    final cancelling = queue.add<int>(() {
      queue.cancelAllJobs();
      replacement = queue.add<int>(() => 4);
      return 2;
    });
    final discarded = _Settlement<int>();
    discarded.observe(queue.add<int>(() {
      discardedRan = true;
      return 3;
    }));

    gate.complete(1);
    expect(await first.timeout(_deadline), 1);
    expect(await cancelling.timeout(_deadline), 2);
    expect(await replacement.timeout(_deadline), 4);
    expect(discardedRan, isFalse);
    discarded.expectPending();
  });

  test('cancelling an idle queue does not prevent later typed results',
      () async {
    final queue = GetQueue()..cancelAllJobs();
    expect(await queue.add<String>(() => 'value').timeout(_deadline), 'value');
    queue.cancelAllJobs();
    expect(await queue.add<int?>(() async => null).timeout(_deadline), isNull);
  });
}

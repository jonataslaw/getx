import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  Future<String> runAfter(Object thrown) {
    final done = Completer<String>();
    // A raw Error escaping `on Exception` surfaces as an uncaught async
    // error -- which is the symptom itself. Isolate it so the test reads.
    runZonedGuarded(() async {
      final queue = GetQueue();
      unawaited(
        queue.add<void>(() async => throw thrown).catchError((Object _) {}),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final next = await queue
          .add<String>(() async => 'ran')
          .timeout(const Duration(milliseconds: 300),
              onTimeout: () => 'QUEUE FROZEN');
      if (!done.isCompleted) done.complete(next);
    }, (_, _) {});
    return done.future;
  }

  test('an Error thrown by a job does not freeze the queue', () async {
    // MUTATION: restore `on Exception catch` in GetQueue._check and this
    // returns 'QUEUE FROZEN' -- verified.
    expect(await runAfter(StateError('an Error, not an Exception')), 'ran');
  });

  test('a raw String throw does not freeze the queue either', () async {
    // GetX itself still throws raw strings in 24 places; `on Exception`
    // caught none of them.
    expect(await runAfter('a bare string throw'), 'ran');
  });

  test('the caller is completed with the error, not left hanging', () async {
    // Second half of the fix: `on Exception` let an Error escape entirely,
    // so the caller's future never completed either.
    final queue = GetQueue();
    await expectLater(
      queue.add<void>(() async => throw StateError('an Error')),
      throwsA(isA<StateError>()),
    );
  });

  test('an Exception still completes the caller with the error', () async {
    final queue = GetQueue();
    await expectLater(
      queue.add<void>(() async => throw Exception('boom')),
      throwsA(isA<Exception>()),
    );
    expect(await queue.add<String>(() async => 'ran'), 'ran');
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _ConcurrentController extends StateController<int> {}

class _ConcurrentListController extends StateController<List<int>> {}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  test('older requests can replace newer success when they finish later',
      () async {
    final controller = _ConcurrentController()..setSuccess(0);
    addTearDown(controller.dispose);
    final older = Completer<int>();
    final newer = Completer<int>();
    final results = <int>[];
    final remove = controller.addListener(() {
      if (controller.status.isSuccess) results.add(controller.state);
    });
    addTearDown(remove);
    controller.futurize(() => older.future);
    controller.futurize(() => newer.future);
    expect(controller.status.isLoading, isTrue);

    newer.complete(2);
    await _flush();
    expect(controller.state, 2);
    expect(controller.status.isSuccess, isTrue);
    older.complete(1);
    await _flush();
    expect(controller.state, 1);
    expect(results, [2, 1]);
  });

  test('loading is not a count of requests still pending', () async {
    final controller = _ConcurrentController();
    addTearDown(controller.dispose);
    final first = Completer<int>();
    final second = Completer<int>();
    controller.futurize(() => first.future);
    controller.futurize(() => second.future);
    first.complete(1);
    await _flush();
    expect(controller.status.isLoading, isFalse);
    expect(controller.state, 1);
    second.complete(2);
    await _flush();
    expect(controller.state, 2);
  });

  test('an older late error replaces status but retains successful data',
      () async {
    final controller = _ConcurrentController();
    addTearDown(controller.dispose);
    final older = Completer<int>();
    final newer = Completer<int>();
    controller.futurize(() => older.future);
    controller.futurize(() => newer.future);
    newer.complete(2);
    await _flush();
    older.completeError(StateError('older failure'));
    await _flush();
    expect(controller.status.isError, isTrue);
    expect(controller.status.errorMessage, contains('older failure'));
    expect(controller.state, 2);
  });

  test('an older late success can replace a newer error', () async {
    final controller = _ConcurrentController()..setSuccess(0);
    addTearDown(controller.dispose);
    final older = Completer<int>();
    final newer = Completer<int>();
    controller.futurize(() => older.future);
    controller.futurize(() => newer.future);
    newer.completeError(Exception('newer failure'));
    await _flush();
    expect(controller.status.isError, isTrue);
    expect(controller.state, 0);
    older.complete(1);
    await _flush();
    expect(controller.status.isSuccess, isTrue);
    expect(controller.state, 1);
  });

  test('initialData initializes once and useEmpty belongs to each request',
      () async {
    final controller = _ConcurrentListController();
    addTearDown(controller.dispose);
    final older = Completer<List<int>>();
    final newer = Completer<List<int>>();
    controller.futurize(() => older.future, initialData: [1], useEmpty: false);
    controller.futurize(() => newer.future, initialData: [2]);
    expect(controller.state, [1]);
    newer.complete([]);
    await _flush();
    expect(controller.status.isEmpty, isTrue);
    expect(controller.state, [1]);
    older.complete([]);
    await _flush();
    expect(controller.status.isSuccess, isTrue);
    expect(controller.state, isEmpty);
  });

  test('per-request error messages follow the request that completed',
      () async {
    final controller = _ConcurrentController();
    addTearDown(controller.dispose);
    final older = Completer<int>();
    final newer = Completer<int>();
    controller.futurize(() => older.future, errorMessage: 'older message');
    controller.futurize(() => newer.future, errorMessage: 'newer message');
    newer.completeError('newer failure');
    await _flush();
    expect(controller.status.errorMessage, contains('newer message'));
    older.completeError('older failure');
    await _flush();
    expect(controller.status.errorMessage, contains('older message'));
    final exception = Exception('original exception');
    controller.futurize(() => Future<int>.error(exception),
        errorMessage: 'replacement message');
    await _flush();
    expect(controller.status.error, same(exception));
  });

  test('bodies start immediately without waiting for another request',
      () async {
    final controller = _ConcurrentController();
    addTearDown(controller.dispose);
    final first = Completer<int>();
    final second = Completer<int>();
    final starts = <String>[];
    controller.futurize(() {
      starts.add('first');
      return first.future;
    });
    controller.futurize(() {
      starts.add('second');
      return second.future;
    });
    expect(starts, ['first', 'second']);
    first.complete(1);
    second.complete(2);
    await _flush();
    expect(controller.state, 2);
  });

  test('closing ignores results without cancelling work already started',
      () async {
    final controller = _ConcurrentController()..setSuccess(0);
    addTearDown(controller.dispose);
    final backend = Completer<int>();
    var backendFinished = false;
    controller.futurize(() => backend.future.then((value) {
          backendFinished = true;
          return value;
        }));
    controller.onDelete();
    backend.complete(1);
    await _flush();
    expect(backendFinished, isTrue);
    expect(controller.status.isLoading, isTrue);
    expect(controller.state, 0);
    var startedAfterClose = false;
    controller.futurize(() async {
      startedAfterClose = true;
      return 2;
    });
    expect(startedAfterClose, isFalse);
  });
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class _Controller extends GetxController {
  int closes = 0;

  @override
  void onClose() {
    closes++;
    super.onClose();
  }
}

class _StateController extends StateController<List<int>> {}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  tearDown(Get.reset);

  group('Rx stream closure', () {
    test('last cancellation and resubscription retain stream updates',
        () async {
      final rx = 0.obs;
      final first = rx.listen((_) {});
      await first.cancel();
      final seen = <int>[];
      final second = rx.listen(seen.add);
      rx.value = 1;
      await _flush();
      expect(seen, [1]);
      await second.cancel();
      rx.close();
    });

    test('active and repeated close finish every subscriber', () async {
      final rx = 0.obs;
      final firstDone = Completer<void>();
      final secondDone = Completer<void>();
      final first = rx.listen((_) {}, onDone: firstDone.complete);
      final second = rx.listen((_) {}, onDone: secondDone.complete);
      rx.close();
      expect(rx.close, returnsNormally);
      await Future.wait([firstDone.future, secondDone.future])
          .timeout(const Duration(seconds: 1));
      await first.cancel();
      await second.cancel();
    });

    testWidgets('an Obx can unmount after its Rx was closed', (tester) async {
      final rx = 0.obs;
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Obx(() => Text('${rx.value}')),
      ));
      rx.close();
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });

  group('assignment snapshots', () {
    test('plain List.assign replaces all previous items', () {
      final values = [1, 2, 3];
      values.assign(4);
      expect(values, [4]);
      values.assign(5);
      expect(values, [5]);
    });

    test('plain Set.assign replaces all previous items', () {
      final values = <int>{1, 2, 3};
      values.assign(4);
      expect(values, {4});
    });

    test('plain Set.assignAll snapshots aliased views before replacement', () {
      final values = <int>{1, 2, 3};
      values.assignAll(values);
      expect(values, {1, 2, 3});
      values.assignAll(values.where((e) => e.isEven));
      expect(values, {2});
      values.assignAll(<int>[]);
      expect(values, isEmpty);
      values.assignAll([4, 5, 5]);
      expect(values, {4, 5});
    });

    test('plain List.assignAll replaces instead of appending', () {
      final values = [1, 2, 3];
      values.assignAll(values.where((e) => e.isEven));
      expect(values, [2]);
    });

    test('RxSet.assignAll snapshots self and lazy backing views', () {
      final values = <int>{1, 2, 3}.obs;
      addTearDown(values.close);
      values.assignAll(values);
      expect(values, {1, 2, 3});
      values.assignAll(values.value.where((e) => e.isOdd));
      expect(values, {1, 3});
    });

    test('RxSet.assignAll emits only its final snapshot', () async {
      final values = <int>{1, 2, 3}.obs;
      final seen = <Set<int>>[];
      final worker = ever<Set<int>>(values, (v) => seen.add(Set.of(v)));
      addTearDown(() {
        worker.dispose();
        values.close();
      });
      values.assignAll([4, 5]);
      await _flush();
      expect(seen, [
        {4, 5}
      ]);
    });

    test('RxMap.assignAll emits one update and keeps self assignment',
        () async {
      final values = <String, int>{'a': 1}.obs;
      final seen = <Map<String, int>>[];
      final worker = ever<Map<String, int>>(values, (v) => seen.add(Map.of(v)));
      addTearDown(() {
        worker.dispose();
        values.close();
      });
      values.assignAll(values);
      expect(values, {'a': 1});
      values.assignAll({'b': 2});
      await _flush();
      expect(seen, [
        {'b': 2}
      ]);
    });
  });

  group('Scoped bindings', () {
    testWidgets('Bind.put removes a nonpermanent owned registration',
        (tester) async {
      final controller = _Controller();
      await tester.pumpWidget(Binds(
        binds: [Bind.put(controller)],
        child: Builder(builder: (context) {
          expect(context.get<_Controller>(), same(controller));
          return const SizedBox();
        }),
      ));
      await tester.pumpWidget(const SizedBox());
      expect(Get.isRegistered<_Controller>(), isFalse);
      expect(controller.closes, 1);
    });

    testWidgets('Bind.put preserves permanent registrations', (tester) async {
      final controller = _Controller();
      await tester.pumpWidget(Binds(
        binds: [Bind.put(controller, permanent: true)],
        child: Builder(builder: (context) {
          expect(context.get<_Controller>(), same(controller));
          return const SizedBox();
        }),
      ));
      await tester.pumpWidget(const SizedBox());
      expect(Get.find<_Controller>(), same(controller));
      expect(controller.closes, 0);
      Get.delete<_Controller>(force: true);
      expect(controller.closes, 1);
    });

    testWidgets('Bind.spawn supplies and closes its scoped instance',
        (tester) async {
      late _Controller controller;
      await tester.pumpWidget(Binds(
        binds: [Bind.spawn<_Controller>(() => _Controller(), permanent: false)],
        child: Builder(builder: (context) {
          controller = context.get<_Controller>();
          expect(context.get<_Controller>(), same(controller));
          return const SizedBox();
        }),
      ));
      expect(tester.takeException(), isNull);
      expect(controller.initialized, isTrue);
      await tester.pumpWidget(const SizedBox());
      expect(controller.closes, 1);
      expect(Get.isRegistered<_Controller>(), isFalse);
    });

    testWidgets('a local Bind.builder initializes and closes its controller',
        (tester) async {
      final controller = _Controller();
      await tester.pumpWidget(Binds(
        binds: [
          Bind<_Controller>.builder(init: () => controller, global: false)
        ],
        child: Builder(builder: (context) {
          expect(context.get<_Controller>(), same(controller));
          return const SizedBox();
        }),
      ));
      expect(controller.initialized, isTrue);
      await tester.pumpWidget(const SizedBox());
      expect(controller.closes, 1);
      expect(Get.isRegistered<_Controller>(), isFalse);
    });

    testWidgets('Bind.create provides independent nested scopes',
        (tester) async {
      final outer = _Controller();
      final inner = _Controller();
      await tester.pumpWidget(Binds(
        binds: [Bind.create<_Controller>((_) => outer)],
        child: Builder(builder: (context) {
          expect(context.get<_Controller>(), same(outer));
          return Binds(
            binds: [Bind.create<_Controller>((_) => inner)],
            child: Builder(builder: (context) {
              expect(context.get<_Controller>(), same(inner));
              return const SizedBox();
            }),
          );
        }),
      ));
      expect(outer.initialized, isTrue);
      expect(inner.initialized, isTrue);
      await tester.pumpWidget(const SizedBox());
      expect(outer.closes, 1);
      expect(inner.closes, 1);
    });
  });

  group('StateMixin.futurize', () {
    test('records synchronous errors as an error state', () async {
      final controller = _StateController();
      final error = StateError('synchronous fetch failure');
      expect(() => controller.futurize(() => throw error), returnsNormally);
      await _flush();
      expect(controller.status.isError, isTrue);
      expect(controller.status.errorMessage,
          contains('synchronous fetch failure'));
    });

    test('emits one notification for each state transition', () async {
      final controller = _StateController();
      controller.setSuccess([0]);
      final request = Completer<List<int>>();
      final statuses = <Type>[];
      final remove = controller
          .addListener(() => statuses.add(controller.status.runtimeType));
      addTearDown(remove);
      controller.futurize(() => request.future);
      request.complete([1, 2]);
      await _flush();
      expect(controller.state, [1, 2]);
      expect(statuses, [LoadingStatus<List<int>>, SuccessStatus<List<int>>]);
    });

    test('handles empty, success and asynchronous error states', () async {
      final controller = _StateController();
      controller.futurize(() async => []);
      await _flush();
      expect(controller.status.isEmpty, isTrue);
      controller.futurize(() async => [], useEmpty: false);
      await _flush();
      expect(controller.status.isSuccess, isTrue);
      expect(controller.state, isEmpty);
      controller.futurize(() => Future.error(Exception('fetch failure')));
      await _flush();
      expect(controller.status.errorMessage, contains('fetch failure'));
    });

    for (final fails in [false, true]) {
      test('ignores ${fails ? 'failed' : 'successful'} results after disposal',
          () async {
        final controller = _StateController();
        final request = Completer<List<int>>();
        controller.futurize(() => request.future);
        controller.dispose();
        if (fails) {
          request.completeError(StateError('disposed fetch'));
        } else {
          request.complete([1]);
        }
        await _flush();
        expect(controller.isDisposed, isTrue);
      });
    }
  });

  test('Notifier restores tracking when a nested builder throws', () {
    final outer = <void Function()>[];
    final inner = <void Function()>[];
    final rx = 0.obs;
    final notifier = Notifier.instance;
    notifier.append(NotifyData(disposers: outer, updater: () {}), () {
      expect(
          () => notifier.append(
                NotifyData(
                    disposers: inner, updater: () {}, throwException: false),
                () => throw StateError('builder failed'),
              ),
          throwsStateError);
      expect(rx.value, 0);
    });
    expect(outer, hasLength(1));
    for (final dispose in outer) {
      dispose();
    }
    rx.close();
  });
}

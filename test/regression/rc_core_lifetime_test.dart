import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _LifetimeController extends StateController<int> {
  int closes = 0;

  @override
  void onClose() {
    closes++;
    super.onClose();
  }
}

class _ScrollingController extends GetxController with ScrollMixin {
  @override
  Future<void> onEndScroll() async {}

  @override
  Future<void> onTopScroll() async {}
}

class _SystemController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final events = <String>[];

  @override
  void onMemoryPressure() => events.add('memory');

  @override
  void onAccessibilityChanged() => events.add('accessibility');
}

Widget _scope(
    Bind binding, String key, void Function(_LifetimeController) read) {
  return Binds(
    key: ValueKey(key),
    binds: [binding],
    child: Builder(builder: (context) {
      read(context.get<_LifetimeController>());
      return const SizedBox();
    }),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);

  group('scoped dependency ownership', () {
    for (final reactive in [false, true]) {
      for (final autoRemove in [false, true]) {
        testWidgets(
            'updated autoRemove=$autoRemove is respected, reactive=$reactive',
            (tester) async {
          final controller = _LifetimeController();
          Widget app(bool remove) => reactive
              ? GetX<_LifetimeController>(
                  key: const ValueKey('owner'),
                  init: controller,
                  autoRemove: remove,
                  builder: (value) {
                    value.status;
                    return const SizedBox();
                  })
              : GetBuilder<_LifetimeController>(
                  key: const ValueKey('owner'),
                  init: controller,
                  autoRemove: remove,
                  builder: (_) => const SizedBox());
          await tester.pumpWidget(app(!autoRemove));
          await tester.pumpWidget(app(autoRemove));
          await tester.pumpWidget(const SizedBox());
          expect(Get.isRegistered<_LifetimeController>(), !autoRemove);
          expect(controller.closes, autoRemove ? 1 : 0);
          if (!autoRemove) Get.delete<_LifetimeController>();
        });
      }
    }

    for (final reactive in [false, true]) {
      for (final autoRemove in [false, true]) {
        testWidgets(
            'local autoRemove=$autoRemove follows the current widget, reactive=$reactive',
            (tester) async {
          final global = Get.put(_LifetimeController());
          final local = _LifetimeController();
          Widget app(bool remove) => reactive
              ? GetX<_LifetimeController>(
                  key: const ValueKey('local'),
                  init: local,
                  global: false,
                  autoRemove: remove,
                  builder: (value) {
                    value.status;
                    return const SizedBox();
                  })
              : GetBuilder<_LifetimeController>(
                  key: const ValueKey('local'),
                  init: local,
                  global: false,
                  autoRemove: remove,
                  builder: (_) => const SizedBox());
          await tester.pumpWidget(app(!autoRemove));
          await tester.pumpWidget(app(autoRemove));
          await tester.pumpWidget(const SizedBox());
          expect(local.closes, autoRemove ? 1 : 0);
          expect(global.closes, 0);
          expect(Get.find<_LifetimeController>(), same(global));
          if (!autoRemove) local.onDelete();
          Get.delete<_LifetimeController>();
        });
      }
    }

    for (final ownerLeavesFirst in [false, true]) {
      testWidgets(
          'a false borrower policy is live only while it remains, owner first=$ownerLeavesFirst',
          (tester) async {
        final controller = _LifetimeController();
        Widget tree(bool owner, bool borrower) => Column(children: [
              if (owner)
                GetBuilder<_LifetimeController>(
                    key: const ValueKey('owner'),
                    init: controller,
                    builder: (_) => const SizedBox()),
              if (borrower)
                GetX<_LifetimeController>(
                    key: const ValueKey('borrower'),
                    autoRemove: false,
                    builder: (value) {
                      value.status;
                      return const SizedBox();
                    }),
            ]);
        await tester.pumpWidget(tree(true, true));
        await tester.pumpWidget(tree(!ownerLeavesFirst, ownerLeavesFirst));
        expect(controller.closes, 0);
        await tester.pumpWidget(const SizedBox());
        expect(Get.isRegistered<_LifetimeController>(), ownerLeavesFirst);
        expect(controller.closes, ownerLeavesFirst ? 0 : 1);
        if (ownerLeavesFirst) Get.delete<_LifetimeController>();
      });
    }

    testWidgets('an opted-out owner does not leave a sticky cleanup request',
        (tester) async {
      final controller = _LifetimeController();
      Widget tree(bool showOwner) => Column(children: [
            if (showOwner)
              GetBuilder<_LifetimeController>(
                  key: const ValueKey('owner'),
                  init: controller,
                  autoRemove: false,
                  builder: (_) => const SizedBox()),
            GetX<_LifetimeController>(
                key: const ValueKey('borrower'),
                builder: (value) {
                  value.status;
                  return const SizedBox();
                }),
          ]);
      await tester.pumpWidget(tree(true));
      await tester.pumpWidget(tree(false));
      await tester.pumpWidget(const SizedBox());
      expect(Get.find<_LifetimeController>(), same(controller));
      expect(controller.closes, 0);
      Get.delete<_LifetimeController>();
    });

    test('registration identity survives fenix but changes after reset', () {
      Get.lazyPut<_LifetimeController>(() => _LifetimeController(),
          fenix: true);
      final first = Get.getInstanceInfo<_LifetimeController>().registrationId;
      expect(first, isNotNull);
      Get.find<_LifetimeController>();
      Get.delete<_LifetimeController>();
      expect(Get.getInstanceInfo<_LifetimeController>().registrationId,
          same(first));
      Get.reset();
      Get.put(_LifetimeController());
      expect(Get.getInstanceInfo<_LifetimeController>().registrationId,
          isNot(same(first)));
      Get.delete<_LifetimeController>();
    });

    testWidgets('Bind.create never publishes a global factory', (tester) async {
      final local = _LifetimeController();
      await tester.pumpWidget(_scope(
          Bind.create<_LifetimeController>((_) => local), 'local', (value) {
        expect(value, same(local));
      }));
      expect(Get.isRegistered<_LifetimeController>(), isFalse);
      await tester.pumpWidget(const SizedBox());
      expect(local.closes, 1);
    });

    for (final fenix in [false, true]) {
      testWidgets(
          'local create preserves an external factory with fenix=$fenix',
          (tester) async {
        Get.lazyPut<_LifetimeController>(() => _LifetimeController(),
            tag: 'shared', fenix: fenix);
        final global = Get.find<_LifetimeController>(tag: 'shared');
        final local = _LifetimeController();
        await tester.pumpWidget(_scope(
            Bind.create<_LifetimeController>((_) => local, tag: 'shared'),
            'local',
            (value) => expect(value, same(local))));
        await tester.pumpWidget(const SizedBox());
        expect(local.closes, 1);
        expect(global.closes, 0);
        expect(Get.find<_LifetimeController>(tag: 'shared'), same(global));
        Get.delete<_LifetimeController>(tag: 'shared');
      });
    }

    testWidgets('Bind.put borrows a preexisting global registration',
        (tester) async {
      final global = Get.put(_LifetimeController(), tag: 'shared');
      await tester.pumpWidget(_scope(
          Bind.put<_LifetimeController>(_LifetimeController(), tag: 'shared'),
          'borrower',
          (value) => expect(value, same(global))));
      await tester.pumpWidget(const SizedBox());
      expect(global.closes, 0);
      expect(Get.find<_LifetimeController>(tag: 'shared'), same(global));
      Get.delete<_LifetimeController>(tag: 'shared');
    });

    testWidgets('a local GetX closes locally without deleting its global peer',
        (tester) async {
      final global = Get.put(_LifetimeController());
      final local = _LifetimeController();
      await tester.pumpWidget(GetX<_LifetimeController>(
          init: local,
          global: false,
          builder: (value) {
            value.status;
            return const SizedBox();
          }));
      await tester.pumpWidget(const SizedBox());
      expect(local.closes, 1);
      expect(global.closes, 0);
      expect(Get.find<_LifetimeController>(), same(global));
      Get.delete<_LifetimeController>();
    });

    for (final fenix in [false, true]) {
      testWidgets(
          'shared lazy scopes release only the last owner, fenix=$fenix',
          (tester) async {
        final first = Bind.lazyPut<_LifetimeController>(
            () => _LifetimeController(),
            tag: 'shared',
            fenix: fenix);
        final second = Bind.lazyPut<_LifetimeController>(
            () => _LifetimeController(),
            tag: 'shared',
            fenix: fenix);
        late _LifetimeController controller;
        Widget tree(bool showFirst) => Column(children: [
              if (showFirst)
                _scope(first, 'first', (value) => controller = value),
              _scope(second, 'second', (value) => controller = value),
            ]);
        await tester.pumpWidget(tree(true));
        final original = controller;
        await tester.pumpWidget(tree(false));
        expect(original.closes, 0);
        expect(Get.find<_LifetimeController>(tag: 'shared'), same(original));
        await tester.pumpWidget(const SizedBox());
        expect(original.closes, 1);
        expect(Get.isRegistered<_LifetimeController>(tag: 'shared'), fenix);
        if (fenix) {
          final recreated = Get.find<_LifetimeController>(tag: 'shared');
          expect(recreated, isNot(same(original)));
          expect(recreated.initialized, isTrue);
          expect(recreated.isClosed, isFalse);
          Get.delete<_LifetimeController>(tag: 'shared');
        }
      });
    }

    testWidgets(
        'shared Bind.put scopes keep their singleton until final unmount',
        (tester) async {
      final controller = _LifetimeController();
      final first = Bind.put(controller, tag: 'shared');
      final second = Bind.put(controller, tag: 'shared');
      Widget tree(bool showFirst) => Column(children: [
            if (showFirst) _scope(first, 'first', (_) {}),
            _scope(second, 'second', (_) {}),
          ]);
      await tester.pumpWidget(tree(true));
      await tester.pumpWidget(tree(false));
      expect(controller.closes, 0);
      expect(Get.find<_LifetimeController>(tag: 'shared'), same(controller));
      await tester.pumpWidget(const SizedBox());
      expect(controller.closes, 1);
      expect(Get.isRegistered<_LifetimeController>(tag: 'shared'), isFalse);
    });

    testWidgets('GetX and GetBuilder share registration ownership',
        (tester) async {
      final controller = _LifetimeController();
      Widget tree(bool showOwner) => Column(children: [
            if (showOwner)
              GetBuilder<_LifetimeController>(
                  key: const ValueKey('owner'),
                  init: controller,
                  builder: (_) => const SizedBox()),
            GetX<_LifetimeController>(
                key: const ValueKey('borrower'),
                builder: (value) {
                  value.status;
                  return const SizedBox();
                }),
          ]);
      await tester.pumpWidget(tree(true));
      await tester.pumpWidget(tree(false));
      expect(controller.closes, 0);
      expect(Get.find<_LifetimeController>(), same(controller));
      await tester.pumpWidget(const SizedBox());
      expect(controller.closes, 1);
    });

    testWidgets('shared spawn factories outlive either scoped instance',
        (tester) async {
      final first = Bind.spawn<_LifetimeController>(() => _LifetimeController(),
          tag: 'shared', permanent: false);
      final second = Bind.spawn<_LifetimeController>(
          () => _LifetimeController(),
          tag: 'shared',
          permanent: false);
      late _LifetimeController a;
      late _LifetimeController b;
      Widget tree(bool showFirst) => Column(children: [
            if (showFirst) _scope(first, 'first', (value) => a = value),
            _scope(second, 'second', (value) => b = value),
          ]);
      await tester.pumpWidget(tree(true));
      expect(a, isNot(same(b)));
      await tester.pumpWidget(tree(false));
      expect(a.closes, 1);
      expect(b.closes, 0);
      expect(Get.isRegistered<_LifetimeController>(tag: 'shared'), isTrue);
      final fromFactory = Get.find<_LifetimeController>(tag: 'shared');
      expect(fromFactory.initialized, isTrue);
      fromFactory.onDelete();
      await tester.pumpWidget(const SizedBox());
      expect(b.closes, 1);
      expect(Get.isRegistered<_LifetimeController>(tag: 'shared'), isFalse);
    });

    testWidgets('spawn scope preserves a preexisting factory', (tester) async {
      Get.spawn<_LifetimeController>(() => _LifetimeController(),
          tag: 'external', permanent: false);
      await tester.pumpWidget(_scope(
          Bind.spawn<_LifetimeController>(() => _LifetimeController(),
              tag: 'external', permanent: false),
          'local',
          (_) {}));
      await tester.pumpWidget(const SizedBox());
      expect(Get.isRegistered<_LifetimeController>(tag: 'external'), isTrue);
      Get.delete<_LifetimeController>(tag: 'external');
    });

    for (final reset in [false, true]) {
      testWidgets(
          'old scopes never delete replacement registrations, reset=$reset',
          (tester) async {
        final old = _LifetimeController();
        await tester.pumpWidget(_scope(Bind.put(old), 'old', (_) {}));
        if (reset) {
          Get.reset();
        } else {
          Get.delete<_LifetimeController>();
        }
        final replacement = Get.put(_LifetimeController());
        await tester.pumpWidget(const SizedBox());
        expect(replacement.closes, 0);
        expect(Get.find<_LifetimeController>(), same(replacement));
        Get.delete<_LifetimeController>();
      });
    }

    testWidgets(
        'a descriptor created before replacement only borrows the new one',
        (tester) async {
      final binding = Bind.put(_LifetimeController());
      Get.delete<_LifetimeController>();
      final replacement = Get.put(_LifetimeController());
      await tester.pumpWidget(_scope(binding, 'stale', (value) {
        expect(value, same(replacement));
      }));
      await tester.pumpWidget(const SizedBox());
      expect(replacement.closes, 0);
      expect(Get.find<_LifetimeController>(), same(replacement));
      Get.delete<_LifetimeController>();
    });

    testWidgets(
        'tagged and permanent registrations retain independent lifetimes',
        (tester) async {
      final a = _LifetimeController();
      final b = _LifetimeController();
      final first = Bind.put(a, tag: 'a');
      final second = Bind.put(b, tag: 'b', permanent: true);
      await tester.pumpWidget(Column(children: [
        _scope(first, 'a', (_) {}),
        _scope(second, 'b', (_) {}),
      ]));
      await tester.pumpWidget(const SizedBox());
      expect(a.closes, 1);
      expect(Get.isRegistered<_LifetimeController>(tag: 'a'), isFalse);
      expect(b.closes, 0);
      expect(Get.find<_LifetimeController>(tag: 'b'), same(b));
      Get.delete<_LifetimeController>(tag: 'b', force: true);
    });
  });

  group('StateMixin controller lifetime', () {
    for (final fails in [false, true]) {
      test('ignores ${fails ? 'error' : 'success'} after Get.delete/onClose',
          () async {
        final controller = Get.put(_LifetimeController());
        final pending = Completer<int>();
        controller.setSuccess(1);
        var notifications = 0;
        final remove = controller.addListener(() => notifications++);
        controller.futurize(() => pending.future);
        expect(Get.delete<_LifetimeController>(), isTrue);
        expect(controller.closes, 1);
        final before = notifications;
        if (fails) {
          pending.completeError(StateError('closed controller'));
        } else {
          pending.complete(2);
        }
        await Future<void>.delayed(Duration.zero);
        expect(notifications, before);
        expect(controller.status.isLoading, isTrue);
        expect(controller.state, 1);
        remove();
      });
    }

    test('fenix recreation receives only its own pending result', () async {
      Get.lazyPut<_LifetimeController>(() => _LifetimeController(),
          fenix: true);
      final old = Get.find<_LifetimeController>();
      final oldRequest = Completer<int>();
      final newRequest = Completer<int>();
      var oldChanges = 0;
      old.futurize(() => oldRequest.future);
      final remove = old.addListener(() => oldChanges++);
      Get.delete<_LifetimeController>();
      final recreated = Get.find<_LifetimeController>();
      recreated.futurize(() => newRequest.future);
      oldRequest.complete(1);
      newRequest.complete(2);
      await Future<void>.delayed(Duration.zero);
      expect(oldChanges, 0);
      expect(recreated.state, 2);
      expect(recreated.isClosed, isFalse);
      remove();
      Get.delete<_LifetimeController>();
    });

    test('a rejected permanent deletion does not discard an active result',
        () async {
      final controller = Get.put(_LifetimeController(), permanent: true);
      final request = Completer<int>();
      controller.futurize(() => request.future);
      expect(Get.delete<_LifetimeController>(), isFalse);
      request.complete(7);
      await Future<void>.delayed(Duration.zero);
      expect(controller.state, 7);
      expect(controller.status.isSuccess, isTrue);
      Get.delete<_LifetimeController>(force: true);
    });
  });

  group('controller resources and system callbacks', () {
    test('ScrollMixin disposes its owned ScrollController on close', () {
      final controller = _ScrollingController()..onStart();
      controller.onDelete();
      expect(() => controller.scroll.addListener(() {}), throwsFlutterError);
    });

    test('FullLifeCycleMixin forwards memory and accessibility changes', () {
      final controller = _SystemController();
      controller.didHaveMemoryPressure();
      controller.didChangeAccessibilityFeatures();
      expect(controller.events, ['memory', 'accessibility']);
    });
  });
}

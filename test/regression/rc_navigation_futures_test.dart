import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

GetDelegate createDelegate(
        {PreventDuplicateHandlingMode mode =
            PreventDuplicateHandlingMode.reorderRoutes,
        List<GetMiddleware> middlewares = const []}) =>
    GetDelegate(pages: [
      for (final name in ['/root', '/one', '/two', '/target'])
        GetPage(
            name: name,
            page: () => const SizedBox.shrink(),
            preventDuplicateHandlingMode: mode,
            middlewares: name == '/target' ? middlewares : const []),
    ]);
List<String?> names(GetDelegate delegate) =>
    delegate.activePages.map((entry) => entry.route?.name).toList();

void main() {
  testWidgets('offAllNamed settles every discarded typed future once',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final first = <String?>[];
    final second = <int?>[];
    delegate.toNamed<String>('/one').then(first.add);
    await tester.pump();
    delegate.toNamed<int>('/two').then(second.add);
    await tester.pump();
    delegate.offAllNamed<bool>('/target');
    await tester.pump();
    expect(names(delegate), ['/target']);
    expect(first, [null]);
    expect(second, [null]);
    await tester.pump();
    expect(first, hasLength(1));
    expect(second, hasLength(1));
  });

  testWidgets(
      'offNamedUntil settles only discarded futures and returns target result',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final retained = <String?>[];
    final removed = <int?>[];
    final target = <bool?>[];
    delegate.toNamed<String>('/one').then(retained.add);
    await tester.pump();
    delegate.toNamed<int>('/two').then(removed.add);
    await tester.pump();
    delegate
        .offNamedUntil<bool>('/target',
            predicate: (page) => page.name == '/one')!
        .then(target.add);
    await tester.pump();
    expect(names(delegate), ['/root', '/one', '/target']);
    expect(removed, [null]);
    expect(retained, isEmpty);
    delegate.back<bool>(true);
    await tester.pump();
    expect(target, [true]);
    delegate.back<String>('retained');
    await tester.pump();
    expect(retained, ['retained']);
  });

  testWidgets('replacing a sole replacement root settles its old typed future',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final old = <String?>[];
    delegate.offAllNamed<String>('/one')!.then(old.add);
    await tester.pump();
    delegate.offAllNamed<int>('/target');
    await tester.pump();
    expect(names(delegate), ['/target']);
    expect(old, [null]);
  });

  testWidgets('named replacement returns its non-null typed result',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final result = <String?>[];
    delegate.offAllNamed<String>('/one')!.then(result.add);
    await tester.pump();
    delegate.backAndtoNamed<String, void>('/target', result: 'picked');
    await tester.pump();
    expect(result, ['picked']);
  });

  testWidgets(
      'unnamed replacement settles predecessor and returns typed result',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final old = <int?>[];
    delegate.toNamed<int>('/one').then(old.add);
    await tester.pump();
    final result = <String?>[];
    delegate
        .off<String>(() => const SizedBox.shrink(),
            routeName: '/replacement',
            popGesture: false,
            transition: Transition.noTransition,
            curve: Curves.linear,
            duration: Duration.zero)
        .then(result.add);
    await tester.pump();
    expect(old, [null]);
    delegate.backAndtoNamed<String, void>('/target', result: 'picked');
    await tester.pump();
    expect(result, ['picked']);
  });

  testWidgets(
      'reorder duplicate settles displaced future and keeps new typed result',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final old = <String?>[];
    delegate.toNamed<String>('/one').then(old.add);
    await tester.pump();
    final result = <int?>[];
    delegate.toNamed<int>('/one').then(result.add);
    await tester.pump();
    expect(names(delegate), ['/root', '/one']);
    expect(old, [null]);
    expect(result, isEmpty);
    delegate.back<int>(42);
    await tester.pump();
    expect(result, [42]);
  });

  testWidgets(
      'doNothing duplicate settles skipped navigation without touching original',
      (tester) async {
    final delegate =
        createDelegate(mode: PreventDuplicateHandlingMode.doNothing);
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final original = <String?>[];
    delegate.toNamed<String>('/one').then(original.add);
    await tester.pump();
    final skipped = <int?>[];
    delegate.toNamed<int>('/one').then(skipped.add);
    await tester.pump();
    expect(skipped, [null]);
    expect(original, isEmpty);
    delegate.back<String>('original');
    await tester.pump();
    expect(original, ['original']);
  });

  testWidgets(
      'popUntilOriginalRoute removes pages above original and cancels duplicate',
      (tester) async {
    final delegate = createDelegate(
        mode: PreventDuplicateHandlingMode.popUntilOriginalRoute);
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final original = <String?>[];
    final above = <int?>[];
    final duplicate = <bool?>[];
    delegate.toNamed<String>('/one').then(original.add);
    await tester.pump();
    delegate.toNamed<int>('/two').then(above.add);
    await tester.pump();
    delegate.toNamed<bool>('/one').then(duplicate.add);
    await tester.pump();
    expect(names(delegate), ['/root', '/one']);
    expect(above, [null]);
    expect(duplicate, [null]);
    expect(original, isEmpty);
    delegate.back<String>('kept');
    await tester.pump();
    expect(original, ['kept']);
  });

  testWidgets('recreate duplicate settles old future before replacing it',
      (tester) async {
    final delegate =
        createDelegate(mode: PreventDuplicateHandlingMode.recreate);
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final old = <String?>[];
    final result = <int?>[];
    delegate.toNamed<String>('/one').then(old.add);
    await tester.pump();
    delegate.toNamed<int>('/one').then(result.add);
    await tester.pump();
    expect(old, [null]);
    delegate.back<int>(7);
    await tester.pump();
    expect(result, [7]);
  });

  testWidgets(
      'removeRoute settles the removed future and preserves other pages',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final removed = <String?>[];
    final retained = <int?>[];
    delegate.toNamed<String>('/one').then(removed.add);
    await tester.pump();
    delegate.toNamed<int>('/two').then(retained.add);
    await tester.pump();
    delegate.removeRoute('/one');
    await tester.pump();
    expect(names(delegate), ['/root', '/two']);
    expect(removed, [null]);
    expect(retained, isEmpty);
    delegate.back<int>(2);
    await tester.pump();
    expect(retained, [2]);
  });

  testWidgets('unknown-page clearing settles all prior futures',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final removed = <String?>[];
    delegate.toNamed<String>('/one').then(removed.add);
    await tester.pump();
    await delegate.goToUnknownPage(true);
    await tester.pump();
    expect(names(delegate), ['/404']);
    expect(removed, [null]);
  });

  testWidgets('cancelling middleware leaves history and settles skipped future',
      (tester) async {
    final delegate = createDelegate(middlewares: [_Cancel()]);
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final results = <String?>[];
    delegate.toNamed<String>('/target').then(results.add);
    await tester.pump();
    expect(names(delegate), ['/root']);
    expect(results, [null]);
  });

  testWidgets('popModeUntil settles removed routes and retains its target',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final retained = <String?>[];
    final removed = <int?>[];
    delegate.toNamed<String>('/one').then(retained.add);
    await tester.pump();
    delegate.toNamed<int>('/two').then(removed.add);
    await tester.pump();
    await delegate.popModeUntil('/one');
    await tester.pump();
    expect(names(delegate), ['/root', '/one']);
    expect(removed, [null]);
    expect(retained, isEmpty);
  });

  testWidgets('explicit preventDuplicates false creates independent futures',
      (tester) async {
    final delegate = createDelegate();
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    final first = <String?>[];
    final second = <int?>[];
    delegate.toNamed<String>('/one', preventDuplicates: false).then(first.add);
    await tester.pump();
    delegate.toNamed<int>('/one', preventDuplicates: false).then(second.add);
    await tester.pump();
    expect(names(delegate), ['/root', '/one', '/one']);
    expect(first, isEmpty);
    delegate.back<int>(2);
    await tester.pump();
    expect(second, [2]);
    delegate.back<String>('one');
    await tester.pump();
    expect(first, ['one']);
  });

  for (final mode in [
    PreventDuplicateHandlingMode.doNothing,
    PreventDuplicateHandlingMode.popUntilOriginalRoute
  ]) {
    testWidgets(
        'reapplying the current configuration keeps its future pending in $mode',
        (tester) async {
      final delegate = createDelegate(mode: mode);
      addTearDown(delegate.dispose);
      await delegate.toNamed<void>('/root');
      final results = <String?>[];
      delegate.toNamed<String>('/one').then(results.add);
      await tester.pump();
      await delegate.setNewRoutePath(delegate.currentConfiguration!);
      await tester.pump();
      expect(results, isEmpty);
      delegate.back<String>('kept');
      await tester.pump();
      expect(results, ['kept']);
    });
  }
  for (final operation in ['off', 'offAll', 'offAllNamed']) {
    testWidgets('$operation can establish the first route of an empty delegate',
        (tester) async {
      final delegate = createDelegate();
      addTearDown(delegate.dispose);
      final navigation = operation == 'offAllNamed'
          ? delegate.offAllNamed<void>('/target')!
          : operation == 'off'
              ? delegate.off<void>(() => const SizedBox.shrink(),
                  routeName: '/target',
                  popGesture: false,
                  transition: Transition.noTransition,
                  curve: Curves.linear,
                  duration: Duration.zero)
              : delegate.offAll<void>(() => const SizedBox.shrink(),
                  routeName: '/target',
                  popGesture: false,
                  transition: Transition.noTransition,
                  curve: Curves.linear,
                  duration: Duration.zero)!;
      await navigation;
      expect(names(delegate), ['/target']);
    });
  }
}

class _Cancel extends GetMiddleware {
  @override
  RouteDecoder? redirectDelegate(RouteDecoder route) => null;
}

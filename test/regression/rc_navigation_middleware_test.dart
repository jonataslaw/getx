import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

GetDelegate delegateWith(GetMiddleware middleware) => GetDelegate(pages: [
      for (final name in ['/root', '/one', '/target'])
        GetPage(
            name: name,
            page: () => const SizedBox.shrink(),
            middlewares: name == '/target' ? [middleware] : const []),
    ]);

void main() {
  for (final operation in ['offAllNamed', 'offNamed', 'offNamedUntil']) {
    testWidgets(
        '$operation respects middleware cancellation before removing history',
        (tester) async {
      final delegate = delegateWith(_Cancel());
      addTearDown(delegate.dispose);
      await delegate.toNamed<void>('/root');
      final prior = <String?>[];
      delegate.toNamed<String>('/one').then(prior.add);
      await tester.pump();
      final blocked = <bool?>[];
      final navigation = operation == 'offAllNamed'
          ? delegate.offAllNamed<bool>('/target')!
          : operation == 'offNamed'
              ? delegate.offNamed<bool>('/target')
              : delegate.offNamedUntil<bool>('/target')!;
      navigation.then(blocked.add);
      await tester.pump();
      expect(delegate.activePages.map((page) => page.route?.name),
          ['/root', '/one']);
      expect(blocked, [null]);
      expect(prior, isEmpty);
    });
  }

  testWidgets(
      'offAllNamed follows redirect middleware before replacing history',
      (tester) async {
    final redirect = _Redirect();
    final delegate = delegateWith(redirect);
    redirect.delegate = delegate;
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/root');
    delegate.offAllNamed<void>('/target');
    await tester.pump();
    expect(delegate.activePages.map((page) => page.route?.name), ['/one']);
  });

  for (final operation in [
    'off',
    'offAll',
    'toNamedAndOffUntil',
    'backAndtoNamed'
  ]) {
    testWidgets('$operation leaves history intact when middleware cancels',
        (tester) async {
      final delegate = delegateWith(_Cancel());
      addTearDown(delegate.dispose);
      await delegate.toNamed<void>('/root');
      final prior = <String?>[];
      delegate.toNamed<String>('/one').then(prior.add);
      await tester.pump();
      final blocked = <bool?>[];
      final navigation = operation == 'off'
          ? delegate.off<bool>(() => const SizedBox.shrink(),
              routeName: '/target',
              popGesture: false,
              transition: Transition.noTransition,
              curve: Curves.linear,
              duration: Duration.zero)
          : operation == 'offAll'
              ? delegate.offAll<bool>(() => const SizedBox.shrink(),
                  routeName: '/target',
                  popGesture: false,
                  transition: Transition.noTransition,
                  curve: Curves.linear,
                  duration: Duration.zero)!
              : operation == 'backAndtoNamed'
                  ? delegate.backAndtoNamed<String, bool>('/target',
                      result: 'removed')
                  : delegate.toNamedAndOffUntil<bool>(
                      '/target', (route) => false);
      navigation.then(blocked.add);
      await tester.pump();
      expect(delegate.activePages.map((page) => page.route?.name),
          ['/root', '/one']);
      expect(blocked, [null]);
      expect(prior, isEmpty);
    });
  }

  testWidgets('disposing a delegate settles active route futures',
      (tester) async {
    final delegate = delegateWith(_Cancel());
    await delegate.toNamed<void>('/root');
    final results = <String?>[];
    delegate.toNamed<String>('/one').then(results.add);
    await tester.pump();
    delegate.dispose();
    await tester.pump();
    expect(results, [null]);
  });

  testWidgets('a middleware finishing after disposal cannot resurrect history',
      (tester) async {
    final middleware = _Delayed();
    final delegate = delegateWith(middleware);
    await delegate.toNamed<void>('/root');
    final results = <String?>[];
    delegate.toNamed<String>('/target').then(results.add);
    await tester.pump();
    delegate.dispose();
    middleware.resume.complete();
    await tester.pump();
    expect(results, [null]);
    expect(delegate.activePages, isEmpty);
    expect(tester.takeException(), isNull);
  });
}

class _Cancel extends GetMiddleware {
  @override
  RouteDecoder? redirectDelegate(RouteDecoder route) => null;
}

class _Redirect extends GetMiddleware {
  late GetDelegate delegate;
  @override
  RouteDecoder redirectDelegate(RouteDecoder route) =>
      delegate.matchRoute('/one');
}

class _Delayed extends GetMiddleware {
  final resume = Completer<void>();
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    await resume.future;
    return route;
  }
}

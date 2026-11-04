import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

List<GetPage> _pages() => [
  GetPage<int>(
    name: '/root',
    restorationId: 'root-page',
    page: () => const _CounterPage('ROOT'),
  ),
  GetPage<int>(
    name: '/detail',
    restorationId: 'detail-page',
    page: () => const _CounterPage('DETAIL'),
  ),
];

Widget _app(GetDelegate delegate, [RouteInformation? information]) =>
    GetMaterialApp.router(
      restorationScopeId: 'app',
      routerDelegate: delegate,
      routeInformationParser: GetInformationParser(initialRoute: '/root'),
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation:
            information ?? RouteInformation(uri: Uri.parse('/root')),
      ),
    );

RouteInformation _persist(GetDelegate delegate) {
  final parser = GetInformationParser(initialRoute: '/root');
  final information = parser.restoreRouteInformation(
    delegate.currentConfiguration!,
  );
  const codec = StandardMessageCodec();
  return RouteInformation(
    uri: information.uri,
    state: codec.decodeMessage(codec.encodeMessage(information.state)),
  );
}

Future<GetDelegate> _seed(WidgetTester tester, {List<GetPage>? pages}) async {
  final delegate = GetDelegate(
    restorationScopeId: 'navigation',
    pages: pages ?? _pages(),
  );
  await tester.pumpWidget(_app(delegate));
  await tester.pumpAndSettle();
  return delegate;
}

Future<GetDelegate> _recreate(
  WidgetTester tester,
  RouteInformation information, {
  String? scope = 'navigation',
  List<GetPage>? pages,
}) async {
  await tester.pumpWidget(const SizedBox.shrink());
  Get.reset();
  final delegate = GetDelegate(
    restorationScopeId: scope,
    pages: pages ?? _pages(),
  );
  await tester.pumpWidget(_app(delegate, information));
  await tester.pumpAndSettle();
  return delegate;
}

Future<RouteDecoder> _parse(RouteInformation information) =>
    GetInformationParser(initialRoute: '/root')
        .parseRouteInformation(information);

Map _payload(RouteInformation information) =>
    (information.state as Map)['getx.navigationHistory'] as Map;

void main() {
  tearDown(Get.reset);

  testWidgets(
    'new delegate restores complete named history and future pushes',
    (tester) async {
      final original = GetDelegate(
        restorationScopeId: 'navigation',
        pages: _pages(),
      );
      await tester.pumpWidget(_app(original));
      await tester.pumpAndSettle();
      Get.toNamed<int>('/detail?item=42');
      await tester.pumpAndSettle();
      final information = _persist(original);
      expect(information.uri.toString(), '/detail?item=42');
      await tester.pumpWidget(const SizedBox.shrink());
      Get.reset();
      final restored = GetDelegate(
        restorationScopeId: 'navigation',
        pages: _pages(),
      );
      await tester.pumpWidget(_app(restored, information));
      await tester.pumpAndSettle();
      expect(restored.activePages.map((page) => page.pageSettings?.name), [
        '/root',
        '/detail?item=42',
      ]);
      expect(restored.canBack, isTrue);
      Get.back<int>(result: 42);
      await tester.pumpAndSettle();
      expect(find.text('ROOT:0'), findsOneWidget);
      expect(restored.canBack, isFalse);
      final future = Get.toNamed<int>('/detail');
      await tester.pumpAndSettle();
      Get.back<int>(result: 73);
      await tester.pumpAndSettle();
      expect(await future, 73);
    },
  );

  testWidgets('restart restores both page buckets and back to root', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        restorationScopeId: 'app',
        initialRoute: '/root',
        getPages: _pages(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ROOT:0'));
    await tester.pump();
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    await tester.tap(find.text('DETAIL:0'));
    await tester.enterText(find.byType(TextField), 'restored-note');
    await tester.pump();
    await tester.restartAndRestore();
    await tester.pumpAndSettle();
    expect(find.text('DETAIL:1'), findsOneWidget);
    expect(find.text('note:restored-note'), findsOneWidget);
    expect(Get.rootController.rootDelegate.canBack, isTrue);
    Get.back<int>(result: 42);
    await tester.pumpAndSettle();
    expect(find.text('ROOT:1'), findsOneWidget);
    expect(Get.rootController.rootDelegate.canBack, isFalse);
  });

  testWidgets('snapshot preserves detached serializable arguments', (
    tester,
  ) async {
    final original = GetDelegate(
      restorationScopeId: 'navigation',
      pages: _pages(),
    );
    await tester.pumpWidget(_app(original));
    await tester.pumpAndSettle();
    final arguments = <String, Object?>{
      'list': <Object?>[1, true, null, 'note'],
      'map': <String, Object?>{'value': 2.5},
    };
    Get.toNamed<int>('/detail', arguments: arguments);
    await tester.pumpAndSettle();
    final information = _persist(original);
    (arguments['list']! as List)[0] = 99;
    await tester.pumpWidget(const SizedBox.shrink());
    Get.reset();
    final restored = GetDelegate(
      restorationScopeId: 'navigation',
      pages: _pages(),
    );
    await tester.pumpWidget(_app(restored, information));
    await tester.pumpAndSettle();
    expect(restored.arguments<Object?>(), {
      'list': [1, true, null, 'note'],
      'map': {'value': 2.5},
    });
  });

  testWidgets('delegate without scope retains URI-only argument behavior', (
    tester,
  ) async {
    final delegate = GetDelegate(pages: _pages());
    await tester.pumpWidget(_app(delegate));
    await tester.pumpAndSettle();
    final object = Object();
    Get.toNamed<int>('/detail', arguments: object);
    await tester.pumpAndSettle();
    expect(_persist(delegate).state, isNull);
    expect(identical(delegate.arguments<Object>(), object), isTrue);
  });

  testWidgets('browser replay retains live prefix and typed result future', (
    tester,
  ) async {
    final delegate = await _seed(tester);
    final result = Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final before = List<RouteDecoder>.of(delegate.activePages);
    final information = _persist(delegate);
    await delegate.setNewRoutePath(await _parse(information));
    await tester.pumpAndSettle();
    expect(identical(delegate.activePages[0], before[0]), isTrue);
    expect(identical(delegate.activePages[1], before[1]), isTrue);
    Get.back<int>(result: 42);
    await tester.pumpAndSettle();
    expect(await result, 42);
  });

  testWidgets(
    'browser back and forward replace history and settle removed future',
    (tester) async {
      final delegate = await _seed(tester);
      final root = _persist(delegate);
      final result = Get.toNamed<int>('/detail');
      await tester.pumpAndSettle();
      final detail = _persist(delegate);
      await delegate.setNewRoutePath(await _parse(root));
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(delegate.activePages.length, 1);
      expect(delegate.canBack, isFalse);
      await delegate.setNewRoutePath(await _parse(detail));
      await tester.pumpAndSettle();
      expect(delegate.activePages.length, 2);
      Get.back<int>(result: 42);
      await tester.pumpAndSettle();
      expect(find.text('ROOT:0'), findsOneWidget);
    },
  );

  testWidgets(
    'same selected URI detects changed history and detached arguments',
    (tester) async {
      final delegate = await _seed(tester);
      final arguments = <String, Object?>{'value': 1};
      Get.toNamed<int>('/detail', arguments: arguments);
      await tester.pumpAndSettle();
      final before = delegate.currentConfiguration;
      arguments['value'] = 2;
      expect(delegate.currentConfiguration, isNot(before));
      final withRoot = delegate.currentConfiguration;
      delegate.removeRoute('/root');
      expect(
        delegate.currentConfiguration?.pageSettings?.uri,
        withRoot?.pageSettings?.uri,
      );
      expect(delegate.currentConfiguration, isNot(withRoot));
    },
  );

  testWidgets('offAll does not fabricate a root during restoration', (
    tester,
  ) async {
    final delegate = await _seed(tester);
    Get.offAllNamed<int>('/detail');
    await tester.pumpAndSettle();
    final restored = await _recreate(tester, _persist(delegate));
    expect(restored.activePages.map((page) => page.route?.name), ['/detail']);
    expect(restored.canBack, isFalse);
  });

  testWidgets(
    'duplicate named instances retain distinct keys and ordered pops',
    (tester) async {
      List<GetPage> pages() => [
        for (final name in ['/root', '/detail'])
          GetPage<int>(name: name, page: () => Text(name)),
      ];
      final delegate = await _seed(tester, pages: pages());
      Get.toNamed<int>('/detail', preventDuplicates: false);
      await tester.pumpAndSettle();
      Get.toNamed<int>('/detail', preventDuplicates: false);
      await tester.pumpAndSettle();
      final information = _persist(delegate);
      expect(information.state, isNotNull);
      final restored = await _recreate(tester, information, pages: pages());
      expect(restored.activePages.length, 3);
      expect(
        restored.activePages.map((page) => page.route?.key).toSet().length,
        3,
      );
      Get.back<int>(result: 42);
      await tester.pumpAndSettle();
      expect(restored.activePages.length, 2);
      Get.back<int>(result: 42);
      await tester.pumpAndSettle();
      expect(find.text('/root'), findsOneWidget);
      expect(restored.canBack, isFalse);
    },
  );

  testWidgets('query, fragment and path parameters keep the selected URI', (
    tester,
  ) async {
    List<GetPage> pages() => [
      ..._pages(),
      GetPage<int>(name: '/item/:id', page: () => const Text('item')),
    ];
    final delegate = await _seed(tester, pages: pages());
    Get.toNamed<int>('/item/42?q=a+b#fragment');
    await tester.pumpAndSettle();
    final information = _persist(delegate);
    final restored = await _recreate(tester, information, pages: pages());
    expect(
      restored.currentConfiguration?.pageSettings?.name,
      '/item/42?q=a+b#fragment',
    );
    expect(restored.parameters, {'q': 'a b', 'id': '42'});
  });

  for (final invalid in [
    'foreign',
    'version',
    'entries',
    'id',
    'top',
    'unknown',
    'keys',
    'restoration-id',
  ]) {
    testWidgets('$invalid snapshot falls back to the selected URI only', (
      tester,
    ) async {
      final delegate = await _seed(tester);
      Get.toNamed<int>('/detail', arguments: {'saved': true});
      await tester.pumpAndSettle();
      final information = _persist(delegate);
      final state = information.state as Map;
      final payload = _payload(information);
      switch (invalid) {
        case 'foreign':
          state.clear();
          state['foreign'] = true;
        case 'version':
          payload['version'] = 99;
        case 'entries':
          payload['entries'] = 'invalid';
        case 'id':
          payload['entries'][1]['id'] = payload['entries'][0]['id'];
        case 'top':
          payload['entries'][1]['uri'] = '/root';
        case 'unknown':
          payload['entries'][0]['uri'] = '/removed';
        case 'keys':
          payload['entries'][0]['uri'] = '/detail';
        case 'restoration-id':
          payload['entries'][0]['uri'] = '/detail';
          for (final entry in payload['entries']) {
            entry['preventDuplicates'] = false;
          }
      }
      final restored = await _recreate(tester, information);
      expect(restored.activePages.map((page) => page.route?.name), ['/detail']);
      expect(restored.arguments<Object?>(), isNull);
    });
  }

  for (final scope in <String?>['other', null]) {
    testWidgets('scope $scope ignores an incoming history snapshot', (
      tester,
    ) async {
      final delegate = await _seed(tester);
      Get.toNamed<int>('/detail', arguments: {'saved': true});
      await tester.pumpAndSettle();
      final restored = await _recreate(
        tester,
        _persist(delegate),
        scope: scope,
      );
      expect(restored.activePages.map((page) => page.route?.name), ['/detail']);
      expect(restored.arguments<Object?>(), isNull);
    });
  }

  for (final kind in ['object', 'cycle', 'depth', 'size', 'number', 'key']) {
    testWidgets('$kind arguments fall back without changing live arguments', (
      tester,
    ) async {
      final delegate = await _seed(tester);
      Object? arguments;
      switch (kind) {
        case 'object':
          arguments = Object();
        case 'cycle':
          final cyclic = <Object?>[];
          cyclic.add(cyclic);
          arguments = cyclic;
        case 'depth':
          arguments = 0;
          for (var i = 0; i < 18; i++) {
            arguments = [arguments];
          }
        case 'size':
          arguments = 'x' * 65537;
        case 'number':
          arguments = double.nan;
        case 'key':
          arguments = {1: 'non-string key'};
      }
      Get.toNamed<int>('/detail', arguments: arguments);
      await tester.pumpAndSettle();
      expect(_persist(delegate).state, isNull);
      expect(identical(delegate.arguments<Object?>(), arguments), isTrue);
    });
  }

  testWidgets('large lazy arguments stop before traversing the full input', (
    tester,
  ) async {
    final delegate = await _seed(tester);
    final arguments = _CountingList();
    Get.toNamed<int>('/detail', arguments: arguments);
    await tester.pumpAndSettle();
    arguments.reads = 0;
    expect(_persist(delegate).state, isNull);
    expect(arguments.reads, lessThan(100));
  });

  testWidgets('history limit accepts 128 entries and falls back at 129', (
    tester,
  ) async {
    final delegate = GetDelegate(
      restorationScopeId: 'navigation',
      pages: [
        GetPage<int>(name: '/detail', page: () => const SizedBox.shrink()),
      ],
    );
    addTearDown(delegate.dispose);
    await delegate.toNamed<int>('/detail');
    for (var index = 1; index < 128; index++) {
      delegate.toNamed<int>('/detail', preventDuplicates: false);
      await tester.pump();
    }
    expect(_persist(delegate).state, isNotNull);
    delegate.toNamed<int>('/detail', preventDuplicates: false);
    await tester.pump();
    expect(_persist(delegate).state, isNull);
  });

  testWidgets('restored entries cannot bypass a canceled ancestor guard', (
    tester,
  ) async {
    final original = await _seed(tester);
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final information = _persist(original);
    final guard = _HistoryGuard()..action = (_) => null;
    final restored = await _recreate(
      tester,
      information,
      pages: [
        GetPage<int>(
          name: '/root',
          page: () => const Text('root'),
          middlewares: [guard],
        ),
        GetPage<int>(name: '/detail', page: () => const Text('detail')),
      ],
    );
    expect(guard.calls, greaterThan(0));
    expect(restored.activePages.map((page) => page.route?.name), ['/detail']);
  });

  testWidgets('canceled selected guard leaves the live stack intact', (
    tester,
  ) async {
    final guard = _HistoryGuard();
    final delegate = await _seed(tester, pages: _guardedPages(guard));
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final information = _persist(delegate);
    Get.back<int>();
    await tester.pumpAndSettle();
    final root = delegate.activePages.single;
    guard.action = (_) => null;
    await delegate.setRestoredRoutePath(await _parse(information));
    await tester.pumpAndSettle();
    expect(delegate.activePages.length, 1);
    expect(identical(delegate.activePages.single, root), isTrue);
  });

  testWidgets('redirect guard discards the snapshot and follows guarded URI', (
    tester,
  ) async {
    final original = await _seed(tester);
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final information = _persist(original);
    final guard = _HistoryGuard()
      ..action = (_) => RouteDecoder.fromRoute('/login');
    final restored = await _recreate(
      tester,
      information,
      pages: _guardedPages(guard),
    );
    expect(restored.activePages.map((page) => page.route?.name), ['/login']);
    expect(guard.calls, greaterThan(0));
  });

  testWidgets('guard errors do not partially replace live history', (
    tester,
  ) async {
    final guard = _HistoryGuard();
    final delegate = await _seed(tester, pages: _guardedPages(guard));
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final information = _persist(delegate);
    Get.back<int>();
    await tester.pumpAndSettle();
    final root = delegate.activePages.single;
    guard.action = (_) => throw StateError('guard failed');
    await expectLater(
      delegate.setRestoredRoutePath(await _parse(information)),
      throwsStateError,
    );
    expect(identical(delegate.activePages.single, root), isTrue);
  });

  for (final interruption in ['navigation', 'import', 'dispose']) {
    testWidgets('$interruption invalidates an asynchronous history import', (
      tester,
    ) async {
      final guard = _HistoryGuard();
      final delegate = await _seed(tester, pages: _guardedPages(guard));
      final rootInformation = _persist(delegate);
      Get.toNamed<int>('/detail');
      await tester.pumpAndSettle();
      final information = _persist(delegate);
      Get.back<int>();
      await tester.pumpAndSettle();
      final pending = Completer<RouteDecoder?>();
      late RouteDecoder guarded;
      guard.action = (route) {
        guarded = route;
        return pending.future;
      };
      final importing = delegate.setRestoredRoutePath(
        await _parse(information),
      );
      await tester.pump();
      switch (interruption) {
        case 'navigation':
          Get.toNamed<int>('/other');
          await tester.pumpAndSettle();
        case 'import':
          await delegate.setNewRoutePath(await _parse(rootInformation));
        case 'dispose':
          await tester.pumpWidget(const SizedBox.shrink());
          delegate.dispose();
      }
      pending.complete(guarded);
      await importing;
      await tester.pump();
      expect(
        delegate.activePages.map((page) => page.route?.name),
        interruption == 'dispose'
            ? isEmpty
            : interruption == 'navigation'
            ? ['/root', '/other']
            : ['/root'],
      );
    });
  }

  testWidgets('in-place guard changes reject a previously validated snapshot', (
    tester,
  ) async {
    final original = await _seed(tester);
    Get.toNamed<int>('/detail');
    await tester.pumpAndSettle();
    final information = _persist(original);
    final guard = _HistoryGuard()
      ..action = (route) {
        route.route = route.route!.copyWith(name: '/changed');
        return route;
      };
    final restored = await _recreate(
      tester,
      information,
      pages: [
        GetPage<int>(
          name: '/root',
          page: () => const Text('root'),
          middlewares: [guard],
        ),
        GetPage<int>(name: '/detail', page: () => const Text('detail')),
      ],
    );
    expect(restored.activePages.map((page) => page.route?.name), ['/detail']);
  });
  testWidgets('ancestor mutations also reject a validated nested snapshot', (
    tester,
  ) async {
    final guard = _HistoryGuard();
    List<GetPage> pages() => [
      GetPage<int>(
        name: '/root',
        page: () => const Text('root'),
        children: [
          GetPage<int>(
            name: '/detail',
            page: () => const Text('detail'),
            middlewares: [guard],
          ),
        ],
      ),
    ];
    final original = await _seed(tester, pages: pages());
    Get.toNamed<int>('/root/detail');
    await tester.pumpAndSettle();
    final information = _persist(original);
    guard.action = (route) {
      route.currentTreeBranch[0] = route.currentTreeBranch[0].copyWith(
        key: const ValueKey('changed-ancestor'),
      );
      return route;
    };
    final restored = await _recreate(tester, information, pages: pages());
    expect(restored.activePages.map((page) => page.route?.name), [
      '/root/detail',
    ]);
  });
  testWidgets(
    'integral floating point entry IDs survive a platform JSON bridge',
    (tester) async {
      final delegate = await _seed(tester);
      Get.toNamed<int>('/detail');
      await tester.pumpAndSettle();
      final information = _persist(delegate);
      for (final entry in _payload(information)['entries']) {
        entry['id'] = (entry['id'] as int).toDouble();
      }
      final restored = await _recreate(tester, information);
      expect(restored.activePages.length, 2);
      expect(restored.canBack, isTrue);
    },
  );

  for (final numeric in <({Object value, bool isInteger})>[
    (value: 42, isInteger: true),
    (value: 42.0, isInteger: false),
  ]) {
    testWidgets(
      'platform JSON bridge preserves numeric argument ${numeric.isInteger ? 'int' : 'double'} and prefix',
      (tester) async {
        final delegate = await _seed(tester);
        final result = Get.toNamed<int>('/detail', arguments: numeric.value)!;
        await tester.pumpAndSettle();
        final originalEntry = delegate.activePages.last;
        final information = _persist(delegate);
        final bridged = RouteInformation(
          uri: information.uri,
          state: _throughNumericBridge(information.state),
        );
        await delegate.setNewRoutePath(await _parse(bridged));
        await tester.pumpAndSettle();
        expect(identical(delegate.activePages.last, originalEntry), isTrue);
        Get.back<int>(result: 42);
        await tester.pumpAndSettle();
        expect(
          await tester.runAsync(
            () => result.timeout(const Duration(seconds: 2)),
          ),
          42,
        );
        final restored = await _recreate(tester, bridged);
        if (numeric.isInteger) {
          expect(restored.arguments<int>(), 42);
        } else {
          expect(restored.arguments<double>(), 42.0);
        }
        Get.back<int>();
        await tester.pumpAndSettle();
        expect(restored.canBack, isFalse);
        // Restored routes have fresh completers, not old process continuations.
      },
    );
  }
  testWidgets(
    'saved restoration data rebuilds a fresh default root and delegate',
    (tester) async {
      Widget app() => GetMaterialApp(
        restorationScopeId: 'saved-os-app',
        initialRoute: '/root',
        getPages: _pages(),
      );
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final oldRoot = Get.rootController;
      final oldDelegate = oldRoot.rootDelegate;
      await tester.tap(find.text('ROOT:0'));
      await tester.enterText(find.byType(TextField), 'root-note');
      await tester.pump();
      Get.toNamed<int>('/detail');
      await tester.pumpAndSettle();
      await tester.tap(find.text('DETAIL:0'));
      await tester.pump();
      await tester.tap(find.text('DETAIL:1'));
      await tester.enterText(find.byType(TextField), 'detail-note');
      await tester.pump();
      final savedData = await tester.getRestorationData();

      await tester.pumpWidget(const SizedBox.shrink());
      Get.reset();
      expect(oldRoot.mounted, isFalse);
      expect(oldDelegate.activePages, isEmpty);
      // Start from an empty engine bucket so fresh startup cannot reuse saved data.
      await tester.restoreFrom(TestRestorationData.empty);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final freshRoot = Get.rootController;
      final freshDelegate = freshRoot.rootDelegate;
      expect(identical(freshRoot, oldRoot), isFalse);
      expect(identical(freshDelegate, oldDelegate), isFalse);
      expect(find.text('ROOT:0'), findsOneWidget);
      expect(freshDelegate.canBack, isFalse);

      await tester.restoreFrom(savedData);
      await tester.pumpAndSettle();
      expect(identical(Get.rootController.rootDelegate, freshDelegate), isTrue);
      expect(find.text('DETAIL:2'), findsOneWidget);
      expect(find.text('note:detail-note'), findsOneWidget);
      expect(freshDelegate.activePages.map((page) => page.route?.name), [
        '/root',
        '/detail',
      ]);
      expect(freshDelegate.canBack, isTrue);
      Get.back<int>(result: 42);
      await tester.pumpAndSettle();
      expect(find.text('ROOT:1'), findsOneWidget);
      expect(find.text('note:root-note'), findsOneWidget);
      expect(freshDelegate.canBack, isFalse);
    },
  );
}

class _CounterPage extends StatefulWidget {
  const _CounterPage(this.label);
  final String label;

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> with RestorationMixin {
  final _count = RestorableInt(0);
  final _note = RestorableTextEditingController();
  @override
  String get restorationId => 'counter-${widget.label}';
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_count, 'count');
    registerForRestoration(_note, 'note');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _count.value++),
          child: Text('${widget.label}:${_count.value}'),
        ),
        TextField(controller: _note.value),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _note.value,
          builder: (context, value, child) => Text('note:${value.text}'),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _count.dispose();
    _note.dispose();
    super.dispose();
  }
}

List<GetPage> _guardedPages(_HistoryGuard guard) => [
  for (final name in ['/root', '/detail', '/other', '/login'])
    GetPage<int>(
      name: name,
      page: () => Text(name),
      middlewares: name == '/detail' ? [guard] : const [],
    ),
];

class _HistoryGuard extends GetMiddleware {
  int calls = 0;
  FutureOr<RouteDecoder?> Function(RouteDecoder)? action;
  @override
  FutureOr<RouteDecoder?> redirectDelegate(RouteDecoder route) {
    calls++;
    final handler = action;
    return handler == null ? route : handler(route);
  }
}

class _CountingList extends ListBase<Object?> {
  int reads = 0;
  @override
  int get length => 200;
  @override
  set length(int value) => throw UnsupportedError('read only');
  @override
  Object? operator [](int index) {
    reads++;
    return 'x' * 1024;
  }

  @override
  void operator []=(int index, Object? value) =>
      throw UnsupportedError('read only');
}

Object? _throughNumericBridge(Object? value) {
  if (value is num) return value.toDouble();
  if (value is List) return value.map(_throughNumericBridge).toList();
  if (value is Map) {
    return value.map((key, item) => MapEntry(key, _throughNumericBridge(item)));
  }
  return value;
}

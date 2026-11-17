import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'support/page_removal_fixture.dart';

class _TestPage extends GetPage<int> {
  _TestPage(String name) : super(name: name, page: () => Text(name));

  @override
  Route<int> createRoute(BuildContext context) => MaterialPageRoute<int>(
        settings: this,
        builder: (_) => Scaffold(body: Text(name)),
      );
}

class _Host extends StatefulWidget {
  const _Host({super.key, required this.generated});
  final bool generated;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final pages = <GetPage>[_TestPage('/root'), _TestPage('/detail')];
  final removed = <Page<Object?>>[];

  void removePage(Page<Object?> page) {
    removed.add(page);
    setState(() => pages.remove(page));
  }

  @override
  Widget build(BuildContext context) => widget.generated
      ? GetNavigator.onGenerateRoute(
          key: navigatorKey,
          pages: List.of(pages),
          onDidRemovePage: removePage,
        )
      : GetNavigator(
          key: navigatorKey,
          pages: List.of(pages),
          onDidRemovePage: removePage,
        );
}

class _Outlet extends StatelessWidget {
  const _Outlet({required this.navigatorKey, required this.observe});
  final GlobalKey<NavigatorState> navigatorKey;
  final List<Page<Object?>>? observe;

  @override
  Widget build(BuildContext context) => GetRouterOutlet.pickPages(
        navigatorKey: navigatorKey,
        pickPages: (_) => Get.rootController.rootDelegate.activePages
            .map((entry) => entry.route!),
        onDidRemovePage: observe == null
            ? null
            : (page) {
                observe!.add(page);
                Get.rootController.rootDelegate.didRemovePage(page);
              },
      );
}

void main() {
  tearDown(Get.reset);
  testWidgets('generated routes do not complete the declarative page result',
      (tester) async {
    final result = Completer<int?>();
    final navigatorKey = GlobalKey<NavigatorState>();
    final pages = <GetPage>[
      GetPage<int>(
          name: '/base', page: () => const Scaffold(body: Text('base'))),
      GetPage<int>(
          name: '/detail',
          page: () => const Scaffold(body: Text('detail')),
          completer: result),
    ];
    await tester.pumpWidget(pageRemovalApp(
      initialRoute: '/host',
      getPages: [
        GetPage(
          name: '/host',
          page: () => StatefulBuilder(
            builder: (context, update) => GetNavigator.onGenerateRoute(
              key: navigatorKey,
              pages: List.of(pages),
              onDidRemovePage: (page) => update(() => pages.remove(page)),
            ),
          ),
        ),
        ...pages,
      ],
    ));
    await tester.pumpAndSettle();
    final generated = navigatorKey.currentState!.pushNamed<dynamic>('/detail');
    await tester.pumpAndSettle();
    navigatorKey.currentState!.pop<int>(9);
    await tester.pumpAndSettle();
    expect(await generated, 9);
    expect(result.isCompleted, isFalse);
    navigatorKey.currentState!.pop<int>(42);
    await tester.pumpAndSettle();
    expect(await result.future, 42);
    expect(pages.map((page) => page.name), ['/base']);
    expect(tester.takeException(), isNull);
  });
  for (final generated in [false, true]) {
    testWidgets(
      'GetNavigator generated=$generated reports committed removals',
      (tester) async {
        final key = GlobalKey<_HostState>();
        await tester.pumpWidget(
          MaterialApp(
            home: _Host(key: key, generated: generated),
          ),
        );
        await tester.pumpAndSettle();
        final state = key.currentState!;
        final detail = state.pages.last;
        state.navigatorKey.currentState!.pop<int>(7);
        await tester.pumpAndSettle();
        expect(state.removed, [same(detail)]);
        expect(state.pages.map((page) => page.name), ['/root']);
        expect(find.text('/root'), findsOneWidget);
        expect(find.text('/detail'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final custom in [false, true]) {
    testWidgets('nested outlet forwards custom=$custom committed removals',
        (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final observed = <Page<Object?>>[];
      await tester.pumpWidget(pageRemovalApp(
        initialRoute: '/shell/one',
        getPages: [
          GetPage(
            name: '/shell',
            participatesInRootNavigator: true,
            page: () => _Outlet(
                navigatorKey: navigatorKey, observe: custom ? observed : null),
            children: [
              for (final name in ['/one', '/two'])
                GetPage(
                  name: name,
                  participatesInRootNavigator: false,
                  page: () => Scaffold(body: Text(name)),
                ),
            ],
          ),
        ],
      ));
      await tester.pumpAndSettle();
      final results = <int?>[];
      Get.toNamed<int>('/shell/two')!.then(results.add);
      await tester.pumpAndSettle();
      navigatorKey.currentState!.pop<int>(19);
      await tester.pumpAndSettle();
      expect(results, [19]);
      expect(Get.rootController.rootDelegate.currentConfiguration?.route?.name,
          '/shell/one');
      expect(Get.rootController.rootDelegate.activePages, hasLength(1));
      expect(observed, hasLength(custom ? 1 : 0));
      expect(find.text('/one'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

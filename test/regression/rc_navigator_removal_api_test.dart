import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

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
  final pages = <GetPage>[_TestPage('root'), _TestPage('detail')];
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

void main() {
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
        expect(state.pages.map((page) => page.name), ['root']);
        expect(find.text('root'), findsOneWidget);
        expect(find.text('detail'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

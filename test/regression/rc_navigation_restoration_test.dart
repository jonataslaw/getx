import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);
  testWidgets('delegate restoration scope restores a page state after restart',
      (tester) async {
    final delegate = GetDelegate(restorationScopeId: 'navigator', pages: [
      GetPage(
          name: '/counter',
          page: () => const _Counter(),
          restorationId: 'counter-page')
    ]);
    addTearDown(delegate.dispose);
    await delegate.toNamed<void>('/counter');
    await tester.pumpWidget(GetMaterialApp.router(
        restorationScopeId: 'app',
        routerDelegate: delegate,
        routeInformationProvider: PlatformRouteInformationProvider(
            initialRouteInformation:
                RouteInformation(uri: Uri.parse('/counter')))));
    await tester.pumpAndSettle();
    await tester.tap(find.text('count:0'));
    await tester.pump();
    expect(find.text('count:1'), findsOneWidget);
    await tester.restartAndRestore();
    await tester.pumpAndSettle();
    expect(
        find
            .byType(Text)
            .evaluate()
            .map((element) => (element.widget as Text).data),
        contains('count:1'));
    expect(tester.takeException(), isNull);
  });
}

class _Counter extends StatefulWidget {
  const _Counter();
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> with RestorationMixin {
  final _count = RestorableInt(0);
  @override
  String get restorationId => 'counter';
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) =>
      registerForRestoration(_count, 'count');
  @override
  Widget build(BuildContext context) => Scaffold(
      body: TextButton(
          onPressed: () => setState(() => _count.value++),
          child: Text('count:${_count.value}')));
  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }
}

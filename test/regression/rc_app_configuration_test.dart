import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _ExternalDelegate extends RouterDelegate<Object> with ChangeNotifier {
  @override
  Widget build(BuildContext context) => const Text('external router');
  @override
  Future<void> setNewRoutePath(Object configuration) async {}
  @override
  Future<bool> popRoute() async => false;
}

void main() {
  tearDown(Get.reset);
  testWidgets('unmount settles pending routes owned by GetRoot',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(getPages: [
      GetPage(name: '/home', page: () => const Text('home')),
      GetPage(name: '/child', page: () => const Text('child')),
    ], initialRoute: '/home'));
    await tester.pump(const Duration(milliseconds: 500));
    var completed = false;
    Get.toNamed<int>('/child')!.then((_) => completed = true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(completed, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    expect(completed, isTrue);
  });

  testWidgets('RouterConfig with GetDelegate retains Get navigation',
      (tester) async {
    final delegate = GetDelegate(pages: [
      GetPage(name: '/home', page: () => const Text('configured home')),
      GetPage(name: '/child', page: () => const Text('configured child')),
    ]);
    await tester.pumpWidget(GetMaterialApp.router(
      routerConfig: RouterConfig<Object>(routerDelegate: delegate),
    ));
    await tester.pump(const Duration(milliseconds: 1));
    Get.toNamed<void>('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('configured home'), findsOneWidget);
    final result = Get.toNamed<int>('/child');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('configured child'), findsOneWidget);
    Get.back<int>(result: 42);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(await result, 42);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    delegate.dispose();
  });

  for (final cupertino in [false, true]) {
    testWidgets('custom RouterConfig works without GetPages ($cupertino)',
        (tester) async {
      final delegate = _ExternalDelegate();
      final config = RouterConfig<Object>(routerDelegate: delegate);
      await tester.pumpWidget(cupertino
          ? GetCupertinoApp.router(routerConfig: config)
          : GetMaterialApp.router(routerConfig: config));
      await tester.pump(const Duration(milliseconds: 1));
      expect(tester.takeException(), isNull);
      expect(find.text('external router'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }

  for (final cupertino in [false, true]) {
    testWidgets('app forwards restoration scope ($cupertino)', (tester) async {
      await tester.pumpWidget(cupertino
          ? GetCupertinoApp(
              restorationScopeId: 'example', home: const SizedBox())
          : GetMaterialApp(
              restorationScopeId: 'example', home: const SizedBox()));
      await tester.pump(const Duration(milliseconds: 1));
      final navigator = tester.widget<GetNavigator>(find.byType(GetNavigator));
      expect(navigator.restorationScopeId, 'example');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }

  testWidgets('MaterialApp forwards high contrast themes and actions',
      (tester) async {
    final highContrast = ThemeData(primaryColor: Colors.orange);
    final highContrastDark = ThemeData.dark();
    final actions = <Type, Action<Intent>>{};
    await tester.pumpWidget(GetMaterialApp(
      home: const Scaffold(),
      actions: actions,
      highContrastTheme: highContrast,
      highContrastDarkTheme: highContrastDark,
    ));
    await tester.pump(const Duration(milliseconds: 1));
    final config = Get.rootController.config;
    expect(config.copyWith(restorationScopeId: 'changed'), isNot(config));
    expect(
      config.copyWith(
        routerConfig: RouterConfig<Object>(routerDelegate: _ExternalDelegate()),
      ),
      isNot(config),
    );
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.highContrastTheme, same(highContrast));
    expect(app.highContrastDarkTheme, same(highContrastDark));
    expect(app.actions, same(actions));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

GetDelegate makeDelegate() => GetDelegate(pages: [
      for (final name in ['/root', '/one', '/target'])
        GetPage(name: name, page: () => const SizedBox.shrink()),
    ]);

void main() {
  testWidgets('clearing an independent nested delegate preserves root futures',
      (tester) async {
    final root = makeDelegate();
    final nested = makeDelegate();
    addTearDown(root.dispose);
    addTearDown(nested.dispose);
    await root.toNamed<void>('/root');
    await nested.toNamed<void>('/root');
    final rootResults = <String?>[];
    final nestedResults = <int?>[];
    root.toNamed<String>('/one').then(rootResults.add);
    nested.toNamed<int>('/one').then(nestedResults.add);
    await tester.pump();
    nested.offAllNamed<void>('/target');
    await tester.pump();
    expect(
        root.activePages.map((entry) => entry.route?.name), ['/root', '/one']);
    expect(nestedResults, [null]);
    expect(rootResults, isEmpty);
    root.back<String>('root');
    await tester.pump();
    expect(rootResults, ['root']);
  });

  test('path plus signs remain literal while query plus signs mean spaces', () {
    final delegate = GetDelegate(pages: [
      GetPage(name: '/parent', page: () => const SizedBox.shrink(), children: [
        GetPage(name: '/:name', page: () => const SizedBox.shrink())
      ])
    ]);
    addTearDown(delegate.dispose);
    final match = delegate.matchRoute('/parent/a+b?search=a+b');
    expect(match.route!.parameters, {'name': 'a+b', 'search': 'a b'});
    final encoded = delegate.matchRoute('/parent/a%2Bb?search=a%2Bb');
    expect(encoded.route!.parameters, {'name': 'a+b', 'search': 'a+b'});
    final unicode = delegate.matchRoute(
        '/parent/%D8%B3%D9%84%D8%A7%D9%85?search=%D8%AF%D9%86%DB%8C%D8%A7');
    expect(unicode.route!.parameters, {'name': 'سلام', 'search': 'دنیا'});
  });
}

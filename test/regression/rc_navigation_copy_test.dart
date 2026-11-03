import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('copyWith preserves restoration, pop contract and duplicate policy', () {
    final completer = Completer<String?>();
    void onPop(bool didPop, String? result) {}
    const key = ValueKey('restored');
    final page = GetPage<String>(
        name: '/page',
        page: () => const SizedBox.shrink(),
        restorationId: 'page-state',
        canPop: false,
        onPopInvoked: onPop,
        key: key,
        completer: completer,
        preventDuplicateHandlingMode: PreventDuplicateHandlingMode.doNothing);
    final copy = page.copyWith();
    expect(copy.restorationId, 'page-state');
    expect(copy.canPop, isFalse);
    expect(copy.onPopInvoked, same(onPop));
    expect(copy.key, key);
    expect(copy.completer, same(completer));
    expect(copy.preventDuplicateHandlingMode,
        PreventDuplicateHandlingMode.doNothing);
    expect(
        page.copyWith(restorationId: 'new-state').restorationId, 'new-state');
  });

  test('route parser preserves restoration identity of parent and child', () {
    final parent = GetPage(
        name: '/parent',
        page: () => const SizedBox.shrink(),
        restorationId: 'parent-state',
        children: [
          GetPage(
              name: '/child',
              page: () => const SizedBox.shrink(),
              restorationId: 'child-state')
        ]);
    final delegate = GetDelegate(pages: [parent]);
    addTearDown(delegate.dispose);
    final match = delegate.matchRoute('/parent/child');
    expect(match.currentTreeBranch.map((page) => page.restorationId),
        ['parent-state', 'child-state']);
  });
}

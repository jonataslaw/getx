import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _ThrowingList extends ListBase<int> {
  _ThrowingList(this.error);

  final StateError error;

  @override
  int get length => 3;

  @override
  set length(int value) => throw UnsupportedError('read only');

  @override
  int operator [](int index) {
    if (index == 1) throw error;
    return index + 1;
  }

  @override
  void operator []=(int index, int value) =>
      throw UnsupportedError('read only');
}

void main() {
  group('RxList.assignAll snapshots list sources', () {
    test('preserves contents when assigning the RxList to itself', () {
      final list = RxList<int>([1, 2, 3]);

      list.assignAll(list);

      expect(list, [1, 2, 3]);
    });

    test('preserves contents when assigning the backing list', () {
      final list = RxList<int>([1, 2, 3]);
      final source = list.value;

      list.assignAll(source);

      expect(list, [1, 2, 3]);
    });

    test('preserves contents when assigning an aliased list view', () {
      final list = RxList<int>([1, 2, 3]);
      final source = UnmodifiableListView<int>(list.value);

      list.assignAll(source);

      expect(list, [1, 2, 3]);
    });

    test('leaves contents untouched when reading a List source throws', () {
      final list = RxList<int>([7, 8, 9]);
      final error = StateError('cannot read source');

      expect(() => list.assignAll(_ThrowingList(error)), throwsA(same(error)));

      expect(list, [7, 8, 9]);
    });

    test('replaces contents without mutating a distinct source list', () {
      final list = RxList<int>([1, 2, 3]);
      final source = [4, 5];

      list.assignAll(source);

      expect(list, [4, 5]);
      expect(source, [4, 5]);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';

void main() {
  test(
    'default RxList is independently growable and notifies its worker',
    () async {
      final values = RxList<int>();
      final other = RxList<int>();
      final seen = <List<int>>[];
      final worker = ever<List<int>>(
        values,
        (value) => seen.add(List.of(value)),
      );
      addTearDown(() {
        worker.dispose();
        values.close();
        other.close();
      });

      values.addAll([1, 2]);
      await Future<void>.delayed(Duration.zero);

      expect(values, [1, 2]);
      expect(other, isEmpty);
      expect(identical(values.value, other.value), isFalse);
      expect(seen, [
        [1, 2],
      ]);
    },
  );

  test(
    'default RxMap is independently mutable and notifies its worker',
    () async {
      final values = RxMap<String, int>();
      final other = RxMap<String, int>();
      final seen = <Map<String, int>>[];
      final worker = ever<Map<String, int>>(
        values,
        (value) => seen.add(Map.of(value)),
      );
      addTearDown(() {
        worker.dispose();
        values.close();
        other.close();
      });

      values['answer'] = 42;
      await Future<void>.delayed(Duration.zero);

      expect(values, {'answer': 42});
      expect(other, isEmpty);
      expect(identical(values.value, other.value), isFalse);
      expect(seen, [
        {'answer': 42},
      ]);
    },
  );

  test(
    'default RxSet is independently mutable and notifies its worker',
    () async {
      final values = RxSet<int>();
      final other = RxSet<int>();
      final seen = <Set<int>>[];
      final worker = ever<Set<int>>(values, (value) => seen.add(Set.of(value)));
      addTearDown(() {
        worker.dispose();
        values.close();
        other.close();
      });

      expect(values.add(7), isTrue);
      await Future<void>.delayed(Duration.zero);

      expect(values, {7});
      expect(other, isEmpty);
      expect(identical(values.value, other.value), isFalse);
      expect(seen, [
        {7},
      ]);
    },
  );

  test('RxList retains the explicitly supplied backing list', () {
    final backing = <int>[];
    final values = RxList<int>(backing);
    addTearDown(values.close);
    values.add(1);
    expect(values.value, same(backing));
    expect(backing, [1]);
  });

  test('RxMap retains the explicitly supplied backing map', () {
    final backing = <String, int>{};
    final values = RxMap<String, int>(backing);
    addTearDown(values.close);
    values['answer'] = 42;
    expect(values.value, same(backing));
    expect(backing, {'answer': 42});
  });

  test('RxSet retains the explicitly supplied backing set', () {
    final backing = <int>{};
    final values = RxSet<int>(backing);
    addTearDown(values.close);
    values.add(1);
    expect(values.value, same(backing));
    expect(backing, {1});
  });

  test('RxList does not make an explicit unmodifiable list growable', () {
    final values = RxList<int>(List<int>.unmodifiable([1]));
    final fixed = RxList<int>.empty();
    addTearDown(values.close);
    addTearDown(fixed.close);
    expect(() => values.add(2), throwsUnsupportedError);
    expect(() => fixed.add(2), throwsUnsupportedError);
  });

  test('RxMap does not make an explicit unmodifiable map mutable', () {
    final values = RxMap<String, int>(Map<String, int>.unmodifiable({'a': 1}));
    addTearDown(values.close);
    expect(() => values['b'] = 2, throwsUnsupportedError);
  });

  test('RxSet does not make an explicit unmodifiable set mutable', () {
    final values = RxSet<int>(Set<int>.unmodifiable({1}));
    addTearDown(values.close);
    expect(() => values.add(2), throwsUnsupportedError);
  });
}

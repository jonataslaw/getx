import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('assignAll leaves the list untouched when the source throws', () {
    final list = RxList<int>([1, 2, 3]);

    Iterable<int> malformed() => [1, 2, 3].map((e) {
          if (e == 2) throw StateError('malformed row');
          return e;
        });

    expect(() => list.assignAll(malformed()), throwsA(isA<StateError>()));

    expect(
      list,
      [1, 2, 3],
      reason: 'MUTATION: consume the iterable after the clear (upstream) and '
          'this is [1] -- the list is emptied and half-refilled.',
    );
  });

  test('assignAll from a lazy view derived from the same list', () {
    final list = RxList<int>([1, 2, 3, 4]);

    // Upstream clears `list` first, so this lazy `where` then reads an empty
    // collection and the assignment drops everything.
    list.assignAll(list.where((e) => e.isEven));

    expect(
      list,
      [2, 4],
      reason: 'MUTATION: consume the iterable after the clear and this is [].',
    );
  });

  test('the ordinary cases are unchanged', () {
    final fromList = RxList<int>([1, 2, 3])..assignAll([9, 8]);
    expect(fromList, [9, 8]);

    final fromLazy = RxList<int>([1])..assignAll([1, 2, 3].map((e) => e * 10));
    expect(fromLazy, [10, 20, 30]);

    final emptied = RxList<int>([1, 2])..assignAll(<int>[]);
    expect(emptied, isEmpty);
  });

  test('assignAll still notifies listeners', () async {
    final list = RxList<int>([1]);
    final seen = <List<int>>[];
    ever<List<int>>(list, (v) => seen.add(List<int>.of(v)));

    list.assignAll([7, 8]);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(seen, isNotEmpty, reason: 'the refresh must still fire');
    expect(seen.last, [7, 8]);
  });
}

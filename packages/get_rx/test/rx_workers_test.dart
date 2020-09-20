import 'package:get_rx/get_rx.dart';
import 'package:test/test.dart';

void main() {
  test('once', () async {
    final count = 0.obs;
    var result = -1;
    once(count, (_) {
      result = _ as int;
    });
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
  });

  test('ever', () async {
    final count = 0.obs;
    var result = -1;
    ever(count, (_) {
      result = _ as int;
    });
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(2, result);
    count.value++;
    await Future.delayed(Duration.zero);
    expect(3, result);
  });

  test('debounce', () async {
    final count = 0.obs;
    var result = -1;
    debounce(count, (_) {
      // print(_);
      result = _ as int;
    }, time: Duration(milliseconds: 100));

    count.value++;
    count.value++;
    count.value++;
    count.value++;
    await Future.delayed(Duration.zero);
    expect(-1, result);
    await Future.delayed(Duration(milliseconds: 100));
    expect(4, result);
  });

  test('interval', () async {
    final count = 0.obs;
    var result = -1;
    interval(count, (_) {
      // print(_);
      result = _ as int;
    }, time: Duration(milliseconds: 100));

    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(1, result);
    count.value++;
    count.value++;
    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(2, result);
    count.value++;
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration(milliseconds: 100));
    expect(5, result);
  });
}

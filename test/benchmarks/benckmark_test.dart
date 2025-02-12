import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';

int times = 30;

Future<int> valueNotifier() {
  final c = Completer<int>();
  final value = ValueNotifier<int>(0);
  final timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (times == value.value) {
      timer.stop();
      debugPrint(
          """${value.value} listeners notified | [VALUE_NOTIFIER] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times + 1; i++) {
    value.value = i;
  }

  return c.future;
}

Future<int> getValue() {
  final c = Completer<int>();
  final value = Value<int>(0);
  final timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (times == value.value) {
      timer.stop();
      debugPrint(
          """${value.value} listeners notified | [GETX_VALUE] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times + 1; i++) {
    value.value = i;
  }

  return c.future;
}

Future<int> stream() {
  final c = Completer<int>();

  final value = StreamController<int>();
  final timer = Stopwatch();
  timer.start();

  value.stream.listen((v) {
    if (times == v) {
      timer.stop();
      debugPrint(
          """$v listeners notified | [STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
      value.close();
    }
  });

  for (var i = 0; i < times + 1; i++) {
    value.add(i);
  }

  return c.future;
}

Future<int> getStream() {
  final c = Completer<int>();

  final value = GetStream<int>();
  final timer = Stopwatch();
  timer.start();

  value.listen((v) {
    if (times == v) {
      timer.stop();
      debugPrint(
          """$v listeners notified | [GET_STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times + 1; i++) {
    value.add(i);
  }

  return c.future;
}

Future<int> miniStream() {
  final c = Completer<int>();

  final value = MiniStream<int>();
  final timer = Stopwatch();
  timer.start();

  value.listen((v) {
    if (times == v) {
      timer.stop();
      debugPrint(
          """$v listeners notified | [MINI_STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times + 1; i++) {
    value.add(i);
  }

  return c.future;
}

void main() {
  test('percentage test', () {
    debugPrint('============================================');
    debugPrint('PERCENTAGE TEST');

    const referenceValue = 200;
    const requestedValue = 100;

    debugPrint('''
referenceValue is ${calculePercentage(referenceValue, requestedValue)}% more than requestedValue''');
    expect(calculePercentage(referenceValue, requestedValue), 100);
  });
  test('run benchmarks from ValueNotifier', () async {
    times = 30;
    debugPrint('============================================');
    debugPrint('VALUE_NOTIFIER X GETX_VALUE TEST');
    debugPrint('-----------');
    await getValue();
    await valueNotifier();
    debugPrint('-----------');

    times = 30000;
    final getx = await getValue();
    final dart = await valueNotifier();
    debugPrint('-----------');

    debugPrint('ValueNotifier delay $dart ms to made $times requests');
    debugPrint('GetValue delay $getx ms to made $times requests');
    debugPrint('-----------');
    debugPrint('''
GetValue is ${calculePercentage(dart, getx).round()}% faster than Default ValueNotifier with $times requests''');
  });

  test('run benchmarks from Streams', () async {
    times = 30;
    debugPrint('============================================');
    debugPrint('DART STREAM X GET_STREAM X GET_MINI_STREAM TEST');
    debugPrint('-----------');
    var getx = await getStream();
    var mini = await miniStream();
    var dart = await stream();
    debugPrint('-----------');
    debugPrint('''
GetStream is ${calculePercentage(dart, mini).round()}% faster than Default Stream with $times requests''');
    debugPrint('-----------');

    times = 30000;
    dart = await stream();
    getx = await getStream();
    mini = await miniStream();

    times = 60000;
    dart = await stream();
    getx = await getStream();
    mini = await miniStream();
    debugPrint('-----------');
    debugPrint('dart_stream delay $dart ms to made $times requests');
    debugPrint('getx_stream delay $getx ms to made $times requests');
    debugPrint('getx_mini_stream delay $mini ms to made $times requests');
    debugPrint('-----------');
    debugPrint('''
GetStream is ${calculePercentage(dart, mini).round()}% faster than Default Stream with $times requests''');
  });
}

int calculePercentage(int dart, int getx) {
  return (dart / getx * 100).round() - 100;
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';

int times = 30;

void printValue(final String value) {
  // ignore: avoid_print
  print(value);
}

Future<int> valueNotifier() {
  final Completer<int> c = Completer<int>();
  final ValueNotifier<int> value = ValueNotifier<int>(0);
  final Stopwatch timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (times == value.value) {
      timer.stop();
      printValue(
        '''${value.value} listeners notified | [VALUE_NOTIFIER] time: ${timer.elapsedMicroseconds}ms''',
      );
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (int i = 0; i < times + 1; i++) {
    value.value = i;
  }

  return c.future;
}

Future<int> getValue() {
  final Completer<int> c = Completer<int>();
  final Value<int> value = Value<int>(0);
  final Stopwatch timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (times == value.value) {
      timer.stop();
      printValue(
        '''${value.value} listeners notified | [GETX_VALUE] time: ${timer.elapsedMicroseconds}ms''',
      );
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (int i = 0; i < times + 1; i++) {
    value.value = i;
  }

  return c.future;
}

Future<int> stream() {
  final Completer<int> c = Completer<int>();

  final StreamController<int> value = StreamController<int>();
  final Stopwatch timer = Stopwatch();
  timer.start();

  value.stream.listen((final int v) {
    if (times == v) {
      timer.stop();
      printValue(
        '''$v listeners notified | [STREAM] time: ${timer.elapsedMicroseconds}ms''',
      );
      c.complete(timer.elapsedMicroseconds);
      value.close();
    }
  });

  for (int i = 0; i < times + 1; i++) {
    value.add(i);
  }

  return c.future;
}

// Future<int> getStream() {
//   final c = Completer<int>();

//   final value = GetStream<int>();
//   final timer = Stopwatch();
//   timer.start();

//   value.listen((v) {
//     if (times == v) {
//       timer.stop();
//       printValue(
// """$v listeners notified |
// [GET_STREAM] time: ${timer.elapsedMicroseconds}ms""");
//       c.complete(timer.elapsedMicroseconds);
//     }
//   });

//   for (var i = 0; i < times + 1; i++) {
//     value.add(i);
//   }

//   return c.future;
// }

Future<int> miniStream() {
  final Completer<int> c = Completer<int>();

  final MiniStream<int> value = MiniStream<int>();
  final Stopwatch timer = Stopwatch();
  timer.start();

  value.listen((final int v) {
    if (times == v) {
      timer.stop();
      printValue(
        '''$v listeners notified | [MINI_STREAM] time: ${timer.elapsedMicroseconds}ms''',
      );
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (int i = 0; i < times + 1; i++) {
    value.add(i);
  }

  return c.future;
}

void main() {
  test('percentage test', () {
    printValue('============================================');
    printValue('PERCENTAGE TEST');

    const int referenceValue = 200;
    const int requestedValue = 100;

    printValue('''
referenceValue is ${calculePercentage(referenceValue, requestedValue)}% more than requestedValue''');
    expect(calculePercentage(referenceValue, requestedValue), 100);
  });
  test('run benchmarks from ValueNotifier', () async {
    times = 30;
    printValue('============================================');
    printValue('VALUE_NOTIFIER X GETX_VALUE TEST');
    printValue('-----------');
    await getValue();
    await valueNotifier();
    printValue('-----------');

    times = 30000;
    final int getx = await getValue();
    final int dart = await valueNotifier();
    printValue('-----------');

    printValue('ValueNotifier delay $dart ms to made $times requests');
    printValue('GetValue delay $getx ms to made $times requests');
    printValue('-----------');
    printValue('''
GetValue is ${calculePercentage(dart, getx)}% faster than Default ValueNotifier with $times requests''');
  });

  test('run benchmarks from Streams', () async {
    times = 30;
    printValue('============================================');
    printValue('DART STREAM X GET_STREAM X GET_MINI_STREAM TEST');
    printValue('-----------');
    // var getx = await getStream();
    int mini = await miniStream();
    int dart = await stream();
    printValue('-----------');
    printValue('''
GetStream is ${calculePercentage(dart, mini)}% faster than Default Stream with $times requests''');
    printValue('-----------');

    times = 30000;
    dart = await stream();
    // getx = await getStream();
    mini = await miniStream();

    times = 60000;
    dart = await stream();
    // getx = await getStream();
    mini = await miniStream();
    printValue('-----------');
    printValue('dart_stream delay $dart ms to made $times requests');
    // printValue('getx_stream delay $getx ms to made $times requests');
    printValue('getx_mini_stream delay $mini ms to made $times requests');
    printValue('-----------');
    printValue('''
GetStream is ${calculePercentage(dart, mini)}% faster than Default Stream with $times requests''');
  });
}

int calculePercentage(final int dart, final int getx) {
  return (dart / getx * 100).round() - 100;
}

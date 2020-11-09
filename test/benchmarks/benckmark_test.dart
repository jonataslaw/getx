import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';

int times = 3;
int get last => times - 1;

Future<int> valueNotifier() {
  final c = Completer<int>();
  final value = ValueNotifier<int>(0);
  final timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (last == value.value) {
      timer.stop();
      print(
          """${value.value} listeners notified | [VALUE_NOTIFIER] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times; i++) {
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
    if (last == value.value) {
      timer.stop();
      print(
          """${value.value} listeners notified | [GETX_VALUE] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times; i++) {
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
    if (last == v) {
      timer.stop();
      print(
          """$v listeners notified | [STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times; i++) {
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
    if (last == v) {
      timer.stop();
      print(
          """$v listeners notified | [GET_STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times; i++) {
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
    if (last == v) {
      timer.stop();
      print(
          """$v listeners notified | [MINI_STREAM] time: ${timer.elapsedMicroseconds}ms""");
      c.complete(timer.elapsedMicroseconds);
    }
  });

  for (var i = 0; i < times; i++) {
    value.add(i);
  }

  return c.future;
}

void main() async {
  test('run benchmarks from ValueNotifier', () async {
    await getValue();
    await valueNotifier();

    times = 30000;
    await getValue();
    await valueNotifier();
  });

  test('percentage test', () {
    final referenceValue = 200;
    final requestedValue = 100;

    print('''
referenceValue is ${calculePercentage(referenceValue, requestedValue)}% more than requestedValue''');
    expect(calculePercentage(referenceValue, requestedValue), 100);
  });

  test('run benchmarks from Streams', () async {
    var dart = await stream();
    var getx = await getStream();
    var mini = await miniStream();
    print('''
GetStream is ${calculePercentage(dart, getx).round()}% more fast than Default Stream with $last listeners''');
    times = 30000;
    dart = await stream();
    getx = await getStream();
    mini = await miniStream();

    print('dart is $dart');
    print('getx is $getx');
    print('mini is $mini');
    print('''
GetStream is ${calculePercentage(dart, getx).round()}% more fast than Default Stream with $last listeners''');
  });
}

int calculePercentage(int dart, int getx) {
  return (dart / getx * 100).round() - 100;
}

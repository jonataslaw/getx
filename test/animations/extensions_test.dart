import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('Animation Extension', () {
    Widget buildWidget() {
      return Container(
        width: 100,
        height: 100,
        color: Colors.red,
      );
    }

    testWidgets('fadeIn() and fadeOut() can not be used sequentially',
        (WidgetTester tester) async {
      final widget = buildWidget();

      expect(() => widget.fadeIn().fadeOut(), throwsAssertionError);
      expect(() => widget.fadeOut().fadeIn(), throwsAssertionError);

      expect(() => widget.fadeIn(isSequential: true).fadeOut(),
          throwsAssertionError);
      expect(() => widget.fadeOut(isSequential: true).fadeIn(),
          throwsAssertionError);
    });

    testWidgets('can not use delay when isSequential is true',
        (WidgetTester tester) async {
      final widget = buildWidget();

      expect(
          () => widget.fadeIn(
              isSequential: true, delay: const Duration(seconds: 1)),
          throwsAssertionError);
    });

    testWidgets(
        'fadeIn() and fadeOut() can be used together when isSequential is true',
        (WidgetTester tester) async {
      final widget = buildWidget();

      expect(
          () => widget.fadeIn(isSequential: true).fadeOut(isSequential: true),
          isNot(throwsException));

      expect(() => widget.fadeIn().fadeOut(isSequential: true),
          isNot(throwsException));
    });

    testWidgets('fadeIn() returns a FadeInAnimation',
        (WidgetTester tester) async {
      final widget = buildWidget();
      const begin = 0.0;
      const end = 1.0;
      final animation = widget.fadeIn();

      expect(animation, isA<FadeInAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('fadeOut() returns a animation', (WidgetTester tester) async {
      final widget = buildWidget();
      const begin = 1.0;
      const end = 0.0;
      final animation = widget.fadeOut();

      expect(animation, isA<FadeOutAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('rotate() returns a RotateAnimation',
        (WidgetTester tester) async {
      const begin = 0.9;
      const end = 1.1;
      final widget = buildWidget();
      final animation = widget.rotate(begin: begin, end: end);

      expect(animation, isA<RotateAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('scale() returns a ScaleAnimation',
        (WidgetTester tester) async {
      const begin = 0.9;
      const end = 1.1;
      final widget = buildWidget();
      final animation = widget.scale(begin: begin, end: end);

      expect(animation, isA<ScaleAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('slide() returns a SlideAnimation',
        (WidgetTester tester) async {
      const begin = 0;
      const end = 1;
      final widget = buildWidget();
      final animation = widget.slide(offset: (_, __) => const Offset(0, 0));

      expect(animation, isA<SlideAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('bounce() returns a BounceAnimation',
        (WidgetTester tester) async {
      const begin = 0.9;
      const end = 1.1;
      final widget = buildWidget();
      final animation = widget.bounce(begin: begin, end: end);

      expect(animation, isA<BounceAnimation>());

      _testDefaultValues(
        animation: animation,
        widget: widget,
        begin: begin,
        end: end,
        curve: Curves.bounceOut,
      );
    });

    testWidgets('spin() returns a SpinAnimation', (WidgetTester tester) async {
      final widget = buildWidget();
      const begin = 0.0;
      const end = 360;
      final animation = widget.spin();

      expect(animation, isA<SpinAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('size() returns a SizeAnimation', (WidgetTester tester) async {
      final widget = buildWidget();

      const begin = 0.9;
      const end = 1.1;
      final animation = widget.size(begin: begin, end: end);

      expect(animation, isA<SizeAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('blur() returns a BlurAnimation', (WidgetTester tester) async {
      final widget = buildWidget();

      const begin = 0.9;
      const end = 1.1;
      final animation = widget.blur(begin: begin, end: end);

      expect(animation, isA<BlurAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('flip() returns a FlipAnimation', (WidgetTester tester) async {
      final widget = buildWidget();

      const begin = 0.9;
      const end = 1.1;
      final animation = widget.flip(begin: begin, end: end);

      expect(animation, isA<FlipAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });

    testWidgets('wave() returns a FlipAnimation', (WidgetTester tester) async {
      final widget = buildWidget();

      const begin = 0.9;
      const end = 1.1;
      final animation = widget.wave(begin: begin, end: end);

      expect(animation, isA<WaveAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end);
    });
  });
}

void _testDefaultValues<T>({
  required GetAnimatedBuilder animation,
  required Widget widget,
  required T begin,
  required T end,
  Curve curve = Curves.linear,
}) {
  expect(animation.tween.begin, begin);
  expect(animation.tween.end, end);
  if (animation.idleValue is Offset) {
    expect(animation.idleValue, Offset.zero);
  } else if (animation is FadeOutAnimation) {
    expect(animation.idleValue, 1);
  } else {
    expect(animation.idleValue, 0);
  }

  expect(animation.delay, Duration.zero);
  expect(animation.child, widget);
  expect(animation.curve, curve);
}

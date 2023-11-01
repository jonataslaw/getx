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
        (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      expect(() => widget.fadeIn().fadeOut(), throwsAssertionError);
      expect(() => widget.fadeOut().fadeIn(), throwsAssertionError);

      expect(() => widget.fadeIn(isSequential: true).fadeOut(),
          throwsAssertionError,);
      expect(() => widget.fadeOut(isSequential: true).fadeIn(),
          throwsAssertionError,);
    });

    testWidgets('can not use delay when isSequential is true',
        (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      expect(
          () => widget.fadeIn(
              isSequential: true, delay: const Duration(seconds: 1),),
          throwsAssertionError,);
    });

    testWidgets(
        'fadeIn() and fadeOut() can be used together when isSequential is true',
        (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      expect(
          () => widget.fadeIn(isSequential: true).fadeOut(isSequential: true),
          isNot(throwsException),);

      expect(() => widget.fadeIn().fadeOut(isSequential: true),
          isNot(throwsException),);
    });

    testWidgets('fadeIn() returns a FadeInAnimation',
        (final WidgetTester tester) async {
      final Widget widget = buildWidget();
      const double begin = 0.0;
      const double end = 1.0;
      final FadeInAnimation animation = widget.fadeIn();

      expect(animation, isA<FadeInAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('fadeOut() returns a animation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();
      const double begin = 1.0;
      const double end = 0.0;
      final FadeOutAnimation animation = widget.fadeOut();

      expect(animation, isA<FadeOutAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('rotate() returns a RotateAnimation',
        (final WidgetTester tester) async {
      const double begin = 0.9;
      const double end = 1.1;
      final Widget widget = buildWidget();
      final RotateAnimation animation = widget.rotate(begin: begin, end: end);

      expect(animation, isA<RotateAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('scale() returns a ScaleAnimation',
        (final WidgetTester tester) async {
      const double begin = 0.9;
      const double end = 1.1;
      final Widget widget = buildWidget();
      final ScaleAnimation animation = widget.scale(begin: begin, end: end);

      expect(animation, isA<ScaleAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('slide() returns a SlideAnimation',
        (final WidgetTester tester) async {
      const int begin = 0;
      const int end = 1;
      final Widget widget = buildWidget();
      final SlideAnimation animation =
          widget.slide(offset: (final _, final __) => Offset.zero);

      expect(animation, isA<SlideAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('bounce() returns a BounceAnimation',
        (final WidgetTester tester) async {
      const double begin = 0.9;
      const double end = 1.1;
      final Widget widget = buildWidget();
      final BounceAnimation animation = widget.bounce(begin: begin, end: end);

      expect(animation, isA<BounceAnimation>());

      _testDefaultValues(
        animation: animation,
        widget: widget,
        begin: begin,
        end: end,
        curve: Curves.bounceOut,
      );
    });

    testWidgets('spin() returns a SpinAnimation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();
      const double begin = 0.0;
      const int end = 360;
      final SpinAnimation animation = widget.spin();

      expect(animation, isA<SpinAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('size() returns a SizeAnimation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      const double begin = 0.9;
      const double end = 1.1;
      final SizeAnimation animation = widget.size(begin: begin, end: end);

      expect(animation, isA<SizeAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('blur() returns a BlurAnimation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      const double begin = 0.9;
      const double end = 1.1;
      final BlurAnimation animation = widget.blur(begin: begin, end: end);

      expect(animation, isA<BlurAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('flip() returns a FlipAnimation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      const double begin = 0.9;
      const double end = 1.1;
      final FlipAnimation animation = widget.flip(begin: begin, end: end);

      expect(animation, isA<FlipAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });

    testWidgets('wave() returns a FlipAnimation', (final WidgetTester tester) async {
      final Widget widget = buildWidget();

      const double begin = 0.9;
      const double end = 1.1;
      final WaveAnimation animation = widget.wave(begin: begin, end: end);

      expect(animation, isA<WaveAnimation>());

      _testDefaultValues(
          animation: animation, widget: widget, begin: begin, end: end,);
    });
  });
}

void _testDefaultValues<T>({
  required final GetAnimatedBuilder<T> animation,
  required final Widget widget,
  required final T begin,
  required final T end,
  final Curve curve = Curves.linear,
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

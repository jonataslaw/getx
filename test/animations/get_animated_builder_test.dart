import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child});
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}

void main() {
  testWidgets('GetAnimatedBuilder defaults', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (final _, final value, final __) => Text(value.toString()),
          delay: Duration.zero,
          child: Container(),
        ),
      ),
    );

    // Verify that the widget starts with the idle value.
    expect(find.text('0'), findsOneWidget);

    // Wait for the animation to complete.
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Verify that the widget ends with the final value.
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('GetAnimatedBuilder changes value over time', (final tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          idleValue: 0.0,
          builder: (final context, final value, final child) {
            return Opacity(opacity: value);
          },
          delay: const Duration(milliseconds: 500),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
        ),
      ),
    );

    // Initial state is idleValue
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.0);

    // Wait for the delay to finish
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the value changes over time
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.2, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.4, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.6, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.8, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(1.0, 0.01));
  });

  testWidgets('onComplete callback is called when animation finishes',
      (final WidgetTester tester) async {
    AnimationController? controller;
    var onCompleteCalled = false;

    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (final _, final value, final __) => Text(value.toString()),
          delay: Duration.zero,
          onComplete: (final c) {
            onCompleteCalled = true;
            controller = c;
          },
          child: Container(),
        ),
      ),
    );

    expect(onCompleteCalled, isFalse);

    // Wait for the animation to complete.
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Verify that the onComplete callback was called.
    expect(controller, isNotNull);

    expect(onCompleteCalled, isTrue);
  });

  testWidgets('onStart callback is called when animation starts',
      (final WidgetTester tester) async {
    var onStartCalled = false;

    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          tween: Tween<double>(begin: 0, end: 1),
          idleValue: 0,
          builder: (final context, final value, final child) => Container(),
          child: Container(),
          onStart: (final _) {
            onStartCalled = true;
          },
        ),
      ),
    );

    expect(onStartCalled, isFalse);

    await tester.pump(const Duration(milliseconds: 500));
    expect(onStartCalled, isTrue);
  });

  testWidgets('GetAnimatedBuilder delay', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (final _, final value, final __) => Text(value.toString()),
          delay: const Duration(milliseconds: 500),
          child: Container(),
        ),
      ),
    );

    // Verify that the widget starts with the idle value.
    expect(find.text('0'), findsOneWidget);

    // Wait for the delay to pass.
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the animation has started.
    expect(find.text('0'), findsOneWidget);

    // Wait for the animation to complete.
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Verify that the widget ends with the final value.
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets(
      'FadeInAnimation in idle should be visible, but not visible when the animation starts',
      (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: FadeInAnimation(
          delay: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500),
          idleValue: 0,
          child: const Text('Hello'),
        ),
      ),
    );

    // in idle, the opacity should be 1.0
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1.0);

    // Wait for the delay to finish
    await tester.pump(const Duration(milliseconds: 500));

    // When the animation starts the opacity should not be visible
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.0);

    // Verify that the value changes over time
    await tester.pump(const Duration(milliseconds: 100));

    // The value should be updated
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.2, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.4, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.6, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.8, 0.01));

    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(1.0, 0.01));
  });

  testWidgets(
      'willResetOnDispose should false when fadeOut is the last animation in a sequential animation',
      (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: const Text('Hello')
            .fadeIn(
              isSequential: true,
              duration: const Duration(milliseconds: 500),
            )
            .fadeOut(
              isSequential: true,
              duration: const Duration(milliseconds: 500),
            ),
      ),
    );

    // The variable starts as false
    expect(
        tester
            .state<GetAnimatedBuilderState>(find.byType(FadeOutAnimation))
            .willResetOnDispose,
        false);

    // Jump to middle of next animation
    await tester.pump(const Duration(milliseconds: 500));

    // The value should be false
    expect(
        tester
            .state<GetAnimatedBuilderState>(find.byType(FadeOutAnimation))
            .willResetOnDispose,
        false);

    await tester.pumpAndSettle();
  });

  testWidgets(
      'willResetOnDispose should true when fadeOut is not last animation in a sequential animation',
      (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: const Text('Hello')
            .fadeOut(
              isSequential: true,
              duration: const Duration(milliseconds: 500),
            )
            .fadeIn(
              isSequential: true,
              duration: const Duration(milliseconds: 500),
            ),
      ),
    );

    // The variable starts as true
    expect(
        tester
            .state<GetAnimatedBuilderState>(find.byType(FadeOutAnimation))
            .willResetOnDispose,
        true);

    // Jump to middle of next animation
    await tester.pump(const Duration(milliseconds: 500));

    // The value should be true
    expect(
        tester
            .state<GetAnimatedBuilderState>(find.byType(FadeOutAnimation))
            .willResetOnDispose,
        true);

    await tester.pumpAndSettle();
  });

  testWidgets('RotateAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      RotateAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 0.0,
        end: 360.0,
        child: Container(),
      ),
    );
    expect(find.byType(RotateAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('ScaleAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      ScaleAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(ScaleAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('WaveAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      WaveAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(WaveAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('WobbleAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      WobbleAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(WobbleAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SlideAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      SlideAnimation(
        offsetBuild: (final p0, final p1) => const Offset(1.0, 1.0),
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 0,
        end: 1,
        child: Container(),
      ),
    );
    expect(find.byType(SlideAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SlideInLeftAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: SlideInLeftAnimation(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          begin: 1.0,
          end: 2.0,
          child: Container(),
        ),
      ),
    );
    expect(find.byType(SlideInLeftAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SlideInRightAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: SlideInRightAnimation(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          begin: 1.0,
          end: 2.0,
          child: Container(),
        ),
      ),
    );
    expect(find.byType(SlideInRightAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SlideInUpAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: SlideInUpAnimation(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          begin: 1.0,
          end: 2.0,
          child: Container(),
        ),
      ),
    );
    expect(find.byType(SlideInUpAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SlideInDownAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: SlideInDownAnimation(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          begin: 1.0,
          end: 2.0,
          child: Container(),
        ),
      ),
    );
    expect(find.byType(SlideInDownAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('BounceAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      BounceAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 0.0,
        end: 1.0,
        child: Container(),
      ),
    );
    expect(find.byType(BounceAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SpinAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      SpinAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        child: Container(),
      ),
    );
    expect(find.byType(SpinAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('ColorAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      ColorAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: Colors.blue,
        end: Colors.red,
        child: Container(),
      ),
    );
    expect(find.byType(ColorAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('SizeAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      SizeAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(SizeAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('BlurAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      BlurAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(BlurAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('FlipAnimation', (final WidgetTester tester) async {
    await tester.pumpWidget(
      FlipAnimation(
        duration: const Duration(seconds: 1),
        delay: Duration.zero,
        begin: 1.0,
        end: 2.0,
        child: Container(),
      ),
    );
    expect(find.byType(FlipAnimation), findsOneWidget);
    await tester.pumpAndSettle();
  });
}

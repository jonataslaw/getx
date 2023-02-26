import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Wrapper extends StatelessWidget {
  const _Wrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}

void main() {
  testWidgets('GetAnimatedBuilder defaults', (WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (_, value, __) => Text(value.toString()),
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

  testWidgets('GetAnimatedBuilder changes value over time', (tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          idleValue: 0.0,
          builder: (context, value, child) {
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
      (WidgetTester tester) async {
    AnimationController? controller;
    var onCompleteCalled = false;

    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (_, value, __) => Text(value.toString()),
          delay: Duration.zero,
          onComplete: (c) {
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
      (WidgetTester tester) async {
    var onStartCalled = false;

    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder(
          duration: const Duration(seconds: 1),
          delay: Duration.zero,
          tween: Tween<double>(begin: 0, end: 1),
          idleValue: 0,
          builder: (context, value, child) => Container(),
          child: Container(),
          onStart: (_) {
            onStartCalled = true;
          },
        ),
      ),
    );

    expect(onStartCalled, isFalse);

    await tester.pump(const Duration(milliseconds: 500));
    expect(onStartCalled, isTrue);
  });

  testWidgets('GetAnimatedBuilder delay', (WidgetTester tester) async {
    await tester.pumpWidget(
      _Wrapper(
        child: GetAnimatedBuilder<int>(
          duration: const Duration(milliseconds: 500),
          tween: Tween(begin: 0, end: 10),
          idleValue: 0,
          builder: (_, value, __) => Text(value.toString()),
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
      (WidgetTester tester) async {
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
      (WidgetTester tester) async {
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
      (WidgetTester tester) async {
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

  testWidgets('RotateAnimation', (WidgetTester tester) async {
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

  testWidgets('ScaleAnimation', (WidgetTester tester) async {
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

  testWidgets('WaveAnimation', (WidgetTester tester) async {
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

  testWidgets('WobbleAnimation', (WidgetTester tester) async {
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

  testWidgets('SlideAnimation', (WidgetTester tester) async {
    await tester.pumpWidget(
      SlideAnimation(
        offsetBuild: (p0, p1) => const Offset(1.0, 1.0),
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

  testWidgets('SlideInLeftAnimation', (WidgetTester tester) async {
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

  testWidgets('SlideInRightAnimation', (WidgetTester tester) async {
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

  testWidgets('SlideInUpAnimation', (WidgetTester tester) async {
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

  testWidgets('SlideInDownAnimation', (WidgetTester tester) async {
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

  testWidgets('BounceAnimation', (WidgetTester tester) async {
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

  testWidgets('SpinAnimation', (WidgetTester tester) async {
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

  testWidgets('ColorAnimation', (WidgetTester tester) async {
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

  testWidgets('SizeAnimation', (WidgetTester tester) async {
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

  testWidgets('BlurAnimation', (WidgetTester tester) async {
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

  testWidgets('FlipAnimation', (WidgetTester tester) async {
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

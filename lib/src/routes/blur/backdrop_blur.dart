import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RippleBackdropAnimatePage extends StatefulWidget {
  const RippleBackdropAnimatePage({
    Key key,
    this.child,
    this.childFade = false,
    this.duration = 300,
    this.blurRadius = 15.0,
    this.bottomButton,
    this.bottomHeight = kBottomNavigationBarHeight,
    this.bottomButtonRotate = true,
    this.bottomButtonRotateDegree = 45.0,
  }) : super(key: key);

  /// Child for page.
  final Widget child;

  /// When enabled, [child] will fade in when animation is going and fade out when popping.
  /// [false] is by default.
  final bool childFade;

  /// Animation's duration,
  /// including [Navigator.push], [Navigator.pop].
  final int duration;

  /// Blur radius for [BackdropFilter].
  final double blurRadius;

  /// [Widget] for bottom of the page.
  final Widget bottomButton;

  /// The height which [bottomButton] will occupy.
  /// [kBottomNavigationBarHeight] is by default.
  final double bottomHeight;

  /// When enabled, [bottomButton] will rotate when to animation is going.
  /// [true] is by default.
  final bool bottomButtonRotate;

  /// The degree which [bottomButton] will rotate.
  /// 45.0 is by default.
  final double bottomButtonRotateDegree;

  @override
  _RippleBackdropAnimatePageState createState() =>
      _RippleBackdropAnimatePageState();
}

class _RippleBackdropAnimatePageState extends State<RippleBackdropAnimatePage>
    with TickerProviderStateMixin {
  /// Boolean to prevent duplicate pop.
  bool _popping = false;

  /// Animation.
  int _animateDuration;
  double _backdropFilterSize = 0.0;
  double _popButtonOpacity = 0.0;
  double _popButtonRotateAngle = 0.0;
  Animation<double> _backDropFilterAnimation;
  AnimationController _backDropFilterController;
  Animation<double> _popButtonAnimation;
  AnimationController _popButtonController;
  Animation<double> _popButtonOpacityAnimation;
  AnimationController _popButtonOpacityController;

  @override
  void initState() {
    _animateDuration = widget.duration;
    SchedulerBinding.instance
        .addPostFrameCallback((_) => backDropFilterAnimate(context, true));
    super.initState();
  }

  @override
  void dispose() {
    _backDropFilterController?.dispose();
    _popButtonController?.dispose();
    super.dispose();
  }

  double pythagoreanTheorem(double short, double long) {
    return math.sqrt(math.pow(short, 2) + math.pow(long, 2));
  }

  void popButtonAnimate(context, bool forward) {
    if (!forward) {
      _popButtonController?.stop();
      _popButtonOpacityController?.stop();
    }
    final double rotateDegree =
        widget.bottomButtonRotateDegree * (math.pi / 180) * 3;

    _popButtonOpacityController = _popButtonController = AnimationController(
      duration: Duration(milliseconds: _animateDuration),
      vsync: this,
    );
    Animation _popButtonCurve = CurvedAnimation(
      parent: _popButtonController,
      curve: Curves.easeInOut,
    );
    _popButtonAnimation = Tween(
      begin: forward ? 0.0 : _popButtonRotateAngle,
      end: forward ? rotateDegree : 0.0,
    ).animate(_popButtonCurve)
      ..addListener(() {
        setState(() {
          _popButtonRotateAngle = _popButtonAnimation.value;
        });
      });
    _popButtonOpacityAnimation = Tween(
      begin: forward ? 0.0 : _popButtonOpacity,
      end: forward ? 1.0 : 0.0,
    ).animate(_popButtonCurve)
      ..addListener(() {
        setState(() {
          _popButtonOpacity = _popButtonOpacityAnimation.value;
        });
      });
    _popButtonController.forward();
    _popButtonOpacityController.forward();
  }

  Future backDropFilterAnimate(BuildContext context, bool forward) async {
    final MediaQueryData m = MediaQuery.of(context);
    final Size s = m.size;
    final double r =
        pythagoreanTheorem(s.width, s.height * 2 + m.padding.top) / 2;
    if (!forward) _backDropFilterController?.stop();
    popButtonAnimate(context, forward);

    _backDropFilterController = AnimationController(
      duration: Duration(milliseconds: _animateDuration),
      vsync: this,
    );
    Animation _backDropFilterCurve = CurvedAnimation(
      parent: _backDropFilterController,
      curve: forward ? Curves.easeInOut : Curves.easeIn,
    );
    _backDropFilterAnimation = Tween(
      begin: forward ? 0.0 : _backdropFilterSize,
      end: forward ? r * 2 : 0.0,
    ).animate(_backDropFilterCurve)
      ..addListener(() {
        setState(() {
          _backdropFilterSize = _backDropFilterAnimation.value;
        });
      });
    await _backDropFilterController.forward();
  }

  Widget popButton() {
    Widget button = widget.bottomButton ?? Icon(Icons.add, color: Colors.grey);
    if (widget.bottomButtonRotate) {
      button = Transform.rotate(
        angle: _popButtonRotateAngle,
        child: button,
      );
    }
    button = Opacity(
      opacity: _popButtonOpacity,
      child: SizedBox(
        width: widget.bottomHeight,
        height: widget.bottomHeight,
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: button,
            onTap: willPop,
          ),
        ),
      ),
    );

    return button;
  }

  Widget wrapper(context, {Widget child}) {
    final MediaQueryData m = MediaQuery.of(context);
    final Size s = m.size;
    final double r =
        pythagoreanTheorem(s.width, s.height * 2 + m.padding.top) / 2;
    final double topOverflow = r - s.height;
    final double horizontalOverflow = r - s.width;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          left: -horizontalOverflow,
          right: -horizontalOverflow,
          top: -topOverflow,
          bottom: -r,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: willPop,
            child: Center(
              child: SizedBox(
                width: _backdropFilterSize,
                height: _backdropFilterSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r * 2),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: widget.blurRadius,
                      sigmaY: widget.blurRadius,
                    ),
                    child: Text(" "),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: topOverflow + 10),
            width: s.width,
            height: s.height,
            constraints: BoxConstraints(
              maxWidth: s.width,
              maxHeight: s.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Opacity(
                    opacity: widget.childFade ? _popButtonOpacity : 1.0,
                    child: child,
                  ),
                ),
                popButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> willPop() async {
    await backDropFilterAnimate(context, false);
    if (!_popping) {
      _popping = true;
      await Future.delayed(Duration(milliseconds: _animateDuration), () {
        Navigator.of(context).pop();
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: willPop,
        child: wrapper(
          context,
          child: widget.child,
        ),
      ),
    );
  }
}

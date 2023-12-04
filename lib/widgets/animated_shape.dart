import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/utils/enums.dart';
import 'dart:math' as math;

/// Render an animated widget based on the animation type given and with
/// a given child widget
///
class AnimatedShape extends StatefulWidget {
  AnimatedShape({
    Key? key,
    required this.shape,
    required this.height,
    this.animationType = AnimationType.none,
    this.animationValue = 1,
    // this.animationOffset,
    this.animationController,
  }) : super(key: key) {
    if (animationType == AnimationType.rotate) {
      assert(animationController != null);
    }
  }

  ///the shape child that will be wrapped with the animated widget
  ///
  final Widget shape;

  ///animation that will be set when navigating between navigation bar items
  ///possible values
  ///```dart
  ///[
  /// NONE,
  /// FADE,
  /// SLIDE_VERTICALLY,
  /// ROTATE
  ///]
  ///```
  ///
  final AnimationType animationType;

  ///Animation value used as an opacity if the animation is [AnimationType.fade]
  ///
  final double animationValue;

  ///Animation offset used if the [animationType] equal [AnimationType.slideVertically]
  ///
  // final Animation<Offset>? animationOffset;

  ///Animation controller used if the [animationType] equal [AnimationType.rotate]
  ///
  final AnimationController? animationController;
  final double height;

  @override
  State<AnimatedShape> createState() => _AnimatedShapeState();
}

class _AnimatedShapeState extends State<AnimatedShape>
    with SingleTickerProviderStateMixin {
  late AnimationController? slideController;
  late Animation<double>? _offsetAnimation;

  @override
  void initState() {
    slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _offsetAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: slideController!, curve: Curves.ease),
    );

    slideController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation!,
      builder: (context, child) {
        return Positioned(
          top: widget.animationType == AnimationType.slideVertically
              ? _offsetAnimation!.value
              : 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: widget.height,
            child: _renderAnimatedShape(),
          ),
        );
      },
    );
  }

  Widget _renderAnimatedShape() {
    switch (widget.animationType) {
      case AnimationType.fade:
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.animationValue,
          child: widget.shape,
        );
      case AnimationType.slideVertically:
        return widget.shape;
      case AnimationType.rotate:
        return AnimatedBuilder(
          animation: widget.animationController!,
          builder: (_, child) {
            return Transform.rotate(
              angle: widget.animationController!.value * 2 * math.pi,
              child: child,
            );
          },
          child: widget.shape,
        );
      default:
        return widget.shape;
    }
  }
}

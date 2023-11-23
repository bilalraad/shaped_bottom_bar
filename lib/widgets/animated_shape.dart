import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/utils/enums.dart';
import 'dart:math' as math;

/// Render an animated widget based on the animation type given and with
/// a given child widget
///
class AnimatedShape extends StatelessWidget {
  AnimatedShape({
    Key? key,
    required this.shape,
    this.animationType = AnimationType.none,
    this.animationValue = 1,
    this.animationOffset,
    this.animationController,
  }) : super(key: key) {
    if (animationType == AnimationType.slideVertically) {
      assert(animationOffset != null);
    } else if (animationType == AnimationType.rotate) {
      assert(animationController != null);
    }
  }

  ///the shape child that will be wraped with the animated widget
  ///
  final Widget shape;

  ///aimation that will be set when navigating between navigation bar items
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
  final Animation<Offset>? animationOffset;

  ///Animation controller used if the [animationType] equal [AnimationType.rotate]
  ///
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return _renderAnimatedShape();
  }

  Widget _renderAnimatedShape() {
    switch (animationType) {
      case AnimationType.fade:
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: animationValue,
          child: shape,
        );
      case AnimationType.slideVertically:
        return SlideTransition(
          position: animationOffset!,
          child: shape,
        );
      case AnimationType.rotate:
        return AnimatedBuilder(
          animation: animationController!,
          builder: (_, child) {
            return Transform.rotate(
              angle: animationController!.value * 2 * math.pi,
              child: child,
            );
          },
          child: shape,
        );
      default:
        return shape;
    }
  }
}

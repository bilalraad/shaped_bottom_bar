import 'package:flutter/material.dart';

/// Render an animated widget based on the animation type given and with
/// a given child widget
///
class AnimatedShape extends StatefulWidget {
  const AnimatedShape({
    Key? key,
    required this.shape,
    required this.height,
  }) : super(key: key);

  ///the shape child that will be wrapped with the animated widget
  ///
  final Widget shape;

  ///Animation offset used if the [animationType] equal [AnimationType.slideVertically]
  ///
  // final Animation<Offset>? animationOffset;

  ///Animation controller used if the [animationType] equal [AnimationType.rotate]
  ///
  final double height;

  @override
  State<AnimatedShape> createState() => _AnimatedShapeState();
}

class _AnimatedShapeState extends State<AnimatedShape>
    with SingleTickerProviderStateMixin {
  late final AnimationController slideController;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    _offsetAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: slideController, curve: Curves.ease),
    );

    slideController.forward();
    super.initState();
  }

  @override
  void dispose() {
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Positioned(
          top: _offsetAnimation.value,
          left: 0,
          right: 0,
          child: SizedBox(
            height: widget.height,
            child: widget.shape,
          ),
        );
      },
    );
  }
}

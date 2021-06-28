import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/paint/draw_hexagon.dart';

///genreates a Hexagon shape widget with the given [child] in the center of the hexagon
///[child] is a required parameter
///
///
/// [background] : optional parameter used to change the background of the Hexagon
/// [size] : optional parameter by default it's 50
class HexagonShape extends StatelessWidget {
  final double size;
  final Color background;
  final Widget child;
  final bool with3DEffect;

  HexagonShape(
      {required this.child,
      this.background = Colors.white,
      this.size = 50,
      this.with3DEffect = false});

  @override
  Widget build(BuildContext context) {
    return renderShape();
  }

  Widget renderShape() {
    return CustomPaint(
      size: Size(this.size, this.size),
      painter: DrawHexagon(
          background: this.background, with3DEffect: this.with3DEffect),
      child: this.child,
    );
  }
}

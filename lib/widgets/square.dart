import 'package:flutter/material.dart';
import 'package:shaped_bottom_bar/paint/paint_square.dart';

///genreates a Square shape widget with the given [child] in the center of the Square
///[child] is a required parameter
///
///
/// [background] : optional parameter used to change the background of the Square
/// [size] : optional parameter by default it's 50
class SquareShape extends StatelessWidget {
  final double size;
  final Color background;
  final Widget child;
  final bool with3DEffect;

  SquareShape(
      {this.background = Colors.black,
      required this.child,
      this.size = 50,
      this.with3DEffect = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(this.size, this.size),
        painter: PaintSquare(
            backgroundColor: this.background, with3dEffect: this.with3DEffect),
        child: this.child,
      ),
    );
  }
}

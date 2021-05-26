import 'package:flutter/material.dart';

class DrawHexagon extends CustomPainter {
  final Color? background;

  DrawHexagon({this.background = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = this.background ?? Colors.black
      ..style = PaintingStyle.fill;

    Path path_0 = renderHexagon(size);
    canvas.drawPath(path_0, paint_0);
  }

  Path renderHexagon(Size size) {
    final path = Path();
    path.lineTo((size.width * 0.5), size.height * 0.1);
    path.lineTo(0, (size.height * 0.3));
    path.lineTo(0, (size.height * 0.7));
    path.lineTo((size.width * 0.5), size.height * 0.9);
    path.lineTo(size.width, (size.height * 0.7));
    path.lineTo(size.width, (size.height * 0.3));
    path.lineTo((size.width * 0.5), size.height * 0.1);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

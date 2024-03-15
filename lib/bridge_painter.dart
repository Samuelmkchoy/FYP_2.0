import 'package:flutter/material.dart';

import 'try.dart';

class BridgePainter extends CustomPainter {
  List<Offset> bridgePoints;

  BridgePainter({required this.bridgePoints});

@override
void paint(Canvas canvas, Size size) {
  drawGrid(canvas, size);

  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  if (bridgePoints.isNotEmpty) {
    drawCurve(canvas, paint, bridgePoints);
  }
}

  void drawCurve(Canvas canvas, Paint paint, List<Offset> points) {
    final path = Path()..moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      path.quadraticBezierTo(
        points[i].dx,
        points[i].dy,
        (points[i].dx + points[i + 1].dx) / 2,
        (points[i].dy + points[i + 1].dy) / 2,
      );
    }

    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
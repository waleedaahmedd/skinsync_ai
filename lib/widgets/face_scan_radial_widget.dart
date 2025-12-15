import 'dart:math';
import 'package:flutter/material.dart';

class FaceScanPainter extends CustomPainter {
  final double progress;

  FaceScanPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    int totalTicks = 60;
    int activeTicks = (progress * totalTicks).round();

    // Define gradient colors
    final List<Color> gradientColors = [
      const Color.fromARGB(255, 1, 242, 255),
      const Color.fromARGB(255, 1, 167, 189),
      
    ];

    for (int i = 0; i < totalTicks; i++) {
      double angle = (i * 6) * pi / 180;
      double inner = radius - 20;
      double outer = radius;

      Offset start = Offset(
        center.dx + inner * cos(angle),
        center.dy + inner * sin(angle),
      );

      Offset end = Offset(
        center.dx + outer * cos(angle),
        center.dy + outer * sin(angle),
      );

      Paint paintToUse = tickPaint;

      // If tick is in progress, use gradient color
      if (i < activeTicks) {
        // Compute gradient index based on tick position
        double t = i / totalTicks; // 0.0 -> 1.0
        paintToUse = Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = _getGradientColor(gradientColors, t);
      }

      canvas.drawLine(start, end, paintToUse);
    }
  }

  // Linear interpolation between gradient colors
  Color _getGradientColor(List<Color> colors, double t) {
    if (t <= 0) return colors.first;
    if (t >= 1) return colors.last;

    double scaledT = t * (colors.length - 1);
    int index = scaledT.floor();
    double lerpT = scaledT - index;

    return Color.lerp(colors[index], colors[index + 1], lerpT)!;
  }

  @override
  bool shouldRepaint(FaceScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

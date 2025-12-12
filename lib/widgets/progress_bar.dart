import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class CustomCircularIndicator extends StatelessWidget {
  final double progress; // 0.0–1.0 (example: 0.72)

  const CustomCircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112.h,
      width: 112.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(112.w, 112.h),
            painter: RingPainter(progress),
          ),

          // Center Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(progress * 100).toInt()}%",
                style: CustomFonts.black28w600
                 
              ),
               Text(
                "Points Earned!",
                style: CustomFonts.black10w600
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;

  RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 10.w;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - strokeWidth;

    // Background ring (white)
    Paint bg = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Progress ring (pink–purple)
    Paint fg = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xffEEA1F0),
          Color(0xffEEA1F0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.1416 / 180,
      360 * 3.1416 / 180,
      false,
      bg,
    );

    // Draw progress ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.1416 / 180,
      360 * progress * 3.1416 / 180,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

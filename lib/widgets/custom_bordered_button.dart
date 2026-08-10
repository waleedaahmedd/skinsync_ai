
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class CustomBorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double borderWidth;

  const CustomBorderedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.backgroundColor,
    this.gradient,
    this.height,
    this.width,
    this.borderRadius,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 40);

    return SizedBox(
      height: height ?? context.h(52),
      width: width ?? double.infinity,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              gradient: gradient ?? CustomColors.purpleBlueGradient,
              borderRadius: radius,
                boxShadow: [
            // Outer glow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
            // Soft white diffuse glow
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: 20,
            ),
          ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(
                  (borderRadius ?? 40) - borderWidth,
                ),
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(
                        text,
                        style: CustomFonts.black18w600
                        // .copyWith(
                        //   color: textColor ?? CustomColors.darkPurple,
                        // ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


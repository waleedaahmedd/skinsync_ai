import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isBorder;
  final double borderWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.textColor = Colors.black,
    this.backgroundColor,
    this.gradient,
    this.height,
    this.width,
    this.borderRadius,
    this.isBorder = false,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final double radiusValue = borderRadius ?? 40;
    final BorderRadius radius = BorderRadius.circular(radiusValue);

    return SizedBox(
      height: height ?? context.h(52),
      width: width ?? double.infinity,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading || isDisabled ? null : onPressed,
          child: Container(
            padding: isBorder ? EdgeInsets.all(borderWidth) : EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: isDisabled ? CustomColors.greyColor : (isBorder ? null : backgroundColor),
              gradient: isDisabled ? null : (backgroundColor != null ? null : (gradient ?? CustomColors.purpleBlueGradient)),
              boxShadow: isDisabled ? null : [
                BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
                BoxShadow(color: Colors.white.withValues(alpha: 0.15), blurRadius: 10),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isBorder ? (backgroundColor ?? Colors.white) : Colors.transparent,
                borderRadius: isBorder ? BorderRadius.circular(radiusValue - borderWidth) : radius,
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(
                        text,
                        style: CustomFonts.black18w600.copyWith(
                          fontSize: context.sp(16),
                          color: isDisabled ? Colors.black.withValues(alpha: 0.45) : textColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

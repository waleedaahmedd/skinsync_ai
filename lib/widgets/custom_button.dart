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
    final radius = BorderRadius.circular(borderRadius ?? 40);

    return SizedBox(
      height: height ?? context.h(52),
      width: width ?? double.infinity,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading || isDisabled ? null : onPressed,
          child: isBorder
              ? _buildBorderedButton(context, isDisabled, radius)
              : _buildSolidButton(context, isDisabled, radius),
        ),
      ),
    );
  }

  Widget _buildSolidButton(
    BuildContext context,
    bool isDisabled,
    BorderRadius radius,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? CustomColors.greyColor : backgroundColor,
        gradient:
            isDisabled
                ? null
                : (backgroundColor != null
                    ? null
                    : (gradient ?? CustomColors.purpleBlueGradient)),
        borderRadius: radius,
        boxShadow:
            isDisabled
                ? null
                : [
                  // Outer glow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 1.r,
                  ),
                  // Soft white diffuse glow
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 1.r,
                  ),
                ],
      ),
      child: Center(
        child:
            isLoading
                ? const CircularProgressIndicator.adaptive()
                : Text(
                  text,
                  style: CustomFonts.black18w600.copyWith(
                    color:
                        isDisabled
                            ? Colors.black.withValues(alpha: 0.45)
                            : textColor,
                    fontSize: context.sp(16),
                  ),
                ),
      ),
    );
  }

  Widget _buildBorderedButton(
    BuildContext context,
    bool isDisabled,
    BorderRadius radius,
  ) {
    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        gradient:
            isDisabled ? null : (gradient ?? CustomColors.purpleBlueGradient),
        color: isDisabled ? CustomColors.greyColor : null,
        borderRadius: radius,
        boxShadow:
            isDisabled
                ? null
                : [
                  // Outer glow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 1.r,
                  ),
                  // Soft white diffuse glow
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 40,
                    spreadRadius: 2.r,
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
          child:
              isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                    text,
                    style: CustomFonts.black18w600.copyWith(
                      color:
                          isDisabled
                              ? Colors.black.withValues(alpha: 0.45)
                              : textColor,
                      fontSize: context.sp(16),
                    ),
                  ),
        ),
      ),
    );
  }
}

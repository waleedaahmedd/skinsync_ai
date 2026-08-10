import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      height: height ?? context.h(52),
      width: width ?? double.infinity,
      child: Material(
        type: .transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 40),
          onTap: isLoading ? null : onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: isDisabled ? CustomColors.greyColor : backgroundColor,
              gradient: isDisabled
                  ? null
                  : (backgroundColor != null
                        ? null
                        : (gradient ?? CustomColors.purpleBlueGradient)),
              borderRadius: BorderRadius.circular(borderRadius ?? 40),
              boxShadow: isDisabled
                  ? null
                  : [
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
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      text,
                      style: CustomFonts.black18w600.copyWith(
                        color: isDisabled
                            ? Colors.black.withValues(alpha: 0.45)
                            : textColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
      // child: ElevatedButton(
      //   onPressed: isLoading ? null : onPressed,
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: backgroundColor,
      //     foregroundColor: textColor,
      //     elevation: backgroundColor == Colors.transparent ? 0 : 1,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(borderRadius ?? context.r(25)),
      //     ),
      //     padding: EdgeInsets.zero,
      //   ),
      //   child: isLoading
      //       ? CupertinoActivityIndicator(color: textColor)
      //       : Text(
      //           text,
      //           style: CustomFonts.white16w600.copyWith(color: textColor),
      //         ),
      // ),
    );
  }
}

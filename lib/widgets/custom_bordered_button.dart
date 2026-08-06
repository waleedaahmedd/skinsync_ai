import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class CustomBorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color borderColor;
  final Color textColor;
  final double? height;
  final double? width;
  final double? borderRadius;

  const CustomBorderedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.borderColor = CustomColors.darkPurple,
    this.textColor = CustomColors.darkPurple,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.h(50),
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? context.r(25)),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CustomColors.darkPurple,
                  ),
                ),
              )
            : Text(
                text,
                style: CustomFonts.black14w600.copyWith(color: textColor),
              ),
      ),
    );
  }
}

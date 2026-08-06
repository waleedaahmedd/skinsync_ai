import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/custom_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? height;
  final double? width;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? context.h(52),
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: backgroundColor == Colors.transparent ? 0 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? context.r(25)),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? CupertinoActivityIndicator(color: textColor)
            : Text(
                text,
                style: CustomFonts.white16w600.copyWith(color: textColor),
              ),
      ),
    );
  }
}

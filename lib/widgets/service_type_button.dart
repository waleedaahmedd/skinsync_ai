import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class ServiceTypeButton extends StatelessWidget {
  final String? icon;
  final String text;
  final bool selected;
  final VoidCallback? onPressed;

  const ServiceTypeButton({
    super.key,
    this.icon,
    this.text = "",
    this.selected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: selected ? CustomColors.purpleBlueGradient : null,
          color: selected ? null : Colors.white,
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.black, // Clean, bold black border when unselected
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? CustomColors.purpleColor.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.015),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            children: [
              // 1. Translucent Premium Dark Mask Overlay (Tints the background gradient)
              if (selected)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.45), // Translucent dark mask
                  ),
                ),

              // 2. High-Contrast Content Layer (Determines the natural size of the card)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Image.asset(
                        icon!,
                        width: 16.w,
                        height: 16.w,
                        color: selected ? Colors.white : Colors.black, // Pure black icon when unselected
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: selected
                          ? CustomFonts.white12w600
                          : CustomFonts.black13w600, // Bold black font when unselected
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

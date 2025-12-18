import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class ServiceTypeButton extends StatelessWidget {
  final Widget? icon;
  final String text;
  final bool selected;
  final bool frosted; // new: enable frosted glass effect

  const ServiceTypeButton({
    super.key,
    this.icon,
    this.text = "",
    this.selected = false,
    this.frosted = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: selected
            ? CustomColors.blackColor.withOpacity(
                0.5,
              ) // semi-transparent when selected
            : Colors.white.withOpacity(0.2), // transparent background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null) SizedBox(width: 8.w),
          Text(
            text,
            style: selected ? CustomFonts.white17w500 : CustomFonts.black17w500,
          ),
        ],
      ),
    );

    // Wrap with BackdropFilter if frosted glass effect is enabled
    if (frosted) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      );
    }

    return child;
  }
}

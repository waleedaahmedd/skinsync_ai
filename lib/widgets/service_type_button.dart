import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class ServiceTypeButton extends StatelessWidget {
  final String? icon;
  final String text;
  final bool selected;

  //final bool frosted; // new: enable frosted glass effect
  final VoidCallback? onPressed;

  const ServiceTypeButton({
    super.key,
    this.icon,
    this.text = "",
    this.selected = false,
    // this.frosted = false,
    this.onPressed,
  });

  Color get _backgroundColor {
    if (selected) {
      return CustomColors.purpleColor;
    } else {
      return CustomColors.blackColor.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Image.asset(
                icon!,
                width: 21.w,
                color: selected
                    ? CustomColors.whiteColor
                    : CustomColors.blackColor,
              ),
            if (icon != null) SizedBox(width: 8.w),
            Text(
              text,
              style: selected
                  ? CustomFonts.white17w500
                  : CustomFonts.black17w500,
            ),
          ],
        ),
      ),
    );

    // if (frosted) {
    //   child = ClipRRect(
    //     borderRadius: BorderRadius.circular(12.r),
    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //       child: child,
    //     ),
    //   );
    // }

    return child;
  }
}
